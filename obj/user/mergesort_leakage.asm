
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
  800041:	e8 1c 21 00 00       	call   802162 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 44 80 00       	push   $0x804420
  80004e:	e8 e0 0a 00 00       	call   800b33 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 44 80 00       	push   $0x804422
  80005e:	e8 d0 0a 00 00       	call   800b33 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 44 80 00       	push   $0x804438
  80006e:	e8 c0 0a 00 00       	call   800b33 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 44 80 00       	push   $0x804422
  80007e:	e8 b0 0a 00 00       	call   800b33 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 44 80 00       	push   $0x804420
  80008e:	e8 a0 0a 00 00       	call   800b33 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 44 80 00       	push   $0x804450
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
  8000de:	68 70 44 80 00       	push   $0x804470
  8000e3:	e8 4b 0a 00 00       	call   800b33 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 92 44 80 00       	push   $0x804492
  8000f3:	e8 3b 0a 00 00       	call   800b33 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a0 44 80 00       	push   $0x8044a0
  800103:	e8 2b 0a 00 00       	call   800b33 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 af 44 80 00       	push   $0x8044af
  800113:	e8 1b 0a 00 00       	call   800b33 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 bf 44 80 00       	push   $0x8044bf
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
  800162:	e8 15 20 00 00       	call   80217c <sys_unlock_cons>
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
  8001d7:	e8 86 1f 00 00       	call   802162 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c8 44 80 00       	push   $0x8044c8
  8001e4:	e8 4a 09 00 00       	call   800b33 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 8b 1f 00 00       	call   80217c <sys_unlock_cons>
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
  80020e:	68 fc 44 80 00       	push   $0x8044fc
  800213:	6a 51                	push   $0x51
  800215:	68 1e 45 80 00       	push   $0x80451e
  80021a:	e8 57 06 00 00       	call   800876 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 3e 1f 00 00       	call   802162 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 38 45 80 00       	push   $0x804538
  80022c:	e8 02 09 00 00       	call   800b33 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 6c 45 80 00       	push   $0x80456c
  80023c:	e8 f2 08 00 00       	call   800b33 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 a0 45 80 00       	push   $0x8045a0
  80024c:	e8 e2 08 00 00       	call   800b33 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 23 1f 00 00       	call   80217c <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 04 1f 00 00       	call   802162 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 d2 45 80 00       	push   $0x8045d2
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
  8002b2:	e8 c5 1e 00 00       	call   80217c <sys_unlock_cons>
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
  800446:	68 20 44 80 00       	push   $0x804420
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
  800468:	68 f0 45 80 00       	push   $0x8045f0
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
  800496:	68 f5 45 80 00       	push   $0x8045f5
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
  80070f:	e8 99 1b 00 00       	call   8022ad <sys_cputc>
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
  800720:	e8 24 1a 00 00       	call   802149 <sys_cgetc>
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
  80073d:	e8 9c 1c 00 00       	call   8023de <sys_getenvindex>
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
  8007ab:	e8 b2 19 00 00       	call   802162 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 14 46 80 00       	push   $0x804614
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
  8007db:	68 3c 46 80 00       	push   $0x80463c
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
  80080c:	68 64 46 80 00       	push   $0x804664
  800811:	e8 1d 03 00 00       	call   800b33 <cprintf>
  800816:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800819:	a1 24 50 80 00       	mov    0x805024,%eax
  80081e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	50                   	push   %eax
  800828:	68 bc 46 80 00       	push   $0x8046bc
  80082d:	e8 01 03 00 00       	call   800b33 <cprintf>
  800832:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	68 14 46 80 00       	push   $0x804614
  80083d:	e8 f1 02 00 00       	call   800b33 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800845:	e8 32 19 00 00       	call   80217c <sys_unlock_cons>
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
  80085d:	e8 48 1b 00 00       	call   8023aa <sys_destroy_env>
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
  80086e:	e8 9d 1b 00 00       	call   802410 <sys_exit_env>
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
  800885:	a1 54 50 80 00       	mov    0x805054,%eax
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 16                	je     8008a4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80088e:	a1 54 50 80 00       	mov    0x805054,%eax
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	50                   	push   %eax
  800897:	68 d0 46 80 00       	push   $0x8046d0
  80089c:	e8 92 02 00 00       	call   800b33 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008a4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	ff 75 08             	pushl  0x8(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	68 d5 46 80 00       	push   $0x8046d5
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
  8008d4:	68 f1 46 80 00       	push   $0x8046f1
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
  800903:	68 f4 46 80 00       	push   $0x8046f4
  800908:	6a 26                	push   $0x26
  80090a:	68 40 47 80 00       	push   $0x804740
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
  8009d8:	68 4c 47 80 00       	push   $0x80474c
  8009dd:	6a 3a                	push   $0x3a
  8009df:	68 40 47 80 00       	push   $0x804740
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
  800a4b:	68 a0 47 80 00       	push   $0x8047a0
  800a50:	6a 44                	push   $0x44
  800a52:	68 40 47 80 00       	push   $0x804740
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
  800a8a:	a0 30 50 80 00       	mov    0x805030,%al
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
  800aa5:	e8 76 16 00 00       	call   802120 <sys_cputs>
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
  800aff:	a0 30 50 80 00       	mov    0x805030,%al
  800b04:	0f b6 c0             	movzbl %al,%eax
  800b07:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	50                   	push   %eax
  800b11:	52                   	push   %edx
  800b12:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b18:	83 c0 08             	add    $0x8,%eax
  800b1b:	50                   	push   %eax
  800b1c:	e8 ff 15 00 00       	call   802120 <sys_cputs>
  800b21:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b24:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
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
  800b39:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  800b66:	e8 f7 15 00 00       	call   802162 <sys_lock_cons>
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
  800b86:	e8 f1 15 00 00       	call   80217c <sys_unlock_cons>
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
  800bd0:	e8 e3 35 00 00       	call   8041b8 <__udivdi3>
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
  800c20:	e8 a3 36 00 00       	call   8042c8 <__umoddi3>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	05 14 4a 80 00       	add    $0x804a14,%eax
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
  800d7b:	8b 04 85 38 4a 80 00 	mov    0x804a38(,%eax,4),%eax
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
  800e5c:	8b 34 9d 80 48 80 00 	mov    0x804880(,%ebx,4),%esi
  800e63:	85 f6                	test   %esi,%esi
  800e65:	75 19                	jne    800e80 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e67:	53                   	push   %ebx
  800e68:	68 25 4a 80 00       	push   $0x804a25
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
  800e81:	68 2e 4a 80 00       	push   $0x804a2e
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
  800eae:	be 31 4a 80 00       	mov    $0x804a31,%esi
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
  8010a6:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
			break;
  8010ad:	eb 2c                	jmp    8010db <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010af:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  8011d9:	68 a8 4b 80 00       	push   $0x804ba8
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
  80121b:	68 ab 4b 80 00       	push   $0x804bab
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
  8012cc:	e8 91 0e 00 00       	call   802162 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d5:	74 13                	je     8012ea <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	68 a8 4b 80 00       	push   $0x804ba8
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
  80131f:	68 ab 4b 80 00       	push   $0x804bab
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
  8013c7:	e8 b0 0d 00 00       	call   80217c <sys_unlock_cons>
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
  801ac1:	68 bc 4b 80 00       	push   $0x804bbc
  801ac6:	68 3f 01 00 00       	push   $0x13f
  801acb:	68 de 4b 80 00       	push   $0x804bde
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
  801ae1:	e8 e5 0b 00 00       	call   8026cb <sys_sbrk>
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
  801b5c:	e8 ee 09 00 00       	call   80254f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	74 16                	je     801b7b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 2e 0f 00 00       	call   802a9e <alloc_block_FF>
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b76:	e9 8a 01 00 00       	jmp    801d05 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b7b:	e8 00 0a 00 00       	call   802580 <sys_isUHeapPlacementStrategyBESTFIT>
  801b80:	85 c0                	test   %eax,%eax
  801b82:	0f 84 7d 01 00 00    	je     801d05 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 c7 13 00 00       	call   802f5a <alloc_block_BF>
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
  801bde:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801c2b:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801c82:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801ce4:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801ceb:	83 ec 08             	sub    $0x8,%esp
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf4:	e8 09 0a 00 00       	call   802702 <sys_allocate_user_mem>
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
  801d3c:	e8 dd 09 00 00       	call   80271e <get_block_size>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 10 1c 00 00       	call   803962 <free_block>
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
  801d87:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801dc4:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801dcb:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	e8 07 09 00 00       	call   8026e6 <sys_free_user_mem>
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
  801df2:	68 ec 4b 80 00       	push   $0x804bec
  801df7:	68 88 00 00 00       	push   $0x88
  801dfc:	68 16 4c 80 00       	push   $0x804c16
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
  801e20:	e9 ec 00 00 00       	jmp    801f11 <smalloc+0x108>
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
  801e51:	75 0a                	jne    801e5d <smalloc+0x54>
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	e9 b4 00 00 00       	jmp    801f11 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e5d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e61:	ff 75 ec             	pushl  -0x14(%ebp)
  801e64:	50                   	push   %eax
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	ff 75 08             	pushl  0x8(%ebp)
  801e6b:	e8 7d 04 00 00       	call   8022ed <sys_createSharedObject>
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e76:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e7a:	74 06                	je     801e82 <smalloc+0x79>
  801e7c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e80:	75 0a                	jne    801e8c <smalloc+0x83>
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
  801e87:	e9 85 00 00 00       	jmp    801f11 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801e8c:	83 ec 08             	sub    $0x8,%esp
  801e8f:	ff 75 ec             	pushl  -0x14(%ebp)
  801e92:	68 22 4c 80 00       	push   $0x804c22
  801e97:	e8 97 ec ff ff       	call   800b33 <cprintf>
  801e9c:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801e9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea2:	a1 24 50 80 00       	mov    0x805024,%eax
  801ea7:	8b 40 78             	mov    0x78(%eax),%eax
  801eaa:	29 c2                	sub    %eax,%edx
  801eac:	89 d0                	mov    %edx,%eax
  801eae:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eb3:	c1 e8 0c             	shr    $0xc,%eax
  801eb6:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801ebc:	42                   	inc    %edx
  801ebd:	89 15 28 50 80 00    	mov    %edx,0x805028
  801ec3:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801ec9:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801ed0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed3:	a1 24 50 80 00       	mov    0x805024,%eax
  801ed8:	8b 40 78             	mov    0x78(%eax),%eax
  801edb:	29 c2                	sub    %eax,%edx
  801edd:	89 d0                	mov    %edx,%eax
  801edf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ee4:	c1 e8 0c             	shr    $0xc,%eax
  801ee7:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801eee:	a1 24 50 80 00       	mov    0x805024,%eax
  801ef3:	8b 50 10             	mov    0x10(%eax),%edx
  801ef6:	89 c8                	mov    %ecx,%eax
  801ef8:	c1 e0 02             	shl    $0x2,%eax
  801efb:	89 c1                	mov    %eax,%ecx
  801efd:	c1 e1 09             	shl    $0x9,%ecx
  801f00:	01 c8                	add    %ecx,%eax
  801f02:	01 c2                	add    %eax,%edx
  801f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f07:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	e8 f0 03 00 00       	call   802317 <sys_getSizeOfSharedObject>
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f2d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f31:	75 0a                	jne    801f3d <sget+0x2a>
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	e9 e7 00 00 00       	jmp    802024 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f43:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	39 d0                	cmp    %edx,%eax
  801f52:	73 02                	jae    801f56 <sget+0x43>
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	50                   	push   %eax
  801f5a:	e8 8c fb ff ff       	call   801aeb <malloc>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f69:	75 0a                	jne    801f75 <sget+0x62>
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f70:	e9 af 00 00 00       	jmp    802024 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	ff 75 e8             	pushl  -0x18(%ebp)
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	e8 ae 03 00 00       	call   802334 <sys_getSharedObject>
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f8f:	a1 24 50 80 00       	mov    0x805024,%eax
  801f94:	8b 40 78             	mov    0x78(%eax),%eax
  801f97:	29 c2                	sub    %eax,%edx
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fa0:	c1 e8 0c             	shr    $0xc,%eax
  801fa3:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801fa9:	42                   	inc    %edx
  801faa:	89 15 28 50 80 00    	mov    %edx,0x805028
  801fb0:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801fb6:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801fbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fc0:	a1 24 50 80 00       	mov    0x805024,%eax
  801fc5:	8b 40 78             	mov    0x78(%eax),%eax
  801fc8:	29 c2                	sub    %eax,%edx
  801fca:	89 d0                	mov    %edx,%eax
  801fcc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fd1:	c1 e8 0c             	shr    $0xc,%eax
  801fd4:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801fdb:	a1 24 50 80 00       	mov    0x805024,%eax
  801fe0:	8b 50 10             	mov    0x10(%eax),%edx
  801fe3:	89 c8                	mov    %ecx,%eax
  801fe5:	c1 e0 02             	shl    $0x2,%eax
  801fe8:	89 c1                	mov    %eax,%ecx
  801fea:	c1 e1 09             	shl    $0x9,%ecx
  801fed:	01 c8                	add    %ecx,%eax
  801fef:	01 c2                	add    %eax,%edx
  801ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801ffb:	a1 24 50 80 00       	mov    0x805024,%eax
  802000:	8b 40 10             	mov    0x10(%eax),%eax
  802003:	83 ec 08             	sub    $0x8,%esp
  802006:	50                   	push   %eax
  802007:	68 31 4c 80 00       	push   $0x804c31
  80200c:	e8 22 eb ff ff       	call   800b33 <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802014:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802018:	75 07                	jne    802021 <sget+0x10e>
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	eb 03                	jmp    802024 <sget+0x111>
	return ptr;
  802021:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80202c:	8b 55 08             	mov    0x8(%ebp),%edx
  80202f:	a1 24 50 80 00       	mov    0x805024,%eax
  802034:	8b 40 78             	mov    0x78(%eax),%eax
  802037:	29 c2                	sub    %eax,%edx
  802039:	89 d0                	mov    %edx,%eax
  80203b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802040:	c1 e8 0c             	shr    $0xc,%eax
  802043:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80204a:	a1 24 50 80 00       	mov    0x805024,%eax
  80204f:	8b 50 10             	mov    0x10(%eax),%edx
  802052:	89 c8                	mov    %ecx,%eax
  802054:	c1 e0 02             	shl    $0x2,%eax
  802057:	89 c1                	mov    %eax,%ecx
  802059:	c1 e1 09             	shl    $0x9,%ecx
  80205c:	01 c8                	add    %ecx,%eax
  80205e:	01 d0                	add    %edx,%eax
  802060:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802067:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80206a:	83 ec 08             	sub    $0x8,%esp
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	ff 75 f4             	pushl  -0xc(%ebp)
  802073:	e8 db 02 00 00       	call   802353 <sys_freeSharedObject>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	68 40 4c 80 00       	push   $0x804c40
  80208f:	68 e5 00 00 00       	push   $0xe5
  802094:	68 16 4c 80 00       	push   $0x804c16
  802099:	e8 d8 e7 ff ff       	call   800876 <_panic>

0080209e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020a4:	83 ec 04             	sub    $0x4,%esp
  8020a7:	68 66 4c 80 00       	push   $0x804c66
  8020ac:	68 f1 00 00 00       	push   $0xf1
  8020b1:	68 16 4c 80 00       	push   $0x804c16
  8020b6:	e8 bb e7 ff ff       	call   800876 <_panic>

008020bb <shrink>:

}
void shrink(uint32 newSize)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	68 66 4c 80 00       	push   $0x804c66
  8020c9:	68 f6 00 00 00       	push   $0xf6
  8020ce:	68 16 4c 80 00       	push   $0x804c16
  8020d3:	e8 9e e7 ff ff       	call   800876 <_panic>

008020d8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020de:	83 ec 04             	sub    $0x4,%esp
  8020e1:	68 66 4c 80 00       	push   $0x804c66
  8020e6:	68 fb 00 00 00       	push   $0xfb
  8020eb:	68 16 4c 80 00       	push   $0x804c16
  8020f0:	e8 81 e7 ff ff       	call   800876 <_panic>

008020f5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	57                   	push   %edi
  8020f9:	56                   	push   %esi
  8020fa:	53                   	push   %ebx
  8020fb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802107:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80210a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80210d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802110:	cd 30                	int    $0x30
  802112:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802115:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5f                   	pop    %edi
  80211e:	5d                   	pop    %ebp
  80211f:	c3                   	ret    

00802120 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	8b 45 10             	mov    0x10(%ebp),%eax
  802129:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80212c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	52                   	push   %edx
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	50                   	push   %eax
  80213c:	6a 00                	push   $0x0
  80213e:	e8 b2 ff ff ff       	call   8020f5 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	90                   	nop
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <sys_cgetc>:

int
sys_cgetc(void)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 02                	push   $0x2
  802158:	e8 98 ff ff ff       	call   8020f5 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 03                	push   $0x3
  802171:	e8 7f ff ff ff       	call   8020f5 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 04                	push   $0x4
  80218b:	e8 65 ff ff ff       	call   8020f5 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	90                   	nop
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	52                   	push   %edx
  8021a6:	50                   	push   %eax
  8021a7:	6a 08                	push   $0x8
  8021a9:	e8 47 ff ff ff       	call   8020f5 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8021bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	56                   	push   %esi
  8021c8:	53                   	push   %ebx
  8021c9:	51                   	push   %ecx
  8021ca:	52                   	push   %edx
  8021cb:	50                   	push   %eax
  8021cc:	6a 09                	push   $0x9
  8021ce:	e8 22 ff ff ff       	call   8020f5 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5d                   	pop    %ebp
  8021dc:	c3                   	ret    

008021dd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	52                   	push   %edx
  8021ed:	50                   	push   %eax
  8021ee:	6a 0a                	push   $0xa
  8021f0:	e8 00 ff ff ff       	call   8020f5 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 0b                	push   $0xb
  80220b:	e8 e5 fe ff ff       	call   8020f5 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 0c                	push   $0xc
  802224:	e8 cc fe ff ff       	call   8020f5 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 0d                	push   $0xd
  80223d:	e8 b3 fe ff ff       	call   8020f5 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 0e                	push   $0xe
  802256:	e8 9a fe ff ff       	call   8020f5 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 0f                	push   $0xf
  80226f:	e8 81 fe ff ff       	call   8020f5 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	6a 10                	push   $0x10
  802289:	e8 67 fe ff ff       	call   8020f5 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 11                	push   $0x11
  8022a2:	e8 4e fe ff ff       	call   8020f5 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_cputc>:

void
sys_cputc(const char c)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 04             	sub    $0x4,%esp
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	50                   	push   %eax
  8022c6:	6a 01                	push   $0x1
  8022c8:	e8 28 fe ff ff       	call   8020f5 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	90                   	nop
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 14                	push   $0x14
  8022e2:	e8 0e fe ff ff       	call   8020f5 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	6a 00                	push   $0x0
  802305:	51                   	push   %ecx
  802306:	52                   	push   %edx
  802307:	ff 75 0c             	pushl  0xc(%ebp)
  80230a:	50                   	push   %eax
  80230b:	6a 15                	push   $0x15
  80230d:	e8 e3 fd ff ff       	call   8020f5 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80231a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	52                   	push   %edx
  802327:	50                   	push   %eax
  802328:	6a 16                	push   $0x16
  80232a:	e8 c6 fd ff ff       	call   8020f5 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802337:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	51                   	push   %ecx
  802345:	52                   	push   %edx
  802346:	50                   	push   %eax
  802347:	6a 17                	push   $0x17
  802349:	e8 a7 fd ff ff       	call   8020f5 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802356:	8b 55 0c             	mov    0xc(%ebp),%edx
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	52                   	push   %edx
  802363:	50                   	push   %eax
  802364:	6a 18                	push   $0x18
  802366:	e8 8a fd ff ff       	call   8020f5 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	6a 00                	push   $0x0
  802378:	ff 75 14             	pushl  0x14(%ebp)
  80237b:	ff 75 10             	pushl  0x10(%ebp)
  80237e:	ff 75 0c             	pushl  0xc(%ebp)
  802381:	50                   	push   %eax
  802382:	6a 19                	push   $0x19
  802384:	e8 6c fd ff ff       	call   8020f5 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	50                   	push   %eax
  80239d:	6a 1a                	push   $0x1a
  80239f:	e8 51 fd ff ff       	call   8020f5 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	90                   	nop
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	50                   	push   %eax
  8023b9:	6a 1b                	push   $0x1b
  8023bb:	e8 35 fd ff ff       	call   8020f5 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 05                	push   $0x5
  8023d4:	e8 1c fd ff ff       	call   8020f5 <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 06                	push   $0x6
  8023ed:	e8 03 fd ff ff       	call   8020f5 <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 07                	push   $0x7
  802406:	e8 ea fc ff ff       	call   8020f5 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_exit_env>:


void sys_exit_env(void)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 1c                	push   $0x1c
  80241f:	e8 d1 fc ff ff       	call   8020f5 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	90                   	nop
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802430:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802433:	8d 50 04             	lea    0x4(%eax),%edx
  802436:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	52                   	push   %edx
  802440:	50                   	push   %eax
  802441:	6a 1d                	push   $0x1d
  802443:	e8 ad fc ff ff       	call   8020f5 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
	return result;
  80244b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80244e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802451:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802454:	89 01                	mov    %eax,(%ecx)
  802456:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	c9                   	leave  
  80245d:	c2 04 00             	ret    $0x4

00802460 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	ff 75 10             	pushl  0x10(%ebp)
  80246a:	ff 75 0c             	pushl  0xc(%ebp)
  80246d:	ff 75 08             	pushl  0x8(%ebp)
  802470:	6a 13                	push   $0x13
  802472:	e8 7e fc ff ff       	call   8020f5 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
	return ;
  80247a:	90                   	nop
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_rcr2>:
uint32 sys_rcr2()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 1e                	push   $0x1e
  80248c:	e8 64 fc ff ff       	call   8020f5 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024a2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	50                   	push   %eax
  8024af:	6a 1f                	push   $0x1f
  8024b1:	e8 3f fc ff ff       	call   8020f5 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b9:	90                   	nop
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <rsttst>:
void rsttst()
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 21                	push   $0x21
  8024cb:	e8 25 fc ff ff       	call   8020f5 <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d3:	90                   	nop
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 04             	sub    $0x4,%esp
  8024dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024e2:	8b 55 18             	mov    0x18(%ebp),%edx
  8024e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024e9:	52                   	push   %edx
  8024ea:	50                   	push   %eax
  8024eb:	ff 75 10             	pushl  0x10(%ebp)
  8024ee:	ff 75 0c             	pushl  0xc(%ebp)
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	6a 20                	push   $0x20
  8024f6:	e8 fa fb ff ff       	call   8020f5 <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024fe:	90                   	nop
}
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    

00802501 <chktst>:
void chktst(uint32 n)
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	ff 75 08             	pushl  0x8(%ebp)
  80250f:	6a 22                	push   $0x22
  802511:	e8 df fb ff ff       	call   8020f5 <syscall>
  802516:	83 c4 18             	add    $0x18,%esp
	return ;
  802519:	90                   	nop
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <inctst>:

void inctst()
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 23                	push   $0x23
  80252b:	e8 c5 fb ff ff       	call   8020f5 <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
	return ;
  802533:	90                   	nop
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <gettst>:
uint32 gettst()
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 24                	push   $0x24
  802545:	e8 ab fb ff ff       	call   8020f5 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
  802552:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 25                	push   $0x25
  802561:	e8 8f fb ff ff       	call   8020f5 <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
  802569:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80256c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802570:	75 07                	jne    802579 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802572:	b8 01 00 00 00       	mov    $0x1,%eax
  802577:	eb 05                	jmp    80257e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 25                	push   $0x25
  802592:	e8 5e fb ff ff       	call   8020f5 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
  80259a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80259d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025a1:	75 07                	jne    8025aa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a8:	eb 05                	jmp    8025af <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 25                	push   $0x25
  8025c3:	e8 2d fb ff ff       	call   8020f5 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
  8025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025ce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025d2:	75 07                	jne    8025db <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d9:	eb 05                	jmp    8025e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 25                	push   $0x25
  8025f4:	e8 fc fa ff ff       	call   8020f5 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
  8025fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802603:	75 07                	jne    80260c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802605:	b8 01 00 00 00       	mov    $0x1,%eax
  80260a:	eb 05                	jmp    802611 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	6a 26                	push   $0x26
  802623:	e8 cd fa ff ff       	call   8020f5 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return ;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802632:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802635:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	6a 00                	push   $0x0
  802640:	53                   	push   %ebx
  802641:	51                   	push   %ecx
  802642:	52                   	push   %edx
  802643:	50                   	push   %eax
  802644:	6a 27                	push   $0x27
  802646:	e8 aa fa ff ff       	call   8020f5 <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
}
  80264e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802656:	8b 55 0c             	mov    0xc(%ebp),%edx
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	52                   	push   %edx
  802663:	50                   	push   %eax
  802664:	6a 28                	push   $0x28
  802666:	e8 8a fa ff ff       	call   8020f5 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802673:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802676:	8b 55 0c             	mov    0xc(%ebp),%edx
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	6a 00                	push   $0x0
  80267e:	51                   	push   %ecx
  80267f:	ff 75 10             	pushl  0x10(%ebp)
  802682:	52                   	push   %edx
  802683:	50                   	push   %eax
  802684:	6a 29                	push   $0x29
  802686:	e8 6a fa ff ff       	call   8020f5 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	ff 75 10             	pushl  0x10(%ebp)
  80269a:	ff 75 0c             	pushl  0xc(%ebp)
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	6a 12                	push   $0x12
  8026a2:	e8 4e fa ff ff       	call   8020f5 <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026aa:	90                   	nop
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	52                   	push   %edx
  8026bd:	50                   	push   %eax
  8026be:	6a 2a                	push   $0x2a
  8026c0:	e8 30 fa ff ff       	call   8020f5 <syscall>
  8026c5:	83 c4 18             	add    $0x18,%esp
	return;
  8026c8:	90                   	nop
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	50                   	push   %eax
  8026da:	6a 2b                	push   $0x2b
  8026dc:	e8 14 fa ff ff       	call   8020f5 <syscall>
  8026e1:	83 c4 18             	add    $0x18,%esp
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	ff 75 0c             	pushl  0xc(%ebp)
  8026f2:	ff 75 08             	pushl  0x8(%ebp)
  8026f5:	6a 2c                	push   $0x2c
  8026f7:	e8 f9 f9 ff ff       	call   8020f5 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
	return;
  8026ff:	90                   	nop
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	ff 75 0c             	pushl  0xc(%ebp)
  80270e:	ff 75 08             	pushl  0x8(%ebp)
  802711:	6a 2d                	push   $0x2d
  802713:	e8 dd f9 ff ff       	call   8020f5 <syscall>
  802718:	83 c4 18             	add    $0x18,%esp
	return;
  80271b:	90                   	nop
}
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	83 e8 04             	sub    $0x4,%eax
  80272a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80272d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
  80273a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	83 e8 04             	sub    $0x4,%eax
  802743:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802746:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	83 e0 01             	and    $0x1,%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	0f 94 c0             	sete   %al
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80275b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802762:	8b 45 0c             	mov    0xc(%ebp),%eax
  802765:	83 f8 02             	cmp    $0x2,%eax
  802768:	74 2b                	je     802795 <alloc_block+0x40>
  80276a:	83 f8 02             	cmp    $0x2,%eax
  80276d:	7f 07                	jg     802776 <alloc_block+0x21>
  80276f:	83 f8 01             	cmp    $0x1,%eax
  802772:	74 0e                	je     802782 <alloc_block+0x2d>
  802774:	eb 58                	jmp    8027ce <alloc_block+0x79>
  802776:	83 f8 03             	cmp    $0x3,%eax
  802779:	74 2d                	je     8027a8 <alloc_block+0x53>
  80277b:	83 f8 04             	cmp    $0x4,%eax
  80277e:	74 3b                	je     8027bb <alloc_block+0x66>
  802780:	eb 4c                	jmp    8027ce <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802782:	83 ec 0c             	sub    $0xc,%esp
  802785:	ff 75 08             	pushl  0x8(%ebp)
  802788:	e8 11 03 00 00       	call   802a9e <alloc_block_FF>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802793:	eb 4a                	jmp    8027df <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802795:	83 ec 0c             	sub    $0xc,%esp
  802798:	ff 75 08             	pushl  0x8(%ebp)
  80279b:	e8 fa 19 00 00       	call   80419a <alloc_block_NF>
  8027a0:	83 c4 10             	add    $0x10,%esp
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a6:	eb 37                	jmp    8027df <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	ff 75 08             	pushl  0x8(%ebp)
  8027ae:	e8 a7 07 00 00       	call   802f5a <alloc_block_BF>
  8027b3:	83 c4 10             	add    $0x10,%esp
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b9:	eb 24                	jmp    8027df <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027bb:	83 ec 0c             	sub    $0xc,%esp
  8027be:	ff 75 08             	pushl  0x8(%ebp)
  8027c1:	e8 b7 19 00 00       	call   80417d <alloc_block_WF>
  8027c6:	83 c4 10             	add    $0x10,%esp
  8027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027cc:	eb 11                	jmp    8027df <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027ce:	83 ec 0c             	sub    $0xc,%esp
  8027d1:	68 78 4c 80 00       	push   $0x804c78
  8027d6:	e8 58 e3 ff ff       	call   800b33 <cprintf>
  8027db:	83 c4 10             	add    $0x10,%esp
		break;
  8027de:	90                   	nop
	}
	return va;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	53                   	push   %ebx
  8027e8:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	68 98 4c 80 00       	push   $0x804c98
  8027f3:	e8 3b e3 ff ff       	call   800b33 <cprintf>
  8027f8:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	68 c3 4c 80 00       	push   $0x804cc3
  802803:	e8 2b e3 ff ff       	call   800b33 <cprintf>
  802808:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802811:	eb 37                	jmp    80284a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	ff 75 f4             	pushl  -0xc(%ebp)
  802819:	e8 19 ff ff ff       	call   802737 <is_free_block>
  80281e:	83 c4 10             	add    $0x10,%esp
  802821:	0f be d8             	movsbl %al,%ebx
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	ff 75 f4             	pushl  -0xc(%ebp)
  80282a:	e8 ef fe ff ff       	call   80271e <get_block_size>
  80282f:	83 c4 10             	add    $0x10,%esp
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	53                   	push   %ebx
  802836:	50                   	push   %eax
  802837:	68 db 4c 80 00       	push   $0x804cdb
  80283c:	e8 f2 e2 ff ff       	call   800b33 <cprintf>
  802841:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802844:	8b 45 10             	mov    0x10(%ebp),%eax
  802847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	74 07                	je     802857 <print_blocks_list+0x73>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	eb 05                	jmp    80285c <print_blocks_list+0x78>
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
  80285c:	89 45 10             	mov    %eax,0x10(%ebp)
  80285f:	8b 45 10             	mov    0x10(%ebp),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	75 ad                	jne    802813 <print_blocks_list+0x2f>
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	75 a7                	jne    802813 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80286c:	83 ec 0c             	sub    $0xc,%esp
  80286f:	68 98 4c 80 00       	push   $0x804c98
  802874:	e8 ba e2 ff ff       	call   800b33 <cprintf>
  802879:	83 c4 10             	add    $0x10,%esp

}
  80287c:	90                   	nop
  80287d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802880:	c9                   	leave  
  802881:	c3                   	ret    

00802882 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
  802885:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288b:	83 e0 01             	and    $0x1,%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 03                	je     802895 <initialize_dynamic_allocator+0x13>
  802892:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802895:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802899:	0f 84 c7 01 00 00    	je     802a66 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80289f:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  8028a6:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8028a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028b6:	0f 87 ad 01 00 00    	ja     802a69 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	0f 89 a5 01 00 00    	jns    802a6c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cd:	01 d0                	add    %edx,%eax
  8028cf:	83 e8 04             	sub    $0x4,%eax
  8028d2:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  8028d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028de:	a1 34 50 80 00       	mov    0x805034,%eax
  8028e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e6:	e9 87 00 00 00       	jmp    802972 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ef:	75 14                	jne    802905 <initialize_dynamic_allocator+0x83>
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 f3 4c 80 00       	push   $0x804cf3
  8028f9:	6a 79                	push   $0x79
  8028fb:	68 11 4d 80 00       	push   $0x804d11
  802900:	e8 71 df ff ff       	call   800876 <_panic>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 10                	je     80291e <initialize_dynamic_allocator+0x9c>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802916:	8b 52 04             	mov    0x4(%edx),%edx
  802919:	89 50 04             	mov    %edx,0x4(%eax)
  80291c:	eb 0b                	jmp    802929 <initialize_dynamic_allocator+0xa7>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	a3 38 50 80 00       	mov    %eax,0x805038
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 0f                	je     802942 <initialize_dynamic_allocator+0xc0>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293c:	8b 12                	mov    (%edx),%edx
  80293e:	89 10                	mov    %edx,(%eax)
  802940:	eb 0a                	jmp    80294c <initialize_dynamic_allocator+0xca>
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	a3 34 50 80 00       	mov    %eax,0x805034
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295f:	a1 40 50 80 00       	mov    0x805040,%eax
  802964:	48                   	dec    %eax
  802965:	a3 40 50 80 00       	mov    %eax,0x805040
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80296a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	74 07                	je     80297f <initialize_dynamic_allocator+0xfd>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	eb 05                	jmp    802984 <initialize_dynamic_allocator+0x102>
  80297f:	b8 00 00 00 00       	mov    $0x0,%eax
  802984:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802989:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	0f 85 55 ff ff ff    	jne    8028eb <initialize_dynamic_allocator+0x69>
  802996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299a:	0f 85 4b ff ff ff    	jne    8028eb <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8029af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b4:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  8029b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8029be:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	83 c0 08             	add    $0x8,%eax
  8029ca:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	83 c0 04             	add    $0x4,%eax
  8029d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d6:	83 ea 08             	sub    $0x8,%edx
  8029d9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	83 e8 08             	sub    $0x8,%eax
  8029e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e9:	83 ea 08             	sub    $0x8,%edx
  8029ec:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a05:	75 17                	jne    802a1e <initialize_dynamic_allocator+0x19c>
  802a07:	83 ec 04             	sub    $0x4,%esp
  802a0a:	68 2c 4d 80 00       	push   $0x804d2c
  802a0f:	68 90 00 00 00       	push   $0x90
  802a14:	68 11 4d 80 00       	push   $0x804d11
  802a19:	e8 58 de ff ff       	call   800876 <_panic>
  802a1e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	89 10                	mov    %edx,(%eax)
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 0d                	je     802a3f <initialize_dynamic_allocator+0x1bd>
  802a32:	a1 34 50 80 00       	mov    0x805034,%eax
  802a37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a3a:	89 50 04             	mov    %edx,0x4(%eax)
  802a3d:	eb 08                	jmp    802a47 <initialize_dynamic_allocator+0x1c5>
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	a3 38 50 80 00       	mov    %eax,0x805038
  802a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4a:	a3 34 50 80 00       	mov    %eax,0x805034
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a59:	a1 40 50 80 00       	mov    0x805040,%eax
  802a5e:	40                   	inc    %eax
  802a5f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a64:	eb 07                	jmp    802a6d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a66:	90                   	nop
  802a67:	eb 04                	jmp    802a6d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a69:	90                   	nop
  802a6a:	eb 01                	jmp    802a6d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a6c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a6d:	c9                   	leave  
  802a6e:	c3                   	ret    

00802a6f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a6f:	55                   	push   %ebp
  802a70:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a72:	8b 45 10             	mov    0x10(%ebp),%eax
  802a75:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a81:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	83 e8 04             	sub    $0x4,%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	83 e0 fe             	and    $0xfffffffe,%eax
  802a8e:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	01 c2                	add    %eax,%edx
  802a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a99:	89 02                	mov    %eax,(%edx)
}
  802a9b:	90                   	nop
  802a9c:	5d                   	pop    %ebp
  802a9d:	c3                   	ret    

00802a9e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	83 e0 01             	and    $0x1,%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 03                	je     802ab1 <alloc_block_FF+0x13>
  802aae:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ab1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ab5:	77 07                	ja     802abe <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ab7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802abe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	75 73                	jne    802b3a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	83 c0 10             	add    $0x10,%eax
  802acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ad0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ad7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	01 d0                	add    %edx,%eax
  802adf:	48                   	dec    %eax
  802ae0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  802aeb:	f7 75 ec             	divl   -0x14(%ebp)
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	29 d0                	sub    %edx,%eax
  802af3:	c1 e8 0c             	shr    $0xc,%eax
  802af6:	83 ec 0c             	sub    $0xc,%esp
  802af9:	50                   	push   %eax
  802afa:	e8 d6 ef ff ff       	call   801ad5 <sbrk>
  802aff:	83 c4 10             	add    $0x10,%esp
  802b02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b05:	83 ec 0c             	sub    $0xc,%esp
  802b08:	6a 00                	push   $0x0
  802b0a:	e8 c6 ef ff ff       	call   801ad5 <sbrk>
  802b0f:	83 c4 10             	add    $0x10,%esp
  802b12:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b18:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b1b:	83 ec 08             	sub    $0x8,%esp
  802b1e:	50                   	push   %eax
  802b1f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b22:	e8 5b fd ff ff       	call   802882 <initialize_dynamic_allocator>
  802b27:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b2a:	83 ec 0c             	sub    $0xc,%esp
  802b2d:	68 4f 4d 80 00       	push   $0x804d4f
  802b32:	e8 fc df ff ff       	call   800b33 <cprintf>
  802b37:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3e:	75 0a                	jne    802b4a <alloc_block_FF+0xac>
	        return NULL;
  802b40:	b8 00 00 00 00       	mov    $0x0,%eax
  802b45:	e9 0e 04 00 00       	jmp    802f58 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b51:	a1 34 50 80 00       	mov    0x805034,%eax
  802b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b59:	e9 f3 02 00 00       	jmp    802e51 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b64:	83 ec 0c             	sub    $0xc,%esp
  802b67:	ff 75 bc             	pushl  -0x44(%ebp)
  802b6a:	e8 af fb ff ff       	call   80271e <get_block_size>
  802b6f:	83 c4 10             	add    $0x10,%esp
  802b72:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	83 c0 08             	add    $0x8,%eax
  802b7b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b7e:	0f 87 c5 02 00 00    	ja     802e49 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	83 c0 18             	add    $0x18,%eax
  802b8a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b8d:	0f 87 19 02 00 00    	ja     802dac <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b93:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b96:	2b 45 08             	sub    0x8(%ebp),%eax
  802b99:	83 e8 08             	sub    $0x8,%eax
  802b9c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8d 50 08             	lea    0x8(%eax),%edx
  802ba5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ba8:	01 d0                	add    %edx,%eax
  802baa:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	83 c0 08             	add    $0x8,%eax
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	6a 01                	push   $0x1
  802bb8:	50                   	push   %eax
  802bb9:	ff 75 bc             	pushl  -0x44(%ebp)
  802bbc:	e8 ae fe ff ff       	call   802a6f <set_block_data>
  802bc1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	75 68                	jne    802c36 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bce:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bd2:	75 17                	jne    802beb <alloc_block_FF+0x14d>
  802bd4:	83 ec 04             	sub    $0x4,%esp
  802bd7:	68 2c 4d 80 00       	push   $0x804d2c
  802bdc:	68 d7 00 00 00       	push   $0xd7
  802be1:	68 11 4d 80 00       	push   $0x804d11
  802be6:	e8 8b dc ff ff       	call   800876 <_panic>
  802beb:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802bf1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf4:	89 10                	mov    %edx,(%eax)
  802bf6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0d                	je     802c0c <alloc_block_FF+0x16e>
  802bff:	a1 34 50 80 00       	mov    0x805034,%eax
  802c04:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c07:	89 50 04             	mov    %edx,0x4(%eax)
  802c0a:	eb 08                	jmp    802c14 <alloc_block_FF+0x176>
  802c0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0f:	a3 38 50 80 00       	mov    %eax,0x805038
  802c14:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c17:	a3 34 50 80 00       	mov    %eax,0x805034
  802c1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c26:	a1 40 50 80 00       	mov    0x805040,%eax
  802c2b:	40                   	inc    %eax
  802c2c:	a3 40 50 80 00       	mov    %eax,0x805040
  802c31:	e9 dc 00 00 00       	jmp    802d12 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	75 65                	jne    802ca4 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c3f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c43:	75 17                	jne    802c5c <alloc_block_FF+0x1be>
  802c45:	83 ec 04             	sub    $0x4,%esp
  802c48:	68 60 4d 80 00       	push   $0x804d60
  802c4d:	68 db 00 00 00       	push   $0xdb
  802c52:	68 11 4d 80 00       	push   $0x804d11
  802c57:	e8 1a dc ff ff       	call   800876 <_panic>
  802c5c:	8b 15 38 50 80 00    	mov    0x805038,%edx
  802c62:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c65:	89 50 04             	mov    %edx,0x4(%eax)
  802c68:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0c                	je     802c7e <alloc_block_FF+0x1e0>
  802c72:	a1 38 50 80 00       	mov    0x805038,%eax
  802c77:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c7a:	89 10                	mov    %edx,(%eax)
  802c7c:	eb 08                	jmp    802c86 <alloc_block_FF+0x1e8>
  802c7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c81:	a3 34 50 80 00       	mov    %eax,0x805034
  802c86:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c89:	a3 38 50 80 00       	mov    %eax,0x805038
  802c8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c97:	a1 40 50 80 00       	mov    0x805040,%eax
  802c9c:	40                   	inc    %eax
  802c9d:	a3 40 50 80 00       	mov    %eax,0x805040
  802ca2:	eb 6e                	jmp    802d12 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802ca4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca8:	74 06                	je     802cb0 <alloc_block_FF+0x212>
  802caa:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cae:	75 17                	jne    802cc7 <alloc_block_FF+0x229>
  802cb0:	83 ec 04             	sub    $0x4,%esp
  802cb3:	68 84 4d 80 00       	push   $0x804d84
  802cb8:	68 df 00 00 00       	push   $0xdf
  802cbd:	68 11 4d 80 00       	push   $0x804d11
  802cc2:	e8 af db ff ff       	call   800876 <_panic>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 10                	mov    (%eax),%edx
  802ccc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ccf:	89 10                	mov    %edx,(%eax)
  802cd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 0b                	je     802ce5 <alloc_block_FF+0x247>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ce2:	89 50 04             	mov    %edx,0x4(%eax)
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ceb:	89 10                	mov    %edx,(%eax)
  802ced:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf3:	89 50 04             	mov    %edx,0x4(%eax)
  802cf6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	75 08                	jne    802d07 <alloc_block_FF+0x269>
  802cff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d02:	a3 38 50 80 00       	mov    %eax,0x805038
  802d07:	a1 40 50 80 00       	mov    0x805040,%eax
  802d0c:	40                   	inc    %eax
  802d0d:	a3 40 50 80 00       	mov    %eax,0x805040
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d16:	75 17                	jne    802d2f <alloc_block_FF+0x291>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 f3 4c 80 00       	push   $0x804cf3
  802d20:	68 e1 00 00 00       	push   $0xe1
  802d25:	68 11 4d 80 00       	push   $0x804d11
  802d2a:	e8 47 db ff ff       	call   800876 <_panic>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 10                	je     802d48 <alloc_block_FF+0x2aa>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d40:	8b 52 04             	mov    0x4(%edx),%edx
  802d43:	89 50 04             	mov    %edx,0x4(%eax)
  802d46:	eb 0b                	jmp    802d53 <alloc_block_FF+0x2b5>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	a3 38 50 80 00       	mov    %eax,0x805038
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 40 04             	mov    0x4(%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 0f                	je     802d6c <alloc_block_FF+0x2ce>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d66:	8b 12                	mov    (%edx),%edx
  802d68:	89 10                	mov    %edx,(%eax)
  802d6a:	eb 0a                	jmp    802d76 <alloc_block_FF+0x2d8>
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	a3 34 50 80 00       	mov    %eax,0x805034
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d89:	a1 40 50 80 00       	mov    0x805040,%eax
  802d8e:	48                   	dec    %eax
  802d8f:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(new_block_va, remaining_size, 0);
  802d94:	83 ec 04             	sub    $0x4,%esp
  802d97:	6a 00                	push   $0x0
  802d99:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d9c:	ff 75 b0             	pushl  -0x50(%ebp)
  802d9f:	e8 cb fc ff ff       	call   802a6f <set_block_data>
  802da4:	83 c4 10             	add    $0x10,%esp
  802da7:	e9 95 00 00 00       	jmp    802e41 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	6a 01                	push   $0x1
  802db1:	ff 75 b8             	pushl  -0x48(%ebp)
  802db4:	ff 75 bc             	pushl  -0x44(%ebp)
  802db7:	e8 b3 fc ff ff       	call   802a6f <set_block_data>
  802dbc:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	75 17                	jne    802ddc <alloc_block_FF+0x33e>
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	68 f3 4c 80 00       	push   $0x804cf3
  802dcd:	68 e8 00 00 00       	push   $0xe8
  802dd2:	68 11 4d 80 00       	push   $0x804d11
  802dd7:	e8 9a da ff ff       	call   800876 <_panic>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 10                	je     802df5 <alloc_block_FF+0x357>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ded:	8b 52 04             	mov    0x4(%edx),%edx
  802df0:	89 50 04             	mov    %edx,0x4(%eax)
  802df3:	eb 0b                	jmp    802e00 <alloc_block_FF+0x362>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	a3 38 50 80 00       	mov    %eax,0x805038
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0f                	je     802e19 <alloc_block_FF+0x37b>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e13:	8b 12                	mov    (%edx),%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	eb 0a                	jmp    802e23 <alloc_block_FF+0x385>
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	a3 34 50 80 00       	mov    %eax,0x805034
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e36:	a1 40 50 80 00       	mov    0x805040,%eax
  802e3b:	48                   	dec    %eax
  802e3c:	a3 40 50 80 00       	mov    %eax,0x805040
	            }
	            return va;
  802e41:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e44:	e9 0f 01 00 00       	jmp    802f58 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e49:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	74 07                	je     802e5e <alloc_block_FF+0x3c0>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	eb 05                	jmp    802e63 <alloc_block_FF+0x3c5>
  802e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e63:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802e68:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	0f 85 e9 fc ff ff    	jne    802b5e <alloc_block_FF+0xc0>
  802e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e79:	0f 85 df fc ff ff    	jne    802b5e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	83 c0 08             	add    $0x8,%eax
  802e85:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e88:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e95:	01 d0                	add    %edx,%eax
  802e97:	48                   	dec    %eax
  802e98:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea3:	f7 75 d8             	divl   -0x28(%ebp)
  802ea6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea9:	29 d0                	sub    %edx,%eax
  802eab:	c1 e8 0c             	shr    $0xc,%eax
  802eae:	83 ec 0c             	sub    $0xc,%esp
  802eb1:	50                   	push   %eax
  802eb2:	e8 1e ec ff ff       	call   801ad5 <sbrk>
  802eb7:	83 c4 10             	add    $0x10,%esp
  802eba:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ebd:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ec1:	75 0a                	jne    802ecd <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec8:	e9 8b 00 00 00       	jmp    802f58 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ecd:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ed4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ed7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eda:	01 d0                	add    %edx,%eax
  802edc:	48                   	dec    %eax
  802edd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ee0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee8:	f7 75 cc             	divl   -0x34(%ebp)
  802eeb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802eee:	29 d0                	sub    %edx,%eax
  802ef0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ef3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ef6:	01 d0                	add    %edx,%eax
  802ef8:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802efd:	a1 48 50 80 00       	mov    0x805048,%eax
  802f02:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f08:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f12:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f15:	01 d0                	add    %edx,%eax
  802f17:	48                   	dec    %eax
  802f18:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f1b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f23:	f7 75 c4             	divl   -0x3c(%ebp)
  802f26:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f29:	29 d0                	sub    %edx,%eax
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	6a 01                	push   $0x1
  802f30:	50                   	push   %eax
  802f31:	ff 75 d0             	pushl  -0x30(%ebp)
  802f34:	e8 36 fb ff ff       	call   802a6f <set_block_data>
  802f39:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f3c:	83 ec 0c             	sub    $0xc,%esp
  802f3f:	ff 75 d0             	pushl  -0x30(%ebp)
  802f42:	e8 1b 0a 00 00       	call   803962 <free_block>
  802f47:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f4a:	83 ec 0c             	sub    $0xc,%esp
  802f4d:	ff 75 08             	pushl  0x8(%ebp)
  802f50:	e8 49 fb ff ff       	call   802a9e <alloc_block_FF>
  802f55:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f58:	c9                   	leave  
  802f59:	c3                   	ret    

00802f5a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f5a:	55                   	push   %ebp
  802f5b:	89 e5                	mov    %esp,%ebp
  802f5d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	83 e0 01             	and    $0x1,%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 03                	je     802f6d <alloc_block_BF+0x13>
  802f6a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f6d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f71:	77 07                	ja     802f7a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f73:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f7a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	75 73                	jne    802ff6 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	83 c0 10             	add    $0x10,%eax
  802f89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f8c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f99:	01 d0                	add    %edx,%eax
  802f9b:	48                   	dec    %eax
  802f9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa7:	f7 75 e0             	divl   -0x20(%ebp)
  802faa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fad:	29 d0                	sub    %edx,%eax
  802faf:	c1 e8 0c             	shr    $0xc,%eax
  802fb2:	83 ec 0c             	sub    $0xc,%esp
  802fb5:	50                   	push   %eax
  802fb6:	e8 1a eb ff ff       	call   801ad5 <sbrk>
  802fbb:	83 c4 10             	add    $0x10,%esp
  802fbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fc1:	83 ec 0c             	sub    $0xc,%esp
  802fc4:	6a 00                	push   $0x0
  802fc6:	e8 0a eb ff ff       	call   801ad5 <sbrk>
  802fcb:	83 c4 10             	add    $0x10,%esp
  802fce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fd7:	83 ec 08             	sub    $0x8,%esp
  802fda:	50                   	push   %eax
  802fdb:	ff 75 d8             	pushl  -0x28(%ebp)
  802fde:	e8 9f f8 ff ff       	call   802882 <initialize_dynamic_allocator>
  802fe3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fe6:	83 ec 0c             	sub    $0xc,%esp
  802fe9:	68 4f 4d 80 00       	push   $0x804d4f
  802fee:	e8 40 db ff ff       	call   800b33 <cprintf>
  802ff3:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ffd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803004:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80300b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803012:	a1 34 50 80 00       	mov    0x805034,%eax
  803017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301a:	e9 1d 01 00 00       	jmp    80313c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803025:	83 ec 0c             	sub    $0xc,%esp
  803028:	ff 75 a8             	pushl  -0x58(%ebp)
  80302b:	e8 ee f6 ff ff       	call   80271e <get_block_size>
  803030:	83 c4 10             	add    $0x10,%esp
  803033:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	83 c0 08             	add    $0x8,%eax
  80303c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80303f:	0f 87 ef 00 00 00    	ja     803134 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	83 c0 18             	add    $0x18,%eax
  80304b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80304e:	77 1d                	ja     80306d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803053:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803056:	0f 86 d8 00 00 00    	jbe    803134 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80305c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80305f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803062:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803065:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803068:	e9 c7 00 00 00       	jmp    803134 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	83 c0 08             	add    $0x8,%eax
  803073:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803076:	0f 85 9d 00 00 00    	jne    803119 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	6a 01                	push   $0x1
  803081:	ff 75 a4             	pushl  -0x5c(%ebp)
  803084:	ff 75 a8             	pushl  -0x58(%ebp)
  803087:	e8 e3 f9 ff ff       	call   802a6f <set_block_data>
  80308c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80308f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803093:	75 17                	jne    8030ac <alloc_block_BF+0x152>
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	68 f3 4c 80 00       	push   $0x804cf3
  80309d:	68 2c 01 00 00       	push   $0x12c
  8030a2:	68 11 4d 80 00       	push   $0x804d11
  8030a7:	e8 ca d7 ff ff       	call   800876 <_panic>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	74 10                	je     8030c5 <alloc_block_BF+0x16b>
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 00                	mov    (%eax),%eax
  8030ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bd:	8b 52 04             	mov    0x4(%edx),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	eb 0b                	jmp    8030d0 <alloc_block_BF+0x176>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	a3 38 50 80 00       	mov    %eax,0x805038
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 40 04             	mov    0x4(%eax),%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	74 0f                	je     8030e9 <alloc_block_BF+0x18f>
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 40 04             	mov    0x4(%eax),%eax
  8030e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e3:	8b 12                	mov    (%edx),%edx
  8030e5:	89 10                	mov    %edx,(%eax)
  8030e7:	eb 0a                	jmp    8030f3 <alloc_block_BF+0x199>
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803106:	a1 40 50 80 00       	mov    0x805040,%eax
  80310b:	48                   	dec    %eax
  80310c:	a3 40 50 80 00       	mov    %eax,0x805040
					return va;
  803111:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803114:	e9 24 04 00 00       	jmp    80353d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80311f:	76 13                	jbe    803134 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803121:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803128:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80312b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80312e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803131:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803134:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803140:	74 07                	je     803149 <alloc_block_BF+0x1ef>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	eb 05                	jmp    80314e <alloc_block_BF+0x1f4>
  803149:	b8 00 00 00 00       	mov    $0x0,%eax
  80314e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803153:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	0f 85 bf fe ff ff    	jne    80301f <alloc_block_BF+0xc5>
  803160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803164:	0f 85 b5 fe ff ff    	jne    80301f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80316a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80316e:	0f 84 26 02 00 00    	je     80339a <alloc_block_BF+0x440>
  803174:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803178:	0f 85 1c 02 00 00    	jne    80339a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80317e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803181:	2b 45 08             	sub    0x8(%ebp),%eax
  803184:	83 e8 08             	sub    $0x8,%eax
  803187:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	8d 50 08             	lea    0x8(%eax),%edx
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	01 d0                	add    %edx,%eax
  803195:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	83 c0 08             	add    $0x8,%eax
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	6a 01                	push   $0x1
  8031a3:	50                   	push   %eax
  8031a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a7:	e8 c3 f8 ff ff       	call   802a6f <set_block_data>
  8031ac:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8031af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b2:	8b 40 04             	mov    0x4(%eax),%eax
  8031b5:	85 c0                	test   %eax,%eax
  8031b7:	75 68                	jne    803221 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031b9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031bd:	75 17                	jne    8031d6 <alloc_block_BF+0x27c>
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	68 2c 4d 80 00       	push   $0x804d2c
  8031c7:	68 45 01 00 00       	push   $0x145
  8031cc:	68 11 4d 80 00       	push   $0x804d11
  8031d1:	e8 a0 d6 ff ff       	call   800876 <_panic>
  8031d6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8031dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e4:	8b 00                	mov    (%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 0d                	je     8031f7 <alloc_block_BF+0x29d>
  8031ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8031ef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031f2:	89 50 04             	mov    %edx,0x4(%eax)
  8031f5:	eb 08                	jmp    8031ff <alloc_block_BF+0x2a5>
  8031f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8031ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803202:	a3 34 50 80 00       	mov    %eax,0x805034
  803207:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80320a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803211:	a1 40 50 80 00       	mov    0x805040,%eax
  803216:	40                   	inc    %eax
  803217:	a3 40 50 80 00       	mov    %eax,0x805040
  80321c:	e9 dc 00 00 00       	jmp    8032fd <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	75 65                	jne    80328f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80322a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80322e:	75 17                	jne    803247 <alloc_block_BF+0x2ed>
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	68 60 4d 80 00       	push   $0x804d60
  803238:	68 4a 01 00 00       	push   $0x14a
  80323d:	68 11 4d 80 00       	push   $0x804d11
  803242:	e8 2f d6 ff ff       	call   800876 <_panic>
  803247:	8b 15 38 50 80 00    	mov    0x805038,%edx
  80324d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803250:	89 50 04             	mov    %edx,0x4(%eax)
  803253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 0c                	je     803269 <alloc_block_BF+0x30f>
  80325d:	a1 38 50 80 00       	mov    0x805038,%eax
  803262:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803265:	89 10                	mov    %edx,(%eax)
  803267:	eb 08                	jmp    803271 <alloc_block_BF+0x317>
  803269:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80326c:	a3 34 50 80 00       	mov    %eax,0x805034
  803271:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803274:	a3 38 50 80 00       	mov    %eax,0x805038
  803279:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803282:	a1 40 50 80 00       	mov    0x805040,%eax
  803287:	40                   	inc    %eax
  803288:	a3 40 50 80 00       	mov    %eax,0x805040
  80328d:	eb 6e                	jmp    8032fd <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80328f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803293:	74 06                	je     80329b <alloc_block_BF+0x341>
  803295:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803299:	75 17                	jne    8032b2 <alloc_block_BF+0x358>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 84 4d 80 00       	push   $0x804d84
  8032a3:	68 4f 01 00 00       	push   $0x14f
  8032a8:	68 11 4d 80 00       	push   $0x804d11
  8032ad:	e8 c4 d5 ff ff       	call   800876 <_panic>
  8032b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b5:	8b 10                	mov    (%eax),%edx
  8032b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ba:	89 10                	mov    %edx,(%eax)
  8032bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	74 0b                	je     8032d0 <alloc_block_BF+0x376>
  8032c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032cd:	89 50 04             	mov    %edx,0x4(%eax)
  8032d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032de:	89 50 04             	mov    %edx,0x4(%eax)
  8032e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	75 08                	jne    8032f2 <alloc_block_BF+0x398>
  8032ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8032f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8032f7:	40                   	inc    %eax
  8032f8:	a3 40 50 80 00       	mov    %eax,0x805040
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803301:	75 17                	jne    80331a <alloc_block_BF+0x3c0>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 f3 4c 80 00       	push   $0x804cf3
  80330b:	68 51 01 00 00       	push   $0x151
  803310:	68 11 4d 80 00       	push   $0x804d11
  803315:	e8 5c d5 ff ff       	call   800876 <_panic>
  80331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 10                	je     803333 <alloc_block_BF+0x3d9>
  803323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80332b:	8b 52 04             	mov    0x4(%edx),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	eb 0b                	jmp    80333e <alloc_block_BF+0x3e4>
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	a3 38 50 80 00       	mov    %eax,0x805038
  80333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0f                	je     803357 <alloc_block_BF+0x3fd>
  803348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803351:	8b 12                	mov    (%edx),%edx
  803353:	89 10                	mov    %edx,(%eax)
  803355:	eb 0a                	jmp    803361 <alloc_block_BF+0x407>
  803357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	a3 34 50 80 00       	mov    %eax,0x805034
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803374:	a1 40 50 80 00       	mov    0x805040,%eax
  803379:	48                   	dec    %eax
  80337a:	a3 40 50 80 00       	mov    %eax,0x805040
			set_block_data(new_block_va, remaining_size, 0);
  80337f:	83 ec 04             	sub    $0x4,%esp
  803382:	6a 00                	push   $0x0
  803384:	ff 75 d0             	pushl  -0x30(%ebp)
  803387:	ff 75 cc             	pushl  -0x34(%ebp)
  80338a:	e8 e0 f6 ff ff       	call   802a6f <set_block_data>
  80338f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	e9 a3 01 00 00       	jmp    80353d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80339a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80339e:	0f 85 9d 00 00 00    	jne    803441 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8033a4:	83 ec 04             	sub    $0x4,%esp
  8033a7:	6a 01                	push   $0x1
  8033a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8033ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8033af:	e8 bb f6 ff ff       	call   802a6f <set_block_data>
  8033b4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033bb:	75 17                	jne    8033d4 <alloc_block_BF+0x47a>
  8033bd:	83 ec 04             	sub    $0x4,%esp
  8033c0:	68 f3 4c 80 00       	push   $0x804cf3
  8033c5:	68 58 01 00 00       	push   $0x158
  8033ca:	68 11 4d 80 00       	push   $0x804d11
  8033cf:	e8 a2 d4 ff ff       	call   800876 <_panic>
  8033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 10                	je     8033ed <alloc_block_BF+0x493>
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e5:	8b 52 04             	mov    0x4(%edx),%edx
  8033e8:	89 50 04             	mov    %edx,0x4(%eax)
  8033eb:	eb 0b                	jmp    8033f8 <alloc_block_BF+0x49e>
  8033ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f0:	8b 40 04             	mov    0x4(%eax),%eax
  8033f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fb:	8b 40 04             	mov    0x4(%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 0f                	je     803411 <alloc_block_BF+0x4b7>
  803402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340b:	8b 12                	mov    (%edx),%edx
  80340d:	89 10                	mov    %edx,(%eax)
  80340f:	eb 0a                	jmp    80341b <alloc_block_BF+0x4c1>
  803411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	a3 34 50 80 00       	mov    %eax,0x805034
  80341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342e:	a1 40 50 80 00       	mov    0x805040,%eax
  803433:	48                   	dec    %eax
  803434:	a3 40 50 80 00       	mov    %eax,0x805040
		return best_va;
  803439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343c:	e9 fc 00 00 00       	jmp    80353d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	83 c0 08             	add    $0x8,%eax
  803447:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80344a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803451:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803454:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803457:	01 d0                	add    %edx,%eax
  803459:	48                   	dec    %eax
  80345a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80345d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803460:	ba 00 00 00 00       	mov    $0x0,%edx
  803465:	f7 75 c4             	divl   -0x3c(%ebp)
  803468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80346b:	29 d0                	sub    %edx,%eax
  80346d:	c1 e8 0c             	shr    $0xc,%eax
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	50                   	push   %eax
  803474:	e8 5c e6 ff ff       	call   801ad5 <sbrk>
  803479:	83 c4 10             	add    $0x10,%esp
  80347c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80347f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803483:	75 0a                	jne    80348f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803485:	b8 00 00 00 00       	mov    $0x0,%eax
  80348a:	e9 ae 00 00 00       	jmp    80353d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80348f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803496:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803499:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	48                   	dec    %eax
  80349f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8034a2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034aa:	f7 75 b8             	divl   -0x48(%ebp)
  8034ad:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034b0:	29 d0                	sub    %edx,%eax
  8034b2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034b8:	01 d0                	add    %edx,%eax
  8034ba:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  8034bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8034c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8034ca:	83 ec 0c             	sub    $0xc,%esp
  8034cd:	68 b8 4d 80 00       	push   $0x804db8
  8034d2:	e8 5c d6 ff ff       	call   800b33 <cprintf>
  8034d7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8034da:	83 ec 08             	sub    $0x8,%esp
  8034dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8034e0:	68 bd 4d 80 00       	push   $0x804dbd
  8034e5:	e8 49 d6 ff ff       	call   800b33 <cprintf>
  8034ea:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034ed:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	48                   	dec    %eax
  8034fd:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803500:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803503:	ba 00 00 00 00       	mov    $0x0,%edx
  803508:	f7 75 b0             	divl   -0x50(%ebp)
  80350b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80350e:	29 d0                	sub    %edx,%eax
  803510:	83 ec 04             	sub    $0x4,%esp
  803513:	6a 01                	push   $0x1
  803515:	50                   	push   %eax
  803516:	ff 75 bc             	pushl  -0x44(%ebp)
  803519:	e8 51 f5 ff ff       	call   802a6f <set_block_data>
  80351e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803521:	83 ec 0c             	sub    $0xc,%esp
  803524:	ff 75 bc             	pushl  -0x44(%ebp)
  803527:	e8 36 04 00 00       	call   803962 <free_block>
  80352c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80352f:	83 ec 0c             	sub    $0xc,%esp
  803532:	ff 75 08             	pushl  0x8(%ebp)
  803535:	e8 20 fa ff ff       	call   802f5a <alloc_block_BF>
  80353a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80353d:	c9                   	leave  
  80353e:	c3                   	ret    

0080353f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80353f:	55                   	push   %ebp
  803540:	89 e5                	mov    %esp,%ebp
  803542:	53                   	push   %ebx
  803543:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80354d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803554:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803558:	74 1e                	je     803578 <merging+0x39>
  80355a:	ff 75 08             	pushl  0x8(%ebp)
  80355d:	e8 bc f1 ff ff       	call   80271e <get_block_size>
  803562:	83 c4 04             	add    $0x4,%esp
  803565:	89 c2                	mov    %eax,%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	01 d0                	add    %edx,%eax
  80356c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80356f:	75 07                	jne    803578 <merging+0x39>
		prev_is_free = 1;
  803571:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80357c:	74 1e                	je     80359c <merging+0x5d>
  80357e:	ff 75 10             	pushl  0x10(%ebp)
  803581:	e8 98 f1 ff ff       	call   80271e <get_block_size>
  803586:	83 c4 04             	add    $0x4,%esp
  803589:	89 c2                	mov    %eax,%edx
  80358b:	8b 45 10             	mov    0x10(%ebp),%eax
  80358e:	01 d0                	add    %edx,%eax
  803590:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803593:	75 07                	jne    80359c <merging+0x5d>
		next_is_free = 1;
  803595:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80359c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a0:	0f 84 cc 00 00 00    	je     803672 <merging+0x133>
  8035a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035aa:	0f 84 c2 00 00 00    	je     803672 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8035b0:	ff 75 08             	pushl  0x8(%ebp)
  8035b3:	e8 66 f1 ff ff       	call   80271e <get_block_size>
  8035b8:	83 c4 04             	add    $0x4,%esp
  8035bb:	89 c3                	mov    %eax,%ebx
  8035bd:	ff 75 10             	pushl  0x10(%ebp)
  8035c0:	e8 59 f1 ff ff       	call   80271e <get_block_size>
  8035c5:	83 c4 04             	add    $0x4,%esp
  8035c8:	01 c3                	add    %eax,%ebx
  8035ca:	ff 75 0c             	pushl  0xc(%ebp)
  8035cd:	e8 4c f1 ff ff       	call   80271e <get_block_size>
  8035d2:	83 c4 04             	add    $0x4,%esp
  8035d5:	01 d8                	add    %ebx,%eax
  8035d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035da:	6a 00                	push   $0x0
  8035dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8035df:	ff 75 08             	pushl  0x8(%ebp)
  8035e2:	e8 88 f4 ff ff       	call   802a6f <set_block_data>
  8035e7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ee:	75 17                	jne    803607 <merging+0xc8>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 f3 4c 80 00       	push   $0x804cf3
  8035f8:	68 7d 01 00 00       	push   $0x17d
  8035fd:	68 11 4d 80 00       	push   $0x804d11
  803602:	e8 6f d2 ff ff       	call   800876 <_panic>
  803607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 10                	je     803620 <merging+0xe1>
  803610:	8b 45 0c             	mov    0xc(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	8b 55 0c             	mov    0xc(%ebp),%edx
  803618:	8b 52 04             	mov    0x4(%edx),%edx
  80361b:	89 50 04             	mov    %edx,0x4(%eax)
  80361e:	eb 0b                	jmp    80362b <merging+0xec>
  803620:	8b 45 0c             	mov    0xc(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	a3 38 50 80 00       	mov    %eax,0x805038
  80362b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	74 0f                	je     803644 <merging+0x105>
  803635:	8b 45 0c             	mov    0xc(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80363e:	8b 12                	mov    (%edx),%edx
  803640:	89 10                	mov    %edx,(%eax)
  803642:	eb 0a                	jmp    80364e <merging+0x10f>
  803644:	8b 45 0c             	mov    0xc(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	a3 34 50 80 00       	mov    %eax,0x805034
  80364e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 40 50 80 00       	mov    0x805040,%eax
  803666:	48                   	dec    %eax
  803667:	a3 40 50 80 00       	mov    %eax,0x805040
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80366c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80366d:	e9 ea 02 00 00       	jmp    80395c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803676:	74 3b                	je     8036b3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803678:	83 ec 0c             	sub    $0xc,%esp
  80367b:	ff 75 08             	pushl  0x8(%ebp)
  80367e:	e8 9b f0 ff ff       	call   80271e <get_block_size>
  803683:	83 c4 10             	add    $0x10,%esp
  803686:	89 c3                	mov    %eax,%ebx
  803688:	83 ec 0c             	sub    $0xc,%esp
  80368b:	ff 75 10             	pushl  0x10(%ebp)
  80368e:	e8 8b f0 ff ff       	call   80271e <get_block_size>
  803693:	83 c4 10             	add    $0x10,%esp
  803696:	01 d8                	add    %ebx,%eax
  803698:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	6a 00                	push   $0x0
  8036a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8036a3:	ff 75 08             	pushl  0x8(%ebp)
  8036a6:	e8 c4 f3 ff ff       	call   802a6f <set_block_data>
  8036ab:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036ae:	e9 a9 02 00 00       	jmp    80395c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8036b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036b7:	0f 84 2d 01 00 00    	je     8037ea <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8036bd:	83 ec 0c             	sub    $0xc,%esp
  8036c0:	ff 75 10             	pushl  0x10(%ebp)
  8036c3:	e8 56 f0 ff ff       	call   80271e <get_block_size>
  8036c8:	83 c4 10             	add    $0x10,%esp
  8036cb:	89 c3                	mov    %eax,%ebx
  8036cd:	83 ec 0c             	sub    $0xc,%esp
  8036d0:	ff 75 0c             	pushl  0xc(%ebp)
  8036d3:	e8 46 f0 ff ff       	call   80271e <get_block_size>
  8036d8:	83 c4 10             	add    $0x10,%esp
  8036db:	01 d8                	add    %ebx,%eax
  8036dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036e0:	83 ec 04             	sub    $0x4,%esp
  8036e3:	6a 00                	push   $0x0
  8036e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036e8:	ff 75 10             	pushl  0x10(%ebp)
  8036eb:	e8 7f f3 ff ff       	call   802a6f <set_block_data>
  8036f0:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8036f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8036f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036fd:	74 06                	je     803705 <merging+0x1c6>
  8036ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803703:	75 17                	jne    80371c <merging+0x1dd>
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	68 cc 4d 80 00       	push   $0x804dcc
  80370d:	68 8d 01 00 00       	push   $0x18d
  803712:	68 11 4d 80 00       	push   $0x804d11
  803717:	e8 5a d1 ff ff       	call   800876 <_panic>
  80371c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371f:	8b 50 04             	mov    0x4(%eax),%edx
  803722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803725:	89 50 04             	mov    %edx,0x4(%eax)
  803728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80372b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80372e:	89 10                	mov    %edx,(%eax)
  803730:	8b 45 0c             	mov    0xc(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0d                	je     803747 <merging+0x208>
  80373a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803743:	89 10                	mov    %edx,(%eax)
  803745:	eb 08                	jmp    80374f <merging+0x210>
  803747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374a:	a3 34 50 80 00       	mov    %eax,0x805034
  80374f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803752:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803755:	89 50 04             	mov    %edx,0x4(%eax)
  803758:	a1 40 50 80 00       	mov    0x805040,%eax
  80375d:	40                   	inc    %eax
  80375e:	a3 40 50 80 00       	mov    %eax,0x805040
		LIST_REMOVE(&freeBlocksList, next_block);
  803763:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803767:	75 17                	jne    803780 <merging+0x241>
  803769:	83 ec 04             	sub    $0x4,%esp
  80376c:	68 f3 4c 80 00       	push   $0x804cf3
  803771:	68 8e 01 00 00       	push   $0x18e
  803776:	68 11 4d 80 00       	push   $0x804d11
  80377b:	e8 f6 d0 ff ff       	call   800876 <_panic>
  803780:	8b 45 0c             	mov    0xc(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	85 c0                	test   %eax,%eax
  803787:	74 10                	je     803799 <merging+0x25a>
  803789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378c:	8b 00                	mov    (%eax),%eax
  80378e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803791:	8b 52 04             	mov    0x4(%edx),%edx
  803794:	89 50 04             	mov    %edx,0x4(%eax)
  803797:	eb 0b                	jmp    8037a4 <merging+0x265>
  803799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	a3 38 50 80 00       	mov    %eax,0x805038
  8037a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a7:	8b 40 04             	mov    0x4(%eax),%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	74 0f                	je     8037bd <merging+0x27e>
  8037ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b1:	8b 40 04             	mov    0x4(%eax),%eax
  8037b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b7:	8b 12                	mov    (%edx),%edx
  8037b9:	89 10                	mov    %edx,(%eax)
  8037bb:	eb 0a                	jmp    8037c7 <merging+0x288>
  8037bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c0:	8b 00                	mov    (%eax),%eax
  8037c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8037c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037da:	a1 40 50 80 00       	mov    0x805040,%eax
  8037df:	48                   	dec    %eax
  8037e0:	a3 40 50 80 00       	mov    %eax,0x805040
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037e5:	e9 72 01 00 00       	jmp    80395c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8037ed:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8037f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f4:	74 79                	je     80386f <merging+0x330>
  8037f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037fa:	74 73                	je     80386f <merging+0x330>
  8037fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803800:	74 06                	je     803808 <merging+0x2c9>
  803802:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803806:	75 17                	jne    80381f <merging+0x2e0>
  803808:	83 ec 04             	sub    $0x4,%esp
  80380b:	68 84 4d 80 00       	push   $0x804d84
  803810:	68 94 01 00 00       	push   $0x194
  803815:	68 11 4d 80 00       	push   $0x804d11
  80381a:	e8 57 d0 ff ff       	call   800876 <_panic>
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	8b 10                	mov    (%eax),%edx
  803824:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803827:	89 10                	mov    %edx,(%eax)
  803829:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	85 c0                	test   %eax,%eax
  803830:	74 0b                	je     80383d <merging+0x2fe>
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80383a:	89 50 04             	mov    %edx,0x4(%eax)
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803843:	89 10                	mov    %edx,(%eax)
  803845:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803848:	8b 55 08             	mov    0x8(%ebp),%edx
  80384b:	89 50 04             	mov    %edx,0x4(%eax)
  80384e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	85 c0                	test   %eax,%eax
  803855:	75 08                	jne    80385f <merging+0x320>
  803857:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385a:	a3 38 50 80 00       	mov    %eax,0x805038
  80385f:	a1 40 50 80 00       	mov    0x805040,%eax
  803864:	40                   	inc    %eax
  803865:	a3 40 50 80 00       	mov    %eax,0x805040
  80386a:	e9 ce 00 00 00       	jmp    80393d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80386f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803873:	74 65                	je     8038da <merging+0x39b>
  803875:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803879:	75 17                	jne    803892 <merging+0x353>
  80387b:	83 ec 04             	sub    $0x4,%esp
  80387e:	68 60 4d 80 00       	push   $0x804d60
  803883:	68 95 01 00 00       	push   $0x195
  803888:	68 11 4d 80 00       	push   $0x804d11
  80388d:	e8 e4 cf ff ff       	call   800876 <_panic>
  803892:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803898:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389b:	89 50 04             	mov    %edx,0x4(%eax)
  80389e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a1:	8b 40 04             	mov    0x4(%eax),%eax
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	74 0c                	je     8038b4 <merging+0x375>
  8038a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	eb 08                	jmp    8038bc <merging+0x37d>
  8038b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b7:	a3 34 50 80 00       	mov    %eax,0x805034
  8038bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038bf:	a3 38 50 80 00       	mov    %eax,0x805038
  8038c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8038d2:	40                   	inc    %eax
  8038d3:	a3 40 50 80 00       	mov    %eax,0x805040
  8038d8:	eb 63                	jmp    80393d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038de:	75 17                	jne    8038f7 <merging+0x3b8>
  8038e0:	83 ec 04             	sub    $0x4,%esp
  8038e3:	68 2c 4d 80 00       	push   $0x804d2c
  8038e8:	68 98 01 00 00       	push   $0x198
  8038ed:	68 11 4d 80 00       	push   $0x804d11
  8038f2:	e8 7f cf ff ff       	call   800876 <_panic>
  8038f7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8038fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803900:	89 10                	mov    %edx,(%eax)
  803902:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803905:	8b 00                	mov    (%eax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	74 0d                	je     803918 <merging+0x3d9>
  80390b:	a1 34 50 80 00       	mov    0x805034,%eax
  803910:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803913:	89 50 04             	mov    %edx,0x4(%eax)
  803916:	eb 08                	jmp    803920 <merging+0x3e1>
  803918:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391b:	a3 38 50 80 00       	mov    %eax,0x805038
  803920:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803923:	a3 34 50 80 00       	mov    %eax,0x805034
  803928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803932:	a1 40 50 80 00       	mov    0x805040,%eax
  803937:	40                   	inc    %eax
  803938:	a3 40 50 80 00       	mov    %eax,0x805040
		}
		set_block_data(va, get_block_size(va), 0);
  80393d:	83 ec 0c             	sub    $0xc,%esp
  803940:	ff 75 10             	pushl  0x10(%ebp)
  803943:	e8 d6 ed ff ff       	call   80271e <get_block_size>
  803948:	83 c4 10             	add    $0x10,%esp
  80394b:	83 ec 04             	sub    $0x4,%esp
  80394e:	6a 00                	push   $0x0
  803950:	50                   	push   %eax
  803951:	ff 75 10             	pushl  0x10(%ebp)
  803954:	e8 16 f1 ff ff       	call   802a6f <set_block_data>
  803959:	83 c4 10             	add    $0x10,%esp
	}
}
  80395c:	90                   	nop
  80395d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803960:	c9                   	leave  
  803961:	c3                   	ret    

00803962 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803962:	55                   	push   %ebp
  803963:	89 e5                	mov    %esp,%ebp
  803965:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803968:	a1 34 50 80 00       	mov    0x805034,%eax
  80396d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803970:	a1 38 50 80 00       	mov    0x805038,%eax
  803975:	3b 45 08             	cmp    0x8(%ebp),%eax
  803978:	73 1b                	jae    803995 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80397a:	a1 38 50 80 00       	mov    0x805038,%eax
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	ff 75 08             	pushl  0x8(%ebp)
  803985:	6a 00                	push   $0x0
  803987:	50                   	push   %eax
  803988:	e8 b2 fb ff ff       	call   80353f <merging>
  80398d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803990:	e9 8b 00 00 00       	jmp    803a20 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803995:	a1 34 50 80 00       	mov    0x805034,%eax
  80399a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80399d:	76 18                	jbe    8039b7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80399f:	a1 34 50 80 00       	mov    0x805034,%eax
  8039a4:	83 ec 04             	sub    $0x4,%esp
  8039a7:	ff 75 08             	pushl  0x8(%ebp)
  8039aa:	50                   	push   %eax
  8039ab:	6a 00                	push   $0x0
  8039ad:	e8 8d fb ff ff       	call   80353f <merging>
  8039b2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039b5:	eb 69                	jmp    803a20 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8039bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039bf:	eb 39                	jmp    8039fa <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8039c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039c7:	73 29                	jae    8039f2 <free_block+0x90>
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039d1:	76 1f                	jbe    8039f2 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039db:	83 ec 04             	sub    $0x4,%esp
  8039de:	ff 75 08             	pushl  0x8(%ebp)
  8039e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8039e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8039e7:	e8 53 fb ff ff       	call   80353f <merging>
  8039ec:	83 c4 10             	add    $0x10,%esp
			break;
  8039ef:	90                   	nop
		}
	}
}
  8039f0:	eb 2e                	jmp    803a20 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039f2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039fe:	74 07                	je     803a07 <free_block+0xa5>
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	eb 05                	jmp    803a0c <free_block+0xaa>
  803a07:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a11:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a16:	85 c0                	test   %eax,%eax
  803a18:	75 a7                	jne    8039c1 <free_block+0x5f>
  803a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1e:	75 a1                	jne    8039c1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a20:	90                   	nop
  803a21:	c9                   	leave  
  803a22:	c3                   	ret    

00803a23 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a23:	55                   	push   %ebp
  803a24:	89 e5                	mov    %esp,%ebp
  803a26:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a29:	ff 75 08             	pushl  0x8(%ebp)
  803a2c:	e8 ed ec ff ff       	call   80271e <get_block_size>
  803a31:	83 c4 04             	add    $0x4,%esp
  803a34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a3e:	eb 17                	jmp    803a57 <copy_data+0x34>
  803a40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a46:	01 c2                	add    %eax,%edx
  803a48:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4e:	01 c8                	add    %ecx,%eax
  803a50:	8a 00                	mov    (%eax),%al
  803a52:	88 02                	mov    %al,(%edx)
  803a54:	ff 45 fc             	incl   -0x4(%ebp)
  803a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a5d:	72 e1                	jb     803a40 <copy_data+0x1d>
}
  803a5f:	90                   	nop
  803a60:	c9                   	leave  
  803a61:	c3                   	ret    

00803a62 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a62:	55                   	push   %ebp
  803a63:	89 e5                	mov    %esp,%ebp
  803a65:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a6c:	75 23                	jne    803a91 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a72:	74 13                	je     803a87 <realloc_block_FF+0x25>
  803a74:	83 ec 0c             	sub    $0xc,%esp
  803a77:	ff 75 0c             	pushl  0xc(%ebp)
  803a7a:	e8 1f f0 ff ff       	call   802a9e <alloc_block_FF>
  803a7f:	83 c4 10             	add    $0x10,%esp
  803a82:	e9 f4 06 00 00       	jmp    80417b <realloc_block_FF+0x719>
		return NULL;
  803a87:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8c:	e9 ea 06 00 00       	jmp    80417b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803a91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a95:	75 18                	jne    803aaf <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a97:	83 ec 0c             	sub    $0xc,%esp
  803a9a:	ff 75 08             	pushl  0x8(%ebp)
  803a9d:	e8 c0 fe ff ff       	call   803962 <free_block>
  803aa2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  803aaa:	e9 cc 06 00 00       	jmp    80417b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803aaf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803ab3:	77 07                	ja     803abc <realloc_block_FF+0x5a>
  803ab5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803abf:	83 e0 01             	and    $0x1,%eax
  803ac2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac8:	83 c0 08             	add    $0x8,%eax
  803acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803ace:	83 ec 0c             	sub    $0xc,%esp
  803ad1:	ff 75 08             	pushl  0x8(%ebp)
  803ad4:	e8 45 ec ff ff       	call   80271e <get_block_size>
  803ad9:	83 c4 10             	add    $0x10,%esp
  803adc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae2:	83 e8 08             	sub    $0x8,%eax
  803ae5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  803aeb:	83 e8 04             	sub    $0x4,%eax
  803aee:	8b 00                	mov    (%eax),%eax
  803af0:	83 e0 fe             	and    $0xfffffffe,%eax
  803af3:	89 c2                	mov    %eax,%edx
  803af5:	8b 45 08             	mov    0x8(%ebp),%eax
  803af8:	01 d0                	add    %edx,%eax
  803afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803afd:	83 ec 0c             	sub    $0xc,%esp
  803b00:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b03:	e8 16 ec ff ff       	call   80271e <get_block_size>
  803b08:	83 c4 10             	add    $0x10,%esp
  803b0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b11:	83 e8 08             	sub    $0x8,%eax
  803b14:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b1d:	75 08                	jne    803b27 <realloc_block_FF+0xc5>
	{
		 return va;
  803b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b22:	e9 54 06 00 00       	jmp    80417b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b2d:	0f 83 e5 03 00 00    	jae    803f18 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b36:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b39:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b3c:	83 ec 0c             	sub    $0xc,%esp
  803b3f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b42:	e8 f0 eb ff ff       	call   802737 <is_free_block>
  803b47:	83 c4 10             	add    $0x10,%esp
  803b4a:	84 c0                	test   %al,%al
  803b4c:	0f 84 3b 01 00 00    	je     803c8d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b55:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b58:	01 d0                	add    %edx,%eax
  803b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b5d:	83 ec 04             	sub    $0x4,%esp
  803b60:	6a 01                	push   $0x1
  803b62:	ff 75 f0             	pushl  -0x10(%ebp)
  803b65:	ff 75 08             	pushl  0x8(%ebp)
  803b68:	e8 02 ef ff ff       	call   802a6f <set_block_data>
  803b6d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b70:	8b 45 08             	mov    0x8(%ebp),%eax
  803b73:	83 e8 04             	sub    $0x4,%eax
  803b76:	8b 00                	mov    (%eax),%eax
  803b78:	83 e0 fe             	and    $0xfffffffe,%eax
  803b7b:	89 c2                	mov    %eax,%edx
  803b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b80:	01 d0                	add    %edx,%eax
  803b82:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b85:	83 ec 04             	sub    $0x4,%esp
  803b88:	6a 00                	push   $0x0
  803b8a:	ff 75 cc             	pushl  -0x34(%ebp)
  803b8d:	ff 75 c8             	pushl  -0x38(%ebp)
  803b90:	e8 da ee ff ff       	call   802a6f <set_block_data>
  803b95:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b9c:	74 06                	je     803ba4 <realloc_block_FF+0x142>
  803b9e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ba2:	75 17                	jne    803bbb <realloc_block_FF+0x159>
  803ba4:	83 ec 04             	sub    $0x4,%esp
  803ba7:	68 84 4d 80 00       	push   $0x804d84
  803bac:	68 f6 01 00 00       	push   $0x1f6
  803bb1:	68 11 4d 80 00       	push   $0x804d11
  803bb6:	e8 bb cc ff ff       	call   800876 <_panic>
  803bbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbe:	8b 10                	mov    (%eax),%edx
  803bc0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc3:	89 10                	mov    %edx,(%eax)
  803bc5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc8:	8b 00                	mov    (%eax),%eax
  803bca:	85 c0                	test   %eax,%eax
  803bcc:	74 0b                	je     803bd9 <realloc_block_FF+0x177>
  803bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd1:	8b 00                	mov    (%eax),%eax
  803bd3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bd6:	89 50 04             	mov    %edx,0x4(%eax)
  803bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bdf:	89 10                	mov    %edx,(%eax)
  803be1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803be4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be7:	89 50 04             	mov    %edx,0x4(%eax)
  803bea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bed:	8b 00                	mov    (%eax),%eax
  803bef:	85 c0                	test   %eax,%eax
  803bf1:	75 08                	jne    803bfb <realloc_block_FF+0x199>
  803bf3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bf6:	a3 38 50 80 00       	mov    %eax,0x805038
  803bfb:	a1 40 50 80 00       	mov    0x805040,%eax
  803c00:	40                   	inc    %eax
  803c01:	a3 40 50 80 00       	mov    %eax,0x805040
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c0a:	75 17                	jne    803c23 <realloc_block_FF+0x1c1>
  803c0c:	83 ec 04             	sub    $0x4,%esp
  803c0f:	68 f3 4c 80 00       	push   $0x804cf3
  803c14:	68 f7 01 00 00       	push   $0x1f7
  803c19:	68 11 4d 80 00       	push   $0x804d11
  803c1e:	e8 53 cc ff ff       	call   800876 <_panic>
  803c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c26:	8b 00                	mov    (%eax),%eax
  803c28:	85 c0                	test   %eax,%eax
  803c2a:	74 10                	je     803c3c <realloc_block_FF+0x1da>
  803c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2f:	8b 00                	mov    (%eax),%eax
  803c31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c34:	8b 52 04             	mov    0x4(%edx),%edx
  803c37:	89 50 04             	mov    %edx,0x4(%eax)
  803c3a:	eb 0b                	jmp    803c47 <realloc_block_FF+0x1e5>
  803c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3f:	8b 40 04             	mov    0x4(%eax),%eax
  803c42:	a3 38 50 80 00       	mov    %eax,0x805038
  803c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4a:	8b 40 04             	mov    0x4(%eax),%eax
  803c4d:	85 c0                	test   %eax,%eax
  803c4f:	74 0f                	je     803c60 <realloc_block_FF+0x1fe>
  803c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c54:	8b 40 04             	mov    0x4(%eax),%eax
  803c57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c5a:	8b 12                	mov    (%edx),%edx
  803c5c:	89 10                	mov    %edx,(%eax)
  803c5e:	eb 0a                	jmp    803c6a <realloc_block_FF+0x208>
  803c60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c63:	8b 00                	mov    (%eax),%eax
  803c65:	a3 34 50 80 00       	mov    %eax,0x805034
  803c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c7d:	a1 40 50 80 00       	mov    0x805040,%eax
  803c82:	48                   	dec    %eax
  803c83:	a3 40 50 80 00       	mov    %eax,0x805040
  803c88:	e9 83 02 00 00       	jmp    803f10 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803c8d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c91:	0f 86 69 02 00 00    	jbe    803f00 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c97:	83 ec 04             	sub    $0x4,%esp
  803c9a:	6a 01                	push   $0x1
  803c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  803c9f:	ff 75 08             	pushl  0x8(%ebp)
  803ca2:	e8 c8 ed ff ff       	call   802a6f <set_block_data>
  803ca7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803caa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cad:	83 e8 04             	sub    $0x4,%eax
  803cb0:	8b 00                	mov    (%eax),%eax
  803cb2:	83 e0 fe             	and    $0xfffffffe,%eax
  803cb5:	89 c2                	mov    %eax,%edx
  803cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cba:	01 d0                	add    %edx,%eax
  803cbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803cbf:	a1 40 50 80 00       	mov    0x805040,%eax
  803cc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803cc7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ccb:	75 68                	jne    803d35 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ccd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cd1:	75 17                	jne    803cea <realloc_block_FF+0x288>
  803cd3:	83 ec 04             	sub    $0x4,%esp
  803cd6:	68 2c 4d 80 00       	push   $0x804d2c
  803cdb:	68 06 02 00 00       	push   $0x206
  803ce0:	68 11 4d 80 00       	push   $0x804d11
  803ce5:	e8 8c cb ff ff       	call   800876 <_panic>
  803cea:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803cf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf3:	89 10                	mov    %edx,(%eax)
  803cf5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf8:	8b 00                	mov    (%eax),%eax
  803cfa:	85 c0                	test   %eax,%eax
  803cfc:	74 0d                	je     803d0b <realloc_block_FF+0x2a9>
  803cfe:	a1 34 50 80 00       	mov    0x805034,%eax
  803d03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d06:	89 50 04             	mov    %edx,0x4(%eax)
  803d09:	eb 08                	jmp    803d13 <realloc_block_FF+0x2b1>
  803d0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0e:	a3 38 50 80 00       	mov    %eax,0x805038
  803d13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d16:	a3 34 50 80 00       	mov    %eax,0x805034
  803d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d25:	a1 40 50 80 00       	mov    0x805040,%eax
  803d2a:	40                   	inc    %eax
  803d2b:	a3 40 50 80 00       	mov    %eax,0x805040
  803d30:	e9 b0 01 00 00       	jmp    803ee5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d35:	a1 34 50 80 00       	mov    0x805034,%eax
  803d3a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d3d:	76 68                	jbe    803da7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d3f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d43:	75 17                	jne    803d5c <realloc_block_FF+0x2fa>
  803d45:	83 ec 04             	sub    $0x4,%esp
  803d48:	68 2c 4d 80 00       	push   $0x804d2c
  803d4d:	68 0b 02 00 00       	push   $0x20b
  803d52:	68 11 4d 80 00       	push   $0x804d11
  803d57:	e8 1a cb ff ff       	call   800876 <_panic>
  803d5c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803d62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d65:	89 10                	mov    %edx,(%eax)
  803d67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6a:	8b 00                	mov    (%eax),%eax
  803d6c:	85 c0                	test   %eax,%eax
  803d6e:	74 0d                	je     803d7d <realloc_block_FF+0x31b>
  803d70:	a1 34 50 80 00       	mov    0x805034,%eax
  803d75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d78:	89 50 04             	mov    %edx,0x4(%eax)
  803d7b:	eb 08                	jmp    803d85 <realloc_block_FF+0x323>
  803d7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d80:	a3 38 50 80 00       	mov    %eax,0x805038
  803d85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d88:	a3 34 50 80 00       	mov    %eax,0x805034
  803d8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d97:	a1 40 50 80 00       	mov    0x805040,%eax
  803d9c:	40                   	inc    %eax
  803d9d:	a3 40 50 80 00       	mov    %eax,0x805040
  803da2:	e9 3e 01 00 00       	jmp    803ee5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803da7:	a1 34 50 80 00       	mov    0x805034,%eax
  803dac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803daf:	73 68                	jae    803e19 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803db1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803db5:	75 17                	jne    803dce <realloc_block_FF+0x36c>
  803db7:	83 ec 04             	sub    $0x4,%esp
  803dba:	68 60 4d 80 00       	push   $0x804d60
  803dbf:	68 10 02 00 00       	push   $0x210
  803dc4:	68 11 4d 80 00       	push   $0x804d11
  803dc9:	e8 a8 ca ff ff       	call   800876 <_panic>
  803dce:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803dd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd7:	89 50 04             	mov    %edx,0x4(%eax)
  803dda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ddd:	8b 40 04             	mov    0x4(%eax),%eax
  803de0:	85 c0                	test   %eax,%eax
  803de2:	74 0c                	je     803df0 <realloc_block_FF+0x38e>
  803de4:	a1 38 50 80 00       	mov    0x805038,%eax
  803de9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dec:	89 10                	mov    %edx,(%eax)
  803dee:	eb 08                	jmp    803df8 <realloc_block_FF+0x396>
  803df0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803df3:	a3 34 50 80 00       	mov    %eax,0x805034
  803df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dfb:	a3 38 50 80 00       	mov    %eax,0x805038
  803e00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e09:	a1 40 50 80 00       	mov    0x805040,%eax
  803e0e:	40                   	inc    %eax
  803e0f:	a3 40 50 80 00       	mov    %eax,0x805040
  803e14:	e9 cc 00 00 00       	jmp    803ee5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e20:	a1 34 50 80 00       	mov    0x805034,%eax
  803e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e28:	e9 8a 00 00 00       	jmp    803eb7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e30:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e33:	73 7a                	jae    803eaf <realloc_block_FF+0x44d>
  803e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e38:	8b 00                	mov    (%eax),%eax
  803e3a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e3d:	73 70                	jae    803eaf <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e43:	74 06                	je     803e4b <realloc_block_FF+0x3e9>
  803e45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e49:	75 17                	jne    803e62 <realloc_block_FF+0x400>
  803e4b:	83 ec 04             	sub    $0x4,%esp
  803e4e:	68 84 4d 80 00       	push   $0x804d84
  803e53:	68 1a 02 00 00       	push   $0x21a
  803e58:	68 11 4d 80 00       	push   $0x804d11
  803e5d:	e8 14 ca ff ff       	call   800876 <_panic>
  803e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e65:	8b 10                	mov    (%eax),%edx
  803e67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6a:	89 10                	mov    %edx,(%eax)
  803e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6f:	8b 00                	mov    (%eax),%eax
  803e71:	85 c0                	test   %eax,%eax
  803e73:	74 0b                	je     803e80 <realloc_block_FF+0x41e>
  803e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e78:	8b 00                	mov    (%eax),%eax
  803e7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e7d:	89 50 04             	mov    %edx,0x4(%eax)
  803e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e86:	89 10                	mov    %edx,(%eax)
  803e88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e8e:	89 50 04             	mov    %edx,0x4(%eax)
  803e91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e94:	8b 00                	mov    (%eax),%eax
  803e96:	85 c0                	test   %eax,%eax
  803e98:	75 08                	jne    803ea2 <realloc_block_FF+0x440>
  803e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9d:	a3 38 50 80 00       	mov    %eax,0x805038
  803ea2:	a1 40 50 80 00       	mov    0x805040,%eax
  803ea7:	40                   	inc    %eax
  803ea8:	a3 40 50 80 00       	mov    %eax,0x805040
							break;
  803ead:	eb 36                	jmp    803ee5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803eaf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ebb:	74 07                	je     803ec4 <realloc_block_FF+0x462>
  803ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec0:	8b 00                	mov    (%eax),%eax
  803ec2:	eb 05                	jmp    803ec9 <realloc_block_FF+0x467>
  803ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ece:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ed3:	85 c0                	test   %eax,%eax
  803ed5:	0f 85 52 ff ff ff    	jne    803e2d <realloc_block_FF+0x3cb>
  803edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803edf:	0f 85 48 ff ff ff    	jne    803e2d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ee5:	83 ec 04             	sub    $0x4,%esp
  803ee8:	6a 00                	push   $0x0
  803eea:	ff 75 d8             	pushl  -0x28(%ebp)
  803eed:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ef0:	e8 7a eb ff ff       	call   802a6f <set_block_data>
  803ef5:	83 c4 10             	add    $0x10,%esp
				return va;
  803ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  803efb:	e9 7b 02 00 00       	jmp    80417b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803f00:	83 ec 0c             	sub    $0xc,%esp
  803f03:	68 01 4e 80 00       	push   $0x804e01
  803f08:	e8 26 cc ff ff       	call   800b33 <cprintf>
  803f0d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803f10:	8b 45 08             	mov    0x8(%ebp),%eax
  803f13:	e9 63 02 00 00       	jmp    80417b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f1b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f1e:	0f 86 4d 02 00 00    	jbe    804171 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f24:	83 ec 0c             	sub    $0xc,%esp
  803f27:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f2a:	e8 08 e8 ff ff       	call   802737 <is_free_block>
  803f2f:	83 c4 10             	add    $0x10,%esp
  803f32:	84 c0                	test   %al,%al
  803f34:	0f 84 37 02 00 00    	je     804171 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f3d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f40:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f46:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f49:	76 38                	jbe    803f83 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f4b:	83 ec 0c             	sub    $0xc,%esp
  803f4e:	ff 75 08             	pushl  0x8(%ebp)
  803f51:	e8 0c fa ff ff       	call   803962 <free_block>
  803f56:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f59:	83 ec 0c             	sub    $0xc,%esp
  803f5c:	ff 75 0c             	pushl  0xc(%ebp)
  803f5f:	e8 3a eb ff ff       	call   802a9e <alloc_block_FF>
  803f64:	83 c4 10             	add    $0x10,%esp
  803f67:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f6a:	83 ec 08             	sub    $0x8,%esp
  803f6d:	ff 75 c0             	pushl  -0x40(%ebp)
  803f70:	ff 75 08             	pushl  0x8(%ebp)
  803f73:	e8 ab fa ff ff       	call   803a23 <copy_data>
  803f78:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f7e:	e9 f8 01 00 00       	jmp    80417b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f86:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f89:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f8c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f90:	0f 87 a0 00 00 00    	ja     804036 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f9a:	75 17                	jne    803fb3 <realloc_block_FF+0x551>
  803f9c:	83 ec 04             	sub    $0x4,%esp
  803f9f:	68 f3 4c 80 00       	push   $0x804cf3
  803fa4:	68 38 02 00 00       	push   $0x238
  803fa9:	68 11 4d 80 00       	push   $0x804d11
  803fae:	e8 c3 c8 ff ff       	call   800876 <_panic>
  803fb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb6:	8b 00                	mov    (%eax),%eax
  803fb8:	85 c0                	test   %eax,%eax
  803fba:	74 10                	je     803fcc <realloc_block_FF+0x56a>
  803fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbf:	8b 00                	mov    (%eax),%eax
  803fc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fc4:	8b 52 04             	mov    0x4(%edx),%edx
  803fc7:	89 50 04             	mov    %edx,0x4(%eax)
  803fca:	eb 0b                	jmp    803fd7 <realloc_block_FF+0x575>
  803fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcf:	8b 40 04             	mov    0x4(%eax),%eax
  803fd2:	a3 38 50 80 00       	mov    %eax,0x805038
  803fd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fda:	8b 40 04             	mov    0x4(%eax),%eax
  803fdd:	85 c0                	test   %eax,%eax
  803fdf:	74 0f                	je     803ff0 <realloc_block_FF+0x58e>
  803fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe4:	8b 40 04             	mov    0x4(%eax),%eax
  803fe7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fea:	8b 12                	mov    (%edx),%edx
  803fec:	89 10                	mov    %edx,(%eax)
  803fee:	eb 0a                	jmp    803ffa <realloc_block_FF+0x598>
  803ff0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff3:	8b 00                	mov    (%eax),%eax
  803ff5:	a3 34 50 80 00       	mov    %eax,0x805034
  803ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80400d:	a1 40 50 80 00       	mov    0x805040,%eax
  804012:	48                   	dec    %eax
  804013:	a3 40 50 80 00       	mov    %eax,0x805040

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804018:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80401b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80401e:	01 d0                	add    %edx,%eax
  804020:	83 ec 04             	sub    $0x4,%esp
  804023:	6a 01                	push   $0x1
  804025:	50                   	push   %eax
  804026:	ff 75 08             	pushl  0x8(%ebp)
  804029:	e8 41 ea ff ff       	call   802a6f <set_block_data>
  80402e:	83 c4 10             	add    $0x10,%esp
  804031:	e9 36 01 00 00       	jmp    80416c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804036:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804039:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80403c:	01 d0                	add    %edx,%eax
  80403e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804041:	83 ec 04             	sub    $0x4,%esp
  804044:	6a 01                	push   $0x1
  804046:	ff 75 f0             	pushl  -0x10(%ebp)
  804049:	ff 75 08             	pushl  0x8(%ebp)
  80404c:	e8 1e ea ff ff       	call   802a6f <set_block_data>
  804051:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804054:	8b 45 08             	mov    0x8(%ebp),%eax
  804057:	83 e8 04             	sub    $0x4,%eax
  80405a:	8b 00                	mov    (%eax),%eax
  80405c:	83 e0 fe             	and    $0xfffffffe,%eax
  80405f:	89 c2                	mov    %eax,%edx
  804061:	8b 45 08             	mov    0x8(%ebp),%eax
  804064:	01 d0                	add    %edx,%eax
  804066:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804069:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80406d:	74 06                	je     804075 <realloc_block_FF+0x613>
  80406f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804073:	75 17                	jne    80408c <realloc_block_FF+0x62a>
  804075:	83 ec 04             	sub    $0x4,%esp
  804078:	68 84 4d 80 00       	push   $0x804d84
  80407d:	68 44 02 00 00       	push   $0x244
  804082:	68 11 4d 80 00       	push   $0x804d11
  804087:	e8 ea c7 ff ff       	call   800876 <_panic>
  80408c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408f:	8b 10                	mov    (%eax),%edx
  804091:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804094:	89 10                	mov    %edx,(%eax)
  804096:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804099:	8b 00                	mov    (%eax),%eax
  80409b:	85 c0                	test   %eax,%eax
  80409d:	74 0b                	je     8040aa <realloc_block_FF+0x648>
  80409f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a2:	8b 00                	mov    (%eax),%eax
  8040a4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040a7:	89 50 04             	mov    %edx,0x4(%eax)
  8040aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ad:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040b0:	89 10                	mov    %edx,(%eax)
  8040b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040b8:	89 50 04             	mov    %edx,0x4(%eax)
  8040bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040be:	8b 00                	mov    (%eax),%eax
  8040c0:	85 c0                	test   %eax,%eax
  8040c2:	75 08                	jne    8040cc <realloc_block_FF+0x66a>
  8040c4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8040cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8040d1:	40                   	inc    %eax
  8040d2:	a3 40 50 80 00       	mov    %eax,0x805040
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040db:	75 17                	jne    8040f4 <realloc_block_FF+0x692>
  8040dd:	83 ec 04             	sub    $0x4,%esp
  8040e0:	68 f3 4c 80 00       	push   $0x804cf3
  8040e5:	68 45 02 00 00       	push   $0x245
  8040ea:	68 11 4d 80 00       	push   $0x804d11
  8040ef:	e8 82 c7 ff ff       	call   800876 <_panic>
  8040f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f7:	8b 00                	mov    (%eax),%eax
  8040f9:	85 c0                	test   %eax,%eax
  8040fb:	74 10                	je     80410d <realloc_block_FF+0x6ab>
  8040fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804100:	8b 00                	mov    (%eax),%eax
  804102:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804105:	8b 52 04             	mov    0x4(%edx),%edx
  804108:	89 50 04             	mov    %edx,0x4(%eax)
  80410b:	eb 0b                	jmp    804118 <realloc_block_FF+0x6b6>
  80410d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804110:	8b 40 04             	mov    0x4(%eax),%eax
  804113:	a3 38 50 80 00       	mov    %eax,0x805038
  804118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411b:	8b 40 04             	mov    0x4(%eax),%eax
  80411e:	85 c0                	test   %eax,%eax
  804120:	74 0f                	je     804131 <realloc_block_FF+0x6cf>
  804122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804125:	8b 40 04             	mov    0x4(%eax),%eax
  804128:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80412b:	8b 12                	mov    (%edx),%edx
  80412d:	89 10                	mov    %edx,(%eax)
  80412f:	eb 0a                	jmp    80413b <realloc_block_FF+0x6d9>
  804131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804134:	8b 00                	mov    (%eax),%eax
  804136:	a3 34 50 80 00       	mov    %eax,0x805034
  80413b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80413e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80414e:	a1 40 50 80 00       	mov    0x805040,%eax
  804153:	48                   	dec    %eax
  804154:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(next_new_va, remaining_size, 0);
  804159:	83 ec 04             	sub    $0x4,%esp
  80415c:	6a 00                	push   $0x0
  80415e:	ff 75 bc             	pushl  -0x44(%ebp)
  804161:	ff 75 b8             	pushl  -0x48(%ebp)
  804164:	e8 06 e9 ff ff       	call   802a6f <set_block_data>
  804169:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80416c:	8b 45 08             	mov    0x8(%ebp),%eax
  80416f:	eb 0a                	jmp    80417b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804171:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804178:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80417b:	c9                   	leave  
  80417c:	c3                   	ret    

0080417d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80417d:	55                   	push   %ebp
  80417e:	89 e5                	mov    %esp,%ebp
  804180:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804183:	83 ec 04             	sub    $0x4,%esp
  804186:	68 08 4e 80 00       	push   $0x804e08
  80418b:	68 58 02 00 00       	push   $0x258
  804190:	68 11 4d 80 00       	push   $0x804d11
  804195:	e8 dc c6 ff ff       	call   800876 <_panic>

0080419a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80419a:	55                   	push   %ebp
  80419b:	89 e5                	mov    %esp,%ebp
  80419d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8041a0:	83 ec 04             	sub    $0x4,%esp
  8041a3:	68 30 4e 80 00       	push   $0x804e30
  8041a8:	68 61 02 00 00       	push   $0x261
  8041ad:	68 11 4d 80 00       	push   $0x804d11
  8041b2:	e8 bf c6 ff ff       	call   800876 <_panic>
  8041b7:	90                   	nop

008041b8 <__udivdi3>:
  8041b8:	55                   	push   %ebp
  8041b9:	57                   	push   %edi
  8041ba:	56                   	push   %esi
  8041bb:	53                   	push   %ebx
  8041bc:	83 ec 1c             	sub    $0x1c,%esp
  8041bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041cf:	89 ca                	mov    %ecx,%edx
  8041d1:	89 f8                	mov    %edi,%eax
  8041d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041d7:	85 f6                	test   %esi,%esi
  8041d9:	75 2d                	jne    804208 <__udivdi3+0x50>
  8041db:	39 cf                	cmp    %ecx,%edi
  8041dd:	77 65                	ja     804244 <__udivdi3+0x8c>
  8041df:	89 fd                	mov    %edi,%ebp
  8041e1:	85 ff                	test   %edi,%edi
  8041e3:	75 0b                	jne    8041f0 <__udivdi3+0x38>
  8041e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ea:	31 d2                	xor    %edx,%edx
  8041ec:	f7 f7                	div    %edi
  8041ee:	89 c5                	mov    %eax,%ebp
  8041f0:	31 d2                	xor    %edx,%edx
  8041f2:	89 c8                	mov    %ecx,%eax
  8041f4:	f7 f5                	div    %ebp
  8041f6:	89 c1                	mov    %eax,%ecx
  8041f8:	89 d8                	mov    %ebx,%eax
  8041fa:	f7 f5                	div    %ebp
  8041fc:	89 cf                	mov    %ecx,%edi
  8041fe:	89 fa                	mov    %edi,%edx
  804200:	83 c4 1c             	add    $0x1c,%esp
  804203:	5b                   	pop    %ebx
  804204:	5e                   	pop    %esi
  804205:	5f                   	pop    %edi
  804206:	5d                   	pop    %ebp
  804207:	c3                   	ret    
  804208:	39 ce                	cmp    %ecx,%esi
  80420a:	77 28                	ja     804234 <__udivdi3+0x7c>
  80420c:	0f bd fe             	bsr    %esi,%edi
  80420f:	83 f7 1f             	xor    $0x1f,%edi
  804212:	75 40                	jne    804254 <__udivdi3+0x9c>
  804214:	39 ce                	cmp    %ecx,%esi
  804216:	72 0a                	jb     804222 <__udivdi3+0x6a>
  804218:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80421c:	0f 87 9e 00 00 00    	ja     8042c0 <__udivdi3+0x108>
  804222:	b8 01 00 00 00       	mov    $0x1,%eax
  804227:	89 fa                	mov    %edi,%edx
  804229:	83 c4 1c             	add    $0x1c,%esp
  80422c:	5b                   	pop    %ebx
  80422d:	5e                   	pop    %esi
  80422e:	5f                   	pop    %edi
  80422f:	5d                   	pop    %ebp
  804230:	c3                   	ret    
  804231:	8d 76 00             	lea    0x0(%esi),%esi
  804234:	31 ff                	xor    %edi,%edi
  804236:	31 c0                	xor    %eax,%eax
  804238:	89 fa                	mov    %edi,%edx
  80423a:	83 c4 1c             	add    $0x1c,%esp
  80423d:	5b                   	pop    %ebx
  80423e:	5e                   	pop    %esi
  80423f:	5f                   	pop    %edi
  804240:	5d                   	pop    %ebp
  804241:	c3                   	ret    
  804242:	66 90                	xchg   %ax,%ax
  804244:	89 d8                	mov    %ebx,%eax
  804246:	f7 f7                	div    %edi
  804248:	31 ff                	xor    %edi,%edi
  80424a:	89 fa                	mov    %edi,%edx
  80424c:	83 c4 1c             	add    $0x1c,%esp
  80424f:	5b                   	pop    %ebx
  804250:	5e                   	pop    %esi
  804251:	5f                   	pop    %edi
  804252:	5d                   	pop    %ebp
  804253:	c3                   	ret    
  804254:	bd 20 00 00 00       	mov    $0x20,%ebp
  804259:	89 eb                	mov    %ebp,%ebx
  80425b:	29 fb                	sub    %edi,%ebx
  80425d:	89 f9                	mov    %edi,%ecx
  80425f:	d3 e6                	shl    %cl,%esi
  804261:	89 c5                	mov    %eax,%ebp
  804263:	88 d9                	mov    %bl,%cl
  804265:	d3 ed                	shr    %cl,%ebp
  804267:	89 e9                	mov    %ebp,%ecx
  804269:	09 f1                	or     %esi,%ecx
  80426b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80426f:	89 f9                	mov    %edi,%ecx
  804271:	d3 e0                	shl    %cl,%eax
  804273:	89 c5                	mov    %eax,%ebp
  804275:	89 d6                	mov    %edx,%esi
  804277:	88 d9                	mov    %bl,%cl
  804279:	d3 ee                	shr    %cl,%esi
  80427b:	89 f9                	mov    %edi,%ecx
  80427d:	d3 e2                	shl    %cl,%edx
  80427f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804283:	88 d9                	mov    %bl,%cl
  804285:	d3 e8                	shr    %cl,%eax
  804287:	09 c2                	or     %eax,%edx
  804289:	89 d0                	mov    %edx,%eax
  80428b:	89 f2                	mov    %esi,%edx
  80428d:	f7 74 24 0c          	divl   0xc(%esp)
  804291:	89 d6                	mov    %edx,%esi
  804293:	89 c3                	mov    %eax,%ebx
  804295:	f7 e5                	mul    %ebp
  804297:	39 d6                	cmp    %edx,%esi
  804299:	72 19                	jb     8042b4 <__udivdi3+0xfc>
  80429b:	74 0b                	je     8042a8 <__udivdi3+0xf0>
  80429d:	89 d8                	mov    %ebx,%eax
  80429f:	31 ff                	xor    %edi,%edi
  8042a1:	e9 58 ff ff ff       	jmp    8041fe <__udivdi3+0x46>
  8042a6:	66 90                	xchg   %ax,%ax
  8042a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042ac:	89 f9                	mov    %edi,%ecx
  8042ae:	d3 e2                	shl    %cl,%edx
  8042b0:	39 c2                	cmp    %eax,%edx
  8042b2:	73 e9                	jae    80429d <__udivdi3+0xe5>
  8042b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042b7:	31 ff                	xor    %edi,%edi
  8042b9:	e9 40 ff ff ff       	jmp    8041fe <__udivdi3+0x46>
  8042be:	66 90                	xchg   %ax,%ax
  8042c0:	31 c0                	xor    %eax,%eax
  8042c2:	e9 37 ff ff ff       	jmp    8041fe <__udivdi3+0x46>
  8042c7:	90                   	nop

008042c8 <__umoddi3>:
  8042c8:	55                   	push   %ebp
  8042c9:	57                   	push   %edi
  8042ca:	56                   	push   %esi
  8042cb:	53                   	push   %ebx
  8042cc:	83 ec 1c             	sub    $0x1c,%esp
  8042cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042e7:	89 f3                	mov    %esi,%ebx
  8042e9:	89 fa                	mov    %edi,%edx
  8042eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042ef:	89 34 24             	mov    %esi,(%esp)
  8042f2:	85 c0                	test   %eax,%eax
  8042f4:	75 1a                	jne    804310 <__umoddi3+0x48>
  8042f6:	39 f7                	cmp    %esi,%edi
  8042f8:	0f 86 a2 00 00 00    	jbe    8043a0 <__umoddi3+0xd8>
  8042fe:	89 c8                	mov    %ecx,%eax
  804300:	89 f2                	mov    %esi,%edx
  804302:	f7 f7                	div    %edi
  804304:	89 d0                	mov    %edx,%eax
  804306:	31 d2                	xor    %edx,%edx
  804308:	83 c4 1c             	add    $0x1c,%esp
  80430b:	5b                   	pop    %ebx
  80430c:	5e                   	pop    %esi
  80430d:	5f                   	pop    %edi
  80430e:	5d                   	pop    %ebp
  80430f:	c3                   	ret    
  804310:	39 f0                	cmp    %esi,%eax
  804312:	0f 87 ac 00 00 00    	ja     8043c4 <__umoddi3+0xfc>
  804318:	0f bd e8             	bsr    %eax,%ebp
  80431b:	83 f5 1f             	xor    $0x1f,%ebp
  80431e:	0f 84 ac 00 00 00    	je     8043d0 <__umoddi3+0x108>
  804324:	bf 20 00 00 00       	mov    $0x20,%edi
  804329:	29 ef                	sub    %ebp,%edi
  80432b:	89 fe                	mov    %edi,%esi
  80432d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804331:	89 e9                	mov    %ebp,%ecx
  804333:	d3 e0                	shl    %cl,%eax
  804335:	89 d7                	mov    %edx,%edi
  804337:	89 f1                	mov    %esi,%ecx
  804339:	d3 ef                	shr    %cl,%edi
  80433b:	09 c7                	or     %eax,%edi
  80433d:	89 e9                	mov    %ebp,%ecx
  80433f:	d3 e2                	shl    %cl,%edx
  804341:	89 14 24             	mov    %edx,(%esp)
  804344:	89 d8                	mov    %ebx,%eax
  804346:	d3 e0                	shl    %cl,%eax
  804348:	89 c2                	mov    %eax,%edx
  80434a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80434e:	d3 e0                	shl    %cl,%eax
  804350:	89 44 24 04          	mov    %eax,0x4(%esp)
  804354:	8b 44 24 08          	mov    0x8(%esp),%eax
  804358:	89 f1                	mov    %esi,%ecx
  80435a:	d3 e8                	shr    %cl,%eax
  80435c:	09 d0                	or     %edx,%eax
  80435e:	d3 eb                	shr    %cl,%ebx
  804360:	89 da                	mov    %ebx,%edx
  804362:	f7 f7                	div    %edi
  804364:	89 d3                	mov    %edx,%ebx
  804366:	f7 24 24             	mull   (%esp)
  804369:	89 c6                	mov    %eax,%esi
  80436b:	89 d1                	mov    %edx,%ecx
  80436d:	39 d3                	cmp    %edx,%ebx
  80436f:	0f 82 87 00 00 00    	jb     8043fc <__umoddi3+0x134>
  804375:	0f 84 91 00 00 00    	je     80440c <__umoddi3+0x144>
  80437b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80437f:	29 f2                	sub    %esi,%edx
  804381:	19 cb                	sbb    %ecx,%ebx
  804383:	89 d8                	mov    %ebx,%eax
  804385:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804389:	d3 e0                	shl    %cl,%eax
  80438b:	89 e9                	mov    %ebp,%ecx
  80438d:	d3 ea                	shr    %cl,%edx
  80438f:	09 d0                	or     %edx,%eax
  804391:	89 e9                	mov    %ebp,%ecx
  804393:	d3 eb                	shr    %cl,%ebx
  804395:	89 da                	mov    %ebx,%edx
  804397:	83 c4 1c             	add    $0x1c,%esp
  80439a:	5b                   	pop    %ebx
  80439b:	5e                   	pop    %esi
  80439c:	5f                   	pop    %edi
  80439d:	5d                   	pop    %ebp
  80439e:	c3                   	ret    
  80439f:	90                   	nop
  8043a0:	89 fd                	mov    %edi,%ebp
  8043a2:	85 ff                	test   %edi,%edi
  8043a4:	75 0b                	jne    8043b1 <__umoddi3+0xe9>
  8043a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ab:	31 d2                	xor    %edx,%edx
  8043ad:	f7 f7                	div    %edi
  8043af:	89 c5                	mov    %eax,%ebp
  8043b1:	89 f0                	mov    %esi,%eax
  8043b3:	31 d2                	xor    %edx,%edx
  8043b5:	f7 f5                	div    %ebp
  8043b7:	89 c8                	mov    %ecx,%eax
  8043b9:	f7 f5                	div    %ebp
  8043bb:	89 d0                	mov    %edx,%eax
  8043bd:	e9 44 ff ff ff       	jmp    804306 <__umoddi3+0x3e>
  8043c2:	66 90                	xchg   %ax,%ax
  8043c4:	89 c8                	mov    %ecx,%eax
  8043c6:	89 f2                	mov    %esi,%edx
  8043c8:	83 c4 1c             	add    $0x1c,%esp
  8043cb:	5b                   	pop    %ebx
  8043cc:	5e                   	pop    %esi
  8043cd:	5f                   	pop    %edi
  8043ce:	5d                   	pop    %ebp
  8043cf:	c3                   	ret    
  8043d0:	3b 04 24             	cmp    (%esp),%eax
  8043d3:	72 06                	jb     8043db <__umoddi3+0x113>
  8043d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043d9:	77 0f                	ja     8043ea <__umoddi3+0x122>
  8043db:	89 f2                	mov    %esi,%edx
  8043dd:	29 f9                	sub    %edi,%ecx
  8043df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043e3:	89 14 24             	mov    %edx,(%esp)
  8043e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043ee:	8b 14 24             	mov    (%esp),%edx
  8043f1:	83 c4 1c             	add    $0x1c,%esp
  8043f4:	5b                   	pop    %ebx
  8043f5:	5e                   	pop    %esi
  8043f6:	5f                   	pop    %edi
  8043f7:	5d                   	pop    %ebp
  8043f8:	c3                   	ret    
  8043f9:	8d 76 00             	lea    0x0(%esi),%esi
  8043fc:	2b 04 24             	sub    (%esp),%eax
  8043ff:	19 fa                	sbb    %edi,%edx
  804401:	89 d1                	mov    %edx,%ecx
  804403:	89 c6                	mov    %eax,%esi
  804405:	e9 71 ff ff ff       	jmp    80437b <__umoddi3+0xb3>
  80440a:	66 90                	xchg   %ax,%ax
  80440c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804410:	72 ea                	jb     8043fc <__umoddi3+0x134>
  804412:	89 d9                	mov    %ebx,%ecx
  804414:	e9 62 ff ff ff       	jmp    80437b <__umoddi3+0xb3>
