
obj/user/matrix_operations:     file format elf32-i386


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
  800031:	e8 d8 09 00 00       	call   800a0e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements);
int64** MatrixAddition(int **M1, int **M2, int NumOfElements);
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Line[255] ;
	char Chose ;
	int val =0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int NumOfElements = 3;
  800049:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	do
	{
		val = 0;
  800050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		NumOfElements = 3;
  800057:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80005e:	e8 ef 20 00 00       	call   802152 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 00 46 80 00       	push   $0x804600
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 04 46 80 00       	push   $0x804604
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 28 46 80 00       	push   $0x804628
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 04 46 80 00       	push   $0x804604
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 00 46 80 00       	push   $0x804600
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 4c 46 80 00       	push   $0x80464c
  8000c2:	e8 ee 11 00 00       	call   8012b5 <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 40 17 00 00       	call   80181d <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 6c 46 80 00       	push   $0x80466c
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 8e 46 80 00       	push   $0x80468e
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 9c 46 80 00       	push   $0x80469c
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 aa 46 80 00       	push   $0x8046aa
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 ba 46 80 00       	push   $0x8046ba
  80012b:	e8 f1 0a 00 00       	call   800c21 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800133:	e8 b9 08 00 00       	call   8009f1 <getchar>
  800138:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80013b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	e8 8a 08 00 00       	call   8009d2 <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	6a 0a                	push   $0xa
  800150:	e8 7d 08 00 00       	call   8009d2 <cputchar>
  800155:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800158:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  80015c:	74 0c                	je     80016a <_main+0x132>
  80015e:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800162:	74 06                	je     80016a <_main+0x132>
  800164:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800168:	75 b9                	jne    800123 <_main+0xeb>

		if (Chose == 'b')
  80016a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80016e:	75 30                	jne    8001a0 <_main+0x168>
		{
			readline("Enter the value to be initialized: ", Line);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	68 c4 46 80 00       	push   $0x8046c4
  80017f:	e8 31 11 00 00       	call   8012b5 <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 83 16 00 00       	call   80181d <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 c7 1f 00 00       	call   80216c <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 25 1a 00 00       	call   801bd9 <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 10 1a 00 00       	call   801bd9 <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (int i = 0; i < NumOfElements; ++i)
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	eb 4b                	jmp    800223 <_main+0x1eb>
		{
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
  8001d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8001e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 e2 19 00 00       	call   801bd9 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 03                	mov    %eax,(%ebx)
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
  8001fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800206:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800209:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	e8 be 19 00 00       	call   801bd9 <malloc>
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	89 03                	mov    %eax,(%ebx)
		sys_unlock_cons();

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
		int **M2 = malloc(sizeof(int) * NumOfElements) ;

		for (int i = 0; i < NumOfElements; ++i)
  800220:	ff 45 f0             	incl   -0x10(%ebp)
  800223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800229:	7c ad                	jl     8001d8 <_main+0x1a0>
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
		}

		int  i ;
		switch (Chose)
  80022b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80022f:	83 f8 62             	cmp    $0x62,%eax
  800232:	74 2e                	je     800262 <_main+0x22a>
  800234:	83 f8 63             	cmp    $0x63,%eax
  800237:	74 53                	je     80028c <_main+0x254>
  800239:	83 f8 61             	cmp    $0x61,%eax
  80023c:	75 72                	jne    8002b0 <_main+0x278>
		{
		case 'a':
			InitializeAscending(M1, NumOfElements);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 dc             	pushl  -0x24(%ebp)
  800247:	e8 9b 05 00 00       	call   8007e7 <InitializeAscending>
  80024c:	83 c4 10             	add    $0x10,%esp
			InitializeAscending(M2, NumOfElements);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 8a 05 00 00       	call   8007e7 <InitializeAscending>
  80025d:	83 c4 10             	add    $0x10,%esp
			break ;
  800260:	eb 70                	jmp    8002d2 <_main+0x29a>
		case 'b':
			InitializeIdentical(M1, NumOfElements, val);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 f4             	pushl  -0xc(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	e8 c3 05 00 00       	call   800836 <InitializeIdentical>
  800273:	83 c4 10             	add    $0x10,%esp
			InitializeIdentical(M2, NumOfElements, val);
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 f4             	pushl  -0xc(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 af 05 00 00       	call   800836 <InitializeIdentical>
  800287:	83 c4 10             	add    $0x10,%esp
			break ;
  80028a:	eb 46                	jmp    8002d2 <_main+0x29a>
		case 'c':
			InitializeSemiRandom(M1, NumOfElements);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	e8 eb 05 00 00       	call   800885 <InitializeSemiRandom>
  80029a:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 da 05 00 00       	call   800885 <InitializeSemiRandom>
  8002ab:	83 c4 10             	add    $0x10,%esp
			//PrintElements(M1, NumOfElements);
			break ;
  8002ae:	eb 22                	jmp    8002d2 <_main+0x29a>
		default:
			InitializeSemiRandom(M1, NumOfElements);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	e8 c7 05 00 00       	call   800885 <InitializeSemiRandom>
  8002be:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 b6 05 00 00       	call   800885 <InitializeSemiRandom>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
  8002d2:	e8 7b 1e 00 00       	call   802152 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 e8 46 80 00       	push   $0x8046e8
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 06 47 80 00       	push   $0x804706
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 1d 47 80 00       	push   $0x80471d
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 34 47 80 00       	push   $0x804734
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 ba 46 80 00       	push   $0x8046ba
  80031f:	e8 fd 08 00 00       	call   800c21 <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800327:	e8 c5 06 00 00       	call   8009f1 <getchar>
  80032c:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80032f:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	e8 96 06 00 00       	call   8009d2 <cputchar>
  80033c:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 0a                	push   $0xa
  800344:	e8 89 06 00 00       	call   8009d2 <cputchar>
  800349:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80034c:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800350:	74 0c                	je     80035e <_main+0x326>
  800352:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800356:	74 06                	je     80035e <_main+0x326>
  800358:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  80035c:	75 b9                	jne    800317 <_main+0x2df>
		sys_unlock_cons();
  80035e:	e8 09 1e 00 00       	call   80216c <sys_unlock_cons>


		int64** Res = NULL ;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		switch (Chose)
  80036a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80036e:	83 f8 62             	cmp    $0x62,%eax
  800371:	74 23                	je     800396 <_main+0x35e>
  800373:	83 f8 63             	cmp    $0x63,%eax
  800376:	74 37                	je     8003af <_main+0x377>
  800378:	83 f8 61             	cmp    $0x61,%eax
  80037b:	75 4b                	jne    8003c8 <_main+0x390>
		{
		case 'a':
			Res = MatrixAddition(M1, M2, NumOfElements);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 e4             	pushl  -0x1c(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 dc             	pushl  -0x24(%ebp)
  800389:	e8 9f 02 00 00       	call   80062d <MatrixAddition>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  800394:	eb 49                	jmp    8003df <_main+0x3a7>
		case 'b':
			Res = MatrixSubtraction(M1, M2, NumOfElements);
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	e8 62 03 00 00       	call   800709 <MatrixSubtraction>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003ad:	eb 30                	jmp    8003df <_main+0x3a7>
		case 'c':
			Res = MatrixMultiply(M1, M2, NumOfElements);
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	e8 1d 01 00 00       	call   8004dd <MatrixMultiply>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003c6:	eb 17                	jmp    8003df <_main+0x3a7>
		default:
			Res = MatrixAddition(M1, M2, NumOfElements);
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	e8 54 02 00 00       	call   80062d <MatrixAddition>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
		}


		sys_lock_cons();
  8003df:	e8 6e 1d 00 00       	call   802152 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 4b 47 80 00       	push   $0x80474b
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 73 1d 00 00       	call   80216c <sys_unlock_cons>

		for (int i = 0; i < NumOfElements; ++i)
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 5a                	jmp    80045c <_main+0x424>
		{
			free(M1[i]);
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	50                   	push   %eax
  800417:	e8 dc 19 00 00       	call   801df8 <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 bf 19 00 00       	call   801df8 <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 a2 19 00 00       	call   801df8 <free>
  800456:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
		cprintf("Operation is COMPLETED.\n");
		sys_unlock_cons();

		for (int i = 0; i < NumOfElements; ++i)
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	7c 9e                	jl     800402 <_main+0x3ca>
		{
			free(M1[i]);
			free(M2[i]);
			free(Res[i]);
		}
		free(M1) ;
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	e8 89 19 00 00       	call   801df8 <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 7b 19 00 00       	call   801df8 <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 6d 19 00 00       	call   801df8 <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 bf 1c 00 00       	call   802152 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 64 47 80 00       	push   $0x804764
  80049b:	e8 81 07 00 00       	call   800c21 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8004a3:	e8 49 05 00 00       	call   8009f1 <getchar>
  8004a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
		cputchar(Chose);
  8004ab:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	50                   	push   %eax
  8004b3:	e8 1a 05 00 00       	call   8009d2 <cputchar>
  8004b8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 0a                	push   $0xa
  8004c0:	e8 0d 05 00 00       	call   8009d2 <cputchar>
  8004c5:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8004c8:	e8 9f 1c 00 00       	call   80216c <sys_unlock_cons>

	} while (Chose == 'y');
  8004cd:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8004d1:	0f 84 79 fb ff ff    	je     800050 <_main+0x18>

}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <MatrixMultiply>:

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 e4 16 00 00       	call   801bd9 <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	eb 27                	jmp    80052b <MatrixMultiply+0x4e>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 b6 16 00 00       	call   801bd9 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 03                	mov    %eax,(%ebx)

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800528:	ff 45 e4             	incl   -0x1c(%ebp)
  80052b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7c d1                	jl     800504 <MatrixMultiply+0x27>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	e9 d7 00 00 00       	jmp    800616 <MatrixMultiply+0x139>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80053f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800546:	e9 bc 00 00 00       	jmp    800607 <MatrixMultiply+0x12a>
		{
			Res[i][j] = 0 ;
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055f:	c1 e2 03             	shl    $0x3,%edx
  800562:	01 d0                	add    %edx,%eax
  800564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80056a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (int k = 0; k < NumOfElements; ++k)
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800578:	eb 7e                	jmp    8005f8 <MatrixMultiply+0x11b>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
  80057a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058e:	c1 e2 03             	shl    $0x3,%edx
  800591:	8d 34 10             	lea    (%eax,%edx,1),%esi
  800594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a8:	c1 e2 03             	shl    $0x3,%edx
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	8b 08                	mov    (%eax),%ecx
  8005af:	8b 58 04             	mov    0x4(%eax),%ebx
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	c1 e2 02             	shl    $0x2,%edx
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	01 f8                	add    %edi,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e1:	c1 e7 02             	shl    $0x2,%edi
  8005e4:	01 f8                	add    %edi,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	0f af c2             	imul   %edx,%eax
  8005eb:	99                   	cltd   
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	11 da                	adc    %ebx,%edx
  8005f0:	89 06                	mov    %eax,(%esi)
  8005f2:	89 56 04             	mov    %edx,0x4(%esi)
	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = 0 ;
			for (int k = 0; k < NumOfElements; ++k)
  8005f5:	ff 45 d8             	incl   -0x28(%ebp)
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005fe:	0f 8c 76 ff ff ff    	jl     80057a <MatrixMultiply+0x9d>
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  800604:	ff 45 dc             	incl   -0x24(%ebp)
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80060d:	0f 8c 38 ff ff ff    	jl     80054b <MatrixMultiply+0x6e>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	3b 45 10             	cmp    0x10(%ebp),%eax
  80061c:	0f 8c 1d ff ff ff    	jl     80053f <MatrixMultiply+0x62>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
			}
		}
	}
	return Res;
  800622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800625:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800628:	5b                   	pop    %ebx
  800629:	5e                   	pop    %esi
  80062a:	5f                   	pop    %edi
  80062b:	5d                   	pop    %ebp
  80062c:	c3                   	ret    

0080062d <MatrixAddition>:

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800634:	8b 45 10             	mov    0x10(%ebp),%eax
  800637:	c1 e0 03             	shl    $0x3,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 96 15 00 00       	call   801bd9 <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800650:	eb 27                	jmp    800679 <MatrixAddition+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800655:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	50                   	push   %eax
  80066c:	e8 68 15 00 00       	call   801bd9 <malloc>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 03                	mov    %eax,(%ebx)

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800676:	ff 45 f4             	incl   -0xc(%ebp)
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80067f:	7c d1                	jl     800652 <MatrixAddition+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	eb 6f                	jmp    8006f9 <MatrixAddition+0xcc>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80068a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800691:	eb 5b                	jmp    8006ee <MatrixAddition+0xc1>
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006a7:	c1 e2 03             	shl    $0x3,%edx
  8006aa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c1:	c1 e2 02             	shl    $0x2,%edx
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8006dc:	c1 e3 02             	shl    $0x2,%ebx
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	99                   	cltd   
  8006e6:	89 01                	mov    %eax,(%ecx)
  8006e8:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8006eb:	ff 45 ec             	incl   -0x14(%ebp)
  8006ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006f4:	7c 9d                	jl     800693 <MatrixAddition+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8006f6:	ff 45 f0             	incl   -0x10(%ebp)
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006ff:	7c 89                	jl     80068a <MatrixAddition+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
		}
	}
	return Res;
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <MatrixSubtraction>:

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	c1 e0 03             	shl    $0x3,%eax
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	50                   	push   %eax
  80071a:	e8 ba 14 00 00       	call   801bd9 <malloc>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80072c:	eb 27                	jmp    800755 <MatrixSubtraction+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	c1 e0 03             	shl    $0x3,%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	e8 8c 14 00 00       	call   801bd9 <malloc>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 03                	mov    %eax,(%ebx)

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800752:	ff 45 f4             	incl   -0xc(%ebp)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075b:	7c d1                	jl     80072e <MatrixSubtraction+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  80075d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800764:	eb 71                	jmp    8007d7 <MatrixSubtraction+0xce>
	{
		for (int j = 0; j < NumOfElements; ++j)
  800766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80076d:	eb 5d                	jmp    8007cc <MatrixSubtraction+0xc3>
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077c:	01 d0                	add    %edx,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800783:	c1 e2 03             	shl    $0x3,%edx
  800786:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80079d:	c1 e2 02             	shl    $0x2,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a7:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8007b8:	c1 e3 02             	shl    $0x2,%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	99                   	cltd   
  8007c4:	89 01                	mov    %eax,(%ecx)
  8007c6:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8007c9:	ff 45 ec             	incl   -0x14(%ebp)
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007d2:	7c 9b                	jl     80076f <MatrixSubtraction+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8007d4:	ff 45 f0             	incl   -0x10(%ebp)
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007dd:	7c 87                	jl     800766 <MatrixSubtraction+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
		}
	}
	return Res;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <InitializeAscending>:

///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8007f4:	eb 35                	jmp    80082b <InitializeAscending+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8007f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8007fd:	eb 21                	jmp    800820 <InitializeAscending+0x39>
		{
			(Elements)[i][j] = j ;
  8007ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800813:	c1 e2 02             	shl    $0x2,%edx
  800816:	01 c2                	add    %eax,%edx
  800818:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80081b:	89 02                	mov    %eax,(%edx)
void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80081d:	ff 45 f8             	incl   -0x8(%ebp)
  800820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800823:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800826:	7c d7                	jl     8007ff <InitializeAscending+0x18>
///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800828:	ff 45 fc             	incl   -0x4(%ebp)
  80082b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80082e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800831:	7c c3                	jl     8007f6 <InitializeAscending+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = j ;
		}
	}
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <InitializeIdentical>:

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80083c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800843:	eb 35                	jmp    80087a <InitializeIdentical+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80084c:	eb 21                	jmp    80086f <InitializeIdentical+0x39>
		{
			(Elements)[i][j] = value ;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800862:	c1 e2 02             	shl    $0x2,%edx
  800865:	01 c2                	add    %eax,%edx
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 02                	mov    %eax,(%edx)
void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80086c:	ff 45 f8             	incl   -0x8(%ebp)
  80086f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800872:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800875:	7c d7                	jl     80084e <InitializeIdentical+0x18>
}

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800877:	ff 45 fc             	incl   -0x4(%ebp)
  80087a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800880:	7c c3                	jl     800845 <InitializeIdentical+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = value ;
		}
	}
}
  800882:	90                   	nop
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <InitializeSemiRandom>:

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 14             	sub    $0x14,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80088c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800893:	eb 51                	jmp    8008e6 <InitializeSemiRandom+0x61>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800895:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80089c:	eb 3d                	jmp    8008db <InitializeSemiRandom+0x56>
		{
			(Elements)[i][j] =  RAND(0, NumOfElements) ;
  80089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008b2:	c1 e2 02             	shl    $0x2,%edx
  8008b5:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
  8008b8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	50                   	push   %eax
  8008bf:	e8 56 1b 00 00       	call   80241a <sys_get_virtual_time>
  8008c4:	83 c4 0c             	add    $0xc,%esp
  8008c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	f7 f1                	div    %ecx
  8008d4:	89 d0                	mov    %edx,%eax
  8008d6:	89 03                	mov    %eax,(%ebx)
void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8008d8:	ff 45 f0             	incl   -0x10(%ebp)
  8008db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e1:	7c bb                	jl     80089e <InitializeSemiRandom+0x19>
}

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008e3:	ff 45 f4             	incl   -0xc(%ebp)
  8008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008ec:	7c a7                	jl     800895 <InitializeSemiRandom+0x10>
		{
			(Elements)[i][j] =  RAND(0, NumOfElements) ;
			//	cprintf("i=%d\n",i);
		}
	}
}
  8008ee:	90                   	nop
  8008ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <PrintElements>:

void PrintElements(int **Elements, int NumOfElements)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800901:	eb 53                	jmp    800956 <PrintElements+0x62>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80090a:	eb 2f                	jmp    80093b <PrintElements+0x47>
		{
			cprintf("%~%d, ",Elements[i][j]);
  80090c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800920:	c1 e2 02             	shl    $0x2,%edx
  800923:	01 d0                	add    %edx,%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	50                   	push   %eax
  80092b:	68 82 47 80 00       	push   $0x804782
  800930:	e8 ec 02 00 00       	call   800c21 <cprintf>
  800935:	83 c4 10             	add    $0x10,%esp
void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800938:	ff 45 f0             	incl   -0x10(%ebp)
  80093b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800941:	7c c9                	jl     80090c <PrintElements+0x18>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
  800943:	83 ec 0c             	sub    $0xc,%esp
  800946:	68 89 47 80 00       	push   $0x804789
  80094b:	e8 d1 02 00 00       	call   800c21 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
}

void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800953:	ff 45 f4             	incl   -0xc(%ebp)
  800956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800959:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80095c:	7c a5                	jl     800903 <PrintElements+0xf>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  80095e:	90                   	nop
  80095f:	c9                   	leave  
  800960:	c3                   	ret    

00800961 <PrintElements64>:

void PrintElements64(int64 **Elements, int NumOfElements)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80096e:	eb 57                	jmp    8009c7 <PrintElements64+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800970:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800977:	eb 33                	jmp    8009ac <PrintElements64+0x4b>
		{
			cprintf("%~%lld, ",Elements[i][j]);
  800979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	01 d0                	add    %edx,%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80098d:	c1 e2 03             	shl    $0x3,%edx
  800990:	01 d0                	add    %edx,%eax
  800992:	8b 50 04             	mov    0x4(%eax),%edx
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	52                   	push   %edx
  80099b:	50                   	push   %eax
  80099c:	68 8d 47 80 00       	push   $0x80478d
  8009a1:	e8 7b 02 00 00       	call   800c21 <cprintf>
  8009a6:	83 c4 10             	add    $0x10,%esp
void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8009a9:	ff 45 f0             	incl   -0x10(%ebp)
  8009ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b2:	7c c5                	jl     800979 <PrintElements64+0x18>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	68 89 47 80 00       	push   $0x804789
  8009bc:	e8 60 02 00 00       	call   800c21 <cprintf>
  8009c1:	83 c4 10             	add    $0x10,%esp
}

void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
  8009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009cd:	7c a1                	jl     800970 <PrintElements64+0xf>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  8009cf:	90                   	nop
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8009de:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	50                   	push   %eax
  8009e6:	e8 b2 18 00 00       	call   80229d <sys_cputc>
  8009eb:	83 c4 10             	add    $0x10,%esp
}
  8009ee:	90                   	nop
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <getchar>:


int
getchar(void)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8009f7:	e8 3d 17 00 00       	call   802139 <sys_cgetc>
  8009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8009ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <iscons>:

int iscons(int fdnum)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800a07:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800a14:	e8 b5 19 00 00       	call   8023ce <sys_getenvindex>
  800a19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	c1 e0 03             	shl    $0x3,%eax
  800a24:	01 d0                	add    %edx,%eax
  800a26:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800a2d:	01 c8                	add    %ecx,%eax
  800a2f:	01 c0                	add    %eax,%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800a3a:	01 c8                	add    %ecx,%eax
  800a3c:	01 d0                	add    %edx,%eax
  800a3e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a43:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a48:	a1 20 50 80 00       	mov    0x805020,%eax
  800a4d:	8a 40 20             	mov    0x20(%eax),%al
  800a50:	84 c0                	test   %al,%al
  800a52:	74 0d                	je     800a61 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800a54:	a1 20 50 80 00       	mov    0x805020,%eax
  800a59:	83 c0 20             	add    $0x20,%eax
  800a5c:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a65:	7e 0a                	jle    800a71 <libmain+0x63>
		binaryname = argv[0];
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	ff 75 08             	pushl  0x8(%ebp)
  800a7a:	e8 b9 f5 ff ff       	call   800038 <_main>
  800a7f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800a82:	e8 cb 16 00 00       	call   802152 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 b0 47 80 00       	push   $0x8047b0
  800a8f:	e8 8d 01 00 00       	call   800c21 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a97:	a1 20 50 80 00       	mov    0x805020,%eax
  800a9c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800aa2:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa7:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	50                   	push   %eax
  800ab2:	68 d8 47 80 00       	push   $0x8047d8
  800ab7:	e8 65 01 00 00       	call   800c21 <cprintf>
  800abc:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800abf:	a1 20 50 80 00       	mov    0x805020,%eax
  800ac4:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800aca:	a1 20 50 80 00       	mov    0x805020,%eax
  800acf:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800ad5:	a1 20 50 80 00       	mov    0x805020,%eax
  800ada:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800ae0:	51                   	push   %ecx
  800ae1:	52                   	push   %edx
  800ae2:	50                   	push   %eax
  800ae3:	68 00 48 80 00       	push   $0x804800
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 50 80 00       	mov    0x805020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 58 48 80 00       	push   $0x804858
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 b0 47 80 00       	push   $0x8047b0
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 4b 16 00 00       	call   80216c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800b21:	e8 19 00 00 00       	call   800b3f <exit>
}
  800b26:	90                   	nop
  800b27:	c9                   	leave  
  800b28:	c3                   	ret    

00800b29 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800b2f:	83 ec 0c             	sub    $0xc,%esp
  800b32:	6a 00                	push   $0x0
  800b34:	e8 61 18 00 00       	call   80239a <sys_destroy_env>
  800b39:	83 c4 10             	add    $0x10,%esp
}
  800b3c:	90                   	nop
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <exit>:

void
exit(void)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800b45:	e8 b6 18 00 00       	call   802400 <sys_exit_env>
}
  800b4a:	90                   	nop
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	89 0a                	mov    %ecx,(%edx)
  800b60:	8b 55 08             	mov    0x8(%ebp),%edx
  800b63:	88 d1                	mov    %dl,%cl
  800b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b68:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b76:	75 2c                	jne    800ba4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b78:	a0 28 50 80 00       	mov    0x805028,%al
  800b7d:	0f b6 c0             	movzbl %al,%eax
  800b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b83:	8b 12                	mov    (%edx),%edx
  800b85:	89 d1                	mov    %edx,%ecx
  800b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8a:	83 c2 08             	add    $0x8,%edx
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	50                   	push   %eax
  800b91:	51                   	push   %ecx
  800b92:	52                   	push   %edx
  800b93:	e8 78 15 00 00       	call   802110 <sys_cputs>
  800b98:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	8b 40 04             	mov    0x4(%eax),%eax
  800baa:	8d 50 01             	lea    0x1(%eax),%edx
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bb3:	90                   	nop
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bbf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bc6:	00 00 00 
	b.cnt = 0;
  800bc9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bd0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	ff 75 08             	pushl  0x8(%ebp)
  800bd9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	68 4d 0b 80 00       	push   $0x800b4d
  800be5:	e8 11 02 00 00       	call   800dfb <vprintfmt>
  800bea:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800bed:	a0 28 50 80 00       	mov    0x805028,%al
  800bf2:	0f b6 c0             	movzbl %al,%eax
  800bf5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800bfb:	83 ec 04             	sub    $0x4,%esp
  800bfe:	50                   	push   %eax
  800bff:	52                   	push   %edx
  800c00:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c06:	83 c0 08             	add    $0x8,%eax
  800c09:	50                   	push   %eax
  800c0a:	e8 01 15 00 00       	call   802110 <sys_cputs>
  800c0f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c12:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c19:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c27:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c2e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3d:	50                   	push   %eax
  800c3e:	e8 73 ff ff ff       	call   800bb6 <vcprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c54:	e8 f9 14 00 00       	call   802152 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c59:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	e8 48 ff ff ff       	call   800bb6 <vcprintf>
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c74:	e8 f3 14 00 00       	call   80216c <sys_unlock_cons>
	return cnt;
  800c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	53                   	push   %ebx
  800c82:	83 ec 14             	sub    $0x14,%esp
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c91:	8b 45 18             	mov    0x18(%ebp),%eax
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c9c:	77 55                	ja     800cf3 <printnum+0x75>
  800c9e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca1:	72 05                	jb     800ca8 <printnum+0x2a>
  800ca3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ca6:	77 4b                	ja     800cf3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cab:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cae:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	52                   	push   %edx
  800cb7:	50                   	push   %eax
  800cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cbe:	e8 cd 36 00 00       	call   804390 <__udivdi3>
  800cc3:	83 c4 10             	add    $0x10,%esp
  800cc6:	83 ec 04             	sub    $0x4,%esp
  800cc9:	ff 75 20             	pushl  0x20(%ebp)
  800ccc:	53                   	push   %ebx
  800ccd:	ff 75 18             	pushl  0x18(%ebp)
  800cd0:	52                   	push   %edx
  800cd1:	50                   	push   %eax
  800cd2:	ff 75 0c             	pushl  0xc(%ebp)
  800cd5:	ff 75 08             	pushl  0x8(%ebp)
  800cd8:	e8 a1 ff ff ff       	call   800c7e <printnum>
  800cdd:	83 c4 20             	add    $0x20,%esp
  800ce0:	eb 1a                	jmp    800cfc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	ff 75 20             	pushl  0x20(%ebp)
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cf3:	ff 4d 1c             	decl   0x1c(%ebp)
  800cf6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cfa:	7f e6                	jg     800ce2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cfc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d0a:	53                   	push   %ebx
  800d0b:	51                   	push   %ecx
  800d0c:	52                   	push   %edx
  800d0d:	50                   	push   %eax
  800d0e:	e8 8d 37 00 00       	call   8044a0 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 94 4a 80 00       	add    $0x804a94,%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f be c0             	movsbl %al,%eax
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	50                   	push   %eax
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
}
  800d2f:	90                   	nop
  800d30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d33:	c9                   	leave  
  800d34:	c3                   	ret    

00800d35 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d38:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d3c:	7e 1c                	jle    800d5a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	8d 50 08             	lea    0x8(%eax),%edx
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	89 10                	mov    %edx,(%eax)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	83 e8 08             	sub    $0x8,%eax
  800d53:	8b 50 04             	mov    0x4(%eax),%edx
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	eb 40                	jmp    800d9a <getuint+0x65>
	else if (lflag)
  800d5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5e:	74 1e                	je     800d7e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	8d 50 04             	lea    0x4(%eax),%edx
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 10                	mov    %edx,(%eax)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7c:	eb 1c                	jmp    800d9a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 50 04             	lea    0x4(%eax),%edx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	89 10                	mov    %edx,(%eax)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	83 e8 04             	sub    $0x4,%eax
  800d93:	8b 00                	mov    (%eax),%eax
  800d95:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d9f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800da3:	7e 1c                	jle    800dc1 <getint+0x25>
		return va_arg(*ap, long long);
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	8d 50 08             	lea    0x8(%eax),%edx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 10                	mov    %edx,(%eax)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	83 e8 08             	sub    $0x8,%eax
  800dba:	8b 50 04             	mov    0x4(%eax),%edx
  800dbd:	8b 00                	mov    (%eax),%eax
  800dbf:	eb 38                	jmp    800df9 <getint+0x5d>
	else if (lflag)
  800dc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc5:	74 1a                	je     800de1 <getint+0x45>
		return va_arg(*ap, long);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8b 00                	mov    (%eax),%eax
  800dcc:	8d 50 04             	lea    0x4(%eax),%edx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 10                	mov    %edx,(%eax)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8b 00                	mov    (%eax),%eax
  800dd9:	83 e8 04             	sub    $0x4,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	99                   	cltd   
  800ddf:	eb 18                	jmp    800df9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	8d 50 04             	lea    0x4(%eax),%edx
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	89 10                	mov    %edx,(%eax)
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	83 e8 04             	sub    $0x4,%eax
  800df6:	8b 00                	mov    (%eax),%eax
  800df8:	99                   	cltd   
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e03:	eb 17                	jmp    800e1c <vprintfmt+0x21>
			if (ch == '\0')
  800e05:	85 db                	test   %ebx,%ebx
  800e07:	0f 84 c1 03 00 00    	je     8011ce <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e0d:	83 ec 08             	sub    $0x8,%esp
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	53                   	push   %ebx
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 10             	mov    %edx,0x10(%ebp)
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	0f b6 d8             	movzbl %al,%ebx
  800e2a:	83 fb 25             	cmp    $0x25,%ebx
  800e2d:	75 d6                	jne    800e05 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e2f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e33:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e3a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e41:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 d8             	movzbl %al,%ebx
  800e5d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e60:	83 f8 5b             	cmp    $0x5b,%eax
  800e63:	0f 87 3d 03 00 00    	ja     8011a6 <vprintfmt+0x3ab>
  800e69:	8b 04 85 b8 4a 80 00 	mov    0x804ab8(,%eax,4),%eax
  800e70:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e72:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e76:	eb d7                	jmp    800e4f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e78:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e7c:	eb d1                	jmp    800e4f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e88:	89 d0                	mov    %edx,%eax
  800e8a:	c1 e0 02             	shl    $0x2,%eax
  800e8d:	01 d0                	add    %edx,%eax
  800e8f:	01 c0                	add    %eax,%eax
  800e91:	01 d8                	add    %ebx,%eax
  800e93:	83 e8 30             	sub    $0x30,%eax
  800e96:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e99:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ea1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ea4:	7e 3e                	jle    800ee4 <vprintfmt+0xe9>
  800ea6:	83 fb 39             	cmp    $0x39,%ebx
  800ea9:	7f 39                	jg     800ee4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eab:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eae:	eb d5                	jmp    800e85 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb3:	83 c0 04             	add    $0x4,%eax
  800eb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	83 e8 04             	sub    $0x4,%eax
  800ebf:	8b 00                	mov    (%eax),%eax
  800ec1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ec4:	eb 1f                	jmp    800ee5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ec6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eca:	79 83                	jns    800e4f <vprintfmt+0x54>
				width = 0;
  800ecc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ed3:	e9 77 ff ff ff       	jmp    800e4f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ed8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800edf:	e9 6b ff ff ff       	jmp    800e4f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ee4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ee5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee9:	0f 89 60 ff ff ff    	jns    800e4f <vprintfmt+0x54>
				width = precision, precision = -1;
  800eef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ef5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800efc:	e9 4e ff ff ff       	jmp    800e4f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f01:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f04:	e9 46 ff ff ff       	jmp    800e4f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f09:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0c:	83 c0 04             	add    $0x4,%eax
  800f0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f12:	8b 45 14             	mov    0x14(%ebp),%eax
  800f15:	83 e8 04             	sub    $0x4,%eax
  800f18:	8b 00                	mov    (%eax),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	50                   	push   %eax
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	ff d0                	call   *%eax
  800f26:	83 c4 10             	add    $0x10,%esp
			break;
  800f29:	e9 9b 02 00 00       	jmp    8011c9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f3f:	85 db                	test   %ebx,%ebx
  800f41:	79 02                	jns    800f45 <vprintfmt+0x14a>
				err = -err;
  800f43:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f45:	83 fb 64             	cmp    $0x64,%ebx
  800f48:	7f 0b                	jg     800f55 <vprintfmt+0x15a>
  800f4a:	8b 34 9d 00 49 80 00 	mov    0x804900(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 a5 4a 80 00       	push   $0x804aa5
  800f5b:	ff 75 0c             	pushl  0xc(%ebp)
  800f5e:	ff 75 08             	pushl  0x8(%ebp)
  800f61:	e8 70 02 00 00       	call   8011d6 <printfmt>
  800f66:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f69:	e9 5b 02 00 00       	jmp    8011c9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f6e:	56                   	push   %esi
  800f6f:	68 ae 4a 80 00       	push   $0x804aae
  800f74:	ff 75 0c             	pushl  0xc(%ebp)
  800f77:	ff 75 08             	pushl  0x8(%ebp)
  800f7a:	e8 57 02 00 00       	call   8011d6 <printfmt>
  800f7f:	83 c4 10             	add    $0x10,%esp
			break;
  800f82:	e9 42 02 00 00       	jmp    8011c9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	83 c0 04             	add    $0x4,%eax
  800f8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f90:	8b 45 14             	mov    0x14(%ebp),%eax
  800f93:	83 e8 04             	sub    $0x4,%eax
  800f96:	8b 30                	mov    (%eax),%esi
  800f98:	85 f6                	test   %esi,%esi
  800f9a:	75 05                	jne    800fa1 <vprintfmt+0x1a6>
				p = "(null)";
  800f9c:	be b1 4a 80 00       	mov    $0x804ab1,%esi
			if (width > 0 && padc != '-')
  800fa1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa5:	7e 6d                	jle    801014 <vprintfmt+0x219>
  800fa7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fab:	74 67                	je     801014 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	83 ec 08             	sub    $0x8,%esp
  800fb3:	50                   	push   %eax
  800fb4:	56                   	push   %esi
  800fb5:	e8 26 05 00 00       	call   8014e0 <strnlen>
  800fba:	83 c4 10             	add    $0x10,%esp
  800fbd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fc0:	eb 16                	jmp    800fd8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fc2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fc6:	83 ec 08             	sub    $0x8,%esp
  800fc9:	ff 75 0c             	pushl  0xc(%ebp)
  800fcc:	50                   	push   %eax
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	ff d0                	call   *%eax
  800fd2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fdc:	7f e4                	jg     800fc2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fde:	eb 34                	jmp    801014 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fe0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fe4:	74 1c                	je     801002 <vprintfmt+0x207>
  800fe6:	83 fb 1f             	cmp    $0x1f,%ebx
  800fe9:	7e 05                	jle    800ff0 <vprintfmt+0x1f5>
  800feb:	83 fb 7e             	cmp    $0x7e,%ebx
  800fee:	7e 12                	jle    801002 <vprintfmt+0x207>
					putch('?', putdat);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	6a 3f                	push   $0x3f
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	ff d0                	call   *%eax
  800ffd:	83 c4 10             	add    $0x10,%esp
  801000:	eb 0f                	jmp    801011 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	ff 75 0c             	pushl  0xc(%ebp)
  801008:	53                   	push   %ebx
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	ff d0                	call   *%eax
  80100e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801011:	ff 4d e4             	decl   -0x1c(%ebp)
  801014:	89 f0                	mov    %esi,%eax
  801016:	8d 70 01             	lea    0x1(%eax),%esi
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be d8             	movsbl %al,%ebx
  80101e:	85 db                	test   %ebx,%ebx
  801020:	74 24                	je     801046 <vprintfmt+0x24b>
  801022:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801026:	78 b8                	js     800fe0 <vprintfmt+0x1e5>
  801028:	ff 4d e0             	decl   -0x20(%ebp)
  80102b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80102f:	79 af                	jns    800fe0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801031:	eb 13                	jmp    801046 <vprintfmt+0x24b>
				putch(' ', putdat);
  801033:	83 ec 08             	sub    $0x8,%esp
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	6a 20                	push   $0x20
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	ff d0                	call   *%eax
  801040:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801043:	ff 4d e4             	decl   -0x1c(%ebp)
  801046:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80104a:	7f e7                	jg     801033 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80104c:	e9 78 01 00 00       	jmp    8011c9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	ff 75 e8             	pushl  -0x18(%ebp)
  801057:	8d 45 14             	lea    0x14(%ebp),%eax
  80105a:	50                   	push   %eax
  80105b:	e8 3c fd ff ff       	call   800d9c <getint>
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801066:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106f:	85 d2                	test   %edx,%edx
  801071:	79 23                	jns    801096 <vprintfmt+0x29b>
				putch('-', putdat);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 0c             	pushl  0xc(%ebp)
  801079:	6a 2d                	push   $0x2d
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	ff d0                	call   *%eax
  801080:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801089:	f7 d8                	neg    %eax
  80108b:	83 d2 00             	adc    $0x0,%edx
  80108e:	f7 da                	neg    %edx
  801090:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801093:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801096:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80109d:	e9 bc 00 00 00       	jmp    80115e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010a2:	83 ec 08             	sub    $0x8,%esp
  8010a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ab:	50                   	push   %eax
  8010ac:	e8 84 fc ff ff       	call   800d35 <getuint>
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c1:	e9 98 00 00 00       	jmp    80115e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	ff 75 0c             	pushl  0xc(%ebp)
  8010cc:	6a 58                	push   $0x58
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	ff d0                	call   *%eax
  8010d3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010d6:	83 ec 08             	sub    $0x8,%esp
  8010d9:	ff 75 0c             	pushl  0xc(%ebp)
  8010dc:	6a 58                	push   $0x58
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	ff d0                	call   *%eax
  8010e3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	6a 58                	push   $0x58
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	ff d0                	call   *%eax
  8010f3:	83 c4 10             	add    $0x10,%esp
			break;
  8010f6:	e9 ce 00 00 00       	jmp    8011c9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 30                	push   $0x30
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 78                	push   $0x78
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80111b:	8b 45 14             	mov    0x14(%ebp),%eax
  80111e:	83 c0 04             	add    $0x4,%eax
  801121:	89 45 14             	mov    %eax,0x14(%ebp)
  801124:	8b 45 14             	mov    0x14(%ebp),%eax
  801127:	83 e8 04             	sub    $0x4,%eax
  80112a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80112c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801136:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80113d:	eb 1f                	jmp    80115e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	ff 75 e8             	pushl  -0x18(%ebp)
  801145:	8d 45 14             	lea    0x14(%ebp),%eax
  801148:	50                   	push   %eax
  801149:	e8 e7 fb ff ff       	call   800d35 <getuint>
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801154:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801157:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80115e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	52                   	push   %edx
  801169:	ff 75 e4             	pushl  -0x1c(%ebp)
  80116c:	50                   	push   %eax
  80116d:	ff 75 f4             	pushl  -0xc(%ebp)
  801170:	ff 75 f0             	pushl  -0x10(%ebp)
  801173:	ff 75 0c             	pushl  0xc(%ebp)
  801176:	ff 75 08             	pushl  0x8(%ebp)
  801179:	e8 00 fb ff ff       	call   800c7e <printnum>
  80117e:	83 c4 20             	add    $0x20,%esp
			break;
  801181:	eb 46                	jmp    8011c9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801183:	83 ec 08             	sub    $0x8,%esp
  801186:	ff 75 0c             	pushl  0xc(%ebp)
  801189:	53                   	push   %ebx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	ff d0                	call   *%eax
  80118f:	83 c4 10             	add    $0x10,%esp
			break;
  801192:	eb 35                	jmp    8011c9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801194:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80119b:	eb 2c                	jmp    8011c9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80119d:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  8011a4:	eb 23                	jmp    8011c9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	6a 25                	push   $0x25
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	ff d0                	call   *%eax
  8011b3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011b6:	ff 4d 10             	decl   0x10(%ebp)
  8011b9:	eb 03                	jmp    8011be <vprintfmt+0x3c3>
  8011bb:	ff 4d 10             	decl   0x10(%ebp)
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	48                   	dec    %eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 25                	cmp    $0x25,%al
  8011c6:	75 f3                	jne    8011bb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011c8:	90                   	nop
		}
	}
  8011c9:	e9 35 fc ff ff       	jmp    800e03 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011ce:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8011df:	83 c0 04             	add    $0x4,%eax
  8011e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011eb:	50                   	push   %eax
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 04 fc ff ff       	call   800dfb <vprintfmt>
  8011f7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011fa:	90                   	nop
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	8b 40 08             	mov    0x8(%eax),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	8b 10                	mov    (%eax),%edx
  801214:	8b 45 0c             	mov    0xc(%ebp),%eax
  801217:	8b 40 04             	mov    0x4(%eax),%eax
  80121a:	39 c2                	cmp    %eax,%edx
  80121c:	73 12                	jae    801230 <sprintputch+0x33>
		*b->buf++ = ch;
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	8b 00                	mov    (%eax),%eax
  801223:	8d 48 01             	lea    0x1(%eax),%ecx
  801226:	8b 55 0c             	mov    0xc(%ebp),%edx
  801229:	89 0a                	mov    %ecx,(%edx)
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	88 10                	mov    %dl,(%eax)
}
  801230:	90                   	nop
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    

00801233 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	8d 50 ff             	lea    -0x1(%eax),%edx
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80124d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801258:	74 06                	je     801260 <vsnprintf+0x2d>
  80125a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125e:	7f 07                	jg     801267 <vsnprintf+0x34>
		return -E_INVAL;
  801260:	b8 03 00 00 00       	mov    $0x3,%eax
  801265:	eb 20                	jmp    801287 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801267:	ff 75 14             	pushl  0x14(%ebp)
  80126a:	ff 75 10             	pushl  0x10(%ebp)
  80126d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801270:	50                   	push   %eax
  801271:	68 fd 11 80 00       	push   $0x8011fd
  801276:	e8 80 fb ff ff       	call   800dfb <vprintfmt>
  80127b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80127e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801281:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80128f:	8d 45 10             	lea    0x10(%ebp),%eax
  801292:	83 c0 04             	add    $0x4,%eax
  801295:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	ff 75 f4             	pushl  -0xc(%ebp)
  80129e:	50                   	push   %eax
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	ff 75 08             	pushl  0x8(%ebp)
  8012a5:	e8 89 ff ff ff       	call   801233 <vsnprintf>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012bf:	74 13                	je     8012d4 <readline+0x1f>
		cprintf("%s", prompt);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	68 28 4c 80 00       	push   $0x804c28
  8012cc:	e8 50 f9 ff ff       	call   800c21 <cprintf>
  8012d1:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012db:	83 ec 0c             	sub    $0xc,%esp
  8012de:	6a 00                	push   $0x0
  8012e0:	e8 1f f7 ff ff       	call   800a04 <iscons>
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012eb:	e8 01 f7 ff ff       	call   8009f1 <getchar>
  8012f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f7:	79 22                	jns    80131b <readline+0x66>
			if (c != -E_EOF)
  8012f9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012fd:	0f 84 ad 00 00 00    	je     8013b0 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 ec             	pushl  -0x14(%ebp)
  801309:	68 2b 4c 80 00       	push   $0x804c2b
  80130e:	e8 0e f9 ff ff       	call   800c21 <cprintf>
  801313:	83 c4 10             	add    $0x10,%esp
			break;
  801316:	e9 95 00 00 00       	jmp    8013b0 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80131b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80131f:	7e 34                	jle    801355 <readline+0xa0>
  801321:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801328:	7f 2b                	jg     801355 <readline+0xa0>
			if (echoing)
  80132a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80132e:	74 0e                	je     80133e <readline+0x89>
				cputchar(c);
  801330:	83 ec 0c             	sub    $0xc,%esp
  801333:	ff 75 ec             	pushl  -0x14(%ebp)
  801336:	e8 97 f6 ff ff       	call   8009d2 <cputchar>
  80133b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801341:	8d 50 01             	lea    0x1(%eax),%edx
  801344:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801347:	89 c2                	mov    %eax,%edx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801351:	88 10                	mov    %dl,(%eax)
  801353:	eb 56                	jmp    8013ab <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801355:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801359:	75 1f                	jne    80137a <readline+0xc5>
  80135b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80135f:	7e 19                	jle    80137a <readline+0xc5>
			if (echoing)
  801361:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801365:	74 0e                	je     801375 <readline+0xc0>
				cputchar(c);
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	ff 75 ec             	pushl  -0x14(%ebp)
  80136d:	e8 60 f6 ff ff       	call   8009d2 <cputchar>
  801372:	83 c4 10             	add    $0x10,%esp

			i--;
  801375:	ff 4d f4             	decl   -0xc(%ebp)
  801378:	eb 31                	jmp    8013ab <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80137a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80137e:	74 0a                	je     80138a <readline+0xd5>
  801380:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801384:	0f 85 61 ff ff ff    	jne    8012eb <readline+0x36>
			if (echoing)
  80138a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138e:	74 0e                	je     80139e <readline+0xe9>
				cputchar(c);
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	ff 75 ec             	pushl  -0x14(%ebp)
  801396:	e8 37 f6 ff ff       	call   8009d2 <cputchar>
  80139b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013a9:	eb 06                	jmp    8013b1 <readline+0xfc>
		}
	}
  8013ab:	e9 3b ff ff ff       	jmp    8012eb <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013b0:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013b1:	90                   	nop
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013ba:	e8 93 0d 00 00       	call   802152 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 28 4c 80 00       	push   $0x804c28
  8013d0:	e8 4c f8 ff ff       	call   800c21 <cprintf>
  8013d5:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	6a 00                	push   $0x0
  8013e4:	e8 1b f6 ff ff       	call   800a04 <iscons>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013ef:	e8 fd f5 ff ff       	call   8009f1 <getchar>
  8013f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013fb:	79 22                	jns    80141f <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801401:	0f 84 ad 00 00 00    	je     8014b4 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801407:	83 ec 08             	sub    $0x8,%esp
  80140a:	ff 75 ec             	pushl  -0x14(%ebp)
  80140d:	68 2b 4c 80 00       	push   $0x804c2b
  801412:	e8 0a f8 ff ff       	call   800c21 <cprintf>
  801417:	83 c4 10             	add    $0x10,%esp
				break;
  80141a:	e9 95 00 00 00       	jmp    8014b4 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80141f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801423:	7e 34                	jle    801459 <atomic_readline+0xa5>
  801425:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80142c:	7f 2b                	jg     801459 <atomic_readline+0xa5>
				if (echoing)
  80142e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801432:	74 0e                	je     801442 <atomic_readline+0x8e>
					cputchar(c);
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	ff 75 ec             	pushl  -0x14(%ebp)
  80143a:	e8 93 f5 ff ff       	call   8009d2 <cputchar>
  80143f:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801445:	8d 50 01             	lea    0x1(%eax),%edx
  801448:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80144b:	89 c2                	mov    %eax,%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801455:	88 10                	mov    %dl,(%eax)
  801457:	eb 56                	jmp    8014af <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801459:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80145d:	75 1f                	jne    80147e <atomic_readline+0xca>
  80145f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801463:	7e 19                	jle    80147e <atomic_readline+0xca>
				if (echoing)
  801465:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801469:	74 0e                	je     801479 <atomic_readline+0xc5>
					cputchar(c);
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	ff 75 ec             	pushl  -0x14(%ebp)
  801471:	e8 5c f5 ff ff       	call   8009d2 <cputchar>
  801476:	83 c4 10             	add    $0x10,%esp
				i--;
  801479:	ff 4d f4             	decl   -0xc(%ebp)
  80147c:	eb 31                	jmp    8014af <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80147e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801482:	74 0a                	je     80148e <atomic_readline+0xda>
  801484:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801488:	0f 85 61 ff ff ff    	jne    8013ef <atomic_readline+0x3b>
				if (echoing)
  80148e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801492:	74 0e                	je     8014a2 <atomic_readline+0xee>
					cputchar(c);
  801494:	83 ec 0c             	sub    $0xc,%esp
  801497:	ff 75 ec             	pushl  -0x14(%ebp)
  80149a:	e8 33 f5 ff ff       	call   8009d2 <cputchar>
  80149f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	01 d0                	add    %edx,%eax
  8014aa:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014ad:	eb 06                	jmp    8014b5 <atomic_readline+0x101>
			}
		}
  8014af:	e9 3b ff ff ff       	jmp    8013ef <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014b4:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014b5:	e8 b2 0c 00 00       	call   80216c <sys_unlock_cons>
}
  8014ba:	90                   	nop
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ca:	eb 06                	jmp    8014d2 <strlen+0x15>
		n++;
  8014cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014cf:	ff 45 08             	incl   0x8(%ebp)
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	84 c0                	test   %al,%al
  8014d9:	75 f1                	jne    8014cc <strlen+0xf>
		n++;
	return n;
  8014db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ed:	eb 09                	jmp    8014f8 <strnlen+0x18>
		n++;
  8014ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014f2:	ff 45 08             	incl   0x8(%ebp)
  8014f5:	ff 4d 0c             	decl   0xc(%ebp)
  8014f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014fc:	74 09                	je     801507 <strnlen+0x27>
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	84 c0                	test   %al,%al
  801505:	75 e8                	jne    8014ef <strnlen+0xf>
		n++;
	return n;
  801507:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801518:	90                   	nop
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 08             	mov    %edx,0x8(%ebp)
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8d 4a 01             	lea    0x1(%edx),%ecx
  801528:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80152b:	8a 12                	mov    (%edx),%dl
  80152d:	88 10                	mov    %dl,(%eax)
  80152f:	8a 00                	mov    (%eax),%al
  801531:	84 c0                	test   %al,%al
  801533:	75 e4                	jne    801519 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801535:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80154d:	eb 1f                	jmp    80156e <strncpy+0x34>
		*dst++ = *src;
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8d 50 01             	lea    0x1(%eax),%edx
  801555:	89 55 08             	mov    %edx,0x8(%ebp)
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8a 12                	mov    (%edx),%dl
  80155d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80155f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801562:	8a 00                	mov    (%eax),%al
  801564:	84 c0                	test   %al,%al
  801566:	74 03                	je     80156b <strncpy+0x31>
			src++;
  801568:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80156b:	ff 45 fc             	incl   -0x4(%ebp)
  80156e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801571:	3b 45 10             	cmp    0x10(%ebp),%eax
  801574:	72 d9                	jb     80154f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801576:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158b:	74 30                	je     8015bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80158d:	eb 16                	jmp    8015a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 08             	mov    %edx,0x8(%ebp)
  801598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015a5:	ff 4d 10             	decl   0x10(%ebp)
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 09                	je     8015b7 <strlcpy+0x3c>
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	84 c0                	test   %al,%al
  8015b5:	75 d8                	jne    80158f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c3:	29 c2                	sub    %eax,%edx
  8015c5:	89 d0                	mov    %edx,%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015cc:	eb 06                	jmp    8015d4 <strcmp+0xb>
		p++, q++;
  8015ce:	ff 45 08             	incl   0x8(%ebp)
  8015d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8a 00                	mov    (%eax),%al
  8015d9:	84 c0                	test   %al,%al
  8015db:	74 0e                	je     8015eb <strcmp+0x22>
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 10                	mov    (%eax),%dl
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	38 c2                	cmp    %al,%dl
  8015e9:	74 e3                	je     8015ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	0f b6 d0             	movzbl %al,%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	0f b6 c0             	movzbl %al,%eax
  8015fb:	29 c2                	sub    %eax,%edx
  8015fd:	89 d0                	mov    %edx,%eax
}
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    

00801601 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801604:	eb 09                	jmp    80160f <strncmp+0xe>
		n--, p++, q++;
  801606:	ff 4d 10             	decl   0x10(%ebp)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80160f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801613:	74 17                	je     80162c <strncmp+0x2b>
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	84 c0                	test   %al,%al
  80161c:	74 0e                	je     80162c <strncmp+0x2b>
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8a 10                	mov    (%eax),%dl
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	38 c2                	cmp    %al,%dl
  80162a:	74 da                	je     801606 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80162c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801630:	75 07                	jne    801639 <strncmp+0x38>
		return 0;
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	eb 14                	jmp    80164d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	0f b6 d0             	movzbl %al,%edx
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	8a 00                	mov    (%eax),%al
  801646:	0f b6 c0             	movzbl %al,%eax
  801649:	29 c2                	sub    %eax,%edx
  80164b:	89 d0                	mov    %edx,%eax
}
  80164d:	5d                   	pop    %ebp
  80164e:	c3                   	ret    

0080164f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	8b 45 0c             	mov    0xc(%ebp),%eax
  801658:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80165b:	eb 12                	jmp    80166f <strchr+0x20>
		if (*s == c)
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801665:	75 05                	jne    80166c <strchr+0x1d>
			return (char *) s;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	eb 11                	jmp    80167d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80166c:	ff 45 08             	incl   0x8(%ebp)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	75 e5                	jne    80165d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80168b:	eb 0d                	jmp    80169a <strfind+0x1b>
		if (*s == c)
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801695:	74 0e                	je     8016a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801697:	ff 45 08             	incl   0x8(%ebp)
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	84 c0                	test   %al,%al
  8016a1:	75 ea                	jne    80168d <strfind+0xe>
  8016a3:	eb 01                	jmp    8016a6 <strfind+0x27>
		if (*s == c)
			break;
  8016a5:	90                   	nop
	return (char *) s;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016bd:	eb 0e                	jmp    8016cd <memset+0x22>
		*p++ = c;
  8016bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c2:	8d 50 01             	lea    0x1(%eax),%edx
  8016c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016cd:	ff 4d f8             	decl   -0x8(%ebp)
  8016d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016d4:	79 e9                	jns    8016bf <memset+0x14>
		*p++ = c;

	return v;
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016ed:	eb 16                	jmp    801705 <memcpy+0x2a>
		*d++ = *s++;
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	8d 50 01             	lea    0x1(%eax),%edx
  8016f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801701:	8a 12                	mov    (%edx),%dl
  801703:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801705:	8b 45 10             	mov    0x10(%ebp),%eax
  801708:	8d 50 ff             	lea    -0x1(%eax),%edx
  80170b:	89 55 10             	mov    %edx,0x10(%ebp)
  80170e:	85 c0                	test   %eax,%eax
  801710:	75 dd                	jne    8016ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801729:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80172f:	73 50                	jae    801781 <memmove+0x6a>
  801731:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801734:	8b 45 10             	mov    0x10(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80173c:	76 43                	jbe    801781 <memmove+0x6a>
		s += n;
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80174a:	eb 10                	jmp    80175c <memmove+0x45>
			*--d = *--s;
  80174c:	ff 4d f8             	decl   -0x8(%ebp)
  80174f:	ff 4d fc             	decl   -0x4(%ebp)
  801752:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801755:	8a 10                	mov    (%eax),%dl
  801757:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80175c:	8b 45 10             	mov    0x10(%ebp),%eax
  80175f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801762:	89 55 10             	mov    %edx,0x10(%ebp)
  801765:	85 c0                	test   %eax,%eax
  801767:	75 e3                	jne    80174c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801769:	eb 23                	jmp    80178e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176e:	8d 50 01             	lea    0x1(%eax),%edx
  801771:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801774:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801777:	8d 4a 01             	lea    0x1(%edx),%ecx
  80177a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80177d:	8a 12                	mov    (%edx),%dl
  80177f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	8d 50 ff             	lea    -0x1(%eax),%edx
  801787:	89 55 10             	mov    %edx,0x10(%ebp)
  80178a:	85 c0                	test   %eax,%eax
  80178c:	75 dd                	jne    80176b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80179f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017a5:	eb 2a                	jmp    8017d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8017a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017aa:	8a 10                	mov    (%eax),%dl
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	38 c2                	cmp    %al,%dl
  8017b3:	74 16                	je     8017cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	0f b6 d0             	movzbl %al,%edx
  8017bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	0f b6 c0             	movzbl %al,%eax
  8017c5:	29 c2                	sub    %eax,%edx
  8017c7:	89 d0                	mov    %edx,%eax
  8017c9:	eb 18                	jmp    8017e3 <memcmp+0x50>
		s1++, s2++;
  8017cb:	ff 45 fc             	incl   -0x4(%ebp)
  8017ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	75 c9                	jne    8017a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f1:	01 d0                	add    %edx,%eax
  8017f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017f6:	eb 15                	jmp    80180d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	0f b6 d0             	movzbl %al,%edx
  801800:	8b 45 0c             	mov    0xc(%ebp),%eax
  801803:	0f b6 c0             	movzbl %al,%eax
  801806:	39 c2                	cmp    %eax,%edx
  801808:	74 0d                	je     801817 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801813:	72 e3                	jb     8017f8 <memfind+0x13>
  801815:	eb 01                	jmp    801818 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801817:	90                   	nop
	return (void *) s;
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801823:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80182a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801831:	eb 03                	jmp    801836 <strtol+0x19>
		s++;
  801833:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	8a 00                	mov    (%eax),%al
  80183b:	3c 20                	cmp    $0x20,%al
  80183d:	74 f4                	je     801833 <strtol+0x16>
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	3c 09                	cmp    $0x9,%al
  801846:	74 eb                	je     801833 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	8a 00                	mov    (%eax),%al
  80184d:	3c 2b                	cmp    $0x2b,%al
  80184f:	75 05                	jne    801856 <strtol+0x39>
		s++;
  801851:	ff 45 08             	incl   0x8(%ebp)
  801854:	eb 13                	jmp    801869 <strtol+0x4c>
	else if (*s == '-')
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	3c 2d                	cmp    $0x2d,%al
  80185d:	75 0a                	jne    801869 <strtol+0x4c>
		s++, neg = 1;
  80185f:	ff 45 08             	incl   0x8(%ebp)
  801862:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801869:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80186d:	74 06                	je     801875 <strtol+0x58>
  80186f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801873:	75 20                	jne    801895 <strtol+0x78>
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	8a 00                	mov    (%eax),%al
  80187a:	3c 30                	cmp    $0x30,%al
  80187c:	75 17                	jne    801895 <strtol+0x78>
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	40                   	inc    %eax
  801882:	8a 00                	mov    (%eax),%al
  801884:	3c 78                	cmp    $0x78,%al
  801886:	75 0d                	jne    801895 <strtol+0x78>
		s += 2, base = 16;
  801888:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80188c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801893:	eb 28                	jmp    8018bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801895:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801899:	75 15                	jne    8018b0 <strtol+0x93>
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8a 00                	mov    (%eax),%al
  8018a0:	3c 30                	cmp    $0x30,%al
  8018a2:	75 0c                	jne    8018b0 <strtol+0x93>
		s++, base = 8;
  8018a4:	ff 45 08             	incl   0x8(%ebp)
  8018a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018ae:	eb 0d                	jmp    8018bd <strtol+0xa0>
	else if (base == 0)
  8018b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018b4:	75 07                	jne    8018bd <strtol+0xa0>
		base = 10;
  8018b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	3c 2f                	cmp    $0x2f,%al
  8018c4:	7e 19                	jle    8018df <strtol+0xc2>
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	8a 00                	mov    (%eax),%al
  8018cb:	3c 39                	cmp    $0x39,%al
  8018cd:	7f 10                	jg     8018df <strtol+0xc2>
			dig = *s - '0';
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	0f be c0             	movsbl %al,%eax
  8018d7:	83 e8 30             	sub    $0x30,%eax
  8018da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018dd:	eb 42                	jmp    801921 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	3c 60                	cmp    $0x60,%al
  8018e6:	7e 19                	jle    801901 <strtol+0xe4>
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	3c 7a                	cmp    $0x7a,%al
  8018ef:	7f 10                	jg     801901 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	0f be c0             	movsbl %al,%eax
  8018f9:	83 e8 57             	sub    $0x57,%eax
  8018fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ff:	eb 20                	jmp    801921 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	8a 00                	mov    (%eax),%al
  801906:	3c 40                	cmp    $0x40,%al
  801908:	7e 39                	jle    801943 <strtol+0x126>
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8a 00                	mov    (%eax),%al
  80190f:	3c 5a                	cmp    $0x5a,%al
  801911:	7f 30                	jg     801943 <strtol+0x126>
			dig = *s - 'A' + 10;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	0f be c0             	movsbl %al,%eax
  80191b:	83 e8 37             	sub    $0x37,%eax
  80191e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801924:	3b 45 10             	cmp    0x10(%ebp),%eax
  801927:	7d 19                	jge    801942 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801929:	ff 45 08             	incl   0x8(%ebp)
  80192c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801933:	89 c2                	mov    %eax,%edx
  801935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801938:	01 d0                	add    %edx,%eax
  80193a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80193d:	e9 7b ff ff ff       	jmp    8018bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801942:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801943:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801947:	74 08                	je     801951 <strtol+0x134>
		*endptr = (char *) s;
  801949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194c:	8b 55 08             	mov    0x8(%ebp),%edx
  80194f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801951:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801955:	74 07                	je     80195e <strtol+0x141>
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195a:	f7 d8                	neg    %eax
  80195c:	eb 03                	jmp    801961 <strtol+0x144>
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <ltostr>:

void
ltostr(long value, char *str)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801969:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801970:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801977:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80197b:	79 13                	jns    801990 <ltostr+0x2d>
	{
		neg = 1;
  80197d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801984:	8b 45 0c             	mov    0xc(%ebp),%eax
  801987:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80198a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80198d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801998:	99                   	cltd   
  801999:	f7 f9                	idiv   %ecx
  80199b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80199e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a1:	8d 50 01             	lea    0x1(%eax),%edx
  8019a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019a7:	89 c2                	mov    %eax,%edx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b1:	83 c2 30             	add    $0x30,%edx
  8019b4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019be:	f7 e9                	imul   %ecx
  8019c0:	c1 fa 02             	sar    $0x2,%edx
  8019c3:	89 c8                	mov    %ecx,%eax
  8019c5:	c1 f8 1f             	sar    $0x1f,%eax
  8019c8:	29 c2                	sub    %eax,%edx
  8019ca:	89 d0                	mov    %edx,%eax
  8019cc:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8019cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019d3:	75 bb                	jne    801990 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019df:	48                   	dec    %eax
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019e7:	74 3d                	je     801a26 <ltostr+0xc3>
		start = 1 ;
  8019e9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019f0:	eb 34                	jmp    801a26 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f8:	01 d0                	add    %edx,%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a05:	01 c2                	add    %eax,%edx
  801a07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0d:	01 c8                	add    %ecx,%eax
  801a0f:	8a 00                	mov    (%eax),%al
  801a11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a19:	01 c2                	add    %eax,%edx
  801a1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a2c:	7c c4                	jl     8019f2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	01 d0                	add    %edx,%eax
  801a36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	e8 73 fa ff ff       	call   8014bd <strlen>
  801a4a:	83 c4 04             	add    $0x4,%esp
  801a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 65 fa ff ff       	call   8014bd <strlen>
  801a58:	83 c4 04             	add    $0x4,%esp
  801a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a6c:	eb 17                	jmp    801a85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	01 c2                	add    %eax,%edx
  801a76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	01 c8                	add    %ecx,%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a82:	ff 45 fc             	incl   -0x4(%ebp)
  801a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a8b:	7c e1                	jl     801a6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a9b:	eb 1f                	jmp    801abc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa0:	8d 50 01             	lea    0x1(%eax),%edx
  801aa3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa6:	89 c2                	mov    %eax,%edx
  801aa8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aab:	01 c2                	add    %eax,%edx
  801aad:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab3:	01 c8                	add    %ecx,%eax
  801ab5:	8a 00                	mov    (%eax),%al
  801ab7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ab9:	ff 45 f8             	incl   -0x8(%ebp)
  801abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ac2:	7c d9                	jl     801a9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ac4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 d0                	add    %edx,%eax
  801acc:	c6 00 00             	movb   $0x0,(%eax)
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aea:	8b 45 10             	mov    0x10(%ebp),%eax
  801aed:	01 d0                	add    %edx,%eax
  801aef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801af5:	eb 0c                	jmp    801b03 <strsplit+0x31>
			*string++ = 0;
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	8d 50 01             	lea    0x1(%eax),%edx
  801afd:	89 55 08             	mov    %edx,0x8(%ebp)
  801b00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	8a 00                	mov    (%eax),%al
  801b08:	84 c0                	test   %al,%al
  801b0a:	74 18                	je     801b24 <strsplit+0x52>
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	8a 00                	mov    (%eax),%al
  801b11:	0f be c0             	movsbl %al,%eax
  801b14:	50                   	push   %eax
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	e8 32 fb ff ff       	call   80164f <strchr>
  801b1d:	83 c4 08             	add    $0x8,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	75 d3                	jne    801af7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	8a 00                	mov    (%eax),%al
  801b29:	84 c0                	test   %al,%al
  801b2b:	74 5a                	je     801b87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b30:	8b 00                	mov    (%eax),%eax
  801b32:	83 f8 0f             	cmp    $0xf,%eax
  801b35:	75 07                	jne    801b3e <strsplit+0x6c>
		{
			return 0;
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3c:	eb 66                	jmp    801ba4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b41:	8b 00                	mov    (%eax),%eax
  801b43:	8d 48 01             	lea    0x1(%eax),%ecx
  801b46:	8b 55 14             	mov    0x14(%ebp),%edx
  801b49:	89 0a                	mov    %ecx,(%edx)
  801b4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b52:	8b 45 10             	mov    0x10(%ebp),%eax
  801b55:	01 c2                	add    %eax,%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b5c:	eb 03                	jmp    801b61 <strsplit+0x8f>
			string++;
  801b5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	8a 00                	mov    (%eax),%al
  801b66:	84 c0                	test   %al,%al
  801b68:	74 8b                	je     801af5 <strsplit+0x23>
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	8a 00                	mov    (%eax),%al
  801b6f:	0f be c0             	movsbl %al,%eax
  801b72:	50                   	push   %eax
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	e8 d4 fa ff ff       	call   80164f <strchr>
  801b7b:	83 c4 08             	add    $0x8,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	74 dc                	je     801b5e <strsplit+0x8c>
			string++;
	}
  801b82:	e9 6e ff ff ff       	jmp    801af5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b88:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8b:	8b 00                	mov    (%eax),%eax
  801b8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b94:	8b 45 10             	mov    0x10(%ebp),%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	68 3c 4c 80 00       	push   $0x804c3c
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 5e 4c 80 00       	push   $0x804c5e
  801bbe:	e8 e4 25 00 00       	call   8041a7 <_panic>

00801bc3 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	e8 e7 0a 00 00       	call   8026bb <sys_sbrk>
  801bd4:	83 c4 10             	add    $0x10,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be3:	75 0a                	jne    801bef <malloc+0x16>
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bea:	e9 07 02 00 00       	jmp    801df6 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801bef:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bfc:	01 d0                	add    %edx,%eax
  801bfe:	48                   	dec    %eax
  801bff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c02:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c05:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0a:	f7 75 dc             	divl   -0x24(%ebp)
  801c0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c10:	29 d0                	sub    %edx,%eax
  801c12:	c1 e8 0c             	shr    $0xc,%eax
  801c15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801c18:	a1 20 50 80 00       	mov    0x805020,%eax
  801c1d:	8b 40 78             	mov    0x78(%eax),%eax
  801c20:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801c25:	29 c2                	sub    %eax,%edx
  801c27:	89 d0                	mov    %edx,%eax
  801c29:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801c2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c34:	c1 e8 0c             	shr    $0xc,%eax
  801c37:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801c3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c41:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c48:	77 42                	ja     801c8c <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c4a:	e8 f0 08 00 00       	call   80253f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 30 0e 00 00       	call   802a8e <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 02 09 00 00       	call   802570 <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 c9 12 00 00       	call   802f4a <alloc_block_BF>
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c87:	e9 67 01 00 00       	jmp    801df3 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801c8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c8f:	48                   	dec    %eax
  801c90:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c93:	0f 86 53 01 00 00    	jbe    801dec <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801c99:	a1 20 50 80 00       	mov    0x805020,%eax
  801c9e:	8b 40 78             	mov    0x78(%eax),%eax
  801ca1:	05 00 10 00 00       	add    $0x1000,%eax
  801ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801ca9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801cb0:	e9 de 00 00 00       	jmp    801d93 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801cb5:	a1 20 50 80 00       	mov    0x805020,%eax
  801cba:	8b 40 78             	mov    0x78(%eax),%eax
  801cbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cc0:	29 c2                	sub    %eax,%edx
  801cc2:	89 d0                	mov    %edx,%eax
  801cc4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc9:	c1 e8 0c             	shr    $0xc,%eax
  801ccc:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	0f 85 ab 00 00 00    	jne    801d86 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	05 00 10 00 00       	add    $0x1000,%eax
  801ce3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801ce6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801ced:	eb 47                	jmp    801d36 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801cef:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801cf6:	76 0a                	jbe    801d02 <malloc+0x129>
  801cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfd:	e9 f4 00 00 00       	jmp    801df6 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801d02:	a1 20 50 80 00       	mov    0x805020,%eax
  801d07:	8b 40 78             	mov    0x78(%eax),%eax
  801d0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d0d:	29 c2                	sub    %eax,%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d16:	c1 e8 0c             	shr    $0xc,%eax
  801d19:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d20:	85 c0                	test   %eax,%eax
  801d22:	74 08                	je     801d2c <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d27:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801d2a:	eb 5a                	jmp    801d86 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801d2c:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801d33:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801d36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d3d:	77 b0                	ja     801cef <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801d3f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801d46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d4d:	eb 2f                	jmp    801d7e <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d52:	c1 e0 0c             	shl    $0xc,%eax
  801d55:	89 c2                	mov    %eax,%edx
  801d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5a:	01 c2                	add    %eax,%edx
  801d5c:	a1 20 50 80 00       	mov    0x805020,%eax
  801d61:	8b 40 78             	mov    0x78(%eax),%eax
  801d64:	29 c2                	sub    %eax,%edx
  801d66:	89 d0                	mov    %edx,%eax
  801d68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6d:	c1 e8 0c             	shr    $0xc,%eax
  801d70:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801d77:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801d7b:	ff 45 e0             	incl   -0x20(%ebp)
  801d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d81:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d84:	72 c9                	jb     801d4f <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801d86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d8a:	75 16                	jne    801da2 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801d8c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801d93:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801d9a:	0f 86 15 ff ff ff    	jbe    801cb5 <malloc+0xdc>
  801da0:	eb 01                	jmp    801da3 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801da2:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801da3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801da7:	75 07                	jne    801db0 <malloc+0x1d7>
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dae:	eb 46                	jmp    801df6 <malloc+0x21d>
		ptr = (void*)i;
  801db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801db6:	a1 20 50 80 00       	mov    0x805020,%eax
  801dbb:	8b 40 78             	mov    0x78(%eax),%eax
  801dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc1:	29 c2                	sub    %eax,%edx
  801dc3:	89 d0                	mov    %edx,%eax
  801dc5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dca:	c1 e8 0c             	shr    $0xc,%eax
  801dcd:	89 c2                	mov    %eax,%edx
  801dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dd2:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  801de2:	e8 0b 09 00 00       	call   8026f2 <sys_allocate_user_mem>
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	eb 07                	jmp    801df3 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
  801df1:	eb 03                	jmp    801df6 <malloc+0x21d>
	}
	return ptr;
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801dfe:	a1 20 50 80 00       	mov    0x805020,%eax
  801e03:	8b 40 78             	mov    0x78(%eax),%eax
  801e06:	05 00 10 00 00       	add    $0x1000,%eax
  801e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801e0e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801e15:	a1 20 50 80 00       	mov    0x805020,%eax
  801e1a:	8b 50 78             	mov    0x78(%eax),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	39 c2                	cmp    %eax,%edx
  801e22:	76 24                	jbe    801e48 <free+0x50>
		size = get_block_size(va);
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	ff 75 08             	pushl  0x8(%ebp)
  801e2a:	e8 df 08 00 00       	call   80270e <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 12 1b 00 00       	call   803952 <free_block>
  801e40:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801e43:	e9 ac 00 00 00       	jmp    801ef4 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e4e:	0f 82 89 00 00 00    	jb     801edd <free+0xe5>
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801e5c:	77 7f                	ja     801edd <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e61:	a1 20 50 80 00       	mov    0x805020,%eax
  801e66:	8b 40 78             	mov    0x78(%eax),%eax
  801e69:	29 c2                	sub    %eax,%edx
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e72:	c1 e8 0c             	shr    $0xc,%eax
  801e75:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e82:	c1 e0 0c             	shl    $0xc,%eax
  801e85:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801e88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e8f:	eb 2f                	jmp    801ec0 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	c1 e0 0c             	shl    $0xc,%eax
  801e97:	89 c2                	mov    %eax,%edx
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	01 c2                	add    %eax,%edx
  801e9e:	a1 20 50 80 00       	mov    0x805020,%eax
  801ea3:	8b 40 78             	mov    0x78(%eax),%eax
  801ea6:	29 c2                	sub    %eax,%edx
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eaf:	c1 e8 0c             	shr    $0xc,%eax
  801eb2:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801eb9:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801ebd:	ff 45 f4             	incl   -0xc(%ebp)
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ec6:	72 c9                	jb     801e91 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	83 ec 08             	sub    $0x8,%esp
  801ece:	ff 75 ec             	pushl  -0x14(%ebp)
  801ed1:	50                   	push   %eax
  801ed2:	e8 ff 07 00 00       	call   8026d6 <sys_free_user_mem>
  801ed7:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801eda:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801edb:	eb 17                	jmp    801ef4 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	68 6c 4c 80 00       	push   $0x804c6c
  801ee5:	68 85 00 00 00       	push   $0x85
  801eea:	68 96 4c 80 00       	push   $0x804c96
  801eef:	e8 b3 22 00 00       	call   8041a7 <_panic>
	}
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 28             	sub    $0x28,%esp
  801efc:	8b 45 10             	mov    0x10(%ebp),%eax
  801eff:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801f02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f06:	75 0a                	jne    801f12 <smalloc+0x1c>
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	e9 9a 00 00 00       	jmp    801fac <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f18:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	39 d0                	cmp    %edx,%eax
  801f27:	73 02                	jae    801f2b <smalloc+0x35>
  801f29:	89 d0                	mov    %edx,%eax
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	50                   	push   %eax
  801f2f:	e8 a5 fc ff ff       	call   801bd9 <malloc>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801f3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3e:	75 07                	jne    801f47 <smalloc+0x51>
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	eb 65                	jmp    801fac <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f47:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f4b:	ff 75 ec             	pushl  -0x14(%ebp)
  801f4e:	50                   	push   %eax
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	e8 83 03 00 00       	call   8022dd <sys_createSharedObject>
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f60:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f64:	74 06                	je     801f6c <smalloc+0x76>
  801f66:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f6a:	75 07                	jne    801f73 <smalloc+0x7d>
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f71:	eb 39                	jmp    801fac <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801f73:	83 ec 08             	sub    $0x8,%esp
  801f76:	ff 75 ec             	pushl  -0x14(%ebp)
  801f79:	68 a2 4c 80 00       	push   $0x804ca2
  801f7e:	e8 9e ec ff ff       	call   800c21 <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801f86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f89:	a1 20 50 80 00       	mov    0x805020,%eax
  801f8e:	8b 40 78             	mov    0x78(%eax),%eax
  801f91:	29 c2                	sub    %eax,%edx
  801f93:	89 d0                	mov    %edx,%eax
  801f95:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f9a:	c1 e8 0c             	shr    $0xc,%eax
  801f9d:	89 c2                	mov    %eax,%edx
  801f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fb4:	83 ec 08             	sub    $0x8,%esp
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	e8 45 03 00 00       	call   802307 <sys_getSizeOfSharedObject>
  801fc2:	83 c4 10             	add    $0x10,%esp
  801fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801fc8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fcc:	75 07                	jne    801fd5 <sget+0x27>
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	eb 5c                	jmp    802031 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fdb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fe2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe8:	39 d0                	cmp    %edx,%eax
  801fea:	7d 02                	jge    801fee <sget+0x40>
  801fec:	89 d0                	mov    %edx,%eax
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	50                   	push   %eax
  801ff2:	e8 e2 fb ff ff       	call   801bd9 <malloc>
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ffd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802001:	75 07                	jne    80200a <sget+0x5c>
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	eb 27                	jmp    802031 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	ff 75 e8             	pushl  -0x18(%ebp)
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	e8 09 03 00 00       	call   802324 <sys_getSharedObject>
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802021:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802025:	75 07                	jne    80202e <sget+0x80>
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	eb 03                	jmp    802031 <sget+0x83>
	return ptr;
  80202e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802039:	8b 55 08             	mov    0x8(%ebp),%edx
  80203c:	a1 20 50 80 00       	mov    0x805020,%eax
  802041:	8b 40 78             	mov    0x78(%eax),%eax
  802044:	29 c2                	sub    %eax,%edx
  802046:	89 d0                	mov    %edx,%eax
  802048:	2d 00 10 00 00       	sub    $0x1000,%eax
  80204d:	c1 e8 0c             	shr    $0xc,%eax
  802050:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802057:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80205a:	83 ec 08             	sub    $0x8,%esp
  80205d:	ff 75 08             	pushl  0x8(%ebp)
  802060:	ff 75 f4             	pushl  -0xc(%ebp)
  802063:	e8 db 02 00 00       	call   802343 <sys_freeSharedObject>
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80206e:	90                   	nop
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	68 b4 4c 80 00       	push   $0x804cb4
  80207f:	68 dd 00 00 00       	push   $0xdd
  802084:	68 96 4c 80 00       	push   $0x804c96
  802089:	e8 19 21 00 00       	call   8041a7 <_panic>

0080208e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802094:	83 ec 04             	sub    $0x4,%esp
  802097:	68 da 4c 80 00       	push   $0x804cda
  80209c:	68 e9 00 00 00       	push   $0xe9
  8020a1:	68 96 4c 80 00       	push   $0x804c96
  8020a6:	e8 fc 20 00 00       	call   8041a7 <_panic>

008020ab <shrink>:

}
void shrink(uint32 newSize)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	68 da 4c 80 00       	push   $0x804cda
  8020b9:	68 ee 00 00 00       	push   $0xee
  8020be:	68 96 4c 80 00       	push   $0x804c96
  8020c3:	e8 df 20 00 00       	call   8041a7 <_panic>

008020c8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	68 da 4c 80 00       	push   $0x804cda
  8020d6:	68 f3 00 00 00       	push   $0xf3
  8020db:	68 96 4c 80 00       	push   $0x804c96
  8020e0:	e8 c2 20 00 00       	call   8041a7 <_panic>

008020e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	57                   	push   %edi
  8020e9:	56                   	push   %esi
  8020ea:	53                   	push   %ebx
  8020eb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020fa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020fd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802100:	cd 30                	int    $0x30
  802102:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802105:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5f                   	pop    %edi
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    

00802110 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	8b 45 10             	mov    0x10(%ebp),%eax
  802119:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80211c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	52                   	push   %edx
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	50                   	push   %eax
  80212c:	6a 00                	push   $0x0
  80212e:	e8 b2 ff ff ff       	call   8020e5 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_cgetc>:

int
sys_cgetc(void)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 02                	push   $0x2
  802148:	e8 98 ff ff ff       	call   8020e5 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 03                	push   $0x3
  802161:	e8 7f ff ff ff       	call   8020e5 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	90                   	nop
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 04                	push   $0x4
  80217b:	e8 65 ff ff ff       	call   8020e5 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	90                   	nop
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802189:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	52                   	push   %edx
  802196:	50                   	push   %eax
  802197:	6a 08                	push   $0x8
  802199:	e8 47 ff ff ff       	call   8020e5 <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	56                   	push   %esi
  8021a7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021a8:	8b 75 18             	mov    0x18(%ebp),%esi
  8021ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	51                   	push   %ecx
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 09                	push   $0x9
  8021be:	e8 22 ff ff ff       	call   8020e5 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c9:	5b                   	pop    %ebx
  8021ca:	5e                   	pop    %esi
  8021cb:	5d                   	pop    %ebp
  8021cc:	c3                   	ret    

008021cd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	52                   	push   %edx
  8021dd:	50                   	push   %eax
  8021de:	6a 0a                	push   $0xa
  8021e0:	e8 00 ff ff ff       	call   8020e5 <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	ff 75 08             	pushl  0x8(%ebp)
  8021f9:	6a 0b                	push   $0xb
  8021fb:	e8 e5 fe ff ff       	call   8020e5 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 0c                	push   $0xc
  802214:	e8 cc fe ff ff       	call   8020e5 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 0d                	push   $0xd
  80222d:	e8 b3 fe ff ff       	call   8020e5 <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 0e                	push   $0xe
  802246:	e8 9a fe ff ff       	call   8020e5 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 0f                	push   $0xf
  80225f:	e8 81 fe ff ff       	call   8020e5 <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	ff 75 08             	pushl  0x8(%ebp)
  802277:	6a 10                	push   $0x10
  802279:	e8 67 fe ff ff       	call   8020e5 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 11                	push   $0x11
  802292:	e8 4e fe ff ff       	call   8020e5 <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
}
  80229a:	90                   	nop
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_cputc>:

void
sys_cputc(const char c)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 04             	sub    $0x4,%esp
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	50                   	push   %eax
  8022b6:	6a 01                	push   $0x1
  8022b8:	e8 28 fe ff ff       	call   8020e5 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	90                   	nop
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 14                	push   $0x14
  8022d2:	e8 0e fe ff ff       	call   8020e5 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	51                   	push   %ecx
  8022f6:	52                   	push   %edx
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	50                   	push   %eax
  8022fb:	6a 15                	push   $0x15
  8022fd:	e8 e3 fd ff ff       	call   8020e5 <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 16                	push   $0x16
  80231a:	e8 c6 fd ff ff       	call   8020e5 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802327:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	51                   	push   %ecx
  802335:	52                   	push   %edx
  802336:	50                   	push   %eax
  802337:	6a 17                	push   $0x17
  802339:	e8 a7 fd ff ff       	call   8020e5 <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802346:	8b 55 0c             	mov    0xc(%ebp),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	52                   	push   %edx
  802353:	50                   	push   %eax
  802354:	6a 18                	push   $0x18
  802356:	e8 8a fd ff ff       	call   8020e5 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	6a 00                	push   $0x0
  802368:	ff 75 14             	pushl  0x14(%ebp)
  80236b:	ff 75 10             	pushl  0x10(%ebp)
  80236e:	ff 75 0c             	pushl  0xc(%ebp)
  802371:	50                   	push   %eax
  802372:	6a 19                	push   $0x19
  802374:	e8 6c fd ff ff       	call   8020e5 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	50                   	push   %eax
  80238d:	6a 1a                	push   $0x1a
  80238f:	e8 51 fd ff ff       	call   8020e5 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	90                   	nop
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	50                   	push   %eax
  8023a9:	6a 1b                	push   $0x1b
  8023ab:	e8 35 fd ff ff       	call   8020e5 <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 05                	push   $0x5
  8023c4:	e8 1c fd ff ff       	call   8020e5 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 06                	push   $0x6
  8023dd:	e8 03 fd ff ff       	call   8020e5 <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 07                	push   $0x7
  8023f6:	e8 ea fc ff ff       	call   8020e5 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_exit_env>:


void sys_exit_env(void)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 1c                	push   $0x1c
  80240f:	e8 d1 fc ff ff       	call   8020e5 <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	90                   	nop
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802420:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802423:	8d 50 04             	lea    0x4(%eax),%edx
  802426:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 1d                	push   $0x1d
  802433:	e8 ad fc ff ff       	call   8020e5 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
	return result;
  80243b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802441:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802444:	89 01                	mov    %eax,(%ecx)
  802446:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	c9                   	leave  
  80244d:	c2 04 00             	ret    $0x4

00802450 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	ff 75 10             	pushl  0x10(%ebp)
  80245a:	ff 75 0c             	pushl  0xc(%ebp)
  80245d:	ff 75 08             	pushl  0x8(%ebp)
  802460:	6a 13                	push   $0x13
  802462:	e8 7e fc ff ff       	call   8020e5 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
	return ;
  80246a:	90                   	nop
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_rcr2>:
uint32 sys_rcr2()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 1e                	push   $0x1e
  80247c:	e8 64 fc ff ff       	call   8020e5 <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802492:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	50                   	push   %eax
  80249f:	6a 1f                	push   $0x1f
  8024a1:	e8 3f fc ff ff       	call   8020e5 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a9:	90                   	nop
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <rsttst>:
void rsttst()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 21                	push   $0x21
  8024bb:	e8 25 fc ff ff       	call   8020e5 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c3:	90                   	nop
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 04             	sub    $0x4,%esp
  8024cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024d2:	8b 55 18             	mov    0x18(%ebp),%edx
  8024d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024d9:	52                   	push   %edx
  8024da:	50                   	push   %eax
  8024db:	ff 75 10             	pushl  0x10(%ebp)
  8024de:	ff 75 0c             	pushl  0xc(%ebp)
  8024e1:	ff 75 08             	pushl  0x8(%ebp)
  8024e4:	6a 20                	push   $0x20
  8024e6:	e8 fa fb ff ff       	call   8020e5 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ee:	90                   	nop
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <chktst>:
void chktst(uint32 n)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	ff 75 08             	pushl  0x8(%ebp)
  8024ff:	6a 22                	push   $0x22
  802501:	e8 df fb ff ff       	call   8020e5 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
	return ;
  802509:	90                   	nop
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <inctst>:

void inctst()
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 23                	push   $0x23
  80251b:	e8 c5 fb ff ff       	call   8020e5 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
	return ;
  802523:	90                   	nop
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <gettst>:
uint32 gettst()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 24                	push   $0x24
  802535:	e8 ab fb ff ff       	call   8020e5 <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 25                	push   $0x25
  802551:	e8 8f fb ff ff       	call   8020e5 <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
  802559:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80255c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802560:	75 07                	jne    802569 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802562:	b8 01 00 00 00       	mov    $0x1,%eax
  802567:	eb 05                	jmp    80256e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 25                	push   $0x25
  802582:	e8 5e fb ff ff       	call   8020e5 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
  80258a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80258d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802591:	75 07                	jne    80259a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802593:	b8 01 00 00 00       	mov    $0x1,%eax
  802598:	eb 05                	jmp    80259f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80259a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 25                	push   $0x25
  8025b3:	e8 2d fb ff ff       	call   8020e5 <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
  8025bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025be:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025c2:	75 07                	jne    8025cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c9:	eb 05                	jmp    8025d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 25                	push   $0x25
  8025e4:	e8 fc fa ff ff       	call   8020e5 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
  8025ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ef:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025f3:	75 07                	jne    8025fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fa:	eb 05                	jmp    802601 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	ff 75 08             	pushl  0x8(%ebp)
  802611:	6a 26                	push   $0x26
  802613:	e8 cd fa ff ff       	call   8020e5 <syscall>
  802618:	83 c4 18             	add    $0x18,%esp
	return ;
  80261b:	90                   	nop
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802622:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802625:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	6a 00                	push   $0x0
  802630:	53                   	push   %ebx
  802631:	51                   	push   %ecx
  802632:	52                   	push   %edx
  802633:	50                   	push   %eax
  802634:	6a 27                	push   $0x27
  802636:	e8 aa fa ff ff       	call   8020e5 <syscall>
  80263b:	83 c4 18             	add    $0x18,%esp
}
  80263e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802646:	8b 55 0c             	mov    0xc(%ebp),%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	52                   	push   %edx
  802653:	50                   	push   %eax
  802654:	6a 28                	push   $0x28
  802656:	e8 8a fa ff ff       	call   8020e5 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802663:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802666:	8b 55 0c             	mov    0xc(%ebp),%edx
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	6a 00                	push   $0x0
  80266e:	51                   	push   %ecx
  80266f:	ff 75 10             	pushl  0x10(%ebp)
  802672:	52                   	push   %edx
  802673:	50                   	push   %eax
  802674:	6a 29                	push   $0x29
  802676:	e8 6a fa ff ff       	call   8020e5 <syscall>
  80267b:	83 c4 18             	add    $0x18,%esp
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	ff 75 10             	pushl  0x10(%ebp)
  80268a:	ff 75 0c             	pushl  0xc(%ebp)
  80268d:	ff 75 08             	pushl  0x8(%ebp)
  802690:	6a 12                	push   $0x12
  802692:	e8 4e fa ff ff       	call   8020e5 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
	return ;
  80269a:	90                   	nop
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	52                   	push   %edx
  8026ad:	50                   	push   %eax
  8026ae:	6a 2a                	push   $0x2a
  8026b0:	e8 30 fa ff ff       	call   8020e5 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	50                   	push   %eax
  8026ca:	6a 2b                	push   $0x2b
  8026cc:	e8 14 fa ff ff       	call   8020e5 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	ff 75 0c             	pushl  0xc(%ebp)
  8026e2:	ff 75 08             	pushl  0x8(%ebp)
  8026e5:	6a 2c                	push   $0x2c
  8026e7:	e8 f9 f9 ff ff       	call   8020e5 <syscall>
  8026ec:	83 c4 18             	add    $0x18,%esp
	return;
  8026ef:	90                   	nop
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	ff 75 0c             	pushl  0xc(%ebp)
  8026fe:	ff 75 08             	pushl  0x8(%ebp)
  802701:	6a 2d                	push   $0x2d
  802703:	e8 dd f9 ff ff       	call   8020e5 <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
	return;
  80270b:	90                   	nop
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	83 e8 04             	sub    $0x4,%eax
  80271a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80271d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802725:	c9                   	leave  
  802726:	c3                   	ret    

00802727 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	83 e8 04             	sub    $0x4,%eax
  802733:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802736:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	83 e0 01             	and    $0x1,%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	0f 94 c0             	sete   %al
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80274b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802752:	8b 45 0c             	mov    0xc(%ebp),%eax
  802755:	83 f8 02             	cmp    $0x2,%eax
  802758:	74 2b                	je     802785 <alloc_block+0x40>
  80275a:	83 f8 02             	cmp    $0x2,%eax
  80275d:	7f 07                	jg     802766 <alloc_block+0x21>
  80275f:	83 f8 01             	cmp    $0x1,%eax
  802762:	74 0e                	je     802772 <alloc_block+0x2d>
  802764:	eb 58                	jmp    8027be <alloc_block+0x79>
  802766:	83 f8 03             	cmp    $0x3,%eax
  802769:	74 2d                	je     802798 <alloc_block+0x53>
  80276b:	83 f8 04             	cmp    $0x4,%eax
  80276e:	74 3b                	je     8027ab <alloc_block+0x66>
  802770:	eb 4c                	jmp    8027be <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802772:	83 ec 0c             	sub    $0xc,%esp
  802775:	ff 75 08             	pushl  0x8(%ebp)
  802778:	e8 11 03 00 00       	call   802a8e <alloc_block_FF>
  80277d:	83 c4 10             	add    $0x10,%esp
  802780:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802783:	eb 4a                	jmp    8027cf <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802785:	83 ec 0c             	sub    $0xc,%esp
  802788:	ff 75 08             	pushl  0x8(%ebp)
  80278b:	e8 fa 19 00 00       	call   80418a <alloc_block_NF>
  802790:	83 c4 10             	add    $0x10,%esp
  802793:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802796:	eb 37                	jmp    8027cf <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802798:	83 ec 0c             	sub    $0xc,%esp
  80279b:	ff 75 08             	pushl  0x8(%ebp)
  80279e:	e8 a7 07 00 00       	call   802f4a <alloc_block_BF>
  8027a3:	83 c4 10             	add    $0x10,%esp
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a9:	eb 24                	jmp    8027cf <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027ab:	83 ec 0c             	sub    $0xc,%esp
  8027ae:	ff 75 08             	pushl  0x8(%ebp)
  8027b1:	e8 b7 19 00 00       	call   80416d <alloc_block_WF>
  8027b6:	83 c4 10             	add    $0x10,%esp
  8027b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027bc:	eb 11                	jmp    8027cf <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	68 ec 4c 80 00       	push   $0x804cec
  8027c6:	e8 56 e4 ff ff       	call   800c21 <cprintf>
  8027cb:	83 c4 10             	add    $0x10,%esp
		break;
  8027ce:	90                   	nop
	}
	return va;
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	53                   	push   %ebx
  8027d8:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027db:	83 ec 0c             	sub    $0xc,%esp
  8027de:	68 0c 4d 80 00       	push   $0x804d0c
  8027e3:	e8 39 e4 ff ff       	call   800c21 <cprintf>
  8027e8:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	68 37 4d 80 00       	push   $0x804d37
  8027f3:	e8 29 e4 ff ff       	call   800c21 <cprintf>
  8027f8:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802801:	eb 37                	jmp    80283a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802803:	83 ec 0c             	sub    $0xc,%esp
  802806:	ff 75 f4             	pushl  -0xc(%ebp)
  802809:	e8 19 ff ff ff       	call   802727 <is_free_block>
  80280e:	83 c4 10             	add    $0x10,%esp
  802811:	0f be d8             	movsbl %al,%ebx
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	ff 75 f4             	pushl  -0xc(%ebp)
  80281a:	e8 ef fe ff ff       	call   80270e <get_block_size>
  80281f:	83 c4 10             	add    $0x10,%esp
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	53                   	push   %ebx
  802826:	50                   	push   %eax
  802827:	68 4f 4d 80 00       	push   $0x804d4f
  80282c:	e8 f0 e3 ff ff       	call   800c21 <cprintf>
  802831:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802834:	8b 45 10             	mov    0x10(%ebp),%eax
  802837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283e:	74 07                	je     802847 <print_blocks_list+0x73>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	eb 05                	jmp    80284c <print_blocks_list+0x78>
  802847:	b8 00 00 00 00       	mov    $0x0,%eax
  80284c:	89 45 10             	mov    %eax,0x10(%ebp)
  80284f:	8b 45 10             	mov    0x10(%ebp),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	75 ad                	jne    802803 <print_blocks_list+0x2f>
  802856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285a:	75 a7                	jne    802803 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80285c:	83 ec 0c             	sub    $0xc,%esp
  80285f:	68 0c 4d 80 00       	push   $0x804d0c
  802864:	e8 b8 e3 ff ff       	call   800c21 <cprintf>
  802869:	83 c4 10             	add    $0x10,%esp

}
  80286c:	90                   	nop
  80286d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287b:	83 e0 01             	and    $0x1,%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 03                	je     802885 <initialize_dynamic_allocator+0x13>
  802882:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802885:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802889:	0f 84 c7 01 00 00    	je     802a56 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80288f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802896:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802899:	8b 55 08             	mov    0x8(%ebp),%edx
  80289c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289f:	01 d0                	add    %edx,%eax
  8028a1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028a6:	0f 87 ad 01 00 00    	ja     802a59 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	0f 89 a5 01 00 00    	jns    802a5c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028bd:	01 d0                	add    %edx,%eax
  8028bf:	83 e8 04             	sub    $0x4,%eax
  8028c2:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8028c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d6:	e9 87 00 00 00       	jmp    802962 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	75 14                	jne    8028f5 <initialize_dynamic_allocator+0x83>
  8028e1:	83 ec 04             	sub    $0x4,%esp
  8028e4:	68 67 4d 80 00       	push   $0x804d67
  8028e9:	6a 79                	push   $0x79
  8028eb:	68 85 4d 80 00       	push   $0x804d85
  8028f0:	e8 b2 18 00 00       	call   8041a7 <_panic>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 10                	je     80290e <initialize_dynamic_allocator+0x9c>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 52 04             	mov    0x4(%edx),%edx
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	eb 0b                	jmp    802919 <initialize_dynamic_allocator+0xa7>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	a3 30 50 80 00       	mov    %eax,0x805030
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0f                	je     802932 <initialize_dynamic_allocator+0xc0>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	8b 12                	mov    (%edx),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	eb 0a                	jmp    80293c <initialize_dynamic_allocator+0xca>
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294f:	a1 38 50 80 00       	mov    0x805038,%eax
  802954:	48                   	dec    %eax
  802955:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80295a:	a1 34 50 80 00       	mov    0x805034,%eax
  80295f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802962:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802966:	74 07                	je     80296f <initialize_dynamic_allocator+0xfd>
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	eb 05                	jmp    802974 <initialize_dynamic_allocator+0x102>
  80296f:	b8 00 00 00 00       	mov    $0x0,%eax
  802974:	a3 34 50 80 00       	mov    %eax,0x805034
  802979:	a1 34 50 80 00       	mov    0x805034,%eax
  80297e:	85 c0                	test   %eax,%eax
  802980:	0f 85 55 ff ff ff    	jne    8028db <initialize_dynamic_allocator+0x69>
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	0f 85 4b ff ff ff    	jne    8028db <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80299f:	a1 44 50 80 00       	mov    0x805044,%eax
  8029a4:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8029a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	83 c0 08             	add    $0x8,%eax
  8029ba:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	83 c0 04             	add    $0x4,%eax
  8029c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c6:	83 ea 08             	sub    $0x8,%edx
  8029c9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	83 e8 08             	sub    $0x8,%eax
  8029d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d9:	83 ea 08             	sub    $0x8,%edx
  8029dc:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8029f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f5:	75 17                	jne    802a0e <initialize_dynamic_allocator+0x19c>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 a0 4d 80 00       	push   $0x804da0
  8029ff:	68 90 00 00 00       	push   $0x90
  802a04:	68 85 4d 80 00       	push   $0x804d85
  802a09:	e8 99 17 00 00       	call   8041a7 <_panic>
  802a0e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	89 10                	mov    %edx,(%eax)
  802a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 0d                	je     802a2f <initialize_dynamic_allocator+0x1bd>
  802a22:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	eb 08                	jmp    802a37 <initialize_dynamic_allocator+0x1c5>
  802a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a32:	a3 30 50 80 00       	mov    %eax,0x805030
  802a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a49:	a1 38 50 80 00       	mov    0x805038,%eax
  802a4e:	40                   	inc    %eax
  802a4f:	a3 38 50 80 00       	mov    %eax,0x805038
  802a54:	eb 07                	jmp    802a5d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a56:	90                   	nop
  802a57:	eb 04                	jmp    802a5d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a59:	90                   	nop
  802a5a:	eb 01                	jmp    802a5d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a5c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a5d:	c9                   	leave  
  802a5e:	c3                   	ret    

00802a5f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a5f:	55                   	push   %ebp
  802a60:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a62:	8b 45 10             	mov    0x10(%ebp),%eax
  802a65:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a71:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	83 e8 04             	sub    $0x4,%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	83 e0 fe             	and    $0xfffffffe,%eax
  802a7e:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	01 c2                	add    %eax,%edx
  802a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a89:	89 02                	mov    %eax,(%edx)
}
  802a8b:	90                   	nop
  802a8c:	5d                   	pop    %ebp
  802a8d:	c3                   	ret    

00802a8e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
  802a91:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	83 e0 01             	and    $0x1,%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	74 03                	je     802aa1 <alloc_block_FF+0x13>
  802a9e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802aa1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802aa5:	77 07                	ja     802aae <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802aa7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802aae:	a1 24 50 80 00       	mov    0x805024,%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	75 73                	jne    802b2a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	83 c0 10             	add    $0x10,%eax
  802abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ac0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acd:	01 d0                	add    %edx,%eax
  802acf:	48                   	dec    %eax
  802ad0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  802adb:	f7 75 ec             	divl   -0x14(%ebp)
  802ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae1:	29 d0                	sub    %edx,%eax
  802ae3:	c1 e8 0c             	shr    $0xc,%eax
  802ae6:	83 ec 0c             	sub    $0xc,%esp
  802ae9:	50                   	push   %eax
  802aea:	e8 d4 f0 ff ff       	call   801bc3 <sbrk>
  802aef:	83 c4 10             	add    $0x10,%esp
  802af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802af5:	83 ec 0c             	sub    $0xc,%esp
  802af8:	6a 00                	push   $0x0
  802afa:	e8 c4 f0 ff ff       	call   801bc3 <sbrk>
  802aff:	83 c4 10             	add    $0x10,%esp
  802b02:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b08:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b0b:	83 ec 08             	sub    $0x8,%esp
  802b0e:	50                   	push   %eax
  802b0f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b12:	e8 5b fd ff ff       	call   802872 <initialize_dynamic_allocator>
  802b17:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b1a:	83 ec 0c             	sub    $0xc,%esp
  802b1d:	68 c3 4d 80 00       	push   $0x804dc3
  802b22:	e8 fa e0 ff ff       	call   800c21 <cprintf>
  802b27:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2e:	75 0a                	jne    802b3a <alloc_block_FF+0xac>
	        return NULL;
  802b30:	b8 00 00 00 00       	mov    $0x0,%eax
  802b35:	e9 0e 04 00 00       	jmp    802f48 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b41:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b49:	e9 f3 02 00 00       	jmp    802e41 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b54:	83 ec 0c             	sub    $0xc,%esp
  802b57:	ff 75 bc             	pushl  -0x44(%ebp)
  802b5a:	e8 af fb ff ff       	call   80270e <get_block_size>
  802b5f:	83 c4 10             	add    $0x10,%esp
  802b62:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	83 c0 08             	add    $0x8,%eax
  802b6b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b6e:	0f 87 c5 02 00 00    	ja     802e39 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	83 c0 18             	add    $0x18,%eax
  802b7a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b7d:	0f 87 19 02 00 00    	ja     802d9c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b86:	2b 45 08             	sub    0x8(%ebp),%eax
  802b89:	83 e8 08             	sub    $0x8,%eax
  802b8c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	8d 50 08             	lea    0x8(%eax),%edx
  802b95:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	83 c0 08             	add    $0x8,%eax
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	6a 01                	push   $0x1
  802ba8:	50                   	push   %eax
  802ba9:	ff 75 bc             	pushl  -0x44(%ebp)
  802bac:	e8 ae fe ff ff       	call   802a5f <set_block_data>
  802bb1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	75 68                	jne    802c26 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bbe:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bc2:	75 17                	jne    802bdb <alloc_block_FF+0x14d>
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	68 a0 4d 80 00       	push   $0x804da0
  802bcc:	68 d7 00 00 00       	push   $0xd7
  802bd1:	68 85 4d 80 00       	push   $0x804d85
  802bd6:	e8 cc 15 00 00       	call   8041a7 <_panic>
  802bdb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802be1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0d                	je     802bfc <alloc_block_FF+0x16e>
  802bef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bf4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	eb 08                	jmp    802c04 <alloc_block_FF+0x176>
  802bfc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bff:	a3 30 50 80 00       	mov    %eax,0x805030
  802c04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c07:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c16:	a1 38 50 80 00       	mov    0x805038,%eax
  802c1b:	40                   	inc    %eax
  802c1c:	a3 38 50 80 00       	mov    %eax,0x805038
  802c21:	e9 dc 00 00 00       	jmp    802d02 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	75 65                	jne    802c94 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c2f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c33:	75 17                	jne    802c4c <alloc_block_FF+0x1be>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 d4 4d 80 00       	push   $0x804dd4
  802c3d:	68 db 00 00 00       	push   $0xdb
  802c42:	68 85 4d 80 00       	push   $0x804d85
  802c47:	e8 5b 15 00 00       	call   8041a7 <_panic>
  802c4c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c52:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0c                	je     802c6e <alloc_block_FF+0x1e0>
  802c62:	a1 30 50 80 00       	mov    0x805030,%eax
  802c67:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	eb 08                	jmp    802c76 <alloc_block_FF+0x1e8>
  802c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c71:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c79:	a3 30 50 80 00       	mov    %eax,0x805030
  802c7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c87:	a1 38 50 80 00       	mov    0x805038,%eax
  802c8c:	40                   	inc    %eax
  802c8d:	a3 38 50 80 00       	mov    %eax,0x805038
  802c92:	eb 6e                	jmp    802d02 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	74 06                	je     802ca0 <alloc_block_FF+0x212>
  802c9a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c9e:	75 17                	jne    802cb7 <alloc_block_FF+0x229>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 f8 4d 80 00       	push   $0x804df8
  802ca8:	68 df 00 00 00       	push   $0xdf
  802cad:	68 85 4d 80 00       	push   $0x804d85
  802cb2:	e8 f0 14 00 00       	call   8041a7 <_panic>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 10                	mov    (%eax),%edx
  802cbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0b                	je     802cd5 <alloc_block_FF+0x247>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cdb:	89 10                	mov    %edx,(%eax)
  802cdd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	75 08                	jne    802cf7 <alloc_block_FF+0x269>
  802cef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf2:	a3 30 50 80 00       	mov    %eax,0x805030
  802cf7:	a1 38 50 80 00       	mov    0x805038,%eax
  802cfc:	40                   	inc    %eax
  802cfd:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d06:	75 17                	jne    802d1f <alloc_block_FF+0x291>
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	68 67 4d 80 00       	push   $0x804d67
  802d10:	68 e1 00 00 00       	push   $0xe1
  802d15:	68 85 4d 80 00       	push   $0x804d85
  802d1a:	e8 88 14 00 00       	call   8041a7 <_panic>
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	74 10                	je     802d38 <alloc_block_FF+0x2aa>
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d30:	8b 52 04             	mov    0x4(%edx),%edx
  802d33:	89 50 04             	mov    %edx,0x4(%eax)
  802d36:	eb 0b                	jmp    802d43 <alloc_block_FF+0x2b5>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	a3 30 50 80 00       	mov    %eax,0x805030
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 0f                	je     802d5c <alloc_block_FF+0x2ce>
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d56:	8b 12                	mov    (%edx),%edx
  802d58:	89 10                	mov    %edx,(%eax)
  802d5a:	eb 0a                	jmp    802d66 <alloc_block_FF+0x2d8>
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d79:	a1 38 50 80 00       	mov    0x805038,%eax
  802d7e:	48                   	dec    %eax
  802d7f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	6a 00                	push   $0x0
  802d89:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d8c:	ff 75 b0             	pushl  -0x50(%ebp)
  802d8f:	e8 cb fc ff ff       	call   802a5f <set_block_data>
  802d94:	83 c4 10             	add    $0x10,%esp
  802d97:	e9 95 00 00 00       	jmp    802e31 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	6a 01                	push   $0x1
  802da1:	ff 75 b8             	pushl  -0x48(%ebp)
  802da4:	ff 75 bc             	pushl  -0x44(%ebp)
  802da7:	e8 b3 fc ff ff       	call   802a5f <set_block_data>
  802dac:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db3:	75 17                	jne    802dcc <alloc_block_FF+0x33e>
  802db5:	83 ec 04             	sub    $0x4,%esp
  802db8:	68 67 4d 80 00       	push   $0x804d67
  802dbd:	68 e8 00 00 00       	push   $0xe8
  802dc2:	68 85 4d 80 00       	push   $0x804d85
  802dc7:	e8 db 13 00 00       	call   8041a7 <_panic>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	74 10                	je     802de5 <alloc_block_FF+0x357>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddd:	8b 52 04             	mov    0x4(%edx),%edx
  802de0:	89 50 04             	mov    %edx,0x4(%eax)
  802de3:	eb 0b                	jmp    802df0 <alloc_block_FF+0x362>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	a3 30 50 80 00       	mov    %eax,0x805030
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 0f                	je     802e09 <alloc_block_FF+0x37b>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e03:	8b 12                	mov    (%edx),%edx
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	eb 0a                	jmp    802e13 <alloc_block_FF+0x385>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e26:	a1 38 50 80 00       	mov    0x805038,%eax
  802e2b:	48                   	dec    %eax
  802e2c:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802e31:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e34:	e9 0f 01 00 00       	jmp    802f48 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e39:	a1 34 50 80 00       	mov    0x805034,%eax
  802e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e45:	74 07                	je     802e4e <alloc_block_FF+0x3c0>
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	eb 05                	jmp    802e53 <alloc_block_FF+0x3c5>
  802e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e53:	a3 34 50 80 00       	mov    %eax,0x805034
  802e58:	a1 34 50 80 00       	mov    0x805034,%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	0f 85 e9 fc ff ff    	jne    802b4e <alloc_block_FF+0xc0>
  802e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e69:	0f 85 df fc ff ff    	jne    802b4e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	83 c0 08             	add    $0x8,%eax
  802e75:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e78:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e85:	01 d0                	add    %edx,%eax
  802e87:	48                   	dec    %eax
  802e88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e93:	f7 75 d8             	divl   -0x28(%ebp)
  802e96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e99:	29 d0                	sub    %edx,%eax
  802e9b:	c1 e8 0c             	shr    $0xc,%eax
  802e9e:	83 ec 0c             	sub    $0xc,%esp
  802ea1:	50                   	push   %eax
  802ea2:	e8 1c ed ff ff       	call   801bc3 <sbrk>
  802ea7:	83 c4 10             	add    $0x10,%esp
  802eaa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ead:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802eb1:	75 0a                	jne    802ebd <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb8:	e9 8b 00 00 00       	jmp    802f48 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ebd:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ec4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ec7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eca:	01 d0                	add    %edx,%eax
  802ecc:	48                   	dec    %eax
  802ecd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ed0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed8:	f7 75 cc             	divl   -0x34(%ebp)
  802edb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ede:	29 d0                	sub    %edx,%eax
  802ee0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ee3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ee6:	01 d0                	add    %edx,%eax
  802ee8:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802eed:	a1 40 50 80 00       	mov    0x805040,%eax
  802ef2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ef8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802eff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f05:	01 d0                	add    %edx,%eax
  802f07:	48                   	dec    %eax
  802f08:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f13:	f7 75 c4             	divl   -0x3c(%ebp)
  802f16:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f19:	29 d0                	sub    %edx,%eax
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	6a 01                	push   $0x1
  802f20:	50                   	push   %eax
  802f21:	ff 75 d0             	pushl  -0x30(%ebp)
  802f24:	e8 36 fb ff ff       	call   802a5f <set_block_data>
  802f29:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f2c:	83 ec 0c             	sub    $0xc,%esp
  802f2f:	ff 75 d0             	pushl  -0x30(%ebp)
  802f32:	e8 1b 0a 00 00       	call   803952 <free_block>
  802f37:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f3a:	83 ec 0c             	sub    $0xc,%esp
  802f3d:	ff 75 08             	pushl  0x8(%ebp)
  802f40:	e8 49 fb ff ff       	call   802a8e <alloc_block_FF>
  802f45:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f48:	c9                   	leave  
  802f49:	c3                   	ret    

00802f4a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
  802f4d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	83 e0 01             	and    $0x1,%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 03                	je     802f5d <alloc_block_BF+0x13>
  802f5a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f5d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f61:	77 07                	ja     802f6a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f63:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f6a:	a1 24 50 80 00       	mov    0x805024,%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	75 73                	jne    802fe6 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	83 c0 10             	add    $0x10,%eax
  802f79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f7c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f89:	01 d0                	add    %edx,%eax
  802f8b:	48                   	dec    %eax
  802f8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f92:	ba 00 00 00 00       	mov    $0x0,%edx
  802f97:	f7 75 e0             	divl   -0x20(%ebp)
  802f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9d:	29 d0                	sub    %edx,%eax
  802f9f:	c1 e8 0c             	shr    $0xc,%eax
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	50                   	push   %eax
  802fa6:	e8 18 ec ff ff       	call   801bc3 <sbrk>
  802fab:	83 c4 10             	add    $0x10,%esp
  802fae:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fb1:	83 ec 0c             	sub    $0xc,%esp
  802fb4:	6a 00                	push   $0x0
  802fb6:	e8 08 ec ff ff       	call   801bc3 <sbrk>
  802fbb:	83 c4 10             	add    $0x10,%esp
  802fbe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fc4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fc7:	83 ec 08             	sub    $0x8,%esp
  802fca:	50                   	push   %eax
  802fcb:	ff 75 d8             	pushl  -0x28(%ebp)
  802fce:	e8 9f f8 ff ff       	call   802872 <initialize_dynamic_allocator>
  802fd3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fd6:	83 ec 0c             	sub    $0xc,%esp
  802fd9:	68 c3 4d 80 00       	push   $0x804dc3
  802fde:	e8 3e dc ff ff       	call   800c21 <cprintf>
  802fe3:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ff4:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ffb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803002:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	e9 1d 01 00 00       	jmp    80312c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803015:	83 ec 0c             	sub    $0xc,%esp
  803018:	ff 75 a8             	pushl  -0x58(%ebp)
  80301b:	e8 ee f6 ff ff       	call   80270e <get_block_size>
  803020:	83 c4 10             	add    $0x10,%esp
  803023:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	83 c0 08             	add    $0x8,%eax
  80302c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80302f:	0f 87 ef 00 00 00    	ja     803124 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	83 c0 18             	add    $0x18,%eax
  80303b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80303e:	77 1d                	ja     80305d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803046:	0f 86 d8 00 00 00    	jbe    803124 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80304c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80304f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803052:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803055:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803058:	e9 c7 00 00 00       	jmp    803124 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	83 c0 08             	add    $0x8,%eax
  803063:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803066:	0f 85 9d 00 00 00    	jne    803109 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	6a 01                	push   $0x1
  803071:	ff 75 a4             	pushl  -0x5c(%ebp)
  803074:	ff 75 a8             	pushl  -0x58(%ebp)
  803077:	e8 e3 f9 ff ff       	call   802a5f <set_block_data>
  80307c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80307f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803083:	75 17                	jne    80309c <alloc_block_BF+0x152>
  803085:	83 ec 04             	sub    $0x4,%esp
  803088:	68 67 4d 80 00       	push   $0x804d67
  80308d:	68 2c 01 00 00       	push   $0x12c
  803092:	68 85 4d 80 00       	push   $0x804d85
  803097:	e8 0b 11 00 00       	call   8041a7 <_panic>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 10                	je     8030b5 <alloc_block_BF+0x16b>
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ad:	8b 52 04             	mov    0x4(%edx),%edx
  8030b0:	89 50 04             	mov    %edx,0x4(%eax)
  8030b3:	eb 0b                	jmp    8030c0 <alloc_block_BF+0x176>
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 0f                	je     8030d9 <alloc_block_BF+0x18f>
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 40 04             	mov    0x4(%eax),%eax
  8030d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d3:	8b 12                	mov    (%edx),%edx
  8030d5:	89 10                	mov    %edx,(%eax)
  8030d7:	eb 0a                	jmp    8030e3 <alloc_block_BF+0x199>
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fb:	48                   	dec    %eax
  8030fc:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  803101:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803104:	e9 24 04 00 00       	jmp    80352d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80310f:	76 13                	jbe    803124 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803111:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803118:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80311b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80311e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803121:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803124:	a1 34 50 80 00       	mov    0x805034,%eax
  803129:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803130:	74 07                	je     803139 <alloc_block_BF+0x1ef>
  803132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803135:	8b 00                	mov    (%eax),%eax
  803137:	eb 05                	jmp    80313e <alloc_block_BF+0x1f4>
  803139:	b8 00 00 00 00       	mov    $0x0,%eax
  80313e:	a3 34 50 80 00       	mov    %eax,0x805034
  803143:	a1 34 50 80 00       	mov    0x805034,%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	0f 85 bf fe ff ff    	jne    80300f <alloc_block_BF+0xc5>
  803150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803154:	0f 85 b5 fe ff ff    	jne    80300f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80315a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80315e:	0f 84 26 02 00 00    	je     80338a <alloc_block_BF+0x440>
  803164:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803168:	0f 85 1c 02 00 00    	jne    80338a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803171:	2b 45 08             	sub    0x8(%ebp),%eax
  803174:	83 e8 08             	sub    $0x8,%eax
  803177:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8d 50 08             	lea    0x8(%eax),%edx
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	01 d0                	add    %edx,%eax
  803185:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	83 c0 08             	add    $0x8,%eax
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	6a 01                	push   $0x1
  803193:	50                   	push   %eax
  803194:	ff 75 f0             	pushl  -0x10(%ebp)
  803197:	e8 c3 f8 ff ff       	call   802a5f <set_block_data>
  80319c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80319f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a2:	8b 40 04             	mov    0x4(%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	75 68                	jne    803211 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031ad:	75 17                	jne    8031c6 <alloc_block_BF+0x27c>
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	68 a0 4d 80 00       	push   $0x804da0
  8031b7:	68 45 01 00 00       	push   $0x145
  8031bc:	68 85 4d 80 00       	push   $0x804d85
  8031c1:	e8 e1 0f 00 00       	call   8041a7 <_panic>
  8031c6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031cf:	89 10                	mov    %edx,(%eax)
  8031d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 0d                	je     8031e7 <alloc_block_BF+0x29d>
  8031da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 08                	jmp    8031ef <alloc_block_BF+0x2a5>
  8031e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8031ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803201:	a1 38 50 80 00       	mov    0x805038,%eax
  803206:	40                   	inc    %eax
  803207:	a3 38 50 80 00       	mov    %eax,0x805038
  80320c:	e9 dc 00 00 00       	jmp    8032ed <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	75 65                	jne    80327f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80321a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80321e:	75 17                	jne    803237 <alloc_block_BF+0x2ed>
  803220:	83 ec 04             	sub    $0x4,%esp
  803223:	68 d4 4d 80 00       	push   $0x804dd4
  803228:	68 4a 01 00 00       	push   $0x14a
  80322d:	68 85 4d 80 00       	push   $0x804d85
  803232:	e8 70 0f 00 00       	call   8041a7 <_panic>
  803237:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80323d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 0c                	je     803259 <alloc_block_BF+0x30f>
  80324d:	a1 30 50 80 00       	mov    0x805030,%eax
  803252:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803255:	89 10                	mov    %edx,(%eax)
  803257:	eb 08                	jmp    803261 <alloc_block_BF+0x317>
  803259:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80325c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803261:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803264:	a3 30 50 80 00       	mov    %eax,0x805030
  803269:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80326c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803272:	a1 38 50 80 00       	mov    0x805038,%eax
  803277:	40                   	inc    %eax
  803278:	a3 38 50 80 00       	mov    %eax,0x805038
  80327d:	eb 6e                	jmp    8032ed <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80327f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803283:	74 06                	je     80328b <alloc_block_BF+0x341>
  803285:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803289:	75 17                	jne    8032a2 <alloc_block_BF+0x358>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 f8 4d 80 00       	push   $0x804df8
  803293:	68 4f 01 00 00       	push   $0x14f
  803298:	68 85 4d 80 00       	push   $0x804d85
  80329d:	e8 05 0f 00 00       	call   8041a7 <_panic>
  8032a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a5:	8b 10                	mov    (%eax),%edx
  8032a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032aa:	89 10                	mov    %edx,(%eax)
  8032ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	74 0b                	je     8032c0 <alloc_block_BF+0x376>
  8032b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	75 08                	jne    8032e2 <alloc_block_BF+0x398>
  8032da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e7:	40                   	inc    %eax
  8032e8:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f1:	75 17                	jne    80330a <alloc_block_BF+0x3c0>
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 67 4d 80 00       	push   $0x804d67
  8032fb:	68 51 01 00 00       	push   $0x151
  803300:	68 85 4d 80 00       	push   $0x804d85
  803305:	e8 9d 0e 00 00       	call   8041a7 <_panic>
  80330a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 10                	je     803323 <alloc_block_BF+0x3d9>
  803313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331b:	8b 52 04             	mov    0x4(%edx),%edx
  80331e:	89 50 04             	mov    %edx,0x4(%eax)
  803321:	eb 0b                	jmp    80332e <alloc_block_BF+0x3e4>
  803323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803326:	8b 40 04             	mov    0x4(%eax),%eax
  803329:	a3 30 50 80 00       	mov    %eax,0x805030
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0f                	je     803347 <alloc_block_BF+0x3fd>
  803338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333b:	8b 40 04             	mov    0x4(%eax),%eax
  80333e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803341:	8b 12                	mov    (%edx),%edx
  803343:	89 10                	mov    %edx,(%eax)
  803345:	eb 0a                	jmp    803351 <alloc_block_BF+0x407>
  803347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803364:	a1 38 50 80 00       	mov    0x805038,%eax
  803369:	48                   	dec    %eax
  80336a:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	6a 00                	push   $0x0
  803374:	ff 75 d0             	pushl  -0x30(%ebp)
  803377:	ff 75 cc             	pushl  -0x34(%ebp)
  80337a:	e8 e0 f6 ff ff       	call   802a5f <set_block_data>
  80337f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	e9 a3 01 00 00       	jmp    80352d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80338a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80338e:	0f 85 9d 00 00 00    	jne    803431 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	6a 01                	push   $0x1
  803399:	ff 75 ec             	pushl  -0x14(%ebp)
  80339c:	ff 75 f0             	pushl  -0x10(%ebp)
  80339f:	e8 bb f6 ff ff       	call   802a5f <set_block_data>
  8033a4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ab:	75 17                	jne    8033c4 <alloc_block_BF+0x47a>
  8033ad:	83 ec 04             	sub    $0x4,%esp
  8033b0:	68 67 4d 80 00       	push   $0x804d67
  8033b5:	68 58 01 00 00       	push   $0x158
  8033ba:	68 85 4d 80 00       	push   $0x804d85
  8033bf:	e8 e3 0d 00 00       	call   8041a7 <_panic>
  8033c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c7:	8b 00                	mov    (%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 10                	je     8033dd <alloc_block_BF+0x493>
  8033cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d5:	8b 52 04             	mov    0x4(%edx),%edx
  8033d8:	89 50 04             	mov    %edx,0x4(%eax)
  8033db:	eb 0b                	jmp    8033e8 <alloc_block_BF+0x49e>
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	8b 40 04             	mov    0x4(%eax),%eax
  8033e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 0f                	je     803401 <alloc_block_BF+0x4b7>
  8033f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f5:	8b 40 04             	mov    0x4(%eax),%eax
  8033f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033fb:	8b 12                	mov    (%edx),%edx
  8033fd:	89 10                	mov    %edx,(%eax)
  8033ff:	eb 0a                	jmp    80340b <alloc_block_BF+0x4c1>
  803401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80340b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341e:	a1 38 50 80 00       	mov    0x805038,%eax
  803423:	48                   	dec    %eax
  803424:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342c:	e9 fc 00 00 00       	jmp    80352d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	83 c0 08             	add    $0x8,%eax
  803437:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80343a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803441:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803444:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803447:	01 d0                	add    %edx,%eax
  803449:	48                   	dec    %eax
  80344a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80344d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803450:	ba 00 00 00 00       	mov    $0x0,%edx
  803455:	f7 75 c4             	divl   -0x3c(%ebp)
  803458:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80345b:	29 d0                	sub    %edx,%eax
  80345d:	c1 e8 0c             	shr    $0xc,%eax
  803460:	83 ec 0c             	sub    $0xc,%esp
  803463:	50                   	push   %eax
  803464:	e8 5a e7 ff ff       	call   801bc3 <sbrk>
  803469:	83 c4 10             	add    $0x10,%esp
  80346c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80346f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803473:	75 0a                	jne    80347f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803475:	b8 00 00 00 00       	mov    $0x0,%eax
  80347a:	e9 ae 00 00 00       	jmp    80352d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80347f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803486:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803489:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80348c:	01 d0                	add    %edx,%eax
  80348e:	48                   	dec    %eax
  80348f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803492:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803495:	ba 00 00 00 00       	mov    $0x0,%edx
  80349a:	f7 75 b8             	divl   -0x48(%ebp)
  80349d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034a0:	29 d0                	sub    %edx,%eax
  8034a2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034a8:	01 d0                	add    %edx,%eax
  8034aa:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8034af:	a1 40 50 80 00       	mov    0x805040,%eax
  8034b4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8034ba:	83 ec 0c             	sub    $0xc,%esp
  8034bd:	68 2c 4e 80 00       	push   $0x804e2c
  8034c2:	e8 5a d7 ff ff       	call   800c21 <cprintf>
  8034c7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8034ca:	83 ec 08             	sub    $0x8,%esp
  8034cd:	ff 75 bc             	pushl  -0x44(%ebp)
  8034d0:	68 31 4e 80 00       	push   $0x804e31
  8034d5:	e8 47 d7 ff ff       	call   800c21 <cprintf>
  8034da:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034dd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034e4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034ea:	01 d0                	add    %edx,%eax
  8034ec:	48                   	dec    %eax
  8034ed:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034f0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f8:	f7 75 b0             	divl   -0x50(%ebp)
  8034fb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034fe:	29 d0                	sub    %edx,%eax
  803500:	83 ec 04             	sub    $0x4,%esp
  803503:	6a 01                	push   $0x1
  803505:	50                   	push   %eax
  803506:	ff 75 bc             	pushl  -0x44(%ebp)
  803509:	e8 51 f5 ff ff       	call   802a5f <set_block_data>
  80350e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803511:	83 ec 0c             	sub    $0xc,%esp
  803514:	ff 75 bc             	pushl  -0x44(%ebp)
  803517:	e8 36 04 00 00       	call   803952 <free_block>
  80351c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80351f:	83 ec 0c             	sub    $0xc,%esp
  803522:	ff 75 08             	pushl  0x8(%ebp)
  803525:	e8 20 fa ff ff       	call   802f4a <alloc_block_BF>
  80352a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80352d:	c9                   	leave  
  80352e:	c3                   	ret    

0080352f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80352f:	55                   	push   %ebp
  803530:	89 e5                	mov    %esp,%ebp
  803532:	53                   	push   %ebx
  803533:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80353d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803544:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803548:	74 1e                	je     803568 <merging+0x39>
  80354a:	ff 75 08             	pushl  0x8(%ebp)
  80354d:	e8 bc f1 ff ff       	call   80270e <get_block_size>
  803552:	83 c4 04             	add    $0x4,%esp
  803555:	89 c2                	mov    %eax,%edx
  803557:	8b 45 08             	mov    0x8(%ebp),%eax
  80355a:	01 d0                	add    %edx,%eax
  80355c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80355f:	75 07                	jne    803568 <merging+0x39>
		prev_is_free = 1;
  803561:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803568:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80356c:	74 1e                	je     80358c <merging+0x5d>
  80356e:	ff 75 10             	pushl  0x10(%ebp)
  803571:	e8 98 f1 ff ff       	call   80270e <get_block_size>
  803576:	83 c4 04             	add    $0x4,%esp
  803579:	89 c2                	mov    %eax,%edx
  80357b:	8b 45 10             	mov    0x10(%ebp),%eax
  80357e:	01 d0                	add    %edx,%eax
  803580:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803583:	75 07                	jne    80358c <merging+0x5d>
		next_is_free = 1;
  803585:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80358c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803590:	0f 84 cc 00 00 00    	je     803662 <merging+0x133>
  803596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80359a:	0f 84 c2 00 00 00    	je     803662 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8035a0:	ff 75 08             	pushl  0x8(%ebp)
  8035a3:	e8 66 f1 ff ff       	call   80270e <get_block_size>
  8035a8:	83 c4 04             	add    $0x4,%esp
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	ff 75 10             	pushl  0x10(%ebp)
  8035b0:	e8 59 f1 ff ff       	call   80270e <get_block_size>
  8035b5:	83 c4 04             	add    $0x4,%esp
  8035b8:	01 c3                	add    %eax,%ebx
  8035ba:	ff 75 0c             	pushl  0xc(%ebp)
  8035bd:	e8 4c f1 ff ff       	call   80270e <get_block_size>
  8035c2:	83 c4 04             	add    $0x4,%esp
  8035c5:	01 d8                	add    %ebx,%eax
  8035c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035ca:	6a 00                	push   $0x0
  8035cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8035cf:	ff 75 08             	pushl  0x8(%ebp)
  8035d2:	e8 88 f4 ff ff       	call   802a5f <set_block_data>
  8035d7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035de:	75 17                	jne    8035f7 <merging+0xc8>
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	68 67 4d 80 00       	push   $0x804d67
  8035e8:	68 7d 01 00 00       	push   $0x17d
  8035ed:	68 85 4d 80 00       	push   $0x804d85
  8035f2:	e8 b0 0b 00 00       	call   8041a7 <_panic>
  8035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	74 10                	je     803610 <merging+0xe1>
  803600:	8b 45 0c             	mov    0xc(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	8b 55 0c             	mov    0xc(%ebp),%edx
  803608:	8b 52 04             	mov    0x4(%edx),%edx
  80360b:	89 50 04             	mov    %edx,0x4(%eax)
  80360e:	eb 0b                	jmp    80361b <merging+0xec>
  803610:	8b 45 0c             	mov    0xc(%ebp),%eax
  803613:	8b 40 04             	mov    0x4(%eax),%eax
  803616:	a3 30 50 80 00       	mov    %eax,0x805030
  80361b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0f                	je     803634 <merging+0x105>
  803625:	8b 45 0c             	mov    0xc(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80362e:	8b 12                	mov    (%edx),%edx
  803630:	89 10                	mov    %edx,(%eax)
  803632:	eb 0a                	jmp    80363e <merging+0x10f>
  803634:	8b 45 0c             	mov    0xc(%ebp),%eax
  803637:	8b 00                	mov    (%eax),%eax
  803639:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80363e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803651:	a1 38 50 80 00       	mov    0x805038,%eax
  803656:	48                   	dec    %eax
  803657:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80365c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80365d:	e9 ea 02 00 00       	jmp    80394c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803666:	74 3b                	je     8036a3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803668:	83 ec 0c             	sub    $0xc,%esp
  80366b:	ff 75 08             	pushl  0x8(%ebp)
  80366e:	e8 9b f0 ff ff       	call   80270e <get_block_size>
  803673:	83 c4 10             	add    $0x10,%esp
  803676:	89 c3                	mov    %eax,%ebx
  803678:	83 ec 0c             	sub    $0xc,%esp
  80367b:	ff 75 10             	pushl  0x10(%ebp)
  80367e:	e8 8b f0 ff ff       	call   80270e <get_block_size>
  803683:	83 c4 10             	add    $0x10,%esp
  803686:	01 d8                	add    %ebx,%eax
  803688:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80368b:	83 ec 04             	sub    $0x4,%esp
  80368e:	6a 00                	push   $0x0
  803690:	ff 75 e8             	pushl  -0x18(%ebp)
  803693:	ff 75 08             	pushl  0x8(%ebp)
  803696:	e8 c4 f3 ff ff       	call   802a5f <set_block_data>
  80369b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80369e:	e9 a9 02 00 00       	jmp    80394c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8036a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036a7:	0f 84 2d 01 00 00    	je     8037da <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8036ad:	83 ec 0c             	sub    $0xc,%esp
  8036b0:	ff 75 10             	pushl  0x10(%ebp)
  8036b3:	e8 56 f0 ff ff       	call   80270e <get_block_size>
  8036b8:	83 c4 10             	add    $0x10,%esp
  8036bb:	89 c3                	mov    %eax,%ebx
  8036bd:	83 ec 0c             	sub    $0xc,%esp
  8036c0:	ff 75 0c             	pushl  0xc(%ebp)
  8036c3:	e8 46 f0 ff ff       	call   80270e <get_block_size>
  8036c8:	83 c4 10             	add    $0x10,%esp
  8036cb:	01 d8                	add    %ebx,%eax
  8036cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	6a 00                	push   $0x0
  8036d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036d8:	ff 75 10             	pushl  0x10(%ebp)
  8036db:	e8 7f f3 ff ff       	call   802a5f <set_block_data>
  8036e0:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8036e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8036e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036ed:	74 06                	je     8036f5 <merging+0x1c6>
  8036ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036f3:	75 17                	jne    80370c <merging+0x1dd>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 40 4e 80 00       	push   $0x804e40
  8036fd:	68 8d 01 00 00       	push   $0x18d
  803702:	68 85 4d 80 00       	push   $0x804d85
  803707:	e8 9b 0a 00 00       	call   8041a7 <_panic>
  80370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370f:	8b 50 04             	mov    0x4(%eax),%edx
  803712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803715:	89 50 04             	mov    %edx,0x4(%eax)
  803718:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80371b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	8b 45 0c             	mov    0xc(%ebp),%eax
  803723:	8b 40 04             	mov    0x4(%eax),%eax
  803726:	85 c0                	test   %eax,%eax
  803728:	74 0d                	je     803737 <merging+0x208>
  80372a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372d:	8b 40 04             	mov    0x4(%eax),%eax
  803730:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803733:	89 10                	mov    %edx,(%eax)
  803735:	eb 08                	jmp    80373f <merging+0x210>
  803737:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80373a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80373f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803742:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	a1 38 50 80 00       	mov    0x805038,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803757:	75 17                	jne    803770 <merging+0x241>
  803759:	83 ec 04             	sub    $0x4,%esp
  80375c:	68 67 4d 80 00       	push   $0x804d67
  803761:	68 8e 01 00 00       	push   $0x18e
  803766:	68 85 4d 80 00       	push   $0x804d85
  80376b:	e8 37 0a 00 00       	call   8041a7 <_panic>
  803770:	8b 45 0c             	mov    0xc(%ebp),%eax
  803773:	8b 00                	mov    (%eax),%eax
  803775:	85 c0                	test   %eax,%eax
  803777:	74 10                	je     803789 <merging+0x25a>
  803779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803781:	8b 52 04             	mov    0x4(%edx),%edx
  803784:	89 50 04             	mov    %edx,0x4(%eax)
  803787:	eb 0b                	jmp    803794 <merging+0x265>
  803789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378c:	8b 40 04             	mov    0x4(%eax),%eax
  80378f:	a3 30 50 80 00       	mov    %eax,0x805030
  803794:	8b 45 0c             	mov    0xc(%ebp),%eax
  803797:	8b 40 04             	mov    0x4(%eax),%eax
  80379a:	85 c0                	test   %eax,%eax
  80379c:	74 0f                	je     8037ad <merging+0x27e>
  80379e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a1:	8b 40 04             	mov    0x4(%eax),%eax
  8037a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037a7:	8b 12                	mov    (%edx),%edx
  8037a9:	89 10                	mov    %edx,(%eax)
  8037ab:	eb 0a                	jmp    8037b7 <merging+0x288>
  8037ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b0:	8b 00                	mov    (%eax),%eax
  8037b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8037cf:	48                   	dec    %eax
  8037d0:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037d5:	e9 72 01 00 00       	jmp    80394c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037da:	8b 45 10             	mov    0x10(%ebp),%eax
  8037dd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8037e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e4:	74 79                	je     80385f <merging+0x330>
  8037e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037ea:	74 73                	je     80385f <merging+0x330>
  8037ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f0:	74 06                	je     8037f8 <merging+0x2c9>
  8037f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037f6:	75 17                	jne    80380f <merging+0x2e0>
  8037f8:	83 ec 04             	sub    $0x4,%esp
  8037fb:	68 f8 4d 80 00       	push   $0x804df8
  803800:	68 94 01 00 00       	push   $0x194
  803805:	68 85 4d 80 00       	push   $0x804d85
  80380a:	e8 98 09 00 00       	call   8041a7 <_panic>
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 10                	mov    (%eax),%edx
  803814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803817:	89 10                	mov    %edx,(%eax)
  803819:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	74 0b                	je     80382d <merging+0x2fe>
  803822:	8b 45 08             	mov    0x8(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80382a:	89 50 04             	mov    %edx,0x4(%eax)
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803833:	89 10                	mov    %edx,(%eax)
  803835:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803838:	8b 55 08             	mov    0x8(%ebp),%edx
  80383b:	89 50 04             	mov    %edx,0x4(%eax)
  80383e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803841:	8b 00                	mov    (%eax),%eax
  803843:	85 c0                	test   %eax,%eax
  803845:	75 08                	jne    80384f <merging+0x320>
  803847:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80384a:	a3 30 50 80 00       	mov    %eax,0x805030
  80384f:	a1 38 50 80 00       	mov    0x805038,%eax
  803854:	40                   	inc    %eax
  803855:	a3 38 50 80 00       	mov    %eax,0x805038
  80385a:	e9 ce 00 00 00       	jmp    80392d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80385f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803863:	74 65                	je     8038ca <merging+0x39b>
  803865:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803869:	75 17                	jne    803882 <merging+0x353>
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	68 d4 4d 80 00       	push   $0x804dd4
  803873:	68 95 01 00 00       	push   $0x195
  803878:	68 85 4d 80 00       	push   $0x804d85
  80387d:	e8 25 09 00 00       	call   8041a7 <_panic>
  803882:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803888:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80388b:	89 50 04             	mov    %edx,0x4(%eax)
  80388e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803891:	8b 40 04             	mov    0x4(%eax),%eax
  803894:	85 c0                	test   %eax,%eax
  803896:	74 0c                	je     8038a4 <merging+0x375>
  803898:	a1 30 50 80 00       	mov    0x805030,%eax
  80389d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038a0:	89 10                	mov    %edx,(%eax)
  8038a2:	eb 08                	jmp    8038ac <merging+0x37d>
  8038a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038af:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8038c2:	40                   	inc    %eax
  8038c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8038c8:	eb 63                	jmp    80392d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038ce:	75 17                	jne    8038e7 <merging+0x3b8>
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 a0 4d 80 00       	push   $0x804da0
  8038d8:	68 98 01 00 00       	push   $0x198
  8038dd:	68 85 4d 80 00       	push   $0x804d85
  8038e2:	e8 c0 08 00 00       	call   8041a7 <_panic>
  8038e7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8038ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f0:	89 10                	mov    %edx,(%eax)
  8038f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	74 0d                	je     803908 <merging+0x3d9>
  8038fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
  803906:	eb 08                	jmp    803910 <merging+0x3e1>
  803908:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390b:	a3 30 50 80 00       	mov    %eax,0x805030
  803910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803913:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803918:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803922:	a1 38 50 80 00       	mov    0x805038,%eax
  803927:	40                   	inc    %eax
  803928:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80392d:	83 ec 0c             	sub    $0xc,%esp
  803930:	ff 75 10             	pushl  0x10(%ebp)
  803933:	e8 d6 ed ff ff       	call   80270e <get_block_size>
  803938:	83 c4 10             	add    $0x10,%esp
  80393b:	83 ec 04             	sub    $0x4,%esp
  80393e:	6a 00                	push   $0x0
  803940:	50                   	push   %eax
  803941:	ff 75 10             	pushl  0x10(%ebp)
  803944:	e8 16 f1 ff ff       	call   802a5f <set_block_data>
  803949:	83 c4 10             	add    $0x10,%esp
	}
}
  80394c:	90                   	nop
  80394d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803950:	c9                   	leave  
  803951:	c3                   	ret    

00803952 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803958:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80395d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803960:	a1 30 50 80 00       	mov    0x805030,%eax
  803965:	3b 45 08             	cmp    0x8(%ebp),%eax
  803968:	73 1b                	jae    803985 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80396a:	a1 30 50 80 00       	mov    0x805030,%eax
  80396f:	83 ec 04             	sub    $0x4,%esp
  803972:	ff 75 08             	pushl  0x8(%ebp)
  803975:	6a 00                	push   $0x0
  803977:	50                   	push   %eax
  803978:	e8 b2 fb ff ff       	call   80352f <merging>
  80397d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803980:	e9 8b 00 00 00       	jmp    803a10 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803985:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80398a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80398d:	76 18                	jbe    8039a7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80398f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	ff 75 08             	pushl  0x8(%ebp)
  80399a:	50                   	push   %eax
  80399b:	6a 00                	push   $0x0
  80399d:	e8 8d fb ff ff       	call   80352f <merging>
  8039a2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039a5:	eb 69                	jmp    803a10 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039af:	eb 39                	jmp    8039ea <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039b7:	73 29                	jae    8039e2 <free_block+0x90>
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039c1:	76 1f                	jbe    8039e2 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039cb:	83 ec 04             	sub    $0x4,%esp
  8039ce:	ff 75 08             	pushl  0x8(%ebp)
  8039d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8039d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8039d7:	e8 53 fb ff ff       	call   80352f <merging>
  8039dc:	83 c4 10             	add    $0x10,%esp
			break;
  8039df:	90                   	nop
		}
	}
}
  8039e0:	eb 2e                	jmp    803a10 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039e2:	a1 34 50 80 00       	mov    0x805034,%eax
  8039e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ee:	74 07                	je     8039f7 <free_block+0xa5>
  8039f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f3:	8b 00                	mov    (%eax),%eax
  8039f5:	eb 05                	jmp    8039fc <free_block+0xaa>
  8039f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fc:	a3 34 50 80 00       	mov    %eax,0x805034
  803a01:	a1 34 50 80 00       	mov    0x805034,%eax
  803a06:	85 c0                	test   %eax,%eax
  803a08:	75 a7                	jne    8039b1 <free_block+0x5f>
  803a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a0e:	75 a1                	jne    8039b1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a10:	90                   	nop
  803a11:	c9                   	leave  
  803a12:	c3                   	ret    

00803a13 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a13:	55                   	push   %ebp
  803a14:	89 e5                	mov    %esp,%ebp
  803a16:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a19:	ff 75 08             	pushl  0x8(%ebp)
  803a1c:	e8 ed ec ff ff       	call   80270e <get_block_size>
  803a21:	83 c4 04             	add    $0x4,%esp
  803a24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a2e:	eb 17                	jmp    803a47 <copy_data+0x34>
  803a30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a36:	01 c2                	add    %eax,%edx
  803a38:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3e:	01 c8                	add    %ecx,%eax
  803a40:	8a 00                	mov    (%eax),%al
  803a42:	88 02                	mov    %al,(%edx)
  803a44:	ff 45 fc             	incl   -0x4(%ebp)
  803a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a4d:	72 e1                	jb     803a30 <copy_data+0x1d>
}
  803a4f:	90                   	nop
  803a50:	c9                   	leave  
  803a51:	c3                   	ret    

00803a52 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a52:	55                   	push   %ebp
  803a53:	89 e5                	mov    %esp,%ebp
  803a55:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a5c:	75 23                	jne    803a81 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a62:	74 13                	je     803a77 <realloc_block_FF+0x25>
  803a64:	83 ec 0c             	sub    $0xc,%esp
  803a67:	ff 75 0c             	pushl  0xc(%ebp)
  803a6a:	e8 1f f0 ff ff       	call   802a8e <alloc_block_FF>
  803a6f:	83 c4 10             	add    $0x10,%esp
  803a72:	e9 f4 06 00 00       	jmp    80416b <realloc_block_FF+0x719>
		return NULL;
  803a77:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7c:	e9 ea 06 00 00       	jmp    80416b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a85:	75 18                	jne    803a9f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a87:	83 ec 0c             	sub    $0xc,%esp
  803a8a:	ff 75 08             	pushl  0x8(%ebp)
  803a8d:	e8 c0 fe ff ff       	call   803952 <free_block>
  803a92:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a95:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9a:	e9 cc 06 00 00       	jmp    80416b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803a9f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803aa3:	77 07                	ja     803aac <realloc_block_FF+0x5a>
  803aa5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aaf:	83 e0 01             	and    $0x1,%eax
  803ab2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab8:	83 c0 08             	add    $0x8,%eax
  803abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803abe:	83 ec 0c             	sub    $0xc,%esp
  803ac1:	ff 75 08             	pushl  0x8(%ebp)
  803ac4:	e8 45 ec ff ff       	call   80270e <get_block_size>
  803ac9:	83 c4 10             	add    $0x10,%esp
  803acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad2:	83 e8 08             	sub    $0x8,%eax
  803ad5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	83 e8 04             	sub    $0x4,%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	83 e0 fe             	and    $0xfffffffe,%eax
  803ae3:	89 c2                	mov    %eax,%edx
  803ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae8:	01 d0                	add    %edx,%eax
  803aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803aed:	83 ec 0c             	sub    $0xc,%esp
  803af0:	ff 75 e4             	pushl  -0x1c(%ebp)
  803af3:	e8 16 ec ff ff       	call   80270e <get_block_size>
  803af8:	83 c4 10             	add    $0x10,%esp
  803afb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803afe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b01:	83 e8 08             	sub    $0x8,%eax
  803b04:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b0d:	75 08                	jne    803b17 <realloc_block_FF+0xc5>
	{
		 return va;
  803b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b12:	e9 54 06 00 00       	jmp    80416b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b1d:	0f 83 e5 03 00 00    	jae    803f08 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b26:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b2c:	83 ec 0c             	sub    $0xc,%esp
  803b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b32:	e8 f0 eb ff ff       	call   802727 <is_free_block>
  803b37:	83 c4 10             	add    $0x10,%esp
  803b3a:	84 c0                	test   %al,%al
  803b3c:	0f 84 3b 01 00 00    	je     803c7d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b48:	01 d0                	add    %edx,%eax
  803b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b4d:	83 ec 04             	sub    $0x4,%esp
  803b50:	6a 01                	push   $0x1
  803b52:	ff 75 f0             	pushl  -0x10(%ebp)
  803b55:	ff 75 08             	pushl  0x8(%ebp)
  803b58:	e8 02 ef ff ff       	call   802a5f <set_block_data>
  803b5d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b60:	8b 45 08             	mov    0x8(%ebp),%eax
  803b63:	83 e8 04             	sub    $0x4,%eax
  803b66:	8b 00                	mov    (%eax),%eax
  803b68:	83 e0 fe             	and    $0xfffffffe,%eax
  803b6b:	89 c2                	mov    %eax,%edx
  803b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b70:	01 d0                	add    %edx,%eax
  803b72:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b75:	83 ec 04             	sub    $0x4,%esp
  803b78:	6a 00                	push   $0x0
  803b7a:	ff 75 cc             	pushl  -0x34(%ebp)
  803b7d:	ff 75 c8             	pushl  -0x38(%ebp)
  803b80:	e8 da ee ff ff       	call   802a5f <set_block_data>
  803b85:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b8c:	74 06                	je     803b94 <realloc_block_FF+0x142>
  803b8e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b92:	75 17                	jne    803bab <realloc_block_FF+0x159>
  803b94:	83 ec 04             	sub    $0x4,%esp
  803b97:	68 f8 4d 80 00       	push   $0x804df8
  803b9c:	68 f6 01 00 00       	push   $0x1f6
  803ba1:	68 85 4d 80 00       	push   $0x804d85
  803ba6:	e8 fc 05 00 00       	call   8041a7 <_panic>
  803bab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bae:	8b 10                	mov    (%eax),%edx
  803bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb3:	89 10                	mov    %edx,(%eax)
  803bb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb8:	8b 00                	mov    (%eax),%eax
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	74 0b                	je     803bc9 <realloc_block_FF+0x177>
  803bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc1:	8b 00                	mov    (%eax),%eax
  803bc3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bc6:	89 50 04             	mov    %edx,0x4(%eax)
  803bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bcf:	89 10                	mov    %edx,(%eax)
  803bd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bd7:	89 50 04             	mov    %edx,0x4(%eax)
  803bda:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bdd:	8b 00                	mov    (%eax),%eax
  803bdf:	85 c0                	test   %eax,%eax
  803be1:	75 08                	jne    803beb <realloc_block_FF+0x199>
  803be3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803be6:	a3 30 50 80 00       	mov    %eax,0x805030
  803beb:	a1 38 50 80 00       	mov    0x805038,%eax
  803bf0:	40                   	inc    %eax
  803bf1:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bfa:	75 17                	jne    803c13 <realloc_block_FF+0x1c1>
  803bfc:	83 ec 04             	sub    $0x4,%esp
  803bff:	68 67 4d 80 00       	push   $0x804d67
  803c04:	68 f7 01 00 00       	push   $0x1f7
  803c09:	68 85 4d 80 00       	push   $0x804d85
  803c0e:	e8 94 05 00 00       	call   8041a7 <_panic>
  803c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c16:	8b 00                	mov    (%eax),%eax
  803c18:	85 c0                	test   %eax,%eax
  803c1a:	74 10                	je     803c2c <realloc_block_FF+0x1da>
  803c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1f:	8b 00                	mov    (%eax),%eax
  803c21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c24:	8b 52 04             	mov    0x4(%edx),%edx
  803c27:	89 50 04             	mov    %edx,0x4(%eax)
  803c2a:	eb 0b                	jmp    803c37 <realloc_block_FF+0x1e5>
  803c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2f:	8b 40 04             	mov    0x4(%eax),%eax
  803c32:	a3 30 50 80 00       	mov    %eax,0x805030
  803c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3a:	8b 40 04             	mov    0x4(%eax),%eax
  803c3d:	85 c0                	test   %eax,%eax
  803c3f:	74 0f                	je     803c50 <realloc_block_FF+0x1fe>
  803c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c44:	8b 40 04             	mov    0x4(%eax),%eax
  803c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c4a:	8b 12                	mov    (%edx),%edx
  803c4c:	89 10                	mov    %edx,(%eax)
  803c4e:	eb 0a                	jmp    803c5a <realloc_block_FF+0x208>
  803c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c53:	8b 00                	mov    (%eax),%eax
  803c55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6d:	a1 38 50 80 00       	mov    0x805038,%eax
  803c72:	48                   	dec    %eax
  803c73:	a3 38 50 80 00       	mov    %eax,0x805038
  803c78:	e9 83 02 00 00       	jmp    803f00 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803c7d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c81:	0f 86 69 02 00 00    	jbe    803ef0 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c87:	83 ec 04             	sub    $0x4,%esp
  803c8a:	6a 01                	push   $0x1
  803c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  803c8f:	ff 75 08             	pushl  0x8(%ebp)
  803c92:	e8 c8 ed ff ff       	call   802a5f <set_block_data>
  803c97:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9d:	83 e8 04             	sub    $0x4,%eax
  803ca0:	8b 00                	mov    (%eax),%eax
  803ca2:	83 e0 fe             	and    $0xfffffffe,%eax
  803ca5:	89 c2                	mov    %eax,%edx
  803ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  803caa:	01 d0                	add    %edx,%eax
  803cac:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803caf:	a1 38 50 80 00       	mov    0x805038,%eax
  803cb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803cb7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803cbb:	75 68                	jne    803d25 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cbd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cc1:	75 17                	jne    803cda <realloc_block_FF+0x288>
  803cc3:	83 ec 04             	sub    $0x4,%esp
  803cc6:	68 a0 4d 80 00       	push   $0x804da0
  803ccb:	68 06 02 00 00       	push   $0x206
  803cd0:	68 85 4d 80 00       	push   $0x804d85
  803cd5:	e8 cd 04 00 00       	call   8041a7 <_panic>
  803cda:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803ce0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce3:	89 10                	mov    %edx,(%eax)
  803ce5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce8:	8b 00                	mov    (%eax),%eax
  803cea:	85 c0                	test   %eax,%eax
  803cec:	74 0d                	je     803cfb <realloc_block_FF+0x2a9>
  803cee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803cf3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cf6:	89 50 04             	mov    %edx,0x4(%eax)
  803cf9:	eb 08                	jmp    803d03 <realloc_block_FF+0x2b1>
  803cfb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfe:	a3 30 50 80 00       	mov    %eax,0x805030
  803d03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d15:	a1 38 50 80 00       	mov    0x805038,%eax
  803d1a:	40                   	inc    %eax
  803d1b:	a3 38 50 80 00       	mov    %eax,0x805038
  803d20:	e9 b0 01 00 00       	jmp    803ed5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d25:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d2d:	76 68                	jbe    803d97 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d33:	75 17                	jne    803d4c <realloc_block_FF+0x2fa>
  803d35:	83 ec 04             	sub    $0x4,%esp
  803d38:	68 a0 4d 80 00       	push   $0x804da0
  803d3d:	68 0b 02 00 00       	push   $0x20b
  803d42:	68 85 4d 80 00       	push   $0x804d85
  803d47:	e8 5b 04 00 00       	call   8041a7 <_panic>
  803d4c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d55:	89 10                	mov    %edx,(%eax)
  803d57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5a:	8b 00                	mov    (%eax),%eax
  803d5c:	85 c0                	test   %eax,%eax
  803d5e:	74 0d                	je     803d6d <realloc_block_FF+0x31b>
  803d60:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d68:	89 50 04             	mov    %edx,0x4(%eax)
  803d6b:	eb 08                	jmp    803d75 <realloc_block_FF+0x323>
  803d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d70:	a3 30 50 80 00       	mov    %eax,0x805030
  803d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d78:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d87:	a1 38 50 80 00       	mov    0x805038,%eax
  803d8c:	40                   	inc    %eax
  803d8d:	a3 38 50 80 00       	mov    %eax,0x805038
  803d92:	e9 3e 01 00 00       	jmp    803ed5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d97:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d9c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d9f:	73 68                	jae    803e09 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803da1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803da5:	75 17                	jne    803dbe <realloc_block_FF+0x36c>
  803da7:	83 ec 04             	sub    $0x4,%esp
  803daa:	68 d4 4d 80 00       	push   $0x804dd4
  803daf:	68 10 02 00 00       	push   $0x210
  803db4:	68 85 4d 80 00       	push   $0x804d85
  803db9:	e8 e9 03 00 00       	call   8041a7 <_panic>
  803dbe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803dc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc7:	89 50 04             	mov    %edx,0x4(%eax)
  803dca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dcd:	8b 40 04             	mov    0x4(%eax),%eax
  803dd0:	85 c0                	test   %eax,%eax
  803dd2:	74 0c                	je     803de0 <realloc_block_FF+0x38e>
  803dd4:	a1 30 50 80 00       	mov    0x805030,%eax
  803dd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ddc:	89 10                	mov    %edx,(%eax)
  803dde:	eb 08                	jmp    803de8 <realloc_block_FF+0x396>
  803de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803de8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803deb:	a3 30 50 80 00       	mov    %eax,0x805030
  803df0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803df3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df9:	a1 38 50 80 00       	mov    0x805038,%eax
  803dfe:	40                   	inc    %eax
  803dff:	a3 38 50 80 00       	mov    %eax,0x805038
  803e04:	e9 cc 00 00 00       	jmp    803ed5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e10:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e18:	e9 8a 00 00 00       	jmp    803ea7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e20:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e23:	73 7a                	jae    803e9f <realloc_block_FF+0x44d>
  803e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e28:	8b 00                	mov    (%eax),%eax
  803e2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e2d:	73 70                	jae    803e9f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e33:	74 06                	je     803e3b <realloc_block_FF+0x3e9>
  803e35:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e39:	75 17                	jne    803e52 <realloc_block_FF+0x400>
  803e3b:	83 ec 04             	sub    $0x4,%esp
  803e3e:	68 f8 4d 80 00       	push   $0x804df8
  803e43:	68 1a 02 00 00       	push   $0x21a
  803e48:	68 85 4d 80 00       	push   $0x804d85
  803e4d:	e8 55 03 00 00       	call   8041a7 <_panic>
  803e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e55:	8b 10                	mov    (%eax),%edx
  803e57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5a:	89 10                	mov    %edx,(%eax)
  803e5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5f:	8b 00                	mov    (%eax),%eax
  803e61:	85 c0                	test   %eax,%eax
  803e63:	74 0b                	je     803e70 <realloc_block_FF+0x41e>
  803e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e68:	8b 00                	mov    (%eax),%eax
  803e6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e6d:	89 50 04             	mov    %edx,0x4(%eax)
  803e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e73:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e76:	89 10                	mov    %edx,(%eax)
  803e78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e7e:	89 50 04             	mov    %edx,0x4(%eax)
  803e81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	75 08                	jne    803e92 <realloc_block_FF+0x440>
  803e8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8d:	a3 30 50 80 00       	mov    %eax,0x805030
  803e92:	a1 38 50 80 00       	mov    0x805038,%eax
  803e97:	40                   	inc    %eax
  803e98:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803e9d:	eb 36                	jmp    803ed5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e9f:	a1 34 50 80 00       	mov    0x805034,%eax
  803ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ea7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eab:	74 07                	je     803eb4 <realloc_block_FF+0x462>
  803ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb0:	8b 00                	mov    (%eax),%eax
  803eb2:	eb 05                	jmp    803eb9 <realloc_block_FF+0x467>
  803eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb9:	a3 34 50 80 00       	mov    %eax,0x805034
  803ebe:	a1 34 50 80 00       	mov    0x805034,%eax
  803ec3:	85 c0                	test   %eax,%eax
  803ec5:	0f 85 52 ff ff ff    	jne    803e1d <realloc_block_FF+0x3cb>
  803ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ecf:	0f 85 48 ff ff ff    	jne    803e1d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ed5:	83 ec 04             	sub    $0x4,%esp
  803ed8:	6a 00                	push   $0x0
  803eda:	ff 75 d8             	pushl  -0x28(%ebp)
  803edd:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ee0:	e8 7a eb ff ff       	call   802a5f <set_block_data>
  803ee5:	83 c4 10             	add    $0x10,%esp
				return va;
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	e9 7b 02 00 00       	jmp    80416b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803ef0:	83 ec 0c             	sub    $0xc,%esp
  803ef3:	68 75 4e 80 00       	push   $0x804e75
  803ef8:	e8 24 cd ff ff       	call   800c21 <cprintf>
  803efd:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803f00:	8b 45 08             	mov    0x8(%ebp),%eax
  803f03:	e9 63 02 00 00       	jmp    80416b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f0b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f0e:	0f 86 4d 02 00 00    	jbe    804161 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f14:	83 ec 0c             	sub    $0xc,%esp
  803f17:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f1a:	e8 08 e8 ff ff       	call   802727 <is_free_block>
  803f1f:	83 c4 10             	add    $0x10,%esp
  803f22:	84 c0                	test   %al,%al
  803f24:	0f 84 37 02 00 00    	je     804161 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f2d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f30:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f33:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f36:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f39:	76 38                	jbe    803f73 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f3b:	83 ec 0c             	sub    $0xc,%esp
  803f3e:	ff 75 08             	pushl  0x8(%ebp)
  803f41:	e8 0c fa ff ff       	call   803952 <free_block>
  803f46:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f49:	83 ec 0c             	sub    $0xc,%esp
  803f4c:	ff 75 0c             	pushl  0xc(%ebp)
  803f4f:	e8 3a eb ff ff       	call   802a8e <alloc_block_FF>
  803f54:	83 c4 10             	add    $0x10,%esp
  803f57:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f5a:	83 ec 08             	sub    $0x8,%esp
  803f5d:	ff 75 c0             	pushl  -0x40(%ebp)
  803f60:	ff 75 08             	pushl  0x8(%ebp)
  803f63:	e8 ab fa ff ff       	call   803a13 <copy_data>
  803f68:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f6e:	e9 f8 01 00 00       	jmp    80416b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f76:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f79:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f7c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f80:	0f 87 a0 00 00 00    	ja     804026 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f8a:	75 17                	jne    803fa3 <realloc_block_FF+0x551>
  803f8c:	83 ec 04             	sub    $0x4,%esp
  803f8f:	68 67 4d 80 00       	push   $0x804d67
  803f94:	68 38 02 00 00       	push   $0x238
  803f99:	68 85 4d 80 00       	push   $0x804d85
  803f9e:	e8 04 02 00 00       	call   8041a7 <_panic>
  803fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa6:	8b 00                	mov    (%eax),%eax
  803fa8:	85 c0                	test   %eax,%eax
  803faa:	74 10                	je     803fbc <realloc_block_FF+0x56a>
  803fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803faf:	8b 00                	mov    (%eax),%eax
  803fb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fb4:	8b 52 04             	mov    0x4(%edx),%edx
  803fb7:	89 50 04             	mov    %edx,0x4(%eax)
  803fba:	eb 0b                	jmp    803fc7 <realloc_block_FF+0x575>
  803fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbf:	8b 40 04             	mov    0x4(%eax),%eax
  803fc2:	a3 30 50 80 00       	mov    %eax,0x805030
  803fc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fca:	8b 40 04             	mov    0x4(%eax),%eax
  803fcd:	85 c0                	test   %eax,%eax
  803fcf:	74 0f                	je     803fe0 <realloc_block_FF+0x58e>
  803fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd4:	8b 40 04             	mov    0x4(%eax),%eax
  803fd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fda:	8b 12                	mov    (%edx),%edx
  803fdc:	89 10                	mov    %edx,(%eax)
  803fde:	eb 0a                	jmp    803fea <realloc_block_FF+0x598>
  803fe0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe3:	8b 00                	mov    (%eax),%eax
  803fe5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ffd:	a1 38 50 80 00       	mov    0x805038,%eax
  804002:	48                   	dec    %eax
  804003:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804008:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80400b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80400e:	01 d0                	add    %edx,%eax
  804010:	83 ec 04             	sub    $0x4,%esp
  804013:	6a 01                	push   $0x1
  804015:	50                   	push   %eax
  804016:	ff 75 08             	pushl  0x8(%ebp)
  804019:	e8 41 ea ff ff       	call   802a5f <set_block_data>
  80401e:	83 c4 10             	add    $0x10,%esp
  804021:	e9 36 01 00 00       	jmp    80415c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804026:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804029:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80402c:	01 d0                	add    %edx,%eax
  80402e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804031:	83 ec 04             	sub    $0x4,%esp
  804034:	6a 01                	push   $0x1
  804036:	ff 75 f0             	pushl  -0x10(%ebp)
  804039:	ff 75 08             	pushl  0x8(%ebp)
  80403c:	e8 1e ea ff ff       	call   802a5f <set_block_data>
  804041:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804044:	8b 45 08             	mov    0x8(%ebp),%eax
  804047:	83 e8 04             	sub    $0x4,%eax
  80404a:	8b 00                	mov    (%eax),%eax
  80404c:	83 e0 fe             	and    $0xfffffffe,%eax
  80404f:	89 c2                	mov    %eax,%edx
  804051:	8b 45 08             	mov    0x8(%ebp),%eax
  804054:	01 d0                	add    %edx,%eax
  804056:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804059:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80405d:	74 06                	je     804065 <realloc_block_FF+0x613>
  80405f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804063:	75 17                	jne    80407c <realloc_block_FF+0x62a>
  804065:	83 ec 04             	sub    $0x4,%esp
  804068:	68 f8 4d 80 00       	push   $0x804df8
  80406d:	68 44 02 00 00       	push   $0x244
  804072:	68 85 4d 80 00       	push   $0x804d85
  804077:	e8 2b 01 00 00       	call   8041a7 <_panic>
  80407c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407f:	8b 10                	mov    (%eax),%edx
  804081:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804084:	89 10                	mov    %edx,(%eax)
  804086:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804089:	8b 00                	mov    (%eax),%eax
  80408b:	85 c0                	test   %eax,%eax
  80408d:	74 0b                	je     80409a <realloc_block_FF+0x648>
  80408f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804092:	8b 00                	mov    (%eax),%eax
  804094:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804097:	89 50 04             	mov    %edx,0x4(%eax)
  80409a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040a0:	89 10                	mov    %edx,(%eax)
  8040a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040a8:	89 50 04             	mov    %edx,0x4(%eax)
  8040ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040ae:	8b 00                	mov    (%eax),%eax
  8040b0:	85 c0                	test   %eax,%eax
  8040b2:	75 08                	jne    8040bc <realloc_block_FF+0x66a>
  8040b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8040bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8040c1:	40                   	inc    %eax
  8040c2:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040cb:	75 17                	jne    8040e4 <realloc_block_FF+0x692>
  8040cd:	83 ec 04             	sub    $0x4,%esp
  8040d0:	68 67 4d 80 00       	push   $0x804d67
  8040d5:	68 45 02 00 00       	push   $0x245
  8040da:	68 85 4d 80 00       	push   $0x804d85
  8040df:	e8 c3 00 00 00       	call   8041a7 <_panic>
  8040e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e7:	8b 00                	mov    (%eax),%eax
  8040e9:	85 c0                	test   %eax,%eax
  8040eb:	74 10                	je     8040fd <realloc_block_FF+0x6ab>
  8040ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f0:	8b 00                	mov    (%eax),%eax
  8040f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040f5:	8b 52 04             	mov    0x4(%edx),%edx
  8040f8:	89 50 04             	mov    %edx,0x4(%eax)
  8040fb:	eb 0b                	jmp    804108 <realloc_block_FF+0x6b6>
  8040fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804100:	8b 40 04             	mov    0x4(%eax),%eax
  804103:	a3 30 50 80 00       	mov    %eax,0x805030
  804108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410b:	8b 40 04             	mov    0x4(%eax),%eax
  80410e:	85 c0                	test   %eax,%eax
  804110:	74 0f                	je     804121 <realloc_block_FF+0x6cf>
  804112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804115:	8b 40 04             	mov    0x4(%eax),%eax
  804118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80411b:	8b 12                	mov    (%edx),%edx
  80411d:	89 10                	mov    %edx,(%eax)
  80411f:	eb 0a                	jmp    80412b <realloc_block_FF+0x6d9>
  804121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804124:	8b 00                	mov    (%eax),%eax
  804126:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80412b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80413e:	a1 38 50 80 00       	mov    0x805038,%eax
  804143:	48                   	dec    %eax
  804144:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  804149:	83 ec 04             	sub    $0x4,%esp
  80414c:	6a 00                	push   $0x0
  80414e:	ff 75 bc             	pushl  -0x44(%ebp)
  804151:	ff 75 b8             	pushl  -0x48(%ebp)
  804154:	e8 06 e9 ff ff       	call   802a5f <set_block_data>
  804159:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80415c:	8b 45 08             	mov    0x8(%ebp),%eax
  80415f:	eb 0a                	jmp    80416b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804161:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804168:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80416b:	c9                   	leave  
  80416c:	c3                   	ret    

0080416d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80416d:	55                   	push   %ebp
  80416e:	89 e5                	mov    %esp,%ebp
  804170:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804173:	83 ec 04             	sub    $0x4,%esp
  804176:	68 7c 4e 80 00       	push   $0x804e7c
  80417b:	68 58 02 00 00       	push   $0x258
  804180:	68 85 4d 80 00       	push   $0x804d85
  804185:	e8 1d 00 00 00       	call   8041a7 <_panic>

0080418a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80418a:	55                   	push   %ebp
  80418b:	89 e5                	mov    %esp,%ebp
  80418d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804190:	83 ec 04             	sub    $0x4,%esp
  804193:	68 a4 4e 80 00       	push   $0x804ea4
  804198:	68 61 02 00 00       	push   $0x261
  80419d:	68 85 4d 80 00       	push   $0x804d85
  8041a2:	e8 00 00 00 00       	call   8041a7 <_panic>

008041a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8041a7:	55                   	push   %ebp
  8041a8:	89 e5                	mov    %esp,%ebp
  8041aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8041ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8041b0:	83 c0 04             	add    $0x4,%eax
  8041b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8041b6:	a1 60 50 98 00       	mov    0x985060,%eax
  8041bb:	85 c0                	test   %eax,%eax
  8041bd:	74 16                	je     8041d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8041bf:	a1 60 50 98 00       	mov    0x985060,%eax
  8041c4:	83 ec 08             	sub    $0x8,%esp
  8041c7:	50                   	push   %eax
  8041c8:	68 cc 4e 80 00       	push   $0x804ecc
  8041cd:	e8 4f ca ff ff       	call   800c21 <cprintf>
  8041d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8041d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8041da:	ff 75 0c             	pushl  0xc(%ebp)
  8041dd:	ff 75 08             	pushl  0x8(%ebp)
  8041e0:	50                   	push   %eax
  8041e1:	68 d1 4e 80 00       	push   $0x804ed1
  8041e6:	e8 36 ca ff ff       	call   800c21 <cprintf>
  8041eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8041ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8041f1:	83 ec 08             	sub    $0x8,%esp
  8041f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8041f7:	50                   	push   %eax
  8041f8:	e8 b9 c9 ff ff       	call   800bb6 <vcprintf>
  8041fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804200:	83 ec 08             	sub    $0x8,%esp
  804203:	6a 00                	push   $0x0
  804205:	68 ed 4e 80 00       	push   $0x804eed
  80420a:	e8 a7 c9 ff ff       	call   800bb6 <vcprintf>
  80420f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  804212:	e8 28 c9 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  804217:	eb fe                	jmp    804217 <_panic+0x70>

00804219 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  804219:	55                   	push   %ebp
  80421a:	89 e5                	mov    %esp,%ebp
  80421c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80421f:	a1 20 50 80 00       	mov    0x805020,%eax
  804224:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80422a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80422d:	39 c2                	cmp    %eax,%edx
  80422f:	74 14                	je     804245 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  804231:	83 ec 04             	sub    $0x4,%esp
  804234:	68 f0 4e 80 00       	push   $0x804ef0
  804239:	6a 26                	push   $0x26
  80423b:	68 3c 4f 80 00       	push   $0x804f3c
  804240:	e8 62 ff ff ff       	call   8041a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804245:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80424c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804253:	e9 c5 00 00 00       	jmp    80431d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  804258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80425b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804262:	8b 45 08             	mov    0x8(%ebp),%eax
  804265:	01 d0                	add    %edx,%eax
  804267:	8b 00                	mov    (%eax),%eax
  804269:	85 c0                	test   %eax,%eax
  80426b:	75 08                	jne    804275 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80426d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804270:	e9 a5 00 00 00       	jmp    80431a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804275:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80427c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804283:	eb 69                	jmp    8042ee <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  804285:	a1 20 50 80 00       	mov    0x805020,%eax
  80428a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804290:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804293:	89 d0                	mov    %edx,%eax
  804295:	01 c0                	add    %eax,%eax
  804297:	01 d0                	add    %edx,%eax
  804299:	c1 e0 03             	shl    $0x3,%eax
  80429c:	01 c8                	add    %ecx,%eax
  80429e:	8a 40 04             	mov    0x4(%eax),%al
  8042a1:	84 c0                	test   %al,%al
  8042a3:	75 46                	jne    8042eb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8042a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8042aa:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8042b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042b3:	89 d0                	mov    %edx,%eax
  8042b5:	01 c0                	add    %eax,%eax
  8042b7:	01 d0                	add    %edx,%eax
  8042b9:	c1 e0 03             	shl    $0x3,%eax
  8042bc:	01 c8                	add    %ecx,%eax
  8042be:	8b 00                	mov    (%eax),%eax
  8042c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8042c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8042cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8042cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8042d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042da:	01 c8                	add    %ecx,%eax
  8042dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8042de:	39 c2                	cmp    %eax,%edx
  8042e0:	75 09                	jne    8042eb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8042e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8042e9:	eb 15                	jmp    804300 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042eb:	ff 45 e8             	incl   -0x18(%ebp)
  8042ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8042f3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8042f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042fc:	39 c2                	cmp    %eax,%edx
  8042fe:	77 85                	ja     804285 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804300:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804304:	75 14                	jne    80431a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  804306:	83 ec 04             	sub    $0x4,%esp
  804309:	68 48 4f 80 00       	push   $0x804f48
  80430e:	6a 3a                	push   $0x3a
  804310:	68 3c 4f 80 00       	push   $0x804f3c
  804315:	e8 8d fe ff ff       	call   8041a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80431a:	ff 45 f0             	incl   -0x10(%ebp)
  80431d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804320:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804323:	0f 8c 2f ff ff ff    	jl     804258 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  804329:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804330:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804337:	eb 26                	jmp    80435f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  804339:	a1 20 50 80 00       	mov    0x805020,%eax
  80433e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804344:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804347:	89 d0                	mov    %edx,%eax
  804349:	01 c0                	add    %eax,%eax
  80434b:	01 d0                	add    %edx,%eax
  80434d:	c1 e0 03             	shl    $0x3,%eax
  804350:	01 c8                	add    %ecx,%eax
  804352:	8a 40 04             	mov    0x4(%eax),%al
  804355:	3c 01                	cmp    $0x1,%al
  804357:	75 03                	jne    80435c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  804359:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80435c:	ff 45 e0             	incl   -0x20(%ebp)
  80435f:	a1 20 50 80 00       	mov    0x805020,%eax
  804364:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80436a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80436d:	39 c2                	cmp    %eax,%edx
  80436f:	77 c8                	ja     804339 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804374:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804377:	74 14                	je     80438d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  804379:	83 ec 04             	sub    $0x4,%esp
  80437c:	68 9c 4f 80 00       	push   $0x804f9c
  804381:	6a 44                	push   $0x44
  804383:	68 3c 4f 80 00       	push   $0x804f3c
  804388:	e8 1a fe ff ff       	call   8041a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80438d:	90                   	nop
  80438e:	c9                   	leave  
  80438f:	c3                   	ret    

00804390 <__udivdi3>:
  804390:	55                   	push   %ebp
  804391:	57                   	push   %edi
  804392:	56                   	push   %esi
  804393:	53                   	push   %ebx
  804394:	83 ec 1c             	sub    $0x1c,%esp
  804397:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80439b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80439f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043a7:	89 ca                	mov    %ecx,%edx
  8043a9:	89 f8                	mov    %edi,%eax
  8043ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043af:	85 f6                	test   %esi,%esi
  8043b1:	75 2d                	jne    8043e0 <__udivdi3+0x50>
  8043b3:	39 cf                	cmp    %ecx,%edi
  8043b5:	77 65                	ja     80441c <__udivdi3+0x8c>
  8043b7:	89 fd                	mov    %edi,%ebp
  8043b9:	85 ff                	test   %edi,%edi
  8043bb:	75 0b                	jne    8043c8 <__udivdi3+0x38>
  8043bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8043c2:	31 d2                	xor    %edx,%edx
  8043c4:	f7 f7                	div    %edi
  8043c6:	89 c5                	mov    %eax,%ebp
  8043c8:	31 d2                	xor    %edx,%edx
  8043ca:	89 c8                	mov    %ecx,%eax
  8043cc:	f7 f5                	div    %ebp
  8043ce:	89 c1                	mov    %eax,%ecx
  8043d0:	89 d8                	mov    %ebx,%eax
  8043d2:	f7 f5                	div    %ebp
  8043d4:	89 cf                	mov    %ecx,%edi
  8043d6:	89 fa                	mov    %edi,%edx
  8043d8:	83 c4 1c             	add    $0x1c,%esp
  8043db:	5b                   	pop    %ebx
  8043dc:	5e                   	pop    %esi
  8043dd:	5f                   	pop    %edi
  8043de:	5d                   	pop    %ebp
  8043df:	c3                   	ret    
  8043e0:	39 ce                	cmp    %ecx,%esi
  8043e2:	77 28                	ja     80440c <__udivdi3+0x7c>
  8043e4:	0f bd fe             	bsr    %esi,%edi
  8043e7:	83 f7 1f             	xor    $0x1f,%edi
  8043ea:	75 40                	jne    80442c <__udivdi3+0x9c>
  8043ec:	39 ce                	cmp    %ecx,%esi
  8043ee:	72 0a                	jb     8043fa <__udivdi3+0x6a>
  8043f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043f4:	0f 87 9e 00 00 00    	ja     804498 <__udivdi3+0x108>
  8043fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ff:	89 fa                	mov    %edi,%edx
  804401:	83 c4 1c             	add    $0x1c,%esp
  804404:	5b                   	pop    %ebx
  804405:	5e                   	pop    %esi
  804406:	5f                   	pop    %edi
  804407:	5d                   	pop    %ebp
  804408:	c3                   	ret    
  804409:	8d 76 00             	lea    0x0(%esi),%esi
  80440c:	31 ff                	xor    %edi,%edi
  80440e:	31 c0                	xor    %eax,%eax
  804410:	89 fa                	mov    %edi,%edx
  804412:	83 c4 1c             	add    $0x1c,%esp
  804415:	5b                   	pop    %ebx
  804416:	5e                   	pop    %esi
  804417:	5f                   	pop    %edi
  804418:	5d                   	pop    %ebp
  804419:	c3                   	ret    
  80441a:	66 90                	xchg   %ax,%ax
  80441c:	89 d8                	mov    %ebx,%eax
  80441e:	f7 f7                	div    %edi
  804420:	31 ff                	xor    %edi,%edi
  804422:	89 fa                	mov    %edi,%edx
  804424:	83 c4 1c             	add    $0x1c,%esp
  804427:	5b                   	pop    %ebx
  804428:	5e                   	pop    %esi
  804429:	5f                   	pop    %edi
  80442a:	5d                   	pop    %ebp
  80442b:	c3                   	ret    
  80442c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804431:	89 eb                	mov    %ebp,%ebx
  804433:	29 fb                	sub    %edi,%ebx
  804435:	89 f9                	mov    %edi,%ecx
  804437:	d3 e6                	shl    %cl,%esi
  804439:	89 c5                	mov    %eax,%ebp
  80443b:	88 d9                	mov    %bl,%cl
  80443d:	d3 ed                	shr    %cl,%ebp
  80443f:	89 e9                	mov    %ebp,%ecx
  804441:	09 f1                	or     %esi,%ecx
  804443:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804447:	89 f9                	mov    %edi,%ecx
  804449:	d3 e0                	shl    %cl,%eax
  80444b:	89 c5                	mov    %eax,%ebp
  80444d:	89 d6                	mov    %edx,%esi
  80444f:	88 d9                	mov    %bl,%cl
  804451:	d3 ee                	shr    %cl,%esi
  804453:	89 f9                	mov    %edi,%ecx
  804455:	d3 e2                	shl    %cl,%edx
  804457:	8b 44 24 08          	mov    0x8(%esp),%eax
  80445b:	88 d9                	mov    %bl,%cl
  80445d:	d3 e8                	shr    %cl,%eax
  80445f:	09 c2                	or     %eax,%edx
  804461:	89 d0                	mov    %edx,%eax
  804463:	89 f2                	mov    %esi,%edx
  804465:	f7 74 24 0c          	divl   0xc(%esp)
  804469:	89 d6                	mov    %edx,%esi
  80446b:	89 c3                	mov    %eax,%ebx
  80446d:	f7 e5                	mul    %ebp
  80446f:	39 d6                	cmp    %edx,%esi
  804471:	72 19                	jb     80448c <__udivdi3+0xfc>
  804473:	74 0b                	je     804480 <__udivdi3+0xf0>
  804475:	89 d8                	mov    %ebx,%eax
  804477:	31 ff                	xor    %edi,%edi
  804479:	e9 58 ff ff ff       	jmp    8043d6 <__udivdi3+0x46>
  80447e:	66 90                	xchg   %ax,%ax
  804480:	8b 54 24 08          	mov    0x8(%esp),%edx
  804484:	89 f9                	mov    %edi,%ecx
  804486:	d3 e2                	shl    %cl,%edx
  804488:	39 c2                	cmp    %eax,%edx
  80448a:	73 e9                	jae    804475 <__udivdi3+0xe5>
  80448c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80448f:	31 ff                	xor    %edi,%edi
  804491:	e9 40 ff ff ff       	jmp    8043d6 <__udivdi3+0x46>
  804496:	66 90                	xchg   %ax,%ax
  804498:	31 c0                	xor    %eax,%eax
  80449a:	e9 37 ff ff ff       	jmp    8043d6 <__udivdi3+0x46>
  80449f:	90                   	nop

008044a0 <__umoddi3>:
  8044a0:	55                   	push   %ebp
  8044a1:	57                   	push   %edi
  8044a2:	56                   	push   %esi
  8044a3:	53                   	push   %ebx
  8044a4:	83 ec 1c             	sub    $0x1c,%esp
  8044a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044bf:	89 f3                	mov    %esi,%ebx
  8044c1:	89 fa                	mov    %edi,%edx
  8044c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044c7:	89 34 24             	mov    %esi,(%esp)
  8044ca:	85 c0                	test   %eax,%eax
  8044cc:	75 1a                	jne    8044e8 <__umoddi3+0x48>
  8044ce:	39 f7                	cmp    %esi,%edi
  8044d0:	0f 86 a2 00 00 00    	jbe    804578 <__umoddi3+0xd8>
  8044d6:	89 c8                	mov    %ecx,%eax
  8044d8:	89 f2                	mov    %esi,%edx
  8044da:	f7 f7                	div    %edi
  8044dc:	89 d0                	mov    %edx,%eax
  8044de:	31 d2                	xor    %edx,%edx
  8044e0:	83 c4 1c             	add    $0x1c,%esp
  8044e3:	5b                   	pop    %ebx
  8044e4:	5e                   	pop    %esi
  8044e5:	5f                   	pop    %edi
  8044e6:	5d                   	pop    %ebp
  8044e7:	c3                   	ret    
  8044e8:	39 f0                	cmp    %esi,%eax
  8044ea:	0f 87 ac 00 00 00    	ja     80459c <__umoddi3+0xfc>
  8044f0:	0f bd e8             	bsr    %eax,%ebp
  8044f3:	83 f5 1f             	xor    $0x1f,%ebp
  8044f6:	0f 84 ac 00 00 00    	je     8045a8 <__umoddi3+0x108>
  8044fc:	bf 20 00 00 00       	mov    $0x20,%edi
  804501:	29 ef                	sub    %ebp,%edi
  804503:	89 fe                	mov    %edi,%esi
  804505:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804509:	89 e9                	mov    %ebp,%ecx
  80450b:	d3 e0                	shl    %cl,%eax
  80450d:	89 d7                	mov    %edx,%edi
  80450f:	89 f1                	mov    %esi,%ecx
  804511:	d3 ef                	shr    %cl,%edi
  804513:	09 c7                	or     %eax,%edi
  804515:	89 e9                	mov    %ebp,%ecx
  804517:	d3 e2                	shl    %cl,%edx
  804519:	89 14 24             	mov    %edx,(%esp)
  80451c:	89 d8                	mov    %ebx,%eax
  80451e:	d3 e0                	shl    %cl,%eax
  804520:	89 c2                	mov    %eax,%edx
  804522:	8b 44 24 08          	mov    0x8(%esp),%eax
  804526:	d3 e0                	shl    %cl,%eax
  804528:	89 44 24 04          	mov    %eax,0x4(%esp)
  80452c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804530:	89 f1                	mov    %esi,%ecx
  804532:	d3 e8                	shr    %cl,%eax
  804534:	09 d0                	or     %edx,%eax
  804536:	d3 eb                	shr    %cl,%ebx
  804538:	89 da                	mov    %ebx,%edx
  80453a:	f7 f7                	div    %edi
  80453c:	89 d3                	mov    %edx,%ebx
  80453e:	f7 24 24             	mull   (%esp)
  804541:	89 c6                	mov    %eax,%esi
  804543:	89 d1                	mov    %edx,%ecx
  804545:	39 d3                	cmp    %edx,%ebx
  804547:	0f 82 87 00 00 00    	jb     8045d4 <__umoddi3+0x134>
  80454d:	0f 84 91 00 00 00    	je     8045e4 <__umoddi3+0x144>
  804553:	8b 54 24 04          	mov    0x4(%esp),%edx
  804557:	29 f2                	sub    %esi,%edx
  804559:	19 cb                	sbb    %ecx,%ebx
  80455b:	89 d8                	mov    %ebx,%eax
  80455d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804561:	d3 e0                	shl    %cl,%eax
  804563:	89 e9                	mov    %ebp,%ecx
  804565:	d3 ea                	shr    %cl,%edx
  804567:	09 d0                	or     %edx,%eax
  804569:	89 e9                	mov    %ebp,%ecx
  80456b:	d3 eb                	shr    %cl,%ebx
  80456d:	89 da                	mov    %ebx,%edx
  80456f:	83 c4 1c             	add    $0x1c,%esp
  804572:	5b                   	pop    %ebx
  804573:	5e                   	pop    %esi
  804574:	5f                   	pop    %edi
  804575:	5d                   	pop    %ebp
  804576:	c3                   	ret    
  804577:	90                   	nop
  804578:	89 fd                	mov    %edi,%ebp
  80457a:	85 ff                	test   %edi,%edi
  80457c:	75 0b                	jne    804589 <__umoddi3+0xe9>
  80457e:	b8 01 00 00 00       	mov    $0x1,%eax
  804583:	31 d2                	xor    %edx,%edx
  804585:	f7 f7                	div    %edi
  804587:	89 c5                	mov    %eax,%ebp
  804589:	89 f0                	mov    %esi,%eax
  80458b:	31 d2                	xor    %edx,%edx
  80458d:	f7 f5                	div    %ebp
  80458f:	89 c8                	mov    %ecx,%eax
  804591:	f7 f5                	div    %ebp
  804593:	89 d0                	mov    %edx,%eax
  804595:	e9 44 ff ff ff       	jmp    8044de <__umoddi3+0x3e>
  80459a:	66 90                	xchg   %ax,%ax
  80459c:	89 c8                	mov    %ecx,%eax
  80459e:	89 f2                	mov    %esi,%edx
  8045a0:	83 c4 1c             	add    $0x1c,%esp
  8045a3:	5b                   	pop    %ebx
  8045a4:	5e                   	pop    %esi
  8045a5:	5f                   	pop    %edi
  8045a6:	5d                   	pop    %ebp
  8045a7:	c3                   	ret    
  8045a8:	3b 04 24             	cmp    (%esp),%eax
  8045ab:	72 06                	jb     8045b3 <__umoddi3+0x113>
  8045ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045b1:	77 0f                	ja     8045c2 <__umoddi3+0x122>
  8045b3:	89 f2                	mov    %esi,%edx
  8045b5:	29 f9                	sub    %edi,%ecx
  8045b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045bb:	89 14 24             	mov    %edx,(%esp)
  8045be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045c6:	8b 14 24             	mov    (%esp),%edx
  8045c9:	83 c4 1c             	add    $0x1c,%esp
  8045cc:	5b                   	pop    %ebx
  8045cd:	5e                   	pop    %esi
  8045ce:	5f                   	pop    %edi
  8045cf:	5d                   	pop    %ebp
  8045d0:	c3                   	ret    
  8045d1:	8d 76 00             	lea    0x0(%esi),%esi
  8045d4:	2b 04 24             	sub    (%esp),%eax
  8045d7:	19 fa                	sbb    %edi,%edx
  8045d9:	89 d1                	mov    %edx,%ecx
  8045db:	89 c6                	mov    %eax,%esi
  8045dd:	e9 71 ff ff ff       	jmp    804553 <__umoddi3+0xb3>
  8045e2:	66 90                	xchg   %ax,%ax
  8045e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045e8:	72 ea                	jb     8045d4 <__umoddi3+0x134>
  8045ea:	89 d9                	mov    %ebx,%ecx
  8045ec:	e9 62 ff ff ff       	jmp    804553 <__umoddi3+0xb3>
