
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
  800041:	e8 c4 1f 00 00       	call   80200a <sys_lock_cons>
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
  800162:	e8 bd 1e 00 00       	call   802024 <sys_unlock_cons>
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
  8001d7:	e8 2e 1e 00 00       	call   80200a <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 88 43 80 00       	push   $0x804388
  8001e4:	e8 4a 09 00 00       	call   800b33 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 33 1e 00 00       	call   802024 <sys_unlock_cons>
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
  80021f:	e8 e6 1d 00 00       	call   80200a <sys_lock_cons>
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
  800254:	e8 cb 1d 00 00       	call   802024 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 ac 1d 00 00       	call   80200a <sys_lock_cons>
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
  8002b2:	e8 6d 1d 00 00       	call   802024 <sys_unlock_cons>
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
  80070f:	e8 41 1a 00 00       	call   802155 <sys_cputc>
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
  800720:	e8 cc 18 00 00       	call   801ff1 <sys_cgetc>
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
  80073d:	e8 44 1b 00 00       	call   802286 <sys_getenvindex>
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
  8007ab:	e8 5a 18 00 00       	call   80200a <sys_lock_cons>
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
  800845:	e8 da 17 00 00       	call   802024 <sys_unlock_cons>
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
  80085d:	e8 f0 19 00 00       	call   802252 <sys_destroy_env>
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
  80086e:	e8 45 1a 00 00       	call   8022b8 <sys_exit_env>
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
  800aa5:	e8 1e 15 00 00       	call   801fc8 <sys_cputs>
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
  800b1c:	e8 a7 14 00 00       	call   801fc8 <sys_cputs>
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
  800b66:	e8 9f 14 00 00       	call   80200a <sys_lock_cons>
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
  800b86:	e8 99 14 00 00       	call   802024 <sys_unlock_cons>
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
  800bd0:	e8 8b 34 00 00       	call   804060 <__udivdi3>
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
  800c20:	e8 4b 35 00 00       	call   804170 <__umoddi3>
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
  8012cc:	e8 39 0d 00 00       	call   80200a <sys_lock_cons>
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
  8013c7:	e8 58 0c 00 00       	call   802024 <sys_unlock_cons>
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
  801ae1:	e8 8d 0a 00 00       	call   802573 <sys_sbrk>
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
  801b5c:	e8 96 08 00 00       	call   8023f7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	74 16                	je     801b7b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 d6 0d 00 00       	call   802946 <alloc_block_FF>
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b76:	e9 8a 01 00 00       	jmp    801d05 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b7b:	e8 a8 08 00 00       	call   802428 <sys_isUHeapPlacementStrategyBESTFIT>
  801b80:	85 c0                	test   %eax,%eax
  801b82:	0f 84 7d 01 00 00    	je     801d05 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 6f 12 00 00       	call   802e02 <alloc_block_BF>
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
  801cf4:	e8 b1 08 00 00       	call   8025aa <sys_allocate_user_mem>
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
  801d3c:	e8 85 08 00 00       	call   8025c6 <get_block_size>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 b8 1a 00 00       	call   80380a <free_block>
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
  801de4:	e8 a5 07 00 00       	call   80258e <sys_free_user_mem>
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
  801e1f:	eb 64                	jmp    801e85 <smalloc+0x7d>
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
  801e54:	eb 2f                	jmp    801e85 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e56:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e5a:	ff 75 ec             	pushl  -0x14(%ebp)
  801e5d:	50                   	push   %eax
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	e8 2c 03 00 00       	call   802195 <sys_createSharedObject>
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e6f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e73:	74 06                	je     801e7b <smalloc+0x73>
  801e75:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e79:	75 07                	jne    801e82 <smalloc+0x7a>
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	eb 03                	jmp    801e85 <smalloc+0x7d>
	 return ptr;
  801e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e8d:	83 ec 08             	sub    $0x8,%esp
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	e8 24 03 00 00       	call   8021bf <sys_getSizeOfSharedObject>
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ea1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ea5:	75 07                	jne    801eae <sget+0x27>
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	eb 5c                	jmp    801f0a <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eb4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	39 d0                	cmp    %edx,%eax
  801ec3:	7d 02                	jge    801ec7 <sget+0x40>
  801ec5:	89 d0                	mov    %edx,%eax
  801ec7:	83 ec 0c             	sub    $0xc,%esp
  801eca:	50                   	push   %eax
  801ecb:	e8 1b fc ff ff       	call   801aeb <malloc>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ed6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801eda:	75 07                	jne    801ee3 <sget+0x5c>
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	eb 27                	jmp    801f0a <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ee3:	83 ec 04             	sub    $0x4,%esp
  801ee6:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	e8 e8 02 00 00       	call   8021dc <sys_getSharedObject>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801efa:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801efe:	75 07                	jne    801f07 <sget+0x80>
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	eb 03                	jmp    801f0a <sget+0x83>
	return ptr;
  801f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	68 e4 4a 80 00       	push   $0x804ae4
  801f1a:	68 c1 00 00 00       	push   $0xc1
  801f1f:	68 d6 4a 80 00       	push   $0x804ad6
  801f24:	e8 4d e9 ff ff       	call   800876 <_panic>

00801f29 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f2f:	83 ec 04             	sub    $0x4,%esp
  801f32:	68 08 4b 80 00       	push   $0x804b08
  801f37:	68 d8 00 00 00       	push   $0xd8
  801f3c:	68 d6 4a 80 00       	push   $0x804ad6
  801f41:	e8 30 e9 ff ff       	call   800876 <_panic>

00801f46 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	68 2e 4b 80 00       	push   $0x804b2e
  801f54:	68 e4 00 00 00       	push   $0xe4
  801f59:	68 d6 4a 80 00       	push   $0x804ad6
  801f5e:	e8 13 e9 ff ff       	call   800876 <_panic>

00801f63 <shrink>:

}
void shrink(uint32 newSize)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	68 2e 4b 80 00       	push   $0x804b2e
  801f71:	68 e9 00 00 00       	push   $0xe9
  801f76:	68 d6 4a 80 00       	push   $0x804ad6
  801f7b:	e8 f6 e8 ff ff       	call   800876 <_panic>

00801f80 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 2e 4b 80 00       	push   $0x804b2e
  801f8e:	68 ee 00 00 00       	push   $0xee
  801f93:	68 d6 4a 80 00       	push   $0x804ad6
  801f98:	e8 d9 e8 ff ff       	call   800876 <_panic>

00801f9d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	57                   	push   %edi
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801faf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fb5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fb8:	cd 30                	int    $0x30
  801fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	5b                   	pop    %ebx
  801fc4:	5e                   	pop    %esi
  801fc5:	5f                   	pop    %edi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fd4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	52                   	push   %edx
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	50                   	push   %eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	e8 b2 ff ff ff       	call   801f9d <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	90                   	nop
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 02                	push   $0x2
  802000:	e8 98 ff ff ff       	call   801f9d <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 03                	push   $0x3
  802019:	e8 7f ff ff ff       	call   801f9d <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
}
  802021:	90                   	nop
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 04                	push   $0x4
  802033:	e8 65 ff ff ff       	call   801f9d <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	90                   	nop
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	52                   	push   %edx
  80204e:	50                   	push   %eax
  80204f:	6a 08                	push   $0x8
  802051:	e8 47 ff ff ff       	call   801f9d <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802060:	8b 75 18             	mov    0x18(%ebp),%esi
  802063:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802066:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	56                   	push   %esi
  802070:	53                   	push   %ebx
  802071:	51                   	push   %ecx
  802072:	52                   	push   %edx
  802073:	50                   	push   %eax
  802074:	6a 09                	push   $0x9
  802076:	e8 22 ff ff ff       	call   801f9d <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802081:	5b                   	pop    %ebx
  802082:	5e                   	pop    %esi
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	52                   	push   %edx
  802095:	50                   	push   %eax
  802096:	6a 0a                	push   $0xa
  802098:	e8 00 ff ff ff       	call   801f9d <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	6a 0b                	push   $0xb
  8020b3:	e8 e5 fe ff ff       	call   801f9d <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 0c                	push   $0xc
  8020cc:	e8 cc fe ff ff       	call   801f9d <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 0d                	push   $0xd
  8020e5:	e8 b3 fe ff ff       	call   801f9d <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 0e                	push   $0xe
  8020fe:	e8 9a fe ff ff       	call   801f9d <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 0f                	push   $0xf
  802117:	e8 81 fe ff ff       	call   801f9d <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	ff 75 08             	pushl  0x8(%ebp)
  80212f:	6a 10                	push   $0x10
  802131:	e8 67 fe ff ff       	call   801f9d <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 11                	push   $0x11
  80214a:	e8 4e fe ff ff       	call   801f9d <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	90                   	nop
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_cputc>:

void
sys_cputc(const char c)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802161:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	50                   	push   %eax
  80216e:	6a 01                	push   $0x1
  802170:	e8 28 fe ff ff       	call   801f9d <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	90                   	nop
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 14                	push   $0x14
  80218a:	e8 0e fe ff ff       	call   801f9d <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
}
  802192:	90                   	nop
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021a1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	6a 00                	push   $0x0
  8021ad:	51                   	push   %ecx
  8021ae:	52                   	push   %edx
  8021af:	ff 75 0c             	pushl  0xc(%ebp)
  8021b2:	50                   	push   %eax
  8021b3:	6a 15                	push   $0x15
  8021b5:	e8 e3 fd ff ff       	call   801f9d <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	52                   	push   %edx
  8021cf:	50                   	push   %eax
  8021d0:	6a 16                	push   $0x16
  8021d2:	e8 c6 fd ff ff       	call   801f9d <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	51                   	push   %ecx
  8021ed:	52                   	push   %edx
  8021ee:	50                   	push   %eax
  8021ef:	6a 17                	push   $0x17
  8021f1:	e8 a7 fd ff ff       	call   801f9d <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	52                   	push   %edx
  80220b:	50                   	push   %eax
  80220c:	6a 18                	push   $0x18
  80220e:	e8 8a fd ff ff       	call   801f9d <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	ff 75 14             	pushl  0x14(%ebp)
  802223:	ff 75 10             	pushl  0x10(%ebp)
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	50                   	push   %eax
  80222a:	6a 19                	push   $0x19
  80222c:	e8 6c fd ff ff       	call   801f9d <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	50                   	push   %eax
  802245:	6a 1a                	push   $0x1a
  802247:	e8 51 fd ff ff       	call   801f9d <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	50                   	push   %eax
  802261:	6a 1b                	push   $0x1b
  802263:	e8 35 fd ff ff       	call   801f9d <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 05                	push   $0x5
  80227c:	e8 1c fd ff ff       	call   801f9d <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 06                	push   $0x6
  802295:	e8 03 fd ff ff       	call   801f9d <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 07                	push   $0x7
  8022ae:	e8 ea fc ff ff       	call   801f9d <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_exit_env>:


void sys_exit_env(void)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 1c                	push   $0x1c
  8022c7:	e8 d1 fc ff ff       	call   801f9d <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	90                   	nop
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022d8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022db:	8d 50 04             	lea    0x4(%eax),%edx
  8022de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	52                   	push   %edx
  8022e8:	50                   	push   %eax
  8022e9:	6a 1d                	push   $0x1d
  8022eb:	e8 ad fc ff ff       	call   801f9d <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
	return result;
  8022f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022fc:	89 01                	mov    %eax,(%ecx)
  8022fe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	c9                   	leave  
  802305:	c2 04 00             	ret    $0x4

00802308 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	ff 75 10             	pushl  0x10(%ebp)
  802312:	ff 75 0c             	pushl  0xc(%ebp)
  802315:	ff 75 08             	pushl  0x8(%ebp)
  802318:	6a 13                	push   $0x13
  80231a:	e8 7e fc ff ff       	call   801f9d <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
	return ;
  802322:	90                   	nop
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_rcr2>:
uint32 sys_rcr2()
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 1e                	push   $0x1e
  802334:	e8 64 fc ff ff       	call   801f9d <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80234a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	50                   	push   %eax
  802357:	6a 1f                	push   $0x1f
  802359:	e8 3f fc ff ff       	call   801f9d <syscall>
  80235e:	83 c4 18             	add    $0x18,%esp
	return ;
  802361:	90                   	nop
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <rsttst>:
void rsttst()
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 21                	push   $0x21
  802373:	e8 25 fc ff ff       	call   801f9d <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
	return ;
  80237b:	90                   	nop
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	8b 45 14             	mov    0x14(%ebp),%eax
  802387:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80238a:	8b 55 18             	mov    0x18(%ebp),%edx
  80238d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802391:	52                   	push   %edx
  802392:	50                   	push   %eax
  802393:	ff 75 10             	pushl  0x10(%ebp)
  802396:	ff 75 0c             	pushl  0xc(%ebp)
  802399:	ff 75 08             	pushl  0x8(%ebp)
  80239c:	6a 20                	push   $0x20
  80239e:	e8 fa fb ff ff       	call   801f9d <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a6:	90                   	nop
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <chktst>:
void chktst(uint32 n)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	ff 75 08             	pushl  0x8(%ebp)
  8023b7:	6a 22                	push   $0x22
  8023b9:	e8 df fb ff ff       	call   801f9d <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c1:	90                   	nop
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <inctst>:

void inctst()
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 23                	push   $0x23
  8023d3:	e8 c5 fb ff ff       	call   801f9d <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023db:	90                   	nop
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <gettst>:
uint32 gettst()
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 24                	push   $0x24
  8023ed:	e8 ab fb ff ff       	call   801f9d <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 25                	push   $0x25
  802409:	e8 8f fb ff ff       	call   801f9d <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
  802411:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802414:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802418:	75 07                	jne    802421 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80241a:	b8 01 00 00 00       	mov    $0x1,%eax
  80241f:	eb 05                	jmp    802426 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 25                	push   $0x25
  80243a:	e8 5e fb ff ff       	call   801f9d <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
  802442:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802445:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802449:	75 07                	jne    802452 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80244b:	b8 01 00 00 00       	mov    $0x1,%eax
  802450:	eb 05                	jmp    802457 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 25                	push   $0x25
  80246b:	e8 2d fb ff ff       	call   801f9d <syscall>
  802470:	83 c4 18             	add    $0x18,%esp
  802473:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802476:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80247a:	75 07                	jne    802483 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80247c:	b8 01 00 00 00       	mov    $0x1,%eax
  802481:	eb 05                	jmp    802488 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 25                	push   $0x25
  80249c:	e8 fc fa ff ff       	call   801f9d <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
  8024a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024a7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024ab:	75 07                	jne    8024b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b2:	eb 05                	jmp    8024b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	ff 75 08             	pushl  0x8(%ebp)
  8024c9:	6a 26                	push   $0x26
  8024cb:	e8 cd fa ff ff       	call   801f9d <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d3:	90                   	nop
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	6a 00                	push   $0x0
  8024e8:	53                   	push   %ebx
  8024e9:	51                   	push   %ecx
  8024ea:	52                   	push   %edx
  8024eb:	50                   	push   %eax
  8024ec:	6a 27                	push   $0x27
  8024ee:	e8 aa fa ff ff       	call   801f9d <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
}
  8024f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	52                   	push   %edx
  80250b:	50                   	push   %eax
  80250c:	6a 28                	push   $0x28
  80250e:	e8 8a fa ff ff       	call   801f9d <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80251b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80251e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	51                   	push   %ecx
  802527:	ff 75 10             	pushl  0x10(%ebp)
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	6a 29                	push   $0x29
  80252e:	e8 6a fa ff ff       	call   801f9d <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	ff 75 10             	pushl  0x10(%ebp)
  802542:	ff 75 0c             	pushl  0xc(%ebp)
  802545:	ff 75 08             	pushl  0x8(%ebp)
  802548:	6a 12                	push   $0x12
  80254a:	e8 4e fa ff ff       	call   801f9d <syscall>
  80254f:	83 c4 18             	add    $0x18,%esp
	return ;
  802552:	90                   	nop
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	52                   	push   %edx
  802565:	50                   	push   %eax
  802566:	6a 2a                	push   $0x2a
  802568:	e8 30 fa ff ff       	call   801f9d <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
	return;
  802570:	90                   	nop
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	50                   	push   %eax
  802582:	6a 2b                	push   $0x2b
  802584:	e8 14 fa ff ff       	call   801f9d <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	ff 75 0c             	pushl  0xc(%ebp)
  80259a:	ff 75 08             	pushl  0x8(%ebp)
  80259d:	6a 2c                	push   $0x2c
  80259f:	e8 f9 f9 ff ff       	call   801f9d <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
	return;
  8025a7:	90                   	nop
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	ff 75 0c             	pushl  0xc(%ebp)
  8025b6:	ff 75 08             	pushl  0x8(%ebp)
  8025b9:	6a 2d                	push   $0x2d
  8025bb:	e8 dd f9 ff ff       	call   801f9d <syscall>
  8025c0:	83 c4 18             	add    $0x18,%esp
	return;
  8025c3:	90                   	nop
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	83 e8 04             	sub    $0x4,%eax
  8025d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e8:	83 e8 04             	sub    $0x4,%eax
  8025eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	83 e0 01             	and    $0x1,%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	0f 94 c0             	sete   %al
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80260a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260d:	83 f8 02             	cmp    $0x2,%eax
  802610:	74 2b                	je     80263d <alloc_block+0x40>
  802612:	83 f8 02             	cmp    $0x2,%eax
  802615:	7f 07                	jg     80261e <alloc_block+0x21>
  802617:	83 f8 01             	cmp    $0x1,%eax
  80261a:	74 0e                	je     80262a <alloc_block+0x2d>
  80261c:	eb 58                	jmp    802676 <alloc_block+0x79>
  80261e:	83 f8 03             	cmp    $0x3,%eax
  802621:	74 2d                	je     802650 <alloc_block+0x53>
  802623:	83 f8 04             	cmp    $0x4,%eax
  802626:	74 3b                	je     802663 <alloc_block+0x66>
  802628:	eb 4c                	jmp    802676 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	ff 75 08             	pushl  0x8(%ebp)
  802630:	e8 11 03 00 00       	call   802946 <alloc_block_FF>
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80263b:	eb 4a                	jmp    802687 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80263d:	83 ec 0c             	sub    $0xc,%esp
  802640:	ff 75 08             	pushl  0x8(%ebp)
  802643:	e8 fa 19 00 00       	call   804042 <alloc_block_NF>
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264e:	eb 37                	jmp    802687 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802650:	83 ec 0c             	sub    $0xc,%esp
  802653:	ff 75 08             	pushl  0x8(%ebp)
  802656:	e8 a7 07 00 00       	call   802e02 <alloc_block_BF>
  80265b:	83 c4 10             	add    $0x10,%esp
  80265e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802661:	eb 24                	jmp    802687 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802663:	83 ec 0c             	sub    $0xc,%esp
  802666:	ff 75 08             	pushl  0x8(%ebp)
  802669:	e8 b7 19 00 00       	call   804025 <alloc_block_WF>
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802674:	eb 11                	jmp    802687 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802676:	83 ec 0c             	sub    $0xc,%esp
  802679:	68 40 4b 80 00       	push   $0x804b40
  80267e:	e8 b0 e4 ff ff       	call   800b33 <cprintf>
  802683:	83 c4 10             	add    $0x10,%esp
		break;
  802686:	90                   	nop
	}
	return va;
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	53                   	push   %ebx
  802690:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802693:	83 ec 0c             	sub    $0xc,%esp
  802696:	68 60 4b 80 00       	push   $0x804b60
  80269b:	e8 93 e4 ff ff       	call   800b33 <cprintf>
  8026a0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	68 8b 4b 80 00       	push   $0x804b8b
  8026ab:	e8 83 e4 ff ff       	call   800b33 <cprintf>
  8026b0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b9:	eb 37                	jmp    8026f2 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c1:	e8 19 ff ff ff       	call   8025df <is_free_block>
  8026c6:	83 c4 10             	add    $0x10,%esp
  8026c9:	0f be d8             	movsbl %al,%ebx
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d2:	e8 ef fe ff ff       	call   8025c6 <get_block_size>
  8026d7:	83 c4 10             	add    $0x10,%esp
  8026da:	83 ec 04             	sub    $0x4,%esp
  8026dd:	53                   	push   %ebx
  8026de:	50                   	push   %eax
  8026df:	68 a3 4b 80 00       	push   $0x804ba3
  8026e4:	e8 4a e4 ff ff       	call   800b33 <cprintf>
  8026e9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f6:	74 07                	je     8026ff <print_blocks_list+0x73>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	eb 05                	jmp    802704 <print_blocks_list+0x78>
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802704:	89 45 10             	mov    %eax,0x10(%ebp)
  802707:	8b 45 10             	mov    0x10(%ebp),%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	75 ad                	jne    8026bb <print_blocks_list+0x2f>
  80270e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802712:	75 a7                	jne    8026bb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802714:	83 ec 0c             	sub    $0xc,%esp
  802717:	68 60 4b 80 00       	push   $0x804b60
  80271c:	e8 12 e4 ff ff       	call   800b33 <cprintf>
  802721:	83 c4 10             	add    $0x10,%esp

}
  802724:	90                   	nop
  802725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802730:	8b 45 0c             	mov    0xc(%ebp),%eax
  802733:	83 e0 01             	and    $0x1,%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 03                	je     80273d <initialize_dynamic_allocator+0x13>
  80273a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80273d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802741:	0f 84 c7 01 00 00    	je     80290e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802747:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80274e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802751:	8b 55 08             	mov    0x8(%ebp),%edx
  802754:	8b 45 0c             	mov    0xc(%ebp),%eax
  802757:	01 d0                	add    %edx,%eax
  802759:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80275e:	0f 87 ad 01 00 00    	ja     802911 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	0f 89 a5 01 00 00    	jns    802914 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80276f:	8b 55 08             	mov    0x8(%ebp),%edx
  802772:	8b 45 0c             	mov    0xc(%ebp),%eax
  802775:	01 d0                	add    %edx,%eax
  802777:	83 e8 04             	sub    $0x4,%eax
  80277a:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80277f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802786:	a1 30 50 80 00       	mov    0x805030,%eax
  80278b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278e:	e9 87 00 00 00       	jmp    80281a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802797:	75 14                	jne    8027ad <initialize_dynamic_allocator+0x83>
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	68 bb 4b 80 00       	push   $0x804bbb
  8027a1:	6a 79                	push   $0x79
  8027a3:	68 d9 4b 80 00       	push   $0x804bd9
  8027a8:	e8 c9 e0 ff ff       	call   800876 <_panic>
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 10                	je     8027c6 <initialize_dynamic_allocator+0x9c>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027be:	8b 52 04             	mov    0x4(%edx),%edx
  8027c1:	89 50 04             	mov    %edx,0x4(%eax)
  8027c4:	eb 0b                	jmp    8027d1 <initialize_dynamic_allocator+0xa7>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 40 04             	mov    0x4(%eax),%eax
  8027cc:	a3 34 50 80 00       	mov    %eax,0x805034
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0f                	je     8027ea <initialize_dynamic_allocator+0xc0>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e4:	8b 12                	mov    (%edx),%edx
  8027e6:	89 10                	mov    %edx,(%eax)
  8027e8:	eb 0a                	jmp    8027f4 <initialize_dynamic_allocator+0xca>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802807:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80280c:	48                   	dec    %eax
  80280d:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802812:	a1 38 50 80 00       	mov    0x805038,%eax
  802817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	74 07                	je     802827 <initialize_dynamic_allocator+0xfd>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	eb 05                	jmp    80282c <initialize_dynamic_allocator+0x102>
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
  80282c:	a3 38 50 80 00       	mov    %eax,0x805038
  802831:	a1 38 50 80 00       	mov    0x805038,%eax
  802836:	85 c0                	test   %eax,%eax
  802838:	0f 85 55 ff ff ff    	jne    802793 <initialize_dynamic_allocator+0x69>
  80283e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802842:	0f 85 4b ff ff ff    	jne    802793 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802857:	a1 48 50 80 00       	mov    0x805048,%eax
  80285c:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802861:	a1 44 50 80 00       	mov    0x805044,%eax
  802866:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	83 c0 08             	add    $0x8,%eax
  802872:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	83 c0 04             	add    $0x4,%eax
  80287b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287e:	83 ea 08             	sub    $0x8,%edx
  802881:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802883:	8b 55 0c             	mov    0xc(%ebp),%edx
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	01 d0                	add    %edx,%eax
  80288b:	83 e8 08             	sub    $0x8,%eax
  80288e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802891:	83 ea 08             	sub    $0x8,%edx
  802894:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028ad:	75 17                	jne    8028c6 <initialize_dynamic_allocator+0x19c>
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	68 f4 4b 80 00       	push   $0x804bf4
  8028b7:	68 90 00 00 00       	push   $0x90
  8028bc:	68 d9 4b 80 00       	push   $0x804bd9
  8028c1:	e8 b0 df ff ff       	call   800876 <_panic>
  8028c6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	89 10                	mov    %edx,(%eax)
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 0d                	je     8028e7 <initialize_dynamic_allocator+0x1bd>
  8028da:	a1 30 50 80 00       	mov    0x805030,%eax
  8028df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e2:	89 50 04             	mov    %edx,0x4(%eax)
  8028e5:	eb 08                	jmp    8028ef <initialize_dynamic_allocator+0x1c5>
  8028e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802901:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802906:	40                   	inc    %eax
  802907:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80290c:	eb 07                	jmp    802915 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80290e:	90                   	nop
  80290f:	eb 04                	jmp    802915 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802911:	90                   	nop
  802912:	eb 01                	jmp    802915 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802914:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80291a:	8b 45 10             	mov    0x10(%ebp),%eax
  80291d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8d 50 fc             	lea    -0x4(%eax),%edx
  802926:	8b 45 0c             	mov    0xc(%ebp),%eax
  802929:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	83 e8 04             	sub    $0x4,%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	83 e0 fe             	and    $0xfffffffe,%eax
  802936:	8d 50 f8             	lea    -0x8(%eax),%edx
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	01 c2                	add    %eax,%edx
  80293e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802941:	89 02                	mov    %eax,(%edx)
}
  802943:	90                   	nop
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    

00802946 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	83 e0 01             	and    $0x1,%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 03                	je     802959 <alloc_block_FF+0x13>
  802956:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802959:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80295d:	77 07                	ja     802966 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80295f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802966:	a1 28 50 80 00       	mov    0x805028,%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	75 73                	jne    8029e2 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	83 c0 10             	add    $0x10,%eax
  802975:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802978:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80297f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802985:	01 d0                	add    %edx,%eax
  802987:	48                   	dec    %eax
  802988:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80298b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298e:	ba 00 00 00 00       	mov    $0x0,%edx
  802993:	f7 75 ec             	divl   -0x14(%ebp)
  802996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802999:	29 d0                	sub    %edx,%eax
  80299b:	c1 e8 0c             	shr    $0xc,%eax
  80299e:	83 ec 0c             	sub    $0xc,%esp
  8029a1:	50                   	push   %eax
  8029a2:	e8 2e f1 ff ff       	call   801ad5 <sbrk>
  8029a7:	83 c4 10             	add    $0x10,%esp
  8029aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029ad:	83 ec 0c             	sub    $0xc,%esp
  8029b0:	6a 00                	push   $0x0
  8029b2:	e8 1e f1 ff ff       	call   801ad5 <sbrk>
  8029b7:	83 c4 10             	add    $0x10,%esp
  8029ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029c3:	83 ec 08             	sub    $0x8,%esp
  8029c6:	50                   	push   %eax
  8029c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029ca:	e8 5b fd ff ff       	call   80272a <initialize_dynamic_allocator>
  8029cf:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029d2:	83 ec 0c             	sub    $0xc,%esp
  8029d5:	68 17 4c 80 00       	push   $0x804c17
  8029da:	e8 54 e1 ff ff       	call   800b33 <cprintf>
  8029df:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e6:	75 0a                	jne    8029f2 <alloc_block_FF+0xac>
	        return NULL;
  8029e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ed:	e9 0e 04 00 00       	jmp    802e00 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029f9:	a1 30 50 80 00       	mov    0x805030,%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a01:	e9 f3 02 00 00       	jmp    802cf9 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	ff 75 bc             	pushl  -0x44(%ebp)
  802a12:	e8 af fb ff ff       	call   8025c6 <get_block_size>
  802a17:	83 c4 10             	add    $0x10,%esp
  802a1a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	83 c0 08             	add    $0x8,%eax
  802a23:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a26:	0f 87 c5 02 00 00    	ja     802cf1 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2f:	83 c0 18             	add    $0x18,%eax
  802a32:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a35:	0f 87 19 02 00 00    	ja     802c54 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802a41:	83 e8 08             	sub    $0x8,%eax
  802a44:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8d 50 08             	lea    0x8(%eax),%edx
  802a4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a50:	01 d0                	add    %edx,%eax
  802a52:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	83 c0 08             	add    $0x8,%eax
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	6a 01                	push   $0x1
  802a60:	50                   	push   %eax
  802a61:	ff 75 bc             	pushl  -0x44(%ebp)
  802a64:	e8 ae fe ff ff       	call   802917 <set_block_data>
  802a69:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	75 68                	jne    802ade <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a76:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a7a:	75 17                	jne    802a93 <alloc_block_FF+0x14d>
  802a7c:	83 ec 04             	sub    $0x4,%esp
  802a7f:	68 f4 4b 80 00       	push   $0x804bf4
  802a84:	68 d7 00 00 00       	push   $0xd7
  802a89:	68 d9 4b 80 00       	push   $0x804bd9
  802a8e:	e8 e3 dd ff ff       	call   800876 <_panic>
  802a93:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a9c:	89 10                	mov    %edx,(%eax)
  802a9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 0d                	je     802ab4 <alloc_block_FF+0x16e>
  802aa7:	a1 30 50 80 00       	mov    0x805030,%eax
  802aac:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 08                	jmp    802abc <alloc_block_FF+0x176>
  802ab4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab7:	a3 34 50 80 00       	mov    %eax,0x805034
  802abc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802abf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ace:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ad3:	40                   	inc    %eax
  802ad4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ad9:	e9 dc 00 00 00       	jmp    802bba <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	75 65                	jne    802b4c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ae7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aeb:	75 17                	jne    802b04 <alloc_block_FF+0x1be>
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	68 28 4c 80 00       	push   $0x804c28
  802af5:	68 db 00 00 00       	push   $0xdb
  802afa:	68 d9 4b 80 00       	push   $0x804bd9
  802aff:	e8 72 dd ff ff       	call   800876 <_panic>
  802b04:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0d:	89 50 04             	mov    %edx,0x4(%eax)
  802b10:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0c                	je     802b26 <alloc_block_FF+0x1e0>
  802b1a:	a1 34 50 80 00       	mov    0x805034,%eax
  802b1f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b22:	89 10                	mov    %edx,(%eax)
  802b24:	eb 08                	jmp    802b2e <alloc_block_FF+0x1e8>
  802b26:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b29:	a3 30 50 80 00       	mov    %eax,0x805030
  802b2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b31:	a3 34 50 80 00       	mov    %eax,0x805034
  802b36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b44:	40                   	inc    %eax
  802b45:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b4a:	eb 6e                	jmp    802bba <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b50:	74 06                	je     802b58 <alloc_block_FF+0x212>
  802b52:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b56:	75 17                	jne    802b6f <alloc_block_FF+0x229>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 4c 4c 80 00       	push   $0x804c4c
  802b60:	68 df 00 00 00       	push   $0xdf
  802b65:	68 d9 4b 80 00       	push   $0x804bd9
  802b6a:	e8 07 dd ff ff       	call   800876 <_panic>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 10                	mov    (%eax),%edx
  802b74:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0b                	je     802b8d <alloc_block_FF+0x247>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 08                	jne    802baf <alloc_block_FF+0x269>
  802ba7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802baa:	a3 34 50 80 00       	mov    %eax,0x805034
  802baf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bb4:	40                   	inc    %eax
  802bb5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbe:	75 17                	jne    802bd7 <alloc_block_FF+0x291>
  802bc0:	83 ec 04             	sub    $0x4,%esp
  802bc3:	68 bb 4b 80 00       	push   $0x804bbb
  802bc8:	68 e1 00 00 00       	push   $0xe1
  802bcd:	68 d9 4b 80 00       	push   $0x804bd9
  802bd2:	e8 9f dc ff ff       	call   800876 <_panic>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 10                	je     802bf0 <alloc_block_FF+0x2aa>
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be8:	8b 52 04             	mov    0x4(%edx),%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	eb 0b                	jmp    802bfb <alloc_block_FF+0x2b5>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	a3 34 50 80 00       	mov    %eax,0x805034
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	85 c0                	test   %eax,%eax
  802c03:	74 0f                	je     802c14 <alloc_block_FF+0x2ce>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0e:	8b 12                	mov    (%edx),%edx
  802c10:	89 10                	mov    %edx,(%eax)
  802c12:	eb 0a                	jmp    802c1e <alloc_block_FF+0x2d8>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	a3 30 50 80 00       	mov    %eax,0x805030
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c31:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c36:	48                   	dec    %eax
  802c37:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	6a 00                	push   $0x0
  802c41:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c44:	ff 75 b0             	pushl  -0x50(%ebp)
  802c47:	e8 cb fc ff ff       	call   802917 <set_block_data>
  802c4c:	83 c4 10             	add    $0x10,%esp
  802c4f:	e9 95 00 00 00       	jmp    802ce9 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	6a 01                	push   $0x1
  802c59:	ff 75 b8             	pushl  -0x48(%ebp)
  802c5c:	ff 75 bc             	pushl  -0x44(%ebp)
  802c5f:	e8 b3 fc ff ff       	call   802917 <set_block_data>
  802c64:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	75 17                	jne    802c84 <alloc_block_FF+0x33e>
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 bb 4b 80 00       	push   $0x804bbb
  802c75:	68 e8 00 00 00       	push   $0xe8
  802c7a:	68 d9 4b 80 00       	push   $0x804bd9
  802c7f:	e8 f2 db ff ff       	call   800876 <_panic>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 10                	je     802c9d <alloc_block_FF+0x357>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c95:	8b 52 04             	mov    0x4(%edx),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	eb 0b                	jmp    802ca8 <alloc_block_FF+0x362>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	a3 34 50 80 00       	mov    %eax,0x805034
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	74 0f                	je     802cc1 <alloc_block_FF+0x37b>
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbb:	8b 12                	mov    (%edx),%edx
  802cbd:	89 10                	mov    %edx,(%eax)
  802cbf:	eb 0a                	jmp    802ccb <alloc_block_FF+0x385>
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	a3 30 50 80 00       	mov    %eax,0x805030
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cde:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ce3:	48                   	dec    %eax
  802ce4:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802ce9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cec:	e9 0f 01 00 00       	jmp    802e00 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802cf1:	a1 38 50 80 00       	mov    0x805038,%eax
  802cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfd:	74 07                	je     802d06 <alloc_block_FF+0x3c0>
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	eb 05                	jmp    802d0b <alloc_block_FF+0x3c5>
  802d06:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0b:	a3 38 50 80 00       	mov    %eax,0x805038
  802d10:	a1 38 50 80 00       	mov    0x805038,%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	0f 85 e9 fc ff ff    	jne    802a06 <alloc_block_FF+0xc0>
  802d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d21:	0f 85 df fc ff ff    	jne    802a06 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	83 c0 08             	add    $0x8,%eax
  802d2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d30:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d3d:	01 d0                	add    %edx,%eax
  802d3f:	48                   	dec    %eax
  802d40:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d46:	ba 00 00 00 00       	mov    $0x0,%edx
  802d4b:	f7 75 d8             	divl   -0x28(%ebp)
  802d4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d51:	29 d0                	sub    %edx,%eax
  802d53:	c1 e8 0c             	shr    $0xc,%eax
  802d56:	83 ec 0c             	sub    $0xc,%esp
  802d59:	50                   	push   %eax
  802d5a:	e8 76 ed ff ff       	call   801ad5 <sbrk>
  802d5f:	83 c4 10             	add    $0x10,%esp
  802d62:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d65:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d69:	75 0a                	jne    802d75 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d70:	e9 8b 00 00 00       	jmp    802e00 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d75:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d82:	01 d0                	add    %edx,%eax
  802d84:	48                   	dec    %eax
  802d85:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d88:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d90:	f7 75 cc             	divl   -0x34(%ebp)
  802d93:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d96:	29 d0                	sub    %edx,%eax
  802d98:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d9e:	01 d0                	add    %edx,%eax
  802da0:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802da5:	a1 44 50 80 00       	mov    0x805044,%eax
  802daa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802db0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802db7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dbd:	01 d0                	add    %edx,%eax
  802dbf:	48                   	dec    %eax
  802dc0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  802dcb:	f7 75 c4             	divl   -0x3c(%ebp)
  802dce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dd1:	29 d0                	sub    %edx,%eax
  802dd3:	83 ec 04             	sub    $0x4,%esp
  802dd6:	6a 01                	push   $0x1
  802dd8:	50                   	push   %eax
  802dd9:	ff 75 d0             	pushl  -0x30(%ebp)
  802ddc:	e8 36 fb ff ff       	call   802917 <set_block_data>
  802de1:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802de4:	83 ec 0c             	sub    $0xc,%esp
  802de7:	ff 75 d0             	pushl  -0x30(%ebp)
  802dea:	e8 1b 0a 00 00       	call   80380a <free_block>
  802def:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802df2:	83 ec 0c             	sub    $0xc,%esp
  802df5:	ff 75 08             	pushl  0x8(%ebp)
  802df8:	e8 49 fb ff ff       	call   802946 <alloc_block_FF>
  802dfd:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e00:	c9                   	leave  
  802e01:	c3                   	ret    

00802e02 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e02:	55                   	push   %ebp
  802e03:	89 e5                	mov    %esp,%ebp
  802e05:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	83 e0 01             	and    $0x1,%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 03                	je     802e15 <alloc_block_BF+0x13>
  802e12:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e15:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e19:	77 07                	ja     802e22 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e1b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e22:	a1 28 50 80 00       	mov    0x805028,%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	75 73                	jne    802e9e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	83 c0 10             	add    $0x10,%eax
  802e31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e34:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e41:	01 d0                	add    %edx,%eax
  802e43:	48                   	dec    %eax
  802e44:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e4f:	f7 75 e0             	divl   -0x20(%ebp)
  802e52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e55:	29 d0                	sub    %edx,%eax
  802e57:	c1 e8 0c             	shr    $0xc,%eax
  802e5a:	83 ec 0c             	sub    $0xc,%esp
  802e5d:	50                   	push   %eax
  802e5e:	e8 72 ec ff ff       	call   801ad5 <sbrk>
  802e63:	83 c4 10             	add    $0x10,%esp
  802e66:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e69:	83 ec 0c             	sub    $0xc,%esp
  802e6c:	6a 00                	push   $0x0
  802e6e:	e8 62 ec ff ff       	call   801ad5 <sbrk>
  802e73:	83 c4 10             	add    $0x10,%esp
  802e76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e7f:	83 ec 08             	sub    $0x8,%esp
  802e82:	50                   	push   %eax
  802e83:	ff 75 d8             	pushl  -0x28(%ebp)
  802e86:	e8 9f f8 ff ff       	call   80272a <initialize_dynamic_allocator>
  802e8b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e8e:	83 ec 0c             	sub    $0xc,%esp
  802e91:	68 17 4c 80 00       	push   $0x804c17
  802e96:	e8 98 dc ff ff       	call   800b33 <cprintf>
  802e9b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ea5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802eac:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802eb3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802eba:	a1 30 50 80 00       	mov    0x805030,%eax
  802ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec2:	e9 1d 01 00 00       	jmp    802fe4 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ecd:	83 ec 0c             	sub    $0xc,%esp
  802ed0:	ff 75 a8             	pushl  -0x58(%ebp)
  802ed3:	e8 ee f6 ff ff       	call   8025c6 <get_block_size>
  802ed8:	83 c4 10             	add    $0x10,%esp
  802edb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	83 c0 08             	add    $0x8,%eax
  802ee4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ee7:	0f 87 ef 00 00 00    	ja     802fdc <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	83 c0 18             	add    $0x18,%eax
  802ef3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ef6:	77 1d                	ja     802f15 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802efe:	0f 86 d8 00 00 00    	jbe    802fdc <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f04:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f0a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f10:	e9 c7 00 00 00       	jmp    802fdc <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	83 c0 08             	add    $0x8,%eax
  802f1b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f1e:	0f 85 9d 00 00 00    	jne    802fc1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	6a 01                	push   $0x1
  802f29:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f2c:	ff 75 a8             	pushl  -0x58(%ebp)
  802f2f:	e8 e3 f9 ff ff       	call   802917 <set_block_data>
  802f34:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3b:	75 17                	jne    802f54 <alloc_block_BF+0x152>
  802f3d:	83 ec 04             	sub    $0x4,%esp
  802f40:	68 bb 4b 80 00       	push   $0x804bbb
  802f45:	68 2c 01 00 00       	push   $0x12c
  802f4a:	68 d9 4b 80 00       	push   $0x804bd9
  802f4f:	e8 22 d9 ff ff       	call   800876 <_panic>
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 10                	je     802f6d <alloc_block_BF+0x16b>
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f65:	8b 52 04             	mov    0x4(%edx),%edx
  802f68:	89 50 04             	mov    %edx,0x4(%eax)
  802f6b:	eb 0b                	jmp    802f78 <alloc_block_BF+0x176>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 40 04             	mov    0x4(%eax),%eax
  802f73:	a3 34 50 80 00       	mov    %eax,0x805034
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 0f                	je     802f91 <alloc_block_BF+0x18f>
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8b:	8b 12                	mov    (%edx),%edx
  802f8d:	89 10                	mov    %edx,(%eax)
  802f8f:	eb 0a                	jmp    802f9b <alloc_block_BF+0x199>
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fb3:	48                   	dec    %eax
  802fb4:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802fb9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fbc:	e9 24 04 00 00       	jmp    8033e5 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fc7:	76 13                	jbe    802fdc <alloc_block_BF+0x1da>
					{
						internal = 1;
  802fc9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802fd0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fd6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802fdc:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	74 07                	je     802ff1 <alloc_block_BF+0x1ef>
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	eb 05                	jmp    802ff6 <alloc_block_BF+0x1f4>
  802ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff6:	a3 38 50 80 00       	mov    %eax,0x805038
  802ffb:	a1 38 50 80 00       	mov    0x805038,%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	0f 85 bf fe ff ff    	jne    802ec7 <alloc_block_BF+0xc5>
  803008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300c:	0f 85 b5 fe ff ff    	jne    802ec7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803016:	0f 84 26 02 00 00    	je     803242 <alloc_block_BF+0x440>
  80301c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803020:	0f 85 1c 02 00 00    	jne    803242 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	2b 45 08             	sub    0x8(%ebp),%eax
  80302c:	83 e8 08             	sub    $0x8,%eax
  80302f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8d 50 08             	lea    0x8(%eax),%edx
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	01 d0                	add    %edx,%eax
  80303d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	83 c0 08             	add    $0x8,%eax
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	6a 01                	push   $0x1
  80304b:	50                   	push   %eax
  80304c:	ff 75 f0             	pushl  -0x10(%ebp)
  80304f:	e8 c3 f8 ff ff       	call   802917 <set_block_data>
  803054:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305a:	8b 40 04             	mov    0x4(%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	75 68                	jne    8030c9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803061:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803065:	75 17                	jne    80307e <alloc_block_BF+0x27c>
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	68 f4 4b 80 00       	push   $0x804bf4
  80306f:	68 45 01 00 00       	push   $0x145
  803074:	68 d9 4b 80 00       	push   $0x804bd9
  803079:	e8 f8 d7 ff ff       	call   800876 <_panic>
  80307e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803084:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803087:	89 10                	mov    %edx,(%eax)
  803089:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	74 0d                	je     80309f <alloc_block_BF+0x29d>
  803092:	a1 30 50 80 00       	mov    0x805030,%eax
  803097:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80309a:	89 50 04             	mov    %edx,0x4(%eax)
  80309d:	eb 08                	jmp    8030a7 <alloc_block_BF+0x2a5>
  80309f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a2:	a3 34 50 80 00       	mov    %eax,0x805034
  8030a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8030af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030be:	40                   	inc    %eax
  8030bf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030c4:	e9 dc 00 00 00       	jmp    8031a5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	75 65                	jne    803137 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030d6:	75 17                	jne    8030ef <alloc_block_BF+0x2ed>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 28 4c 80 00       	push   $0x804c28
  8030e0:	68 4a 01 00 00       	push   $0x14a
  8030e5:	68 d9 4b 80 00       	push   $0x804bd9
  8030ea:	e8 87 d7 ff ff       	call   800876 <_panic>
  8030ef:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f8:	89 50 04             	mov    %edx,0x4(%eax)
  8030fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 0c                	je     803111 <alloc_block_BF+0x30f>
  803105:	a1 34 50 80 00       	mov    0x805034,%eax
  80310a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80310d:	89 10                	mov    %edx,(%eax)
  80310f:	eb 08                	jmp    803119 <alloc_block_BF+0x317>
  803111:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803114:	a3 30 50 80 00       	mov    %eax,0x805030
  803119:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311c:	a3 34 50 80 00       	mov    %eax,0x805034
  803121:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80312f:	40                   	inc    %eax
  803130:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803135:	eb 6e                	jmp    8031a5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803137:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313b:	74 06                	je     803143 <alloc_block_BF+0x341>
  80313d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803141:	75 17                	jne    80315a <alloc_block_BF+0x358>
  803143:	83 ec 04             	sub    $0x4,%esp
  803146:	68 4c 4c 80 00       	push   $0x804c4c
  80314b:	68 4f 01 00 00       	push   $0x14f
  803150:	68 d9 4b 80 00       	push   $0x804bd9
  803155:	e8 1c d7 ff ff       	call   800876 <_panic>
  80315a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315d:	8b 10                	mov    (%eax),%edx
  80315f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803162:	89 10                	mov    %edx,(%eax)
  803164:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0b                	je     803178 <alloc_block_BF+0x376>
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803183:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803186:	89 50 04             	mov    %edx,0x4(%eax)
  803189:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	75 08                	jne    80319a <alloc_block_BF+0x398>
  803192:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803195:	a3 34 50 80 00       	mov    %eax,0x805034
  80319a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80319f:	40                   	inc    %eax
  8031a0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a9:	75 17                	jne    8031c2 <alloc_block_BF+0x3c0>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 bb 4b 80 00       	push   $0x804bbb
  8031b3:	68 51 01 00 00       	push   $0x151
  8031b8:	68 d9 4b 80 00       	push   $0x804bd9
  8031bd:	e8 b4 d6 ff ff       	call   800876 <_panic>
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 10                	je     8031db <alloc_block_BF+0x3d9>
  8031cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ce:	8b 00                	mov    (%eax),%eax
  8031d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d3:	8b 52 04             	mov    0x4(%edx),%edx
  8031d6:	89 50 04             	mov    %edx,0x4(%eax)
  8031d9:	eb 0b                	jmp    8031e6 <alloc_block_BF+0x3e4>
  8031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 0f                	je     8031ff <alloc_block_BF+0x3fd>
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 40 04             	mov    0x4(%eax),%eax
  8031f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f9:	8b 12                	mov    (%edx),%edx
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	eb 0a                	jmp    803209 <alloc_block_BF+0x407>
  8031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	a3 30 50 80 00       	mov    %eax,0x805030
  803209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803221:	48                   	dec    %eax
  803222:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	6a 00                	push   $0x0
  80322c:	ff 75 d0             	pushl  -0x30(%ebp)
  80322f:	ff 75 cc             	pushl  -0x34(%ebp)
  803232:	e8 e0 f6 ff ff       	call   802917 <set_block_data>
  803237:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	e9 a3 01 00 00       	jmp    8033e5 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803242:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803246:	0f 85 9d 00 00 00    	jne    8032e9 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80324c:	83 ec 04             	sub    $0x4,%esp
  80324f:	6a 01                	push   $0x1
  803251:	ff 75 ec             	pushl  -0x14(%ebp)
  803254:	ff 75 f0             	pushl  -0x10(%ebp)
  803257:	e8 bb f6 ff ff       	call   802917 <set_block_data>
  80325c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80325f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803263:	75 17                	jne    80327c <alloc_block_BF+0x47a>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 bb 4b 80 00       	push   $0x804bbb
  80326d:	68 58 01 00 00       	push   $0x158
  803272:	68 d9 4b 80 00       	push   $0x804bd9
  803277:	e8 fa d5 ff ff       	call   800876 <_panic>
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	85 c0                	test   %eax,%eax
  803283:	74 10                	je     803295 <alloc_block_BF+0x493>
  803285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328d:	8b 52 04             	mov    0x4(%edx),%edx
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	eb 0b                	jmp    8032a0 <alloc_block_BF+0x49e>
  803295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803298:	8b 40 04             	mov    0x4(%eax),%eax
  80329b:	a3 34 50 80 00       	mov    %eax,0x805034
  8032a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a3:	8b 40 04             	mov    0x4(%eax),%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 0f                	je     8032b9 <alloc_block_BF+0x4b7>
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8b 40 04             	mov    0x4(%eax),%eax
  8032b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b3:	8b 12                	mov    (%edx),%edx
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	eb 0a                	jmp    8032c3 <alloc_block_BF+0x4c1>
  8032b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032db:	48                   	dec    %eax
  8032dc:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8032e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e4:	e9 fc 00 00 00       	jmp    8033e5 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	83 c0 08             	add    $0x8,%eax
  8032ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032f2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032f9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032ff:	01 d0                	add    %edx,%eax
  803301:	48                   	dec    %eax
  803302:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803305:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803308:	ba 00 00 00 00       	mov    $0x0,%edx
  80330d:	f7 75 c4             	divl   -0x3c(%ebp)
  803310:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803313:	29 d0                	sub    %edx,%eax
  803315:	c1 e8 0c             	shr    $0xc,%eax
  803318:	83 ec 0c             	sub    $0xc,%esp
  80331b:	50                   	push   %eax
  80331c:	e8 b4 e7 ff ff       	call   801ad5 <sbrk>
  803321:	83 c4 10             	add    $0x10,%esp
  803324:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803327:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80332b:	75 0a                	jne    803337 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80332d:	b8 00 00 00 00       	mov    $0x0,%eax
  803332:	e9 ae 00 00 00       	jmp    8033e5 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803337:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80333e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803341:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803344:	01 d0                	add    %edx,%eax
  803346:	48                   	dec    %eax
  803347:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80334a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80334d:	ba 00 00 00 00       	mov    $0x0,%edx
  803352:	f7 75 b8             	divl   -0x48(%ebp)
  803355:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803358:	29 d0                	sub    %edx,%eax
  80335a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80335d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803360:	01 d0                	add    %edx,%eax
  803362:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803367:	a1 44 50 80 00       	mov    0x805044,%eax
  80336c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803372:	83 ec 0c             	sub    $0xc,%esp
  803375:	68 80 4c 80 00       	push   $0x804c80
  80337a:	e8 b4 d7 ff ff       	call   800b33 <cprintf>
  80337f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803382:	83 ec 08             	sub    $0x8,%esp
  803385:	ff 75 bc             	pushl  -0x44(%ebp)
  803388:	68 85 4c 80 00       	push   $0x804c85
  80338d:	e8 a1 d7 ff ff       	call   800b33 <cprintf>
  803392:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803395:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80339c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80339f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033a2:	01 d0                	add    %edx,%eax
  8033a4:	48                   	dec    %eax
  8033a5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033a8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8033b0:	f7 75 b0             	divl   -0x50(%ebp)
  8033b3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033b6:	29 d0                	sub    %edx,%eax
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	6a 01                	push   $0x1
  8033bd:	50                   	push   %eax
  8033be:	ff 75 bc             	pushl  -0x44(%ebp)
  8033c1:	e8 51 f5 ff ff       	call   802917 <set_block_data>
  8033c6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8033c9:	83 ec 0c             	sub    $0xc,%esp
  8033cc:	ff 75 bc             	pushl  -0x44(%ebp)
  8033cf:	e8 36 04 00 00       	call   80380a <free_block>
  8033d4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8033d7:	83 ec 0c             	sub    $0xc,%esp
  8033da:	ff 75 08             	pushl  0x8(%ebp)
  8033dd:	e8 20 fa ff ff       	call   802e02 <alloc_block_BF>
  8033e2:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8033e5:	c9                   	leave  
  8033e6:	c3                   	ret    

008033e7 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8033e7:	55                   	push   %ebp
  8033e8:	89 e5                	mov    %esp,%ebp
  8033ea:	53                   	push   %ebx
  8033eb:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803400:	74 1e                	je     803420 <merging+0x39>
  803402:	ff 75 08             	pushl  0x8(%ebp)
  803405:	e8 bc f1 ff ff       	call   8025c6 <get_block_size>
  80340a:	83 c4 04             	add    $0x4,%esp
  80340d:	89 c2                	mov    %eax,%edx
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	01 d0                	add    %edx,%eax
  803414:	3b 45 10             	cmp    0x10(%ebp),%eax
  803417:	75 07                	jne    803420 <merging+0x39>
		prev_is_free = 1;
  803419:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803424:	74 1e                	je     803444 <merging+0x5d>
  803426:	ff 75 10             	pushl  0x10(%ebp)
  803429:	e8 98 f1 ff ff       	call   8025c6 <get_block_size>
  80342e:	83 c4 04             	add    $0x4,%esp
  803431:	89 c2                	mov    %eax,%edx
  803433:	8b 45 10             	mov    0x10(%ebp),%eax
  803436:	01 d0                	add    %edx,%eax
  803438:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80343b:	75 07                	jne    803444 <merging+0x5d>
		next_is_free = 1;
  80343d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803448:	0f 84 cc 00 00 00    	je     80351a <merging+0x133>
  80344e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803452:	0f 84 c2 00 00 00    	je     80351a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803458:	ff 75 08             	pushl  0x8(%ebp)
  80345b:	e8 66 f1 ff ff       	call   8025c6 <get_block_size>
  803460:	83 c4 04             	add    $0x4,%esp
  803463:	89 c3                	mov    %eax,%ebx
  803465:	ff 75 10             	pushl  0x10(%ebp)
  803468:	e8 59 f1 ff ff       	call   8025c6 <get_block_size>
  80346d:	83 c4 04             	add    $0x4,%esp
  803470:	01 c3                	add    %eax,%ebx
  803472:	ff 75 0c             	pushl  0xc(%ebp)
  803475:	e8 4c f1 ff ff       	call   8025c6 <get_block_size>
  80347a:	83 c4 04             	add    $0x4,%esp
  80347d:	01 d8                	add    %ebx,%eax
  80347f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803482:	6a 00                	push   $0x0
  803484:	ff 75 ec             	pushl  -0x14(%ebp)
  803487:	ff 75 08             	pushl  0x8(%ebp)
  80348a:	e8 88 f4 ff ff       	call   802917 <set_block_data>
  80348f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803496:	75 17                	jne    8034af <merging+0xc8>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 bb 4b 80 00       	push   $0x804bbb
  8034a0:	68 7d 01 00 00       	push   $0x17d
  8034a5:	68 d9 4b 80 00       	push   $0x804bd9
  8034aa:	e8 c7 d3 ff ff       	call   800876 <_panic>
  8034af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b2:	8b 00                	mov    (%eax),%eax
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	74 10                	je     8034c8 <merging+0xe1>
  8034b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c0:	8b 52 04             	mov    0x4(%edx),%edx
  8034c3:	89 50 04             	mov    %edx,0x4(%eax)
  8034c6:	eb 0b                	jmp    8034d3 <merging+0xec>
  8034c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ce:	a3 34 50 80 00       	mov    %eax,0x805034
  8034d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	74 0f                	je     8034ec <merging+0x105>
  8034dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e0:	8b 40 04             	mov    0x4(%eax),%eax
  8034e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e6:	8b 12                	mov    (%edx),%edx
  8034e8:	89 10                	mov    %edx,(%eax)
  8034ea:	eb 0a                	jmp    8034f6 <merging+0x10f>
  8034ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803509:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80350e:	48                   	dec    %eax
  80350f:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803514:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803515:	e9 ea 02 00 00       	jmp    803804 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80351a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80351e:	74 3b                	je     80355b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803520:	83 ec 0c             	sub    $0xc,%esp
  803523:	ff 75 08             	pushl  0x8(%ebp)
  803526:	e8 9b f0 ff ff       	call   8025c6 <get_block_size>
  80352b:	83 c4 10             	add    $0x10,%esp
  80352e:	89 c3                	mov    %eax,%ebx
  803530:	83 ec 0c             	sub    $0xc,%esp
  803533:	ff 75 10             	pushl  0x10(%ebp)
  803536:	e8 8b f0 ff ff       	call   8025c6 <get_block_size>
  80353b:	83 c4 10             	add    $0x10,%esp
  80353e:	01 d8                	add    %ebx,%eax
  803540:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	6a 00                	push   $0x0
  803548:	ff 75 e8             	pushl  -0x18(%ebp)
  80354b:	ff 75 08             	pushl  0x8(%ebp)
  80354e:	e8 c4 f3 ff ff       	call   802917 <set_block_data>
  803553:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803556:	e9 a9 02 00 00       	jmp    803804 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80355b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80355f:	0f 84 2d 01 00 00    	je     803692 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803565:	83 ec 0c             	sub    $0xc,%esp
  803568:	ff 75 10             	pushl  0x10(%ebp)
  80356b:	e8 56 f0 ff ff       	call   8025c6 <get_block_size>
  803570:	83 c4 10             	add    $0x10,%esp
  803573:	89 c3                	mov    %eax,%ebx
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	ff 75 0c             	pushl  0xc(%ebp)
  80357b:	e8 46 f0 ff ff       	call   8025c6 <get_block_size>
  803580:	83 c4 10             	add    $0x10,%esp
  803583:	01 d8                	add    %ebx,%eax
  803585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803588:	83 ec 04             	sub    $0x4,%esp
  80358b:	6a 00                	push   $0x0
  80358d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803590:	ff 75 10             	pushl  0x10(%ebp)
  803593:	e8 7f f3 ff ff       	call   802917 <set_block_data>
  803598:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80359b:	8b 45 10             	mov    0x10(%ebp),%eax
  80359e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035a5:	74 06                	je     8035ad <merging+0x1c6>
  8035a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035ab:	75 17                	jne    8035c4 <merging+0x1dd>
  8035ad:	83 ec 04             	sub    $0x4,%esp
  8035b0:	68 94 4c 80 00       	push   $0x804c94
  8035b5:	68 8d 01 00 00       	push   $0x18d
  8035ba:	68 d9 4b 80 00       	push   $0x804bd9
  8035bf:	e8 b2 d2 ff ff       	call   800876 <_panic>
  8035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c7:	8b 50 04             	mov    0x4(%eax),%edx
  8035ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035db:	8b 40 04             	mov    0x4(%eax),%eax
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	74 0d                	je     8035ef <merging+0x208>
  8035e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e5:	8b 40 04             	mov    0x4(%eax),%eax
  8035e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	eb 08                	jmp    8035f7 <merging+0x210>
  8035ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035fd:	89 50 04             	mov    %edx,0x4(%eax)
  803600:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803605:	40                   	inc    %eax
  803606:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80360b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80360f:	75 17                	jne    803628 <merging+0x241>
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	68 bb 4b 80 00       	push   $0x804bbb
  803619:	68 8e 01 00 00       	push   $0x18e
  80361e:	68 d9 4b 80 00       	push   $0x804bd9
  803623:	e8 4e d2 ff ff       	call   800876 <_panic>
  803628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 10                	je     803641 <merging+0x25a>
  803631:	8b 45 0c             	mov    0xc(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	8b 55 0c             	mov    0xc(%ebp),%edx
  803639:	8b 52 04             	mov    0x4(%edx),%edx
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	eb 0b                	jmp    80364c <merging+0x265>
  803641:	8b 45 0c             	mov    0xc(%ebp),%eax
  803644:	8b 40 04             	mov    0x4(%eax),%eax
  803647:	a3 34 50 80 00       	mov    %eax,0x805034
  80364c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364f:	8b 40 04             	mov    0x4(%eax),%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	74 0f                	je     803665 <merging+0x27e>
  803656:	8b 45 0c             	mov    0xc(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80365f:	8b 12                	mov    (%edx),%edx
  803661:	89 10                	mov    %edx,(%eax)
  803663:	eb 0a                	jmp    80366f <merging+0x288>
  803665:	8b 45 0c             	mov    0xc(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	a3 30 50 80 00       	mov    %eax,0x805030
  80366f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803682:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803687:	48                   	dec    %eax
  803688:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80368d:	e9 72 01 00 00       	jmp    803804 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803692:	8b 45 10             	mov    0x10(%ebp),%eax
  803695:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803698:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80369c:	74 79                	je     803717 <merging+0x330>
  80369e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a2:	74 73                	je     803717 <merging+0x330>
  8036a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a8:	74 06                	je     8036b0 <merging+0x2c9>
  8036aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036ae:	75 17                	jne    8036c7 <merging+0x2e0>
  8036b0:	83 ec 04             	sub    $0x4,%esp
  8036b3:	68 4c 4c 80 00       	push   $0x804c4c
  8036b8:	68 94 01 00 00       	push   $0x194
  8036bd:	68 d9 4b 80 00       	push   $0x804bd9
  8036c2:	e8 af d1 ff ff       	call   800876 <_panic>
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	8b 10                	mov    (%eax),%edx
  8036cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036cf:	89 10                	mov    %edx,(%eax)
  8036d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	74 0b                	je     8036e5 <merging+0x2fe>
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036e2:	89 50 04             	mov    %edx,0x4(%eax)
  8036e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f3:	89 50 04             	mov    %edx,0x4(%eax)
  8036f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	75 08                	jne    803707 <merging+0x320>
  8036ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803702:	a3 34 50 80 00       	mov    %eax,0x805034
  803707:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80370c:	40                   	inc    %eax
  80370d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803712:	e9 ce 00 00 00       	jmp    8037e5 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803717:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80371b:	74 65                	je     803782 <merging+0x39b>
  80371d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803721:	75 17                	jne    80373a <merging+0x353>
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	68 28 4c 80 00       	push   $0x804c28
  80372b:	68 95 01 00 00       	push   $0x195
  803730:	68 d9 4b 80 00       	push   $0x804bd9
  803735:	e8 3c d1 ff ff       	call   800876 <_panic>
  80373a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803740:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803743:	89 50 04             	mov    %edx,0x4(%eax)
  803746:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803749:	8b 40 04             	mov    0x4(%eax),%eax
  80374c:	85 c0                	test   %eax,%eax
  80374e:	74 0c                	je     80375c <merging+0x375>
  803750:	a1 34 50 80 00       	mov    0x805034,%eax
  803755:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803758:	89 10                	mov    %edx,(%eax)
  80375a:	eb 08                	jmp    803764 <merging+0x37d>
  80375c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375f:	a3 30 50 80 00       	mov    %eax,0x805030
  803764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803767:	a3 34 50 80 00       	mov    %eax,0x805034
  80376c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803775:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80377a:	40                   	inc    %eax
  80377b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803780:	eb 63                	jmp    8037e5 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803782:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803786:	75 17                	jne    80379f <merging+0x3b8>
  803788:	83 ec 04             	sub    $0x4,%esp
  80378b:	68 f4 4b 80 00       	push   $0x804bf4
  803790:	68 98 01 00 00       	push   $0x198
  803795:	68 d9 4b 80 00       	push   $0x804bd9
  80379a:	e8 d7 d0 ff ff       	call   800876 <_panic>
  80379f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	74 0d                	je     8037c0 <merging+0x3d9>
  8037b3:	a1 30 50 80 00       	mov    0x805030,%eax
  8037b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	eb 08                	jmp    8037c8 <merging+0x3e1>
  8037c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c3:	a3 34 50 80 00       	mov    %eax,0x805034
  8037c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037da:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037df:	40                   	inc    %eax
  8037e0:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8037e5:	83 ec 0c             	sub    $0xc,%esp
  8037e8:	ff 75 10             	pushl  0x10(%ebp)
  8037eb:	e8 d6 ed ff ff       	call   8025c6 <get_block_size>
  8037f0:	83 c4 10             	add    $0x10,%esp
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	6a 00                	push   $0x0
  8037f8:	50                   	push   %eax
  8037f9:	ff 75 10             	pushl  0x10(%ebp)
  8037fc:	e8 16 f1 ff ff       	call   802917 <set_block_data>
  803801:	83 c4 10             	add    $0x10,%esp
	}
}
  803804:	90                   	nop
  803805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803808:	c9                   	leave  
  803809:	c3                   	ret    

0080380a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80380a:	55                   	push   %ebp
  80380b:	89 e5                	mov    %esp,%ebp
  80380d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803810:	a1 30 50 80 00       	mov    0x805030,%eax
  803815:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803818:	a1 34 50 80 00       	mov    0x805034,%eax
  80381d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803820:	73 1b                	jae    80383d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803822:	a1 34 50 80 00       	mov    0x805034,%eax
  803827:	83 ec 04             	sub    $0x4,%esp
  80382a:	ff 75 08             	pushl  0x8(%ebp)
  80382d:	6a 00                	push   $0x0
  80382f:	50                   	push   %eax
  803830:	e8 b2 fb ff ff       	call   8033e7 <merging>
  803835:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803838:	e9 8b 00 00 00       	jmp    8038c8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80383d:	a1 30 50 80 00       	mov    0x805030,%eax
  803842:	3b 45 08             	cmp    0x8(%ebp),%eax
  803845:	76 18                	jbe    80385f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803847:	a1 30 50 80 00       	mov    0x805030,%eax
  80384c:	83 ec 04             	sub    $0x4,%esp
  80384f:	ff 75 08             	pushl  0x8(%ebp)
  803852:	50                   	push   %eax
  803853:	6a 00                	push   $0x0
  803855:	e8 8d fb ff ff       	call   8033e7 <merging>
  80385a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80385d:	eb 69                	jmp    8038c8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80385f:	a1 30 50 80 00       	mov    0x805030,%eax
  803864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803867:	eb 39                	jmp    8038a2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80386f:	73 29                	jae    80389a <free_block+0x90>
  803871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	3b 45 08             	cmp    0x8(%ebp),%eax
  803879:	76 1f                	jbe    80389a <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	8b 00                	mov    (%eax),%eax
  803880:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803883:	83 ec 04             	sub    $0x4,%esp
  803886:	ff 75 08             	pushl  0x8(%ebp)
  803889:	ff 75 f0             	pushl  -0x10(%ebp)
  80388c:	ff 75 f4             	pushl  -0xc(%ebp)
  80388f:	e8 53 fb ff ff       	call   8033e7 <merging>
  803894:	83 c4 10             	add    $0x10,%esp
			break;
  803897:	90                   	nop
		}
	}
}
  803898:	eb 2e                	jmp    8038c8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80389a:	a1 38 50 80 00       	mov    0x805038,%eax
  80389f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a6:	74 07                	je     8038af <free_block+0xa5>
  8038a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	eb 05                	jmp    8038b4 <free_block+0xaa>
  8038af:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b4:	a3 38 50 80 00       	mov    %eax,0x805038
  8038b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038be:	85 c0                	test   %eax,%eax
  8038c0:	75 a7                	jne    803869 <free_block+0x5f>
  8038c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c6:	75 a1                	jne    803869 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038c8:	90                   	nop
  8038c9:	c9                   	leave  
  8038ca:	c3                   	ret    

008038cb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8038cb:	55                   	push   %ebp
  8038cc:	89 e5                	mov    %esp,%ebp
  8038ce:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038d1:	ff 75 08             	pushl  0x8(%ebp)
  8038d4:	e8 ed ec ff ff       	call   8025c6 <get_block_size>
  8038d9:	83 c4 04             	add    $0x4,%esp
  8038dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8038df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8038e6:	eb 17                	jmp    8038ff <copy_data+0x34>
  8038e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ee:	01 c2                	add    %eax,%edx
  8038f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8038f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f6:	01 c8                	add    %ecx,%eax
  8038f8:	8a 00                	mov    (%eax),%al
  8038fa:	88 02                	mov    %al,(%edx)
  8038fc:	ff 45 fc             	incl   -0x4(%ebp)
  8038ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803902:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803905:	72 e1                	jb     8038e8 <copy_data+0x1d>
}
  803907:	90                   	nop
  803908:	c9                   	leave  
  803909:	c3                   	ret    

0080390a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80390a:	55                   	push   %ebp
  80390b:	89 e5                	mov    %esp,%ebp
  80390d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803914:	75 23                	jne    803939 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803916:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80391a:	74 13                	je     80392f <realloc_block_FF+0x25>
  80391c:	83 ec 0c             	sub    $0xc,%esp
  80391f:	ff 75 0c             	pushl  0xc(%ebp)
  803922:	e8 1f f0 ff ff       	call   802946 <alloc_block_FF>
  803927:	83 c4 10             	add    $0x10,%esp
  80392a:	e9 f4 06 00 00       	jmp    804023 <realloc_block_FF+0x719>
		return NULL;
  80392f:	b8 00 00 00 00       	mov    $0x0,%eax
  803934:	e9 ea 06 00 00       	jmp    804023 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803939:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80393d:	75 18                	jne    803957 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80393f:	83 ec 0c             	sub    $0xc,%esp
  803942:	ff 75 08             	pushl  0x8(%ebp)
  803945:	e8 c0 fe ff ff       	call   80380a <free_block>
  80394a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80394d:	b8 00 00 00 00       	mov    $0x0,%eax
  803952:	e9 cc 06 00 00       	jmp    804023 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803957:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80395b:	77 07                	ja     803964 <realloc_block_FF+0x5a>
  80395d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803964:	8b 45 0c             	mov    0xc(%ebp),%eax
  803967:	83 e0 01             	and    $0x1,%eax
  80396a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80396d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803970:	83 c0 08             	add    $0x8,%eax
  803973:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803976:	83 ec 0c             	sub    $0xc,%esp
  803979:	ff 75 08             	pushl  0x8(%ebp)
  80397c:	e8 45 ec ff ff       	call   8025c6 <get_block_size>
  803981:	83 c4 10             	add    $0x10,%esp
  803984:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398a:	83 e8 08             	sub    $0x8,%eax
  80398d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	83 e8 04             	sub    $0x4,%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	83 e0 fe             	and    $0xfffffffe,%eax
  80399b:	89 c2                	mov    %eax,%edx
  80399d:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a0:	01 d0                	add    %edx,%eax
  8039a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039a5:	83 ec 0c             	sub    $0xc,%esp
  8039a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039ab:	e8 16 ec ff ff       	call   8025c6 <get_block_size>
  8039b0:	83 c4 10             	add    $0x10,%esp
  8039b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b9:	83 e8 08             	sub    $0x8,%eax
  8039bc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8039bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039c5:	75 08                	jne    8039cf <realloc_block_FF+0xc5>
	{
		 return va;
  8039c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ca:	e9 54 06 00 00       	jmp    804023 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8039cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039d5:	0f 83 e5 03 00 00    	jae    803dc0 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8039db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039de:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8039e4:	83 ec 0c             	sub    $0xc,%esp
  8039e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039ea:	e8 f0 eb ff ff       	call   8025df <is_free_block>
  8039ef:	83 c4 10             	add    $0x10,%esp
  8039f2:	84 c0                	test   %al,%al
  8039f4:	0f 84 3b 01 00 00    	je     803b35 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a00:	01 d0                	add    %edx,%eax
  803a02:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a05:	83 ec 04             	sub    $0x4,%esp
  803a08:	6a 01                	push   $0x1
  803a0a:	ff 75 f0             	pushl  -0x10(%ebp)
  803a0d:	ff 75 08             	pushl  0x8(%ebp)
  803a10:	e8 02 ef ff ff       	call   802917 <set_block_data>
  803a15:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a18:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1b:	83 e8 04             	sub    $0x4,%eax
  803a1e:	8b 00                	mov    (%eax),%eax
  803a20:	83 e0 fe             	and    $0xfffffffe,%eax
  803a23:	89 c2                	mov    %eax,%edx
  803a25:	8b 45 08             	mov    0x8(%ebp),%eax
  803a28:	01 d0                	add    %edx,%eax
  803a2a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a2d:	83 ec 04             	sub    $0x4,%esp
  803a30:	6a 00                	push   $0x0
  803a32:	ff 75 cc             	pushl  -0x34(%ebp)
  803a35:	ff 75 c8             	pushl  -0x38(%ebp)
  803a38:	e8 da ee ff ff       	call   802917 <set_block_data>
  803a3d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a44:	74 06                	je     803a4c <realloc_block_FF+0x142>
  803a46:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a4a:	75 17                	jne    803a63 <realloc_block_FF+0x159>
  803a4c:	83 ec 04             	sub    $0x4,%esp
  803a4f:	68 4c 4c 80 00       	push   $0x804c4c
  803a54:	68 f6 01 00 00       	push   $0x1f6
  803a59:	68 d9 4b 80 00       	push   $0x804bd9
  803a5e:	e8 13 ce ff ff       	call   800876 <_panic>
  803a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a66:	8b 10                	mov    (%eax),%edx
  803a68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a6b:	89 10                	mov    %edx,(%eax)
  803a6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	85 c0                	test   %eax,%eax
  803a74:	74 0b                	je     803a81 <realloc_block_FF+0x177>
  803a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a7e:	89 50 04             	mov    %edx,0x4(%eax)
  803a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a84:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a87:	89 10                	mov    %edx,(%eax)
  803a89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a8f:	89 50 04             	mov    %edx,0x4(%eax)
  803a92:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a95:	8b 00                	mov    (%eax),%eax
  803a97:	85 c0                	test   %eax,%eax
  803a99:	75 08                	jne    803aa3 <realloc_block_FF+0x199>
  803a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a9e:	a3 34 50 80 00       	mov    %eax,0x805034
  803aa3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aa8:	40                   	inc    %eax
  803aa9:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ab2:	75 17                	jne    803acb <realloc_block_FF+0x1c1>
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	68 bb 4b 80 00       	push   $0x804bbb
  803abc:	68 f7 01 00 00       	push   $0x1f7
  803ac1:	68 d9 4b 80 00       	push   $0x804bd9
  803ac6:	e8 ab cd ff ff       	call   800876 <_panic>
  803acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	85 c0                	test   %eax,%eax
  803ad2:	74 10                	je     803ae4 <realloc_block_FF+0x1da>
  803ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad7:	8b 00                	mov    (%eax),%eax
  803ad9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803adc:	8b 52 04             	mov    0x4(%edx),%edx
  803adf:	89 50 04             	mov    %edx,0x4(%eax)
  803ae2:	eb 0b                	jmp    803aef <realloc_block_FF+0x1e5>
  803ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae7:	8b 40 04             	mov    0x4(%eax),%eax
  803aea:	a3 34 50 80 00       	mov    %eax,0x805034
  803aef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af2:	8b 40 04             	mov    0x4(%eax),%eax
  803af5:	85 c0                	test   %eax,%eax
  803af7:	74 0f                	je     803b08 <realloc_block_FF+0x1fe>
  803af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afc:	8b 40 04             	mov    0x4(%eax),%eax
  803aff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b02:	8b 12                	mov    (%edx),%edx
  803b04:	89 10                	mov    %edx,(%eax)
  803b06:	eb 0a                	jmp    803b12 <realloc_block_FF+0x208>
  803b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0b:	8b 00                	mov    (%eax),%eax
  803b0d:	a3 30 50 80 00       	mov    %eax,0x805030
  803b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b25:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b2a:	48                   	dec    %eax
  803b2b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b30:	e9 83 02 00 00       	jmp    803db8 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b35:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b39:	0f 86 69 02 00 00    	jbe    803da8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b3f:	83 ec 04             	sub    $0x4,%esp
  803b42:	6a 01                	push   $0x1
  803b44:	ff 75 f0             	pushl  -0x10(%ebp)
  803b47:	ff 75 08             	pushl  0x8(%ebp)
  803b4a:	e8 c8 ed ff ff       	call   802917 <set_block_data>
  803b4f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b52:	8b 45 08             	mov    0x8(%ebp),%eax
  803b55:	83 e8 04             	sub    $0x4,%eax
  803b58:	8b 00                	mov    (%eax),%eax
  803b5a:	83 e0 fe             	and    $0xfffffffe,%eax
  803b5d:	89 c2                	mov    %eax,%edx
  803b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b62:	01 d0                	add    %edx,%eax
  803b64:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b67:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b6f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b73:	75 68                	jne    803bdd <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b79:	75 17                	jne    803b92 <realloc_block_FF+0x288>
  803b7b:	83 ec 04             	sub    $0x4,%esp
  803b7e:	68 f4 4b 80 00       	push   $0x804bf4
  803b83:	68 06 02 00 00       	push   $0x206
  803b88:	68 d9 4b 80 00       	push   $0x804bd9
  803b8d:	e8 e4 cc ff ff       	call   800876 <_panic>
  803b92:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b9b:	89 10                	mov    %edx,(%eax)
  803b9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba0:	8b 00                	mov    (%eax),%eax
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	74 0d                	je     803bb3 <realloc_block_FF+0x2a9>
  803ba6:	a1 30 50 80 00       	mov    0x805030,%eax
  803bab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bae:	89 50 04             	mov    %edx,0x4(%eax)
  803bb1:	eb 08                	jmp    803bbb <realloc_block_FF+0x2b1>
  803bb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb6:	a3 34 50 80 00       	mov    %eax,0x805034
  803bbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbe:	a3 30 50 80 00       	mov    %eax,0x805030
  803bc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bcd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bd2:	40                   	inc    %eax
  803bd3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bd8:	e9 b0 01 00 00       	jmp    803d8d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803bdd:	a1 30 50 80 00       	mov    0x805030,%eax
  803be2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803be5:	76 68                	jbe    803c4f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803be7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803beb:	75 17                	jne    803c04 <realloc_block_FF+0x2fa>
  803bed:	83 ec 04             	sub    $0x4,%esp
  803bf0:	68 f4 4b 80 00       	push   $0x804bf4
  803bf5:	68 0b 02 00 00       	push   $0x20b
  803bfa:	68 d9 4b 80 00       	push   $0x804bd9
  803bff:	e8 72 cc ff ff       	call   800876 <_panic>
  803c04:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0d:	89 10                	mov    %edx,(%eax)
  803c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c12:	8b 00                	mov    (%eax),%eax
  803c14:	85 c0                	test   %eax,%eax
  803c16:	74 0d                	je     803c25 <realloc_block_FF+0x31b>
  803c18:	a1 30 50 80 00       	mov    0x805030,%eax
  803c1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c20:	89 50 04             	mov    %edx,0x4(%eax)
  803c23:	eb 08                	jmp    803c2d <realloc_block_FF+0x323>
  803c25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c28:	a3 34 50 80 00       	mov    %eax,0x805034
  803c2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c30:	a3 30 50 80 00       	mov    %eax,0x805030
  803c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c44:	40                   	inc    %eax
  803c45:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c4a:	e9 3e 01 00 00       	jmp    803d8d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c4f:	a1 30 50 80 00       	mov    0x805030,%eax
  803c54:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c57:	73 68                	jae    803cc1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c59:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c5d:	75 17                	jne    803c76 <realloc_block_FF+0x36c>
  803c5f:	83 ec 04             	sub    $0x4,%esp
  803c62:	68 28 4c 80 00       	push   $0x804c28
  803c67:	68 10 02 00 00       	push   $0x210
  803c6c:	68 d9 4b 80 00       	push   $0x804bd9
  803c71:	e8 00 cc ff ff       	call   800876 <_panic>
  803c76:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7f:	89 50 04             	mov    %edx,0x4(%eax)
  803c82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c85:	8b 40 04             	mov    0x4(%eax),%eax
  803c88:	85 c0                	test   %eax,%eax
  803c8a:	74 0c                	je     803c98 <realloc_block_FF+0x38e>
  803c8c:	a1 34 50 80 00       	mov    0x805034,%eax
  803c91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c94:	89 10                	mov    %edx,(%eax)
  803c96:	eb 08                	jmp    803ca0 <realloc_block_FF+0x396>
  803c98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c9b:	a3 30 50 80 00       	mov    %eax,0x805030
  803ca0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca3:	a3 34 50 80 00       	mov    %eax,0x805034
  803ca8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cb1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cb6:	40                   	inc    %eax
  803cb7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803cbc:	e9 cc 00 00 00       	jmp    803d8d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803cc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803cc8:	a1 30 50 80 00       	mov    0x805030,%eax
  803ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd0:	e9 8a 00 00 00       	jmp    803d5f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cdb:	73 7a                	jae    803d57 <realloc_block_FF+0x44d>
  803cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce0:	8b 00                	mov    (%eax),%eax
  803ce2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ce5:	73 70                	jae    803d57 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ceb:	74 06                	je     803cf3 <realloc_block_FF+0x3e9>
  803ced:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cf1:	75 17                	jne    803d0a <realloc_block_FF+0x400>
  803cf3:	83 ec 04             	sub    $0x4,%esp
  803cf6:	68 4c 4c 80 00       	push   $0x804c4c
  803cfb:	68 1a 02 00 00       	push   $0x21a
  803d00:	68 d9 4b 80 00       	push   $0x804bd9
  803d05:	e8 6c cb ff ff       	call   800876 <_panic>
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	8b 10                	mov    (%eax),%edx
  803d0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d12:	89 10                	mov    %edx,(%eax)
  803d14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d17:	8b 00                	mov    (%eax),%eax
  803d19:	85 c0                	test   %eax,%eax
  803d1b:	74 0b                	je     803d28 <realloc_block_FF+0x41e>
  803d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d20:	8b 00                	mov    (%eax),%eax
  803d22:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d25:	89 50 04             	mov    %edx,0x4(%eax)
  803d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d2e:	89 10                	mov    %edx,(%eax)
  803d30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d36:	89 50 04             	mov    %edx,0x4(%eax)
  803d39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3c:	8b 00                	mov    (%eax),%eax
  803d3e:	85 c0                	test   %eax,%eax
  803d40:	75 08                	jne    803d4a <realloc_block_FF+0x440>
  803d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d45:	a3 34 50 80 00       	mov    %eax,0x805034
  803d4a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d4f:	40                   	inc    %eax
  803d50:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d55:	eb 36                	jmp    803d8d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d57:	a1 38 50 80 00       	mov    0x805038,%eax
  803d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d63:	74 07                	je     803d6c <realloc_block_FF+0x462>
  803d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d68:	8b 00                	mov    (%eax),%eax
  803d6a:	eb 05                	jmp    803d71 <realloc_block_FF+0x467>
  803d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d71:	a3 38 50 80 00       	mov    %eax,0x805038
  803d76:	a1 38 50 80 00       	mov    0x805038,%eax
  803d7b:	85 c0                	test   %eax,%eax
  803d7d:	0f 85 52 ff ff ff    	jne    803cd5 <realloc_block_FF+0x3cb>
  803d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d87:	0f 85 48 ff ff ff    	jne    803cd5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d8d:	83 ec 04             	sub    $0x4,%esp
  803d90:	6a 00                	push   $0x0
  803d92:	ff 75 d8             	pushl  -0x28(%ebp)
  803d95:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d98:	e8 7a eb ff ff       	call   802917 <set_block_data>
  803d9d:	83 c4 10             	add    $0x10,%esp
				return va;
  803da0:	8b 45 08             	mov    0x8(%ebp),%eax
  803da3:	e9 7b 02 00 00       	jmp    804023 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803da8:	83 ec 0c             	sub    $0xc,%esp
  803dab:	68 c9 4c 80 00       	push   $0x804cc9
  803db0:	e8 7e cd ff ff       	call   800b33 <cprintf>
  803db5:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803db8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dbb:	e9 63 02 00 00       	jmp    804023 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dc6:	0f 86 4d 02 00 00    	jbe    804019 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803dcc:	83 ec 0c             	sub    $0xc,%esp
  803dcf:	ff 75 e4             	pushl  -0x1c(%ebp)
  803dd2:	e8 08 e8 ff ff       	call   8025df <is_free_block>
  803dd7:	83 c4 10             	add    $0x10,%esp
  803dda:	84 c0                	test   %al,%al
  803ddc:	0f 84 37 02 00 00    	je     804019 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803de5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803de8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803deb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dee:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803df1:	76 38                	jbe    803e2b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803df3:	83 ec 0c             	sub    $0xc,%esp
  803df6:	ff 75 08             	pushl  0x8(%ebp)
  803df9:	e8 0c fa ff ff       	call   80380a <free_block>
  803dfe:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e01:	83 ec 0c             	sub    $0xc,%esp
  803e04:	ff 75 0c             	pushl  0xc(%ebp)
  803e07:	e8 3a eb ff ff       	call   802946 <alloc_block_FF>
  803e0c:	83 c4 10             	add    $0x10,%esp
  803e0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e12:	83 ec 08             	sub    $0x8,%esp
  803e15:	ff 75 c0             	pushl  -0x40(%ebp)
  803e18:	ff 75 08             	pushl  0x8(%ebp)
  803e1b:	e8 ab fa ff ff       	call   8038cb <copy_data>
  803e20:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e23:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e26:	e9 f8 01 00 00       	jmp    804023 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e2e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e31:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e34:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e38:	0f 87 a0 00 00 00    	ja     803ede <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e42:	75 17                	jne    803e5b <realloc_block_FF+0x551>
  803e44:	83 ec 04             	sub    $0x4,%esp
  803e47:	68 bb 4b 80 00       	push   $0x804bbb
  803e4c:	68 38 02 00 00       	push   $0x238
  803e51:	68 d9 4b 80 00       	push   $0x804bd9
  803e56:	e8 1b ca ff ff       	call   800876 <_panic>
  803e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e5e:	8b 00                	mov    (%eax),%eax
  803e60:	85 c0                	test   %eax,%eax
  803e62:	74 10                	je     803e74 <realloc_block_FF+0x56a>
  803e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e67:	8b 00                	mov    (%eax),%eax
  803e69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e6c:	8b 52 04             	mov    0x4(%edx),%edx
  803e6f:	89 50 04             	mov    %edx,0x4(%eax)
  803e72:	eb 0b                	jmp    803e7f <realloc_block_FF+0x575>
  803e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e77:	8b 40 04             	mov    0x4(%eax),%eax
  803e7a:	a3 34 50 80 00       	mov    %eax,0x805034
  803e7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e82:	8b 40 04             	mov    0x4(%eax),%eax
  803e85:	85 c0                	test   %eax,%eax
  803e87:	74 0f                	je     803e98 <realloc_block_FF+0x58e>
  803e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8c:	8b 40 04             	mov    0x4(%eax),%eax
  803e8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e92:	8b 12                	mov    (%edx),%edx
  803e94:	89 10                	mov    %edx,(%eax)
  803e96:	eb 0a                	jmp    803ea2 <realloc_block_FF+0x598>
  803e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9b:	8b 00                	mov    (%eax),%eax
  803e9d:	a3 30 50 80 00       	mov    %eax,0x805030
  803ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803eba:	48                   	dec    %eax
  803ebb:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ec0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ec6:	01 d0                	add    %edx,%eax
  803ec8:	83 ec 04             	sub    $0x4,%esp
  803ecb:	6a 01                	push   $0x1
  803ecd:	50                   	push   %eax
  803ece:	ff 75 08             	pushl  0x8(%ebp)
  803ed1:	e8 41 ea ff ff       	call   802917 <set_block_data>
  803ed6:	83 c4 10             	add    $0x10,%esp
  803ed9:	e9 36 01 00 00       	jmp    804014 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ede:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ee1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ee4:	01 d0                	add    %edx,%eax
  803ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803ee9:	83 ec 04             	sub    $0x4,%esp
  803eec:	6a 01                	push   $0x1
  803eee:	ff 75 f0             	pushl  -0x10(%ebp)
  803ef1:	ff 75 08             	pushl  0x8(%ebp)
  803ef4:	e8 1e ea ff ff       	call   802917 <set_block_data>
  803ef9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803efc:	8b 45 08             	mov    0x8(%ebp),%eax
  803eff:	83 e8 04             	sub    $0x4,%eax
  803f02:	8b 00                	mov    (%eax),%eax
  803f04:	83 e0 fe             	and    $0xfffffffe,%eax
  803f07:	89 c2                	mov    %eax,%edx
  803f09:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0c:	01 d0                	add    %edx,%eax
  803f0e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f15:	74 06                	je     803f1d <realloc_block_FF+0x613>
  803f17:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f1b:	75 17                	jne    803f34 <realloc_block_FF+0x62a>
  803f1d:	83 ec 04             	sub    $0x4,%esp
  803f20:	68 4c 4c 80 00       	push   $0x804c4c
  803f25:	68 44 02 00 00       	push   $0x244
  803f2a:	68 d9 4b 80 00       	push   $0x804bd9
  803f2f:	e8 42 c9 ff ff       	call   800876 <_panic>
  803f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f37:	8b 10                	mov    (%eax),%edx
  803f39:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f3c:	89 10                	mov    %edx,(%eax)
  803f3e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f41:	8b 00                	mov    (%eax),%eax
  803f43:	85 c0                	test   %eax,%eax
  803f45:	74 0b                	je     803f52 <realloc_block_FF+0x648>
  803f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4a:	8b 00                	mov    (%eax),%eax
  803f4c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f4f:	89 50 04             	mov    %edx,0x4(%eax)
  803f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f55:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f58:	89 10                	mov    %edx,(%eax)
  803f5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f60:	89 50 04             	mov    %edx,0x4(%eax)
  803f63:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f66:	8b 00                	mov    (%eax),%eax
  803f68:	85 c0                	test   %eax,%eax
  803f6a:	75 08                	jne    803f74 <realloc_block_FF+0x66a>
  803f6c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f6f:	a3 34 50 80 00       	mov    %eax,0x805034
  803f74:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f79:	40                   	inc    %eax
  803f7a:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f83:	75 17                	jne    803f9c <realloc_block_FF+0x692>
  803f85:	83 ec 04             	sub    $0x4,%esp
  803f88:	68 bb 4b 80 00       	push   $0x804bbb
  803f8d:	68 45 02 00 00       	push   $0x245
  803f92:	68 d9 4b 80 00       	push   $0x804bd9
  803f97:	e8 da c8 ff ff       	call   800876 <_panic>
  803f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9f:	8b 00                	mov    (%eax),%eax
  803fa1:	85 c0                	test   %eax,%eax
  803fa3:	74 10                	je     803fb5 <realloc_block_FF+0x6ab>
  803fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa8:	8b 00                	mov    (%eax),%eax
  803faa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fad:	8b 52 04             	mov    0x4(%edx),%edx
  803fb0:	89 50 04             	mov    %edx,0x4(%eax)
  803fb3:	eb 0b                	jmp    803fc0 <realloc_block_FF+0x6b6>
  803fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb8:	8b 40 04             	mov    0x4(%eax),%eax
  803fbb:	a3 34 50 80 00       	mov    %eax,0x805034
  803fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc3:	8b 40 04             	mov    0x4(%eax),%eax
  803fc6:	85 c0                	test   %eax,%eax
  803fc8:	74 0f                	je     803fd9 <realloc_block_FF+0x6cf>
  803fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcd:	8b 40 04             	mov    0x4(%eax),%eax
  803fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd3:	8b 12                	mov    (%edx),%edx
  803fd5:	89 10                	mov    %edx,(%eax)
  803fd7:	eb 0a                	jmp    803fe3 <realloc_block_FF+0x6d9>
  803fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdc:	8b 00                	mov    (%eax),%eax
  803fde:	a3 30 50 80 00       	mov    %eax,0x805030
  803fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ff6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ffb:	48                   	dec    %eax
  803ffc:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  804001:	83 ec 04             	sub    $0x4,%esp
  804004:	6a 00                	push   $0x0
  804006:	ff 75 bc             	pushl  -0x44(%ebp)
  804009:	ff 75 b8             	pushl  -0x48(%ebp)
  80400c:	e8 06 e9 ff ff       	call   802917 <set_block_data>
  804011:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804014:	8b 45 08             	mov    0x8(%ebp),%eax
  804017:	eb 0a                	jmp    804023 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804019:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804020:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804023:	c9                   	leave  
  804024:	c3                   	ret    

00804025 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804025:	55                   	push   %ebp
  804026:	89 e5                	mov    %esp,%ebp
  804028:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80402b:	83 ec 04             	sub    $0x4,%esp
  80402e:	68 d0 4c 80 00       	push   $0x804cd0
  804033:	68 58 02 00 00       	push   $0x258
  804038:	68 d9 4b 80 00       	push   $0x804bd9
  80403d:	e8 34 c8 ff ff       	call   800876 <_panic>

00804042 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804042:	55                   	push   %ebp
  804043:	89 e5                	mov    %esp,%ebp
  804045:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804048:	83 ec 04             	sub    $0x4,%esp
  80404b:	68 f8 4c 80 00       	push   $0x804cf8
  804050:	68 61 02 00 00       	push   $0x261
  804055:	68 d9 4b 80 00       	push   $0x804bd9
  80405a:	e8 17 c8 ff ff       	call   800876 <_panic>
  80405f:	90                   	nop

00804060 <__udivdi3>:
  804060:	55                   	push   %ebp
  804061:	57                   	push   %edi
  804062:	56                   	push   %esi
  804063:	53                   	push   %ebx
  804064:	83 ec 1c             	sub    $0x1c,%esp
  804067:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80406b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80406f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804073:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804077:	89 ca                	mov    %ecx,%edx
  804079:	89 f8                	mov    %edi,%eax
  80407b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80407f:	85 f6                	test   %esi,%esi
  804081:	75 2d                	jne    8040b0 <__udivdi3+0x50>
  804083:	39 cf                	cmp    %ecx,%edi
  804085:	77 65                	ja     8040ec <__udivdi3+0x8c>
  804087:	89 fd                	mov    %edi,%ebp
  804089:	85 ff                	test   %edi,%edi
  80408b:	75 0b                	jne    804098 <__udivdi3+0x38>
  80408d:	b8 01 00 00 00       	mov    $0x1,%eax
  804092:	31 d2                	xor    %edx,%edx
  804094:	f7 f7                	div    %edi
  804096:	89 c5                	mov    %eax,%ebp
  804098:	31 d2                	xor    %edx,%edx
  80409a:	89 c8                	mov    %ecx,%eax
  80409c:	f7 f5                	div    %ebp
  80409e:	89 c1                	mov    %eax,%ecx
  8040a0:	89 d8                	mov    %ebx,%eax
  8040a2:	f7 f5                	div    %ebp
  8040a4:	89 cf                	mov    %ecx,%edi
  8040a6:	89 fa                	mov    %edi,%edx
  8040a8:	83 c4 1c             	add    $0x1c,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5f                   	pop    %edi
  8040ae:	5d                   	pop    %ebp
  8040af:	c3                   	ret    
  8040b0:	39 ce                	cmp    %ecx,%esi
  8040b2:	77 28                	ja     8040dc <__udivdi3+0x7c>
  8040b4:	0f bd fe             	bsr    %esi,%edi
  8040b7:	83 f7 1f             	xor    $0x1f,%edi
  8040ba:	75 40                	jne    8040fc <__udivdi3+0x9c>
  8040bc:	39 ce                	cmp    %ecx,%esi
  8040be:	72 0a                	jb     8040ca <__udivdi3+0x6a>
  8040c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040c4:	0f 87 9e 00 00 00    	ja     804168 <__udivdi3+0x108>
  8040ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8040cf:	89 fa                	mov    %edi,%edx
  8040d1:	83 c4 1c             	add    $0x1c,%esp
  8040d4:	5b                   	pop    %ebx
  8040d5:	5e                   	pop    %esi
  8040d6:	5f                   	pop    %edi
  8040d7:	5d                   	pop    %ebp
  8040d8:	c3                   	ret    
  8040d9:	8d 76 00             	lea    0x0(%esi),%esi
  8040dc:	31 ff                	xor    %edi,%edi
  8040de:	31 c0                	xor    %eax,%eax
  8040e0:	89 fa                	mov    %edi,%edx
  8040e2:	83 c4 1c             	add    $0x1c,%esp
  8040e5:	5b                   	pop    %ebx
  8040e6:	5e                   	pop    %esi
  8040e7:	5f                   	pop    %edi
  8040e8:	5d                   	pop    %ebp
  8040e9:	c3                   	ret    
  8040ea:	66 90                	xchg   %ax,%ax
  8040ec:	89 d8                	mov    %ebx,%eax
  8040ee:	f7 f7                	div    %edi
  8040f0:	31 ff                	xor    %edi,%edi
  8040f2:	89 fa                	mov    %edi,%edx
  8040f4:	83 c4 1c             	add    $0x1c,%esp
  8040f7:	5b                   	pop    %ebx
  8040f8:	5e                   	pop    %esi
  8040f9:	5f                   	pop    %edi
  8040fa:	5d                   	pop    %ebp
  8040fb:	c3                   	ret    
  8040fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  804101:	89 eb                	mov    %ebp,%ebx
  804103:	29 fb                	sub    %edi,%ebx
  804105:	89 f9                	mov    %edi,%ecx
  804107:	d3 e6                	shl    %cl,%esi
  804109:	89 c5                	mov    %eax,%ebp
  80410b:	88 d9                	mov    %bl,%cl
  80410d:	d3 ed                	shr    %cl,%ebp
  80410f:	89 e9                	mov    %ebp,%ecx
  804111:	09 f1                	or     %esi,%ecx
  804113:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804117:	89 f9                	mov    %edi,%ecx
  804119:	d3 e0                	shl    %cl,%eax
  80411b:	89 c5                	mov    %eax,%ebp
  80411d:	89 d6                	mov    %edx,%esi
  80411f:	88 d9                	mov    %bl,%cl
  804121:	d3 ee                	shr    %cl,%esi
  804123:	89 f9                	mov    %edi,%ecx
  804125:	d3 e2                	shl    %cl,%edx
  804127:	8b 44 24 08          	mov    0x8(%esp),%eax
  80412b:	88 d9                	mov    %bl,%cl
  80412d:	d3 e8                	shr    %cl,%eax
  80412f:	09 c2                	or     %eax,%edx
  804131:	89 d0                	mov    %edx,%eax
  804133:	89 f2                	mov    %esi,%edx
  804135:	f7 74 24 0c          	divl   0xc(%esp)
  804139:	89 d6                	mov    %edx,%esi
  80413b:	89 c3                	mov    %eax,%ebx
  80413d:	f7 e5                	mul    %ebp
  80413f:	39 d6                	cmp    %edx,%esi
  804141:	72 19                	jb     80415c <__udivdi3+0xfc>
  804143:	74 0b                	je     804150 <__udivdi3+0xf0>
  804145:	89 d8                	mov    %ebx,%eax
  804147:	31 ff                	xor    %edi,%edi
  804149:	e9 58 ff ff ff       	jmp    8040a6 <__udivdi3+0x46>
  80414e:	66 90                	xchg   %ax,%ax
  804150:	8b 54 24 08          	mov    0x8(%esp),%edx
  804154:	89 f9                	mov    %edi,%ecx
  804156:	d3 e2                	shl    %cl,%edx
  804158:	39 c2                	cmp    %eax,%edx
  80415a:	73 e9                	jae    804145 <__udivdi3+0xe5>
  80415c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80415f:	31 ff                	xor    %edi,%edi
  804161:	e9 40 ff ff ff       	jmp    8040a6 <__udivdi3+0x46>
  804166:	66 90                	xchg   %ax,%ax
  804168:	31 c0                	xor    %eax,%eax
  80416a:	e9 37 ff ff ff       	jmp    8040a6 <__udivdi3+0x46>
  80416f:	90                   	nop

00804170 <__umoddi3>:
  804170:	55                   	push   %ebp
  804171:	57                   	push   %edi
  804172:	56                   	push   %esi
  804173:	53                   	push   %ebx
  804174:	83 ec 1c             	sub    $0x1c,%esp
  804177:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80417b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80417f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804183:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80418b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80418f:	89 f3                	mov    %esi,%ebx
  804191:	89 fa                	mov    %edi,%edx
  804193:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804197:	89 34 24             	mov    %esi,(%esp)
  80419a:	85 c0                	test   %eax,%eax
  80419c:	75 1a                	jne    8041b8 <__umoddi3+0x48>
  80419e:	39 f7                	cmp    %esi,%edi
  8041a0:	0f 86 a2 00 00 00    	jbe    804248 <__umoddi3+0xd8>
  8041a6:	89 c8                	mov    %ecx,%eax
  8041a8:	89 f2                	mov    %esi,%edx
  8041aa:	f7 f7                	div    %edi
  8041ac:	89 d0                	mov    %edx,%eax
  8041ae:	31 d2                	xor    %edx,%edx
  8041b0:	83 c4 1c             	add    $0x1c,%esp
  8041b3:	5b                   	pop    %ebx
  8041b4:	5e                   	pop    %esi
  8041b5:	5f                   	pop    %edi
  8041b6:	5d                   	pop    %ebp
  8041b7:	c3                   	ret    
  8041b8:	39 f0                	cmp    %esi,%eax
  8041ba:	0f 87 ac 00 00 00    	ja     80426c <__umoddi3+0xfc>
  8041c0:	0f bd e8             	bsr    %eax,%ebp
  8041c3:	83 f5 1f             	xor    $0x1f,%ebp
  8041c6:	0f 84 ac 00 00 00    	je     804278 <__umoddi3+0x108>
  8041cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8041d1:	29 ef                	sub    %ebp,%edi
  8041d3:	89 fe                	mov    %edi,%esi
  8041d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041d9:	89 e9                	mov    %ebp,%ecx
  8041db:	d3 e0                	shl    %cl,%eax
  8041dd:	89 d7                	mov    %edx,%edi
  8041df:	89 f1                	mov    %esi,%ecx
  8041e1:	d3 ef                	shr    %cl,%edi
  8041e3:	09 c7                	or     %eax,%edi
  8041e5:	89 e9                	mov    %ebp,%ecx
  8041e7:	d3 e2                	shl    %cl,%edx
  8041e9:	89 14 24             	mov    %edx,(%esp)
  8041ec:	89 d8                	mov    %ebx,%eax
  8041ee:	d3 e0                	shl    %cl,%eax
  8041f0:	89 c2                	mov    %eax,%edx
  8041f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041f6:	d3 e0                	shl    %cl,%eax
  8041f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  804200:	89 f1                	mov    %esi,%ecx
  804202:	d3 e8                	shr    %cl,%eax
  804204:	09 d0                	or     %edx,%eax
  804206:	d3 eb                	shr    %cl,%ebx
  804208:	89 da                	mov    %ebx,%edx
  80420a:	f7 f7                	div    %edi
  80420c:	89 d3                	mov    %edx,%ebx
  80420e:	f7 24 24             	mull   (%esp)
  804211:	89 c6                	mov    %eax,%esi
  804213:	89 d1                	mov    %edx,%ecx
  804215:	39 d3                	cmp    %edx,%ebx
  804217:	0f 82 87 00 00 00    	jb     8042a4 <__umoddi3+0x134>
  80421d:	0f 84 91 00 00 00    	je     8042b4 <__umoddi3+0x144>
  804223:	8b 54 24 04          	mov    0x4(%esp),%edx
  804227:	29 f2                	sub    %esi,%edx
  804229:	19 cb                	sbb    %ecx,%ebx
  80422b:	89 d8                	mov    %ebx,%eax
  80422d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804231:	d3 e0                	shl    %cl,%eax
  804233:	89 e9                	mov    %ebp,%ecx
  804235:	d3 ea                	shr    %cl,%edx
  804237:	09 d0                	or     %edx,%eax
  804239:	89 e9                	mov    %ebp,%ecx
  80423b:	d3 eb                	shr    %cl,%ebx
  80423d:	89 da                	mov    %ebx,%edx
  80423f:	83 c4 1c             	add    $0x1c,%esp
  804242:	5b                   	pop    %ebx
  804243:	5e                   	pop    %esi
  804244:	5f                   	pop    %edi
  804245:	5d                   	pop    %ebp
  804246:	c3                   	ret    
  804247:	90                   	nop
  804248:	89 fd                	mov    %edi,%ebp
  80424a:	85 ff                	test   %edi,%edi
  80424c:	75 0b                	jne    804259 <__umoddi3+0xe9>
  80424e:	b8 01 00 00 00       	mov    $0x1,%eax
  804253:	31 d2                	xor    %edx,%edx
  804255:	f7 f7                	div    %edi
  804257:	89 c5                	mov    %eax,%ebp
  804259:	89 f0                	mov    %esi,%eax
  80425b:	31 d2                	xor    %edx,%edx
  80425d:	f7 f5                	div    %ebp
  80425f:	89 c8                	mov    %ecx,%eax
  804261:	f7 f5                	div    %ebp
  804263:	89 d0                	mov    %edx,%eax
  804265:	e9 44 ff ff ff       	jmp    8041ae <__umoddi3+0x3e>
  80426a:	66 90                	xchg   %ax,%ax
  80426c:	89 c8                	mov    %ecx,%eax
  80426e:	89 f2                	mov    %esi,%edx
  804270:	83 c4 1c             	add    $0x1c,%esp
  804273:	5b                   	pop    %ebx
  804274:	5e                   	pop    %esi
  804275:	5f                   	pop    %edi
  804276:	5d                   	pop    %ebp
  804277:	c3                   	ret    
  804278:	3b 04 24             	cmp    (%esp),%eax
  80427b:	72 06                	jb     804283 <__umoddi3+0x113>
  80427d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804281:	77 0f                	ja     804292 <__umoddi3+0x122>
  804283:	89 f2                	mov    %esi,%edx
  804285:	29 f9                	sub    %edi,%ecx
  804287:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80428b:	89 14 24             	mov    %edx,(%esp)
  80428e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804292:	8b 44 24 04          	mov    0x4(%esp),%eax
  804296:	8b 14 24             	mov    (%esp),%edx
  804299:	83 c4 1c             	add    $0x1c,%esp
  80429c:	5b                   	pop    %ebx
  80429d:	5e                   	pop    %esi
  80429e:	5f                   	pop    %edi
  80429f:	5d                   	pop    %ebp
  8042a0:	c3                   	ret    
  8042a1:	8d 76 00             	lea    0x0(%esi),%esi
  8042a4:	2b 04 24             	sub    (%esp),%eax
  8042a7:	19 fa                	sbb    %edi,%edx
  8042a9:	89 d1                	mov    %edx,%ecx
  8042ab:	89 c6                	mov    %eax,%esi
  8042ad:	e9 71 ff ff ff       	jmp    804223 <__umoddi3+0xb3>
  8042b2:	66 90                	xchg   %ax,%ax
  8042b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042b8:	72 ea                	jb     8042a4 <__umoddi3+0x134>
  8042ba:	89 d9                	mov    %ebx,%ecx
  8042bc:	e9 62 ff ff ff       	jmp    804223 <__umoddi3+0xb3>
