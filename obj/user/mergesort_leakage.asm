
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
  800041:	e8 d4 1f 00 00       	call   80201a <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 42 80 00       	push   $0x8042e0
  80004e:	e8 e0 0a 00 00       	call   800b33 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 42 80 00       	push   $0x8042e2
  80005e:	e8 d0 0a 00 00       	call   800b33 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 42 80 00       	push   $0x8042f8
  80006e:	e8 c0 0a 00 00       	call   800b33 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 42 80 00       	push   $0x8042e2
  80007e:	e8 b0 0a 00 00       	call   800b33 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 42 80 00       	push   $0x8042e0
  80008e:	e8 a0 0a 00 00       	call   800b33 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 10 43 80 00       	push   $0x804310
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
  8000de:	68 30 43 80 00       	push   $0x804330
  8000e3:	e8 4b 0a 00 00       	call   800b33 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 52 43 80 00       	push   $0x804352
  8000f3:	e8 3b 0a 00 00       	call   800b33 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 60 43 80 00       	push   $0x804360
  800103:	e8 2b 0a 00 00       	call   800b33 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 6f 43 80 00       	push   $0x80436f
  800113:	e8 1b 0a 00 00       	call   800b33 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 7f 43 80 00       	push   $0x80437f
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
  800162:	e8 cd 1e 00 00       	call   802034 <sys_unlock_cons>
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
  8001d7:	e8 3e 1e 00 00       	call   80201a <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 88 43 80 00       	push   $0x804388
  8001e4:	e8 4a 09 00 00       	call   800b33 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 43 1e 00 00       	call   802034 <sys_unlock_cons>
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
  80020e:	68 bc 43 80 00       	push   $0x8043bc
  800213:	6a 51                	push   $0x51
  800215:	68 de 43 80 00       	push   $0x8043de
  80021a:	e8 57 06 00 00       	call   800876 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 f6 1d 00 00       	call   80201a <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 f8 43 80 00       	push   $0x8043f8
  80022c:	e8 02 09 00 00       	call   800b33 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 2c 44 80 00       	push   $0x80442c
  80023c:	e8 f2 08 00 00       	call   800b33 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 60 44 80 00       	push   $0x804460
  80024c:	e8 e2 08 00 00       	call   800b33 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 db 1d 00 00       	call   802034 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 bc 1d 00 00       	call   80201a <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 92 44 80 00       	push   $0x804492
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
  8002b2:	e8 7d 1d 00 00       	call   802034 <sys_unlock_cons>
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
  800446:	68 e0 42 80 00       	push   $0x8042e0
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
  800468:	68 b0 44 80 00       	push   $0x8044b0
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
  800496:	68 b5 44 80 00       	push   $0x8044b5
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
  80070f:	e8 51 1a 00 00       	call   802165 <sys_cputc>
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
  800720:	e8 dc 18 00 00       	call   802001 <sys_cgetc>
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
  80073d:	e8 54 1b 00 00       	call   802296 <sys_getenvindex>
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
  8007ab:	e8 6a 18 00 00       	call   80201a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 d4 44 80 00       	push   $0x8044d4
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
  8007db:	68 fc 44 80 00       	push   $0x8044fc
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
  80080c:	68 24 45 80 00       	push   $0x804524
  800811:	e8 1d 03 00 00       	call   800b33 <cprintf>
  800816:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800819:	a1 24 50 80 00       	mov    0x805024,%eax
  80081e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	50                   	push   %eax
  800828:	68 7c 45 80 00       	push   $0x80457c
  80082d:	e8 01 03 00 00       	call   800b33 <cprintf>
  800832:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	68 d4 44 80 00       	push   $0x8044d4
  80083d:	e8 f1 02 00 00       	call   800b33 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800845:	e8 ea 17 00 00       	call   802034 <sys_unlock_cons>
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
  80085d:	e8 00 1a 00 00       	call   802262 <sys_destroy_env>
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
  80086e:	e8 55 1a 00 00       	call   8022c8 <sys_exit_env>
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
  800897:	68 90 45 80 00       	push   $0x804590
  80089c:	e8 92 02 00 00       	call   800b33 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008a4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	ff 75 08             	pushl  0x8(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	68 95 45 80 00       	push   $0x804595
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
  8008d4:	68 b1 45 80 00       	push   $0x8045b1
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
  800903:	68 b4 45 80 00       	push   $0x8045b4
  800908:	6a 26                	push   $0x26
  80090a:	68 00 46 80 00       	push   $0x804600
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
  8009d8:	68 0c 46 80 00       	push   $0x80460c
  8009dd:	6a 3a                	push   $0x3a
  8009df:	68 00 46 80 00       	push   $0x804600
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
  800a4b:	68 60 46 80 00       	push   $0x804660
  800a50:	6a 44                	push   $0x44
  800a52:	68 00 46 80 00       	push   $0x804600
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
  800aa5:	e8 2e 15 00 00       	call   801fd8 <sys_cputs>
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
  800b1c:	e8 b7 14 00 00       	call   801fd8 <sys_cputs>
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
  800b66:	e8 af 14 00 00       	call   80201a <sys_lock_cons>
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
  800b86:	e8 a9 14 00 00       	call   802034 <sys_unlock_cons>
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
  800bd0:	e8 9b 34 00 00       	call   804070 <__udivdi3>
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
  800c20:	e8 5b 35 00 00       	call   804180 <__umoddi3>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	05 d4 48 80 00       	add    $0x8048d4,%eax
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
  800d7b:	8b 04 85 f8 48 80 00 	mov    0x8048f8(,%eax,4),%eax
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
  800e5c:	8b 34 9d 40 47 80 00 	mov    0x804740(,%ebx,4),%esi
  800e63:	85 f6                	test   %esi,%esi
  800e65:	75 19                	jne    800e80 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e67:	53                   	push   %ebx
  800e68:	68 e5 48 80 00       	push   $0x8048e5
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
  800e81:	68 ee 48 80 00       	push   $0x8048ee
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
  800eae:	be f1 48 80 00       	mov    $0x8048f1,%esi
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
  8011d9:	68 68 4a 80 00       	push   $0x804a68
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
  80121b:	68 6b 4a 80 00       	push   $0x804a6b
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
  8012cc:	e8 49 0d 00 00       	call   80201a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d5:	74 13                	je     8012ea <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	68 68 4a 80 00       	push   $0x804a68
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
  80131f:	68 6b 4a 80 00       	push   $0x804a6b
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
  8013c7:	e8 68 0c 00 00       	call   802034 <sys_unlock_cons>
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
  801ac1:	68 7c 4a 80 00       	push   $0x804a7c
  801ac6:	68 3f 01 00 00       	push   $0x13f
  801acb:	68 9e 4a 80 00       	push   $0x804a9e
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
  801ae1:	e8 9d 0a 00 00       	call   802583 <sys_sbrk>
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
  801b5c:	e8 a6 08 00 00       	call   802407 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	74 16                	je     801b7b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 e6 0d 00 00       	call   802956 <alloc_block_FF>
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b76:	e9 8a 01 00 00       	jmp    801d05 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b7b:	e8 b8 08 00 00       	call   802438 <sys_isUHeapPlacementStrategyBESTFIT>
  801b80:	85 c0                	test   %eax,%eax
  801b82:	0f 84 7d 01 00 00    	je     801d05 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 7f 12 00 00       	call   802e12 <alloc_block_BF>
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
  801bde:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801c2b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801c82:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801ce4:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801ceb:	83 ec 08             	sub    $0x8,%esp
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf4:	e8 c1 08 00 00       	call   8025ba <sys_allocate_user_mem>
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
  801d3c:	e8 95 08 00 00       	call   8025d6 <get_block_size>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 c8 1a 00 00       	call   80381a <free_block>
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
  801d87:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801dc4:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801de4:	e8 b5 07 00 00       	call   80259e <sys_free_user_mem>
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
  801df2:	68 ac 4a 80 00       	push   $0x804aac
  801df7:	68 84 00 00 00       	push   $0x84
  801dfc:	68 d6 4a 80 00       	push   $0x804ad6
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
  801e18:	75 07                	jne    801e21 <smalloc+0x19>
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	eb 74                	jmp    801e95 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e27:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	39 d0                	cmp    %edx,%eax
  801e36:	73 02                	jae    801e3a <smalloc+0x32>
  801e38:	89 d0                	mov    %edx,%eax
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	50                   	push   %eax
  801e3e:	e8 a8 fc ff ff       	call   801aeb <malloc>
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e4d:	75 07                	jne    801e56 <smalloc+0x4e>
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e54:	eb 3f                	jmp    801e95 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e56:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e5a:	ff 75 ec             	pushl  -0x14(%ebp)
  801e5d:	50                   	push   %eax
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	e8 3c 03 00 00       	call   8021a5 <sys_createSharedObject>
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e6f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e73:	74 06                	je     801e7b <smalloc+0x73>
  801e75:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e79:	75 07                	jne    801e82 <smalloc+0x7a>
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	eb 13                	jmp    801e95 <smalloc+0x8d>
	 cprintf("153\n");
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	68 e2 4a 80 00       	push   $0x804ae2
  801e8a:	e8 a4 ec ff ff       	call   800b33 <cprintf>
  801e8f:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e9d:	83 ec 08             	sub    $0x8,%esp
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	e8 24 03 00 00       	call   8021cf <sys_getSizeOfSharedObject>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801eb1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801eb5:	75 07                	jne    801ebe <sget+0x27>
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	eb 5c                	jmp    801f1a <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ec4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed1:	39 d0                	cmp    %edx,%eax
  801ed3:	7d 02                	jge    801ed7 <sget+0x40>
  801ed5:	89 d0                	mov    %edx,%eax
  801ed7:	83 ec 0c             	sub    $0xc,%esp
  801eda:	50                   	push   %eax
  801edb:	e8 0b fc ff ff       	call   801aeb <malloc>
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ee6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801eea:	75 07                	jne    801ef3 <sget+0x5c>
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	eb 27                	jmp    801f1a <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	ff 75 e8             	pushl  -0x18(%ebp)
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	ff 75 08             	pushl  0x8(%ebp)
  801eff:	e8 e8 02 00 00       	call   8021ec <sys_getSharedObject>
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f0a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f0e:	75 07                	jne    801f17 <sget+0x80>
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
  801f15:	eb 03                	jmp    801f1a <sget+0x83>
	return ptr;
  801f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f22:	83 ec 04             	sub    $0x4,%esp
  801f25:	68 e8 4a 80 00       	push   $0x804ae8
  801f2a:	68 c2 00 00 00       	push   $0xc2
  801f2f:	68 d6 4a 80 00       	push   $0x804ad6
  801f34:	e8 3d e9 ff ff       	call   800876 <_panic>

00801f39 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f3f:	83 ec 04             	sub    $0x4,%esp
  801f42:	68 0c 4b 80 00       	push   $0x804b0c
  801f47:	68 d9 00 00 00       	push   $0xd9
  801f4c:	68 d6 4a 80 00       	push   $0x804ad6
  801f51:	e8 20 e9 ff ff       	call   800876 <_panic>

00801f56 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	68 32 4b 80 00       	push   $0x804b32
  801f64:	68 e5 00 00 00       	push   $0xe5
  801f69:	68 d6 4a 80 00       	push   $0x804ad6
  801f6e:	e8 03 e9 ff ff       	call   800876 <_panic>

00801f73 <shrink>:

}
void shrink(uint32 newSize)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	68 32 4b 80 00       	push   $0x804b32
  801f81:	68 ea 00 00 00       	push   $0xea
  801f86:	68 d6 4a 80 00       	push   $0x804ad6
  801f8b:	e8 e6 e8 ff ff       	call   800876 <_panic>

00801f90 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 32 4b 80 00       	push   $0x804b32
  801f9e:	68 ef 00 00 00       	push   $0xef
  801fa3:	68 d6 4a 80 00       	push   $0x804ad6
  801fa8:	e8 c9 e8 ff ff       	call   800876 <_panic>

00801fad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	57                   	push   %edi
  801fb1:	56                   	push   %esi
  801fb2:	53                   	push   %ebx
  801fb3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fc5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fc8:	cd 30                	int    $0x30
  801fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5f                   	pop    %edi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    

00801fd8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fe4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	52                   	push   %edx
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	50                   	push   %eax
  801ff4:	6a 00                	push   $0x0
  801ff6:	e8 b2 ff ff ff       	call   801fad <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	90                   	nop
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_cgetc>:

int
sys_cgetc(void)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 02                	push   $0x2
  802010:	e8 98 ff ff ff       	call   801fad <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 03                	push   $0x3
  802029:	e8 7f ff ff ff       	call   801fad <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	90                   	nop
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 04                	push   $0x4
  802043:	e8 65 ff ff ff       	call   801fad <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	90                   	nop
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802051:	8b 55 0c             	mov    0xc(%ebp),%edx
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	6a 08                	push   $0x8
  802061:	e8 47 ff ff ff       	call   801fad <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802070:	8b 75 18             	mov    0x18(%ebp),%esi
  802073:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802076:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	56                   	push   %esi
  802080:	53                   	push   %ebx
  802081:	51                   	push   %ecx
  802082:	52                   	push   %edx
  802083:	50                   	push   %eax
  802084:	6a 09                	push   $0x9
  802086:	e8 22 ff ff ff       	call   801fad <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802091:	5b                   	pop    %ebx
  802092:	5e                   	pop    %esi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    

00802095 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	52                   	push   %edx
  8020a5:	50                   	push   %eax
  8020a6:	6a 0a                	push   $0xa
  8020a8:	e8 00 ff ff ff       	call   801fad <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	6a 0b                	push   $0xb
  8020c3:	e8 e5 fe ff ff       	call   801fad <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 0c                	push   $0xc
  8020dc:	e8 cc fe ff ff       	call   801fad <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 0d                	push   $0xd
  8020f5:	e8 b3 fe ff ff       	call   801fad <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 0e                	push   $0xe
  80210e:	e8 9a fe ff ff       	call   801fad <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 0f                	push   $0xf
  802127:	e8 81 fe ff ff       	call   801fad <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	6a 10                	push   $0x10
  802141:	e8 67 fe ff ff       	call   801fad <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 11                	push   $0x11
  80215a:	e8 4e fe ff ff       	call   801fad <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	90                   	nop
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_cputc>:

void
sys_cputc(const char c)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802171:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	50                   	push   %eax
  80217e:	6a 01                	push   $0x1
  802180:	e8 28 fe ff ff       	call   801fad <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
}
  802188:	90                   	nop
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 14                	push   $0x14
  80219a:	e8 0e fe ff ff       	call   801fad <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	90                   	nop
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	51                   	push   %ecx
  8021be:	52                   	push   %edx
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	50                   	push   %eax
  8021c3:	6a 15                	push   $0x15
  8021c5:	e8 e3 fd ff ff       	call   801fad <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	52                   	push   %edx
  8021df:	50                   	push   %eax
  8021e0:	6a 16                	push   $0x16
  8021e2:	e8 c6 fd ff ff       	call   801fad <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	51                   	push   %ecx
  8021fd:	52                   	push   %edx
  8021fe:	50                   	push   %eax
  8021ff:	6a 17                	push   $0x17
  802201:	e8 a7 fd ff ff       	call   801fad <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80220e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	52                   	push   %edx
  80221b:	50                   	push   %eax
  80221c:	6a 18                	push   $0x18
  80221e:	e8 8a fd ff ff       	call   801fad <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	6a 00                	push   $0x0
  802230:	ff 75 14             	pushl  0x14(%ebp)
  802233:	ff 75 10             	pushl  0x10(%ebp)
  802236:	ff 75 0c             	pushl  0xc(%ebp)
  802239:	50                   	push   %eax
  80223a:	6a 19                	push   $0x19
  80223c:	e8 6c fd ff ff       	call   801fad <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	50                   	push   %eax
  802255:	6a 1a                	push   $0x1a
  802257:	e8 51 fd ff ff       	call   801fad <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	90                   	nop
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	50                   	push   %eax
  802271:	6a 1b                	push   $0x1b
  802273:	e8 35 fd ff ff       	call   801fad <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 05                	push   $0x5
  80228c:	e8 1c fd ff ff       	call   801fad <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 06                	push   $0x6
  8022a5:	e8 03 fd ff ff       	call   801fad <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 07                	push   $0x7
  8022be:	e8 ea fc ff ff       	call   801fad <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_exit_env>:


void sys_exit_env(void)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 1c                	push   $0x1c
  8022d7:	e8 d1 fc ff ff       	call   801fad <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	90                   	nop
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022eb:	8d 50 04             	lea    0x4(%eax),%edx
  8022ee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	52                   	push   %edx
  8022f8:	50                   	push   %eax
  8022f9:	6a 1d                	push   $0x1d
  8022fb:	e8 ad fc ff ff       	call   801fad <syscall>
  802300:	83 c4 18             	add    $0x18,%esp
	return result;
  802303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802309:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80230c:	89 01                	mov    %eax,(%ecx)
  80230e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	c9                   	leave  
  802315:	c2 04 00             	ret    $0x4

00802318 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	ff 75 10             	pushl  0x10(%ebp)
  802322:	ff 75 0c             	pushl  0xc(%ebp)
  802325:	ff 75 08             	pushl  0x8(%ebp)
  802328:	6a 13                	push   $0x13
  80232a:	e8 7e fc ff ff       	call   801fad <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
	return ;
  802332:	90                   	nop
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_rcr2>:
uint32 sys_rcr2()
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 1e                	push   $0x1e
  802344:	e8 64 fc ff ff       	call   801fad <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80235a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	50                   	push   %eax
  802367:	6a 1f                	push   $0x1f
  802369:	e8 3f fc ff ff       	call   801fad <syscall>
  80236e:	83 c4 18             	add    $0x18,%esp
	return ;
  802371:	90                   	nop
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <rsttst>:
void rsttst()
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 21                	push   $0x21
  802383:	e8 25 fc ff ff       	call   801fad <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
	return ;
  80238b:	90                   	nop
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	8b 45 14             	mov    0x14(%ebp),%eax
  802397:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80239a:	8b 55 18             	mov    0x18(%ebp),%edx
  80239d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023a1:	52                   	push   %edx
  8023a2:	50                   	push   %eax
  8023a3:	ff 75 10             	pushl  0x10(%ebp)
  8023a6:	ff 75 0c             	pushl  0xc(%ebp)
  8023a9:	ff 75 08             	pushl  0x8(%ebp)
  8023ac:	6a 20                	push   $0x20
  8023ae:	e8 fa fb ff ff       	call   801fad <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b6:	90                   	nop
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <chktst>:
void chktst(uint32 n)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	ff 75 08             	pushl  0x8(%ebp)
  8023c7:	6a 22                	push   $0x22
  8023c9:	e8 df fb ff ff       	call   801fad <syscall>
  8023ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d1:	90                   	nop
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <inctst>:

void inctst()
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 23                	push   $0x23
  8023e3:	e8 c5 fb ff ff       	call   801fad <syscall>
  8023e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023eb:	90                   	nop
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <gettst>:
uint32 gettst()
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 24                	push   $0x24
  8023fd:	e8 ab fb ff ff       	call   801fad <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 25                	push   $0x25
  802419:	e8 8f fb ff ff       	call   801fad <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
  802421:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802424:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802428:	75 07                	jne    802431 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80242a:	b8 01 00 00 00       	mov    $0x1,%eax
  80242f:	eb 05                	jmp    802436 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 25                	push   $0x25
  80244a:	e8 5e fb ff ff       	call   801fad <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
  802452:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802455:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802459:	75 07                	jne    802462 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80245b:	b8 01 00 00 00       	mov    $0x1,%eax
  802460:	eb 05                	jmp    802467 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 25                	push   $0x25
  80247b:	e8 2d fb ff ff       	call   801fad <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
  802483:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802486:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80248a:	75 07                	jne    802493 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80248c:	b8 01 00 00 00       	mov    $0x1,%eax
  802491:	eb 05                	jmp    802498 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 25                	push   $0x25
  8024ac:	e8 fc fa ff ff       	call   801fad <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
  8024b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024b7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024bb:	75 07                	jne    8024c4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	eb 05                	jmp    8024c9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	ff 75 08             	pushl  0x8(%ebp)
  8024d9:	6a 26                	push   $0x26
  8024db:	e8 cd fa ff ff       	call   801fad <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e3:	90                   	nop
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	53                   	push   %ebx
  8024f9:	51                   	push   %ecx
  8024fa:	52                   	push   %edx
  8024fb:	50                   	push   %eax
  8024fc:	6a 27                	push   $0x27
  8024fe:	e8 aa fa ff ff       	call   801fad <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
}
  802506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80250e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	52                   	push   %edx
  80251b:	50                   	push   %eax
  80251c:	6a 28                	push   $0x28
  80251e:	e8 8a fa ff ff       	call   801fad <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80252b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80252e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	6a 00                	push   $0x0
  802536:	51                   	push   %ecx
  802537:	ff 75 10             	pushl  0x10(%ebp)
  80253a:	52                   	push   %edx
  80253b:	50                   	push   %eax
  80253c:	6a 29                	push   $0x29
  80253e:	e8 6a fa ff ff       	call   801fad <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	ff 75 10             	pushl  0x10(%ebp)
  802552:	ff 75 0c             	pushl  0xc(%ebp)
  802555:	ff 75 08             	pushl  0x8(%ebp)
  802558:	6a 12                	push   $0x12
  80255a:	e8 4e fa ff ff       	call   801fad <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
	return ;
  802562:	90                   	nop
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	52                   	push   %edx
  802575:	50                   	push   %eax
  802576:	6a 2a                	push   $0x2a
  802578:	e8 30 fa ff ff       	call   801fad <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
	return;
  802580:	90                   	nop
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	50                   	push   %eax
  802592:	6a 2b                	push   $0x2b
  802594:	e8 14 fa ff ff       	call   801fad <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	ff 75 0c             	pushl  0xc(%ebp)
  8025aa:	ff 75 08             	pushl  0x8(%ebp)
  8025ad:	6a 2c                	push   $0x2c
  8025af:	e8 f9 f9 ff ff       	call   801fad <syscall>
  8025b4:	83 c4 18             	add    $0x18,%esp
	return;
  8025b7:	90                   	nop
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	ff 75 0c             	pushl  0xc(%ebp)
  8025c6:	ff 75 08             	pushl  0x8(%ebp)
  8025c9:	6a 2d                	push   $0x2d
  8025cb:	e8 dd f9 ff ff       	call   801fad <syscall>
  8025d0:	83 c4 18             	add    $0x18,%esp
	return;
  8025d3:	90                   	nop
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	83 e8 04             	sub    $0x4,%eax
  8025e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e8:	8b 00                	mov    (%eax),%eax
  8025ea:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	83 e8 04             	sub    $0x4,%eax
  8025fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	83 e0 01             	and    $0x1,%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	0f 94 c0             	sete   %al
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80261a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261d:	83 f8 02             	cmp    $0x2,%eax
  802620:	74 2b                	je     80264d <alloc_block+0x40>
  802622:	83 f8 02             	cmp    $0x2,%eax
  802625:	7f 07                	jg     80262e <alloc_block+0x21>
  802627:	83 f8 01             	cmp    $0x1,%eax
  80262a:	74 0e                	je     80263a <alloc_block+0x2d>
  80262c:	eb 58                	jmp    802686 <alloc_block+0x79>
  80262e:	83 f8 03             	cmp    $0x3,%eax
  802631:	74 2d                	je     802660 <alloc_block+0x53>
  802633:	83 f8 04             	cmp    $0x4,%eax
  802636:	74 3b                	je     802673 <alloc_block+0x66>
  802638:	eb 4c                	jmp    802686 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	ff 75 08             	pushl  0x8(%ebp)
  802640:	e8 11 03 00 00       	call   802956 <alloc_block_FF>
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264b:	eb 4a                	jmp    802697 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80264d:	83 ec 0c             	sub    $0xc,%esp
  802650:	ff 75 08             	pushl  0x8(%ebp)
  802653:	e8 fa 19 00 00       	call   804052 <alloc_block_NF>
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80265e:	eb 37                	jmp    802697 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802660:	83 ec 0c             	sub    $0xc,%esp
  802663:	ff 75 08             	pushl  0x8(%ebp)
  802666:	e8 a7 07 00 00       	call   802e12 <alloc_block_BF>
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802671:	eb 24                	jmp    802697 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	ff 75 08             	pushl  0x8(%ebp)
  802679:	e8 b7 19 00 00       	call   804035 <alloc_block_WF>
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802684:	eb 11                	jmp    802697 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802686:	83 ec 0c             	sub    $0xc,%esp
  802689:	68 44 4b 80 00       	push   $0x804b44
  80268e:	e8 a0 e4 ff ff       	call   800b33 <cprintf>
  802693:	83 c4 10             	add    $0x10,%esp
		break;
  802696:	90                   	nop
	}
	return va;
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	53                   	push   %ebx
  8026a0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	68 64 4b 80 00       	push   $0x804b64
  8026ab:	e8 83 e4 ff ff       	call   800b33 <cprintf>
  8026b0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026b3:	83 ec 0c             	sub    $0xc,%esp
  8026b6:	68 8f 4b 80 00       	push   $0x804b8f
  8026bb:	e8 73 e4 ff ff       	call   800b33 <cprintf>
  8026c0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c9:	eb 37                	jmp    802702 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d1:	e8 19 ff ff ff       	call   8025ef <is_free_block>
  8026d6:	83 c4 10             	add    $0x10,%esp
  8026d9:	0f be d8             	movsbl %al,%ebx
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e2:	e8 ef fe ff ff       	call   8025d6 <get_block_size>
  8026e7:	83 c4 10             	add    $0x10,%esp
  8026ea:	83 ec 04             	sub    $0x4,%esp
  8026ed:	53                   	push   %ebx
  8026ee:	50                   	push   %eax
  8026ef:	68 a7 4b 80 00       	push   $0x804ba7
  8026f4:	e8 3a e4 ff ff       	call   800b33 <cprintf>
  8026f9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802702:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802706:	74 07                	je     80270f <print_blocks_list+0x73>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	eb 05                	jmp    802714 <print_blocks_list+0x78>
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
  802714:	89 45 10             	mov    %eax,0x10(%ebp)
  802717:	8b 45 10             	mov    0x10(%ebp),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	75 ad                	jne    8026cb <print_blocks_list+0x2f>
  80271e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802722:	75 a7                	jne    8026cb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802724:	83 ec 0c             	sub    $0xc,%esp
  802727:	68 64 4b 80 00       	push   $0x804b64
  80272c:	e8 02 e4 ff ff       	call   800b33 <cprintf>
  802731:	83 c4 10             	add    $0x10,%esp

}
  802734:	90                   	nop
  802735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802740:	8b 45 0c             	mov    0xc(%ebp),%eax
  802743:	83 e0 01             	and    $0x1,%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	74 03                	je     80274d <initialize_dynamic_allocator+0x13>
  80274a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80274d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802751:	0f 84 c7 01 00 00    	je     80291e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802757:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80275e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802761:	8b 55 08             	mov    0x8(%ebp),%edx
  802764:	8b 45 0c             	mov    0xc(%ebp),%eax
  802767:	01 d0                	add    %edx,%eax
  802769:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80276e:	0f 87 ad 01 00 00    	ja     802921 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	0f 89 a5 01 00 00    	jns    802924 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80277f:	8b 55 08             	mov    0x8(%ebp),%edx
  802782:	8b 45 0c             	mov    0xc(%ebp),%eax
  802785:	01 d0                	add    %edx,%eax
  802787:	83 e8 04             	sub    $0x4,%eax
  80278a:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80278f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802796:	a1 30 50 80 00       	mov    0x805030,%eax
  80279b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279e:	e9 87 00 00 00       	jmp    80282a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a7:	75 14                	jne    8027bd <initialize_dynamic_allocator+0x83>
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 bf 4b 80 00       	push   $0x804bbf
  8027b1:	6a 79                	push   $0x79
  8027b3:	68 dd 4b 80 00       	push   $0x804bdd
  8027b8:	e8 b9 e0 ff ff       	call   800876 <_panic>
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 10                	je     8027d6 <initialize_dynamic_allocator+0x9c>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ce:	8b 52 04             	mov    0x4(%edx),%edx
  8027d1:	89 50 04             	mov    %edx,0x4(%eax)
  8027d4:	eb 0b                	jmp    8027e1 <initialize_dynamic_allocator+0xa7>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	a3 34 50 80 00       	mov    %eax,0x805034
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 04             	mov    0x4(%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 0f                	je     8027fa <initialize_dynamic_allocator+0xc0>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f4:	8b 12                	mov    (%edx),%edx
  8027f6:	89 10                	mov    %edx,(%eax)
  8027f8:	eb 0a                	jmp    802804 <initialize_dynamic_allocator+0xca>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 00                	mov    (%eax),%eax
  8027ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802817:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80281c:	48                   	dec    %eax
  80281d:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802822:	a1 38 50 80 00       	mov    0x805038,%eax
  802827:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	74 07                	je     802837 <initialize_dynamic_allocator+0xfd>
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	eb 05                	jmp    80283c <initialize_dynamic_allocator+0x102>
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
  80283c:	a3 38 50 80 00       	mov    %eax,0x805038
  802841:	a1 38 50 80 00       	mov    0x805038,%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	0f 85 55 ff ff ff    	jne    8027a3 <initialize_dynamic_allocator+0x69>
  80284e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802852:	0f 85 4b ff ff ff    	jne    8027a3 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802858:	8b 45 08             	mov    0x8(%ebp),%eax
  80285b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802867:	a1 48 50 80 00       	mov    0x805048,%eax
  80286c:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802871:	a1 44 50 80 00       	mov    0x805044,%eax
  802876:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	83 c0 08             	add    $0x8,%eax
  802882:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	83 c0 04             	add    $0x4,%eax
  80288b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288e:	83 ea 08             	sub    $0x8,%edx
  802891:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802893:	8b 55 0c             	mov    0xc(%ebp),%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	83 e8 08             	sub    $0x8,%eax
  80289e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a1:	83 ea 08             	sub    $0x8,%edx
  8028a4:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8028af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028bd:	75 17                	jne    8028d6 <initialize_dynamic_allocator+0x19c>
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 f8 4b 80 00       	push   $0x804bf8
  8028c7:	68 90 00 00 00       	push   $0x90
  8028cc:	68 dd 4b 80 00       	push   $0x804bdd
  8028d1:	e8 a0 df ff ff       	call   800876 <_panic>
  8028d6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	89 10                	mov    %edx,(%eax)
  8028e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 0d                	je     8028f7 <initialize_dynamic_allocator+0x1bd>
  8028ea:	a1 30 50 80 00       	mov    0x805030,%eax
  8028ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f2:	89 50 04             	mov    %edx,0x4(%eax)
  8028f5:	eb 08                	jmp    8028ff <initialize_dynamic_allocator+0x1c5>
  8028f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	a3 30 50 80 00       	mov    %eax,0x805030
  802907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802911:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802916:	40                   	inc    %eax
  802917:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80291c:	eb 07                	jmp    802925 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80291e:	90                   	nop
  80291f:	eb 04                	jmp    802925 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802921:	90                   	nop
  802922:	eb 01                	jmp    802925 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802924:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80292a:	8b 45 10             	mov    0x10(%ebp),%eax
  80292d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	8d 50 fc             	lea    -0x4(%eax),%edx
  802936:	8b 45 0c             	mov    0xc(%ebp),%eax
  802939:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	83 e8 04             	sub    $0x4,%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	83 e0 fe             	and    $0xfffffffe,%eax
  802946:	8d 50 f8             	lea    -0x8(%eax),%edx
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	01 c2                	add    %eax,%edx
  80294e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802951:	89 02                	mov    %eax,(%edx)
}
  802953:	90                   	nop
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    

00802956 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	83 e0 01             	and    $0x1,%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 03                	je     802969 <alloc_block_FF+0x13>
  802966:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802969:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80296d:	77 07                	ja     802976 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80296f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802976:	a1 28 50 80 00       	mov    0x805028,%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	75 73                	jne    8029f2 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	83 c0 10             	add    $0x10,%eax
  802985:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802988:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80298f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802995:	01 d0                	add    %edx,%eax
  802997:	48                   	dec    %eax
  802998:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80299b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299e:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a3:	f7 75 ec             	divl   -0x14(%ebp)
  8029a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a9:	29 d0                	sub    %edx,%eax
  8029ab:	c1 e8 0c             	shr    $0xc,%eax
  8029ae:	83 ec 0c             	sub    $0xc,%esp
  8029b1:	50                   	push   %eax
  8029b2:	e8 1e f1 ff ff       	call   801ad5 <sbrk>
  8029b7:	83 c4 10             	add    $0x10,%esp
  8029ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029bd:	83 ec 0c             	sub    $0xc,%esp
  8029c0:	6a 00                	push   $0x0
  8029c2:	e8 0e f1 ff ff       	call   801ad5 <sbrk>
  8029c7:	83 c4 10             	add    $0x10,%esp
  8029ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029d3:	83 ec 08             	sub    $0x8,%esp
  8029d6:	50                   	push   %eax
  8029d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029da:	e8 5b fd ff ff       	call   80273a <initialize_dynamic_allocator>
  8029df:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029e2:	83 ec 0c             	sub    $0xc,%esp
  8029e5:	68 1b 4c 80 00       	push   $0x804c1b
  8029ea:	e8 44 e1 ff ff       	call   800b33 <cprintf>
  8029ef:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f6:	75 0a                	jne    802a02 <alloc_block_FF+0xac>
	        return NULL;
  8029f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fd:	e9 0e 04 00 00       	jmp    802e10 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a09:	a1 30 50 80 00       	mov    0x805030,%eax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a11:	e9 f3 02 00 00       	jmp    802d09 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a1c:	83 ec 0c             	sub    $0xc,%esp
  802a1f:	ff 75 bc             	pushl  -0x44(%ebp)
  802a22:	e8 af fb ff ff       	call   8025d6 <get_block_size>
  802a27:	83 c4 10             	add    $0x10,%esp
  802a2a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	83 c0 08             	add    $0x8,%eax
  802a33:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a36:	0f 87 c5 02 00 00    	ja     802d01 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	83 c0 18             	add    $0x18,%eax
  802a42:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a45:	0f 87 19 02 00 00    	ja     802c64 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a4e:	2b 45 08             	sub    0x8(%ebp),%eax
  802a51:	83 e8 08             	sub    $0x8,%eax
  802a54:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	8d 50 08             	lea    0x8(%eax),%edx
  802a5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a60:	01 d0                	add    %edx,%eax
  802a62:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	83 c0 08             	add    $0x8,%eax
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	6a 01                	push   $0x1
  802a70:	50                   	push   %eax
  802a71:	ff 75 bc             	pushl  -0x44(%ebp)
  802a74:	e8 ae fe ff ff       	call   802927 <set_block_data>
  802a79:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 68                	jne    802aee <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a86:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a8a:	75 17                	jne    802aa3 <alloc_block_FF+0x14d>
  802a8c:	83 ec 04             	sub    $0x4,%esp
  802a8f:	68 f8 4b 80 00       	push   $0x804bf8
  802a94:	68 d7 00 00 00       	push   $0xd7
  802a99:	68 dd 4b 80 00       	push   $0x804bdd
  802a9e:	e8 d3 dd ff ff       	call   800876 <_panic>
  802aa3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802aa9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	74 0d                	je     802ac4 <alloc_block_FF+0x16e>
  802ab7:	a1 30 50 80 00       	mov    0x805030,%eax
  802abc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802abf:	89 50 04             	mov    %edx,0x4(%eax)
  802ac2:	eb 08                	jmp    802acc <alloc_block_FF+0x176>
  802ac4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac7:	a3 34 50 80 00       	mov    %eax,0x805034
  802acc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802acf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ade:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ae3:	40                   	inc    %eax
  802ae4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ae9:	e9 dc 00 00 00       	jmp    802bca <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	75 65                	jne    802b5c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802af7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802afb:	75 17                	jne    802b14 <alloc_block_FF+0x1be>
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 2c 4c 80 00       	push   $0x804c2c
  802b05:	68 db 00 00 00       	push   $0xdb
  802b0a:	68 dd 4b 80 00       	push   $0x804bdd
  802b0f:	e8 62 dd ff ff       	call   800876 <_panic>
  802b14:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b1a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 0c                	je     802b36 <alloc_block_FF+0x1e0>
  802b2a:	a1 34 50 80 00       	mov    0x805034,%eax
  802b2f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b32:	89 10                	mov    %edx,(%eax)
  802b34:	eb 08                	jmp    802b3e <alloc_block_FF+0x1e8>
  802b36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b39:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b41:	a3 34 50 80 00       	mov    %eax,0x805034
  802b46:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b54:	40                   	inc    %eax
  802b55:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b5a:	eb 6e                	jmp    802bca <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b60:	74 06                	je     802b68 <alloc_block_FF+0x212>
  802b62:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b66:	75 17                	jne    802b7f <alloc_block_FF+0x229>
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	68 50 4c 80 00       	push   $0x804c50
  802b70:	68 df 00 00 00       	push   $0xdf
  802b75:	68 dd 4b 80 00       	push   $0x804bdd
  802b7a:	e8 f7 dc ff ff       	call   800876 <_panic>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 10                	mov    (%eax),%edx
  802b84:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 0b                	je     802b9d <alloc_block_FF+0x247>
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ba3:	89 10                	mov    %edx,(%eax)
  802ba5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bab:	89 50 04             	mov    %edx,0x4(%eax)
  802bae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	75 08                	jne    802bbf <alloc_block_FF+0x269>
  802bb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bba:	a3 34 50 80 00       	mov    %eax,0x805034
  802bbf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bc4:	40                   	inc    %eax
  802bc5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	75 17                	jne    802be7 <alloc_block_FF+0x291>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 bf 4b 80 00       	push   $0x804bbf
  802bd8:	68 e1 00 00 00       	push   $0xe1
  802bdd:	68 dd 4b 80 00       	push   $0x804bdd
  802be2:	e8 8f dc ff ff       	call   800876 <_panic>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 10                	je     802c00 <alloc_block_FF+0x2aa>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf8:	8b 52 04             	mov    0x4(%edx),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	eb 0b                	jmp    802c0b <alloc_block_FF+0x2b5>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	a3 34 50 80 00       	mov    %eax,0x805034
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	85 c0                	test   %eax,%eax
  802c13:	74 0f                	je     802c24 <alloc_block_FF+0x2ce>
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 40 04             	mov    0x4(%eax),%eax
  802c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1e:	8b 12                	mov    (%edx),%edx
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	eb 0a                	jmp    802c2e <alloc_block_FF+0x2d8>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	a3 30 50 80 00       	mov    %eax,0x805030
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c41:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c46:	48                   	dec    %eax
  802c47:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	6a 00                	push   $0x0
  802c51:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c54:	ff 75 b0             	pushl  -0x50(%ebp)
  802c57:	e8 cb fc ff ff       	call   802927 <set_block_data>
  802c5c:	83 c4 10             	add    $0x10,%esp
  802c5f:	e9 95 00 00 00       	jmp    802cf9 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	6a 01                	push   $0x1
  802c69:	ff 75 b8             	pushl  -0x48(%ebp)
  802c6c:	ff 75 bc             	pushl  -0x44(%ebp)
  802c6f:	e8 b3 fc ff ff       	call   802927 <set_block_data>
  802c74:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7b:	75 17                	jne    802c94 <alloc_block_FF+0x33e>
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 bf 4b 80 00       	push   $0x804bbf
  802c85:	68 e8 00 00 00       	push   $0xe8
  802c8a:	68 dd 4b 80 00       	push   $0x804bdd
  802c8f:	e8 e2 db ff ff       	call   800876 <_panic>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 10                	je     802cad <alloc_block_FF+0x357>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca5:	8b 52 04             	mov    0x4(%edx),%edx
  802ca8:	89 50 04             	mov    %edx,0x4(%eax)
  802cab:	eb 0b                	jmp    802cb8 <alloc_block_FF+0x362>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	a3 34 50 80 00       	mov    %eax,0x805034
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 04             	mov    0x4(%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 0f                	je     802cd1 <alloc_block_FF+0x37b>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccb:	8b 12                	mov    (%edx),%edx
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	eb 0a                	jmp    802cdb <alloc_block_FF+0x385>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	a3 30 50 80 00       	mov    %eax,0x805030
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cf3:	48                   	dec    %eax
  802cf4:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802cf9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cfc:	e9 0f 01 00 00       	jmp    802e10 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d01:	a1 38 50 80 00       	mov    0x805038,%eax
  802d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0d:	74 07                	je     802d16 <alloc_block_FF+0x3c0>
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	eb 05                	jmp    802d1b <alloc_block_FF+0x3c5>
  802d16:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1b:	a3 38 50 80 00       	mov    %eax,0x805038
  802d20:	a1 38 50 80 00       	mov    0x805038,%eax
  802d25:	85 c0                	test   %eax,%eax
  802d27:	0f 85 e9 fc ff ff    	jne    802a16 <alloc_block_FF+0xc0>
  802d2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d31:	0f 85 df fc ff ff    	jne    802a16 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	83 c0 08             	add    $0x8,%eax
  802d3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d40:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d47:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d4d:	01 d0                	add    %edx,%eax
  802d4f:	48                   	dec    %eax
  802d50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d56:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5b:	f7 75 d8             	divl   -0x28(%ebp)
  802d5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d61:	29 d0                	sub    %edx,%eax
  802d63:	c1 e8 0c             	shr    $0xc,%eax
  802d66:	83 ec 0c             	sub    $0xc,%esp
  802d69:	50                   	push   %eax
  802d6a:	e8 66 ed ff ff       	call   801ad5 <sbrk>
  802d6f:	83 c4 10             	add    $0x10,%esp
  802d72:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d75:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d79:	75 0a                	jne    802d85 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d80:	e9 8b 00 00 00       	jmp    802e10 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d85:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d92:	01 d0                	add    %edx,%eax
  802d94:	48                   	dec    %eax
  802d95:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802da0:	f7 75 cc             	divl   -0x34(%ebp)
  802da3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802da6:	29 d0                	sub    %edx,%eax
  802da8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dae:	01 d0                	add    %edx,%eax
  802db0:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802db5:	a1 44 50 80 00       	mov    0x805044,%eax
  802dba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802dc0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	48                   	dec    %eax
  802dd0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  802ddb:	f7 75 c4             	divl   -0x3c(%ebp)
  802dde:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802de1:	29 d0                	sub    %edx,%eax
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	6a 01                	push   $0x1
  802de8:	50                   	push   %eax
  802de9:	ff 75 d0             	pushl  -0x30(%ebp)
  802dec:	e8 36 fb ff ff       	call   802927 <set_block_data>
  802df1:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802df4:	83 ec 0c             	sub    $0xc,%esp
  802df7:	ff 75 d0             	pushl  -0x30(%ebp)
  802dfa:	e8 1b 0a 00 00       	call   80381a <free_block>
  802dff:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e02:	83 ec 0c             	sub    $0xc,%esp
  802e05:	ff 75 08             	pushl  0x8(%ebp)
  802e08:	e8 49 fb ff ff       	call   802956 <alloc_block_FF>
  802e0d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e10:	c9                   	leave  
  802e11:	c3                   	ret    

00802e12 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e12:	55                   	push   %ebp
  802e13:	89 e5                	mov    %esp,%ebp
  802e15:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	83 e0 01             	and    $0x1,%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 03                	je     802e25 <alloc_block_BF+0x13>
  802e22:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e25:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e29:	77 07                	ja     802e32 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e2b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e32:	a1 28 50 80 00       	mov    0x805028,%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	75 73                	jne    802eae <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	83 c0 10             	add    $0x10,%eax
  802e41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e44:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e51:	01 d0                	add    %edx,%eax
  802e53:	48                   	dec    %eax
  802e54:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e5f:	f7 75 e0             	divl   -0x20(%ebp)
  802e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e65:	29 d0                	sub    %edx,%eax
  802e67:	c1 e8 0c             	shr    $0xc,%eax
  802e6a:	83 ec 0c             	sub    $0xc,%esp
  802e6d:	50                   	push   %eax
  802e6e:	e8 62 ec ff ff       	call   801ad5 <sbrk>
  802e73:	83 c4 10             	add    $0x10,%esp
  802e76:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e79:	83 ec 0c             	sub    $0xc,%esp
  802e7c:	6a 00                	push   $0x0
  802e7e:	e8 52 ec ff ff       	call   801ad5 <sbrk>
  802e83:	83 c4 10             	add    $0x10,%esp
  802e86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e8c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e8f:	83 ec 08             	sub    $0x8,%esp
  802e92:	50                   	push   %eax
  802e93:	ff 75 d8             	pushl  -0x28(%ebp)
  802e96:	e8 9f f8 ff ff       	call   80273a <initialize_dynamic_allocator>
  802e9b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e9e:	83 ec 0c             	sub    $0xc,%esp
  802ea1:	68 1b 4c 80 00       	push   $0x804c1b
  802ea6:	e8 88 dc ff ff       	call   800b33 <cprintf>
  802eab:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802eb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ebc:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ec3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802eca:	a1 30 50 80 00       	mov    0x805030,%eax
  802ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed2:	e9 1d 01 00 00       	jmp    802ff4 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802edd:	83 ec 0c             	sub    $0xc,%esp
  802ee0:	ff 75 a8             	pushl  -0x58(%ebp)
  802ee3:	e8 ee f6 ff ff       	call   8025d6 <get_block_size>
  802ee8:	83 c4 10             	add    $0x10,%esp
  802eeb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	83 c0 08             	add    $0x8,%eax
  802ef4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ef7:	0f 87 ef 00 00 00    	ja     802fec <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	83 c0 18             	add    $0x18,%eax
  802f03:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f06:	77 1d                	ja     802f25 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f0e:	0f 86 d8 00 00 00    	jbe    802fec <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f14:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f1a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f20:	e9 c7 00 00 00       	jmp    802fec <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	83 c0 08             	add    $0x8,%eax
  802f2b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f2e:	0f 85 9d 00 00 00    	jne    802fd1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	6a 01                	push   $0x1
  802f39:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f3c:	ff 75 a8             	pushl  -0x58(%ebp)
  802f3f:	e8 e3 f9 ff ff       	call   802927 <set_block_data>
  802f44:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4b:	75 17                	jne    802f64 <alloc_block_BF+0x152>
  802f4d:	83 ec 04             	sub    $0x4,%esp
  802f50:	68 bf 4b 80 00       	push   $0x804bbf
  802f55:	68 2c 01 00 00       	push   $0x12c
  802f5a:	68 dd 4b 80 00       	push   $0x804bdd
  802f5f:	e8 12 d9 ff ff       	call   800876 <_panic>
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 10                	je     802f7d <alloc_block_BF+0x16b>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f75:	8b 52 04             	mov    0x4(%edx),%edx
  802f78:	89 50 04             	mov    %edx,0x4(%eax)
  802f7b:	eb 0b                	jmp    802f88 <alloc_block_BF+0x176>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	a3 34 50 80 00       	mov    %eax,0x805034
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 04             	mov    0x4(%eax),%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	74 0f                	je     802fa1 <alloc_block_BF+0x18f>
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9b:	8b 12                	mov    (%edx),%edx
  802f9d:	89 10                	mov    %edx,(%eax)
  802f9f:	eb 0a                	jmp    802fab <alloc_block_BF+0x199>
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	a3 30 50 80 00       	mov    %eax,0x805030
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbe:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fc3:	48                   	dec    %eax
  802fc4:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802fc9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fcc:	e9 24 04 00 00       	jmp    8033f5 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fd7:	76 13                	jbe    802fec <alloc_block_BF+0x1da>
					{
						internal = 1;
  802fd9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802fe0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fe6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fe9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802fec:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff8:	74 07                	je     803001 <alloc_block_BF+0x1ef>
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	eb 05                	jmp    803006 <alloc_block_BF+0x1f4>
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
  803006:	a3 38 50 80 00       	mov    %eax,0x805038
  80300b:	a1 38 50 80 00       	mov    0x805038,%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	0f 85 bf fe ff ff    	jne    802ed7 <alloc_block_BF+0xc5>
  803018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301c:	0f 85 b5 fe ff ff    	jne    802ed7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803022:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803026:	0f 84 26 02 00 00    	je     803252 <alloc_block_BF+0x440>
  80302c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803030:	0f 85 1c 02 00 00    	jne    803252 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803036:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803039:	2b 45 08             	sub    0x8(%ebp),%eax
  80303c:	83 e8 08             	sub    $0x8,%eax
  80303f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	8d 50 08             	lea    0x8(%eax),%edx
  803048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304b:	01 d0                	add    %edx,%eax
  80304d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	83 c0 08             	add    $0x8,%eax
  803056:	83 ec 04             	sub    $0x4,%esp
  803059:	6a 01                	push   $0x1
  80305b:	50                   	push   %eax
  80305c:	ff 75 f0             	pushl  -0x10(%ebp)
  80305f:	e8 c3 f8 ff ff       	call   802927 <set_block_data>
  803064:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	75 68                	jne    8030d9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803071:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803075:	75 17                	jne    80308e <alloc_block_BF+0x27c>
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 f8 4b 80 00       	push   $0x804bf8
  80307f:	68 45 01 00 00       	push   $0x145
  803084:	68 dd 4b 80 00       	push   $0x804bdd
  803089:	e8 e8 d7 ff ff       	call   800876 <_panic>
  80308e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803094:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803097:	89 10                	mov    %edx,(%eax)
  803099:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0d                	je     8030af <alloc_block_BF+0x29d>
  8030a2:	a1 30 50 80 00       	mov    0x805030,%eax
  8030a7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	eb 08                	jmp    8030b7 <alloc_block_BF+0x2a5>
  8030af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8030b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8030bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030ce:	40                   	inc    %eax
  8030cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030d4:	e9 dc 00 00 00       	jmp    8031b5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	75 65                	jne    803147 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030e6:	75 17                	jne    8030ff <alloc_block_BF+0x2ed>
  8030e8:	83 ec 04             	sub    $0x4,%esp
  8030eb:	68 2c 4c 80 00       	push   $0x804c2c
  8030f0:	68 4a 01 00 00       	push   $0x14a
  8030f5:	68 dd 4b 80 00       	push   $0x804bdd
  8030fa:	e8 77 d7 ff ff       	call   800876 <_panic>
  8030ff:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803105:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	74 0c                	je     803121 <alloc_block_BF+0x30f>
  803115:	a1 34 50 80 00       	mov    0x805034,%eax
  80311a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80311d:	89 10                	mov    %edx,(%eax)
  80311f:	eb 08                	jmp    803129 <alloc_block_BF+0x317>
  803121:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803124:	a3 30 50 80 00       	mov    %eax,0x805030
  803129:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80312c:	a3 34 50 80 00       	mov    %eax,0x805034
  803131:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80313f:	40                   	inc    %eax
  803140:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803145:	eb 6e                	jmp    8031b5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803147:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80314b:	74 06                	je     803153 <alloc_block_BF+0x341>
  80314d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803151:	75 17                	jne    80316a <alloc_block_BF+0x358>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 50 4c 80 00       	push   $0x804c50
  80315b:	68 4f 01 00 00       	push   $0x14f
  803160:	68 dd 4b 80 00       	push   $0x804bdd
  803165:	e8 0c d7 ff ff       	call   800876 <_panic>
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 10                	mov    (%eax),%edx
  80316f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803172:	89 10                	mov    %edx,(%eax)
  803174:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	85 c0                	test   %eax,%eax
  80317b:	74 0b                	je     803188 <alloc_block_BF+0x376>
  80317d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803185:	89 50 04             	mov    %edx,0x4(%eax)
  803188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803193:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803196:	89 50 04             	mov    %edx,0x4(%eax)
  803199:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	75 08                	jne    8031aa <alloc_block_BF+0x398>
  8031a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8031aa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031af:	40                   	inc    %eax
  8031b0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b9:	75 17                	jne    8031d2 <alloc_block_BF+0x3c0>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 bf 4b 80 00       	push   $0x804bbf
  8031c3:	68 51 01 00 00       	push   $0x151
  8031c8:	68 dd 4b 80 00       	push   $0x804bdd
  8031cd:	e8 a4 d6 ff ff       	call   800876 <_panic>
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	74 10                	je     8031eb <alloc_block_BF+0x3d9>
  8031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e3:	8b 52 04             	mov    0x4(%edx),%edx
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	eb 0b                	jmp    8031f6 <alloc_block_BF+0x3e4>
  8031eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	a3 34 50 80 00       	mov    %eax,0x805034
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 0f                	je     80320f <alloc_block_BF+0x3fd>
  803200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803203:	8b 40 04             	mov    0x4(%eax),%eax
  803206:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803209:	8b 12                	mov    (%edx),%edx
  80320b:	89 10                	mov    %edx,(%eax)
  80320d:	eb 0a                	jmp    803219 <alloc_block_BF+0x407>
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	a3 30 50 80 00       	mov    %eax,0x805030
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803231:	48                   	dec    %eax
  803232:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	6a 00                	push   $0x0
  80323c:	ff 75 d0             	pushl  -0x30(%ebp)
  80323f:	ff 75 cc             	pushl  -0x34(%ebp)
  803242:	e8 e0 f6 ff ff       	call   802927 <set_block_data>
  803247:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	e9 a3 01 00 00       	jmp    8033f5 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803252:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803256:	0f 85 9d 00 00 00    	jne    8032f9 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80325c:	83 ec 04             	sub    $0x4,%esp
  80325f:	6a 01                	push   $0x1
  803261:	ff 75 ec             	pushl  -0x14(%ebp)
  803264:	ff 75 f0             	pushl  -0x10(%ebp)
  803267:	e8 bb f6 ff ff       	call   802927 <set_block_data>
  80326c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80326f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803273:	75 17                	jne    80328c <alloc_block_BF+0x47a>
  803275:	83 ec 04             	sub    $0x4,%esp
  803278:	68 bf 4b 80 00       	push   $0x804bbf
  80327d:	68 58 01 00 00       	push   $0x158
  803282:	68 dd 4b 80 00       	push   $0x804bdd
  803287:	e8 ea d5 ff ff       	call   800876 <_panic>
  80328c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	85 c0                	test   %eax,%eax
  803293:	74 10                	je     8032a5 <alloc_block_BF+0x493>
  803295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80329d:	8b 52 04             	mov    0x4(%edx),%edx
  8032a0:	89 50 04             	mov    %edx,0x4(%eax)
  8032a3:	eb 0b                	jmp    8032b0 <alloc_block_BF+0x49e>
  8032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	a3 34 50 80 00       	mov    %eax,0x805034
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 40 04             	mov    0x4(%eax),%eax
  8032b6:	85 c0                	test   %eax,%eax
  8032b8:	74 0f                	je     8032c9 <alloc_block_BF+0x4b7>
  8032ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c3:	8b 12                	mov    (%edx),%edx
  8032c5:	89 10                	mov    %edx,(%eax)
  8032c7:	eb 0a                	jmp    8032d3 <alloc_block_BF+0x4c1>
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032eb:	48                   	dec    %eax
  8032ec:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8032f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f4:	e9 fc 00 00 00       	jmp    8033f5 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	83 c0 08             	add    $0x8,%eax
  8032ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803302:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803309:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80330c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80330f:	01 d0                	add    %edx,%eax
  803311:	48                   	dec    %eax
  803312:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803315:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803318:	ba 00 00 00 00       	mov    $0x0,%edx
  80331d:	f7 75 c4             	divl   -0x3c(%ebp)
  803320:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803323:	29 d0                	sub    %edx,%eax
  803325:	c1 e8 0c             	shr    $0xc,%eax
  803328:	83 ec 0c             	sub    $0xc,%esp
  80332b:	50                   	push   %eax
  80332c:	e8 a4 e7 ff ff       	call   801ad5 <sbrk>
  803331:	83 c4 10             	add    $0x10,%esp
  803334:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803337:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80333b:	75 0a                	jne    803347 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80333d:	b8 00 00 00 00       	mov    $0x0,%eax
  803342:	e9 ae 00 00 00       	jmp    8033f5 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803347:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80334e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803351:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803354:	01 d0                	add    %edx,%eax
  803356:	48                   	dec    %eax
  803357:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80335a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80335d:	ba 00 00 00 00       	mov    $0x0,%edx
  803362:	f7 75 b8             	divl   -0x48(%ebp)
  803365:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803368:	29 d0                	sub    %edx,%eax
  80336a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80336d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803370:	01 d0                	add    %edx,%eax
  803372:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803377:	a1 44 50 80 00       	mov    0x805044,%eax
  80337c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803382:	83 ec 0c             	sub    $0xc,%esp
  803385:	68 84 4c 80 00       	push   $0x804c84
  80338a:	e8 a4 d7 ff ff       	call   800b33 <cprintf>
  80338f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803392:	83 ec 08             	sub    $0x8,%esp
  803395:	ff 75 bc             	pushl  -0x44(%ebp)
  803398:	68 89 4c 80 00       	push   $0x804c89
  80339d:	e8 91 d7 ff ff       	call   800b33 <cprintf>
  8033a2:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033a5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8033ac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033b2:	01 d0                	add    %edx,%eax
  8033b4:	48                   	dec    %eax
  8033b5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033b8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c0:	f7 75 b0             	divl   -0x50(%ebp)
  8033c3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033c6:	29 d0                	sub    %edx,%eax
  8033c8:	83 ec 04             	sub    $0x4,%esp
  8033cb:	6a 01                	push   $0x1
  8033cd:	50                   	push   %eax
  8033ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8033d1:	e8 51 f5 ff ff       	call   802927 <set_block_data>
  8033d6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8033d9:	83 ec 0c             	sub    $0xc,%esp
  8033dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8033df:	e8 36 04 00 00       	call   80381a <free_block>
  8033e4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 08             	pushl  0x8(%ebp)
  8033ed:	e8 20 fa ff ff       	call   802e12 <alloc_block_BF>
  8033f2:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8033f5:	c9                   	leave  
  8033f6:	c3                   	ret    

008033f7 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8033f7:	55                   	push   %ebp
  8033f8:	89 e5                	mov    %esp,%ebp
  8033fa:	53                   	push   %ebx
  8033fb:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803405:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80340c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803410:	74 1e                	je     803430 <merging+0x39>
  803412:	ff 75 08             	pushl  0x8(%ebp)
  803415:	e8 bc f1 ff ff       	call   8025d6 <get_block_size>
  80341a:	83 c4 04             	add    $0x4,%esp
  80341d:	89 c2                	mov    %eax,%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	01 d0                	add    %edx,%eax
  803424:	3b 45 10             	cmp    0x10(%ebp),%eax
  803427:	75 07                	jne    803430 <merging+0x39>
		prev_is_free = 1;
  803429:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803430:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803434:	74 1e                	je     803454 <merging+0x5d>
  803436:	ff 75 10             	pushl  0x10(%ebp)
  803439:	e8 98 f1 ff ff       	call   8025d6 <get_block_size>
  80343e:	83 c4 04             	add    $0x4,%esp
  803441:	89 c2                	mov    %eax,%edx
  803443:	8b 45 10             	mov    0x10(%ebp),%eax
  803446:	01 d0                	add    %edx,%eax
  803448:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80344b:	75 07                	jne    803454 <merging+0x5d>
		next_is_free = 1;
  80344d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803458:	0f 84 cc 00 00 00    	je     80352a <merging+0x133>
  80345e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803462:	0f 84 c2 00 00 00    	je     80352a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803468:	ff 75 08             	pushl  0x8(%ebp)
  80346b:	e8 66 f1 ff ff       	call   8025d6 <get_block_size>
  803470:	83 c4 04             	add    $0x4,%esp
  803473:	89 c3                	mov    %eax,%ebx
  803475:	ff 75 10             	pushl  0x10(%ebp)
  803478:	e8 59 f1 ff ff       	call   8025d6 <get_block_size>
  80347d:	83 c4 04             	add    $0x4,%esp
  803480:	01 c3                	add    %eax,%ebx
  803482:	ff 75 0c             	pushl  0xc(%ebp)
  803485:	e8 4c f1 ff ff       	call   8025d6 <get_block_size>
  80348a:	83 c4 04             	add    $0x4,%esp
  80348d:	01 d8                	add    %ebx,%eax
  80348f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803492:	6a 00                	push   $0x0
  803494:	ff 75 ec             	pushl  -0x14(%ebp)
  803497:	ff 75 08             	pushl  0x8(%ebp)
  80349a:	e8 88 f4 ff ff       	call   802927 <set_block_data>
  80349f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034a6:	75 17                	jne    8034bf <merging+0xc8>
  8034a8:	83 ec 04             	sub    $0x4,%esp
  8034ab:	68 bf 4b 80 00       	push   $0x804bbf
  8034b0:	68 7d 01 00 00       	push   $0x17d
  8034b5:	68 dd 4b 80 00       	push   $0x804bdd
  8034ba:	e8 b7 d3 ff ff       	call   800876 <_panic>
  8034bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c2:	8b 00                	mov    (%eax),%eax
  8034c4:	85 c0                	test   %eax,%eax
  8034c6:	74 10                	je     8034d8 <merging+0xe1>
  8034c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d0:	8b 52 04             	mov    0x4(%edx),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	eb 0b                	jmp    8034e3 <merging+0xec>
  8034d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034db:	8b 40 04             	mov    0x4(%eax),%eax
  8034de:	a3 34 50 80 00       	mov    %eax,0x805034
  8034e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e6:	8b 40 04             	mov    0x4(%eax),%eax
  8034e9:	85 c0                	test   %eax,%eax
  8034eb:	74 0f                	je     8034fc <merging+0x105>
  8034ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f0:	8b 40 04             	mov    0x4(%eax),%eax
  8034f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f6:	8b 12                	mov    (%edx),%edx
  8034f8:	89 10                	mov    %edx,(%eax)
  8034fa:	eb 0a                	jmp    803506 <merging+0x10f>
  8034fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ff:	8b 00                	mov    (%eax),%eax
  803501:	a3 30 50 80 00       	mov    %eax,0x805030
  803506:	8b 45 0c             	mov    0xc(%ebp),%eax
  803509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803519:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80351e:	48                   	dec    %eax
  80351f:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803524:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803525:	e9 ea 02 00 00       	jmp    803814 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80352a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352e:	74 3b                	je     80356b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803530:	83 ec 0c             	sub    $0xc,%esp
  803533:	ff 75 08             	pushl  0x8(%ebp)
  803536:	e8 9b f0 ff ff       	call   8025d6 <get_block_size>
  80353b:	83 c4 10             	add    $0x10,%esp
  80353e:	89 c3                	mov    %eax,%ebx
  803540:	83 ec 0c             	sub    $0xc,%esp
  803543:	ff 75 10             	pushl  0x10(%ebp)
  803546:	e8 8b f0 ff ff       	call   8025d6 <get_block_size>
  80354b:	83 c4 10             	add    $0x10,%esp
  80354e:	01 d8                	add    %ebx,%eax
  803550:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803553:	83 ec 04             	sub    $0x4,%esp
  803556:	6a 00                	push   $0x0
  803558:	ff 75 e8             	pushl  -0x18(%ebp)
  80355b:	ff 75 08             	pushl  0x8(%ebp)
  80355e:	e8 c4 f3 ff ff       	call   802927 <set_block_data>
  803563:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803566:	e9 a9 02 00 00       	jmp    803814 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80356b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80356f:	0f 84 2d 01 00 00    	je     8036a2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	ff 75 10             	pushl  0x10(%ebp)
  80357b:	e8 56 f0 ff ff       	call   8025d6 <get_block_size>
  803580:	83 c4 10             	add    $0x10,%esp
  803583:	89 c3                	mov    %eax,%ebx
  803585:	83 ec 0c             	sub    $0xc,%esp
  803588:	ff 75 0c             	pushl  0xc(%ebp)
  80358b:	e8 46 f0 ff ff       	call   8025d6 <get_block_size>
  803590:	83 c4 10             	add    $0x10,%esp
  803593:	01 d8                	add    %ebx,%eax
  803595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803598:	83 ec 04             	sub    $0x4,%esp
  80359b:	6a 00                	push   $0x0
  80359d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035a0:	ff 75 10             	pushl  0x10(%ebp)
  8035a3:	e8 7f f3 ff ff       	call   802927 <set_block_data>
  8035a8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8035ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8035ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035b5:	74 06                	je     8035bd <merging+0x1c6>
  8035b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035bb:	75 17                	jne    8035d4 <merging+0x1dd>
  8035bd:	83 ec 04             	sub    $0x4,%esp
  8035c0:	68 98 4c 80 00       	push   $0x804c98
  8035c5:	68 8d 01 00 00       	push   $0x18d
  8035ca:	68 dd 4b 80 00       	push   $0x804bdd
  8035cf:	e8 a2 d2 ff ff       	call   800876 <_panic>
  8035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d7:	8b 50 04             	mov    0x4(%eax),%edx
  8035da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035dd:	89 50 04             	mov    %edx,0x4(%eax)
  8035e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e6:	89 10                	mov    %edx,(%eax)
  8035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035eb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ee:	85 c0                	test   %eax,%eax
  8035f0:	74 0d                	je     8035ff <merging+0x208>
  8035f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f5:	8b 40 04             	mov    0x4(%eax),%eax
  8035f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035fb:	89 10                	mov    %edx,(%eax)
  8035fd:	eb 08                	jmp    803607 <merging+0x210>
  8035ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803602:	a3 30 50 80 00       	mov    %eax,0x805030
  803607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80360d:	89 50 04             	mov    %edx,0x4(%eax)
  803610:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803615:	40                   	inc    %eax
  803616:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80361b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80361f:	75 17                	jne    803638 <merging+0x241>
  803621:	83 ec 04             	sub    $0x4,%esp
  803624:	68 bf 4b 80 00       	push   $0x804bbf
  803629:	68 8e 01 00 00       	push   $0x18e
  80362e:	68 dd 4b 80 00       	push   $0x804bdd
  803633:	e8 3e d2 ff ff       	call   800876 <_panic>
  803638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363b:	8b 00                	mov    (%eax),%eax
  80363d:	85 c0                	test   %eax,%eax
  80363f:	74 10                	je     803651 <merging+0x25a>
  803641:	8b 45 0c             	mov    0xc(%ebp),%eax
  803644:	8b 00                	mov    (%eax),%eax
  803646:	8b 55 0c             	mov    0xc(%ebp),%edx
  803649:	8b 52 04             	mov    0x4(%edx),%edx
  80364c:	89 50 04             	mov    %edx,0x4(%eax)
  80364f:	eb 0b                	jmp    80365c <merging+0x265>
  803651:	8b 45 0c             	mov    0xc(%ebp),%eax
  803654:	8b 40 04             	mov    0x4(%eax),%eax
  803657:	a3 34 50 80 00       	mov    %eax,0x805034
  80365c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365f:	8b 40 04             	mov    0x4(%eax),%eax
  803662:	85 c0                	test   %eax,%eax
  803664:	74 0f                	je     803675 <merging+0x27e>
  803666:	8b 45 0c             	mov    0xc(%ebp),%eax
  803669:	8b 40 04             	mov    0x4(%eax),%eax
  80366c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80366f:	8b 12                	mov    (%edx),%edx
  803671:	89 10                	mov    %edx,(%eax)
  803673:	eb 0a                	jmp    80367f <merging+0x288>
  803675:	8b 45 0c             	mov    0xc(%ebp),%eax
  803678:	8b 00                	mov    (%eax),%eax
  80367a:	a3 30 50 80 00       	mov    %eax,0x805030
  80367f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803692:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803697:	48                   	dec    %eax
  803698:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80369d:	e9 72 01 00 00       	jmp    803814 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8036a5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8036a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ac:	74 79                	je     803727 <merging+0x330>
  8036ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036b2:	74 73                	je     803727 <merging+0x330>
  8036b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b8:	74 06                	je     8036c0 <merging+0x2c9>
  8036ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036be:	75 17                	jne    8036d7 <merging+0x2e0>
  8036c0:	83 ec 04             	sub    $0x4,%esp
  8036c3:	68 50 4c 80 00       	push   $0x804c50
  8036c8:	68 94 01 00 00       	push   $0x194
  8036cd:	68 dd 4b 80 00       	push   $0x804bdd
  8036d2:	e8 9f d1 ff ff       	call   800876 <_panic>
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	8b 10                	mov    (%eax),%edx
  8036dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036df:	89 10                	mov    %edx,(%eax)
  8036e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e4:	8b 00                	mov    (%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 0b                	je     8036f5 <merging+0x2fe>
  8036ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036f2:	89 50 04             	mov    %edx,0x4(%eax)
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803700:	8b 55 08             	mov    0x8(%ebp),%edx
  803703:	89 50 04             	mov    %edx,0x4(%eax)
  803706:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	85 c0                	test   %eax,%eax
  80370d:	75 08                	jne    803717 <merging+0x320>
  80370f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803712:	a3 34 50 80 00       	mov    %eax,0x805034
  803717:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80371c:	40                   	inc    %eax
  80371d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803722:	e9 ce 00 00 00       	jmp    8037f5 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803727:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80372b:	74 65                	je     803792 <merging+0x39b>
  80372d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803731:	75 17                	jne    80374a <merging+0x353>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 2c 4c 80 00       	push   $0x804c2c
  80373b:	68 95 01 00 00       	push   $0x195
  803740:	68 dd 4b 80 00       	push   $0x804bdd
  803745:	e8 2c d1 ff ff       	call   800876 <_panic>
  80374a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803750:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803753:	89 50 04             	mov    %edx,0x4(%eax)
  803756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803759:	8b 40 04             	mov    0x4(%eax),%eax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 0c                	je     80376c <merging+0x375>
  803760:	a1 34 50 80 00       	mov    0x805034,%eax
  803765:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	eb 08                	jmp    803774 <merging+0x37d>
  80376c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376f:	a3 30 50 80 00       	mov    %eax,0x805030
  803774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803777:	a3 34 50 80 00       	mov    %eax,0x805034
  80377c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803785:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80378a:	40                   	inc    %eax
  80378b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803790:	eb 63                	jmp    8037f5 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803792:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803796:	75 17                	jne    8037af <merging+0x3b8>
  803798:	83 ec 04             	sub    $0x4,%esp
  80379b:	68 f8 4b 80 00       	push   $0x804bf8
  8037a0:	68 98 01 00 00       	push   $0x198
  8037a5:	68 dd 4b 80 00       	push   $0x804bdd
  8037aa:	e8 c7 d0 ff ff       	call   800876 <_panic>
  8037af:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b8:	89 10                	mov    %edx,(%eax)
  8037ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	74 0d                	je     8037d0 <merging+0x3d9>
  8037c3:	a1 30 50 80 00       	mov    0x805030,%eax
  8037c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037cb:	89 50 04             	mov    %edx,0x4(%eax)
  8037ce:	eb 08                	jmp    8037d8 <merging+0x3e1>
  8037d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8037d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037db:	a3 30 50 80 00       	mov    %eax,0x805030
  8037e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ea:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037ef:	40                   	inc    %eax
  8037f0:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8037f5:	83 ec 0c             	sub    $0xc,%esp
  8037f8:	ff 75 10             	pushl  0x10(%ebp)
  8037fb:	e8 d6 ed ff ff       	call   8025d6 <get_block_size>
  803800:	83 c4 10             	add    $0x10,%esp
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	6a 00                	push   $0x0
  803808:	50                   	push   %eax
  803809:	ff 75 10             	pushl  0x10(%ebp)
  80380c:	e8 16 f1 ff ff       	call   802927 <set_block_data>
  803811:	83 c4 10             	add    $0x10,%esp
	}
}
  803814:	90                   	nop
  803815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803818:	c9                   	leave  
  803819:	c3                   	ret    

0080381a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80381a:	55                   	push   %ebp
  80381b:	89 e5                	mov    %esp,%ebp
  80381d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803820:	a1 30 50 80 00       	mov    0x805030,%eax
  803825:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803828:	a1 34 50 80 00       	mov    0x805034,%eax
  80382d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803830:	73 1b                	jae    80384d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803832:	a1 34 50 80 00       	mov    0x805034,%eax
  803837:	83 ec 04             	sub    $0x4,%esp
  80383a:	ff 75 08             	pushl  0x8(%ebp)
  80383d:	6a 00                	push   $0x0
  80383f:	50                   	push   %eax
  803840:	e8 b2 fb ff ff       	call   8033f7 <merging>
  803845:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803848:	e9 8b 00 00 00       	jmp    8038d8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80384d:	a1 30 50 80 00       	mov    0x805030,%eax
  803852:	3b 45 08             	cmp    0x8(%ebp),%eax
  803855:	76 18                	jbe    80386f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803857:	a1 30 50 80 00       	mov    0x805030,%eax
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	ff 75 08             	pushl  0x8(%ebp)
  803862:	50                   	push   %eax
  803863:	6a 00                	push   $0x0
  803865:	e8 8d fb ff ff       	call   8033f7 <merging>
  80386a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80386d:	eb 69                	jmp    8038d8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80386f:	a1 30 50 80 00       	mov    0x805030,%eax
  803874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803877:	eb 39                	jmp    8038b2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80387f:	73 29                	jae    8038aa <free_block+0x90>
  803881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803884:	8b 00                	mov    (%eax),%eax
  803886:	3b 45 08             	cmp    0x8(%ebp),%eax
  803889:	76 1f                	jbe    8038aa <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803893:	83 ec 04             	sub    $0x4,%esp
  803896:	ff 75 08             	pushl  0x8(%ebp)
  803899:	ff 75 f0             	pushl  -0x10(%ebp)
  80389c:	ff 75 f4             	pushl  -0xc(%ebp)
  80389f:	e8 53 fb ff ff       	call   8033f7 <merging>
  8038a4:	83 c4 10             	add    $0x10,%esp
			break;
  8038a7:	90                   	nop
		}
	}
}
  8038a8:	eb 2e                	jmp    8038d8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8038af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b6:	74 07                	je     8038bf <free_block+0xa5>
  8038b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	eb 05                	jmp    8038c4 <free_block+0xaa>
  8038bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c4:	a3 38 50 80 00       	mov    %eax,0x805038
  8038c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ce:	85 c0                	test   %eax,%eax
  8038d0:	75 a7                	jne    803879 <free_block+0x5f>
  8038d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d6:	75 a1                	jne    803879 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038d8:	90                   	nop
  8038d9:	c9                   	leave  
  8038da:	c3                   	ret    

008038db <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8038db:	55                   	push   %ebp
  8038dc:	89 e5                	mov    %esp,%ebp
  8038de:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038e1:	ff 75 08             	pushl  0x8(%ebp)
  8038e4:	e8 ed ec ff ff       	call   8025d6 <get_block_size>
  8038e9:	83 c4 04             	add    $0x4,%esp
  8038ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8038ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8038f6:	eb 17                	jmp    80390f <copy_data+0x34>
  8038f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fe:	01 c2                	add    %eax,%edx
  803900:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	01 c8                	add    %ecx,%eax
  803908:	8a 00                	mov    (%eax),%al
  80390a:	88 02                	mov    %al,(%edx)
  80390c:	ff 45 fc             	incl   -0x4(%ebp)
  80390f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803912:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803915:	72 e1                	jb     8038f8 <copy_data+0x1d>
}
  803917:	90                   	nop
  803918:	c9                   	leave  
  803919:	c3                   	ret    

0080391a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80391a:	55                   	push   %ebp
  80391b:	89 e5                	mov    %esp,%ebp
  80391d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803920:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803924:	75 23                	jne    803949 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803926:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80392a:	74 13                	je     80393f <realloc_block_FF+0x25>
  80392c:	83 ec 0c             	sub    $0xc,%esp
  80392f:	ff 75 0c             	pushl  0xc(%ebp)
  803932:	e8 1f f0 ff ff       	call   802956 <alloc_block_FF>
  803937:	83 c4 10             	add    $0x10,%esp
  80393a:	e9 f4 06 00 00       	jmp    804033 <realloc_block_FF+0x719>
		return NULL;
  80393f:	b8 00 00 00 00       	mov    $0x0,%eax
  803944:	e9 ea 06 00 00       	jmp    804033 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80394d:	75 18                	jne    803967 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80394f:	83 ec 0c             	sub    $0xc,%esp
  803952:	ff 75 08             	pushl  0x8(%ebp)
  803955:	e8 c0 fe ff ff       	call   80381a <free_block>
  80395a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80395d:	b8 00 00 00 00       	mov    $0x0,%eax
  803962:	e9 cc 06 00 00       	jmp    804033 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803967:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80396b:	77 07                	ja     803974 <realloc_block_FF+0x5a>
  80396d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803974:	8b 45 0c             	mov    0xc(%ebp),%eax
  803977:	83 e0 01             	and    $0x1,%eax
  80397a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80397d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803980:	83 c0 08             	add    $0x8,%eax
  803983:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803986:	83 ec 0c             	sub    $0xc,%esp
  803989:	ff 75 08             	pushl  0x8(%ebp)
  80398c:	e8 45 ec ff ff       	call   8025d6 <get_block_size>
  803991:	83 c4 10             	add    $0x10,%esp
  803994:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399a:	83 e8 08             	sub    $0x8,%eax
  80399d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a3:	83 e8 04             	sub    $0x4,%eax
  8039a6:	8b 00                	mov    (%eax),%eax
  8039a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8039ab:	89 c2                	mov    %eax,%edx
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	01 d0                	add    %edx,%eax
  8039b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039b5:	83 ec 0c             	sub    $0xc,%esp
  8039b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039bb:	e8 16 ec ff ff       	call   8025d6 <get_block_size>
  8039c0:	83 c4 10             	add    $0x10,%esp
  8039c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c9:	83 e8 08             	sub    $0x8,%eax
  8039cc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8039cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039d5:	75 08                	jne    8039df <realloc_block_FF+0xc5>
	{
		 return va;
  8039d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039da:	e9 54 06 00 00       	jmp    804033 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8039df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039e5:	0f 83 e5 03 00 00    	jae    803dd0 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8039eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ee:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8039f4:	83 ec 0c             	sub    $0xc,%esp
  8039f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039fa:	e8 f0 eb ff ff       	call   8025ef <is_free_block>
  8039ff:	83 c4 10             	add    $0x10,%esp
  803a02:	84 c0                	test   %al,%al
  803a04:	0f 84 3b 01 00 00    	je     803b45 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a10:	01 d0                	add    %edx,%eax
  803a12:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a15:	83 ec 04             	sub    $0x4,%esp
  803a18:	6a 01                	push   $0x1
  803a1a:	ff 75 f0             	pushl  -0x10(%ebp)
  803a1d:	ff 75 08             	pushl  0x8(%ebp)
  803a20:	e8 02 ef ff ff       	call   802927 <set_block_data>
  803a25:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2b:	83 e8 04             	sub    $0x4,%eax
  803a2e:	8b 00                	mov    (%eax),%eax
  803a30:	83 e0 fe             	and    $0xfffffffe,%eax
  803a33:	89 c2                	mov    %eax,%edx
  803a35:	8b 45 08             	mov    0x8(%ebp),%eax
  803a38:	01 d0                	add    %edx,%eax
  803a3a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a3d:	83 ec 04             	sub    $0x4,%esp
  803a40:	6a 00                	push   $0x0
  803a42:	ff 75 cc             	pushl  -0x34(%ebp)
  803a45:	ff 75 c8             	pushl  -0x38(%ebp)
  803a48:	e8 da ee ff ff       	call   802927 <set_block_data>
  803a4d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a54:	74 06                	je     803a5c <realloc_block_FF+0x142>
  803a56:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a5a:	75 17                	jne    803a73 <realloc_block_FF+0x159>
  803a5c:	83 ec 04             	sub    $0x4,%esp
  803a5f:	68 50 4c 80 00       	push   $0x804c50
  803a64:	68 f6 01 00 00       	push   $0x1f6
  803a69:	68 dd 4b 80 00       	push   $0x804bdd
  803a6e:	e8 03 ce ff ff       	call   800876 <_panic>
  803a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a76:	8b 10                	mov    (%eax),%edx
  803a78:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a7b:	89 10                	mov    %edx,(%eax)
  803a7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a80:	8b 00                	mov    (%eax),%eax
  803a82:	85 c0                	test   %eax,%eax
  803a84:	74 0b                	je     803a91 <realloc_block_FF+0x177>
  803a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a89:	8b 00                	mov    (%eax),%eax
  803a8b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a8e:	89 50 04             	mov    %edx,0x4(%eax)
  803a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a94:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a97:	89 10                	mov    %edx,(%eax)
  803a99:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a9f:	89 50 04             	mov    %edx,0x4(%eax)
  803aa2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	75 08                	jne    803ab3 <realloc_block_FF+0x199>
  803aab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aae:	a3 34 50 80 00       	mov    %eax,0x805034
  803ab3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ab8:	40                   	inc    %eax
  803ab9:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803abe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ac2:	75 17                	jne    803adb <realloc_block_FF+0x1c1>
  803ac4:	83 ec 04             	sub    $0x4,%esp
  803ac7:	68 bf 4b 80 00       	push   $0x804bbf
  803acc:	68 f7 01 00 00       	push   $0x1f7
  803ad1:	68 dd 4b 80 00       	push   $0x804bdd
  803ad6:	e8 9b cd ff ff       	call   800876 <_panic>
  803adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	85 c0                	test   %eax,%eax
  803ae2:	74 10                	je     803af4 <realloc_block_FF+0x1da>
  803ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae7:	8b 00                	mov    (%eax),%eax
  803ae9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aec:	8b 52 04             	mov    0x4(%edx),%edx
  803aef:	89 50 04             	mov    %edx,0x4(%eax)
  803af2:	eb 0b                	jmp    803aff <realloc_block_FF+0x1e5>
  803af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af7:	8b 40 04             	mov    0x4(%eax),%eax
  803afa:	a3 34 50 80 00       	mov    %eax,0x805034
  803aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b02:	8b 40 04             	mov    0x4(%eax),%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	74 0f                	je     803b18 <realloc_block_FF+0x1fe>
  803b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0c:	8b 40 04             	mov    0x4(%eax),%eax
  803b0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b12:	8b 12                	mov    (%edx),%edx
  803b14:	89 10                	mov    %edx,(%eax)
  803b16:	eb 0a                	jmp    803b22 <realloc_block_FF+0x208>
  803b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	a3 30 50 80 00       	mov    %eax,0x805030
  803b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b35:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b3a:	48                   	dec    %eax
  803b3b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b40:	e9 83 02 00 00       	jmp    803dc8 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b45:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b49:	0f 86 69 02 00 00    	jbe    803db8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b4f:	83 ec 04             	sub    $0x4,%esp
  803b52:	6a 01                	push   $0x1
  803b54:	ff 75 f0             	pushl  -0x10(%ebp)
  803b57:	ff 75 08             	pushl  0x8(%ebp)
  803b5a:	e8 c8 ed ff ff       	call   802927 <set_block_data>
  803b5f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b62:	8b 45 08             	mov    0x8(%ebp),%eax
  803b65:	83 e8 04             	sub    $0x4,%eax
  803b68:	8b 00                	mov    (%eax),%eax
  803b6a:	83 e0 fe             	and    $0xfffffffe,%eax
  803b6d:	89 c2                	mov    %eax,%edx
  803b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b72:	01 d0                	add    %edx,%eax
  803b74:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b77:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b7f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b83:	75 68                	jne    803bed <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b85:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b89:	75 17                	jne    803ba2 <realloc_block_FF+0x288>
  803b8b:	83 ec 04             	sub    $0x4,%esp
  803b8e:	68 f8 4b 80 00       	push   $0x804bf8
  803b93:	68 06 02 00 00       	push   $0x206
  803b98:	68 dd 4b 80 00       	push   $0x804bdd
  803b9d:	e8 d4 cc ff ff       	call   800876 <_panic>
  803ba2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ba8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bab:	89 10                	mov    %edx,(%eax)
  803bad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb0:	8b 00                	mov    (%eax),%eax
  803bb2:	85 c0                	test   %eax,%eax
  803bb4:	74 0d                	je     803bc3 <realloc_block_FF+0x2a9>
  803bb6:	a1 30 50 80 00       	mov    0x805030,%eax
  803bbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bbe:	89 50 04             	mov    %edx,0x4(%eax)
  803bc1:	eb 08                	jmp    803bcb <realloc_block_FF+0x2b1>
  803bc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc6:	a3 34 50 80 00       	mov    %eax,0x805034
  803bcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bce:	a3 30 50 80 00       	mov    %eax,0x805030
  803bd3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bdd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803be2:	40                   	inc    %eax
  803be3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803be8:	e9 b0 01 00 00       	jmp    803d9d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803bed:	a1 30 50 80 00       	mov    0x805030,%eax
  803bf2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bf5:	76 68                	jbe    803c5f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bf7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bfb:	75 17                	jne    803c14 <realloc_block_FF+0x2fa>
  803bfd:	83 ec 04             	sub    $0x4,%esp
  803c00:	68 f8 4b 80 00       	push   $0x804bf8
  803c05:	68 0b 02 00 00       	push   $0x20b
  803c0a:	68 dd 4b 80 00       	push   $0x804bdd
  803c0f:	e8 62 cc ff ff       	call   800876 <_panic>
  803c14:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1d:	89 10                	mov    %edx,(%eax)
  803c1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c22:	8b 00                	mov    (%eax),%eax
  803c24:	85 c0                	test   %eax,%eax
  803c26:	74 0d                	je     803c35 <realloc_block_FF+0x31b>
  803c28:	a1 30 50 80 00       	mov    0x805030,%eax
  803c2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c30:	89 50 04             	mov    %edx,0x4(%eax)
  803c33:	eb 08                	jmp    803c3d <realloc_block_FF+0x323>
  803c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c38:	a3 34 50 80 00       	mov    %eax,0x805034
  803c3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c40:	a3 30 50 80 00       	mov    %eax,0x805030
  803c45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c4f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c54:	40                   	inc    %eax
  803c55:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c5a:	e9 3e 01 00 00       	jmp    803d9d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c5f:	a1 30 50 80 00       	mov    0x805030,%eax
  803c64:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c67:	73 68                	jae    803cd1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c69:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c6d:	75 17                	jne    803c86 <realloc_block_FF+0x36c>
  803c6f:	83 ec 04             	sub    $0x4,%esp
  803c72:	68 2c 4c 80 00       	push   $0x804c2c
  803c77:	68 10 02 00 00       	push   $0x210
  803c7c:	68 dd 4b 80 00       	push   $0x804bdd
  803c81:	e8 f0 cb ff ff       	call   800876 <_panic>
  803c86:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8f:	89 50 04             	mov    %edx,0x4(%eax)
  803c92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c95:	8b 40 04             	mov    0x4(%eax),%eax
  803c98:	85 c0                	test   %eax,%eax
  803c9a:	74 0c                	je     803ca8 <realloc_block_FF+0x38e>
  803c9c:	a1 34 50 80 00       	mov    0x805034,%eax
  803ca1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ca4:	89 10                	mov    %edx,(%eax)
  803ca6:	eb 08                	jmp    803cb0 <realloc_block_FF+0x396>
  803ca8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cab:	a3 30 50 80 00       	mov    %eax,0x805030
  803cb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb3:	a3 34 50 80 00       	mov    %eax,0x805034
  803cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cc6:	40                   	inc    %eax
  803cc7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ccc:	e9 cc 00 00 00       	jmp    803d9d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803cd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803cd8:	a1 30 50 80 00       	mov    0x805030,%eax
  803cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ce0:	e9 8a 00 00 00       	jmp    803d6f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ceb:	73 7a                	jae    803d67 <realloc_block_FF+0x44d>
  803ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf0:	8b 00                	mov    (%eax),%eax
  803cf2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cf5:	73 70                	jae    803d67 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cfb:	74 06                	je     803d03 <realloc_block_FF+0x3e9>
  803cfd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d01:	75 17                	jne    803d1a <realloc_block_FF+0x400>
  803d03:	83 ec 04             	sub    $0x4,%esp
  803d06:	68 50 4c 80 00       	push   $0x804c50
  803d0b:	68 1a 02 00 00       	push   $0x21a
  803d10:	68 dd 4b 80 00       	push   $0x804bdd
  803d15:	e8 5c cb ff ff       	call   800876 <_panic>
  803d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1d:	8b 10                	mov    (%eax),%edx
  803d1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d22:	89 10                	mov    %edx,(%eax)
  803d24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d27:	8b 00                	mov    (%eax),%eax
  803d29:	85 c0                	test   %eax,%eax
  803d2b:	74 0b                	je     803d38 <realloc_block_FF+0x41e>
  803d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d30:	8b 00                	mov    (%eax),%eax
  803d32:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d35:	89 50 04             	mov    %edx,0x4(%eax)
  803d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d3e:	89 10                	mov    %edx,(%eax)
  803d40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d46:	89 50 04             	mov    %edx,0x4(%eax)
  803d49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d4c:	8b 00                	mov    (%eax),%eax
  803d4e:	85 c0                	test   %eax,%eax
  803d50:	75 08                	jne    803d5a <realloc_block_FF+0x440>
  803d52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d55:	a3 34 50 80 00       	mov    %eax,0x805034
  803d5a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d5f:	40                   	inc    %eax
  803d60:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d65:	eb 36                	jmp    803d9d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d67:	a1 38 50 80 00       	mov    0x805038,%eax
  803d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d73:	74 07                	je     803d7c <realloc_block_FF+0x462>
  803d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d78:	8b 00                	mov    (%eax),%eax
  803d7a:	eb 05                	jmp    803d81 <realloc_block_FF+0x467>
  803d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d81:	a3 38 50 80 00       	mov    %eax,0x805038
  803d86:	a1 38 50 80 00       	mov    0x805038,%eax
  803d8b:	85 c0                	test   %eax,%eax
  803d8d:	0f 85 52 ff ff ff    	jne    803ce5 <realloc_block_FF+0x3cb>
  803d93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d97:	0f 85 48 ff ff ff    	jne    803ce5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d9d:	83 ec 04             	sub    $0x4,%esp
  803da0:	6a 00                	push   $0x0
  803da2:	ff 75 d8             	pushl  -0x28(%ebp)
  803da5:	ff 75 d4             	pushl  -0x2c(%ebp)
  803da8:	e8 7a eb ff ff       	call   802927 <set_block_data>
  803dad:	83 c4 10             	add    $0x10,%esp
				return va;
  803db0:	8b 45 08             	mov    0x8(%ebp),%eax
  803db3:	e9 7b 02 00 00       	jmp    804033 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803db8:	83 ec 0c             	sub    $0xc,%esp
  803dbb:	68 cd 4c 80 00       	push   $0x804ccd
  803dc0:	e8 6e cd ff ff       	call   800b33 <cprintf>
  803dc5:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcb:	e9 63 02 00 00       	jmp    804033 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dd3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dd6:	0f 86 4d 02 00 00    	jbe    804029 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ddc:	83 ec 0c             	sub    $0xc,%esp
  803ddf:	ff 75 e4             	pushl  -0x1c(%ebp)
  803de2:	e8 08 e8 ff ff       	call   8025ef <is_free_block>
  803de7:	83 c4 10             	add    $0x10,%esp
  803dea:	84 c0                	test   %al,%al
  803dec:	0f 84 37 02 00 00    	je     804029 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803df8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803dfb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dfe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e01:	76 38                	jbe    803e3b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e03:	83 ec 0c             	sub    $0xc,%esp
  803e06:	ff 75 08             	pushl  0x8(%ebp)
  803e09:	e8 0c fa ff ff       	call   80381a <free_block>
  803e0e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e11:	83 ec 0c             	sub    $0xc,%esp
  803e14:	ff 75 0c             	pushl  0xc(%ebp)
  803e17:	e8 3a eb ff ff       	call   802956 <alloc_block_FF>
  803e1c:	83 c4 10             	add    $0x10,%esp
  803e1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e22:	83 ec 08             	sub    $0x8,%esp
  803e25:	ff 75 c0             	pushl  -0x40(%ebp)
  803e28:	ff 75 08             	pushl  0x8(%ebp)
  803e2b:	e8 ab fa ff ff       	call   8038db <copy_data>
  803e30:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e33:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e36:	e9 f8 01 00 00       	jmp    804033 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e41:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e44:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e48:	0f 87 a0 00 00 00    	ja     803eee <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e52:	75 17                	jne    803e6b <realloc_block_FF+0x551>
  803e54:	83 ec 04             	sub    $0x4,%esp
  803e57:	68 bf 4b 80 00       	push   $0x804bbf
  803e5c:	68 38 02 00 00       	push   $0x238
  803e61:	68 dd 4b 80 00       	push   $0x804bdd
  803e66:	e8 0b ca ff ff       	call   800876 <_panic>
  803e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6e:	8b 00                	mov    (%eax),%eax
  803e70:	85 c0                	test   %eax,%eax
  803e72:	74 10                	je     803e84 <realloc_block_FF+0x56a>
  803e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e77:	8b 00                	mov    (%eax),%eax
  803e79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e7c:	8b 52 04             	mov    0x4(%edx),%edx
  803e7f:	89 50 04             	mov    %edx,0x4(%eax)
  803e82:	eb 0b                	jmp    803e8f <realloc_block_FF+0x575>
  803e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e87:	8b 40 04             	mov    0x4(%eax),%eax
  803e8a:	a3 34 50 80 00       	mov    %eax,0x805034
  803e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e92:	8b 40 04             	mov    0x4(%eax),%eax
  803e95:	85 c0                	test   %eax,%eax
  803e97:	74 0f                	je     803ea8 <realloc_block_FF+0x58e>
  803e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9c:	8b 40 04             	mov    0x4(%eax),%eax
  803e9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ea2:	8b 12                	mov    (%edx),%edx
  803ea4:	89 10                	mov    %edx,(%eax)
  803ea6:	eb 0a                	jmp    803eb2 <realloc_block_FF+0x598>
  803ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eab:	8b 00                	mov    (%eax),%eax
  803ead:	a3 30 50 80 00       	mov    %eax,0x805030
  803eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803eca:	48                   	dec    %eax
  803ecb:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ed0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ed6:	01 d0                	add    %edx,%eax
  803ed8:	83 ec 04             	sub    $0x4,%esp
  803edb:	6a 01                	push   $0x1
  803edd:	50                   	push   %eax
  803ede:	ff 75 08             	pushl  0x8(%ebp)
  803ee1:	e8 41 ea ff ff       	call   802927 <set_block_data>
  803ee6:	83 c4 10             	add    $0x10,%esp
  803ee9:	e9 36 01 00 00       	jmp    804024 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ef1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ef4:	01 d0                	add    %edx,%eax
  803ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803ef9:	83 ec 04             	sub    $0x4,%esp
  803efc:	6a 01                	push   $0x1
  803efe:	ff 75 f0             	pushl  -0x10(%ebp)
  803f01:	ff 75 08             	pushl  0x8(%ebp)
  803f04:	e8 1e ea ff ff       	call   802927 <set_block_data>
  803f09:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0f:	83 e8 04             	sub    $0x4,%eax
  803f12:	8b 00                	mov    (%eax),%eax
  803f14:	83 e0 fe             	and    $0xfffffffe,%eax
  803f17:	89 c2                	mov    %eax,%edx
  803f19:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1c:	01 d0                	add    %edx,%eax
  803f1e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f25:	74 06                	je     803f2d <realloc_block_FF+0x613>
  803f27:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f2b:	75 17                	jne    803f44 <realloc_block_FF+0x62a>
  803f2d:	83 ec 04             	sub    $0x4,%esp
  803f30:	68 50 4c 80 00       	push   $0x804c50
  803f35:	68 44 02 00 00       	push   $0x244
  803f3a:	68 dd 4b 80 00       	push   $0x804bdd
  803f3f:	e8 32 c9 ff ff       	call   800876 <_panic>
  803f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f47:	8b 10                	mov    (%eax),%edx
  803f49:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f4c:	89 10                	mov    %edx,(%eax)
  803f4e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f51:	8b 00                	mov    (%eax),%eax
  803f53:	85 c0                	test   %eax,%eax
  803f55:	74 0b                	je     803f62 <realloc_block_FF+0x648>
  803f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5a:	8b 00                	mov    (%eax),%eax
  803f5c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f5f:	89 50 04             	mov    %edx,0x4(%eax)
  803f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f65:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f68:	89 10                	mov    %edx,(%eax)
  803f6a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f70:	89 50 04             	mov    %edx,0x4(%eax)
  803f73:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f76:	8b 00                	mov    (%eax),%eax
  803f78:	85 c0                	test   %eax,%eax
  803f7a:	75 08                	jne    803f84 <realloc_block_FF+0x66a>
  803f7c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f7f:	a3 34 50 80 00       	mov    %eax,0x805034
  803f84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f89:	40                   	inc    %eax
  803f8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f93:	75 17                	jne    803fac <realloc_block_FF+0x692>
  803f95:	83 ec 04             	sub    $0x4,%esp
  803f98:	68 bf 4b 80 00       	push   $0x804bbf
  803f9d:	68 45 02 00 00       	push   $0x245
  803fa2:	68 dd 4b 80 00       	push   $0x804bdd
  803fa7:	e8 ca c8 ff ff       	call   800876 <_panic>
  803fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803faf:	8b 00                	mov    (%eax),%eax
  803fb1:	85 c0                	test   %eax,%eax
  803fb3:	74 10                	je     803fc5 <realloc_block_FF+0x6ab>
  803fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb8:	8b 00                	mov    (%eax),%eax
  803fba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fbd:	8b 52 04             	mov    0x4(%edx),%edx
  803fc0:	89 50 04             	mov    %edx,0x4(%eax)
  803fc3:	eb 0b                	jmp    803fd0 <realloc_block_FF+0x6b6>
  803fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc8:	8b 40 04             	mov    0x4(%eax),%eax
  803fcb:	a3 34 50 80 00       	mov    %eax,0x805034
  803fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd3:	8b 40 04             	mov    0x4(%eax),%eax
  803fd6:	85 c0                	test   %eax,%eax
  803fd8:	74 0f                	je     803fe9 <realloc_block_FF+0x6cf>
  803fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdd:	8b 40 04             	mov    0x4(%eax),%eax
  803fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fe3:	8b 12                	mov    (%edx),%edx
  803fe5:	89 10                	mov    %edx,(%eax)
  803fe7:	eb 0a                	jmp    803ff3 <realloc_block_FF+0x6d9>
  803fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fec:	8b 00                	mov    (%eax),%eax
  803fee:	a3 30 50 80 00       	mov    %eax,0x805030
  803ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804006:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80400b:	48                   	dec    %eax
  80400c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  804011:	83 ec 04             	sub    $0x4,%esp
  804014:	6a 00                	push   $0x0
  804016:	ff 75 bc             	pushl  -0x44(%ebp)
  804019:	ff 75 b8             	pushl  -0x48(%ebp)
  80401c:	e8 06 e9 ff ff       	call   802927 <set_block_data>
  804021:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804024:	8b 45 08             	mov    0x8(%ebp),%eax
  804027:	eb 0a                	jmp    804033 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804029:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804033:	c9                   	leave  
  804034:	c3                   	ret    

00804035 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804035:	55                   	push   %ebp
  804036:	89 e5                	mov    %esp,%ebp
  804038:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80403b:	83 ec 04             	sub    $0x4,%esp
  80403e:	68 d4 4c 80 00       	push   $0x804cd4
  804043:	68 58 02 00 00       	push   $0x258
  804048:	68 dd 4b 80 00       	push   $0x804bdd
  80404d:	e8 24 c8 ff ff       	call   800876 <_panic>

00804052 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804052:	55                   	push   %ebp
  804053:	89 e5                	mov    %esp,%ebp
  804055:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804058:	83 ec 04             	sub    $0x4,%esp
  80405b:	68 fc 4c 80 00       	push   $0x804cfc
  804060:	68 61 02 00 00       	push   $0x261
  804065:	68 dd 4b 80 00       	push   $0x804bdd
  80406a:	e8 07 c8 ff ff       	call   800876 <_panic>
  80406f:	90                   	nop

00804070 <__udivdi3>:
  804070:	55                   	push   %ebp
  804071:	57                   	push   %edi
  804072:	56                   	push   %esi
  804073:	53                   	push   %ebx
  804074:	83 ec 1c             	sub    $0x1c,%esp
  804077:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80407b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80407f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804083:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804087:	89 ca                	mov    %ecx,%edx
  804089:	89 f8                	mov    %edi,%eax
  80408b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80408f:	85 f6                	test   %esi,%esi
  804091:	75 2d                	jne    8040c0 <__udivdi3+0x50>
  804093:	39 cf                	cmp    %ecx,%edi
  804095:	77 65                	ja     8040fc <__udivdi3+0x8c>
  804097:	89 fd                	mov    %edi,%ebp
  804099:	85 ff                	test   %edi,%edi
  80409b:	75 0b                	jne    8040a8 <__udivdi3+0x38>
  80409d:	b8 01 00 00 00       	mov    $0x1,%eax
  8040a2:	31 d2                	xor    %edx,%edx
  8040a4:	f7 f7                	div    %edi
  8040a6:	89 c5                	mov    %eax,%ebp
  8040a8:	31 d2                	xor    %edx,%edx
  8040aa:	89 c8                	mov    %ecx,%eax
  8040ac:	f7 f5                	div    %ebp
  8040ae:	89 c1                	mov    %eax,%ecx
  8040b0:	89 d8                	mov    %ebx,%eax
  8040b2:	f7 f5                	div    %ebp
  8040b4:	89 cf                	mov    %ecx,%edi
  8040b6:	89 fa                	mov    %edi,%edx
  8040b8:	83 c4 1c             	add    $0x1c,%esp
  8040bb:	5b                   	pop    %ebx
  8040bc:	5e                   	pop    %esi
  8040bd:	5f                   	pop    %edi
  8040be:	5d                   	pop    %ebp
  8040bf:	c3                   	ret    
  8040c0:	39 ce                	cmp    %ecx,%esi
  8040c2:	77 28                	ja     8040ec <__udivdi3+0x7c>
  8040c4:	0f bd fe             	bsr    %esi,%edi
  8040c7:	83 f7 1f             	xor    $0x1f,%edi
  8040ca:	75 40                	jne    80410c <__udivdi3+0x9c>
  8040cc:	39 ce                	cmp    %ecx,%esi
  8040ce:	72 0a                	jb     8040da <__udivdi3+0x6a>
  8040d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040d4:	0f 87 9e 00 00 00    	ja     804178 <__udivdi3+0x108>
  8040da:	b8 01 00 00 00       	mov    $0x1,%eax
  8040df:	89 fa                	mov    %edi,%edx
  8040e1:	83 c4 1c             	add    $0x1c,%esp
  8040e4:	5b                   	pop    %ebx
  8040e5:	5e                   	pop    %esi
  8040e6:	5f                   	pop    %edi
  8040e7:	5d                   	pop    %ebp
  8040e8:	c3                   	ret    
  8040e9:	8d 76 00             	lea    0x0(%esi),%esi
  8040ec:	31 ff                	xor    %edi,%edi
  8040ee:	31 c0                	xor    %eax,%eax
  8040f0:	89 fa                	mov    %edi,%edx
  8040f2:	83 c4 1c             	add    $0x1c,%esp
  8040f5:	5b                   	pop    %ebx
  8040f6:	5e                   	pop    %esi
  8040f7:	5f                   	pop    %edi
  8040f8:	5d                   	pop    %ebp
  8040f9:	c3                   	ret    
  8040fa:	66 90                	xchg   %ax,%ax
  8040fc:	89 d8                	mov    %ebx,%eax
  8040fe:	f7 f7                	div    %edi
  804100:	31 ff                	xor    %edi,%edi
  804102:	89 fa                	mov    %edi,%edx
  804104:	83 c4 1c             	add    $0x1c,%esp
  804107:	5b                   	pop    %ebx
  804108:	5e                   	pop    %esi
  804109:	5f                   	pop    %edi
  80410a:	5d                   	pop    %ebp
  80410b:	c3                   	ret    
  80410c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804111:	89 eb                	mov    %ebp,%ebx
  804113:	29 fb                	sub    %edi,%ebx
  804115:	89 f9                	mov    %edi,%ecx
  804117:	d3 e6                	shl    %cl,%esi
  804119:	89 c5                	mov    %eax,%ebp
  80411b:	88 d9                	mov    %bl,%cl
  80411d:	d3 ed                	shr    %cl,%ebp
  80411f:	89 e9                	mov    %ebp,%ecx
  804121:	09 f1                	or     %esi,%ecx
  804123:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804127:	89 f9                	mov    %edi,%ecx
  804129:	d3 e0                	shl    %cl,%eax
  80412b:	89 c5                	mov    %eax,%ebp
  80412d:	89 d6                	mov    %edx,%esi
  80412f:	88 d9                	mov    %bl,%cl
  804131:	d3 ee                	shr    %cl,%esi
  804133:	89 f9                	mov    %edi,%ecx
  804135:	d3 e2                	shl    %cl,%edx
  804137:	8b 44 24 08          	mov    0x8(%esp),%eax
  80413b:	88 d9                	mov    %bl,%cl
  80413d:	d3 e8                	shr    %cl,%eax
  80413f:	09 c2                	or     %eax,%edx
  804141:	89 d0                	mov    %edx,%eax
  804143:	89 f2                	mov    %esi,%edx
  804145:	f7 74 24 0c          	divl   0xc(%esp)
  804149:	89 d6                	mov    %edx,%esi
  80414b:	89 c3                	mov    %eax,%ebx
  80414d:	f7 e5                	mul    %ebp
  80414f:	39 d6                	cmp    %edx,%esi
  804151:	72 19                	jb     80416c <__udivdi3+0xfc>
  804153:	74 0b                	je     804160 <__udivdi3+0xf0>
  804155:	89 d8                	mov    %ebx,%eax
  804157:	31 ff                	xor    %edi,%edi
  804159:	e9 58 ff ff ff       	jmp    8040b6 <__udivdi3+0x46>
  80415e:	66 90                	xchg   %ax,%ax
  804160:	8b 54 24 08          	mov    0x8(%esp),%edx
  804164:	89 f9                	mov    %edi,%ecx
  804166:	d3 e2                	shl    %cl,%edx
  804168:	39 c2                	cmp    %eax,%edx
  80416a:	73 e9                	jae    804155 <__udivdi3+0xe5>
  80416c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80416f:	31 ff                	xor    %edi,%edi
  804171:	e9 40 ff ff ff       	jmp    8040b6 <__udivdi3+0x46>
  804176:	66 90                	xchg   %ax,%ax
  804178:	31 c0                	xor    %eax,%eax
  80417a:	e9 37 ff ff ff       	jmp    8040b6 <__udivdi3+0x46>
  80417f:	90                   	nop

00804180 <__umoddi3>:
  804180:	55                   	push   %ebp
  804181:	57                   	push   %edi
  804182:	56                   	push   %esi
  804183:	53                   	push   %ebx
  804184:	83 ec 1c             	sub    $0x1c,%esp
  804187:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80418b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80418f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804193:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804197:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80419b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80419f:	89 f3                	mov    %esi,%ebx
  8041a1:	89 fa                	mov    %edi,%edx
  8041a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041a7:	89 34 24             	mov    %esi,(%esp)
  8041aa:	85 c0                	test   %eax,%eax
  8041ac:	75 1a                	jne    8041c8 <__umoddi3+0x48>
  8041ae:	39 f7                	cmp    %esi,%edi
  8041b0:	0f 86 a2 00 00 00    	jbe    804258 <__umoddi3+0xd8>
  8041b6:	89 c8                	mov    %ecx,%eax
  8041b8:	89 f2                	mov    %esi,%edx
  8041ba:	f7 f7                	div    %edi
  8041bc:	89 d0                	mov    %edx,%eax
  8041be:	31 d2                	xor    %edx,%edx
  8041c0:	83 c4 1c             	add    $0x1c,%esp
  8041c3:	5b                   	pop    %ebx
  8041c4:	5e                   	pop    %esi
  8041c5:	5f                   	pop    %edi
  8041c6:	5d                   	pop    %ebp
  8041c7:	c3                   	ret    
  8041c8:	39 f0                	cmp    %esi,%eax
  8041ca:	0f 87 ac 00 00 00    	ja     80427c <__umoddi3+0xfc>
  8041d0:	0f bd e8             	bsr    %eax,%ebp
  8041d3:	83 f5 1f             	xor    $0x1f,%ebp
  8041d6:	0f 84 ac 00 00 00    	je     804288 <__umoddi3+0x108>
  8041dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8041e1:	29 ef                	sub    %ebp,%edi
  8041e3:	89 fe                	mov    %edi,%esi
  8041e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041e9:	89 e9                	mov    %ebp,%ecx
  8041eb:	d3 e0                	shl    %cl,%eax
  8041ed:	89 d7                	mov    %edx,%edi
  8041ef:	89 f1                	mov    %esi,%ecx
  8041f1:	d3 ef                	shr    %cl,%edi
  8041f3:	09 c7                	or     %eax,%edi
  8041f5:	89 e9                	mov    %ebp,%ecx
  8041f7:	d3 e2                	shl    %cl,%edx
  8041f9:	89 14 24             	mov    %edx,(%esp)
  8041fc:	89 d8                	mov    %ebx,%eax
  8041fe:	d3 e0                	shl    %cl,%eax
  804200:	89 c2                	mov    %eax,%edx
  804202:	8b 44 24 08          	mov    0x8(%esp),%eax
  804206:	d3 e0                	shl    %cl,%eax
  804208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80420c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804210:	89 f1                	mov    %esi,%ecx
  804212:	d3 e8                	shr    %cl,%eax
  804214:	09 d0                	or     %edx,%eax
  804216:	d3 eb                	shr    %cl,%ebx
  804218:	89 da                	mov    %ebx,%edx
  80421a:	f7 f7                	div    %edi
  80421c:	89 d3                	mov    %edx,%ebx
  80421e:	f7 24 24             	mull   (%esp)
  804221:	89 c6                	mov    %eax,%esi
  804223:	89 d1                	mov    %edx,%ecx
  804225:	39 d3                	cmp    %edx,%ebx
  804227:	0f 82 87 00 00 00    	jb     8042b4 <__umoddi3+0x134>
  80422d:	0f 84 91 00 00 00    	je     8042c4 <__umoddi3+0x144>
  804233:	8b 54 24 04          	mov    0x4(%esp),%edx
  804237:	29 f2                	sub    %esi,%edx
  804239:	19 cb                	sbb    %ecx,%ebx
  80423b:	89 d8                	mov    %ebx,%eax
  80423d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804241:	d3 e0                	shl    %cl,%eax
  804243:	89 e9                	mov    %ebp,%ecx
  804245:	d3 ea                	shr    %cl,%edx
  804247:	09 d0                	or     %edx,%eax
  804249:	89 e9                	mov    %ebp,%ecx
  80424b:	d3 eb                	shr    %cl,%ebx
  80424d:	89 da                	mov    %ebx,%edx
  80424f:	83 c4 1c             	add    $0x1c,%esp
  804252:	5b                   	pop    %ebx
  804253:	5e                   	pop    %esi
  804254:	5f                   	pop    %edi
  804255:	5d                   	pop    %ebp
  804256:	c3                   	ret    
  804257:	90                   	nop
  804258:	89 fd                	mov    %edi,%ebp
  80425a:	85 ff                	test   %edi,%edi
  80425c:	75 0b                	jne    804269 <__umoddi3+0xe9>
  80425e:	b8 01 00 00 00       	mov    $0x1,%eax
  804263:	31 d2                	xor    %edx,%edx
  804265:	f7 f7                	div    %edi
  804267:	89 c5                	mov    %eax,%ebp
  804269:	89 f0                	mov    %esi,%eax
  80426b:	31 d2                	xor    %edx,%edx
  80426d:	f7 f5                	div    %ebp
  80426f:	89 c8                	mov    %ecx,%eax
  804271:	f7 f5                	div    %ebp
  804273:	89 d0                	mov    %edx,%eax
  804275:	e9 44 ff ff ff       	jmp    8041be <__umoddi3+0x3e>
  80427a:	66 90                	xchg   %ax,%ax
  80427c:	89 c8                	mov    %ecx,%eax
  80427e:	89 f2                	mov    %esi,%edx
  804280:	83 c4 1c             	add    $0x1c,%esp
  804283:	5b                   	pop    %ebx
  804284:	5e                   	pop    %esi
  804285:	5f                   	pop    %edi
  804286:	5d                   	pop    %ebp
  804287:	c3                   	ret    
  804288:	3b 04 24             	cmp    (%esp),%eax
  80428b:	72 06                	jb     804293 <__umoddi3+0x113>
  80428d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804291:	77 0f                	ja     8042a2 <__umoddi3+0x122>
  804293:	89 f2                	mov    %esi,%edx
  804295:	29 f9                	sub    %edi,%ecx
  804297:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80429b:	89 14 24             	mov    %edx,(%esp)
  80429e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042a6:	8b 14 24             	mov    (%esp),%edx
  8042a9:	83 c4 1c             	add    $0x1c,%esp
  8042ac:	5b                   	pop    %ebx
  8042ad:	5e                   	pop    %esi
  8042ae:	5f                   	pop    %edi
  8042af:	5d                   	pop    %ebp
  8042b0:	c3                   	ret    
  8042b1:	8d 76 00             	lea    0x0(%esi),%esi
  8042b4:	2b 04 24             	sub    (%esp),%eax
  8042b7:	19 fa                	sbb    %edi,%edx
  8042b9:	89 d1                	mov    %edx,%ecx
  8042bb:	89 c6                	mov    %eax,%esi
  8042bd:	e9 71 ff ff ff       	jmp    804233 <__umoddi3+0xb3>
  8042c2:	66 90                	xchg   %ax,%ax
  8042c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042c8:	72 ea                	jb     8042b4 <__umoddi3+0x134>
  8042ca:	89 d9                	mov    %ebx,%ecx
  8042cc:	e9 62 ff ff ff       	jmp    804233 <__umoddi3+0xb3>
