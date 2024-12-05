
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
  80005e:	e8 00 21 00 00       	call   802163 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 e0 45 80 00       	push   $0x8045e0
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 e4 45 80 00       	push   $0x8045e4
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 08 46 80 00       	push   $0x804608
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 e4 45 80 00       	push   $0x8045e4
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 e0 45 80 00       	push   $0x8045e0
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 2c 46 80 00       	push   $0x80462c
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
  8000e6:	68 4c 46 80 00       	push   $0x80464c
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 6e 46 80 00       	push   $0x80466e
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 7c 46 80 00       	push   $0x80467c
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 8a 46 80 00       	push   $0x80468a
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 9a 46 80 00       	push   $0x80469a
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
  80017a:	68 a4 46 80 00       	push   $0x8046a4
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
  8001a0:	e8 d8 1f 00 00       	call   80217d <sys_unlock_cons>

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
  8002d2:	e8 8c 1e 00 00       	call   802163 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 c8 46 80 00       	push   $0x8046c8
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 e6 46 80 00       	push   $0x8046e6
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 fd 46 80 00       	push   $0x8046fd
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 14 47 80 00       	push   $0x804714
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 9a 46 80 00       	push   $0x80469a
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
  80035e:	e8 1a 1e 00 00       	call   80217d <sys_unlock_cons>


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
  8003df:	e8 7f 1d 00 00       	call   802163 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 2b 47 80 00       	push   $0x80472b
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 84 1d 00 00       	call   80217d <sys_unlock_cons>

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
  80048e:	e8 d0 1c 00 00       	call   802163 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 44 47 80 00       	push   $0x804744
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
  8004c8:	e8 b0 1c 00 00       	call   80217d <sys_unlock_cons>

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
  8008bf:	e8 67 1b 00 00       	call   80242b <sys_get_virtual_time>
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
  80092b:	68 62 47 80 00       	push   $0x804762
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
  800946:	68 69 47 80 00       	push   $0x804769
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
  80099c:	68 6d 47 80 00       	push   $0x80476d
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
  8009b7:	68 69 47 80 00       	push   $0x804769
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
  8009e6:	e8 c3 18 00 00       	call   8022ae <sys_cputc>
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
  8009f7:	e8 4e 17 00 00       	call   80214a <sys_cgetc>
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
  800a14:	e8 c6 19 00 00       	call   8023df <sys_getenvindex>
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
  800a82:	e8 dc 16 00 00       	call   802163 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 90 47 80 00       	push   $0x804790
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
  800ab2:	68 b8 47 80 00       	push   $0x8047b8
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
  800ae3:	68 e0 47 80 00       	push   $0x8047e0
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 50 80 00       	mov    0x805020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 38 48 80 00       	push   $0x804838
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 90 47 80 00       	push   $0x804790
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 5c 16 00 00       	call   80217d <sys_unlock_cons>
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
  800b34:	e8 72 18 00 00       	call   8023ab <sys_destroy_env>
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
  800b45:	e8 c7 18 00 00       	call   802411 <sys_exit_env>
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
  800b93:	e8 89 15 00 00       	call   802121 <sys_cputs>
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
  800c0a:	e8 12 15 00 00       	call   802121 <sys_cputs>
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
  800c54:	e8 0a 15 00 00       	call   802163 <sys_lock_cons>
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
  800c74:	e8 04 15 00 00       	call   80217d <sys_unlock_cons>
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
  800cbe:	e8 ad 36 00 00       	call   804370 <__udivdi3>
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
  800d0e:	e8 6d 37 00 00       	call   804480 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 74 4a 80 00       	add    $0x804a74,%eax
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
  800e69:	8b 04 85 98 4a 80 00 	mov    0x804a98(,%eax,4),%eax
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
  800f4a:	8b 34 9d e0 48 80 00 	mov    0x8048e0(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 85 4a 80 00       	push   $0x804a85
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
  800f6f:	68 8e 4a 80 00       	push   $0x804a8e
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
  800f9c:	be 91 4a 80 00       	mov    $0x804a91,%esi
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
  8012c7:	68 08 4c 80 00       	push   $0x804c08
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
  801309:	68 0b 4c 80 00       	push   $0x804c0b
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
  8013ba:	e8 a4 0d 00 00       	call   802163 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 08 4c 80 00       	push   $0x804c08
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
  80140d:	68 0b 4c 80 00       	push   $0x804c0b
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
  8014b5:	e8 c3 0c 00 00       	call   80217d <sys_unlock_cons>
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
  801baf:	68 1c 4c 80 00       	push   $0x804c1c
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 3e 4c 80 00       	push   $0x804c3e
  801bbe:	e8 c2 25 00 00       	call   804185 <_panic>

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
  801bcf:	e8 f8 0a 00 00       	call   8026cc <sys_sbrk>
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
  801c4a:	e8 01 09 00 00       	call   802550 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 41 0e 00 00       	call   802a9f <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 13 09 00 00       	call   802581 <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 da 12 00 00       	call   802f5b <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	05 00 10 00 00       	add    $0x1000,%eax
  801ce3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801ce6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  801d86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d8a:	75 16                	jne    801da2 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801d8c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801d93:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801d9a:	0f 86 15 ff ff ff    	jbe    801cb5 <malloc+0xdc>
  801da0:	eb 01                	jmp    801da3 <malloc+0x1ca>
				}
				

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
  801de2:	e8 1c 09 00 00       	call   802703 <sys_allocate_user_mem>
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	eb 07                	jmp    801df3 <malloc+0x21a>
		
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
  801e2a:	e8 f0 08 00 00       	call   80271f <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 00 1b 00 00       	call   803940 <free_block>
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
  801e8f:	eb 42                	jmp    801ed3 <free+0xdb>
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
			sys_free_user_mem((uint32)va, k);
  801ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	83 ec 08             	sub    $0x8,%esp
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	e8 1a 08 00 00       	call   8026e7 <sys_free_user_mem>
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
  801ee0:	68 4c 4c 80 00       	push   $0x804c4c
  801ee5:	68 87 00 00 00       	push   $0x87
  801eea:	68 76 4c 80 00       	push   $0x804c76
  801eef:	e8 91 22 00 00       	call   804185 <_panic>
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
  801f0e:	e9 87 00 00 00       	jmp    801f9a <smalloc+0xa3>
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
  801f3f:	75 07                	jne    801f48 <smalloc+0x51>
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	eb 52                	jmp    801f9a <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f48:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f4c:	ff 75 ec             	pushl  -0x14(%ebp)
  801f4f:	50                   	push   %eax
  801f50:	ff 75 0c             	pushl  0xc(%ebp)
  801f53:	ff 75 08             	pushl  0x8(%ebp)
  801f56:	e8 93 03 00 00       	call   8022ee <sys_createSharedObject>
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f61:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f65:	74 06                	je     801f6d <smalloc+0x76>
  801f67:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f6b:	75 07                	jne    801f74 <smalloc+0x7d>
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	eb 26                	jmp    801f9a <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f77:	a1 20 50 80 00       	mov    0x805020,%eax
  801f7c:	8b 40 78             	mov    0x78(%eax),%eax
  801f7f:	29 c2                	sub    %eax,%edx
  801f81:	89 d0                	mov    %edx,%eax
  801f83:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f88:	c1 e8 0c             	shr    $0xc,%eax
  801f8b:	89 c2                	mov    %eax,%edx
  801f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f90:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fa2:	83 ec 08             	sub    $0x8,%esp
  801fa5:	ff 75 0c             	pushl  0xc(%ebp)
  801fa8:	ff 75 08             	pushl  0x8(%ebp)
  801fab:	e8 68 03 00 00       	call   802318 <sys_getSizeOfSharedObject>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801fb6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fba:	75 07                	jne    801fc3 <sget+0x27>
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	eb 7f                	jmp    802042 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fc9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd6:	39 d0                	cmp    %edx,%eax
  801fd8:	73 02                	jae    801fdc <sget+0x40>
  801fda:	89 d0                	mov    %edx,%eax
  801fdc:	83 ec 0c             	sub    $0xc,%esp
  801fdf:	50                   	push   %eax
  801fe0:	e8 f4 fb ff ff       	call   801bd9 <malloc>
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801feb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fef:	75 07                	jne    801ff8 <sget+0x5c>
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff6:	eb 4a                	jmp    802042 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	e8 2c 03 00 00       	call   802335 <sys_getSharedObject>
  802009:	83 c4 10             	add    $0x10,%esp
  80200c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80200f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802012:	a1 20 50 80 00       	mov    0x805020,%eax
  802017:	8b 40 78             	mov    0x78(%eax),%eax
  80201a:	29 c2                	sub    %eax,%edx
  80201c:	89 d0                	mov    %edx,%eax
  80201e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802023:	c1 e8 0c             	shr    $0xc,%eax
  802026:	89 c2                	mov    %eax,%edx
  802028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80202b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802032:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802036:	75 07                	jne    80203f <sget+0xa3>
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
  80203d:	eb 03                	jmp    802042 <sget+0xa6>
	return ptr;
  80203f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80204a:	8b 55 08             	mov    0x8(%ebp),%edx
  80204d:	a1 20 50 80 00       	mov    0x805020,%eax
  802052:	8b 40 78             	mov    0x78(%eax),%eax
  802055:	29 c2                	sub    %eax,%edx
  802057:	89 d0                	mov    %edx,%eax
  802059:	2d 00 10 00 00       	sub    $0x1000,%eax
  80205e:	c1 e8 0c             	shr    $0xc,%eax
  802061:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802068:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80206b:	83 ec 08             	sub    $0x8,%esp
  80206e:	ff 75 08             	pushl  0x8(%ebp)
  802071:	ff 75 f4             	pushl  -0xc(%ebp)
  802074:	e8 db 02 00 00       	call   802354 <sys_freeSharedObject>
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80207f:	90                   	nop
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	68 84 4c 80 00       	push   $0x804c84
  802090:	68 e4 00 00 00       	push   $0xe4
  802095:	68 76 4c 80 00       	push   $0x804c76
  80209a:	e8 e6 20 00 00       	call   804185 <_panic>

0080209f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 aa 4c 80 00       	push   $0x804caa
  8020ad:	68 f0 00 00 00       	push   $0xf0
  8020b2:	68 76 4c 80 00       	push   $0x804c76
  8020b7:	e8 c9 20 00 00       	call   804185 <_panic>

008020bc <shrink>:

}
void shrink(uint32 newSize)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	68 aa 4c 80 00       	push   $0x804caa
  8020ca:	68 f5 00 00 00       	push   $0xf5
  8020cf:	68 76 4c 80 00       	push   $0x804c76
  8020d4:	e8 ac 20 00 00       	call   804185 <_panic>

008020d9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	68 aa 4c 80 00       	push   $0x804caa
  8020e7:	68 fa 00 00 00       	push   $0xfa
  8020ec:	68 76 4c 80 00       	push   $0x804c76
  8020f1:	e8 8f 20 00 00       	call   804185 <_panic>

008020f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	57                   	push   %edi
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	8b 55 0c             	mov    0xc(%ebp),%edx
  802105:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802108:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80210b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80210e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802111:	cd 30                	int    $0x30
  802113:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802116:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	8b 45 10             	mov    0x10(%ebp),%eax
  80212a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80212d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	52                   	push   %edx
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	50                   	push   %eax
  80213d:	6a 00                	push   $0x0
  80213f:	e8 b2 ff ff ff       	call   8020f6 <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	90                   	nop
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_cgetc>:

int
sys_cgetc(void)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 02                	push   $0x2
  802159:	e8 98 ff ff ff       	call   8020f6 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 03                	push   $0x3
  802172:	e8 7f ff ff ff       	call   8020f6 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	90                   	nop
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 04                	push   $0x4
  80218c:	e8 65 ff ff ff       	call   8020f6 <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	90                   	nop
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80219a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	6a 08                	push   $0x8
  8021aa:	e8 47 ff ff ff       	call   8020f6 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8021bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	56                   	push   %esi
  8021c9:	53                   	push   %ebx
  8021ca:	51                   	push   %ecx
  8021cb:	52                   	push   %edx
  8021cc:	50                   	push   %eax
  8021cd:	6a 09                	push   $0x9
  8021cf:	e8 22 ff ff ff       	call   8020f6 <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021da:	5b                   	pop    %ebx
  8021db:	5e                   	pop    %esi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	52                   	push   %edx
  8021ee:	50                   	push   %eax
  8021ef:	6a 0a                	push   $0xa
  8021f1:	e8 00 ff ff ff       	call   8020f6 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	ff 75 0c             	pushl  0xc(%ebp)
  802207:	ff 75 08             	pushl  0x8(%ebp)
  80220a:	6a 0b                	push   $0xb
  80220c:	e8 e5 fe ff ff       	call   8020f6 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 0c                	push   $0xc
  802225:	e8 cc fe ff ff       	call   8020f6 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 0d                	push   $0xd
  80223e:	e8 b3 fe ff ff       	call   8020f6 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 0e                	push   $0xe
  802257:	e8 9a fe ff ff       	call   8020f6 <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 0f                	push   $0xf
  802270:	e8 81 fe ff ff       	call   8020f6 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	ff 75 08             	pushl  0x8(%ebp)
  802288:	6a 10                	push   $0x10
  80228a:	e8 67 fe ff ff       	call   8020f6 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 11                	push   $0x11
  8022a3:	e8 4e fe ff ff       	call   8020f6 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	90                   	nop
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_cputc>:

void
sys_cputc(const char c)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022ba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	50                   	push   %eax
  8022c7:	6a 01                	push   $0x1
  8022c9:	e8 28 fe ff ff       	call   8020f6 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
}
  8022d1:	90                   	nop
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 14                	push   $0x14
  8022e3:	e8 0e fe ff ff       	call   8020f6 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 04             	sub    $0x4,%esp
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	6a 00                	push   $0x0
  802306:	51                   	push   %ecx
  802307:	52                   	push   %edx
  802308:	ff 75 0c             	pushl  0xc(%ebp)
  80230b:	50                   	push   %eax
  80230c:	6a 15                	push   $0x15
  80230e:	e8 e3 fd ff ff       	call   8020f6 <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80231b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	52                   	push   %edx
  802328:	50                   	push   %eax
  802329:	6a 16                	push   $0x16
  80232b:	e8 c6 fd ff ff       	call   8020f6 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802338:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	51                   	push   %ecx
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	6a 17                	push   $0x17
  80234a:	e8 a7 fd ff ff       	call   8020f6 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	52                   	push   %edx
  802364:	50                   	push   %eax
  802365:	6a 18                	push   $0x18
  802367:	e8 8a fd ff ff       	call   8020f6 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	ff 75 14             	pushl  0x14(%ebp)
  80237c:	ff 75 10             	pushl  0x10(%ebp)
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	50                   	push   %eax
  802383:	6a 19                	push   $0x19
  802385:	e8 6c fd ff ff       	call   8020f6 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	50                   	push   %eax
  80239e:	6a 1a                	push   $0x1a
  8023a0:	e8 51 fd ff ff       	call   8020f6 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	90                   	nop
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	50                   	push   %eax
  8023ba:	6a 1b                	push   $0x1b
  8023bc:	e8 35 fd ff ff       	call   8020f6 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 05                	push   $0x5
  8023d5:	e8 1c fd ff ff       	call   8020f6 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 06                	push   $0x6
  8023ee:	e8 03 fd ff ff       	call   8020f6 <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 07                	push   $0x7
  802407:	e8 ea fc ff ff       	call   8020f6 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_exit_env>:


void sys_exit_env(void)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 1c                	push   $0x1c
  802420:	e8 d1 fc ff ff       	call   8020f6 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	90                   	nop
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802431:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802434:	8d 50 04             	lea    0x4(%eax),%edx
  802437:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	52                   	push   %edx
  802441:	50                   	push   %eax
  802442:	6a 1d                	push   $0x1d
  802444:	e8 ad fc ff ff       	call   8020f6 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
	return result;
  80244c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80244f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802452:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802455:	89 01                	mov    %eax,(%ecx)
  802457:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	c9                   	leave  
  80245e:	c2 04 00             	ret    $0x4

00802461 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	ff 75 10             	pushl  0x10(%ebp)
  80246b:	ff 75 0c             	pushl  0xc(%ebp)
  80246e:	ff 75 08             	pushl  0x8(%ebp)
  802471:	6a 13                	push   $0x13
  802473:	e8 7e fc ff ff       	call   8020f6 <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
	return ;
  80247b:	90                   	nop
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_rcr2>:
uint32 sys_rcr2()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 1e                	push   $0x1e
  80248d:	e8 64 fc ff ff       	call   8020f6 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	50                   	push   %eax
  8024b0:	6a 1f                	push   $0x1f
  8024b2:	e8 3f fc ff ff       	call   8020f6 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ba:	90                   	nop
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <rsttst>:
void rsttst()
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 21                	push   $0x21
  8024cc:	e8 25 fc ff ff       	call   8020f6 <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d4:	90                   	nop
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8024e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024ea:	52                   	push   %edx
  8024eb:	50                   	push   %eax
  8024ec:	ff 75 10             	pushl  0x10(%ebp)
  8024ef:	ff 75 0c             	pushl  0xc(%ebp)
  8024f2:	ff 75 08             	pushl  0x8(%ebp)
  8024f5:	6a 20                	push   $0x20
  8024f7:	e8 fa fb ff ff       	call   8020f6 <syscall>
  8024fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ff:	90                   	nop
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <chktst>:
void chktst(uint32 n)
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	ff 75 08             	pushl  0x8(%ebp)
  802510:	6a 22                	push   $0x22
  802512:	e8 df fb ff ff       	call   8020f6 <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
	return ;
  80251a:	90                   	nop
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <inctst>:

void inctst()
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 23                	push   $0x23
  80252c:	e8 c5 fb ff ff       	call   8020f6 <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
	return ;
  802534:	90                   	nop
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <gettst>:
uint32 gettst()
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 24                	push   $0x24
  802546:	e8 ab fb ff ff       	call   8020f6 <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 25                	push   $0x25
  802562:	e8 8f fb ff ff       	call   8020f6 <syscall>
  802567:	83 c4 18             	add    $0x18,%esp
  80256a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80256d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802571:	75 07                	jne    80257a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802573:	b8 01 00 00 00       	mov    $0x1,%eax
  802578:	eb 05                	jmp    80257f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 25                	push   $0x25
  802593:	e8 5e fb ff ff       	call   8020f6 <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
  80259b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80259e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025a2:	75 07                	jne    8025ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a9:	eb 05                	jmp    8025b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 25                	push   $0x25
  8025c4:	e8 2d fb ff ff       	call   8020f6 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
  8025cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025d3:	75 07                	jne    8025dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025da:	eb 05                	jmp    8025e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 25                	push   $0x25
  8025f5:	e8 fc fa ff ff       	call   8020f6 <syscall>
  8025fa:	83 c4 18             	add    $0x18,%esp
  8025fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802600:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802604:	75 07                	jne    80260d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802606:	b8 01 00 00 00       	mov    $0x1,%eax
  80260b:	eb 05                	jmp    802612 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	ff 75 08             	pushl  0x8(%ebp)
  802622:	6a 26                	push   $0x26
  802624:	e8 cd fa ff ff       	call   8020f6 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
	return ;
  80262c:	90                   	nop
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802633:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802636:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	6a 00                	push   $0x0
  802641:	53                   	push   %ebx
  802642:	51                   	push   %ecx
  802643:	52                   	push   %edx
  802644:	50                   	push   %eax
  802645:	6a 27                	push   $0x27
  802647:	e8 aa fa ff ff       	call   8020f6 <syscall>
  80264c:	83 c4 18             	add    $0x18,%esp
}
  80264f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	52                   	push   %edx
  802664:	50                   	push   %eax
  802665:	6a 28                	push   $0x28
  802667:	e8 8a fa ff ff       	call   8020f6 <syscall>
  80266c:	83 c4 18             	add    $0x18,%esp
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802674:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	6a 00                	push   $0x0
  80267f:	51                   	push   %ecx
  802680:	ff 75 10             	pushl  0x10(%ebp)
  802683:	52                   	push   %edx
  802684:	50                   	push   %eax
  802685:	6a 29                	push   $0x29
  802687:	e8 6a fa ff ff       	call   8020f6 <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	ff 75 10             	pushl  0x10(%ebp)
  80269b:	ff 75 0c             	pushl  0xc(%ebp)
  80269e:	ff 75 08             	pushl  0x8(%ebp)
  8026a1:	6a 12                	push   $0x12
  8026a3:	e8 4e fa ff ff       	call   8020f6 <syscall>
  8026a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ab:	90                   	nop
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	52                   	push   %edx
  8026be:	50                   	push   %eax
  8026bf:	6a 2a                	push   $0x2a
  8026c1:	e8 30 fa ff ff       	call   8020f6 <syscall>
  8026c6:	83 c4 18             	add    $0x18,%esp
	return;
  8026c9:	90                   	nop
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	50                   	push   %eax
  8026db:	6a 2b                	push   $0x2b
  8026dd:	e8 14 fa ff ff       	call   8020f6 <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
}
  8026e5:	c9                   	leave  
  8026e6:	c3                   	ret    

008026e7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	ff 75 0c             	pushl  0xc(%ebp)
  8026f3:	ff 75 08             	pushl  0x8(%ebp)
  8026f6:	6a 2c                	push   $0x2c
  8026f8:	e8 f9 f9 ff ff       	call   8020f6 <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
	return;
  802700:	90                   	nop
}
  802701:	c9                   	leave  
  802702:	c3                   	ret    

00802703 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	ff 75 0c             	pushl  0xc(%ebp)
  80270f:	ff 75 08             	pushl  0x8(%ebp)
  802712:	6a 2d                	push   $0x2d
  802714:	e8 dd f9 ff ff       	call   8020f6 <syscall>
  802719:	83 c4 18             	add    $0x18,%esp
	return;
  80271c:	90                   	nop
}
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    

0080271f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	83 e8 04             	sub    $0x4,%eax
  80272b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80272e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
  80273b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	83 e8 04             	sub    $0x4,%eax
  802744:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802747:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	83 e0 01             	and    $0x1,%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	0f 94 c0             	sete   %al
}
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80275c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802763:	8b 45 0c             	mov    0xc(%ebp),%eax
  802766:	83 f8 02             	cmp    $0x2,%eax
  802769:	74 2b                	je     802796 <alloc_block+0x40>
  80276b:	83 f8 02             	cmp    $0x2,%eax
  80276e:	7f 07                	jg     802777 <alloc_block+0x21>
  802770:	83 f8 01             	cmp    $0x1,%eax
  802773:	74 0e                	je     802783 <alloc_block+0x2d>
  802775:	eb 58                	jmp    8027cf <alloc_block+0x79>
  802777:	83 f8 03             	cmp    $0x3,%eax
  80277a:	74 2d                	je     8027a9 <alloc_block+0x53>
  80277c:	83 f8 04             	cmp    $0x4,%eax
  80277f:	74 3b                	je     8027bc <alloc_block+0x66>
  802781:	eb 4c                	jmp    8027cf <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	ff 75 08             	pushl  0x8(%ebp)
  802789:	e8 11 03 00 00       	call   802a9f <alloc_block_FF>
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802794:	eb 4a                	jmp    8027e0 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	ff 75 08             	pushl  0x8(%ebp)
  80279c:	e8 c7 19 00 00       	call   804168 <alloc_block_NF>
  8027a1:	83 c4 10             	add    $0x10,%esp
  8027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a7:	eb 37                	jmp    8027e0 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	ff 75 08             	pushl  0x8(%ebp)
  8027af:	e8 a7 07 00 00       	call   802f5b <alloc_block_BF>
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027ba:	eb 24                	jmp    8027e0 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027bc:	83 ec 0c             	sub    $0xc,%esp
  8027bf:	ff 75 08             	pushl  0x8(%ebp)
  8027c2:	e8 84 19 00 00       	call   80414b <alloc_block_WF>
  8027c7:	83 c4 10             	add    $0x10,%esp
  8027ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027cd:	eb 11                	jmp    8027e0 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	68 bc 4c 80 00       	push   $0x804cbc
  8027d7:	e8 45 e4 ff ff       	call   800c21 <cprintf>
  8027dc:	83 c4 10             	add    $0x10,%esp
		break;
  8027df:	90                   	nop
	}
	return va;
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	53                   	push   %ebx
  8027e9:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027ec:	83 ec 0c             	sub    $0xc,%esp
  8027ef:	68 dc 4c 80 00       	push   $0x804cdc
  8027f4:	e8 28 e4 ff ff       	call   800c21 <cprintf>
  8027f9:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027fc:	83 ec 0c             	sub    $0xc,%esp
  8027ff:	68 07 4d 80 00       	push   $0x804d07
  802804:	e8 18 e4 ff ff       	call   800c21 <cprintf>
  802809:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802812:	eb 37                	jmp    80284b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	ff 75 f4             	pushl  -0xc(%ebp)
  80281a:	e8 19 ff ff ff       	call   802738 <is_free_block>
  80281f:	83 c4 10             	add    $0x10,%esp
  802822:	0f be d8             	movsbl %al,%ebx
  802825:	83 ec 0c             	sub    $0xc,%esp
  802828:	ff 75 f4             	pushl  -0xc(%ebp)
  80282b:	e8 ef fe ff ff       	call   80271f <get_block_size>
  802830:	83 c4 10             	add    $0x10,%esp
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	53                   	push   %ebx
  802837:	50                   	push   %eax
  802838:	68 1f 4d 80 00       	push   $0x804d1f
  80283d:	e8 df e3 ff ff       	call   800c21 <cprintf>
  802842:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802845:	8b 45 10             	mov    0x10(%ebp),%eax
  802848:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	74 07                	je     802858 <print_blocks_list+0x73>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	eb 05                	jmp    80285d <print_blocks_list+0x78>
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
  80285d:	89 45 10             	mov    %eax,0x10(%ebp)
  802860:	8b 45 10             	mov    0x10(%ebp),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	75 ad                	jne    802814 <print_blocks_list+0x2f>
  802867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286b:	75 a7                	jne    802814 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80286d:	83 ec 0c             	sub    $0xc,%esp
  802870:	68 dc 4c 80 00       	push   $0x804cdc
  802875:	e8 a7 e3 ff ff       	call   800c21 <cprintf>
  80287a:	83 c4 10             	add    $0x10,%esp

}
  80287d:	90                   	nop
  80287e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288c:	83 e0 01             	and    $0x1,%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 03                	je     802896 <initialize_dynamic_allocator+0x13>
  802893:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802896:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80289a:	0f 84 c7 01 00 00    	je     802a67 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8028a0:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8028a7:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8028aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b0:	01 d0                	add    %edx,%eax
  8028b2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028b7:	0f 87 ad 01 00 00    	ja     802a6a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	0f 89 a5 01 00 00    	jns    802a6d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	83 e8 04             	sub    $0x4,%eax
  8028d3:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8028d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028df:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e7:	e9 87 00 00 00       	jmp    802973 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	75 14                	jne    802906 <initialize_dynamic_allocator+0x83>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 37 4d 80 00       	push   $0x804d37
  8028fa:	6a 79                	push   $0x79
  8028fc:	68 55 4d 80 00       	push   $0x804d55
  802901:	e8 7f 18 00 00       	call   804185 <_panic>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	74 10                	je     80291f <initialize_dynamic_allocator+0x9c>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802917:	8b 52 04             	mov    0x4(%edx),%edx
  80291a:	89 50 04             	mov    %edx,0x4(%eax)
  80291d:	eb 0b                	jmp    80292a <initialize_dynamic_allocator+0xa7>
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	a3 30 50 80 00       	mov    %eax,0x805030
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 04             	mov    0x4(%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 0f                	je     802943 <initialize_dynamic_allocator+0xc0>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 04             	mov    0x4(%eax),%eax
  80293a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293d:	8b 12                	mov    (%edx),%edx
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	eb 0a                	jmp    80294d <initialize_dynamic_allocator+0xca>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802960:	a1 38 50 80 00       	mov    0x805038,%eax
  802965:	48                   	dec    %eax
  802966:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80296b:	a1 34 50 80 00       	mov    0x805034,%eax
  802970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802977:	74 07                	je     802980 <initialize_dynamic_allocator+0xfd>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	eb 05                	jmp    802985 <initialize_dynamic_allocator+0x102>
  802980:	b8 00 00 00 00       	mov    $0x0,%eax
  802985:	a3 34 50 80 00       	mov    %eax,0x805034
  80298a:	a1 34 50 80 00       	mov    0x805034,%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	0f 85 55 ff ff ff    	jne    8028ec <initialize_dynamic_allocator+0x69>
  802997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299b:	0f 85 4b ff ff ff    	jne    8028ec <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8029a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029aa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8029b0:	a1 44 50 80 00       	mov    0x805044,%eax
  8029b5:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8029ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8029bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	83 c0 08             	add    $0x8,%eax
  8029cb:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	83 c0 04             	add    $0x4,%eax
  8029d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d7:	83 ea 08             	sub    $0x8,%edx
  8029da:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	01 d0                	add    %edx,%eax
  8029e4:	83 e8 08             	sub    $0x8,%eax
  8029e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ea:	83 ea 08             	sub    $0x8,%edx
  8029ed:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a06:	75 17                	jne    802a1f <initialize_dynamic_allocator+0x19c>
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 70 4d 80 00       	push   $0x804d70
  802a10:	68 90 00 00 00       	push   $0x90
  802a15:	68 55 4d 80 00       	push   $0x804d55
  802a1a:	e8 66 17 00 00       	call   804185 <_panic>
  802a1f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a28:	89 10                	mov    %edx,(%eax)
  802a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 0d                	je     802a40 <initialize_dynamic_allocator+0x1bd>
  802a33:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a3b:	89 50 04             	mov    %edx,0x4(%eax)
  802a3e:	eb 08                	jmp    802a48 <initialize_dynamic_allocator+0x1c5>
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	a3 30 50 80 00       	mov    %eax,0x805030
  802a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5f:	40                   	inc    %eax
  802a60:	a3 38 50 80 00       	mov    %eax,0x805038
  802a65:	eb 07                	jmp    802a6e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a67:	90                   	nop
  802a68:	eb 04                	jmp    802a6e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a6a:	90                   	nop
  802a6b:	eb 01                	jmp    802a6e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a6d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a6e:	c9                   	leave  
  802a6f:	c3                   	ret    

00802a70 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a73:	8b 45 10             	mov    0x10(%ebp),%eax
  802a76:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a82:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	83 e8 04             	sub    $0x4,%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	83 e0 fe             	and    $0xfffffffe,%eax
  802a8f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	01 c2                	add    %eax,%edx
  802a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a9a:	89 02                	mov    %eax,(%edx)
}
  802a9c:	90                   	nop
  802a9d:	5d                   	pop    %ebp
  802a9e:	c3                   	ret    

00802a9f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	83 e0 01             	and    $0x1,%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	74 03                	je     802ab2 <alloc_block_FF+0x13>
  802aaf:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ab2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ab6:	77 07                	ja     802abf <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ab8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802abf:	a1 24 50 80 00       	mov    0x805024,%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	75 73                	jne    802b3b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	83 c0 10             	add    $0x10,%eax
  802ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ad1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	01 d0                	add    %edx,%eax
  802ae0:	48                   	dec    %eax
  802ae1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  802aec:	f7 75 ec             	divl   -0x14(%ebp)
  802aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af2:	29 d0                	sub    %edx,%eax
  802af4:	c1 e8 0c             	shr    $0xc,%eax
  802af7:	83 ec 0c             	sub    $0xc,%esp
  802afa:	50                   	push   %eax
  802afb:	e8 c3 f0 ff ff       	call   801bc3 <sbrk>
  802b00:	83 c4 10             	add    $0x10,%esp
  802b03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b06:	83 ec 0c             	sub    $0xc,%esp
  802b09:	6a 00                	push   $0x0
  802b0b:	e8 b3 f0 ff ff       	call   801bc3 <sbrk>
  802b10:	83 c4 10             	add    $0x10,%esp
  802b13:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b19:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b1c:	83 ec 08             	sub    $0x8,%esp
  802b1f:	50                   	push   %eax
  802b20:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b23:	e8 5b fd ff ff       	call   802883 <initialize_dynamic_allocator>
  802b28:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b2b:	83 ec 0c             	sub    $0xc,%esp
  802b2e:	68 93 4d 80 00       	push   $0x804d93
  802b33:	e8 e9 e0 ff ff       	call   800c21 <cprintf>
  802b38:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3f:	75 0a                	jne    802b4b <alloc_block_FF+0xac>
	        return NULL;
  802b41:	b8 00 00 00 00       	mov    $0x0,%eax
  802b46:	e9 0e 04 00 00       	jmp    802f59 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b52:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5a:	e9 f3 02 00 00       	jmp    802e52 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b65:	83 ec 0c             	sub    $0xc,%esp
  802b68:	ff 75 bc             	pushl  -0x44(%ebp)
  802b6b:	e8 af fb ff ff       	call   80271f <get_block_size>
  802b70:	83 c4 10             	add    $0x10,%esp
  802b73:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	83 c0 08             	add    $0x8,%eax
  802b7c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b7f:	0f 87 c5 02 00 00    	ja     802e4a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	83 c0 18             	add    $0x18,%eax
  802b8b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b8e:	0f 87 19 02 00 00    	ja     802dad <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b94:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b97:	2b 45 08             	sub    0x8(%ebp),%eax
  802b9a:	83 e8 08             	sub    $0x8,%eax
  802b9d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	8d 50 08             	lea    0x8(%eax),%edx
  802ba6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ba9:	01 d0                	add    %edx,%eax
  802bab:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	83 c0 08             	add    $0x8,%eax
  802bb4:	83 ec 04             	sub    $0x4,%esp
  802bb7:	6a 01                	push   $0x1
  802bb9:	50                   	push   %eax
  802bba:	ff 75 bc             	pushl  -0x44(%ebp)
  802bbd:	e8 ae fe ff ff       	call   802a70 <set_block_data>
  802bc2:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	75 68                	jne    802c37 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bcf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bd3:	75 17                	jne    802bec <alloc_block_FF+0x14d>
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	68 70 4d 80 00       	push   $0x804d70
  802bdd:	68 d7 00 00 00       	push   $0xd7
  802be2:	68 55 4d 80 00       	push   $0x804d55
  802be7:	e8 99 15 00 00       	call   804185 <_panic>
  802bec:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bf2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0d                	je     802c0d <alloc_block_FF+0x16e>
  802c00:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c05:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 08                	jmp    802c15 <alloc_block_FF+0x176>
  802c0d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c10:	a3 30 50 80 00       	mov    %eax,0x805030
  802c15:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c18:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 38 50 80 00       	mov    0x805038,%eax
  802c2c:	40                   	inc    %eax
  802c2d:	a3 38 50 80 00       	mov    %eax,0x805038
  802c32:	e9 dc 00 00 00       	jmp    802d13 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	75 65                	jne    802ca5 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c40:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c44:	75 17                	jne    802c5d <alloc_block_FF+0x1be>
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	68 a4 4d 80 00       	push   $0x804da4
  802c4e:	68 db 00 00 00       	push   $0xdb
  802c53:	68 55 4d 80 00       	push   $0x804d55
  802c58:	e8 28 15 00 00       	call   804185 <_panic>
  802c5d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c66:	89 50 04             	mov    %edx,0x4(%eax)
  802c69:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 0c                	je     802c7f <alloc_block_FF+0x1e0>
  802c73:	a1 30 50 80 00       	mov    0x805030,%eax
  802c78:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	eb 08                	jmp    802c87 <alloc_block_FF+0x1e8>
  802c7f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c82:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c8f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c98:	a1 38 50 80 00       	mov    0x805038,%eax
  802c9d:	40                   	inc    %eax
  802c9e:	a3 38 50 80 00       	mov    %eax,0x805038
  802ca3:	eb 6e                	jmp    802d13 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca9:	74 06                	je     802cb1 <alloc_block_FF+0x212>
  802cab:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802caf:	75 17                	jne    802cc8 <alloc_block_FF+0x229>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 c8 4d 80 00       	push   $0x804dc8
  802cb9:	68 df 00 00 00       	push   $0xdf
  802cbe:	68 55 4d 80 00       	push   $0x804d55
  802cc3:	e8 bd 14 00 00       	call   804185 <_panic>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 10                	mov    (%eax),%edx
  802ccd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0b                	je     802ce6 <alloc_block_FF+0x247>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf4:	89 50 04             	mov    %edx,0x4(%eax)
  802cf7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	75 08                	jne    802d08 <alloc_block_FF+0x269>
  802d00:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d03:	a3 30 50 80 00       	mov    %eax,0x805030
  802d08:	a1 38 50 80 00       	mov    0x805038,%eax
  802d0d:	40                   	inc    %eax
  802d0e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d17:	75 17                	jne    802d30 <alloc_block_FF+0x291>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 37 4d 80 00       	push   $0x804d37
  802d21:	68 e1 00 00 00       	push   $0xe1
  802d26:	68 55 4d 80 00       	push   $0x804d55
  802d2b:	e8 55 14 00 00       	call   804185 <_panic>
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 10                	je     802d49 <alloc_block_FF+0x2aa>
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d41:	8b 52 04             	mov    0x4(%edx),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 0b                	jmp    802d54 <alloc_block_FF+0x2b5>
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0f                	je     802d6d <alloc_block_FF+0x2ce>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d67:	8b 12                	mov    (%edx),%edx
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	eb 0a                	jmp    802d77 <alloc_block_FF+0x2d8>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d8f:	48                   	dec    %eax
  802d90:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	6a 00                	push   $0x0
  802d9a:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d9d:	ff 75 b0             	pushl  -0x50(%ebp)
  802da0:	e8 cb fc ff ff       	call   802a70 <set_block_data>
  802da5:	83 c4 10             	add    $0x10,%esp
  802da8:	e9 95 00 00 00       	jmp    802e42 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802dad:	83 ec 04             	sub    $0x4,%esp
  802db0:	6a 01                	push   $0x1
  802db2:	ff 75 b8             	pushl  -0x48(%ebp)
  802db5:	ff 75 bc             	pushl  -0x44(%ebp)
  802db8:	e8 b3 fc ff ff       	call   802a70 <set_block_data>
  802dbd:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	75 17                	jne    802ddd <alloc_block_FF+0x33e>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 37 4d 80 00       	push   $0x804d37
  802dce:	68 e8 00 00 00       	push   $0xe8
  802dd3:	68 55 4d 80 00       	push   $0x804d55
  802dd8:	e8 a8 13 00 00       	call   804185 <_panic>
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 10                	je     802df6 <alloc_block_FF+0x357>
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dee:	8b 52 04             	mov    0x4(%edx),%edx
  802df1:	89 50 04             	mov    %edx,0x4(%eax)
  802df4:	eb 0b                	jmp    802e01 <alloc_block_FF+0x362>
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	a3 30 50 80 00       	mov    %eax,0x805030
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 0f                	je     802e1a <alloc_block_FF+0x37b>
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e14:	8b 12                	mov    (%edx),%edx
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	eb 0a                	jmp    802e24 <alloc_block_FF+0x385>
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e37:	a1 38 50 80 00       	mov    0x805038,%eax
  802e3c:	48                   	dec    %eax
  802e3d:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802e42:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e45:	e9 0f 01 00 00       	jmp    802f59 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e4a:	a1 34 50 80 00       	mov    0x805034,%eax
  802e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e56:	74 07                	je     802e5f <alloc_block_FF+0x3c0>
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	eb 05                	jmp    802e64 <alloc_block_FF+0x3c5>
  802e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e64:	a3 34 50 80 00       	mov    %eax,0x805034
  802e69:	a1 34 50 80 00       	mov    0x805034,%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	0f 85 e9 fc ff ff    	jne    802b5f <alloc_block_FF+0xc0>
  802e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7a:	0f 85 df fc ff ff    	jne    802b5f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	83 c0 08             	add    $0x8,%eax
  802e86:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e89:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e93:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e96:	01 d0                	add    %edx,%eax
  802e98:	48                   	dec    %eax
  802e99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea4:	f7 75 d8             	divl   -0x28(%ebp)
  802ea7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eaa:	29 d0                	sub    %edx,%eax
  802eac:	c1 e8 0c             	shr    $0xc,%eax
  802eaf:	83 ec 0c             	sub    $0xc,%esp
  802eb2:	50                   	push   %eax
  802eb3:	e8 0b ed ff ff       	call   801bc3 <sbrk>
  802eb8:	83 c4 10             	add    $0x10,%esp
  802ebb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ebe:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ec2:	75 0a                	jne    802ece <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec9:	e9 8b 00 00 00       	jmp    802f59 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ece:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ed5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ed8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802edb:	01 d0                	add    %edx,%eax
  802edd:	48                   	dec    %eax
  802ede:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ee1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee9:	f7 75 cc             	divl   -0x34(%ebp)
  802eec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802eef:	29 d0                	sub    %edx,%eax
  802ef1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ef4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ef7:	01 d0                	add    %edx,%eax
  802ef9:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802efe:	a1 40 50 80 00       	mov    0x805040,%eax
  802f03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f09:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f16:	01 d0                	add    %edx,%eax
  802f18:	48                   	dec    %eax
  802f19:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802f24:	f7 75 c4             	divl   -0x3c(%ebp)
  802f27:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f2a:	29 d0                	sub    %edx,%eax
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	6a 01                	push   $0x1
  802f31:	50                   	push   %eax
  802f32:	ff 75 d0             	pushl  -0x30(%ebp)
  802f35:	e8 36 fb ff ff       	call   802a70 <set_block_data>
  802f3a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f3d:	83 ec 0c             	sub    $0xc,%esp
  802f40:	ff 75 d0             	pushl  -0x30(%ebp)
  802f43:	e8 f8 09 00 00       	call   803940 <free_block>
  802f48:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f4b:	83 ec 0c             	sub    $0xc,%esp
  802f4e:	ff 75 08             	pushl  0x8(%ebp)
  802f51:	e8 49 fb ff ff       	call   802a9f <alloc_block_FF>
  802f56:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
  802f5e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	83 e0 01             	and    $0x1,%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	74 03                	je     802f6e <alloc_block_BF+0x13>
  802f6b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f6e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f72:	77 07                	ja     802f7b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f74:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f7b:	a1 24 50 80 00       	mov    0x805024,%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	75 73                	jne    802ff7 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	83 c0 10             	add    $0x10,%eax
  802f8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f8d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9a:	01 d0                	add    %edx,%eax
  802f9c:	48                   	dec    %eax
  802f9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa8:	f7 75 e0             	divl   -0x20(%ebp)
  802fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fae:	29 d0                	sub    %edx,%eax
  802fb0:	c1 e8 0c             	shr    $0xc,%eax
  802fb3:	83 ec 0c             	sub    $0xc,%esp
  802fb6:	50                   	push   %eax
  802fb7:	e8 07 ec ff ff       	call   801bc3 <sbrk>
  802fbc:	83 c4 10             	add    $0x10,%esp
  802fbf:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fc2:	83 ec 0c             	sub    $0xc,%esp
  802fc5:	6a 00                	push   $0x0
  802fc7:	e8 f7 eb ff ff       	call   801bc3 <sbrk>
  802fcc:	83 c4 10             	add    $0x10,%esp
  802fcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fd8:	83 ec 08             	sub    $0x8,%esp
  802fdb:	50                   	push   %eax
  802fdc:	ff 75 d8             	pushl  -0x28(%ebp)
  802fdf:	e8 9f f8 ff ff       	call   802883 <initialize_dynamic_allocator>
  802fe4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fe7:	83 ec 0c             	sub    $0xc,%esp
  802fea:	68 93 4d 80 00       	push   $0x804d93
  802fef:	e8 2d dc ff ff       	call   800c21 <cprintf>
  802ff4:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ff7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ffe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803005:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80300c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803013:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301b:	e9 1d 01 00 00       	jmp    80313d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803026:	83 ec 0c             	sub    $0xc,%esp
  803029:	ff 75 a8             	pushl  -0x58(%ebp)
  80302c:	e8 ee f6 ff ff       	call   80271f <get_block_size>
  803031:	83 c4 10             	add    $0x10,%esp
  803034:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	83 c0 08             	add    $0x8,%eax
  80303d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803040:	0f 87 ef 00 00 00    	ja     803135 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	83 c0 18             	add    $0x18,%eax
  80304c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80304f:	77 1d                	ja     80306e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803057:	0f 86 d8 00 00 00    	jbe    803135 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80305d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803060:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803063:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803066:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803069:	e9 c7 00 00 00       	jmp    803135 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	83 c0 08             	add    $0x8,%eax
  803074:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803077:	0f 85 9d 00 00 00    	jne    80311a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	6a 01                	push   $0x1
  803082:	ff 75 a4             	pushl  -0x5c(%ebp)
  803085:	ff 75 a8             	pushl  -0x58(%ebp)
  803088:	e8 e3 f9 ff ff       	call   802a70 <set_block_data>
  80308d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803094:	75 17                	jne    8030ad <alloc_block_BF+0x152>
  803096:	83 ec 04             	sub    $0x4,%esp
  803099:	68 37 4d 80 00       	push   $0x804d37
  80309e:	68 2c 01 00 00       	push   $0x12c
  8030a3:	68 55 4d 80 00       	push   $0x804d55
  8030a8:	e8 d8 10 00 00       	call   804185 <_panic>
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 10                	je     8030c6 <alloc_block_BF+0x16b>
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030be:	8b 52 04             	mov    0x4(%edx),%edx
  8030c1:	89 50 04             	mov    %edx,0x4(%eax)
  8030c4:	eb 0b                	jmp    8030d1 <alloc_block_BF+0x176>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	8b 40 04             	mov    0x4(%eax),%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	74 0f                	je     8030ea <alloc_block_BF+0x18f>
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 40 04             	mov    0x4(%eax),%eax
  8030e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e4:	8b 12                	mov    (%edx),%edx
  8030e6:	89 10                	mov    %edx,(%eax)
  8030e8:	eb 0a                	jmp    8030f4 <alloc_block_BF+0x199>
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803107:	a1 38 50 80 00       	mov    0x805038,%eax
  80310c:	48                   	dec    %eax
  80310d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  803112:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803115:	e9 01 04 00 00       	jmp    80351b <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803120:	76 13                	jbe    803135 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803122:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803129:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80312c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80312f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803132:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803135:	a1 34 50 80 00       	mov    0x805034,%eax
  80313a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803141:	74 07                	je     80314a <alloc_block_BF+0x1ef>
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	eb 05                	jmp    80314f <alloc_block_BF+0x1f4>
  80314a:	b8 00 00 00 00       	mov    $0x0,%eax
  80314f:	a3 34 50 80 00       	mov    %eax,0x805034
  803154:	a1 34 50 80 00       	mov    0x805034,%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	0f 85 bf fe ff ff    	jne    803020 <alloc_block_BF+0xc5>
  803161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803165:	0f 85 b5 fe ff ff    	jne    803020 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80316b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80316f:	0f 84 26 02 00 00    	je     80339b <alloc_block_BF+0x440>
  803175:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803179:	0f 85 1c 02 00 00    	jne    80339b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80317f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803182:	2b 45 08             	sub    0x8(%ebp),%eax
  803185:	83 e8 08             	sub    $0x8,%eax
  803188:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8d 50 08             	lea    0x8(%eax),%edx
  803191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803194:	01 d0                	add    %edx,%eax
  803196:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	83 c0 08             	add    $0x8,%eax
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	6a 01                	push   $0x1
  8031a4:	50                   	push   %eax
  8031a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a8:	e8 c3 f8 ff ff       	call   802a70 <set_block_data>
  8031ad:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8031b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b3:	8b 40 04             	mov    0x4(%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	75 68                	jne    803222 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031be:	75 17                	jne    8031d7 <alloc_block_BF+0x27c>
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	68 70 4d 80 00       	push   $0x804d70
  8031c8:	68 45 01 00 00       	push   $0x145
  8031cd:	68 55 4d 80 00       	push   $0x804d55
  8031d2:	e8 ae 0f 00 00       	call   804185 <_panic>
  8031d7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e0:	89 10                	mov    %edx,(%eax)
  8031e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	85 c0                	test   %eax,%eax
  8031e9:	74 0d                	je     8031f8 <alloc_block_BF+0x29d>
  8031eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	eb 08                	jmp    803200 <alloc_block_BF+0x2a5>
  8031f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803200:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803203:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803208:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80320b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803212:	a1 38 50 80 00       	mov    0x805038,%eax
  803217:	40                   	inc    %eax
  803218:	a3 38 50 80 00       	mov    %eax,0x805038
  80321d:	e9 dc 00 00 00       	jmp    8032fe <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	75 65                	jne    803290 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80322b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80322f:	75 17                	jne    803248 <alloc_block_BF+0x2ed>
  803231:	83 ec 04             	sub    $0x4,%esp
  803234:	68 a4 4d 80 00       	push   $0x804da4
  803239:	68 4a 01 00 00       	push   $0x14a
  80323e:	68 55 4d 80 00       	push   $0x804d55
  803243:	e8 3d 0f 00 00       	call   804185 <_panic>
  803248:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80324e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803251:	89 50 04             	mov    %edx,0x4(%eax)
  803254:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803257:	8b 40 04             	mov    0x4(%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 0c                	je     80326a <alloc_block_BF+0x30f>
  80325e:	a1 30 50 80 00       	mov    0x805030,%eax
  803263:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803266:	89 10                	mov    %edx,(%eax)
  803268:	eb 08                	jmp    803272 <alloc_block_BF+0x317>
  80326a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80326d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803272:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803275:	a3 30 50 80 00       	mov    %eax,0x805030
  80327a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803283:	a1 38 50 80 00       	mov    0x805038,%eax
  803288:	40                   	inc    %eax
  803289:	a3 38 50 80 00       	mov    %eax,0x805038
  80328e:	eb 6e                	jmp    8032fe <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803294:	74 06                	je     80329c <alloc_block_BF+0x341>
  803296:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80329a:	75 17                	jne    8032b3 <alloc_block_BF+0x358>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 c8 4d 80 00       	push   $0x804dc8
  8032a4:	68 4f 01 00 00       	push   $0x14f
  8032a9:	68 55 4d 80 00       	push   $0x804d55
  8032ae:	e8 d2 0e 00 00       	call   804185 <_panic>
  8032b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b6:	8b 10                	mov    (%eax),%edx
  8032b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	74 0b                	je     8032d1 <alloc_block_BF+0x376>
  8032c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032d7:	89 10                	mov    %edx,(%eax)
  8032d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	75 08                	jne    8032f3 <alloc_block_BF+0x398>
  8032eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f8:	40                   	inc    %eax
  8032f9:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803302:	75 17                	jne    80331b <alloc_block_BF+0x3c0>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 37 4d 80 00       	push   $0x804d37
  80330c:	68 51 01 00 00       	push   $0x151
  803311:	68 55 4d 80 00       	push   $0x804d55
  803316:	e8 6a 0e 00 00       	call   804185 <_panic>
  80331b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 10                	je     803334 <alloc_block_BF+0x3d9>
  803324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80332c:	8b 52 04             	mov    0x4(%edx),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	eb 0b                	jmp    80333f <alloc_block_BF+0x3e4>
  803334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	a3 30 50 80 00       	mov    %eax,0x805030
  80333f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 0f                	je     803358 <alloc_block_BF+0x3fd>
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	8b 40 04             	mov    0x4(%eax),%eax
  80334f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803352:	8b 12                	mov    (%edx),%edx
  803354:	89 10                	mov    %edx,(%eax)
  803356:	eb 0a                	jmp    803362 <alloc_block_BF+0x407>
  803358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803375:	a1 38 50 80 00       	mov    0x805038,%eax
  80337a:	48                   	dec    %eax
  80337b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	6a 00                	push   $0x0
  803385:	ff 75 d0             	pushl  -0x30(%ebp)
  803388:	ff 75 cc             	pushl  -0x34(%ebp)
  80338b:	e8 e0 f6 ff ff       	call   802a70 <set_block_data>
  803390:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	e9 80 01 00 00       	jmp    80351b <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80339b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80339f:	0f 85 9d 00 00 00    	jne    803442 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	6a 01                	push   $0x1
  8033aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8033ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b0:	e8 bb f6 ff ff       	call   802a70 <set_block_data>
  8033b5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033bc:	75 17                	jne    8033d5 <alloc_block_BF+0x47a>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 37 4d 80 00       	push   $0x804d37
  8033c6:	68 58 01 00 00       	push   $0x158
  8033cb:	68 55 4d 80 00       	push   $0x804d55
  8033d0:	e8 b0 0d 00 00       	call   804185 <_panic>
  8033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	74 10                	je     8033ee <alloc_block_BF+0x493>
  8033de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e6:	8b 52 04             	mov    0x4(%edx),%edx
  8033e9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ec:	eb 0b                	jmp    8033f9 <alloc_block_BF+0x49e>
  8033ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f1:	8b 40 04             	mov    0x4(%eax),%eax
  8033f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fc:	8b 40 04             	mov    0x4(%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 0f                	je     803412 <alloc_block_BF+0x4b7>
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	8b 40 04             	mov    0x4(%eax),%eax
  803409:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340c:	8b 12                	mov    (%edx),%edx
  80340e:	89 10                	mov    %edx,(%eax)
  803410:	eb 0a                	jmp    80341c <alloc_block_BF+0x4c1>
  803412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80341c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803428:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342f:	a1 38 50 80 00       	mov    0x805038,%eax
  803434:	48                   	dec    %eax
  803435:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80343a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343d:	e9 d9 00 00 00       	jmp    80351b <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	83 c0 08             	add    $0x8,%eax
  803448:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80344b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803452:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803455:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803458:	01 d0                	add    %edx,%eax
  80345a:	48                   	dec    %eax
  80345b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80345e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803461:	ba 00 00 00 00       	mov    $0x0,%edx
  803466:	f7 75 c4             	divl   -0x3c(%ebp)
  803469:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80346c:	29 d0                	sub    %edx,%eax
  80346e:	c1 e8 0c             	shr    $0xc,%eax
  803471:	83 ec 0c             	sub    $0xc,%esp
  803474:	50                   	push   %eax
  803475:	e8 49 e7 ff ff       	call   801bc3 <sbrk>
  80347a:	83 c4 10             	add    $0x10,%esp
  80347d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803480:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803484:	75 0a                	jne    803490 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803486:	b8 00 00 00 00       	mov    $0x0,%eax
  80348b:	e9 8b 00 00 00       	jmp    80351b <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803490:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803497:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80349a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80349d:	01 d0                	add    %edx,%eax
  80349f:	48                   	dec    %eax
  8034a0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8034a3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8034ab:	f7 75 b8             	divl   -0x48(%ebp)
  8034ae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034b1:	29 d0                	sub    %edx,%eax
  8034b3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034b9:	01 d0                	add    %edx,%eax
  8034bb:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8034c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8034c5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034cb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034d8:	01 d0                	add    %edx,%eax
  8034da:	48                   	dec    %eax
  8034db:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034de:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e6:	f7 75 b0             	divl   -0x50(%ebp)
  8034e9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034ec:	29 d0                	sub    %edx,%eax
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	6a 01                	push   $0x1
  8034f3:	50                   	push   %eax
  8034f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8034f7:	e8 74 f5 ff ff       	call   802a70 <set_block_data>
  8034fc:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8034ff:	83 ec 0c             	sub    $0xc,%esp
  803502:	ff 75 bc             	pushl  -0x44(%ebp)
  803505:	e8 36 04 00 00       	call   803940 <free_block>
  80350a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80350d:	83 ec 0c             	sub    $0xc,%esp
  803510:	ff 75 08             	pushl  0x8(%ebp)
  803513:	e8 43 fa ff ff       	call   802f5b <alloc_block_BF>
  803518:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
  803520:	53                   	push   %ebx
  803521:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80352b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803532:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803536:	74 1e                	je     803556 <merging+0x39>
  803538:	ff 75 08             	pushl  0x8(%ebp)
  80353b:	e8 df f1 ff ff       	call   80271f <get_block_size>
  803540:	83 c4 04             	add    $0x4,%esp
  803543:	89 c2                	mov    %eax,%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	01 d0                	add    %edx,%eax
  80354a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80354d:	75 07                	jne    803556 <merging+0x39>
		prev_is_free = 1;
  80354f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803556:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80355a:	74 1e                	je     80357a <merging+0x5d>
  80355c:	ff 75 10             	pushl  0x10(%ebp)
  80355f:	e8 bb f1 ff ff       	call   80271f <get_block_size>
  803564:	83 c4 04             	add    $0x4,%esp
  803567:	89 c2                	mov    %eax,%edx
  803569:	8b 45 10             	mov    0x10(%ebp),%eax
  80356c:	01 d0                	add    %edx,%eax
  80356e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803571:	75 07                	jne    80357a <merging+0x5d>
		next_is_free = 1;
  803573:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80357a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357e:	0f 84 cc 00 00 00    	je     803650 <merging+0x133>
  803584:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803588:	0f 84 c2 00 00 00    	je     803650 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80358e:	ff 75 08             	pushl  0x8(%ebp)
  803591:	e8 89 f1 ff ff       	call   80271f <get_block_size>
  803596:	83 c4 04             	add    $0x4,%esp
  803599:	89 c3                	mov    %eax,%ebx
  80359b:	ff 75 10             	pushl  0x10(%ebp)
  80359e:	e8 7c f1 ff ff       	call   80271f <get_block_size>
  8035a3:	83 c4 04             	add    $0x4,%esp
  8035a6:	01 c3                	add    %eax,%ebx
  8035a8:	ff 75 0c             	pushl  0xc(%ebp)
  8035ab:	e8 6f f1 ff ff       	call   80271f <get_block_size>
  8035b0:	83 c4 04             	add    $0x4,%esp
  8035b3:	01 d8                	add    %ebx,%eax
  8035b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035b8:	6a 00                	push   $0x0
  8035ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8035bd:	ff 75 08             	pushl  0x8(%ebp)
  8035c0:	e8 ab f4 ff ff       	call   802a70 <set_block_data>
  8035c5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035cc:	75 17                	jne    8035e5 <merging+0xc8>
  8035ce:	83 ec 04             	sub    $0x4,%esp
  8035d1:	68 37 4d 80 00       	push   $0x804d37
  8035d6:	68 7d 01 00 00       	push   $0x17d
  8035db:	68 55 4d 80 00       	push   $0x804d55
  8035e0:	e8 a0 0b 00 00       	call   804185 <_panic>
  8035e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 10                	je     8035fe <merging+0xe1>
  8035ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f6:	8b 52 04             	mov    0x4(%edx),%edx
  8035f9:	89 50 04             	mov    %edx,0x4(%eax)
  8035fc:	eb 0b                	jmp    803609 <merging+0xec>
  8035fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803601:	8b 40 04             	mov    0x4(%eax),%eax
  803604:	a3 30 50 80 00       	mov    %eax,0x805030
  803609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360c:	8b 40 04             	mov    0x4(%eax),%eax
  80360f:	85 c0                	test   %eax,%eax
  803611:	74 0f                	je     803622 <merging+0x105>
  803613:	8b 45 0c             	mov    0xc(%ebp),%eax
  803616:	8b 40 04             	mov    0x4(%eax),%eax
  803619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80361c:	8b 12                	mov    (%edx),%edx
  80361e:	89 10                	mov    %edx,(%eax)
  803620:	eb 0a                	jmp    80362c <merging+0x10f>
  803622:	8b 45 0c             	mov    0xc(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80362c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803635:	8b 45 0c             	mov    0xc(%ebp),%eax
  803638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363f:	a1 38 50 80 00       	mov    0x805038,%eax
  803644:	48                   	dec    %eax
  803645:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80364a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80364b:	e9 ea 02 00 00       	jmp    80393a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803654:	74 3b                	je     803691 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803656:	83 ec 0c             	sub    $0xc,%esp
  803659:	ff 75 08             	pushl  0x8(%ebp)
  80365c:	e8 be f0 ff ff       	call   80271f <get_block_size>
  803661:	83 c4 10             	add    $0x10,%esp
  803664:	89 c3                	mov    %eax,%ebx
  803666:	83 ec 0c             	sub    $0xc,%esp
  803669:	ff 75 10             	pushl  0x10(%ebp)
  80366c:	e8 ae f0 ff ff       	call   80271f <get_block_size>
  803671:	83 c4 10             	add    $0x10,%esp
  803674:	01 d8                	add    %ebx,%eax
  803676:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803679:	83 ec 04             	sub    $0x4,%esp
  80367c:	6a 00                	push   $0x0
  80367e:	ff 75 e8             	pushl  -0x18(%ebp)
  803681:	ff 75 08             	pushl  0x8(%ebp)
  803684:	e8 e7 f3 ff ff       	call   802a70 <set_block_data>
  803689:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80368c:	e9 a9 02 00 00       	jmp    80393a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803695:	0f 84 2d 01 00 00    	je     8037c8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80369b:	83 ec 0c             	sub    $0xc,%esp
  80369e:	ff 75 10             	pushl  0x10(%ebp)
  8036a1:	e8 79 f0 ff ff       	call   80271f <get_block_size>
  8036a6:	83 c4 10             	add    $0x10,%esp
  8036a9:	89 c3                	mov    %eax,%ebx
  8036ab:	83 ec 0c             	sub    $0xc,%esp
  8036ae:	ff 75 0c             	pushl  0xc(%ebp)
  8036b1:	e8 69 f0 ff ff       	call   80271f <get_block_size>
  8036b6:	83 c4 10             	add    $0x10,%esp
  8036b9:	01 d8                	add    %ebx,%eax
  8036bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036be:	83 ec 04             	sub    $0x4,%esp
  8036c1:	6a 00                	push   $0x0
  8036c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036c6:	ff 75 10             	pushl  0x10(%ebp)
  8036c9:	e8 a2 f3 ff ff       	call   802a70 <set_block_data>
  8036ce:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8036d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8036d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036db:	74 06                	je     8036e3 <merging+0x1c6>
  8036dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036e1:	75 17                	jne    8036fa <merging+0x1dd>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 fc 4d 80 00       	push   $0x804dfc
  8036eb:	68 8d 01 00 00       	push   $0x18d
  8036f0:	68 55 4d 80 00       	push   $0x804d55
  8036f5:	e8 8b 0a 00 00       	call   804185 <_panic>
  8036fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fd:	8b 50 04             	mov    0x4(%eax),%edx
  803700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803703:	89 50 04             	mov    %edx,0x4(%eax)
  803706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80370c:	89 10                	mov    %edx,(%eax)
  80370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803711:	8b 40 04             	mov    0x4(%eax),%eax
  803714:	85 c0                	test   %eax,%eax
  803716:	74 0d                	je     803725 <merging+0x208>
  803718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371b:	8b 40 04             	mov    0x4(%eax),%eax
  80371e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803721:	89 10                	mov    %edx,(%eax)
  803723:	eb 08                	jmp    80372d <merging+0x210>
  803725:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803728:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80372d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803730:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803733:	89 50 04             	mov    %edx,0x4(%eax)
  803736:	a1 38 50 80 00       	mov    0x805038,%eax
  80373b:	40                   	inc    %eax
  80373c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803741:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803745:	75 17                	jne    80375e <merging+0x241>
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	68 37 4d 80 00       	push   $0x804d37
  80374f:	68 8e 01 00 00       	push   $0x18e
  803754:	68 55 4d 80 00       	push   $0x804d55
  803759:	e8 27 0a 00 00       	call   804185 <_panic>
  80375e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	85 c0                	test   %eax,%eax
  803765:	74 10                	je     803777 <merging+0x25a>
  803767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80376f:	8b 52 04             	mov    0x4(%edx),%edx
  803772:	89 50 04             	mov    %edx,0x4(%eax)
  803775:	eb 0b                	jmp    803782 <merging+0x265>
  803777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377a:	8b 40 04             	mov    0x4(%eax),%eax
  80377d:	a3 30 50 80 00       	mov    %eax,0x805030
  803782:	8b 45 0c             	mov    0xc(%ebp),%eax
  803785:	8b 40 04             	mov    0x4(%eax),%eax
  803788:	85 c0                	test   %eax,%eax
  80378a:	74 0f                	je     80379b <merging+0x27e>
  80378c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378f:	8b 40 04             	mov    0x4(%eax),%eax
  803792:	8b 55 0c             	mov    0xc(%ebp),%edx
  803795:	8b 12                	mov    (%edx),%edx
  803797:	89 10                	mov    %edx,(%eax)
  803799:	eb 0a                	jmp    8037a5 <merging+0x288>
  80379b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8037bd:	48                   	dec    %eax
  8037be:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037c3:	e9 72 01 00 00       	jmp    80393a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8037cb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8037ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d2:	74 79                	je     80384d <merging+0x330>
  8037d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037d8:	74 73                	je     80384d <merging+0x330>
  8037da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037de:	74 06                	je     8037e6 <merging+0x2c9>
  8037e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037e4:	75 17                	jne    8037fd <merging+0x2e0>
  8037e6:	83 ec 04             	sub    $0x4,%esp
  8037e9:	68 c8 4d 80 00       	push   $0x804dc8
  8037ee:	68 94 01 00 00       	push   $0x194
  8037f3:	68 55 4d 80 00       	push   $0x804d55
  8037f8:	e8 88 09 00 00       	call   804185 <_panic>
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	8b 10                	mov    (%eax),%edx
  803802:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803805:	89 10                	mov    %edx,(%eax)
  803807:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 0b                	je     80381b <merging+0x2fe>
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803818:	89 50 04             	mov    %edx,0x4(%eax)
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803821:	89 10                	mov    %edx,(%eax)
  803823:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803826:	8b 55 08             	mov    0x8(%ebp),%edx
  803829:	89 50 04             	mov    %edx,0x4(%eax)
  80382c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382f:	8b 00                	mov    (%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	75 08                	jne    80383d <merging+0x320>
  803835:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803838:	a3 30 50 80 00       	mov    %eax,0x805030
  80383d:	a1 38 50 80 00       	mov    0x805038,%eax
  803842:	40                   	inc    %eax
  803843:	a3 38 50 80 00       	mov    %eax,0x805038
  803848:	e9 ce 00 00 00       	jmp    80391b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80384d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803851:	74 65                	je     8038b8 <merging+0x39b>
  803853:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803857:	75 17                	jne    803870 <merging+0x353>
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 a4 4d 80 00       	push   $0x804da4
  803861:	68 95 01 00 00       	push   $0x195
  803866:	68 55 4d 80 00       	push   $0x804d55
  80386b:	e8 15 09 00 00       	call   804185 <_panic>
  803870:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80387f:	8b 40 04             	mov    0x4(%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	74 0c                	je     803892 <merging+0x375>
  803886:	a1 30 50 80 00       	mov    0x805030,%eax
  80388b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80388e:	89 10                	mov    %edx,(%eax)
  803890:	eb 08                	jmp    80389a <merging+0x37d>
  803892:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803895:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80389a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389d:	a3 30 50 80 00       	mov    %eax,0x805030
  8038a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b0:	40                   	inc    %eax
  8038b1:	a3 38 50 80 00       	mov    %eax,0x805038
  8038b6:	eb 63                	jmp    80391b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038bc:	75 17                	jne    8038d5 <merging+0x3b8>
  8038be:	83 ec 04             	sub    $0x4,%esp
  8038c1:	68 70 4d 80 00       	push   $0x804d70
  8038c6:	68 98 01 00 00       	push   $0x198
  8038cb:	68 55 4d 80 00       	push   $0x804d55
  8038d0:	e8 b0 08 00 00       	call   804185 <_panic>
  8038d5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8038db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038de:	89 10                	mov    %edx,(%eax)
  8038e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e3:	8b 00                	mov    (%eax),%eax
  8038e5:	85 c0                	test   %eax,%eax
  8038e7:	74 0d                	je     8038f6 <merging+0x3d9>
  8038e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 08                	jmp    8038fe <merging+0x3e1>
  8038f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8038fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803901:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803906:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803910:	a1 38 50 80 00       	mov    0x805038,%eax
  803915:	40                   	inc    %eax
  803916:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80391b:	83 ec 0c             	sub    $0xc,%esp
  80391e:	ff 75 10             	pushl  0x10(%ebp)
  803921:	e8 f9 ed ff ff       	call   80271f <get_block_size>
  803926:	83 c4 10             	add    $0x10,%esp
  803929:	83 ec 04             	sub    $0x4,%esp
  80392c:	6a 00                	push   $0x0
  80392e:	50                   	push   %eax
  80392f:	ff 75 10             	pushl  0x10(%ebp)
  803932:	e8 39 f1 ff ff       	call   802a70 <set_block_data>
  803937:	83 c4 10             	add    $0x10,%esp
	}
}
  80393a:	90                   	nop
  80393b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80393e:	c9                   	leave  
  80393f:	c3                   	ret    

00803940 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
  803943:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803946:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80394b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80394e:	a1 30 50 80 00       	mov    0x805030,%eax
  803953:	3b 45 08             	cmp    0x8(%ebp),%eax
  803956:	73 1b                	jae    803973 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803958:	a1 30 50 80 00       	mov    0x805030,%eax
  80395d:	83 ec 04             	sub    $0x4,%esp
  803960:	ff 75 08             	pushl  0x8(%ebp)
  803963:	6a 00                	push   $0x0
  803965:	50                   	push   %eax
  803966:	e8 b2 fb ff ff       	call   80351d <merging>
  80396b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80396e:	e9 8b 00 00 00       	jmp    8039fe <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803973:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803978:	3b 45 08             	cmp    0x8(%ebp),%eax
  80397b:	76 18                	jbe    803995 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80397d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803982:	83 ec 04             	sub    $0x4,%esp
  803985:	ff 75 08             	pushl  0x8(%ebp)
  803988:	50                   	push   %eax
  803989:	6a 00                	push   $0x0
  80398b:	e8 8d fb ff ff       	call   80351d <merging>
  803990:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803993:	eb 69                	jmp    8039fe <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803995:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80399a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80399d:	eb 39                	jmp    8039d8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039a5:	73 29                	jae    8039d0 <free_block+0x90>
  8039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039aa:	8b 00                	mov    (%eax),%eax
  8039ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039af:	76 1f                	jbe    8039d0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039b9:	83 ec 04             	sub    $0x4,%esp
  8039bc:	ff 75 08             	pushl  0x8(%ebp)
  8039bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8039c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8039c5:	e8 53 fb ff ff       	call   80351d <merging>
  8039ca:	83 c4 10             	add    $0x10,%esp
			break;
  8039cd:	90                   	nop
		}
	}
}
  8039ce:	eb 2e                	jmp    8039fe <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039d0:	a1 34 50 80 00       	mov    0x805034,%eax
  8039d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039dc:	74 07                	je     8039e5 <free_block+0xa5>
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	eb 05                	jmp    8039ea <free_block+0xaa>
  8039e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8039ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8039f4:	85 c0                	test   %eax,%eax
  8039f6:	75 a7                	jne    80399f <free_block+0x5f>
  8039f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039fc:	75 a1                	jne    80399f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039fe:	90                   	nop
  8039ff:	c9                   	leave  
  803a00:	c3                   	ret    

00803a01 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a01:	55                   	push   %ebp
  803a02:	89 e5                	mov    %esp,%ebp
  803a04:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a07:	ff 75 08             	pushl  0x8(%ebp)
  803a0a:	e8 10 ed ff ff       	call   80271f <get_block_size>
  803a0f:	83 c4 04             	add    $0x4,%esp
  803a12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a1c:	eb 17                	jmp    803a35 <copy_data+0x34>
  803a1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a24:	01 c2                	add    %eax,%edx
  803a26:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	01 c8                	add    %ecx,%eax
  803a2e:	8a 00                	mov    (%eax),%al
  803a30:	88 02                	mov    %al,(%edx)
  803a32:	ff 45 fc             	incl   -0x4(%ebp)
  803a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a3b:	72 e1                	jb     803a1e <copy_data+0x1d>
}
  803a3d:	90                   	nop
  803a3e:	c9                   	leave  
  803a3f:	c3                   	ret    

00803a40 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a40:	55                   	push   %ebp
  803a41:	89 e5                	mov    %esp,%ebp
  803a43:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a4a:	75 23                	jne    803a6f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a50:	74 13                	je     803a65 <realloc_block_FF+0x25>
  803a52:	83 ec 0c             	sub    $0xc,%esp
  803a55:	ff 75 0c             	pushl  0xc(%ebp)
  803a58:	e8 42 f0 ff ff       	call   802a9f <alloc_block_FF>
  803a5d:	83 c4 10             	add    $0x10,%esp
  803a60:	e9 e4 06 00 00       	jmp    804149 <realloc_block_FF+0x709>
		return NULL;
  803a65:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6a:	e9 da 06 00 00       	jmp    804149 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803a6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a73:	75 18                	jne    803a8d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a75:	83 ec 0c             	sub    $0xc,%esp
  803a78:	ff 75 08             	pushl  0x8(%ebp)
  803a7b:	e8 c0 fe ff ff       	call   803940 <free_block>
  803a80:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a83:	b8 00 00 00 00       	mov    $0x0,%eax
  803a88:	e9 bc 06 00 00       	jmp    804149 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803a8d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a91:	77 07                	ja     803a9a <realloc_block_FF+0x5a>
  803a93:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a9d:	83 e0 01             	and    $0x1,%eax
  803aa0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa6:	83 c0 08             	add    $0x8,%eax
  803aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803aac:	83 ec 0c             	sub    $0xc,%esp
  803aaf:	ff 75 08             	pushl  0x8(%ebp)
  803ab2:	e8 68 ec ff ff       	call   80271f <get_block_size>
  803ab7:	83 c4 10             	add    $0x10,%esp
  803aba:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac0:	83 e8 08             	sub    $0x8,%eax
  803ac3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	83 e8 04             	sub    $0x4,%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	83 e0 fe             	and    $0xfffffffe,%eax
  803ad1:	89 c2                	mov    %eax,%edx
  803ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad6:	01 d0                	add    %edx,%eax
  803ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803adb:	83 ec 0c             	sub    $0xc,%esp
  803ade:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ae1:	e8 39 ec ff ff       	call   80271f <get_block_size>
  803ae6:	83 c4 10             	add    $0x10,%esp
  803ae9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aef:	83 e8 08             	sub    $0x8,%eax
  803af2:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803afb:	75 08                	jne    803b05 <realloc_block_FF+0xc5>
	{
		 return va;
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	e9 44 06 00 00       	jmp    804149 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b08:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b0b:	0f 83 d5 03 00 00    	jae    803ee6 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b14:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b17:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b1a:	83 ec 0c             	sub    $0xc,%esp
  803b1d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b20:	e8 13 ec ff ff       	call   802738 <is_free_block>
  803b25:	83 c4 10             	add    $0x10,%esp
  803b28:	84 c0                	test   %al,%al
  803b2a:	0f 84 3b 01 00 00    	je     803c6b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b36:	01 d0                	add    %edx,%eax
  803b38:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b3b:	83 ec 04             	sub    $0x4,%esp
  803b3e:	6a 01                	push   $0x1
  803b40:	ff 75 f0             	pushl  -0x10(%ebp)
  803b43:	ff 75 08             	pushl  0x8(%ebp)
  803b46:	e8 25 ef ff ff       	call   802a70 <set_block_data>
  803b4b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b51:	83 e8 04             	sub    $0x4,%eax
  803b54:	8b 00                	mov    (%eax),%eax
  803b56:	83 e0 fe             	and    $0xfffffffe,%eax
  803b59:	89 c2                	mov    %eax,%edx
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	01 d0                	add    %edx,%eax
  803b60:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b63:	83 ec 04             	sub    $0x4,%esp
  803b66:	6a 00                	push   $0x0
  803b68:	ff 75 cc             	pushl  -0x34(%ebp)
  803b6b:	ff 75 c8             	pushl  -0x38(%ebp)
  803b6e:	e8 fd ee ff ff       	call   802a70 <set_block_data>
  803b73:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b7a:	74 06                	je     803b82 <realloc_block_FF+0x142>
  803b7c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b80:	75 17                	jne    803b99 <realloc_block_FF+0x159>
  803b82:	83 ec 04             	sub    $0x4,%esp
  803b85:	68 c8 4d 80 00       	push   $0x804dc8
  803b8a:	68 f6 01 00 00       	push   $0x1f6
  803b8f:	68 55 4d 80 00       	push   $0x804d55
  803b94:	e8 ec 05 00 00       	call   804185 <_panic>
  803b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9c:	8b 10                	mov    (%eax),%edx
  803b9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ba1:	89 10                	mov    %edx,(%eax)
  803ba3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ba6:	8b 00                	mov    (%eax),%eax
  803ba8:	85 c0                	test   %eax,%eax
  803baa:	74 0b                	je     803bb7 <realloc_block_FF+0x177>
  803bac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803baf:	8b 00                	mov    (%eax),%eax
  803bb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bb4:	89 50 04             	mov    %edx,0x4(%eax)
  803bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bba:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bbd:	89 10                	mov    %edx,(%eax)
  803bbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bc5:	89 50 04             	mov    %edx,0x4(%eax)
  803bc8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bcb:	8b 00                	mov    (%eax),%eax
  803bcd:	85 c0                	test   %eax,%eax
  803bcf:	75 08                	jne    803bd9 <realloc_block_FF+0x199>
  803bd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bd4:	a3 30 50 80 00       	mov    %eax,0x805030
  803bd9:	a1 38 50 80 00       	mov    0x805038,%eax
  803bde:	40                   	inc    %eax
  803bdf:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803be4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803be8:	75 17                	jne    803c01 <realloc_block_FF+0x1c1>
  803bea:	83 ec 04             	sub    $0x4,%esp
  803bed:	68 37 4d 80 00       	push   $0x804d37
  803bf2:	68 f7 01 00 00       	push   $0x1f7
  803bf7:	68 55 4d 80 00       	push   $0x804d55
  803bfc:	e8 84 05 00 00       	call   804185 <_panic>
  803c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c04:	8b 00                	mov    (%eax),%eax
  803c06:	85 c0                	test   %eax,%eax
  803c08:	74 10                	je     803c1a <realloc_block_FF+0x1da>
  803c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0d:	8b 00                	mov    (%eax),%eax
  803c0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c12:	8b 52 04             	mov    0x4(%edx),%edx
  803c15:	89 50 04             	mov    %edx,0x4(%eax)
  803c18:	eb 0b                	jmp    803c25 <realloc_block_FF+0x1e5>
  803c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1d:	8b 40 04             	mov    0x4(%eax),%eax
  803c20:	a3 30 50 80 00       	mov    %eax,0x805030
  803c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c28:	8b 40 04             	mov    0x4(%eax),%eax
  803c2b:	85 c0                	test   %eax,%eax
  803c2d:	74 0f                	je     803c3e <realloc_block_FF+0x1fe>
  803c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c32:	8b 40 04             	mov    0x4(%eax),%eax
  803c35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c38:	8b 12                	mov    (%edx),%edx
  803c3a:	89 10                	mov    %edx,(%eax)
  803c3c:	eb 0a                	jmp    803c48 <realloc_block_FF+0x208>
  803c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c41:	8b 00                	mov    (%eax),%eax
  803c43:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5b:	a1 38 50 80 00       	mov    0x805038,%eax
  803c60:	48                   	dec    %eax
  803c61:	a3 38 50 80 00       	mov    %eax,0x805038
  803c66:	e9 73 02 00 00       	jmp    803ede <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803c6b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c6f:	0f 86 69 02 00 00    	jbe    803ede <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c75:	83 ec 04             	sub    $0x4,%esp
  803c78:	6a 01                	push   $0x1
  803c7a:	ff 75 f0             	pushl  -0x10(%ebp)
  803c7d:	ff 75 08             	pushl  0x8(%ebp)
  803c80:	e8 eb ed ff ff       	call   802a70 <set_block_data>
  803c85:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c88:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8b:	83 e8 04             	sub    $0x4,%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	83 e0 fe             	and    $0xfffffffe,%eax
  803c93:	89 c2                	mov    %eax,%edx
  803c95:	8b 45 08             	mov    0x8(%ebp),%eax
  803c98:	01 d0                	add    %edx,%eax
  803c9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c9d:	a1 38 50 80 00       	mov    0x805038,%eax
  803ca2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ca5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ca9:	75 68                	jne    803d13 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803caf:	75 17                	jne    803cc8 <realloc_block_FF+0x288>
  803cb1:	83 ec 04             	sub    $0x4,%esp
  803cb4:	68 70 4d 80 00       	push   $0x804d70
  803cb9:	68 06 02 00 00       	push   $0x206
  803cbe:	68 55 4d 80 00       	push   $0x804d55
  803cc3:	e8 bd 04 00 00       	call   804185 <_panic>
  803cc8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803cce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd1:	89 10                	mov    %edx,(%eax)
  803cd3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd6:	8b 00                	mov    (%eax),%eax
  803cd8:	85 c0                	test   %eax,%eax
  803cda:	74 0d                	je     803ce9 <realloc_block_FF+0x2a9>
  803cdc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ce1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ce4:	89 50 04             	mov    %edx,0x4(%eax)
  803ce7:	eb 08                	jmp    803cf1 <realloc_block_FF+0x2b1>
  803ce9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cec:	a3 30 50 80 00       	mov    %eax,0x805030
  803cf1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d03:	a1 38 50 80 00       	mov    0x805038,%eax
  803d08:	40                   	inc    %eax
  803d09:	a3 38 50 80 00       	mov    %eax,0x805038
  803d0e:	e9 b0 01 00 00       	jmp    803ec3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d13:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d18:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d1b:	76 68                	jbe    803d85 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d1d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d21:	75 17                	jne    803d3a <realloc_block_FF+0x2fa>
  803d23:	83 ec 04             	sub    $0x4,%esp
  803d26:	68 70 4d 80 00       	push   $0x804d70
  803d2b:	68 0b 02 00 00       	push   $0x20b
  803d30:	68 55 4d 80 00       	push   $0x804d55
  803d35:	e8 4b 04 00 00       	call   804185 <_panic>
  803d3a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d43:	89 10                	mov    %edx,(%eax)
  803d45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d48:	8b 00                	mov    (%eax),%eax
  803d4a:	85 c0                	test   %eax,%eax
  803d4c:	74 0d                	je     803d5b <realloc_block_FF+0x31b>
  803d4e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d56:	89 50 04             	mov    %edx,0x4(%eax)
  803d59:	eb 08                	jmp    803d63 <realloc_block_FF+0x323>
  803d5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5e:	a3 30 50 80 00       	mov    %eax,0x805030
  803d63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d66:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d75:	a1 38 50 80 00       	mov    0x805038,%eax
  803d7a:	40                   	inc    %eax
  803d7b:	a3 38 50 80 00       	mov    %eax,0x805038
  803d80:	e9 3e 01 00 00       	jmp    803ec3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d85:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d8a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d8d:	73 68                	jae    803df7 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d8f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d93:	75 17                	jne    803dac <realloc_block_FF+0x36c>
  803d95:	83 ec 04             	sub    $0x4,%esp
  803d98:	68 a4 4d 80 00       	push   $0x804da4
  803d9d:	68 10 02 00 00       	push   $0x210
  803da2:	68 55 4d 80 00       	push   $0x804d55
  803da7:	e8 d9 03 00 00       	call   804185 <_panic>
  803dac:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803db2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db5:	89 50 04             	mov    %edx,0x4(%eax)
  803db8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dbb:	8b 40 04             	mov    0x4(%eax),%eax
  803dbe:	85 c0                	test   %eax,%eax
  803dc0:	74 0c                	je     803dce <realloc_block_FF+0x38e>
  803dc2:	a1 30 50 80 00       	mov    0x805030,%eax
  803dc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dca:	89 10                	mov    %edx,(%eax)
  803dcc:	eb 08                	jmp    803dd6 <realloc_block_FF+0x396>
  803dce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803dd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd9:	a3 30 50 80 00       	mov    %eax,0x805030
  803dde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de7:	a1 38 50 80 00       	mov    0x805038,%eax
  803dec:	40                   	inc    %eax
  803ded:	a3 38 50 80 00       	mov    %eax,0x805038
  803df2:	e9 cc 00 00 00       	jmp    803ec3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803df7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803dfe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e06:	e9 8a 00 00 00       	jmp    803e95 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e11:	73 7a                	jae    803e8d <realloc_block_FF+0x44d>
  803e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e1b:	73 70                	jae    803e8d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e21:	74 06                	je     803e29 <realloc_block_FF+0x3e9>
  803e23:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e27:	75 17                	jne    803e40 <realloc_block_FF+0x400>
  803e29:	83 ec 04             	sub    $0x4,%esp
  803e2c:	68 c8 4d 80 00       	push   $0x804dc8
  803e31:	68 1a 02 00 00       	push   $0x21a
  803e36:	68 55 4d 80 00       	push   $0x804d55
  803e3b:	e8 45 03 00 00       	call   804185 <_panic>
  803e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e43:	8b 10                	mov    (%eax),%edx
  803e45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e48:	89 10                	mov    %edx,(%eax)
  803e4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4d:	8b 00                	mov    (%eax),%eax
  803e4f:	85 c0                	test   %eax,%eax
  803e51:	74 0b                	je     803e5e <realloc_block_FF+0x41e>
  803e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e56:	8b 00                	mov    (%eax),%eax
  803e58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e5b:	89 50 04             	mov    %edx,0x4(%eax)
  803e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e64:	89 10                	mov    %edx,(%eax)
  803e66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e6c:	89 50 04             	mov    %edx,0x4(%eax)
  803e6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e72:	8b 00                	mov    (%eax),%eax
  803e74:	85 c0                	test   %eax,%eax
  803e76:	75 08                	jne    803e80 <realloc_block_FF+0x440>
  803e78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7b:	a3 30 50 80 00       	mov    %eax,0x805030
  803e80:	a1 38 50 80 00       	mov    0x805038,%eax
  803e85:	40                   	inc    %eax
  803e86:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803e8b:	eb 36                	jmp    803ec3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e8d:	a1 34 50 80 00       	mov    0x805034,%eax
  803e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e99:	74 07                	je     803ea2 <realloc_block_FF+0x462>
  803e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9e:	8b 00                	mov    (%eax),%eax
  803ea0:	eb 05                	jmp    803ea7 <realloc_block_FF+0x467>
  803ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea7:	a3 34 50 80 00       	mov    %eax,0x805034
  803eac:	a1 34 50 80 00       	mov    0x805034,%eax
  803eb1:	85 c0                	test   %eax,%eax
  803eb3:	0f 85 52 ff ff ff    	jne    803e0b <realloc_block_FF+0x3cb>
  803eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ebd:	0f 85 48 ff ff ff    	jne    803e0b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ec3:	83 ec 04             	sub    $0x4,%esp
  803ec6:	6a 00                	push   $0x0
  803ec8:	ff 75 d8             	pushl  -0x28(%ebp)
  803ecb:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ece:	e8 9d eb ff ff       	call   802a70 <set_block_data>
  803ed3:	83 c4 10             	add    $0x10,%esp
				return va;
  803ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed9:	e9 6b 02 00 00       	jmp    804149 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803ede:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee1:	e9 63 02 00 00       	jmp    804149 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ee9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803eec:	0f 86 4d 02 00 00    	jbe    80413f <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803ef2:	83 ec 0c             	sub    $0xc,%esp
  803ef5:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ef8:	e8 3b e8 ff ff       	call   802738 <is_free_block>
  803efd:	83 c4 10             	add    $0x10,%esp
  803f00:	84 c0                	test   %al,%al
  803f02:	0f 84 37 02 00 00    	je     80413f <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f0b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f14:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f17:	76 38                	jbe    803f51 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f19:	83 ec 0c             	sub    $0xc,%esp
  803f1c:	ff 75 0c             	pushl  0xc(%ebp)
  803f1f:	e8 7b eb ff ff       	call   802a9f <alloc_block_FF>
  803f24:	83 c4 10             	add    $0x10,%esp
  803f27:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f2a:	83 ec 08             	sub    $0x8,%esp
  803f2d:	ff 75 c0             	pushl  -0x40(%ebp)
  803f30:	ff 75 08             	pushl  0x8(%ebp)
  803f33:	e8 c9 fa ff ff       	call   803a01 <copy_data>
  803f38:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803f3b:	83 ec 0c             	sub    $0xc,%esp
  803f3e:	ff 75 08             	pushl  0x8(%ebp)
  803f41:	e8 fa f9 ff ff       	call   803940 <free_block>
  803f46:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f49:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f4c:	e9 f8 01 00 00       	jmp    804149 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f54:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f57:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f5a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f5e:	0f 87 a0 00 00 00    	ja     804004 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f68:	75 17                	jne    803f81 <realloc_block_FF+0x541>
  803f6a:	83 ec 04             	sub    $0x4,%esp
  803f6d:	68 37 4d 80 00       	push   $0x804d37
  803f72:	68 38 02 00 00       	push   $0x238
  803f77:	68 55 4d 80 00       	push   $0x804d55
  803f7c:	e8 04 02 00 00       	call   804185 <_panic>
  803f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f84:	8b 00                	mov    (%eax),%eax
  803f86:	85 c0                	test   %eax,%eax
  803f88:	74 10                	je     803f9a <realloc_block_FF+0x55a>
  803f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8d:	8b 00                	mov    (%eax),%eax
  803f8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f92:	8b 52 04             	mov    0x4(%edx),%edx
  803f95:	89 50 04             	mov    %edx,0x4(%eax)
  803f98:	eb 0b                	jmp    803fa5 <realloc_block_FF+0x565>
  803f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9d:	8b 40 04             	mov    0x4(%eax),%eax
  803fa0:	a3 30 50 80 00       	mov    %eax,0x805030
  803fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa8:	8b 40 04             	mov    0x4(%eax),%eax
  803fab:	85 c0                	test   %eax,%eax
  803fad:	74 0f                	je     803fbe <realloc_block_FF+0x57e>
  803faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb2:	8b 40 04             	mov    0x4(%eax),%eax
  803fb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fb8:	8b 12                	mov    (%edx),%edx
  803fba:	89 10                	mov    %edx,(%eax)
  803fbc:	eb 0a                	jmp    803fc8 <realloc_block_FF+0x588>
  803fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc1:	8b 00                	mov    (%eax),%eax
  803fc3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fdb:	a1 38 50 80 00       	mov    0x805038,%eax
  803fe0:	48                   	dec    %eax
  803fe1:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803fe6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fe9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fec:	01 d0                	add    %edx,%eax
  803fee:	83 ec 04             	sub    $0x4,%esp
  803ff1:	6a 01                	push   $0x1
  803ff3:	50                   	push   %eax
  803ff4:	ff 75 08             	pushl  0x8(%ebp)
  803ff7:	e8 74 ea ff ff       	call   802a70 <set_block_data>
  803ffc:	83 c4 10             	add    $0x10,%esp
  803fff:	e9 36 01 00 00       	jmp    80413a <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804004:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804007:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80400a:	01 d0                	add    %edx,%eax
  80400c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80400f:	83 ec 04             	sub    $0x4,%esp
  804012:	6a 01                	push   $0x1
  804014:	ff 75 f0             	pushl  -0x10(%ebp)
  804017:	ff 75 08             	pushl  0x8(%ebp)
  80401a:	e8 51 ea ff ff       	call   802a70 <set_block_data>
  80401f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804022:	8b 45 08             	mov    0x8(%ebp),%eax
  804025:	83 e8 04             	sub    $0x4,%eax
  804028:	8b 00                	mov    (%eax),%eax
  80402a:	83 e0 fe             	and    $0xfffffffe,%eax
  80402d:	89 c2                	mov    %eax,%edx
  80402f:	8b 45 08             	mov    0x8(%ebp),%eax
  804032:	01 d0                	add    %edx,%eax
  804034:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804037:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80403b:	74 06                	je     804043 <realloc_block_FF+0x603>
  80403d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804041:	75 17                	jne    80405a <realloc_block_FF+0x61a>
  804043:	83 ec 04             	sub    $0x4,%esp
  804046:	68 c8 4d 80 00       	push   $0x804dc8
  80404b:	68 44 02 00 00       	push   $0x244
  804050:	68 55 4d 80 00       	push   $0x804d55
  804055:	e8 2b 01 00 00       	call   804185 <_panic>
  80405a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405d:	8b 10                	mov    (%eax),%edx
  80405f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804062:	89 10                	mov    %edx,(%eax)
  804064:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804067:	8b 00                	mov    (%eax),%eax
  804069:	85 c0                	test   %eax,%eax
  80406b:	74 0b                	je     804078 <realloc_block_FF+0x638>
  80406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804070:	8b 00                	mov    (%eax),%eax
  804072:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804075:	89 50 04             	mov    %edx,0x4(%eax)
  804078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80407e:	89 10                	mov    %edx,(%eax)
  804080:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804083:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804086:	89 50 04             	mov    %edx,0x4(%eax)
  804089:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80408c:	8b 00                	mov    (%eax),%eax
  80408e:	85 c0                	test   %eax,%eax
  804090:	75 08                	jne    80409a <realloc_block_FF+0x65a>
  804092:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804095:	a3 30 50 80 00       	mov    %eax,0x805030
  80409a:	a1 38 50 80 00       	mov    0x805038,%eax
  80409f:	40                   	inc    %eax
  8040a0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040a9:	75 17                	jne    8040c2 <realloc_block_FF+0x682>
  8040ab:	83 ec 04             	sub    $0x4,%esp
  8040ae:	68 37 4d 80 00       	push   $0x804d37
  8040b3:	68 45 02 00 00       	push   $0x245
  8040b8:	68 55 4d 80 00       	push   $0x804d55
  8040bd:	e8 c3 00 00 00       	call   804185 <_panic>
  8040c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c5:	8b 00                	mov    (%eax),%eax
  8040c7:	85 c0                	test   %eax,%eax
  8040c9:	74 10                	je     8040db <realloc_block_FF+0x69b>
  8040cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ce:	8b 00                	mov    (%eax),%eax
  8040d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d3:	8b 52 04             	mov    0x4(%edx),%edx
  8040d6:	89 50 04             	mov    %edx,0x4(%eax)
  8040d9:	eb 0b                	jmp    8040e6 <realloc_block_FF+0x6a6>
  8040db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040de:	8b 40 04             	mov    0x4(%eax),%eax
  8040e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8040e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e9:	8b 40 04             	mov    0x4(%eax),%eax
  8040ec:	85 c0                	test   %eax,%eax
  8040ee:	74 0f                	je     8040ff <realloc_block_FF+0x6bf>
  8040f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f3:	8b 40 04             	mov    0x4(%eax),%eax
  8040f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040f9:	8b 12                	mov    (%edx),%edx
  8040fb:	89 10                	mov    %edx,(%eax)
  8040fd:	eb 0a                	jmp    804109 <realloc_block_FF+0x6c9>
  8040ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804102:	8b 00                	mov    (%eax),%eax
  804104:	a3 2c 50 80 00       	mov    %eax,0x80502c
  804109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804115:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80411c:	a1 38 50 80 00       	mov    0x805038,%eax
  804121:	48                   	dec    %eax
  804122:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  804127:	83 ec 04             	sub    $0x4,%esp
  80412a:	6a 00                	push   $0x0
  80412c:	ff 75 bc             	pushl  -0x44(%ebp)
  80412f:	ff 75 b8             	pushl  -0x48(%ebp)
  804132:	e8 39 e9 ff ff       	call   802a70 <set_block_data>
  804137:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80413a:	8b 45 08             	mov    0x8(%ebp),%eax
  80413d:	eb 0a                	jmp    804149 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80413f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804146:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804149:	c9                   	leave  
  80414a:	c3                   	ret    

0080414b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80414b:	55                   	push   %ebp
  80414c:	89 e5                	mov    %esp,%ebp
  80414e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804151:	83 ec 04             	sub    $0x4,%esp
  804154:	68 34 4e 80 00       	push   $0x804e34
  804159:	68 58 02 00 00       	push   $0x258
  80415e:	68 55 4d 80 00       	push   $0x804d55
  804163:	e8 1d 00 00 00       	call   804185 <_panic>

00804168 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804168:	55                   	push   %ebp
  804169:	89 e5                	mov    %esp,%ebp
  80416b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80416e:	83 ec 04             	sub    $0x4,%esp
  804171:	68 5c 4e 80 00       	push   $0x804e5c
  804176:	68 61 02 00 00       	push   $0x261
  80417b:	68 55 4d 80 00       	push   $0x804d55
  804180:	e8 00 00 00 00       	call   804185 <_panic>

00804185 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  804185:	55                   	push   %ebp
  804186:	89 e5                	mov    %esp,%ebp
  804188:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80418b:	8d 45 10             	lea    0x10(%ebp),%eax
  80418e:	83 c0 04             	add    $0x4,%eax
  804191:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804194:	a1 60 50 98 00       	mov    0x985060,%eax
  804199:	85 c0                	test   %eax,%eax
  80419b:	74 16                	je     8041b3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80419d:	a1 60 50 98 00       	mov    0x985060,%eax
  8041a2:	83 ec 08             	sub    $0x8,%esp
  8041a5:	50                   	push   %eax
  8041a6:	68 84 4e 80 00       	push   $0x804e84
  8041ab:	e8 71 ca ff ff       	call   800c21 <cprintf>
  8041b0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8041b3:	a1 00 50 80 00       	mov    0x805000,%eax
  8041b8:	ff 75 0c             	pushl  0xc(%ebp)
  8041bb:	ff 75 08             	pushl  0x8(%ebp)
  8041be:	50                   	push   %eax
  8041bf:	68 89 4e 80 00       	push   $0x804e89
  8041c4:	e8 58 ca ff ff       	call   800c21 <cprintf>
  8041c9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8041cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8041cf:	83 ec 08             	sub    $0x8,%esp
  8041d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8041d5:	50                   	push   %eax
  8041d6:	e8 db c9 ff ff       	call   800bb6 <vcprintf>
  8041db:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8041de:	83 ec 08             	sub    $0x8,%esp
  8041e1:	6a 00                	push   $0x0
  8041e3:	68 a5 4e 80 00       	push   $0x804ea5
  8041e8:	e8 c9 c9 ff ff       	call   800bb6 <vcprintf>
  8041ed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8041f0:	e8 4a c9 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  8041f5:	eb fe                	jmp    8041f5 <_panic+0x70>

008041f7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8041f7:	55                   	push   %ebp
  8041f8:	89 e5                	mov    %esp,%ebp
  8041fa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8041fd:	a1 20 50 80 00       	mov    0x805020,%eax
  804202:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80420b:	39 c2                	cmp    %eax,%edx
  80420d:	74 14                	je     804223 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80420f:	83 ec 04             	sub    $0x4,%esp
  804212:	68 a8 4e 80 00       	push   $0x804ea8
  804217:	6a 26                	push   $0x26
  804219:	68 f4 4e 80 00       	push   $0x804ef4
  80421e:	e8 62 ff ff ff       	call   804185 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80422a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804231:	e9 c5 00 00 00       	jmp    8042fb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  804236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804239:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804240:	8b 45 08             	mov    0x8(%ebp),%eax
  804243:	01 d0                	add    %edx,%eax
  804245:	8b 00                	mov    (%eax),%eax
  804247:	85 c0                	test   %eax,%eax
  804249:	75 08                	jne    804253 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80424b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80424e:	e9 a5 00 00 00       	jmp    8042f8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804253:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80425a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804261:	eb 69                	jmp    8042cc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  804263:	a1 20 50 80 00       	mov    0x805020,%eax
  804268:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80426e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804271:	89 d0                	mov    %edx,%eax
  804273:	01 c0                	add    %eax,%eax
  804275:	01 d0                	add    %edx,%eax
  804277:	c1 e0 03             	shl    $0x3,%eax
  80427a:	01 c8                	add    %ecx,%eax
  80427c:	8a 40 04             	mov    0x4(%eax),%al
  80427f:	84 c0                	test   %al,%al
  804281:	75 46                	jne    8042c9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804283:	a1 20 50 80 00       	mov    0x805020,%eax
  804288:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80428e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804291:	89 d0                	mov    %edx,%eax
  804293:	01 c0                	add    %eax,%eax
  804295:	01 d0                	add    %edx,%eax
  804297:	c1 e0 03             	shl    $0x3,%eax
  80429a:	01 c8                	add    %ecx,%eax
  80429c:	8b 00                	mov    (%eax),%eax
  80429e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8042a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8042a9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8042ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8042b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b8:	01 c8                	add    %ecx,%eax
  8042ba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8042bc:	39 c2                	cmp    %eax,%edx
  8042be:	75 09                	jne    8042c9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8042c0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8042c7:	eb 15                	jmp    8042de <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042c9:	ff 45 e8             	incl   -0x18(%ebp)
  8042cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8042d1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8042d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042da:	39 c2                	cmp    %eax,%edx
  8042dc:	77 85                	ja     804263 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8042de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8042e2:	75 14                	jne    8042f8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8042e4:	83 ec 04             	sub    $0x4,%esp
  8042e7:	68 00 4f 80 00       	push   $0x804f00
  8042ec:	6a 3a                	push   $0x3a
  8042ee:	68 f4 4e 80 00       	push   $0x804ef4
  8042f3:	e8 8d fe ff ff       	call   804185 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8042f8:	ff 45 f0             	incl   -0x10(%ebp)
  8042fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804301:	0f 8c 2f ff ff ff    	jl     804236 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  804307:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80430e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804315:	eb 26                	jmp    80433d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  804317:	a1 20 50 80 00       	mov    0x805020,%eax
  80431c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804322:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804325:	89 d0                	mov    %edx,%eax
  804327:	01 c0                	add    %eax,%eax
  804329:	01 d0                	add    %edx,%eax
  80432b:	c1 e0 03             	shl    $0x3,%eax
  80432e:	01 c8                	add    %ecx,%eax
  804330:	8a 40 04             	mov    0x4(%eax),%al
  804333:	3c 01                	cmp    $0x1,%al
  804335:	75 03                	jne    80433a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  804337:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80433a:	ff 45 e0             	incl   -0x20(%ebp)
  80433d:	a1 20 50 80 00       	mov    0x805020,%eax
  804342:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80434b:	39 c2                	cmp    %eax,%edx
  80434d:	77 c8                	ja     804317 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804352:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804355:	74 14                	je     80436b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  804357:	83 ec 04             	sub    $0x4,%esp
  80435a:	68 54 4f 80 00       	push   $0x804f54
  80435f:	6a 44                	push   $0x44
  804361:	68 f4 4e 80 00       	push   $0x804ef4
  804366:	e8 1a fe ff ff       	call   804185 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80436b:	90                   	nop
  80436c:	c9                   	leave  
  80436d:	c3                   	ret    
  80436e:	66 90                	xchg   %ax,%ax

00804370 <__udivdi3>:
  804370:	55                   	push   %ebp
  804371:	57                   	push   %edi
  804372:	56                   	push   %esi
  804373:	53                   	push   %ebx
  804374:	83 ec 1c             	sub    $0x1c,%esp
  804377:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80437b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80437f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804383:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804387:	89 ca                	mov    %ecx,%edx
  804389:	89 f8                	mov    %edi,%eax
  80438b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80438f:	85 f6                	test   %esi,%esi
  804391:	75 2d                	jne    8043c0 <__udivdi3+0x50>
  804393:	39 cf                	cmp    %ecx,%edi
  804395:	77 65                	ja     8043fc <__udivdi3+0x8c>
  804397:	89 fd                	mov    %edi,%ebp
  804399:	85 ff                	test   %edi,%edi
  80439b:	75 0b                	jne    8043a8 <__udivdi3+0x38>
  80439d:	b8 01 00 00 00       	mov    $0x1,%eax
  8043a2:	31 d2                	xor    %edx,%edx
  8043a4:	f7 f7                	div    %edi
  8043a6:	89 c5                	mov    %eax,%ebp
  8043a8:	31 d2                	xor    %edx,%edx
  8043aa:	89 c8                	mov    %ecx,%eax
  8043ac:	f7 f5                	div    %ebp
  8043ae:	89 c1                	mov    %eax,%ecx
  8043b0:	89 d8                	mov    %ebx,%eax
  8043b2:	f7 f5                	div    %ebp
  8043b4:	89 cf                	mov    %ecx,%edi
  8043b6:	89 fa                	mov    %edi,%edx
  8043b8:	83 c4 1c             	add    $0x1c,%esp
  8043bb:	5b                   	pop    %ebx
  8043bc:	5e                   	pop    %esi
  8043bd:	5f                   	pop    %edi
  8043be:	5d                   	pop    %ebp
  8043bf:	c3                   	ret    
  8043c0:	39 ce                	cmp    %ecx,%esi
  8043c2:	77 28                	ja     8043ec <__udivdi3+0x7c>
  8043c4:	0f bd fe             	bsr    %esi,%edi
  8043c7:	83 f7 1f             	xor    $0x1f,%edi
  8043ca:	75 40                	jne    80440c <__udivdi3+0x9c>
  8043cc:	39 ce                	cmp    %ecx,%esi
  8043ce:	72 0a                	jb     8043da <__udivdi3+0x6a>
  8043d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043d4:	0f 87 9e 00 00 00    	ja     804478 <__udivdi3+0x108>
  8043da:	b8 01 00 00 00       	mov    $0x1,%eax
  8043df:	89 fa                	mov    %edi,%edx
  8043e1:	83 c4 1c             	add    $0x1c,%esp
  8043e4:	5b                   	pop    %ebx
  8043e5:	5e                   	pop    %esi
  8043e6:	5f                   	pop    %edi
  8043e7:	5d                   	pop    %ebp
  8043e8:	c3                   	ret    
  8043e9:	8d 76 00             	lea    0x0(%esi),%esi
  8043ec:	31 ff                	xor    %edi,%edi
  8043ee:	31 c0                	xor    %eax,%eax
  8043f0:	89 fa                	mov    %edi,%edx
  8043f2:	83 c4 1c             	add    $0x1c,%esp
  8043f5:	5b                   	pop    %ebx
  8043f6:	5e                   	pop    %esi
  8043f7:	5f                   	pop    %edi
  8043f8:	5d                   	pop    %ebp
  8043f9:	c3                   	ret    
  8043fa:	66 90                	xchg   %ax,%ax
  8043fc:	89 d8                	mov    %ebx,%eax
  8043fe:	f7 f7                	div    %edi
  804400:	31 ff                	xor    %edi,%edi
  804402:	89 fa                	mov    %edi,%edx
  804404:	83 c4 1c             	add    $0x1c,%esp
  804407:	5b                   	pop    %ebx
  804408:	5e                   	pop    %esi
  804409:	5f                   	pop    %edi
  80440a:	5d                   	pop    %ebp
  80440b:	c3                   	ret    
  80440c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804411:	89 eb                	mov    %ebp,%ebx
  804413:	29 fb                	sub    %edi,%ebx
  804415:	89 f9                	mov    %edi,%ecx
  804417:	d3 e6                	shl    %cl,%esi
  804419:	89 c5                	mov    %eax,%ebp
  80441b:	88 d9                	mov    %bl,%cl
  80441d:	d3 ed                	shr    %cl,%ebp
  80441f:	89 e9                	mov    %ebp,%ecx
  804421:	09 f1                	or     %esi,%ecx
  804423:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804427:	89 f9                	mov    %edi,%ecx
  804429:	d3 e0                	shl    %cl,%eax
  80442b:	89 c5                	mov    %eax,%ebp
  80442d:	89 d6                	mov    %edx,%esi
  80442f:	88 d9                	mov    %bl,%cl
  804431:	d3 ee                	shr    %cl,%esi
  804433:	89 f9                	mov    %edi,%ecx
  804435:	d3 e2                	shl    %cl,%edx
  804437:	8b 44 24 08          	mov    0x8(%esp),%eax
  80443b:	88 d9                	mov    %bl,%cl
  80443d:	d3 e8                	shr    %cl,%eax
  80443f:	09 c2                	or     %eax,%edx
  804441:	89 d0                	mov    %edx,%eax
  804443:	89 f2                	mov    %esi,%edx
  804445:	f7 74 24 0c          	divl   0xc(%esp)
  804449:	89 d6                	mov    %edx,%esi
  80444b:	89 c3                	mov    %eax,%ebx
  80444d:	f7 e5                	mul    %ebp
  80444f:	39 d6                	cmp    %edx,%esi
  804451:	72 19                	jb     80446c <__udivdi3+0xfc>
  804453:	74 0b                	je     804460 <__udivdi3+0xf0>
  804455:	89 d8                	mov    %ebx,%eax
  804457:	31 ff                	xor    %edi,%edi
  804459:	e9 58 ff ff ff       	jmp    8043b6 <__udivdi3+0x46>
  80445e:	66 90                	xchg   %ax,%ax
  804460:	8b 54 24 08          	mov    0x8(%esp),%edx
  804464:	89 f9                	mov    %edi,%ecx
  804466:	d3 e2                	shl    %cl,%edx
  804468:	39 c2                	cmp    %eax,%edx
  80446a:	73 e9                	jae    804455 <__udivdi3+0xe5>
  80446c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80446f:	31 ff                	xor    %edi,%edi
  804471:	e9 40 ff ff ff       	jmp    8043b6 <__udivdi3+0x46>
  804476:	66 90                	xchg   %ax,%ax
  804478:	31 c0                	xor    %eax,%eax
  80447a:	e9 37 ff ff ff       	jmp    8043b6 <__udivdi3+0x46>
  80447f:	90                   	nop

00804480 <__umoddi3>:
  804480:	55                   	push   %ebp
  804481:	57                   	push   %edi
  804482:	56                   	push   %esi
  804483:	53                   	push   %ebx
  804484:	83 ec 1c             	sub    $0x1c,%esp
  804487:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80448b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80448f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804493:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804497:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80449b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80449f:	89 f3                	mov    %esi,%ebx
  8044a1:	89 fa                	mov    %edi,%edx
  8044a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044a7:	89 34 24             	mov    %esi,(%esp)
  8044aa:	85 c0                	test   %eax,%eax
  8044ac:	75 1a                	jne    8044c8 <__umoddi3+0x48>
  8044ae:	39 f7                	cmp    %esi,%edi
  8044b0:	0f 86 a2 00 00 00    	jbe    804558 <__umoddi3+0xd8>
  8044b6:	89 c8                	mov    %ecx,%eax
  8044b8:	89 f2                	mov    %esi,%edx
  8044ba:	f7 f7                	div    %edi
  8044bc:	89 d0                	mov    %edx,%eax
  8044be:	31 d2                	xor    %edx,%edx
  8044c0:	83 c4 1c             	add    $0x1c,%esp
  8044c3:	5b                   	pop    %ebx
  8044c4:	5e                   	pop    %esi
  8044c5:	5f                   	pop    %edi
  8044c6:	5d                   	pop    %ebp
  8044c7:	c3                   	ret    
  8044c8:	39 f0                	cmp    %esi,%eax
  8044ca:	0f 87 ac 00 00 00    	ja     80457c <__umoddi3+0xfc>
  8044d0:	0f bd e8             	bsr    %eax,%ebp
  8044d3:	83 f5 1f             	xor    $0x1f,%ebp
  8044d6:	0f 84 ac 00 00 00    	je     804588 <__umoddi3+0x108>
  8044dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8044e1:	29 ef                	sub    %ebp,%edi
  8044e3:	89 fe                	mov    %edi,%esi
  8044e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044e9:	89 e9                	mov    %ebp,%ecx
  8044eb:	d3 e0                	shl    %cl,%eax
  8044ed:	89 d7                	mov    %edx,%edi
  8044ef:	89 f1                	mov    %esi,%ecx
  8044f1:	d3 ef                	shr    %cl,%edi
  8044f3:	09 c7                	or     %eax,%edi
  8044f5:	89 e9                	mov    %ebp,%ecx
  8044f7:	d3 e2                	shl    %cl,%edx
  8044f9:	89 14 24             	mov    %edx,(%esp)
  8044fc:	89 d8                	mov    %ebx,%eax
  8044fe:	d3 e0                	shl    %cl,%eax
  804500:	89 c2                	mov    %eax,%edx
  804502:	8b 44 24 08          	mov    0x8(%esp),%eax
  804506:	d3 e0                	shl    %cl,%eax
  804508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80450c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804510:	89 f1                	mov    %esi,%ecx
  804512:	d3 e8                	shr    %cl,%eax
  804514:	09 d0                	or     %edx,%eax
  804516:	d3 eb                	shr    %cl,%ebx
  804518:	89 da                	mov    %ebx,%edx
  80451a:	f7 f7                	div    %edi
  80451c:	89 d3                	mov    %edx,%ebx
  80451e:	f7 24 24             	mull   (%esp)
  804521:	89 c6                	mov    %eax,%esi
  804523:	89 d1                	mov    %edx,%ecx
  804525:	39 d3                	cmp    %edx,%ebx
  804527:	0f 82 87 00 00 00    	jb     8045b4 <__umoddi3+0x134>
  80452d:	0f 84 91 00 00 00    	je     8045c4 <__umoddi3+0x144>
  804533:	8b 54 24 04          	mov    0x4(%esp),%edx
  804537:	29 f2                	sub    %esi,%edx
  804539:	19 cb                	sbb    %ecx,%ebx
  80453b:	89 d8                	mov    %ebx,%eax
  80453d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804541:	d3 e0                	shl    %cl,%eax
  804543:	89 e9                	mov    %ebp,%ecx
  804545:	d3 ea                	shr    %cl,%edx
  804547:	09 d0                	or     %edx,%eax
  804549:	89 e9                	mov    %ebp,%ecx
  80454b:	d3 eb                	shr    %cl,%ebx
  80454d:	89 da                	mov    %ebx,%edx
  80454f:	83 c4 1c             	add    $0x1c,%esp
  804552:	5b                   	pop    %ebx
  804553:	5e                   	pop    %esi
  804554:	5f                   	pop    %edi
  804555:	5d                   	pop    %ebp
  804556:	c3                   	ret    
  804557:	90                   	nop
  804558:	89 fd                	mov    %edi,%ebp
  80455a:	85 ff                	test   %edi,%edi
  80455c:	75 0b                	jne    804569 <__umoddi3+0xe9>
  80455e:	b8 01 00 00 00       	mov    $0x1,%eax
  804563:	31 d2                	xor    %edx,%edx
  804565:	f7 f7                	div    %edi
  804567:	89 c5                	mov    %eax,%ebp
  804569:	89 f0                	mov    %esi,%eax
  80456b:	31 d2                	xor    %edx,%edx
  80456d:	f7 f5                	div    %ebp
  80456f:	89 c8                	mov    %ecx,%eax
  804571:	f7 f5                	div    %ebp
  804573:	89 d0                	mov    %edx,%eax
  804575:	e9 44 ff ff ff       	jmp    8044be <__umoddi3+0x3e>
  80457a:	66 90                	xchg   %ax,%ax
  80457c:	89 c8                	mov    %ecx,%eax
  80457e:	89 f2                	mov    %esi,%edx
  804580:	83 c4 1c             	add    $0x1c,%esp
  804583:	5b                   	pop    %ebx
  804584:	5e                   	pop    %esi
  804585:	5f                   	pop    %edi
  804586:	5d                   	pop    %ebp
  804587:	c3                   	ret    
  804588:	3b 04 24             	cmp    (%esp),%eax
  80458b:	72 06                	jb     804593 <__umoddi3+0x113>
  80458d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804591:	77 0f                	ja     8045a2 <__umoddi3+0x122>
  804593:	89 f2                	mov    %esi,%edx
  804595:	29 f9                	sub    %edi,%ecx
  804597:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80459b:	89 14 24             	mov    %edx,(%esp)
  80459e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045a6:	8b 14 24             	mov    (%esp),%edx
  8045a9:	83 c4 1c             	add    $0x1c,%esp
  8045ac:	5b                   	pop    %ebx
  8045ad:	5e                   	pop    %esi
  8045ae:	5f                   	pop    %edi
  8045af:	5d                   	pop    %ebp
  8045b0:	c3                   	ret    
  8045b1:	8d 76 00             	lea    0x0(%esi),%esi
  8045b4:	2b 04 24             	sub    (%esp),%eax
  8045b7:	19 fa                	sbb    %edi,%edx
  8045b9:	89 d1                	mov    %edx,%ecx
  8045bb:	89 c6                	mov    %eax,%esi
  8045bd:	e9 71 ff ff ff       	jmp    804533 <__umoddi3+0xb3>
  8045c2:	66 90                	xchg   %ax,%ax
  8045c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045c8:	72 ea                	jb     8045b4 <__umoddi3+0x134>
  8045ca:	89 d9                	mov    %ebx,%ecx
  8045cc:	e9 62 ff ff ff       	jmp    804533 <__umoddi3+0xb3>
