
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
  80005e:	e8 ed 21 00 00       	call   802250 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 00 47 80 00       	push   $0x804700
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 04 47 80 00       	push   $0x804704
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 28 47 80 00       	push   $0x804728
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 04 47 80 00       	push   $0x804704
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 00 47 80 00       	push   $0x804700
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 4c 47 80 00       	push   $0x80474c
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
  8000e6:	68 6c 47 80 00       	push   $0x80476c
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 8e 47 80 00       	push   $0x80478e
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 9c 47 80 00       	push   $0x80479c
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 aa 47 80 00       	push   $0x8047aa
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 ba 47 80 00       	push   $0x8047ba
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
  80017a:	68 c4 47 80 00       	push   $0x8047c4
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
  8001a0:	e8 c5 20 00 00       	call   80226a <sys_unlock_cons>

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
  8002d2:	e8 79 1f 00 00       	call   802250 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 e8 47 80 00       	push   $0x8047e8
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 06 48 80 00       	push   $0x804806
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 1d 48 80 00       	push   $0x80481d
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 34 48 80 00       	push   $0x804834
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 ba 47 80 00       	push   $0x8047ba
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
  80035e:	e8 07 1f 00 00       	call   80226a <sys_unlock_cons>


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
  8003df:	e8 6c 1e 00 00       	call   802250 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 4b 48 80 00       	push   $0x80484b
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 71 1e 00 00       	call   80226a <sys_unlock_cons>

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
  80048e:	e8 bd 1d 00 00       	call   802250 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 64 48 80 00       	push   $0x804864
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
  8004c8:	e8 9d 1d 00 00       	call   80226a <sys_unlock_cons>

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
  8008bf:	e8 54 1c 00 00       	call   802518 <sys_get_virtual_time>
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
  80092b:	68 82 48 80 00       	push   $0x804882
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
  800946:	68 89 48 80 00       	push   $0x804889
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
  80099c:	68 8d 48 80 00       	push   $0x80488d
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
  8009b7:	68 89 48 80 00       	push   $0x804889
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
  8009e6:	e8 b0 19 00 00       	call   80239b <sys_cputc>
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
  8009f7:	e8 3b 18 00 00       	call   802237 <sys_cgetc>
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
  800a14:	e8 b3 1a 00 00       	call   8024cc <sys_getenvindex>
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
  800a43:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a48:	a1 20 60 80 00       	mov    0x806020,%eax
  800a4d:	8a 40 20             	mov    0x20(%eax),%al
  800a50:	84 c0                	test   %al,%al
  800a52:	74 0d                	je     800a61 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800a54:	a1 20 60 80 00       	mov    0x806020,%eax
  800a59:	83 c0 20             	add    $0x20,%eax
  800a5c:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a65:	7e 0a                	jle    800a71 <libmain+0x63>
		binaryname = argv[0];
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	ff 75 08             	pushl  0x8(%ebp)
  800a7a:	e8 b9 f5 ff ff       	call   800038 <_main>
  800a7f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800a82:	e8 c9 17 00 00       	call   802250 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 b0 48 80 00       	push   $0x8048b0
  800a8f:	e8 8d 01 00 00       	call   800c21 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a97:	a1 20 60 80 00       	mov    0x806020,%eax
  800a9c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800aa2:	a1 20 60 80 00       	mov    0x806020,%eax
  800aa7:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	50                   	push   %eax
  800ab2:	68 d8 48 80 00       	push   $0x8048d8
  800ab7:	e8 65 01 00 00       	call   800c21 <cprintf>
  800abc:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800abf:	a1 20 60 80 00       	mov    0x806020,%eax
  800ac4:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800aca:	a1 20 60 80 00       	mov    0x806020,%eax
  800acf:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800ad5:	a1 20 60 80 00       	mov    0x806020,%eax
  800ada:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800ae0:	51                   	push   %ecx
  800ae1:	52                   	push   %edx
  800ae2:	50                   	push   %eax
  800ae3:	68 00 49 80 00       	push   $0x804900
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 60 80 00       	mov    0x806020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 58 49 80 00       	push   $0x804958
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 b0 48 80 00       	push   $0x8048b0
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 49 17 00 00       	call   80226a <sys_unlock_cons>
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
  800b34:	e8 5f 19 00 00       	call   802498 <sys_destroy_env>
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
  800b45:	e8 b4 19 00 00       	call   8024fe <sys_exit_env>
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
  800b78:	a0 2c 60 80 00       	mov    0x80602c,%al
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
  800b93:	e8 76 16 00 00       	call   80220e <sys_cputs>
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
  800bed:	a0 2c 60 80 00       	mov    0x80602c,%al
  800bf2:	0f b6 c0             	movzbl %al,%eax
  800bf5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800bfb:	83 ec 04             	sub    $0x4,%esp
  800bfe:	50                   	push   %eax
  800bff:	52                   	push   %edx
  800c00:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c06:	83 c0 08             	add    $0x8,%eax
  800c09:	50                   	push   %eax
  800c0a:	e8 ff 15 00 00       	call   80220e <sys_cputs>
  800c0f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c12:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
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
  800c27:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
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
  800c54:	e8 f7 15 00 00       	call   802250 <sys_lock_cons>
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
  800c74:	e8 f1 15 00 00       	call   80226a <sys_unlock_cons>
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
  800cbe:	e8 cd 37 00 00       	call   804490 <__udivdi3>
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
  800d0e:	e8 8d 38 00 00       	call   8045a0 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 94 4b 80 00       	add    $0x804b94,%eax
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
  800e69:	8b 04 85 b8 4b 80 00 	mov    0x804bb8(,%eax,4),%eax
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
  800f4a:	8b 34 9d 00 4a 80 00 	mov    0x804a00(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 a5 4b 80 00       	push   $0x804ba5
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
  800f6f:	68 ae 4b 80 00       	push   $0x804bae
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
  800f9c:	be b1 4b 80 00       	mov    $0x804bb1,%esi
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
  801194:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
			break;
  80119b:	eb 2c                	jmp    8011c9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80119d:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
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
  8012c7:	68 28 4d 80 00       	push   $0x804d28
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
  801309:	68 2b 4d 80 00       	push   $0x804d2b
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
  8013ba:	e8 91 0e 00 00       	call   802250 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 28 4d 80 00       	push   $0x804d28
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
  80140d:	68 2b 4d 80 00       	push   $0x804d2b
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
  8014b5:	e8 b0 0d 00 00       	call   80226a <sys_unlock_cons>
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
  801baf:	68 3c 4d 80 00       	push   $0x804d3c
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 5e 4d 80 00       	push   $0x804d5e
  801bbe:	e8 e2 26 00 00       	call   8042a5 <_panic>

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
  801bcf:	e8 e5 0b 00 00       	call   8027b9 <sys_sbrk>
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
  801c18:	a1 20 60 80 00       	mov    0x806020,%eax
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
  801c4a:	e8 ee 09 00 00       	call   80263d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 2e 0f 00 00       	call   802b8c <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 00 0a 00 00       	call   80266e <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 c7 13 00 00       	call   803048 <alloc_block_BF>
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
  801c99:	a1 20 60 80 00       	mov    0x806020,%eax
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
  801cb5:	a1 20 60 80 00       	mov    0x806020,%eax
  801cba:	8b 40 78             	mov    0x78(%eax),%eax
  801cbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cc0:	29 c2                	sub    %eax,%edx
  801cc2:	89 d0                	mov    %edx,%eax
  801cc4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc9:	c1 e8 0c             	shr    $0xc,%eax
  801ccc:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
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
  801d02:	a1 20 60 80 00       	mov    0x806020,%eax
  801d07:	8b 40 78             	mov    0x78(%eax),%eax
  801d0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d0d:	29 c2                	sub    %eax,%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d16:	c1 e8 0c             	shr    $0xc,%eax
  801d19:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
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
  801d5c:	a1 20 60 80 00       	mov    0x806020,%eax
  801d61:	8b 40 78             	mov    0x78(%eax),%eax
  801d64:	29 c2                	sub    %eax,%edx
  801d66:	89 d0                	mov    %edx,%eax
  801d68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6d:	c1 e8 0c             	shr    $0xc,%eax
  801d70:	c7 04 85 60 a0 08 01 	movl   $0x1,0x108a060(,%eax,4)
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
  801db6:	a1 20 60 80 00       	mov    0x806020,%eax
  801dbb:	8b 40 78             	mov    0x78(%eax),%eax
  801dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc1:	29 c2                	sub    %eax,%edx
  801dc3:	89 d0                	mov    %edx,%eax
  801dc5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dca:	c1 e8 0c             	shr    $0xc,%eax
  801dcd:	89 c2                	mov    %eax,%edx
  801dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dd2:	89 04 95 60 a0 10 01 	mov    %eax,0x110a060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  801de2:	e8 09 0a 00 00       	call   8027f0 <sys_allocate_user_mem>
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
  801dfe:	a1 20 60 80 00       	mov    0x806020,%eax
  801e03:	8b 40 78             	mov    0x78(%eax),%eax
  801e06:	05 00 10 00 00       	add    $0x1000,%eax
  801e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801e0e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801e15:	a1 20 60 80 00       	mov    0x806020,%eax
  801e1a:	8b 50 78             	mov    0x78(%eax),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	39 c2                	cmp    %eax,%edx
  801e22:	76 24                	jbe    801e48 <free+0x50>
		size = get_block_size(va);
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	ff 75 08             	pushl  0x8(%ebp)
  801e2a:	e8 dd 09 00 00       	call   80280c <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 10 1c 00 00       	call   803a50 <free_block>
  801e40:	83 c4 10             	add    $0x10,%esp
		}

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
  801e61:	a1 20 60 80 00       	mov    0x806020,%eax
  801e66:	8b 40 78             	mov    0x78(%eax),%eax
  801e69:	29 c2                	sub    %eax,%edx
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e72:	c1 e8 0c             	shr    $0xc,%eax
  801e75:	8b 04 85 60 a0 10 01 	mov    0x110a060(,%eax,4),%eax
  801e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e82:	c1 e0 0c             	shl    $0xc,%eax
  801e85:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801e88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e8f:	eb 42                	jmp    801ed3 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	c1 e0 0c             	shl    $0xc,%eax
  801e97:	89 c2                	mov    %eax,%edx
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	01 c2                	add    %eax,%edx
  801e9e:	a1 20 60 80 00       	mov    0x806020,%eax
  801ea3:	8b 40 78             	mov    0x78(%eax),%eax
  801ea6:	29 c2                	sub    %eax,%edx
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eaf:	c1 e8 0c             	shr    $0xc,%eax
  801eb2:	c7 04 85 60 a0 08 01 	movl   $0x0,0x108a060(,%eax,4)
  801eb9:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	83 ec 08             	sub    $0x8,%esp
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	e8 07 09 00 00       	call   8027d4 <sys_free_user_mem>
  801ecd:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801ed0:	ff 45 f4             	incl   -0xc(%ebp)
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ed9:	72 b6                	jb     801e91 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801edb:	eb 17                	jmp    801ef4 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	68 6c 4d 80 00       	push   $0x804d6c
  801ee5:	68 88 00 00 00       	push   $0x88
  801eea:	68 96 4d 80 00       	push   $0x804d96
  801eef:	e8 b1 23 00 00       	call   8042a5 <_panic>
	}
}
  801ef4:	90                   	nop
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 28             	sub    $0x28,%esp
  801efd:	8b 45 10             	mov    0x10(%ebp),%eax
  801f00:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801f03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f07:	75 0a                	jne    801f13 <smalloc+0x1c>
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0e:	e9 ec 00 00 00       	jmp    801fff <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f19:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	39 d0                	cmp    %edx,%eax
  801f28:	73 02                	jae    801f2c <smalloc+0x35>
  801f2a:	89 d0                	mov    %edx,%eax
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	50                   	push   %eax
  801f30:	e8 a4 fc ff ff       	call   801bd9 <malloc>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3f:	75 0a                	jne    801f4b <smalloc+0x54>
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	e9 b4 00 00 00       	jmp    801fff <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f4b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f4f:	ff 75 ec             	pushl  -0x14(%ebp)
  801f52:	50                   	push   %eax
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	e8 7d 04 00 00       	call   8023db <sys_createSharedObject>
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f64:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f68:	74 06                	je     801f70 <smalloc+0x79>
  801f6a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f6e:	75 0a                	jne    801f7a <smalloc+0x83>
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
  801f75:	e9 85 00 00 00       	jmp    801fff <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	ff 75 ec             	pushl  -0x14(%ebp)
  801f80:	68 a2 4d 80 00       	push   $0x804da2
  801f85:	e8 97 ec ff ff       	call   800c21 <cprintf>
  801f8a:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801f8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f90:	a1 20 60 80 00       	mov    0x806020,%eax
  801f95:	8b 40 78             	mov    0x78(%eax),%eax
  801f98:	29 c2                	sub    %eax,%edx
  801f9a:	89 d0                	mov    %edx,%eax
  801f9c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fa1:	c1 e8 0c             	shr    $0xc,%eax
  801fa4:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801faa:	42                   	inc    %edx
  801fab:	89 15 24 60 80 00    	mov    %edx,0x806024
  801fb1:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801fb7:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801fbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fc1:	a1 20 60 80 00       	mov    0x806020,%eax
  801fc6:	8b 40 78             	mov    0x78(%eax),%eax
  801fc9:	29 c2                	sub    %eax,%edx
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fd2:	c1 e8 0c             	shr    $0xc,%eax
  801fd5:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  801fdc:	a1 20 60 80 00       	mov    0x806020,%eax
  801fe1:	8b 50 10             	mov    0x10(%eax),%edx
  801fe4:	89 c8                	mov    %ecx,%eax
  801fe6:	c1 e0 02             	shl    $0x2,%eax
  801fe9:	89 c1                	mov    %eax,%ecx
  801feb:	c1 e1 09             	shl    $0x9,%ecx
  801fee:	01 c8                	add    %ecx,%eax
  801ff0:	01 c2                	add    %eax,%edx
  801ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff5:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  801ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802007:	83 ec 08             	sub    $0x8,%esp
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 f0 03 00 00       	call   802405 <sys_getSizeOfSharedObject>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80201b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80201f:	75 0a                	jne    80202b <sget+0x2a>
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	e9 e7 00 00 00       	jmp    802112 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802031:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802038:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	39 d0                	cmp    %edx,%eax
  802040:	73 02                	jae    802044 <sget+0x43>
  802042:	89 d0                	mov    %edx,%eax
  802044:	83 ec 0c             	sub    $0xc,%esp
  802047:	50                   	push   %eax
  802048:	e8 8c fb ff ff       	call   801bd9 <malloc>
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802053:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802057:	75 0a                	jne    802063 <sget+0x62>
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	e9 af 00 00 00       	jmp    802112 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	ff 75 e8             	pushl  -0x18(%ebp)
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	ff 75 08             	pushl  0x8(%ebp)
  80206f:	e8 ae 03 00 00       	call   802422 <sys_getSharedObject>
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80207a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80207d:	a1 20 60 80 00       	mov    0x806020,%eax
  802082:	8b 40 78             	mov    0x78(%eax),%eax
  802085:	29 c2                	sub    %eax,%edx
  802087:	89 d0                	mov    %edx,%eax
  802089:	2d 00 10 00 00       	sub    $0x1000,%eax
  80208e:	c1 e8 0c             	shr    $0xc,%eax
  802091:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802097:	42                   	inc    %edx
  802098:	89 15 24 60 80 00    	mov    %edx,0x806024
  80209e:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8020a4:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8020ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8020b3:	8b 40 78             	mov    0x78(%eax),%eax
  8020b6:	29 c2                	sub    %eax,%edx
  8020b8:	89 d0                	mov    %edx,%eax
  8020ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020bf:	c1 e8 0c             	shr    $0xc,%eax
  8020c2:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  8020c9:	a1 20 60 80 00       	mov    0x806020,%eax
  8020ce:	8b 50 10             	mov    0x10(%eax),%edx
  8020d1:	89 c8                	mov    %ecx,%eax
  8020d3:	c1 e0 02             	shl    $0x2,%eax
  8020d6:	89 c1                	mov    %eax,%ecx
  8020d8:	c1 e1 09             	shl    $0x9,%ecx
  8020db:	01 c8                	add    %ecx,%eax
  8020dd:	01 c2                	add    %eax,%edx
  8020df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e2:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  8020e9:	a1 20 60 80 00       	mov    0x806020,%eax
  8020ee:	8b 40 10             	mov    0x10(%eax),%eax
  8020f1:	83 ec 08             	sub    $0x8,%esp
  8020f4:	50                   	push   %eax
  8020f5:	68 b1 4d 80 00       	push   $0x804db1
  8020fa:	e8 22 eb ff ff       	call   800c21 <cprintf>
  8020ff:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802102:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802106:	75 07                	jne    80210f <sget+0x10e>
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	eb 03                	jmp    802112 <sget+0x111>
	return ptr;
  80210f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80211a:	8b 55 08             	mov    0x8(%ebp),%edx
  80211d:	a1 20 60 80 00       	mov    0x806020,%eax
  802122:	8b 40 78             	mov    0x78(%eax),%eax
  802125:	29 c2                	sub    %eax,%edx
  802127:	89 d0                	mov    %edx,%eax
  802129:	2d 00 10 00 00       	sub    $0x1000,%eax
  80212e:	c1 e8 0c             	shr    $0xc,%eax
  802131:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802138:	a1 20 60 80 00       	mov    0x806020,%eax
  80213d:	8b 50 10             	mov    0x10(%eax),%edx
  802140:	89 c8                	mov    %ecx,%eax
  802142:	c1 e0 02             	shl    $0x2,%eax
  802145:	89 c1                	mov    %eax,%ecx
  802147:	c1 e1 09             	shl    $0x9,%ecx
  80214a:	01 c8                	add    %ecx,%eax
  80214c:	01 d0                	add    %edx,%eax
  80214e:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802155:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802158:	83 ec 08             	sub    $0x8,%esp
  80215b:	ff 75 08             	pushl  0x8(%ebp)
  80215e:	ff 75 f4             	pushl  -0xc(%ebp)
  802161:	e8 db 02 00 00       	call   802441 <sys_freeSharedObject>
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80216c:	90                   	nop
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 c0 4d 80 00       	push   $0x804dc0
  80217d:	68 e5 00 00 00       	push   $0xe5
  802182:	68 96 4d 80 00       	push   $0x804d96
  802187:	e8 19 21 00 00       	call   8042a5 <_panic>

0080218c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	68 e6 4d 80 00       	push   $0x804de6
  80219a:	68 f1 00 00 00       	push   $0xf1
  80219f:	68 96 4d 80 00       	push   $0x804d96
  8021a4:	e8 fc 20 00 00       	call   8042a5 <_panic>

008021a9 <shrink>:

}
void shrink(uint32 newSize)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 e6 4d 80 00       	push   $0x804de6
  8021b7:	68 f6 00 00 00       	push   $0xf6
  8021bc:	68 96 4d 80 00       	push   $0x804d96
  8021c1:	e8 df 20 00 00       	call   8042a5 <_panic>

008021c6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 e6 4d 80 00       	push   $0x804de6
  8021d4:	68 fb 00 00 00       	push   $0xfb
  8021d9:	68 96 4d 80 00       	push   $0x804d96
  8021de:	e8 c2 20 00 00       	call   8042a5 <_panic>

008021e3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	57                   	push   %edi
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021fb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021fe:	cd 30                	int    $0x30
  802200:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802203:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	5b                   	pop    %ebx
  80220a:	5e                   	pop    %esi
  80220b:	5f                   	pop    %edi
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    

0080220e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 04             	sub    $0x4,%esp
  802214:	8b 45 10             	mov    0x10(%ebp),%eax
  802217:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80221a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	52                   	push   %edx
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	50                   	push   %eax
  80222a:	6a 00                	push   $0x0
  80222c:	e8 b2 ff ff ff       	call   8021e3 <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
}
  802234:	90                   	nop
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_cgetc>:

int
sys_cgetc(void)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 02                	push   $0x2
  802246:	e8 98 ff ff ff       	call   8021e3 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 03                	push   $0x3
  80225f:	e8 7f ff ff ff       	call   8021e3 <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	90                   	nop
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 04                	push   $0x4
  802279:	e8 65 ff ff ff       	call   8021e3 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	90                   	nop
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	52                   	push   %edx
  802294:	50                   	push   %eax
  802295:	6a 08                	push   $0x8
  802297:	e8 47 ff ff ff       	call   8021e3 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	56                   	push   %esi
  8022a5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8022a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	56                   	push   %esi
  8022b6:	53                   	push   %ebx
  8022b7:	51                   	push   %ecx
  8022b8:	52                   	push   %edx
  8022b9:	50                   	push   %eax
  8022ba:	6a 09                	push   $0x9
  8022bc:	e8 22 ff ff ff       	call   8021e3 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c7:	5b                   	pop    %ebx
  8022c8:	5e                   	pop    %esi
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    

008022cb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	6a 0a                	push   $0xa
  8022de:	e8 00 ff ff ff       	call   8021e3 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 0b                	push   $0xb
  8022f9:	e8 e5 fe ff ff       	call   8021e3 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 0c                	push   $0xc
  802312:	e8 cc fe ff ff       	call   8021e3 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 0d                	push   $0xd
  80232b:	e8 b3 fe ff ff       	call   8021e3 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 0e                	push   $0xe
  802344:	e8 9a fe ff ff       	call   8021e3 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 0f                	push   $0xf
  80235d:	e8 81 fe ff ff       	call   8021e3 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	ff 75 08             	pushl  0x8(%ebp)
  802375:	6a 10                	push   $0x10
  802377:	e8 67 fe ff ff       	call   8021e3 <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 11                	push   $0x11
  802390:	e8 4e fe ff ff       	call   8021e3 <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	90                   	nop
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_cputc>:

void
sys_cputc(const char c)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 04             	sub    $0x4,%esp
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	50                   	push   %eax
  8023b4:	6a 01                	push   $0x1
  8023b6:	e8 28 fe ff ff       	call   8021e3 <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
}
  8023be:	90                   	nop
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 14                	push   $0x14
  8023d0:	e8 0e fe ff ff       	call   8021e3 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
}
  8023d8:	90                   	nop
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	6a 00                	push   $0x0
  8023f3:	51                   	push   %ecx
  8023f4:	52                   	push   %edx
  8023f5:	ff 75 0c             	pushl  0xc(%ebp)
  8023f8:	50                   	push   %eax
  8023f9:	6a 15                	push   $0x15
  8023fb:	e8 e3 fd ff ff       	call   8021e3 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	52                   	push   %edx
  802415:	50                   	push   %eax
  802416:	6a 16                	push   $0x16
  802418:	e8 c6 fd ff ff       	call   8021e3 <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802425:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	51                   	push   %ecx
  802433:	52                   	push   %edx
  802434:	50                   	push   %eax
  802435:	6a 17                	push   $0x17
  802437:	e8 a7 fd ff ff       	call   8021e3 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802444:	8b 55 0c             	mov    0xc(%ebp),%edx
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	52                   	push   %edx
  802451:	50                   	push   %eax
  802452:	6a 18                	push   $0x18
  802454:	e8 8a fd ff ff       	call   8021e3 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	ff 75 14             	pushl  0x14(%ebp)
  802469:	ff 75 10             	pushl  0x10(%ebp)
  80246c:	ff 75 0c             	pushl  0xc(%ebp)
  80246f:	50                   	push   %eax
  802470:	6a 19                	push   $0x19
  802472:	e8 6c fd ff ff       	call   8021e3 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	50                   	push   %eax
  80248b:	6a 1a                	push   $0x1a
  80248d:	e8 51 fd ff ff       	call   8021e3 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	50                   	push   %eax
  8024a7:	6a 1b                	push   $0x1b
  8024a9:	e8 35 fd ff ff       	call   8021e3 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 05                	push   $0x5
  8024c2:	e8 1c fd ff ff       	call   8021e3 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 06                	push   $0x6
  8024db:	e8 03 fd ff ff       	call   8021e3 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 07                	push   $0x7
  8024f4:	e8 ea fc ff ff       	call   8021e3 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <sys_exit_env>:


void sys_exit_env(void)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 1c                	push   $0x1c
  80250d:	e8 d1 fc ff ff       	call   8021e3 <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
}
  802515:	90                   	nop
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80251e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802521:	8d 50 04             	lea    0x4(%eax),%edx
  802524:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	52                   	push   %edx
  80252e:	50                   	push   %eax
  80252f:	6a 1d                	push   $0x1d
  802531:	e8 ad fc ff ff       	call   8021e3 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
	return result;
  802539:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80253c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80253f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802542:	89 01                	mov    %eax,(%ecx)
  802544:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	c9                   	leave  
  80254b:	c2 04 00             	ret    $0x4

0080254e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	ff 75 10             	pushl  0x10(%ebp)
  802558:	ff 75 0c             	pushl  0xc(%ebp)
  80255b:	ff 75 08             	pushl  0x8(%ebp)
  80255e:	6a 13                	push   $0x13
  802560:	e8 7e fc ff ff       	call   8021e3 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
	return ;
  802568:	90                   	nop
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <sys_rcr2>:
uint32 sys_rcr2()
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 1e                	push   $0x1e
  80257a:	e8 64 fc ff ff       	call   8021e3 <syscall>
  80257f:	83 c4 18             	add    $0x18,%esp
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802590:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	50                   	push   %eax
  80259d:	6a 1f                	push   $0x1f
  80259f:	e8 3f fc ff ff       	call   8021e3 <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a7:	90                   	nop
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <rsttst>:
void rsttst()
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 21                	push   $0x21
  8025b9:	e8 25 fc ff ff       	call   8021e3 <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c1:	90                   	nop
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8025cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025d0:	8b 55 18             	mov    0x18(%ebp),%edx
  8025d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025d7:	52                   	push   %edx
  8025d8:	50                   	push   %eax
  8025d9:	ff 75 10             	pushl  0x10(%ebp)
  8025dc:	ff 75 0c             	pushl  0xc(%ebp)
  8025df:	ff 75 08             	pushl  0x8(%ebp)
  8025e2:	6a 20                	push   $0x20
  8025e4:	e8 fa fb ff ff       	call   8021e3 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ec:	90                   	nop
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <chktst>:
void chktst(uint32 n)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	ff 75 08             	pushl  0x8(%ebp)
  8025fd:	6a 22                	push   $0x22
  8025ff:	e8 df fb ff ff       	call   8021e3 <syscall>
  802604:	83 c4 18             	add    $0x18,%esp
	return ;
  802607:	90                   	nop
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <inctst>:

void inctst()
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 23                	push   $0x23
  802619:	e8 c5 fb ff ff       	call   8021e3 <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
	return ;
  802621:	90                   	nop
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <gettst>:
uint32 gettst()
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 24                	push   $0x24
  802633:	e8 ab fb ff ff       	call   8021e3 <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 25                	push   $0x25
  80264f:	e8 8f fb ff ff       	call   8021e3 <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
  802657:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80265a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80265e:	75 07                	jne    802667 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802660:	b8 01 00 00 00       	mov    $0x1,%eax
  802665:	eb 05                	jmp    80266c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 25                	push   $0x25
  802680:	e8 5e fb ff ff       	call   8021e3 <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
  802688:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80268b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80268f:	75 07                	jne    802698 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802691:	b8 01 00 00 00       	mov    $0x1,%eax
  802696:	eb 05                	jmp    80269d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 25                	push   $0x25
  8026b1:	e8 2d fb ff ff       	call   8021e3 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
  8026b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026bc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026c0:	75 07                	jne    8026c9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c7:	eb 05                	jmp    8026ce <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 25                	push   $0x25
  8026e2:	e8 fc fa ff ff       	call   8021e3 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
  8026ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026ed:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026f1:	75 07                	jne    8026fa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f8:	eb 05                	jmp    8026ff <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	ff 75 08             	pushl  0x8(%ebp)
  80270f:	6a 26                	push   $0x26
  802711:	e8 cd fa ff ff       	call   8021e3 <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
	return ;
  802719:	90                   	nop
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802720:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802723:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802726:	8b 55 0c             	mov    0xc(%ebp),%edx
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	6a 00                	push   $0x0
  80272e:	53                   	push   %ebx
  80272f:	51                   	push   %ecx
  802730:	52                   	push   %edx
  802731:	50                   	push   %eax
  802732:	6a 27                	push   $0x27
  802734:	e8 aa fa ff ff       	call   8021e3 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802744:	8b 55 0c             	mov    0xc(%ebp),%edx
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	52                   	push   %edx
  802751:	50                   	push   %eax
  802752:	6a 28                	push   $0x28
  802754:	e8 8a fa ff ff       	call   8021e3 <syscall>
  802759:	83 c4 18             	add    $0x18,%esp
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802761:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802764:	8b 55 0c             	mov    0xc(%ebp),%edx
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	6a 00                	push   $0x0
  80276c:	51                   	push   %ecx
  80276d:	ff 75 10             	pushl  0x10(%ebp)
  802770:	52                   	push   %edx
  802771:	50                   	push   %eax
  802772:	6a 29                	push   $0x29
  802774:	e8 6a fa ff ff       	call   8021e3 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	ff 75 10             	pushl  0x10(%ebp)
  802788:	ff 75 0c             	pushl  0xc(%ebp)
  80278b:	ff 75 08             	pushl  0x8(%ebp)
  80278e:	6a 12                	push   $0x12
  802790:	e8 4e fa ff ff       	call   8021e3 <syscall>
  802795:	83 c4 18             	add    $0x18,%esp
	return ;
  802798:	90                   	nop
}
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80279e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	52                   	push   %edx
  8027ab:	50                   	push   %eax
  8027ac:	6a 2a                	push   $0x2a
  8027ae:	e8 30 fa ff ff       	call   8021e3 <syscall>
  8027b3:	83 c4 18             	add    $0x18,%esp
	return;
  8027b6:	90                   	nop
}
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	50                   	push   %eax
  8027c8:	6a 2b                	push   $0x2b
  8027ca:	e8 14 fa ff ff       	call   8021e3 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	ff 75 0c             	pushl  0xc(%ebp)
  8027e0:	ff 75 08             	pushl  0x8(%ebp)
  8027e3:	6a 2c                	push   $0x2c
  8027e5:	e8 f9 f9 ff ff       	call   8021e3 <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
	return;
  8027ed:	90                   	nop
}
  8027ee:	c9                   	leave  
  8027ef:	c3                   	ret    

008027f0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	ff 75 0c             	pushl  0xc(%ebp)
  8027fc:	ff 75 08             	pushl  0x8(%ebp)
  8027ff:	6a 2d                	push   $0x2d
  802801:	e8 dd f9 ff ff       	call   8021e3 <syscall>
  802806:	83 c4 18             	add    $0x18,%esp
	return;
  802809:	90                   	nop
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	83 e8 04             	sub    $0x4,%eax
  802818:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80281b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	83 e8 04             	sub    $0x4,%eax
  802831:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802834:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	83 e0 01             	and    $0x1,%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	0f 94 c0             	sete   %al
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802850:	8b 45 0c             	mov    0xc(%ebp),%eax
  802853:	83 f8 02             	cmp    $0x2,%eax
  802856:	74 2b                	je     802883 <alloc_block+0x40>
  802858:	83 f8 02             	cmp    $0x2,%eax
  80285b:	7f 07                	jg     802864 <alloc_block+0x21>
  80285d:	83 f8 01             	cmp    $0x1,%eax
  802860:	74 0e                	je     802870 <alloc_block+0x2d>
  802862:	eb 58                	jmp    8028bc <alloc_block+0x79>
  802864:	83 f8 03             	cmp    $0x3,%eax
  802867:	74 2d                	je     802896 <alloc_block+0x53>
  802869:	83 f8 04             	cmp    $0x4,%eax
  80286c:	74 3b                	je     8028a9 <alloc_block+0x66>
  80286e:	eb 4c                	jmp    8028bc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802870:	83 ec 0c             	sub    $0xc,%esp
  802873:	ff 75 08             	pushl  0x8(%ebp)
  802876:	e8 11 03 00 00       	call   802b8c <alloc_block_FF>
  80287b:	83 c4 10             	add    $0x10,%esp
  80287e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802881:	eb 4a                	jmp    8028cd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802883:	83 ec 0c             	sub    $0xc,%esp
  802886:	ff 75 08             	pushl  0x8(%ebp)
  802889:	e8 fa 19 00 00       	call   804288 <alloc_block_NF>
  80288e:	83 c4 10             	add    $0x10,%esp
  802891:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802894:	eb 37                	jmp    8028cd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802896:	83 ec 0c             	sub    $0xc,%esp
  802899:	ff 75 08             	pushl  0x8(%ebp)
  80289c:	e8 a7 07 00 00       	call   803048 <alloc_block_BF>
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028a7:	eb 24                	jmp    8028cd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8028a9:	83 ec 0c             	sub    $0xc,%esp
  8028ac:	ff 75 08             	pushl  0x8(%ebp)
  8028af:	e8 b7 19 00 00       	call   80426b <alloc_block_WF>
  8028b4:	83 c4 10             	add    $0x10,%esp
  8028b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028ba:	eb 11                	jmp    8028cd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8028bc:	83 ec 0c             	sub    $0xc,%esp
  8028bf:	68 f8 4d 80 00       	push   $0x804df8
  8028c4:	e8 58 e3 ff ff       	call   800c21 <cprintf>
  8028c9:	83 c4 10             	add    $0x10,%esp
		break;
  8028cc:	90                   	nop
	}
	return va;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

008028d2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
  8028d5:	53                   	push   %ebx
  8028d6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8028d9:	83 ec 0c             	sub    $0xc,%esp
  8028dc:	68 18 4e 80 00       	push   $0x804e18
  8028e1:	e8 3b e3 ff ff       	call   800c21 <cprintf>
  8028e6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8028e9:	83 ec 0c             	sub    $0xc,%esp
  8028ec:	68 43 4e 80 00       	push   $0x804e43
  8028f1:	e8 2b e3 ff ff       	call   800c21 <cprintf>
  8028f6:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ff:	eb 37                	jmp    802938 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802901:	83 ec 0c             	sub    $0xc,%esp
  802904:	ff 75 f4             	pushl  -0xc(%ebp)
  802907:	e8 19 ff ff ff       	call   802825 <is_free_block>
  80290c:	83 c4 10             	add    $0x10,%esp
  80290f:	0f be d8             	movsbl %al,%ebx
  802912:	83 ec 0c             	sub    $0xc,%esp
  802915:	ff 75 f4             	pushl  -0xc(%ebp)
  802918:	e8 ef fe ff ff       	call   80280c <get_block_size>
  80291d:	83 c4 10             	add    $0x10,%esp
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	53                   	push   %ebx
  802924:	50                   	push   %eax
  802925:	68 5b 4e 80 00       	push   $0x804e5b
  80292a:	e8 f2 e2 ff ff       	call   800c21 <cprintf>
  80292f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802932:	8b 45 10             	mov    0x10(%ebp),%eax
  802935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293c:	74 07                	je     802945 <print_blocks_list+0x73>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	eb 05                	jmp    80294a <print_blocks_list+0x78>
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	89 45 10             	mov    %eax,0x10(%ebp)
  80294d:	8b 45 10             	mov    0x10(%ebp),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 ad                	jne    802901 <print_blocks_list+0x2f>
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	75 a7                	jne    802901 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80295a:	83 ec 0c             	sub    $0xc,%esp
  80295d:	68 18 4e 80 00       	push   $0x804e18
  802962:	e8 ba e2 ff ff       	call   800c21 <cprintf>
  802967:	83 c4 10             	add    $0x10,%esp

}
  80296a:	90                   	nop
  80296b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802976:	8b 45 0c             	mov    0xc(%ebp),%eax
  802979:	83 e0 01             	and    $0x1,%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 03                	je     802983 <initialize_dynamic_allocator+0x13>
  802980:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802983:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802987:	0f 84 c7 01 00 00    	je     802b54 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80298d:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  802994:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802997:	8b 55 08             	mov    0x8(%ebp),%edx
  80299a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80299d:	01 d0                	add    %edx,%eax
  80299f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8029a4:	0f 87 ad 01 00 00    	ja     802b57 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	0f 89 a5 01 00 00    	jns    802b5a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8029b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029bb:	01 d0                	add    %edx,%eax
  8029bd:	83 e8 04             	sub    $0x4,%eax
  8029c0:	a3 48 60 80 00       	mov    %eax,0x806048
     struct BlockElement * element = NULL;
  8029c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8029cc:	a1 30 60 80 00       	mov    0x806030,%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d4:	e9 87 00 00 00       	jmp    802a60 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dd:	75 14                	jne    8029f3 <initialize_dynamic_allocator+0x83>
  8029df:	83 ec 04             	sub    $0x4,%esp
  8029e2:	68 73 4e 80 00       	push   $0x804e73
  8029e7:	6a 79                	push   $0x79
  8029e9:	68 91 4e 80 00       	push   $0x804e91
  8029ee:	e8 b2 18 00 00       	call   8042a5 <_panic>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	74 10                	je     802a0c <initialize_dynamic_allocator+0x9c>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a04:	8b 52 04             	mov    0x4(%edx),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	eb 0b                	jmp    802a17 <initialize_dynamic_allocator+0xa7>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 04             	mov    0x4(%eax),%eax
  802a12:	a3 34 60 80 00       	mov    %eax,0x806034
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 04             	mov    0x4(%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 0f                	je     802a30 <initialize_dynamic_allocator+0xc0>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2a:	8b 12                	mov    (%edx),%edx
  802a2c:	89 10                	mov    %edx,(%eax)
  802a2e:	eb 0a                	jmp    802a3a <initialize_dynamic_allocator+0xca>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	a3 30 60 80 00       	mov    %eax,0x806030
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4d:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802a52:	48                   	dec    %eax
  802a53:	a3 3c 60 80 00       	mov    %eax,0x80603c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a58:	a1 38 60 80 00       	mov    0x806038,%eax
  802a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a64:	74 07                	je     802a6d <initialize_dynamic_allocator+0xfd>
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	eb 05                	jmp    802a72 <initialize_dynamic_allocator+0x102>
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a72:	a3 38 60 80 00       	mov    %eax,0x806038
  802a77:	a1 38 60 80 00       	mov    0x806038,%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	0f 85 55 ff ff ff    	jne    8029d9 <initialize_dynamic_allocator+0x69>
  802a84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a88:	0f 85 4b ff ff ff    	jne    8029d9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a9d:	a1 48 60 80 00       	mov    0x806048,%eax
  802aa2:	a3 44 60 80 00       	mov    %eax,0x806044
    end_block->info = 1;
  802aa7:	a1 44 60 80 00       	mov    0x806044,%eax
  802aac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	83 c0 08             	add    $0x8,%eax
  802ab8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	83 c0 04             	add    $0x4,%eax
  802ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac4:	83 ea 08             	sub    $0x8,%edx
  802ac7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	01 d0                	add    %edx,%eax
  802ad1:	83 e8 08             	sub    $0x8,%eax
  802ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad7:	83 ea 08             	sub    $0x8,%edx
  802ada:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802aef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af3:	75 17                	jne    802b0c <initialize_dynamic_allocator+0x19c>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 ac 4e 80 00       	push   $0x804eac
  802afd:	68 90 00 00 00       	push   $0x90
  802b02:	68 91 4e 80 00       	push   $0x804e91
  802b07:	e8 99 17 00 00       	call   8042a5 <_panic>
  802b0c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 0d                	je     802b2d <initialize_dynamic_allocator+0x1bd>
  802b20:	a1 30 60 80 00       	mov    0x806030,%eax
  802b25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%eax)
  802b2b:	eb 08                	jmp    802b35 <initialize_dynamic_allocator+0x1c5>
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	a3 34 60 80 00       	mov    %eax,0x806034
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	a3 30 60 80 00       	mov    %eax,0x806030
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b47:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802b4c:	40                   	inc    %eax
  802b4d:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802b52:	eb 07                	jmp    802b5b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b54:	90                   	nop
  802b55:	eb 04                	jmp    802b5b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b57:	90                   	nop
  802b58:	eb 01                	jmp    802b5b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b5a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    

00802b5d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b5d:	55                   	push   %ebp
  802b5e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b60:	8b 45 10             	mov    0x10(%ebp),%eax
  802b63:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b6f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	83 e8 04             	sub    $0x4,%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	83 e0 fe             	and    $0xfffffffe,%eax
  802b7c:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	01 c2                	add    %eax,%edx
  802b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b87:	89 02                	mov    %eax,(%edx)
}
  802b89:	90                   	nop
  802b8a:	5d                   	pop    %ebp
  802b8b:	c3                   	ret    

00802b8c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b8c:	55                   	push   %ebp
  802b8d:	89 e5                	mov    %esp,%ebp
  802b8f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	83 e0 01             	and    $0x1,%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 03                	je     802b9f <alloc_block_FF+0x13>
  802b9c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b9f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ba3:	77 07                	ja     802bac <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ba5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bac:	a1 28 60 80 00       	mov    0x806028,%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	75 73                	jne    802c28 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	83 c0 10             	add    $0x10,%eax
  802bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802bbe:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802bc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcb:	01 d0                	add    %edx,%eax
  802bcd:	48                   	dec    %eax
  802bce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd9:	f7 75 ec             	divl   -0x14(%ebp)
  802bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdf:	29 d0                	sub    %edx,%eax
  802be1:	c1 e8 0c             	shr    $0xc,%eax
  802be4:	83 ec 0c             	sub    $0xc,%esp
  802be7:	50                   	push   %eax
  802be8:	e8 d6 ef ff ff       	call   801bc3 <sbrk>
  802bed:	83 c4 10             	add    $0x10,%esp
  802bf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bf3:	83 ec 0c             	sub    $0xc,%esp
  802bf6:	6a 00                	push   $0x0
  802bf8:	e8 c6 ef ff ff       	call   801bc3 <sbrk>
  802bfd:	83 c4 10             	add    $0x10,%esp
  802c00:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c06:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c09:	83 ec 08             	sub    $0x8,%esp
  802c0c:	50                   	push   %eax
  802c0d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c10:	e8 5b fd ff ff       	call   802970 <initialize_dynamic_allocator>
  802c15:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c18:	83 ec 0c             	sub    $0xc,%esp
  802c1b:	68 cf 4e 80 00       	push   $0x804ecf
  802c20:	e8 fc df ff ff       	call   800c21 <cprintf>
  802c25:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2c:	75 0a                	jne    802c38 <alloc_block_FF+0xac>
	        return NULL;
  802c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c33:	e9 0e 04 00 00       	jmp    803046 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c3f:	a1 30 60 80 00       	mov    0x806030,%eax
  802c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c47:	e9 f3 02 00 00       	jmp    802f3f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c52:	83 ec 0c             	sub    $0xc,%esp
  802c55:	ff 75 bc             	pushl  -0x44(%ebp)
  802c58:	e8 af fb ff ff       	call   80280c <get_block_size>
  802c5d:	83 c4 10             	add    $0x10,%esp
  802c60:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	83 c0 08             	add    $0x8,%eax
  802c69:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c6c:	0f 87 c5 02 00 00    	ja     802f37 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	83 c0 18             	add    $0x18,%eax
  802c78:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c7b:	0f 87 19 02 00 00    	ja     802e9a <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802c81:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c84:	2b 45 08             	sub    0x8(%ebp),%eax
  802c87:	83 e8 08             	sub    $0x8,%eax
  802c8a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8d 50 08             	lea    0x8(%eax),%edx
  802c93:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c96:	01 d0                	add    %edx,%eax
  802c98:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	83 c0 08             	add    $0x8,%eax
  802ca1:	83 ec 04             	sub    $0x4,%esp
  802ca4:	6a 01                	push   $0x1
  802ca6:	50                   	push   %eax
  802ca7:	ff 75 bc             	pushl  -0x44(%ebp)
  802caa:	e8 ae fe ff ff       	call   802b5d <set_block_data>
  802caf:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	75 68                	jne    802d24 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cbc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cc0:	75 17                	jne    802cd9 <alloc_block_FF+0x14d>
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	68 ac 4e 80 00       	push   $0x804eac
  802cca:	68 d7 00 00 00       	push   $0xd7
  802ccf:	68 91 4e 80 00       	push   $0x804e91
  802cd4:	e8 cc 15 00 00       	call   8042a5 <_panic>
  802cd9:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802cdf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0d                	je     802cfa <alloc_block_FF+0x16e>
  802ced:	a1 30 60 80 00       	mov    0x806030,%eax
  802cf2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cf5:	89 50 04             	mov    %edx,0x4(%eax)
  802cf8:	eb 08                	jmp    802d02 <alloc_block_FF+0x176>
  802cfa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cfd:	a3 34 60 80 00       	mov    %eax,0x806034
  802d02:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d05:	a3 30 60 80 00       	mov    %eax,0x806030
  802d0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d14:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802d19:	40                   	inc    %eax
  802d1a:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802d1f:	e9 dc 00 00 00       	jmp    802e00 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	75 65                	jne    802d92 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d2d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d31:	75 17                	jne    802d4a <alloc_block_FF+0x1be>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 e0 4e 80 00       	push   $0x804ee0
  802d3b:	68 db 00 00 00       	push   $0xdb
  802d40:	68 91 4e 80 00       	push   $0x804e91
  802d45:	e8 5b 15 00 00       	call   8042a5 <_panic>
  802d4a:	8b 15 34 60 80 00    	mov    0x806034,%edx
  802d50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0c                	je     802d6c <alloc_block_FF+0x1e0>
  802d60:	a1 34 60 80 00       	mov    0x806034,%eax
  802d65:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d68:	89 10                	mov    %edx,(%eax)
  802d6a:	eb 08                	jmp    802d74 <alloc_block_FF+0x1e8>
  802d6c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d6f:	a3 30 60 80 00       	mov    %eax,0x806030
  802d74:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d77:	a3 34 60 80 00       	mov    %eax,0x806034
  802d7c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d85:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802d8a:	40                   	inc    %eax
  802d8b:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802d90:	eb 6e                	jmp    802e00 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d96:	74 06                	je     802d9e <alloc_block_FF+0x212>
  802d98:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d9c:	75 17                	jne    802db5 <alloc_block_FF+0x229>
  802d9e:	83 ec 04             	sub    $0x4,%esp
  802da1:	68 04 4f 80 00       	push   $0x804f04
  802da6:	68 df 00 00 00       	push   $0xdf
  802dab:	68 91 4e 80 00       	push   $0x804e91
  802db0:	e8 f0 14 00 00       	call   8042a5 <_panic>
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 10                	mov    (%eax),%edx
  802dba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dbd:	89 10                	mov    %edx,(%eax)
  802dbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 0b                	je     802dd3 <alloc_block_FF+0x247>
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802dd0:	89 50 04             	mov    %edx,0x4(%eax)
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802dd9:	89 10                	mov    %edx,(%eax)
  802ddb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	85 c0                	test   %eax,%eax
  802deb:	75 08                	jne    802df5 <alloc_block_FF+0x269>
  802ded:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802df0:	a3 34 60 80 00       	mov    %eax,0x806034
  802df5:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802dfa:	40                   	inc    %eax
  802dfb:	a3 3c 60 80 00       	mov    %eax,0x80603c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e04:	75 17                	jne    802e1d <alloc_block_FF+0x291>
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	68 73 4e 80 00       	push   $0x804e73
  802e0e:	68 e1 00 00 00       	push   $0xe1
  802e13:	68 91 4e 80 00       	push   $0x804e91
  802e18:	e8 88 14 00 00       	call   8042a5 <_panic>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	74 10                	je     802e36 <alloc_block_FF+0x2aa>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2e:	8b 52 04             	mov    0x4(%edx),%edx
  802e31:	89 50 04             	mov    %edx,0x4(%eax)
  802e34:	eb 0b                	jmp    802e41 <alloc_block_FF+0x2b5>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 40 04             	mov    0x4(%eax),%eax
  802e3c:	a3 34 60 80 00       	mov    %eax,0x806034
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 40 04             	mov    0x4(%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 0f                	je     802e5a <alloc_block_FF+0x2ce>
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e54:	8b 12                	mov    (%edx),%edx
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	eb 0a                	jmp    802e64 <alloc_block_FF+0x2d8>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	a3 30 60 80 00       	mov    %eax,0x806030
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802e7c:	48                   	dec    %eax
  802e7d:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(new_block_va, remaining_size, 0);
  802e82:	83 ec 04             	sub    $0x4,%esp
  802e85:	6a 00                	push   $0x0
  802e87:	ff 75 b4             	pushl  -0x4c(%ebp)
  802e8a:	ff 75 b0             	pushl  -0x50(%ebp)
  802e8d:	e8 cb fc ff ff       	call   802b5d <set_block_data>
  802e92:	83 c4 10             	add    $0x10,%esp
  802e95:	e9 95 00 00 00       	jmp    802f2f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	6a 01                	push   $0x1
  802e9f:	ff 75 b8             	pushl  -0x48(%ebp)
  802ea2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ea5:	e8 b3 fc ff ff       	call   802b5d <set_block_data>
  802eaa:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	75 17                	jne    802eca <alloc_block_FF+0x33e>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 73 4e 80 00       	push   $0x804e73
  802ebb:	68 e8 00 00 00       	push   $0xe8
  802ec0:	68 91 4e 80 00       	push   $0x804e91
  802ec5:	e8 db 13 00 00       	call   8042a5 <_panic>
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 10                	je     802ee3 <alloc_block_FF+0x357>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edb:	8b 52 04             	mov    0x4(%edx),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	eb 0b                	jmp    802eee <alloc_block_FF+0x362>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	a3 34 60 80 00       	mov    %eax,0x806034
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0f                	je     802f07 <alloc_block_FF+0x37b>
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f01:	8b 12                	mov    (%edx),%edx
  802f03:	89 10                	mov    %edx,(%eax)
  802f05:	eb 0a                	jmp    802f11 <alloc_block_FF+0x385>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	a3 30 60 80 00       	mov    %eax,0x806030
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802f29:	48                   	dec    %eax
  802f2a:	a3 3c 60 80 00       	mov    %eax,0x80603c
	            }
	            return va;
  802f2f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f32:	e9 0f 01 00 00       	jmp    803046 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f37:	a1 38 60 80 00       	mov    0x806038,%eax
  802f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f43:	74 07                	je     802f4c <alloc_block_FF+0x3c0>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	eb 05                	jmp    802f51 <alloc_block_FF+0x3c5>
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	a3 38 60 80 00       	mov    %eax,0x806038
  802f56:	a1 38 60 80 00       	mov    0x806038,%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	0f 85 e9 fc ff ff    	jne    802c4c <alloc_block_FF+0xc0>
  802f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f67:	0f 85 df fc ff ff    	jne    802c4c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	83 c0 08             	add    $0x8,%eax
  802f73:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f76:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f83:	01 d0                	add    %edx,%eax
  802f85:	48                   	dec    %eax
  802f86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f91:	f7 75 d8             	divl   -0x28(%ebp)
  802f94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f97:	29 d0                	sub    %edx,%eax
  802f99:	c1 e8 0c             	shr    $0xc,%eax
  802f9c:	83 ec 0c             	sub    $0xc,%esp
  802f9f:	50                   	push   %eax
  802fa0:	e8 1e ec ff ff       	call   801bc3 <sbrk>
  802fa5:	83 c4 10             	add    $0x10,%esp
  802fa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802fab:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802faf:	75 0a                	jne    802fbb <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb6:	e9 8b 00 00 00       	jmp    803046 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802fbb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802fc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc8:	01 d0                	add    %edx,%eax
  802fca:	48                   	dec    %eax
  802fcb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802fce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd6:	f7 75 cc             	divl   -0x34(%ebp)
  802fd9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fdc:	29 d0                	sub    %edx,%eax
  802fde:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fe1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fe4:	01 d0                	add    %edx,%eax
  802fe6:	a3 44 60 80 00       	mov    %eax,0x806044
			end_block->info = 1;
  802feb:	a1 44 60 80 00       	mov    0x806044,%eax
  802ff0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ff6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ffd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803000:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803003:	01 d0                	add    %edx,%eax
  803005:	48                   	dec    %eax
  803006:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803009:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80300c:	ba 00 00 00 00       	mov    $0x0,%edx
  803011:	f7 75 c4             	divl   -0x3c(%ebp)
  803014:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803017:	29 d0                	sub    %edx,%eax
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	6a 01                	push   $0x1
  80301e:	50                   	push   %eax
  80301f:	ff 75 d0             	pushl  -0x30(%ebp)
  803022:	e8 36 fb ff ff       	call   802b5d <set_block_data>
  803027:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80302a:	83 ec 0c             	sub    $0xc,%esp
  80302d:	ff 75 d0             	pushl  -0x30(%ebp)
  803030:	e8 1b 0a 00 00       	call   803a50 <free_block>
  803035:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803038:	83 ec 0c             	sub    $0xc,%esp
  80303b:	ff 75 08             	pushl  0x8(%ebp)
  80303e:	e8 49 fb ff ff       	call   802b8c <alloc_block_FF>
  803043:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803046:	c9                   	leave  
  803047:	c3                   	ret    

00803048 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803048:	55                   	push   %ebp
  803049:	89 e5                	mov    %esp,%ebp
  80304b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	83 e0 01             	and    $0x1,%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 03                	je     80305b <alloc_block_BF+0x13>
  803058:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80305b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80305f:	77 07                	ja     803068 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803061:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803068:	a1 28 60 80 00       	mov    0x806028,%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	75 73                	jne    8030e4 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	83 c0 10             	add    $0x10,%eax
  803077:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80307a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803081:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803087:	01 d0                	add    %edx,%eax
  803089:	48                   	dec    %eax
  80308a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80308d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803090:	ba 00 00 00 00       	mov    $0x0,%edx
  803095:	f7 75 e0             	divl   -0x20(%ebp)
  803098:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309b:	29 d0                	sub    %edx,%eax
  80309d:	c1 e8 0c             	shr    $0xc,%eax
  8030a0:	83 ec 0c             	sub    $0xc,%esp
  8030a3:	50                   	push   %eax
  8030a4:	e8 1a eb ff ff       	call   801bc3 <sbrk>
  8030a9:	83 c4 10             	add    $0x10,%esp
  8030ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8030af:	83 ec 0c             	sub    $0xc,%esp
  8030b2:	6a 00                	push   $0x0
  8030b4:	e8 0a eb ff ff       	call   801bc3 <sbrk>
  8030b9:	83 c4 10             	add    $0x10,%esp
  8030bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8030bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030c2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8030c5:	83 ec 08             	sub    $0x8,%esp
  8030c8:	50                   	push   %eax
  8030c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8030cc:	e8 9f f8 ff ff       	call   802970 <initialize_dynamic_allocator>
  8030d1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8030d4:	83 ec 0c             	sub    $0xc,%esp
  8030d7:	68 cf 4e 80 00       	push   $0x804ecf
  8030dc:	e8 40 db ff ff       	call   800c21 <cprintf>
  8030e1:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8030e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8030eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8030f2:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8030f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803100:	a1 30 60 80 00       	mov    0x806030,%eax
  803105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803108:	e9 1d 01 00 00       	jmp    80322a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803113:	83 ec 0c             	sub    $0xc,%esp
  803116:	ff 75 a8             	pushl  -0x58(%ebp)
  803119:	e8 ee f6 ff ff       	call   80280c <get_block_size>
  80311e:	83 c4 10             	add    $0x10,%esp
  803121:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	83 c0 08             	add    $0x8,%eax
  80312a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80312d:	0f 87 ef 00 00 00    	ja     803222 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	83 c0 18             	add    $0x18,%eax
  803139:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80313c:	77 1d                	ja     80315b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80313e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803141:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803144:	0f 86 d8 00 00 00    	jbe    803222 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80314a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80314d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803150:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803153:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803156:	e9 c7 00 00 00       	jmp    803222 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	83 c0 08             	add    $0x8,%eax
  803161:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803164:	0f 85 9d 00 00 00    	jne    803207 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80316a:	83 ec 04             	sub    $0x4,%esp
  80316d:	6a 01                	push   $0x1
  80316f:	ff 75 a4             	pushl  -0x5c(%ebp)
  803172:	ff 75 a8             	pushl  -0x58(%ebp)
  803175:	e8 e3 f9 ff ff       	call   802b5d <set_block_data>
  80317a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80317d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803181:	75 17                	jne    80319a <alloc_block_BF+0x152>
  803183:	83 ec 04             	sub    $0x4,%esp
  803186:	68 73 4e 80 00       	push   $0x804e73
  80318b:	68 2c 01 00 00       	push   $0x12c
  803190:	68 91 4e 80 00       	push   $0x804e91
  803195:	e8 0b 11 00 00       	call   8042a5 <_panic>
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 10                	je     8031b3 <alloc_block_BF+0x16b>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ab:	8b 52 04             	mov    0x4(%edx),%edx
  8031ae:	89 50 04             	mov    %edx,0x4(%eax)
  8031b1:	eb 0b                	jmp    8031be <alloc_block_BF+0x176>
  8031b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b6:	8b 40 04             	mov    0x4(%eax),%eax
  8031b9:	a3 34 60 80 00       	mov    %eax,0x806034
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	74 0f                	je     8031d7 <alloc_block_BF+0x18f>
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d1:	8b 12                	mov    (%edx),%edx
  8031d3:	89 10                	mov    %edx,(%eax)
  8031d5:	eb 0a                	jmp    8031e1 <alloc_block_BF+0x199>
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	a3 30 60 80 00       	mov    %eax,0x806030
  8031e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8031f9:	48                   	dec    %eax
  8031fa:	a3 3c 60 80 00       	mov    %eax,0x80603c
					return va;
  8031ff:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803202:	e9 24 04 00 00       	jmp    80362b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80320d:	76 13                	jbe    803222 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80320f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803216:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803219:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80321c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80321f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803222:	a1 38 60 80 00       	mov    0x806038,%eax
  803227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322e:	74 07                	je     803237 <alloc_block_BF+0x1ef>
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	eb 05                	jmp    80323c <alloc_block_BF+0x1f4>
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
  80323c:	a3 38 60 80 00       	mov    %eax,0x806038
  803241:	a1 38 60 80 00       	mov    0x806038,%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	0f 85 bf fe ff ff    	jne    80310d <alloc_block_BF+0xc5>
  80324e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803252:	0f 85 b5 fe ff ff    	jne    80310d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80325c:	0f 84 26 02 00 00    	je     803488 <alloc_block_BF+0x440>
  803262:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803266:	0f 85 1c 02 00 00    	jne    803488 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80326c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326f:	2b 45 08             	sub    0x8(%ebp),%eax
  803272:	83 e8 08             	sub    $0x8,%eax
  803275:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	8d 50 08             	lea    0x8(%eax),%edx
  80327e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803281:	01 d0                	add    %edx,%eax
  803283:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	83 c0 08             	add    $0x8,%eax
  80328c:	83 ec 04             	sub    $0x4,%esp
  80328f:	6a 01                	push   $0x1
  803291:	50                   	push   %eax
  803292:	ff 75 f0             	pushl  -0x10(%ebp)
  803295:	e8 c3 f8 ff ff       	call   802b5d <set_block_data>
  80329a:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	75 68                	jne    80330f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032ab:	75 17                	jne    8032c4 <alloc_block_BF+0x27c>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 ac 4e 80 00       	push   $0x804eac
  8032b5:	68 45 01 00 00       	push   $0x145
  8032ba:	68 91 4e 80 00       	push   $0x804e91
  8032bf:	e8 e1 0f 00 00       	call   8042a5 <_panic>
  8032c4:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8032ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 0d                	je     8032e5 <alloc_block_BF+0x29d>
  8032d8:	a1 30 60 80 00       	mov    0x806030,%eax
  8032dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032e0:	89 50 04             	mov    %edx,0x4(%eax)
  8032e3:	eb 08                	jmp    8032ed <alloc_block_BF+0x2a5>
  8032e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032e8:	a3 34 60 80 00       	mov    %eax,0x806034
  8032ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f0:	a3 30 60 80 00       	mov    %eax,0x806030
  8032f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ff:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803304:	40                   	inc    %eax
  803305:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80330a:	e9 dc 00 00 00       	jmp    8033eb <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80330f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803312:	8b 00                	mov    (%eax),%eax
  803314:	85 c0                	test   %eax,%eax
  803316:	75 65                	jne    80337d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803318:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80331c:	75 17                	jne    803335 <alloc_block_BF+0x2ed>
  80331e:	83 ec 04             	sub    $0x4,%esp
  803321:	68 e0 4e 80 00       	push   $0x804ee0
  803326:	68 4a 01 00 00       	push   $0x14a
  80332b:	68 91 4e 80 00       	push   $0x804e91
  803330:	e8 70 0f 00 00       	call   8042a5 <_panic>
  803335:	8b 15 34 60 80 00    	mov    0x806034,%edx
  80333b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803344:	8b 40 04             	mov    0x4(%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 0c                	je     803357 <alloc_block_BF+0x30f>
  80334b:	a1 34 60 80 00       	mov    0x806034,%eax
  803350:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803353:	89 10                	mov    %edx,(%eax)
  803355:	eb 08                	jmp    80335f <alloc_block_BF+0x317>
  803357:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80335a:	a3 30 60 80 00       	mov    %eax,0x806030
  80335f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803362:	a3 34 60 80 00       	mov    %eax,0x806034
  803367:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80336a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803370:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803375:	40                   	inc    %eax
  803376:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80337b:	eb 6e                	jmp    8033eb <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80337d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803381:	74 06                	je     803389 <alloc_block_BF+0x341>
  803383:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803387:	75 17                	jne    8033a0 <alloc_block_BF+0x358>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 04 4f 80 00       	push   $0x804f04
  803391:	68 4f 01 00 00       	push   $0x14f
  803396:	68 91 4e 80 00       	push   $0x804e91
  80339b:	e8 05 0f 00 00       	call   8042a5 <_panic>
  8033a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a3:	8b 10                	mov    (%eax),%edx
  8033a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a8:	89 10                	mov    %edx,(%eax)
  8033aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	74 0b                	je     8033be <alloc_block_BF+0x376>
  8033b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033bb:	89 50 04             	mov    %edx,0x4(%eax)
  8033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033c4:	89 10                	mov    %edx,(%eax)
  8033c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	75 08                	jne    8033e0 <alloc_block_BF+0x398>
  8033d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033db:	a3 34 60 80 00       	mov    %eax,0x806034
  8033e0:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8033e5:	40                   	inc    %eax
  8033e6:	a3 3c 60 80 00       	mov    %eax,0x80603c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8033eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ef:	75 17                	jne    803408 <alloc_block_BF+0x3c0>
  8033f1:	83 ec 04             	sub    $0x4,%esp
  8033f4:	68 73 4e 80 00       	push   $0x804e73
  8033f9:	68 51 01 00 00       	push   $0x151
  8033fe:	68 91 4e 80 00       	push   $0x804e91
  803403:	e8 9d 0e 00 00       	call   8042a5 <_panic>
  803408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 10                	je     803421 <alloc_block_BF+0x3d9>
  803411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803419:	8b 52 04             	mov    0x4(%edx),%edx
  80341c:	89 50 04             	mov    %edx,0x4(%eax)
  80341f:	eb 0b                	jmp    80342c <alloc_block_BF+0x3e4>
  803421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803424:	8b 40 04             	mov    0x4(%eax),%eax
  803427:	a3 34 60 80 00       	mov    %eax,0x806034
  80342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342f:	8b 40 04             	mov    0x4(%eax),%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	74 0f                	je     803445 <alloc_block_BF+0x3fd>
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	8b 40 04             	mov    0x4(%eax),%eax
  80343c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80343f:	8b 12                	mov    (%edx),%edx
  803441:	89 10                	mov    %edx,(%eax)
  803443:	eb 0a                	jmp    80344f <alloc_block_BF+0x407>
  803445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	a3 30 60 80 00       	mov    %eax,0x806030
  80344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803452:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803462:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803467:	48                   	dec    %eax
  803468:	a3 3c 60 80 00       	mov    %eax,0x80603c
			set_block_data(new_block_va, remaining_size, 0);
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	6a 00                	push   $0x0
  803472:	ff 75 d0             	pushl  -0x30(%ebp)
  803475:	ff 75 cc             	pushl  -0x34(%ebp)
  803478:	e8 e0 f6 ff ff       	call   802b5d <set_block_data>
  80347d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803483:	e9 a3 01 00 00       	jmp    80362b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803488:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80348c:	0f 85 9d 00 00 00    	jne    80352f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803492:	83 ec 04             	sub    $0x4,%esp
  803495:	6a 01                	push   $0x1
  803497:	ff 75 ec             	pushl  -0x14(%ebp)
  80349a:	ff 75 f0             	pushl  -0x10(%ebp)
  80349d:	e8 bb f6 ff ff       	call   802b5d <set_block_data>
  8034a2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8034a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034a9:	75 17                	jne    8034c2 <alloc_block_BF+0x47a>
  8034ab:	83 ec 04             	sub    $0x4,%esp
  8034ae:	68 73 4e 80 00       	push   $0x804e73
  8034b3:	68 58 01 00 00       	push   $0x158
  8034b8:	68 91 4e 80 00       	push   $0x804e91
  8034bd:	e8 e3 0d 00 00       	call   8042a5 <_panic>
  8034c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 10                	je     8034db <alloc_block_BF+0x493>
  8034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d3:	8b 52 04             	mov    0x4(%edx),%edx
  8034d6:	89 50 04             	mov    %edx,0x4(%eax)
  8034d9:	eb 0b                	jmp    8034e6 <alloc_block_BF+0x49e>
  8034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034de:	8b 40 04             	mov    0x4(%eax),%eax
  8034e1:	a3 34 60 80 00       	mov    %eax,0x806034
  8034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	74 0f                	je     8034ff <alloc_block_BF+0x4b7>
  8034f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f3:	8b 40 04             	mov    0x4(%eax),%eax
  8034f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f9:	8b 12                	mov    (%edx),%edx
  8034fb:	89 10                	mov    %edx,(%eax)
  8034fd:	eb 0a                	jmp    803509 <alloc_block_BF+0x4c1>
  8034ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	a3 30 60 80 00       	mov    %eax,0x806030
  803509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803515:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803521:	48                   	dec    %eax
  803522:	a3 3c 60 80 00       	mov    %eax,0x80603c
		return best_va;
  803527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352a:	e9 fc 00 00 00       	jmp    80362b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	83 c0 08             	add    $0x8,%eax
  803535:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803538:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80353f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803542:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803545:	01 d0                	add    %edx,%eax
  803547:	48                   	dec    %eax
  803548:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80354b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80354e:	ba 00 00 00 00       	mov    $0x0,%edx
  803553:	f7 75 c4             	divl   -0x3c(%ebp)
  803556:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803559:	29 d0                	sub    %edx,%eax
  80355b:	c1 e8 0c             	shr    $0xc,%eax
  80355e:	83 ec 0c             	sub    $0xc,%esp
  803561:	50                   	push   %eax
  803562:	e8 5c e6 ff ff       	call   801bc3 <sbrk>
  803567:	83 c4 10             	add    $0x10,%esp
  80356a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80356d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803571:	75 0a                	jne    80357d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803573:	b8 00 00 00 00       	mov    $0x0,%eax
  803578:	e9 ae 00 00 00       	jmp    80362b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80357d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803584:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80358a:	01 d0                	add    %edx,%eax
  80358c:	48                   	dec    %eax
  80358d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803590:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803593:	ba 00 00 00 00       	mov    $0x0,%edx
  803598:	f7 75 b8             	divl   -0x48(%ebp)
  80359b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80359e:	29 d0                	sub    %edx,%eax
  8035a0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8035a6:	01 d0                	add    %edx,%eax
  8035a8:	a3 44 60 80 00       	mov    %eax,0x806044
				end_block->info = 1;
  8035ad:	a1 44 60 80 00       	mov    0x806044,%eax
  8035b2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8035b8:	83 ec 0c             	sub    $0xc,%esp
  8035bb:	68 38 4f 80 00       	push   $0x804f38
  8035c0:	e8 5c d6 ff ff       	call   800c21 <cprintf>
  8035c5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8035c8:	83 ec 08             	sub    $0x8,%esp
  8035cb:	ff 75 bc             	pushl  -0x44(%ebp)
  8035ce:	68 3d 4f 80 00       	push   $0x804f3d
  8035d3:	e8 49 d6 ff ff       	call   800c21 <cprintf>
  8035d8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8035db:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8035e2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035e8:	01 d0                	add    %edx,%eax
  8035ea:	48                   	dec    %eax
  8035eb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8035ee:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8035f6:	f7 75 b0             	divl   -0x50(%ebp)
  8035f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035fc:	29 d0                	sub    %edx,%eax
  8035fe:	83 ec 04             	sub    $0x4,%esp
  803601:	6a 01                	push   $0x1
  803603:	50                   	push   %eax
  803604:	ff 75 bc             	pushl  -0x44(%ebp)
  803607:	e8 51 f5 ff ff       	call   802b5d <set_block_data>
  80360c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80360f:	83 ec 0c             	sub    $0xc,%esp
  803612:	ff 75 bc             	pushl  -0x44(%ebp)
  803615:	e8 36 04 00 00       	call   803a50 <free_block>
  80361a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80361d:	83 ec 0c             	sub    $0xc,%esp
  803620:	ff 75 08             	pushl  0x8(%ebp)
  803623:	e8 20 fa ff ff       	call   803048 <alloc_block_BF>
  803628:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80362b:	c9                   	leave  
  80362c:	c3                   	ret    

0080362d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80362d:	55                   	push   %ebp
  80362e:	89 e5                	mov    %esp,%ebp
  803630:	53                   	push   %ebx
  803631:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80363b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803646:	74 1e                	je     803666 <merging+0x39>
  803648:	ff 75 08             	pushl  0x8(%ebp)
  80364b:	e8 bc f1 ff ff       	call   80280c <get_block_size>
  803650:	83 c4 04             	add    $0x4,%esp
  803653:	89 c2                	mov    %eax,%edx
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	01 d0                	add    %edx,%eax
  80365a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80365d:	75 07                	jne    803666 <merging+0x39>
		prev_is_free = 1;
  80365f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803666:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80366a:	74 1e                	je     80368a <merging+0x5d>
  80366c:	ff 75 10             	pushl  0x10(%ebp)
  80366f:	e8 98 f1 ff ff       	call   80280c <get_block_size>
  803674:	83 c4 04             	add    $0x4,%esp
  803677:	89 c2                	mov    %eax,%edx
  803679:	8b 45 10             	mov    0x10(%ebp),%eax
  80367c:	01 d0                	add    %edx,%eax
  80367e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803681:	75 07                	jne    80368a <merging+0x5d>
		next_is_free = 1;
  803683:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80368a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368e:	0f 84 cc 00 00 00    	je     803760 <merging+0x133>
  803694:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803698:	0f 84 c2 00 00 00    	je     803760 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80369e:	ff 75 08             	pushl  0x8(%ebp)
  8036a1:	e8 66 f1 ff ff       	call   80280c <get_block_size>
  8036a6:	83 c4 04             	add    $0x4,%esp
  8036a9:	89 c3                	mov    %eax,%ebx
  8036ab:	ff 75 10             	pushl  0x10(%ebp)
  8036ae:	e8 59 f1 ff ff       	call   80280c <get_block_size>
  8036b3:	83 c4 04             	add    $0x4,%esp
  8036b6:	01 c3                	add    %eax,%ebx
  8036b8:	ff 75 0c             	pushl  0xc(%ebp)
  8036bb:	e8 4c f1 ff ff       	call   80280c <get_block_size>
  8036c0:	83 c4 04             	add    $0x4,%esp
  8036c3:	01 d8                	add    %ebx,%eax
  8036c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036c8:	6a 00                	push   $0x0
  8036ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8036cd:	ff 75 08             	pushl  0x8(%ebp)
  8036d0:	e8 88 f4 ff ff       	call   802b5d <set_block_data>
  8036d5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8036d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036dc:	75 17                	jne    8036f5 <merging+0xc8>
  8036de:	83 ec 04             	sub    $0x4,%esp
  8036e1:	68 73 4e 80 00       	push   $0x804e73
  8036e6:	68 7d 01 00 00       	push   $0x17d
  8036eb:	68 91 4e 80 00       	push   $0x804e91
  8036f0:	e8 b0 0b 00 00       	call   8042a5 <_panic>
  8036f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	85 c0                	test   %eax,%eax
  8036fc:	74 10                	je     80370e <merging+0xe1>
  8036fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	8b 55 0c             	mov    0xc(%ebp),%edx
  803706:	8b 52 04             	mov    0x4(%edx),%edx
  803709:	89 50 04             	mov    %edx,0x4(%eax)
  80370c:	eb 0b                	jmp    803719 <merging+0xec>
  80370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803711:	8b 40 04             	mov    0x4(%eax),%eax
  803714:	a3 34 60 80 00       	mov    %eax,0x806034
  803719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371c:	8b 40 04             	mov    0x4(%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	74 0f                	je     803732 <merging+0x105>
  803723:	8b 45 0c             	mov    0xc(%ebp),%eax
  803726:	8b 40 04             	mov    0x4(%eax),%eax
  803729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80372c:	8b 12                	mov    (%edx),%edx
  80372e:	89 10                	mov    %edx,(%eax)
  803730:	eb 0a                	jmp    80373c <merging+0x10f>
  803732:	8b 45 0c             	mov    0xc(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	a3 30 60 80 00       	mov    %eax,0x806030
  80373c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803745:	8b 45 0c             	mov    0xc(%ebp),%eax
  803748:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374f:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803754:	48                   	dec    %eax
  803755:	a3 3c 60 80 00       	mov    %eax,0x80603c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80375a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80375b:	e9 ea 02 00 00       	jmp    803a4a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803764:	74 3b                	je     8037a1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803766:	83 ec 0c             	sub    $0xc,%esp
  803769:	ff 75 08             	pushl  0x8(%ebp)
  80376c:	e8 9b f0 ff ff       	call   80280c <get_block_size>
  803771:	83 c4 10             	add    $0x10,%esp
  803774:	89 c3                	mov    %eax,%ebx
  803776:	83 ec 0c             	sub    $0xc,%esp
  803779:	ff 75 10             	pushl  0x10(%ebp)
  80377c:	e8 8b f0 ff ff       	call   80280c <get_block_size>
  803781:	83 c4 10             	add    $0x10,%esp
  803784:	01 d8                	add    %ebx,%eax
  803786:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	6a 00                	push   $0x0
  80378e:	ff 75 e8             	pushl  -0x18(%ebp)
  803791:	ff 75 08             	pushl  0x8(%ebp)
  803794:	e8 c4 f3 ff ff       	call   802b5d <set_block_data>
  803799:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80379c:	e9 a9 02 00 00       	jmp    803a4a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8037a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037a5:	0f 84 2d 01 00 00    	je     8038d8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8037ab:	83 ec 0c             	sub    $0xc,%esp
  8037ae:	ff 75 10             	pushl  0x10(%ebp)
  8037b1:	e8 56 f0 ff ff       	call   80280c <get_block_size>
  8037b6:	83 c4 10             	add    $0x10,%esp
  8037b9:	89 c3                	mov    %eax,%ebx
  8037bb:	83 ec 0c             	sub    $0xc,%esp
  8037be:	ff 75 0c             	pushl  0xc(%ebp)
  8037c1:	e8 46 f0 ff ff       	call   80280c <get_block_size>
  8037c6:	83 c4 10             	add    $0x10,%esp
  8037c9:	01 d8                	add    %ebx,%eax
  8037cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	6a 00                	push   $0x0
  8037d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037d6:	ff 75 10             	pushl  0x10(%ebp)
  8037d9:	e8 7f f3 ff ff       	call   802b5d <set_block_data>
  8037de:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8037e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8037e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8037e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037eb:	74 06                	je     8037f3 <merging+0x1c6>
  8037ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037f1:	75 17                	jne    80380a <merging+0x1dd>
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 4c 4f 80 00       	push   $0x804f4c
  8037fb:	68 8d 01 00 00       	push   $0x18d
  803800:	68 91 4e 80 00       	push   $0x804e91
  803805:	e8 9b 0a 00 00       	call   8042a5 <_panic>
  80380a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380d:	8b 50 04             	mov    0x4(%eax),%edx
  803810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803813:	89 50 04             	mov    %edx,0x4(%eax)
  803816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80381c:	89 10                	mov    %edx,(%eax)
  80381e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803821:	8b 40 04             	mov    0x4(%eax),%eax
  803824:	85 c0                	test   %eax,%eax
  803826:	74 0d                	je     803835 <merging+0x208>
  803828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382b:	8b 40 04             	mov    0x4(%eax),%eax
  80382e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803831:	89 10                	mov    %edx,(%eax)
  803833:	eb 08                	jmp    80383d <merging+0x210>
  803835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803838:	a3 30 60 80 00       	mov    %eax,0x806030
  80383d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803840:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803843:	89 50 04             	mov    %edx,0x4(%eax)
  803846:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80384b:	40                   	inc    %eax
  80384c:	a3 3c 60 80 00       	mov    %eax,0x80603c
		LIST_REMOVE(&freeBlocksList, next_block);
  803851:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803855:	75 17                	jne    80386e <merging+0x241>
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 73 4e 80 00       	push   $0x804e73
  80385f:	68 8e 01 00 00       	push   $0x18e
  803864:	68 91 4e 80 00       	push   $0x804e91
  803869:	e8 37 0a 00 00       	call   8042a5 <_panic>
  80386e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	74 10                	je     803887 <merging+0x25a>
  803877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80387f:	8b 52 04             	mov    0x4(%edx),%edx
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	eb 0b                	jmp    803892 <merging+0x265>
  803887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388a:	8b 40 04             	mov    0x4(%eax),%eax
  80388d:	a3 34 60 80 00       	mov    %eax,0x806034
  803892:	8b 45 0c             	mov    0xc(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	85 c0                	test   %eax,%eax
  80389a:	74 0f                	je     8038ab <merging+0x27e>
  80389c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038a5:	8b 12                	mov    (%edx),%edx
  8038a7:	89 10                	mov    %edx,(%eax)
  8038a9:	eb 0a                	jmp    8038b5 <merging+0x288>
  8038ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	a3 30 60 80 00       	mov    %eax,0x806030
  8038b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c8:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8038cd:	48                   	dec    %eax
  8038ce:	a3 3c 60 80 00       	mov    %eax,0x80603c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8038d3:	e9 72 01 00 00       	jmp    803a4a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8038d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8038db:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8038de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e2:	74 79                	je     80395d <merging+0x330>
  8038e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038e8:	74 73                	je     80395d <merging+0x330>
  8038ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ee:	74 06                	je     8038f6 <merging+0x2c9>
  8038f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038f4:	75 17                	jne    80390d <merging+0x2e0>
  8038f6:	83 ec 04             	sub    $0x4,%esp
  8038f9:	68 04 4f 80 00       	push   $0x804f04
  8038fe:	68 94 01 00 00       	push   $0x194
  803903:	68 91 4e 80 00       	push   $0x804e91
  803908:	e8 98 09 00 00       	call   8042a5 <_panic>
  80390d:	8b 45 08             	mov    0x8(%ebp),%eax
  803910:	8b 10                	mov    (%eax),%edx
  803912:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803915:	89 10                	mov    %edx,(%eax)
  803917:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 0b                	je     80392b <merging+0x2fe>
  803920:	8b 45 08             	mov    0x8(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803928:	89 50 04             	mov    %edx,0x4(%eax)
  80392b:	8b 45 08             	mov    0x8(%ebp),%eax
  80392e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803931:	89 10                	mov    %edx,(%eax)
  803933:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803936:	8b 55 08             	mov    0x8(%ebp),%edx
  803939:	89 50 04             	mov    %edx,0x4(%eax)
  80393c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	75 08                	jne    80394d <merging+0x320>
  803945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803948:	a3 34 60 80 00       	mov    %eax,0x806034
  80394d:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803952:	40                   	inc    %eax
  803953:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803958:	e9 ce 00 00 00       	jmp    803a2b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80395d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803961:	74 65                	je     8039c8 <merging+0x39b>
  803963:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803967:	75 17                	jne    803980 <merging+0x353>
  803969:	83 ec 04             	sub    $0x4,%esp
  80396c:	68 e0 4e 80 00       	push   $0x804ee0
  803971:	68 95 01 00 00       	push   $0x195
  803976:	68 91 4e 80 00       	push   $0x804e91
  80397b:	e8 25 09 00 00       	call   8042a5 <_panic>
  803980:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803986:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803989:	89 50 04             	mov    %edx,0x4(%eax)
  80398c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398f:	8b 40 04             	mov    0x4(%eax),%eax
  803992:	85 c0                	test   %eax,%eax
  803994:	74 0c                	je     8039a2 <merging+0x375>
  803996:	a1 34 60 80 00       	mov    0x806034,%eax
  80399b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80399e:	89 10                	mov    %edx,(%eax)
  8039a0:	eb 08                	jmp    8039aa <merging+0x37d>
  8039a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a5:	a3 30 60 80 00       	mov    %eax,0x806030
  8039aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ad:	a3 34 60 80 00       	mov    %eax,0x806034
  8039b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039bb:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8039c0:	40                   	inc    %eax
  8039c1:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8039c6:	eb 63                	jmp    803a2b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8039c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039cc:	75 17                	jne    8039e5 <merging+0x3b8>
  8039ce:	83 ec 04             	sub    $0x4,%esp
  8039d1:	68 ac 4e 80 00       	push   $0x804eac
  8039d6:	68 98 01 00 00       	push   $0x198
  8039db:	68 91 4e 80 00       	push   $0x804e91
  8039e0:	e8 c0 08 00 00       	call   8042a5 <_panic>
  8039e5:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8039eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ee:	89 10                	mov    %edx,(%eax)
  8039f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f3:	8b 00                	mov    (%eax),%eax
  8039f5:	85 c0                	test   %eax,%eax
  8039f7:	74 0d                	je     803a06 <merging+0x3d9>
  8039f9:	a1 30 60 80 00       	mov    0x806030,%eax
  8039fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a01:	89 50 04             	mov    %edx,0x4(%eax)
  803a04:	eb 08                	jmp    803a0e <merging+0x3e1>
  803a06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a09:	a3 34 60 80 00       	mov    %eax,0x806034
  803a0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a11:	a3 30 60 80 00       	mov    %eax,0x806030
  803a16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a20:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803a25:	40                   	inc    %eax
  803a26:	a3 3c 60 80 00       	mov    %eax,0x80603c
		}
		set_block_data(va, get_block_size(va), 0);
  803a2b:	83 ec 0c             	sub    $0xc,%esp
  803a2e:	ff 75 10             	pushl  0x10(%ebp)
  803a31:	e8 d6 ed ff ff       	call   80280c <get_block_size>
  803a36:	83 c4 10             	add    $0x10,%esp
  803a39:	83 ec 04             	sub    $0x4,%esp
  803a3c:	6a 00                	push   $0x0
  803a3e:	50                   	push   %eax
  803a3f:	ff 75 10             	pushl  0x10(%ebp)
  803a42:	e8 16 f1 ff ff       	call   802b5d <set_block_data>
  803a47:	83 c4 10             	add    $0x10,%esp
	}
}
  803a4a:	90                   	nop
  803a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a4e:	c9                   	leave  
  803a4f:	c3                   	ret    

00803a50 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a50:	55                   	push   %ebp
  803a51:	89 e5                	mov    %esp,%ebp
  803a53:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a56:	a1 30 60 80 00       	mov    0x806030,%eax
  803a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a5e:	a1 34 60 80 00       	mov    0x806034,%eax
  803a63:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a66:	73 1b                	jae    803a83 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a68:	a1 34 60 80 00       	mov    0x806034,%eax
  803a6d:	83 ec 04             	sub    $0x4,%esp
  803a70:	ff 75 08             	pushl  0x8(%ebp)
  803a73:	6a 00                	push   $0x0
  803a75:	50                   	push   %eax
  803a76:	e8 b2 fb ff ff       	call   80362d <merging>
  803a7b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a7e:	e9 8b 00 00 00       	jmp    803b0e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a83:	a1 30 60 80 00       	mov    0x806030,%eax
  803a88:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a8b:	76 18                	jbe    803aa5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a8d:	a1 30 60 80 00       	mov    0x806030,%eax
  803a92:	83 ec 04             	sub    $0x4,%esp
  803a95:	ff 75 08             	pushl  0x8(%ebp)
  803a98:	50                   	push   %eax
  803a99:	6a 00                	push   $0x0
  803a9b:	e8 8d fb ff ff       	call   80362d <merging>
  803aa0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aa3:	eb 69                	jmp    803b0e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803aa5:	a1 30 60 80 00       	mov    0x806030,%eax
  803aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aad:	eb 39                	jmp    803ae8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ab5:	73 29                	jae    803ae0 <free_block+0x90>
  803ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aba:	8b 00                	mov    (%eax),%eax
  803abc:	3b 45 08             	cmp    0x8(%ebp),%eax
  803abf:	76 1f                	jbe    803ae0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ac9:	83 ec 04             	sub    $0x4,%esp
  803acc:	ff 75 08             	pushl  0x8(%ebp)
  803acf:	ff 75 f0             	pushl  -0x10(%ebp)
  803ad2:	ff 75 f4             	pushl  -0xc(%ebp)
  803ad5:	e8 53 fb ff ff       	call   80362d <merging>
  803ada:	83 c4 10             	add    $0x10,%esp
			break;
  803add:	90                   	nop
		}
	}
}
  803ade:	eb 2e                	jmp    803b0e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803ae0:	a1 38 60 80 00       	mov    0x806038,%eax
  803ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aec:	74 07                	je     803af5 <free_block+0xa5>
  803aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	eb 05                	jmp    803afa <free_block+0xaa>
  803af5:	b8 00 00 00 00       	mov    $0x0,%eax
  803afa:	a3 38 60 80 00       	mov    %eax,0x806038
  803aff:	a1 38 60 80 00       	mov    0x806038,%eax
  803b04:	85 c0                	test   %eax,%eax
  803b06:	75 a7                	jne    803aaf <free_block+0x5f>
  803b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0c:	75 a1                	jne    803aaf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b0e:	90                   	nop
  803b0f:	c9                   	leave  
  803b10:	c3                   	ret    

00803b11 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803b11:	55                   	push   %ebp
  803b12:	89 e5                	mov    %esp,%ebp
  803b14:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803b17:	ff 75 08             	pushl  0x8(%ebp)
  803b1a:	e8 ed ec ff ff       	call   80280c <get_block_size>
  803b1f:	83 c4 04             	add    $0x4,%esp
  803b22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803b25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803b2c:	eb 17                	jmp    803b45 <copy_data+0x34>
  803b2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b34:	01 c2                	add    %eax,%edx
  803b36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b39:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3c:	01 c8                	add    %ecx,%eax
  803b3e:	8a 00                	mov    (%eax),%al
  803b40:	88 02                	mov    %al,(%edx)
  803b42:	ff 45 fc             	incl   -0x4(%ebp)
  803b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b4b:	72 e1                	jb     803b2e <copy_data+0x1d>
}
  803b4d:	90                   	nop
  803b4e:	c9                   	leave  
  803b4f:	c3                   	ret    

00803b50 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b50:	55                   	push   %ebp
  803b51:	89 e5                	mov    %esp,%ebp
  803b53:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b5a:	75 23                	jne    803b7f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b60:	74 13                	je     803b75 <realloc_block_FF+0x25>
  803b62:	83 ec 0c             	sub    $0xc,%esp
  803b65:	ff 75 0c             	pushl  0xc(%ebp)
  803b68:	e8 1f f0 ff ff       	call   802b8c <alloc_block_FF>
  803b6d:	83 c4 10             	add    $0x10,%esp
  803b70:	e9 f4 06 00 00       	jmp    804269 <realloc_block_FF+0x719>
		return NULL;
  803b75:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7a:	e9 ea 06 00 00       	jmp    804269 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803b7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b83:	75 18                	jne    803b9d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b85:	83 ec 0c             	sub    $0xc,%esp
  803b88:	ff 75 08             	pushl  0x8(%ebp)
  803b8b:	e8 c0 fe ff ff       	call   803a50 <free_block>
  803b90:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b93:	b8 00 00 00 00       	mov    $0x0,%eax
  803b98:	e9 cc 06 00 00       	jmp    804269 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803b9d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803ba1:	77 07                	ja     803baa <realloc_block_FF+0x5a>
  803ba3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bad:	83 e0 01             	and    $0x1,%eax
  803bb0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb6:	83 c0 08             	add    $0x8,%eax
  803bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803bbc:	83 ec 0c             	sub    $0xc,%esp
  803bbf:	ff 75 08             	pushl  0x8(%ebp)
  803bc2:	e8 45 ec ff ff       	call   80280c <get_block_size>
  803bc7:	83 c4 10             	add    $0x10,%esp
  803bca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd0:	83 e8 08             	sub    $0x8,%eax
  803bd3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd9:	83 e8 04             	sub    $0x4,%eax
  803bdc:	8b 00                	mov    (%eax),%eax
  803bde:	83 e0 fe             	and    $0xfffffffe,%eax
  803be1:	89 c2                	mov    %eax,%edx
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	01 d0                	add    %edx,%eax
  803be8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803beb:	83 ec 0c             	sub    $0xc,%esp
  803bee:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bf1:	e8 16 ec ff ff       	call   80280c <get_block_size>
  803bf6:	83 c4 10             	add    $0x10,%esp
  803bf9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bff:	83 e8 08             	sub    $0x8,%eax
  803c02:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c08:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c0b:	75 08                	jne    803c15 <realloc_block_FF+0xc5>
	{
		 return va;
  803c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c10:	e9 54 06 00 00       	jmp    804269 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c18:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c1b:	0f 83 e5 03 00 00    	jae    804006 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c24:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c27:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803c2a:	83 ec 0c             	sub    $0xc,%esp
  803c2d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c30:	e8 f0 eb ff ff       	call   802825 <is_free_block>
  803c35:	83 c4 10             	add    $0x10,%esp
  803c38:	84 c0                	test   %al,%al
  803c3a:	0f 84 3b 01 00 00    	je     803d7b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c43:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c46:	01 d0                	add    %edx,%eax
  803c48:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c4b:	83 ec 04             	sub    $0x4,%esp
  803c4e:	6a 01                	push   $0x1
  803c50:	ff 75 f0             	pushl  -0x10(%ebp)
  803c53:	ff 75 08             	pushl  0x8(%ebp)
  803c56:	e8 02 ef ff ff       	call   802b5d <set_block_data>
  803c5b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	83 e8 04             	sub    $0x4,%eax
  803c64:	8b 00                	mov    (%eax),%eax
  803c66:	83 e0 fe             	and    $0xfffffffe,%eax
  803c69:	89 c2                	mov    %eax,%edx
  803c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6e:	01 d0                	add    %edx,%eax
  803c70:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c73:	83 ec 04             	sub    $0x4,%esp
  803c76:	6a 00                	push   $0x0
  803c78:	ff 75 cc             	pushl  -0x34(%ebp)
  803c7b:	ff 75 c8             	pushl  -0x38(%ebp)
  803c7e:	e8 da ee ff ff       	call   802b5d <set_block_data>
  803c83:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c8a:	74 06                	je     803c92 <realloc_block_FF+0x142>
  803c8c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c90:	75 17                	jne    803ca9 <realloc_block_FF+0x159>
  803c92:	83 ec 04             	sub    $0x4,%esp
  803c95:	68 04 4f 80 00       	push   $0x804f04
  803c9a:	68 f6 01 00 00       	push   $0x1f6
  803c9f:	68 91 4e 80 00       	push   $0x804e91
  803ca4:	e8 fc 05 00 00       	call   8042a5 <_panic>
  803ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cac:	8b 10                	mov    (%eax),%edx
  803cae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cb1:	89 10                	mov    %edx,(%eax)
  803cb3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	74 0b                	je     803cc7 <realloc_block_FF+0x177>
  803cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbf:	8b 00                	mov    (%eax),%eax
  803cc1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803cc4:	89 50 04             	mov    %edx,0x4(%eax)
  803cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ccd:	89 10                	mov    %edx,(%eax)
  803ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd5:	89 50 04             	mov    %edx,0x4(%eax)
  803cd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cdb:	8b 00                	mov    (%eax),%eax
  803cdd:	85 c0                	test   %eax,%eax
  803cdf:	75 08                	jne    803ce9 <realloc_block_FF+0x199>
  803ce1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ce4:	a3 34 60 80 00       	mov    %eax,0x806034
  803ce9:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803cee:	40                   	inc    %eax
  803cef:	a3 3c 60 80 00       	mov    %eax,0x80603c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cf8:	75 17                	jne    803d11 <realloc_block_FF+0x1c1>
  803cfa:	83 ec 04             	sub    $0x4,%esp
  803cfd:	68 73 4e 80 00       	push   $0x804e73
  803d02:	68 f7 01 00 00       	push   $0x1f7
  803d07:	68 91 4e 80 00       	push   $0x804e91
  803d0c:	e8 94 05 00 00       	call   8042a5 <_panic>
  803d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d14:	8b 00                	mov    (%eax),%eax
  803d16:	85 c0                	test   %eax,%eax
  803d18:	74 10                	je     803d2a <realloc_block_FF+0x1da>
  803d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1d:	8b 00                	mov    (%eax),%eax
  803d1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d22:	8b 52 04             	mov    0x4(%edx),%edx
  803d25:	89 50 04             	mov    %edx,0x4(%eax)
  803d28:	eb 0b                	jmp    803d35 <realloc_block_FF+0x1e5>
  803d2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2d:	8b 40 04             	mov    0x4(%eax),%eax
  803d30:	a3 34 60 80 00       	mov    %eax,0x806034
  803d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d38:	8b 40 04             	mov    0x4(%eax),%eax
  803d3b:	85 c0                	test   %eax,%eax
  803d3d:	74 0f                	je     803d4e <realloc_block_FF+0x1fe>
  803d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d42:	8b 40 04             	mov    0x4(%eax),%eax
  803d45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d48:	8b 12                	mov    (%edx),%edx
  803d4a:	89 10                	mov    %edx,(%eax)
  803d4c:	eb 0a                	jmp    803d58 <realloc_block_FF+0x208>
  803d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d51:	8b 00                	mov    (%eax),%eax
  803d53:	a3 30 60 80 00       	mov    %eax,0x806030
  803d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d6b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803d70:	48                   	dec    %eax
  803d71:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803d76:	e9 83 02 00 00       	jmp    803ffe <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803d7b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d7f:	0f 86 69 02 00 00    	jbe    803fee <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d85:	83 ec 04             	sub    $0x4,%esp
  803d88:	6a 01                	push   $0x1
  803d8a:	ff 75 f0             	pushl  -0x10(%ebp)
  803d8d:	ff 75 08             	pushl  0x8(%ebp)
  803d90:	e8 c8 ed ff ff       	call   802b5d <set_block_data>
  803d95:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	83 e8 04             	sub    $0x4,%eax
  803d9e:	8b 00                	mov    (%eax),%eax
  803da0:	83 e0 fe             	and    $0xfffffffe,%eax
  803da3:	89 c2                	mov    %eax,%edx
  803da5:	8b 45 08             	mov    0x8(%ebp),%eax
  803da8:	01 d0                	add    %edx,%eax
  803daa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803dad:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803db2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803db5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803db9:	75 68                	jne    803e23 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803dbb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dbf:	75 17                	jne    803dd8 <realloc_block_FF+0x288>
  803dc1:	83 ec 04             	sub    $0x4,%esp
  803dc4:	68 ac 4e 80 00       	push   $0x804eac
  803dc9:	68 06 02 00 00       	push   $0x206
  803dce:	68 91 4e 80 00       	push   $0x804e91
  803dd3:	e8 cd 04 00 00       	call   8042a5 <_panic>
  803dd8:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803dde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de1:	89 10                	mov    %edx,(%eax)
  803de3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de6:	8b 00                	mov    (%eax),%eax
  803de8:	85 c0                	test   %eax,%eax
  803dea:	74 0d                	je     803df9 <realloc_block_FF+0x2a9>
  803dec:	a1 30 60 80 00       	mov    0x806030,%eax
  803df1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803df4:	89 50 04             	mov    %edx,0x4(%eax)
  803df7:	eb 08                	jmp    803e01 <realloc_block_FF+0x2b1>
  803df9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dfc:	a3 34 60 80 00       	mov    %eax,0x806034
  803e01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e04:	a3 30 60 80 00       	mov    %eax,0x806030
  803e09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e13:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e18:	40                   	inc    %eax
  803e19:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803e1e:	e9 b0 01 00 00       	jmp    803fd3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803e23:	a1 30 60 80 00       	mov    0x806030,%eax
  803e28:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e2b:	76 68                	jbe    803e95 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e2d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e31:	75 17                	jne    803e4a <realloc_block_FF+0x2fa>
  803e33:	83 ec 04             	sub    $0x4,%esp
  803e36:	68 ac 4e 80 00       	push   $0x804eac
  803e3b:	68 0b 02 00 00       	push   $0x20b
  803e40:	68 91 4e 80 00       	push   $0x804e91
  803e45:	e8 5b 04 00 00       	call   8042a5 <_panic>
  803e4a:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e53:	89 10                	mov    %edx,(%eax)
  803e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e58:	8b 00                	mov    (%eax),%eax
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	74 0d                	je     803e6b <realloc_block_FF+0x31b>
  803e5e:	a1 30 60 80 00       	mov    0x806030,%eax
  803e63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e66:	89 50 04             	mov    %edx,0x4(%eax)
  803e69:	eb 08                	jmp    803e73 <realloc_block_FF+0x323>
  803e6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6e:	a3 34 60 80 00       	mov    %eax,0x806034
  803e73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e76:	a3 30 60 80 00       	mov    %eax,0x806030
  803e7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e85:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e8a:	40                   	inc    %eax
  803e8b:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803e90:	e9 3e 01 00 00       	jmp    803fd3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e95:	a1 30 60 80 00       	mov    0x806030,%eax
  803e9a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e9d:	73 68                	jae    803f07 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e9f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ea3:	75 17                	jne    803ebc <realloc_block_FF+0x36c>
  803ea5:	83 ec 04             	sub    $0x4,%esp
  803ea8:	68 e0 4e 80 00       	push   $0x804ee0
  803ead:	68 10 02 00 00       	push   $0x210
  803eb2:	68 91 4e 80 00       	push   $0x804e91
  803eb7:	e8 e9 03 00 00       	call   8042a5 <_panic>
  803ebc:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803ec2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec5:	89 50 04             	mov    %edx,0x4(%eax)
  803ec8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ecb:	8b 40 04             	mov    0x4(%eax),%eax
  803ece:	85 c0                	test   %eax,%eax
  803ed0:	74 0c                	je     803ede <realloc_block_FF+0x38e>
  803ed2:	a1 34 60 80 00       	mov    0x806034,%eax
  803ed7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eda:	89 10                	mov    %edx,(%eax)
  803edc:	eb 08                	jmp    803ee6 <realloc_block_FF+0x396>
  803ede:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ee1:	a3 30 60 80 00       	mov    %eax,0x806030
  803ee6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ee9:	a3 34 60 80 00       	mov    %eax,0x806034
  803eee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ef7:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803efc:	40                   	inc    %eax
  803efd:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803f02:	e9 cc 00 00 00       	jmp    803fd3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803f07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803f0e:	a1 30 60 80 00       	mov    0x806030,%eax
  803f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f16:	e9 8a 00 00 00       	jmp    803fa5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f21:	73 7a                	jae    803f9d <realloc_block_FF+0x44d>
  803f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f26:	8b 00                	mov    (%eax),%eax
  803f28:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f2b:	73 70                	jae    803f9d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f31:	74 06                	je     803f39 <realloc_block_FF+0x3e9>
  803f33:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f37:	75 17                	jne    803f50 <realloc_block_FF+0x400>
  803f39:	83 ec 04             	sub    $0x4,%esp
  803f3c:	68 04 4f 80 00       	push   $0x804f04
  803f41:	68 1a 02 00 00       	push   $0x21a
  803f46:	68 91 4e 80 00       	push   $0x804e91
  803f4b:	e8 55 03 00 00       	call   8042a5 <_panic>
  803f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f53:	8b 10                	mov    (%eax),%edx
  803f55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f58:	89 10                	mov    %edx,(%eax)
  803f5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f5d:	8b 00                	mov    (%eax),%eax
  803f5f:	85 c0                	test   %eax,%eax
  803f61:	74 0b                	je     803f6e <realloc_block_FF+0x41e>
  803f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f66:	8b 00                	mov    (%eax),%eax
  803f68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f6b:	89 50 04             	mov    %edx,0x4(%eax)
  803f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f74:	89 10                	mov    %edx,(%eax)
  803f76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f7c:	89 50 04             	mov    %edx,0x4(%eax)
  803f7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f82:	8b 00                	mov    (%eax),%eax
  803f84:	85 c0                	test   %eax,%eax
  803f86:	75 08                	jne    803f90 <realloc_block_FF+0x440>
  803f88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f8b:	a3 34 60 80 00       	mov    %eax,0x806034
  803f90:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803f95:	40                   	inc    %eax
  803f96:	a3 3c 60 80 00       	mov    %eax,0x80603c
							break;
  803f9b:	eb 36                	jmp    803fd3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f9d:	a1 38 60 80 00       	mov    0x806038,%eax
  803fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fa9:	74 07                	je     803fb2 <realloc_block_FF+0x462>
  803fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fae:	8b 00                	mov    (%eax),%eax
  803fb0:	eb 05                	jmp    803fb7 <realloc_block_FF+0x467>
  803fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb7:	a3 38 60 80 00       	mov    %eax,0x806038
  803fbc:	a1 38 60 80 00       	mov    0x806038,%eax
  803fc1:	85 c0                	test   %eax,%eax
  803fc3:	0f 85 52 ff ff ff    	jne    803f1b <realloc_block_FF+0x3cb>
  803fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fcd:	0f 85 48 ff ff ff    	jne    803f1b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803fd3:	83 ec 04             	sub    $0x4,%esp
  803fd6:	6a 00                	push   $0x0
  803fd8:	ff 75 d8             	pushl  -0x28(%ebp)
  803fdb:	ff 75 d4             	pushl  -0x2c(%ebp)
  803fde:	e8 7a eb ff ff       	call   802b5d <set_block_data>
  803fe3:	83 c4 10             	add    $0x10,%esp
				return va;
  803fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe9:	e9 7b 02 00 00       	jmp    804269 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803fee:	83 ec 0c             	sub    $0xc,%esp
  803ff1:	68 81 4f 80 00       	push   $0x804f81
  803ff6:	e8 26 cc ff ff       	call   800c21 <cprintf>
  803ffb:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  804001:	e9 63 02 00 00       	jmp    804269 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804006:	8b 45 0c             	mov    0xc(%ebp),%eax
  804009:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80400c:	0f 86 4d 02 00 00    	jbe    80425f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804012:	83 ec 0c             	sub    $0xc,%esp
  804015:	ff 75 e4             	pushl  -0x1c(%ebp)
  804018:	e8 08 e8 ff ff       	call   802825 <is_free_block>
  80401d:	83 c4 10             	add    $0x10,%esp
  804020:	84 c0                	test   %al,%al
  804022:	0f 84 37 02 00 00    	je     80425f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80402e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804031:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804034:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804037:	76 38                	jbe    804071 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804039:	83 ec 0c             	sub    $0xc,%esp
  80403c:	ff 75 08             	pushl  0x8(%ebp)
  80403f:	e8 0c fa ff ff       	call   803a50 <free_block>
  804044:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804047:	83 ec 0c             	sub    $0xc,%esp
  80404a:	ff 75 0c             	pushl  0xc(%ebp)
  80404d:	e8 3a eb ff ff       	call   802b8c <alloc_block_FF>
  804052:	83 c4 10             	add    $0x10,%esp
  804055:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804058:	83 ec 08             	sub    $0x8,%esp
  80405b:	ff 75 c0             	pushl  -0x40(%ebp)
  80405e:	ff 75 08             	pushl  0x8(%ebp)
  804061:	e8 ab fa ff ff       	call   803b11 <copy_data>
  804066:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804069:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80406c:	e9 f8 01 00 00       	jmp    804269 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804071:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804074:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804077:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80407a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80407e:	0f 87 a0 00 00 00    	ja     804124 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804084:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804088:	75 17                	jne    8040a1 <realloc_block_FF+0x551>
  80408a:	83 ec 04             	sub    $0x4,%esp
  80408d:	68 73 4e 80 00       	push   $0x804e73
  804092:	68 38 02 00 00       	push   $0x238
  804097:	68 91 4e 80 00       	push   $0x804e91
  80409c:	e8 04 02 00 00       	call   8042a5 <_panic>
  8040a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a4:	8b 00                	mov    (%eax),%eax
  8040a6:	85 c0                	test   %eax,%eax
  8040a8:	74 10                	je     8040ba <realloc_block_FF+0x56a>
  8040aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ad:	8b 00                	mov    (%eax),%eax
  8040af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040b2:	8b 52 04             	mov    0x4(%edx),%edx
  8040b5:	89 50 04             	mov    %edx,0x4(%eax)
  8040b8:	eb 0b                	jmp    8040c5 <realloc_block_FF+0x575>
  8040ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040bd:	8b 40 04             	mov    0x4(%eax),%eax
  8040c0:	a3 34 60 80 00       	mov    %eax,0x806034
  8040c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c8:	8b 40 04             	mov    0x4(%eax),%eax
  8040cb:	85 c0                	test   %eax,%eax
  8040cd:	74 0f                	je     8040de <realloc_block_FF+0x58e>
  8040cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d2:	8b 40 04             	mov    0x4(%eax),%eax
  8040d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d8:	8b 12                	mov    (%edx),%edx
  8040da:	89 10                	mov    %edx,(%eax)
  8040dc:	eb 0a                	jmp    8040e8 <realloc_block_FF+0x598>
  8040de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e1:	8b 00                	mov    (%eax),%eax
  8040e3:	a3 30 60 80 00       	mov    %eax,0x806030
  8040e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040fb:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804100:	48                   	dec    %eax
  804101:	a3 3c 60 80 00       	mov    %eax,0x80603c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804106:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804109:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80410c:	01 d0                	add    %edx,%eax
  80410e:	83 ec 04             	sub    $0x4,%esp
  804111:	6a 01                	push   $0x1
  804113:	50                   	push   %eax
  804114:	ff 75 08             	pushl  0x8(%ebp)
  804117:	e8 41 ea ff ff       	call   802b5d <set_block_data>
  80411c:	83 c4 10             	add    $0x10,%esp
  80411f:	e9 36 01 00 00       	jmp    80425a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804124:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804127:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80412a:	01 d0                	add    %edx,%eax
  80412c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80412f:	83 ec 04             	sub    $0x4,%esp
  804132:	6a 01                	push   $0x1
  804134:	ff 75 f0             	pushl  -0x10(%ebp)
  804137:	ff 75 08             	pushl  0x8(%ebp)
  80413a:	e8 1e ea ff ff       	call   802b5d <set_block_data>
  80413f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804142:	8b 45 08             	mov    0x8(%ebp),%eax
  804145:	83 e8 04             	sub    $0x4,%eax
  804148:	8b 00                	mov    (%eax),%eax
  80414a:	83 e0 fe             	and    $0xfffffffe,%eax
  80414d:	89 c2                	mov    %eax,%edx
  80414f:	8b 45 08             	mov    0x8(%ebp),%eax
  804152:	01 d0                	add    %edx,%eax
  804154:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804157:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80415b:	74 06                	je     804163 <realloc_block_FF+0x613>
  80415d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804161:	75 17                	jne    80417a <realloc_block_FF+0x62a>
  804163:	83 ec 04             	sub    $0x4,%esp
  804166:	68 04 4f 80 00       	push   $0x804f04
  80416b:	68 44 02 00 00       	push   $0x244
  804170:	68 91 4e 80 00       	push   $0x804e91
  804175:	e8 2b 01 00 00       	call   8042a5 <_panic>
  80417a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80417d:	8b 10                	mov    (%eax),%edx
  80417f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804182:	89 10                	mov    %edx,(%eax)
  804184:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804187:	8b 00                	mov    (%eax),%eax
  804189:	85 c0                	test   %eax,%eax
  80418b:	74 0b                	je     804198 <realloc_block_FF+0x648>
  80418d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804190:	8b 00                	mov    (%eax),%eax
  804192:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804195:	89 50 04             	mov    %edx,0x4(%eax)
  804198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80419e:	89 10                	mov    %edx,(%eax)
  8041a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041a6:	89 50 04             	mov    %edx,0x4(%eax)
  8041a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ac:	8b 00                	mov    (%eax),%eax
  8041ae:	85 c0                	test   %eax,%eax
  8041b0:	75 08                	jne    8041ba <realloc_block_FF+0x66a>
  8041b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041b5:	a3 34 60 80 00       	mov    %eax,0x806034
  8041ba:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8041bf:	40                   	inc    %eax
  8041c0:	a3 3c 60 80 00       	mov    %eax,0x80603c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041c9:	75 17                	jne    8041e2 <realloc_block_FF+0x692>
  8041cb:	83 ec 04             	sub    $0x4,%esp
  8041ce:	68 73 4e 80 00       	push   $0x804e73
  8041d3:	68 45 02 00 00       	push   $0x245
  8041d8:	68 91 4e 80 00       	push   $0x804e91
  8041dd:	e8 c3 00 00 00       	call   8042a5 <_panic>
  8041e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e5:	8b 00                	mov    (%eax),%eax
  8041e7:	85 c0                	test   %eax,%eax
  8041e9:	74 10                	je     8041fb <realloc_block_FF+0x6ab>
  8041eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ee:	8b 00                	mov    (%eax),%eax
  8041f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041f3:	8b 52 04             	mov    0x4(%edx),%edx
  8041f6:	89 50 04             	mov    %edx,0x4(%eax)
  8041f9:	eb 0b                	jmp    804206 <realloc_block_FF+0x6b6>
  8041fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041fe:	8b 40 04             	mov    0x4(%eax),%eax
  804201:	a3 34 60 80 00       	mov    %eax,0x806034
  804206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804209:	8b 40 04             	mov    0x4(%eax),%eax
  80420c:	85 c0                	test   %eax,%eax
  80420e:	74 0f                	je     80421f <realloc_block_FF+0x6cf>
  804210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804213:	8b 40 04             	mov    0x4(%eax),%eax
  804216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804219:	8b 12                	mov    (%edx),%edx
  80421b:	89 10                	mov    %edx,(%eax)
  80421d:	eb 0a                	jmp    804229 <realloc_block_FF+0x6d9>
  80421f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804222:	8b 00                	mov    (%eax),%eax
  804224:	a3 30 60 80 00       	mov    %eax,0x806030
  804229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80422c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80423c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804241:	48                   	dec    %eax
  804242:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(next_new_va, remaining_size, 0);
  804247:	83 ec 04             	sub    $0x4,%esp
  80424a:	6a 00                	push   $0x0
  80424c:	ff 75 bc             	pushl  -0x44(%ebp)
  80424f:	ff 75 b8             	pushl  -0x48(%ebp)
  804252:	e8 06 e9 ff ff       	call   802b5d <set_block_data>
  804257:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80425a:	8b 45 08             	mov    0x8(%ebp),%eax
  80425d:	eb 0a                	jmp    804269 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80425f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804266:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804269:	c9                   	leave  
  80426a:	c3                   	ret    

0080426b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80426b:	55                   	push   %ebp
  80426c:	89 e5                	mov    %esp,%ebp
  80426e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804271:	83 ec 04             	sub    $0x4,%esp
  804274:	68 88 4f 80 00       	push   $0x804f88
  804279:	68 58 02 00 00       	push   $0x258
  80427e:	68 91 4e 80 00       	push   $0x804e91
  804283:	e8 1d 00 00 00       	call   8042a5 <_panic>

00804288 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804288:	55                   	push   %ebp
  804289:	89 e5                	mov    %esp,%ebp
  80428b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80428e:	83 ec 04             	sub    $0x4,%esp
  804291:	68 b0 4f 80 00       	push   $0x804fb0
  804296:	68 61 02 00 00       	push   $0x261
  80429b:	68 91 4e 80 00       	push   $0x804e91
  8042a0:	e8 00 00 00 00       	call   8042a5 <_panic>

008042a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8042a5:	55                   	push   %ebp
  8042a6:	89 e5                	mov    %esp,%ebp
  8042a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8042ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8042ae:	83 c0 04             	add    $0x4,%eax
  8042b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8042b4:	a1 60 a0 18 01       	mov    0x118a060,%eax
  8042b9:	85 c0                	test   %eax,%eax
  8042bb:	74 16                	je     8042d3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8042bd:	a1 60 a0 18 01       	mov    0x118a060,%eax
  8042c2:	83 ec 08             	sub    $0x8,%esp
  8042c5:	50                   	push   %eax
  8042c6:	68 d8 4f 80 00       	push   $0x804fd8
  8042cb:	e8 51 c9 ff ff       	call   800c21 <cprintf>
  8042d0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8042d3:	a1 00 60 80 00       	mov    0x806000,%eax
  8042d8:	ff 75 0c             	pushl  0xc(%ebp)
  8042db:	ff 75 08             	pushl  0x8(%ebp)
  8042de:	50                   	push   %eax
  8042df:	68 dd 4f 80 00       	push   $0x804fdd
  8042e4:	e8 38 c9 ff ff       	call   800c21 <cprintf>
  8042e9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8042ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8042ef:	83 ec 08             	sub    $0x8,%esp
  8042f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8042f5:	50                   	push   %eax
  8042f6:	e8 bb c8 ff ff       	call   800bb6 <vcprintf>
  8042fb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8042fe:	83 ec 08             	sub    $0x8,%esp
  804301:	6a 00                	push   $0x0
  804303:	68 f9 4f 80 00       	push   $0x804ff9
  804308:	e8 a9 c8 ff ff       	call   800bb6 <vcprintf>
  80430d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  804310:	e8 2a c8 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  804315:	eb fe                	jmp    804315 <_panic+0x70>

00804317 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  804317:	55                   	push   %ebp
  804318:	89 e5                	mov    %esp,%ebp
  80431a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80431d:	a1 20 60 80 00       	mov    0x806020,%eax
  804322:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80432b:	39 c2                	cmp    %eax,%edx
  80432d:	74 14                	je     804343 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80432f:	83 ec 04             	sub    $0x4,%esp
  804332:	68 fc 4f 80 00       	push   $0x804ffc
  804337:	6a 26                	push   $0x26
  804339:	68 48 50 80 00       	push   $0x805048
  80433e:	e8 62 ff ff ff       	call   8042a5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80434a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804351:	e9 c5 00 00 00       	jmp    80441b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  804356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804360:	8b 45 08             	mov    0x8(%ebp),%eax
  804363:	01 d0                	add    %edx,%eax
  804365:	8b 00                	mov    (%eax),%eax
  804367:	85 c0                	test   %eax,%eax
  804369:	75 08                	jne    804373 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80436b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80436e:	e9 a5 00 00 00       	jmp    804418 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804373:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80437a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804381:	eb 69                	jmp    8043ec <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  804383:	a1 20 60 80 00       	mov    0x806020,%eax
  804388:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80438e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804391:	89 d0                	mov    %edx,%eax
  804393:	01 c0                	add    %eax,%eax
  804395:	01 d0                	add    %edx,%eax
  804397:	c1 e0 03             	shl    $0x3,%eax
  80439a:	01 c8                	add    %ecx,%eax
  80439c:	8a 40 04             	mov    0x4(%eax),%al
  80439f:	84 c0                	test   %al,%al
  8043a1:	75 46                	jne    8043e9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8043a3:	a1 20 60 80 00       	mov    0x806020,%eax
  8043a8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8043ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8043b1:	89 d0                	mov    %edx,%eax
  8043b3:	01 c0                	add    %eax,%eax
  8043b5:	01 d0                	add    %edx,%eax
  8043b7:	c1 e0 03             	shl    $0x3,%eax
  8043ba:	01 c8                	add    %ecx,%eax
  8043bc:	8b 00                	mov    (%eax),%eax
  8043be:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8043c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8043c9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8043cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8043d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d8:	01 c8                	add    %ecx,%eax
  8043da:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8043dc:	39 c2                	cmp    %eax,%edx
  8043de:	75 09                	jne    8043e9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8043e0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8043e7:	eb 15                	jmp    8043fe <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8043e9:	ff 45 e8             	incl   -0x18(%ebp)
  8043ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8043f1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8043f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043fa:	39 c2                	cmp    %eax,%edx
  8043fc:	77 85                	ja     804383 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8043fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804402:	75 14                	jne    804418 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  804404:	83 ec 04             	sub    $0x4,%esp
  804407:	68 54 50 80 00       	push   $0x805054
  80440c:	6a 3a                	push   $0x3a
  80440e:	68 48 50 80 00       	push   $0x805048
  804413:	e8 8d fe ff ff       	call   8042a5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  804418:	ff 45 f0             	incl   -0x10(%ebp)
  80441b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80441e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804421:	0f 8c 2f ff ff ff    	jl     804356 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  804427:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80442e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804435:	eb 26                	jmp    80445d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  804437:	a1 20 60 80 00       	mov    0x806020,%eax
  80443c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804442:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804445:	89 d0                	mov    %edx,%eax
  804447:	01 c0                	add    %eax,%eax
  804449:	01 d0                	add    %edx,%eax
  80444b:	c1 e0 03             	shl    $0x3,%eax
  80444e:	01 c8                	add    %ecx,%eax
  804450:	8a 40 04             	mov    0x4(%eax),%al
  804453:	3c 01                	cmp    $0x1,%al
  804455:	75 03                	jne    80445a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  804457:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80445a:	ff 45 e0             	incl   -0x20(%ebp)
  80445d:	a1 20 60 80 00       	mov    0x806020,%eax
  804462:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80446b:	39 c2                	cmp    %eax,%edx
  80446d:	77 c8                	ja     804437 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804472:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804475:	74 14                	je     80448b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  804477:	83 ec 04             	sub    $0x4,%esp
  80447a:	68 a8 50 80 00       	push   $0x8050a8
  80447f:	6a 44                	push   $0x44
  804481:	68 48 50 80 00       	push   $0x805048
  804486:	e8 1a fe ff ff       	call   8042a5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80448b:	90                   	nop
  80448c:	c9                   	leave  
  80448d:	c3                   	ret    
  80448e:	66 90                	xchg   %ax,%ax

00804490 <__udivdi3>:
  804490:	55                   	push   %ebp
  804491:	57                   	push   %edi
  804492:	56                   	push   %esi
  804493:	53                   	push   %ebx
  804494:	83 ec 1c             	sub    $0x1c,%esp
  804497:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80449b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80449f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8044a7:	89 ca                	mov    %ecx,%edx
  8044a9:	89 f8                	mov    %edi,%eax
  8044ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8044af:	85 f6                	test   %esi,%esi
  8044b1:	75 2d                	jne    8044e0 <__udivdi3+0x50>
  8044b3:	39 cf                	cmp    %ecx,%edi
  8044b5:	77 65                	ja     80451c <__udivdi3+0x8c>
  8044b7:	89 fd                	mov    %edi,%ebp
  8044b9:	85 ff                	test   %edi,%edi
  8044bb:	75 0b                	jne    8044c8 <__udivdi3+0x38>
  8044bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8044c2:	31 d2                	xor    %edx,%edx
  8044c4:	f7 f7                	div    %edi
  8044c6:	89 c5                	mov    %eax,%ebp
  8044c8:	31 d2                	xor    %edx,%edx
  8044ca:	89 c8                	mov    %ecx,%eax
  8044cc:	f7 f5                	div    %ebp
  8044ce:	89 c1                	mov    %eax,%ecx
  8044d0:	89 d8                	mov    %ebx,%eax
  8044d2:	f7 f5                	div    %ebp
  8044d4:	89 cf                	mov    %ecx,%edi
  8044d6:	89 fa                	mov    %edi,%edx
  8044d8:	83 c4 1c             	add    $0x1c,%esp
  8044db:	5b                   	pop    %ebx
  8044dc:	5e                   	pop    %esi
  8044dd:	5f                   	pop    %edi
  8044de:	5d                   	pop    %ebp
  8044df:	c3                   	ret    
  8044e0:	39 ce                	cmp    %ecx,%esi
  8044e2:	77 28                	ja     80450c <__udivdi3+0x7c>
  8044e4:	0f bd fe             	bsr    %esi,%edi
  8044e7:	83 f7 1f             	xor    $0x1f,%edi
  8044ea:	75 40                	jne    80452c <__udivdi3+0x9c>
  8044ec:	39 ce                	cmp    %ecx,%esi
  8044ee:	72 0a                	jb     8044fa <__udivdi3+0x6a>
  8044f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8044f4:	0f 87 9e 00 00 00    	ja     804598 <__udivdi3+0x108>
  8044fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8044ff:	89 fa                	mov    %edi,%edx
  804501:	83 c4 1c             	add    $0x1c,%esp
  804504:	5b                   	pop    %ebx
  804505:	5e                   	pop    %esi
  804506:	5f                   	pop    %edi
  804507:	5d                   	pop    %ebp
  804508:	c3                   	ret    
  804509:	8d 76 00             	lea    0x0(%esi),%esi
  80450c:	31 ff                	xor    %edi,%edi
  80450e:	31 c0                	xor    %eax,%eax
  804510:	89 fa                	mov    %edi,%edx
  804512:	83 c4 1c             	add    $0x1c,%esp
  804515:	5b                   	pop    %ebx
  804516:	5e                   	pop    %esi
  804517:	5f                   	pop    %edi
  804518:	5d                   	pop    %ebp
  804519:	c3                   	ret    
  80451a:	66 90                	xchg   %ax,%ax
  80451c:	89 d8                	mov    %ebx,%eax
  80451e:	f7 f7                	div    %edi
  804520:	31 ff                	xor    %edi,%edi
  804522:	89 fa                	mov    %edi,%edx
  804524:	83 c4 1c             	add    $0x1c,%esp
  804527:	5b                   	pop    %ebx
  804528:	5e                   	pop    %esi
  804529:	5f                   	pop    %edi
  80452a:	5d                   	pop    %ebp
  80452b:	c3                   	ret    
  80452c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804531:	89 eb                	mov    %ebp,%ebx
  804533:	29 fb                	sub    %edi,%ebx
  804535:	89 f9                	mov    %edi,%ecx
  804537:	d3 e6                	shl    %cl,%esi
  804539:	89 c5                	mov    %eax,%ebp
  80453b:	88 d9                	mov    %bl,%cl
  80453d:	d3 ed                	shr    %cl,%ebp
  80453f:	89 e9                	mov    %ebp,%ecx
  804541:	09 f1                	or     %esi,%ecx
  804543:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804547:	89 f9                	mov    %edi,%ecx
  804549:	d3 e0                	shl    %cl,%eax
  80454b:	89 c5                	mov    %eax,%ebp
  80454d:	89 d6                	mov    %edx,%esi
  80454f:	88 d9                	mov    %bl,%cl
  804551:	d3 ee                	shr    %cl,%esi
  804553:	89 f9                	mov    %edi,%ecx
  804555:	d3 e2                	shl    %cl,%edx
  804557:	8b 44 24 08          	mov    0x8(%esp),%eax
  80455b:	88 d9                	mov    %bl,%cl
  80455d:	d3 e8                	shr    %cl,%eax
  80455f:	09 c2                	or     %eax,%edx
  804561:	89 d0                	mov    %edx,%eax
  804563:	89 f2                	mov    %esi,%edx
  804565:	f7 74 24 0c          	divl   0xc(%esp)
  804569:	89 d6                	mov    %edx,%esi
  80456b:	89 c3                	mov    %eax,%ebx
  80456d:	f7 e5                	mul    %ebp
  80456f:	39 d6                	cmp    %edx,%esi
  804571:	72 19                	jb     80458c <__udivdi3+0xfc>
  804573:	74 0b                	je     804580 <__udivdi3+0xf0>
  804575:	89 d8                	mov    %ebx,%eax
  804577:	31 ff                	xor    %edi,%edi
  804579:	e9 58 ff ff ff       	jmp    8044d6 <__udivdi3+0x46>
  80457e:	66 90                	xchg   %ax,%ax
  804580:	8b 54 24 08          	mov    0x8(%esp),%edx
  804584:	89 f9                	mov    %edi,%ecx
  804586:	d3 e2                	shl    %cl,%edx
  804588:	39 c2                	cmp    %eax,%edx
  80458a:	73 e9                	jae    804575 <__udivdi3+0xe5>
  80458c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80458f:	31 ff                	xor    %edi,%edi
  804591:	e9 40 ff ff ff       	jmp    8044d6 <__udivdi3+0x46>
  804596:	66 90                	xchg   %ax,%ax
  804598:	31 c0                	xor    %eax,%eax
  80459a:	e9 37 ff ff ff       	jmp    8044d6 <__udivdi3+0x46>
  80459f:	90                   	nop

008045a0 <__umoddi3>:
  8045a0:	55                   	push   %ebp
  8045a1:	57                   	push   %edi
  8045a2:	56                   	push   %esi
  8045a3:	53                   	push   %ebx
  8045a4:	83 ec 1c             	sub    $0x1c,%esp
  8045a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8045ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8045af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8045b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8045b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8045bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8045bf:	89 f3                	mov    %esi,%ebx
  8045c1:	89 fa                	mov    %edi,%edx
  8045c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045c7:	89 34 24             	mov    %esi,(%esp)
  8045ca:	85 c0                	test   %eax,%eax
  8045cc:	75 1a                	jne    8045e8 <__umoddi3+0x48>
  8045ce:	39 f7                	cmp    %esi,%edi
  8045d0:	0f 86 a2 00 00 00    	jbe    804678 <__umoddi3+0xd8>
  8045d6:	89 c8                	mov    %ecx,%eax
  8045d8:	89 f2                	mov    %esi,%edx
  8045da:	f7 f7                	div    %edi
  8045dc:	89 d0                	mov    %edx,%eax
  8045de:	31 d2                	xor    %edx,%edx
  8045e0:	83 c4 1c             	add    $0x1c,%esp
  8045e3:	5b                   	pop    %ebx
  8045e4:	5e                   	pop    %esi
  8045e5:	5f                   	pop    %edi
  8045e6:	5d                   	pop    %ebp
  8045e7:	c3                   	ret    
  8045e8:	39 f0                	cmp    %esi,%eax
  8045ea:	0f 87 ac 00 00 00    	ja     80469c <__umoddi3+0xfc>
  8045f0:	0f bd e8             	bsr    %eax,%ebp
  8045f3:	83 f5 1f             	xor    $0x1f,%ebp
  8045f6:	0f 84 ac 00 00 00    	je     8046a8 <__umoddi3+0x108>
  8045fc:	bf 20 00 00 00       	mov    $0x20,%edi
  804601:	29 ef                	sub    %ebp,%edi
  804603:	89 fe                	mov    %edi,%esi
  804605:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804609:	89 e9                	mov    %ebp,%ecx
  80460b:	d3 e0                	shl    %cl,%eax
  80460d:	89 d7                	mov    %edx,%edi
  80460f:	89 f1                	mov    %esi,%ecx
  804611:	d3 ef                	shr    %cl,%edi
  804613:	09 c7                	or     %eax,%edi
  804615:	89 e9                	mov    %ebp,%ecx
  804617:	d3 e2                	shl    %cl,%edx
  804619:	89 14 24             	mov    %edx,(%esp)
  80461c:	89 d8                	mov    %ebx,%eax
  80461e:	d3 e0                	shl    %cl,%eax
  804620:	89 c2                	mov    %eax,%edx
  804622:	8b 44 24 08          	mov    0x8(%esp),%eax
  804626:	d3 e0                	shl    %cl,%eax
  804628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80462c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804630:	89 f1                	mov    %esi,%ecx
  804632:	d3 e8                	shr    %cl,%eax
  804634:	09 d0                	or     %edx,%eax
  804636:	d3 eb                	shr    %cl,%ebx
  804638:	89 da                	mov    %ebx,%edx
  80463a:	f7 f7                	div    %edi
  80463c:	89 d3                	mov    %edx,%ebx
  80463e:	f7 24 24             	mull   (%esp)
  804641:	89 c6                	mov    %eax,%esi
  804643:	89 d1                	mov    %edx,%ecx
  804645:	39 d3                	cmp    %edx,%ebx
  804647:	0f 82 87 00 00 00    	jb     8046d4 <__umoddi3+0x134>
  80464d:	0f 84 91 00 00 00    	je     8046e4 <__umoddi3+0x144>
  804653:	8b 54 24 04          	mov    0x4(%esp),%edx
  804657:	29 f2                	sub    %esi,%edx
  804659:	19 cb                	sbb    %ecx,%ebx
  80465b:	89 d8                	mov    %ebx,%eax
  80465d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804661:	d3 e0                	shl    %cl,%eax
  804663:	89 e9                	mov    %ebp,%ecx
  804665:	d3 ea                	shr    %cl,%edx
  804667:	09 d0                	or     %edx,%eax
  804669:	89 e9                	mov    %ebp,%ecx
  80466b:	d3 eb                	shr    %cl,%ebx
  80466d:	89 da                	mov    %ebx,%edx
  80466f:	83 c4 1c             	add    $0x1c,%esp
  804672:	5b                   	pop    %ebx
  804673:	5e                   	pop    %esi
  804674:	5f                   	pop    %edi
  804675:	5d                   	pop    %ebp
  804676:	c3                   	ret    
  804677:	90                   	nop
  804678:	89 fd                	mov    %edi,%ebp
  80467a:	85 ff                	test   %edi,%edi
  80467c:	75 0b                	jne    804689 <__umoddi3+0xe9>
  80467e:	b8 01 00 00 00       	mov    $0x1,%eax
  804683:	31 d2                	xor    %edx,%edx
  804685:	f7 f7                	div    %edi
  804687:	89 c5                	mov    %eax,%ebp
  804689:	89 f0                	mov    %esi,%eax
  80468b:	31 d2                	xor    %edx,%edx
  80468d:	f7 f5                	div    %ebp
  80468f:	89 c8                	mov    %ecx,%eax
  804691:	f7 f5                	div    %ebp
  804693:	89 d0                	mov    %edx,%eax
  804695:	e9 44 ff ff ff       	jmp    8045de <__umoddi3+0x3e>
  80469a:	66 90                	xchg   %ax,%ax
  80469c:	89 c8                	mov    %ecx,%eax
  80469e:	89 f2                	mov    %esi,%edx
  8046a0:	83 c4 1c             	add    $0x1c,%esp
  8046a3:	5b                   	pop    %ebx
  8046a4:	5e                   	pop    %esi
  8046a5:	5f                   	pop    %edi
  8046a6:	5d                   	pop    %ebp
  8046a7:	c3                   	ret    
  8046a8:	3b 04 24             	cmp    (%esp),%eax
  8046ab:	72 06                	jb     8046b3 <__umoddi3+0x113>
  8046ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8046b1:	77 0f                	ja     8046c2 <__umoddi3+0x122>
  8046b3:	89 f2                	mov    %esi,%edx
  8046b5:	29 f9                	sub    %edi,%ecx
  8046b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8046bb:	89 14 24             	mov    %edx,(%esp)
  8046be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8046c6:	8b 14 24             	mov    (%esp),%edx
  8046c9:	83 c4 1c             	add    $0x1c,%esp
  8046cc:	5b                   	pop    %ebx
  8046cd:	5e                   	pop    %esi
  8046ce:	5f                   	pop    %edi
  8046cf:	5d                   	pop    %ebp
  8046d0:	c3                   	ret    
  8046d1:	8d 76 00             	lea    0x0(%esi),%esi
  8046d4:	2b 04 24             	sub    (%esp),%eax
  8046d7:	19 fa                	sbb    %edi,%edx
  8046d9:	89 d1                	mov    %edx,%ecx
  8046db:	89 c6                	mov    %eax,%esi
  8046dd:	e9 71 ff ff ff       	jmp    804653 <__umoddi3+0xb3>
  8046e2:	66 90                	xchg   %ax,%ax
  8046e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8046e8:	72 ea                	jb     8046d4 <__umoddi3+0x134>
  8046ea:	89 d9                	mov    %ebx,%ecx
  8046ec:	e9 62 ff ff ff       	jmp    804653 <__umoddi3+0xb3>
