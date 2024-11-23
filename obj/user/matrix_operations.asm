
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
  80005e:	e8 95 20 00 00       	call   8020f8 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 a0 45 80 00       	push   $0x8045a0
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a4 45 80 00       	push   $0x8045a4
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 c8 45 80 00       	push   $0x8045c8
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 a4 45 80 00       	push   $0x8045a4
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 a0 45 80 00       	push   $0x8045a0
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 ec 45 80 00       	push   $0x8045ec
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
  8000e6:	68 0c 46 80 00       	push   $0x80460c
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 2e 46 80 00       	push   $0x80462e
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 3c 46 80 00       	push   $0x80463c
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 4a 46 80 00       	push   $0x80464a
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 5a 46 80 00       	push   $0x80465a
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
  80017a:	68 64 46 80 00       	push   $0x804664
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
  8001a0:	e8 6d 1f 00 00       	call   802112 <sys_unlock_cons>

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
  8002d2:	e8 21 1e 00 00       	call   8020f8 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 88 46 80 00       	push   $0x804688
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 a6 46 80 00       	push   $0x8046a6
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 bd 46 80 00       	push   $0x8046bd
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 d4 46 80 00       	push   $0x8046d4
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 5a 46 80 00       	push   $0x80465a
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
  80035e:	e8 af 1d 00 00       	call   802112 <sys_unlock_cons>


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
  8003df:	e8 14 1d 00 00       	call   8020f8 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 eb 46 80 00       	push   $0x8046eb
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 19 1d 00 00       	call   802112 <sys_unlock_cons>

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
  80048e:	e8 65 1c 00 00       	call   8020f8 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 04 47 80 00       	push   $0x804704
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
  8004c8:	e8 45 1c 00 00       	call   802112 <sys_unlock_cons>

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
  8008bf:	e8 fc 1a 00 00       	call   8023c0 <sys_get_virtual_time>
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
  80092b:	68 22 47 80 00       	push   $0x804722
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
  800946:	68 29 47 80 00       	push   $0x804729
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
  80099c:	68 2d 47 80 00       	push   $0x80472d
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
  8009b7:	68 29 47 80 00       	push   $0x804729
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
  8009e6:	e8 58 18 00 00       	call   802243 <sys_cputc>
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
  8009f7:	e8 e3 16 00 00       	call   8020df <sys_cgetc>
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
  800a14:	e8 5b 19 00 00       	call   802374 <sys_getenvindex>
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
  800a82:	e8 71 16 00 00       	call   8020f8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 50 47 80 00       	push   $0x804750
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
  800ab2:	68 78 47 80 00       	push   $0x804778
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
  800ae3:	68 a0 47 80 00       	push   $0x8047a0
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 50 80 00       	mov    0x805020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 f8 47 80 00       	push   $0x8047f8
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 50 47 80 00       	push   $0x804750
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 f1 15 00 00       	call   802112 <sys_unlock_cons>
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
  800b34:	e8 07 18 00 00       	call   802340 <sys_destroy_env>
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
  800b45:	e8 5c 18 00 00       	call   8023a6 <sys_exit_env>
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
  800b93:	e8 1e 15 00 00       	call   8020b6 <sys_cputs>
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
  800c0a:	e8 a7 14 00 00       	call   8020b6 <sys_cputs>
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
  800c54:	e8 9f 14 00 00       	call   8020f8 <sys_lock_cons>
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
  800c74:	e8 99 14 00 00       	call   802112 <sys_unlock_cons>
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
  800cbe:	e8 75 36 00 00       	call   804338 <__udivdi3>
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
  800d0e:	e8 35 37 00 00       	call   804448 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 34 4a 80 00       	add    $0x804a34,%eax
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
  800e69:	8b 04 85 58 4a 80 00 	mov    0x804a58(,%eax,4),%eax
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
  800f4a:	8b 34 9d a0 48 80 00 	mov    0x8048a0(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 45 4a 80 00       	push   $0x804a45
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
  800f6f:	68 4e 4a 80 00       	push   $0x804a4e
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
  800f9c:	be 51 4a 80 00       	mov    $0x804a51,%esi
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
  8012c7:	68 c8 4b 80 00       	push   $0x804bc8
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
  801309:	68 cb 4b 80 00       	push   $0x804bcb
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
  8013ba:	e8 39 0d 00 00       	call   8020f8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 c8 4b 80 00       	push   $0x804bc8
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
  80140d:	68 cb 4b 80 00       	push   $0x804bcb
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
  8014b5:	e8 58 0c 00 00       	call   802112 <sys_unlock_cons>
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
  801baf:	68 dc 4b 80 00       	push   $0x804bdc
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 fe 4b 80 00       	push   $0x804bfe
  801bbe:	e8 8a 25 00 00       	call   80414d <_panic>

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
  801bcf:	e8 8d 0a 00 00       	call   802661 <sys_sbrk>
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
  801c4a:	e8 96 08 00 00       	call   8024e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 d6 0d 00 00       	call   802a34 <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 a8 08 00 00       	call   802516 <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 6f 12 00 00       	call   802ef0 <alloc_block_BF>
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
  801ccc:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801d19:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801d70:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801dd2:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  801de2:	e8 b1 08 00 00       	call   802698 <sys_allocate_user_mem>
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
  801e2a:	e8 85 08 00 00       	call   8026b4 <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 b8 1a 00 00       	call   8038f8 <free_block>
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
  801e75:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801eb2:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801ed2:	e8 a5 07 00 00       	call   80267c <sys_free_user_mem>
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
  801ee0:	68 0c 4c 80 00       	push   $0x804c0c
  801ee5:	68 84 00 00 00       	push   $0x84
  801eea:	68 36 4c 80 00       	push   $0x804c36
  801eef:	e8 59 22 00 00       	call   80414d <_panic>
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
  801f06:	75 07                	jne    801f0f <smalloc+0x19>
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	eb 64                	jmp    801f73 <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f15:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	39 d0                	cmp    %edx,%eax
  801f24:	73 02                	jae    801f28 <smalloc+0x32>
  801f26:	89 d0                	mov    %edx,%eax
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	50                   	push   %eax
  801f2c:	e8 a8 fc ff ff       	call   801bd9 <malloc>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801f37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3b:	75 07                	jne    801f44 <smalloc+0x4e>
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	eb 2f                	jmp    801f73 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f44:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f48:	ff 75 ec             	pushl  -0x14(%ebp)
  801f4b:	50                   	push   %eax
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	e8 2c 03 00 00       	call   802283 <sys_createSharedObject>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f5d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f61:	74 06                	je     801f69 <smalloc+0x73>
  801f63:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f67:	75 07                	jne    801f70 <smalloc+0x7a>
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	eb 03                	jmp    801f73 <smalloc+0x7d>
	 return ptr;
  801f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f7b:	83 ec 08             	sub    $0x8,%esp
  801f7e:	ff 75 0c             	pushl  0xc(%ebp)
  801f81:	ff 75 08             	pushl  0x8(%ebp)
  801f84:	e8 24 03 00 00       	call   8022ad <sys_getSizeOfSharedObject>
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f8f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f93:	75 07                	jne    801f9c <sget+0x27>
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	eb 5c                	jmp    801ff8 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fa2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fa9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	39 d0                	cmp    %edx,%eax
  801fb1:	7d 02                	jge    801fb5 <sget+0x40>
  801fb3:	89 d0                	mov    %edx,%eax
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	50                   	push   %eax
  801fb9:	e8 1b fc ff ff       	call   801bd9 <malloc>
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801fc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fc8:	75 07                	jne    801fd1 <sget+0x5c>
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	eb 27                	jmp    801ff8 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	ff 75 e8             	pushl  -0x18(%ebp)
  801fd7:	ff 75 0c             	pushl  0xc(%ebp)
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	e8 e8 02 00 00       	call   8022ca <sys_getSharedObject>
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801fe8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801fec:	75 07                	jne    801ff5 <sget+0x80>
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	eb 03                	jmp    801ff8 <sget+0x83>
	return ptr;
  801ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 44 4c 80 00       	push   $0x804c44
  802008:	68 c1 00 00 00       	push   $0xc1
  80200d:	68 36 4c 80 00       	push   $0x804c36
  802012:	e8 36 21 00 00       	call   80414d <_panic>

00802017 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	68 68 4c 80 00       	push   $0x804c68
  802025:	68 d8 00 00 00       	push   $0xd8
  80202a:	68 36 4c 80 00       	push   $0x804c36
  80202f:	e8 19 21 00 00       	call   80414d <_panic>

00802034 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	68 8e 4c 80 00       	push   $0x804c8e
  802042:	68 e4 00 00 00       	push   $0xe4
  802047:	68 36 4c 80 00       	push   $0x804c36
  80204c:	e8 fc 20 00 00       	call   80414d <_panic>

00802051 <shrink>:

}
void shrink(uint32 newSize)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 8e 4c 80 00       	push   $0x804c8e
  80205f:	68 e9 00 00 00       	push   $0xe9
  802064:	68 36 4c 80 00       	push   $0x804c36
  802069:	e8 df 20 00 00       	call   80414d <_panic>

0080206e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	68 8e 4c 80 00       	push   $0x804c8e
  80207c:	68 ee 00 00 00       	push   $0xee
  802081:	68 36 4c 80 00       	push   $0x804c36
  802086:	e8 c2 20 00 00       	call   80414d <_panic>

0080208b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	57                   	push   %edi
  80208f:	56                   	push   %esi
  802090:	53                   	push   %ebx
  802091:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80209d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020a0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020a3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020a6:	cd 30                	int    $0x30
  8020a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    

008020b6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 04             	sub    $0x4,%esp
  8020bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	52                   	push   %edx
  8020ce:	ff 75 0c             	pushl  0xc(%ebp)
  8020d1:	50                   	push   %eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 b2 ff ff ff       	call   80208b <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_cgetc>:

int
sys_cgetc(void)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 02                	push   $0x2
  8020ee:	e8 98 ff ff ff       	call   80208b <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 03                	push   $0x3
  802107:	e8 7f ff ff ff       	call   80208b <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	90                   	nop
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 04                	push   $0x4
  802121:	e8 65 ff ff ff       	call   80208b <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	90                   	nop
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80212f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	52                   	push   %edx
  80213c:	50                   	push   %eax
  80213d:	6a 08                	push   $0x8
  80213f:	e8 47 ff ff ff       	call   80208b <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80214e:	8b 75 18             	mov    0x18(%ebp),%esi
  802151:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802154:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	56                   	push   %esi
  80215e:	53                   	push   %ebx
  80215f:	51                   	push   %ecx
  802160:	52                   	push   %edx
  802161:	50                   	push   %eax
  802162:	6a 09                	push   $0x9
  802164:	e8 22 ff ff ff       	call   80208b <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5d                   	pop    %ebp
  802172:	c3                   	ret    

00802173 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802176:	8b 55 0c             	mov    0xc(%ebp),%edx
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	52                   	push   %edx
  802183:	50                   	push   %eax
  802184:	6a 0a                	push   $0xa
  802186:	e8 00 ff ff ff       	call   80208b <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	ff 75 08             	pushl  0x8(%ebp)
  80219f:	6a 0b                	push   $0xb
  8021a1:	e8 e5 fe ff ff       	call   80208b <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 0c                	push   $0xc
  8021ba:	e8 cc fe ff ff       	call   80208b <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 0d                	push   $0xd
  8021d3:	e8 b3 fe ff ff       	call   80208b <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 0e                	push   $0xe
  8021ec:	e8 9a fe ff ff       	call   80208b <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 0f                	push   $0xf
  802205:	e8 81 fe ff ff       	call   80208b <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	ff 75 08             	pushl  0x8(%ebp)
  80221d:	6a 10                	push   $0x10
  80221f:	e8 67 fe ff ff       	call   80208b <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 11                	push   $0x11
  802238:	e8 4e fe ff ff       	call   80208b <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	90                   	nop
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_cputc>:

void
sys_cputc(const char c)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80224f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	50                   	push   %eax
  80225c:	6a 01                	push   $0x1
  80225e:	e8 28 fe ff ff       	call   80208b <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	90                   	nop
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 14                	push   $0x14
  802278:	e8 0e fe ff ff       	call   80208b <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	90                   	nop
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	8b 45 10             	mov    0x10(%ebp),%eax
  80228c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80228f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802292:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	6a 00                	push   $0x0
  80229b:	51                   	push   %ecx
  80229c:	52                   	push   %edx
  80229d:	ff 75 0c             	pushl  0xc(%ebp)
  8022a0:	50                   	push   %eax
  8022a1:	6a 15                	push   $0x15
  8022a3:	e8 e3 fd ff ff       	call   80208b <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	52                   	push   %edx
  8022bd:	50                   	push   %eax
  8022be:	6a 16                	push   $0x16
  8022c0:	e8 c6 fd ff ff       	call   80208b <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	51                   	push   %ecx
  8022db:	52                   	push   %edx
  8022dc:	50                   	push   %eax
  8022dd:	6a 17                	push   $0x17
  8022df:	e8 a7 fd ff ff       	call   80208b <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	52                   	push   %edx
  8022f9:	50                   	push   %eax
  8022fa:	6a 18                	push   $0x18
  8022fc:	e8 8a fd ff ff       	call   80208b <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	6a 00                	push   $0x0
  80230e:	ff 75 14             	pushl  0x14(%ebp)
  802311:	ff 75 10             	pushl  0x10(%ebp)
  802314:	ff 75 0c             	pushl  0xc(%ebp)
  802317:	50                   	push   %eax
  802318:	6a 19                	push   $0x19
  80231a:	e8 6c fd ff ff       	call   80208b <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	50                   	push   %eax
  802333:	6a 1a                	push   $0x1a
  802335:	e8 51 fd ff ff       	call   80208b <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	90                   	nop
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	50                   	push   %eax
  80234f:	6a 1b                	push   $0x1b
  802351:	e8 35 fd ff ff       	call   80208b <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 05                	push   $0x5
  80236a:	e8 1c fd ff ff       	call   80208b <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 06                	push   $0x6
  802383:	e8 03 fd ff ff       	call   80208b <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 07                	push   $0x7
  80239c:	e8 ea fc ff ff       	call   80208b <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 1c                	push   $0x1c
  8023b5:	e8 d1 fc ff ff       	call   80208b <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
}
  8023bd:	90                   	nop
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023c9:	8d 50 04             	lea    0x4(%eax),%edx
  8023cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	52                   	push   %edx
  8023d6:	50                   	push   %eax
  8023d7:	6a 1d                	push   $0x1d
  8023d9:	e8 ad fc ff ff       	call   80208b <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
	return result;
  8023e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023ea:	89 01                	mov    %eax,(%ecx)
  8023ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	c9                   	leave  
  8023f3:	c2 04 00             	ret    $0x4

008023f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	ff 75 10             	pushl  0x10(%ebp)
  802400:	ff 75 0c             	pushl  0xc(%ebp)
  802403:	ff 75 08             	pushl  0x8(%ebp)
  802406:	6a 13                	push   $0x13
  802408:	e8 7e fc ff ff       	call   80208b <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
	return ;
  802410:	90                   	nop
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_rcr2>:
uint32 sys_rcr2()
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 1e                	push   $0x1e
  802422:	e8 64 fc ff ff       	call   80208b <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	83 ec 04             	sub    $0x4,%esp
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802438:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	50                   	push   %eax
  802445:	6a 1f                	push   $0x1f
  802447:	e8 3f fc ff ff       	call   80208b <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
	return ;
  80244f:	90                   	nop
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <rsttst>:
void rsttst()
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 21                	push   $0x21
  802461:	e8 25 fc ff ff       	call   80208b <syscall>
  802466:	83 c4 18             	add    $0x18,%esp
	return ;
  802469:	90                   	nop
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	8b 45 14             	mov    0x14(%ebp),%eax
  802475:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802478:	8b 55 18             	mov    0x18(%ebp),%edx
  80247b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80247f:	52                   	push   %edx
  802480:	50                   	push   %eax
  802481:	ff 75 10             	pushl  0x10(%ebp)
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	6a 20                	push   $0x20
  80248c:	e8 fa fb ff ff       	call   80208b <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <chktst>:
void chktst(uint32 n)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	ff 75 08             	pushl  0x8(%ebp)
  8024a5:	6a 22                	push   $0x22
  8024a7:	e8 df fb ff ff       	call   80208b <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8024af:	90                   	nop
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <inctst>:

void inctst()
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 23                	push   $0x23
  8024c1:	e8 c5 fb ff ff       	call   80208b <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c9:	90                   	nop
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <gettst>:
uint32 gettst()
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 24                	push   $0x24
  8024db:	e8 ab fb ff ff       	call   80208b <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 25                	push   $0x25
  8024f7:	e8 8f fb ff ff       	call   80208b <syscall>
  8024fc:	83 c4 18             	add    $0x18,%esp
  8024ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802502:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802506:	75 07                	jne    80250f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802508:	b8 01 00 00 00       	mov    $0x1,%eax
  80250d:	eb 05                	jmp    802514 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 25                	push   $0x25
  802528:	e8 5e fb ff ff       	call   80208b <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
  802530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802533:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802537:	75 07                	jne    802540 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802539:	b8 01 00 00 00       	mov    $0x1,%eax
  80253e:	eb 05                	jmp    802545 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 25                	push   $0x25
  802559:	e8 2d fb ff ff       	call   80208b <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
  802561:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802564:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802568:	75 07                	jne    802571 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80256a:	b8 01 00 00 00       	mov    $0x1,%eax
  80256f:	eb 05                	jmp    802576 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 25                	push   $0x25
  80258a:	e8 fc fa ff ff       	call   80208b <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
  802592:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802595:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802599:	75 07                	jne    8025a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80259b:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a0:	eb 05                	jmp    8025a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	ff 75 08             	pushl  0x8(%ebp)
  8025b7:	6a 26                	push   $0x26
  8025b9:	e8 cd fa ff ff       	call   80208b <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c1:	90                   	nop
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	6a 00                	push   $0x0
  8025d6:	53                   	push   %ebx
  8025d7:	51                   	push   %ecx
  8025d8:	52                   	push   %edx
  8025d9:	50                   	push   %eax
  8025da:	6a 27                	push   $0x27
  8025dc:	e8 aa fa ff ff       	call   80208b <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
}
  8025e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	52                   	push   %edx
  8025f9:	50                   	push   %eax
  8025fa:	6a 28                	push   $0x28
  8025fc:	e8 8a fa ff ff       	call   80208b <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802609:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80260c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	6a 00                	push   $0x0
  802614:	51                   	push   %ecx
  802615:	ff 75 10             	pushl  0x10(%ebp)
  802618:	52                   	push   %edx
  802619:	50                   	push   %eax
  80261a:	6a 29                	push   $0x29
  80261c:	e8 6a fa ff ff       	call   80208b <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	ff 75 10             	pushl  0x10(%ebp)
  802630:	ff 75 0c             	pushl  0xc(%ebp)
  802633:	ff 75 08             	pushl  0x8(%ebp)
  802636:	6a 12                	push   $0x12
  802638:	e8 4e fa ff ff       	call   80208b <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
	return ;
  802640:	90                   	nop
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802646:	8b 55 0c             	mov    0xc(%ebp),%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	52                   	push   %edx
  802653:	50                   	push   %eax
  802654:	6a 2a                	push   $0x2a
  802656:	e8 30 fa ff ff       	call   80208b <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
	return;
  80265e:	90                   	nop
}
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	50                   	push   %eax
  802670:	6a 2b                	push   $0x2b
  802672:	e8 14 fa ff ff       	call   80208b <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	ff 75 0c             	pushl  0xc(%ebp)
  802688:	ff 75 08             	pushl  0x8(%ebp)
  80268b:	6a 2c                	push   $0x2c
  80268d:	e8 f9 f9 ff ff       	call   80208b <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
	return;
  802695:	90                   	nop
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	ff 75 0c             	pushl  0xc(%ebp)
  8026a4:	ff 75 08             	pushl  0x8(%ebp)
  8026a7:	6a 2d                	push   $0x2d
  8026a9:	e8 dd f9 ff ff       	call   80208b <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
	return;
  8026b1:	90                   	nop
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	83 e8 04             	sub    $0x4,%eax
  8026c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8026c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	83 e8 04             	sub    $0x4,%eax
  8026d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8026dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	83 e0 01             	and    $0x1,%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	0f 94 c0             	sete   %al
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8026f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8026f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fb:	83 f8 02             	cmp    $0x2,%eax
  8026fe:	74 2b                	je     80272b <alloc_block+0x40>
  802700:	83 f8 02             	cmp    $0x2,%eax
  802703:	7f 07                	jg     80270c <alloc_block+0x21>
  802705:	83 f8 01             	cmp    $0x1,%eax
  802708:	74 0e                	je     802718 <alloc_block+0x2d>
  80270a:	eb 58                	jmp    802764 <alloc_block+0x79>
  80270c:	83 f8 03             	cmp    $0x3,%eax
  80270f:	74 2d                	je     80273e <alloc_block+0x53>
  802711:	83 f8 04             	cmp    $0x4,%eax
  802714:	74 3b                	je     802751 <alloc_block+0x66>
  802716:	eb 4c                	jmp    802764 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802718:	83 ec 0c             	sub    $0xc,%esp
  80271b:	ff 75 08             	pushl  0x8(%ebp)
  80271e:	e8 11 03 00 00       	call   802a34 <alloc_block_FF>
  802723:	83 c4 10             	add    $0x10,%esp
  802726:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802729:	eb 4a                	jmp    802775 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	ff 75 08             	pushl  0x8(%ebp)
  802731:	e8 fa 19 00 00       	call   804130 <alloc_block_NF>
  802736:	83 c4 10             	add    $0x10,%esp
  802739:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80273c:	eb 37                	jmp    802775 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80273e:	83 ec 0c             	sub    $0xc,%esp
  802741:	ff 75 08             	pushl  0x8(%ebp)
  802744:	e8 a7 07 00 00       	call   802ef0 <alloc_block_BF>
  802749:	83 c4 10             	add    $0x10,%esp
  80274c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80274f:	eb 24                	jmp    802775 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	ff 75 08             	pushl  0x8(%ebp)
  802757:	e8 b7 19 00 00       	call   804113 <alloc_block_WF>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802762:	eb 11                	jmp    802775 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	68 a0 4c 80 00       	push   $0x804ca0
  80276c:	e8 b0 e4 ff ff       	call   800c21 <cprintf>
  802771:	83 c4 10             	add    $0x10,%esp
		break;
  802774:	90                   	nop
	}
	return va;
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	53                   	push   %ebx
  80277e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802781:	83 ec 0c             	sub    $0xc,%esp
  802784:	68 c0 4c 80 00       	push   $0x804cc0
  802789:	e8 93 e4 ff ff       	call   800c21 <cprintf>
  80278e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	68 eb 4c 80 00       	push   $0x804ceb
  802799:	e8 83 e4 ff ff       	call   800c21 <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a7:	eb 37                	jmp    8027e0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8027af:	e8 19 ff ff ff       	call   8026cd <is_free_block>
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	0f be d8             	movsbl %al,%ebx
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c0:	e8 ef fe ff ff       	call   8026b4 <get_block_size>
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	53                   	push   %ebx
  8027cc:	50                   	push   %eax
  8027cd:	68 03 4d 80 00       	push   $0x804d03
  8027d2:	e8 4a e4 ff ff       	call   800c21 <cprintf>
  8027d7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8027da:	8b 45 10             	mov    0x10(%ebp),%eax
  8027dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	74 07                	je     8027ed <print_blocks_list+0x73>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	eb 05                	jmp    8027f2 <print_blocks_list+0x78>
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	89 45 10             	mov    %eax,0x10(%ebp)
  8027f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	75 ad                	jne    8027a9 <print_blocks_list+0x2f>
  8027fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802800:	75 a7                	jne    8027a9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802802:	83 ec 0c             	sub    $0xc,%esp
  802805:	68 c0 4c 80 00       	push   $0x804cc0
  80280a:	e8 12 e4 ff ff       	call   800c21 <cprintf>
  80280f:	83 c4 10             	add    $0x10,%esp

}
  802812:	90                   	nop
  802813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80281e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802821:	83 e0 01             	and    $0x1,%eax
  802824:	85 c0                	test   %eax,%eax
  802826:	74 03                	je     80282b <initialize_dynamic_allocator+0x13>
  802828:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80282b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80282f:	0f 84 c7 01 00 00    	je     8029fc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802835:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80283c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80283f:	8b 55 08             	mov    0x8(%ebp),%edx
  802842:	8b 45 0c             	mov    0xc(%ebp),%eax
  802845:	01 d0                	add    %edx,%eax
  802847:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80284c:	0f 87 ad 01 00 00    	ja     8029ff <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	0f 89 a5 01 00 00    	jns    802a02 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80285d:	8b 55 08             	mov    0x8(%ebp),%edx
  802860:	8b 45 0c             	mov    0xc(%ebp),%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	83 e8 04             	sub    $0x4,%eax
  802868:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80286d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802874:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287c:	e9 87 00 00 00       	jmp    802908 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802885:	75 14                	jne    80289b <initialize_dynamic_allocator+0x83>
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 1b 4d 80 00       	push   $0x804d1b
  80288f:	6a 79                	push   $0x79
  802891:	68 39 4d 80 00       	push   $0x804d39
  802896:	e8 b2 18 00 00       	call   80414d <_panic>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 10                	je     8028b4 <initialize_dynamic_allocator+0x9c>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ac:	8b 52 04             	mov    0x4(%edx),%edx
  8028af:	89 50 04             	mov    %edx,0x4(%eax)
  8028b2:	eb 0b                	jmp    8028bf <initialize_dynamic_allocator+0xa7>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 04             	mov    0x4(%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 0f                	je     8028d8 <initialize_dynamic_allocator+0xc0>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d2:	8b 12                	mov    (%edx),%edx
  8028d4:	89 10                	mov    %edx,(%eax)
  8028d6:	eb 0a                	jmp    8028e2 <initialize_dynamic_allocator+0xca>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fa:	48                   	dec    %eax
  8028fb:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802900:	a1 34 50 80 00       	mov    0x805034,%eax
  802905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290c:	74 07                	je     802915 <initialize_dynamic_allocator+0xfd>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	eb 05                	jmp    80291a <initialize_dynamic_allocator+0x102>
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
  80291a:	a3 34 50 80 00       	mov    %eax,0x805034
  80291f:	a1 34 50 80 00       	mov    0x805034,%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	0f 85 55 ff ff ff    	jne    802881 <initialize_dynamic_allocator+0x69>
  80292c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802930:	0f 85 4b ff ff ff    	jne    802881 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802945:	a1 44 50 80 00       	mov    0x805044,%eax
  80294a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80294f:	a1 40 50 80 00       	mov    0x805040,%eax
  802954:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	83 c0 08             	add    $0x8,%eax
  802960:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	83 c0 04             	add    $0x4,%eax
  802969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80296c:	83 ea 08             	sub    $0x8,%edx
  80296f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802971:	8b 55 0c             	mov    0xc(%ebp),%edx
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	01 d0                	add    %edx,%eax
  802979:	83 e8 08             	sub    $0x8,%eax
  80297c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297f:	83 ea 08             	sub    $0x8,%edx
  802982:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299b:	75 17                	jne    8029b4 <initialize_dynamic_allocator+0x19c>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 54 4d 80 00       	push   $0x804d54
  8029a5:	68 90 00 00 00       	push   $0x90
  8029aa:	68 39 4d 80 00       	push   $0x804d39
  8029af:	e8 99 17 00 00       	call   80414d <_panic>
  8029b4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bd:	89 10                	mov    %edx,(%eax)
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 0d                	je     8029d5 <initialize_dynamic_allocator+0x1bd>
  8029c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d0:	89 50 04             	mov    %edx,0x4(%eax)
  8029d3:	eb 08                	jmp    8029dd <initialize_dynamic_allocator+0x1c5>
  8029d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8029dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f4:	40                   	inc    %eax
  8029f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8029fa:	eb 07                	jmp    802a03 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8029fc:	90                   	nop
  8029fd:	eb 04                	jmp    802a03 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8029ff:	90                   	nop
  802a00:	eb 01                	jmp    802a03 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a02:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a08:	8b 45 10             	mov    0x10(%ebp),%eax
  802a0b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a17:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	83 e8 04             	sub    $0x4,%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	83 e0 fe             	and    $0xfffffffe,%eax
  802a24:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	01 c2                	add    %eax,%edx
  802a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2f:	89 02                	mov    %eax,(%edx)
}
  802a31:	90                   	nop
  802a32:	5d                   	pop    %ebp
  802a33:	c3                   	ret    

00802a34 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a34:	55                   	push   %ebp
  802a35:	89 e5                	mov    %esp,%ebp
  802a37:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	83 e0 01             	and    $0x1,%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 03                	je     802a47 <alloc_block_FF+0x13>
  802a44:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a47:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a4b:	77 07                	ja     802a54 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a4d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a54:	a1 24 50 80 00       	mov    0x805024,%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	75 73                	jne    802ad0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	83 c0 10             	add    $0x10,%eax
  802a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a66:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a73:	01 d0                	add    %edx,%eax
  802a75:	48                   	dec    %eax
  802a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a81:	f7 75 ec             	divl   -0x14(%ebp)
  802a84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a87:	29 d0                	sub    %edx,%eax
  802a89:	c1 e8 0c             	shr    $0xc,%eax
  802a8c:	83 ec 0c             	sub    $0xc,%esp
  802a8f:	50                   	push   %eax
  802a90:	e8 2e f1 ff ff       	call   801bc3 <sbrk>
  802a95:	83 c4 10             	add    $0x10,%esp
  802a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a9b:	83 ec 0c             	sub    $0xc,%esp
  802a9e:	6a 00                	push   $0x0
  802aa0:	e8 1e f1 ff ff       	call   801bc3 <sbrk>
  802aa5:	83 c4 10             	add    $0x10,%esp
  802aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aae:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ab1:	83 ec 08             	sub    $0x8,%esp
  802ab4:	50                   	push   %eax
  802ab5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ab8:	e8 5b fd ff ff       	call   802818 <initialize_dynamic_allocator>
  802abd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ac0:	83 ec 0c             	sub    $0xc,%esp
  802ac3:	68 77 4d 80 00       	push   $0x804d77
  802ac8:	e8 54 e1 ff ff       	call   800c21 <cprintf>
  802acd:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad4:	75 0a                	jne    802ae0 <alloc_block_FF+0xac>
	        return NULL;
  802ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  802adb:	e9 0e 04 00 00       	jmp    802eee <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802ae0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ae7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aef:	e9 f3 02 00 00       	jmp    802de7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802afa:	83 ec 0c             	sub    $0xc,%esp
  802afd:	ff 75 bc             	pushl  -0x44(%ebp)
  802b00:	e8 af fb ff ff       	call   8026b4 <get_block_size>
  802b05:	83 c4 10             	add    $0x10,%esp
  802b08:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	83 c0 08             	add    $0x8,%eax
  802b11:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b14:	0f 87 c5 02 00 00    	ja     802ddf <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	83 c0 18             	add    $0x18,%eax
  802b20:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b23:	0f 87 19 02 00 00    	ja     802d42 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b2c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b2f:	83 e8 08             	sub    $0x8,%eax
  802b32:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8d 50 08             	lea    0x8(%eax),%edx
  802b3b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b3e:	01 d0                	add    %edx,%eax
  802b40:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	83 c0 08             	add    $0x8,%eax
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	6a 01                	push   $0x1
  802b4e:	50                   	push   %eax
  802b4f:	ff 75 bc             	pushl  -0x44(%ebp)
  802b52:	e8 ae fe ff ff       	call   802a05 <set_block_data>
  802b57:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	75 68                	jne    802bcc <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b64:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b68:	75 17                	jne    802b81 <alloc_block_FF+0x14d>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 54 4d 80 00       	push   $0x804d54
  802b72:	68 d7 00 00 00       	push   $0xd7
  802b77:	68 39 4d 80 00       	push   $0x804d39
  802b7c:	e8 cc 15 00 00       	call   80414d <_panic>
  802b81:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b8a:	89 10                	mov    %edx,(%eax)
  802b8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	74 0d                	je     802ba2 <alloc_block_FF+0x16e>
  802b95:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b9a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ba0:	eb 08                	jmp    802baa <alloc_block_FF+0x176>
  802ba2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba5:	a3 30 50 80 00       	mov    %eax,0x805030
  802baa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbc:	a1 38 50 80 00       	mov    0x805038,%eax
  802bc1:	40                   	inc    %eax
  802bc2:	a3 38 50 80 00       	mov    %eax,0x805038
  802bc7:	e9 dc 00 00 00       	jmp    802ca8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	75 65                	jne    802c3a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bd5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bd9:	75 17                	jne    802bf2 <alloc_block_FF+0x1be>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 88 4d 80 00       	push   $0x804d88
  802be3:	68 db 00 00 00       	push   $0xdb
  802be8:	68 39 4d 80 00       	push   $0x804d39
  802bed:	e8 5b 15 00 00       	call   80414d <_panic>
  802bf2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bf8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c01:	8b 40 04             	mov    0x4(%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	74 0c                	je     802c14 <alloc_block_FF+0x1e0>
  802c08:	a1 30 50 80 00       	mov    0x805030,%eax
  802c0d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c10:	89 10                	mov    %edx,(%eax)
  802c12:	eb 08                	jmp    802c1c <alloc_block_FF+0x1e8>
  802c14:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c17:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c1f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c24:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c32:	40                   	inc    %eax
  802c33:	a3 38 50 80 00       	mov    %eax,0x805038
  802c38:	eb 6e                	jmp    802ca8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3e:	74 06                	je     802c46 <alloc_block_FF+0x212>
  802c40:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c44:	75 17                	jne    802c5d <alloc_block_FF+0x229>
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	68 ac 4d 80 00       	push   $0x804dac
  802c4e:	68 df 00 00 00       	push   $0xdf
  802c53:	68 39 4d 80 00       	push   $0x804d39
  802c58:	e8 f0 14 00 00       	call   80414d <_panic>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 10                	mov    (%eax),%edx
  802c62:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c65:	89 10                	mov    %edx,(%eax)
  802c67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 0b                	je     802c7b <alloc_block_FF+0x247>
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c78:	89 50 04             	mov    %edx,0x4(%eax)
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c81:	89 10                	mov    %edx,(%eax)
  802c83:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	85 c0                	test   %eax,%eax
  802c93:	75 08                	jne    802c9d <alloc_block_FF+0x269>
  802c95:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c98:	a3 30 50 80 00       	mov    %eax,0x805030
  802c9d:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca2:	40                   	inc    %eax
  802ca3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	75 17                	jne    802cc5 <alloc_block_FF+0x291>
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 1b 4d 80 00       	push   $0x804d1b
  802cb6:	68 e1 00 00 00       	push   $0xe1
  802cbb:	68 39 4d 80 00       	push   $0x804d39
  802cc0:	e8 88 14 00 00       	call   80414d <_panic>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 10                	je     802cde <alloc_block_FF+0x2aa>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd6:	8b 52 04             	mov    0x4(%edx),%edx
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	eb 0b                	jmp    802ce9 <alloc_block_FF+0x2b5>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 04             	mov    0x4(%eax),%eax
  802ce4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 04             	mov    0x4(%eax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	74 0f                	je     802d02 <alloc_block_FF+0x2ce>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 04             	mov    0x4(%eax),%eax
  802cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfc:	8b 12                	mov    (%edx),%edx
  802cfe:	89 10                	mov    %edx,(%eax)
  802d00:	eb 0a                	jmp    802d0c <alloc_block_FF+0x2d8>
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d24:	48                   	dec    %eax
  802d25:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	6a 00                	push   $0x0
  802d2f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d32:	ff 75 b0             	pushl  -0x50(%ebp)
  802d35:	e8 cb fc ff ff       	call   802a05 <set_block_data>
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	e9 95 00 00 00       	jmp    802dd7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	6a 01                	push   $0x1
  802d47:	ff 75 b8             	pushl  -0x48(%ebp)
  802d4a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d4d:	e8 b3 fc ff ff       	call   802a05 <set_block_data>
  802d52:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d59:	75 17                	jne    802d72 <alloc_block_FF+0x33e>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 1b 4d 80 00       	push   $0x804d1b
  802d63:	68 e8 00 00 00       	push   $0xe8
  802d68:	68 39 4d 80 00       	push   $0x804d39
  802d6d:	e8 db 13 00 00       	call   80414d <_panic>
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	74 10                	je     802d8b <alloc_block_FF+0x357>
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d83:	8b 52 04             	mov    0x4(%edx),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	eb 0b                	jmp    802d96 <alloc_block_FF+0x362>
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	a3 30 50 80 00       	mov    %eax,0x805030
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 0f                	je     802daf <alloc_block_FF+0x37b>
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da9:	8b 12                	mov    (%edx),%edx
  802dab:	89 10                	mov    %edx,(%eax)
  802dad:	eb 0a                	jmp    802db9 <alloc_block_FF+0x385>
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcc:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd1:	48                   	dec    %eax
  802dd2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802dd7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dda:	e9 0f 01 00 00       	jmp    802eee <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ddf:	a1 34 50 80 00       	mov    0x805034,%eax
  802de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802deb:	74 07                	je     802df4 <alloc_block_FF+0x3c0>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	eb 05                	jmp    802df9 <alloc_block_FF+0x3c5>
  802df4:	b8 00 00 00 00       	mov    $0x0,%eax
  802df9:	a3 34 50 80 00       	mov    %eax,0x805034
  802dfe:	a1 34 50 80 00       	mov    0x805034,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	0f 85 e9 fc ff ff    	jne    802af4 <alloc_block_FF+0xc0>
  802e0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0f:	0f 85 df fc ff ff    	jne    802af4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	83 c0 08             	add    $0x8,%eax
  802e1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e1e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e28:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e2b:	01 d0                	add    %edx,%eax
  802e2d:	48                   	dec    %eax
  802e2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e34:	ba 00 00 00 00       	mov    $0x0,%edx
  802e39:	f7 75 d8             	divl   -0x28(%ebp)
  802e3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e3f:	29 d0                	sub    %edx,%eax
  802e41:	c1 e8 0c             	shr    $0xc,%eax
  802e44:	83 ec 0c             	sub    $0xc,%esp
  802e47:	50                   	push   %eax
  802e48:	e8 76 ed ff ff       	call   801bc3 <sbrk>
  802e4d:	83 c4 10             	add    $0x10,%esp
  802e50:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e53:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e57:	75 0a                	jne    802e63 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	e9 8b 00 00 00       	jmp    802eee <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e63:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	48                   	dec    %eax
  802e73:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e76:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e79:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7e:	f7 75 cc             	divl   -0x34(%ebp)
  802e81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e84:	29 d0                	sub    %edx,%eax
  802e86:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e8c:	01 d0                	add    %edx,%eax
  802e8e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802e93:	a1 40 50 80 00       	mov    0x805040,%eax
  802e98:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e9e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ea5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ea8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	48                   	dec    %eax
  802eae:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802eb1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb9:	f7 75 c4             	divl   -0x3c(%ebp)
  802ebc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ebf:	29 d0                	sub    %edx,%eax
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	6a 01                	push   $0x1
  802ec6:	50                   	push   %eax
  802ec7:	ff 75 d0             	pushl  -0x30(%ebp)
  802eca:	e8 36 fb ff ff       	call   802a05 <set_block_data>
  802ecf:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ed2:	83 ec 0c             	sub    $0xc,%esp
  802ed5:	ff 75 d0             	pushl  -0x30(%ebp)
  802ed8:	e8 1b 0a 00 00       	call   8038f8 <free_block>
  802edd:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	ff 75 08             	pushl  0x8(%ebp)
  802ee6:	e8 49 fb ff ff       	call   802a34 <alloc_block_FF>
  802eeb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
  802ef3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	83 e0 01             	and    $0x1,%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	74 03                	je     802f03 <alloc_block_BF+0x13>
  802f00:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f03:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f07:	77 07                	ja     802f10 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f09:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f10:	a1 24 50 80 00       	mov    0x805024,%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	75 73                	jne    802f8c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	83 c0 10             	add    $0x10,%eax
  802f1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f22:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2f:	01 d0                	add    %edx,%eax
  802f31:	48                   	dec    %eax
  802f32:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f38:	ba 00 00 00 00       	mov    $0x0,%edx
  802f3d:	f7 75 e0             	divl   -0x20(%ebp)
  802f40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f43:	29 d0                	sub    %edx,%eax
  802f45:	c1 e8 0c             	shr    $0xc,%eax
  802f48:	83 ec 0c             	sub    $0xc,%esp
  802f4b:	50                   	push   %eax
  802f4c:	e8 72 ec ff ff       	call   801bc3 <sbrk>
  802f51:	83 c4 10             	add    $0x10,%esp
  802f54:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f57:	83 ec 0c             	sub    $0xc,%esp
  802f5a:	6a 00                	push   $0x0
  802f5c:	e8 62 ec ff ff       	call   801bc3 <sbrk>
  802f61:	83 c4 10             	add    $0x10,%esp
  802f64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f6a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f6d:	83 ec 08             	sub    $0x8,%esp
  802f70:	50                   	push   %eax
  802f71:	ff 75 d8             	pushl  -0x28(%ebp)
  802f74:	e8 9f f8 ff ff       	call   802818 <initialize_dynamic_allocator>
  802f79:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f7c:	83 ec 0c             	sub    $0xc,%esp
  802f7f:	68 77 4d 80 00       	push   $0x804d77
  802f84:	e8 98 dc ff ff       	call   800c21 <cprintf>
  802f89:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f9a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802fa1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802fa8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb0:	e9 1d 01 00 00       	jmp    8030d2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802fbb:	83 ec 0c             	sub    $0xc,%esp
  802fbe:	ff 75 a8             	pushl  -0x58(%ebp)
  802fc1:	e8 ee f6 ff ff       	call   8026b4 <get_block_size>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	83 c0 08             	add    $0x8,%eax
  802fd2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fd5:	0f 87 ef 00 00 00    	ja     8030ca <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	83 c0 18             	add    $0x18,%eax
  802fe1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fe4:	77 1d                	ja     803003 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fec:	0f 86 d8 00 00 00    	jbe    8030ca <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ff2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ff8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ffb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ffe:	e9 c7 00 00 00       	jmp    8030ca <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	83 c0 08             	add    $0x8,%eax
  803009:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80300c:	0f 85 9d 00 00 00    	jne    8030af <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	6a 01                	push   $0x1
  803017:	ff 75 a4             	pushl  -0x5c(%ebp)
  80301a:	ff 75 a8             	pushl  -0x58(%ebp)
  80301d:	e8 e3 f9 ff ff       	call   802a05 <set_block_data>
  803022:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803029:	75 17                	jne    803042 <alloc_block_BF+0x152>
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	68 1b 4d 80 00       	push   $0x804d1b
  803033:	68 2c 01 00 00       	push   $0x12c
  803038:	68 39 4d 80 00       	push   $0x804d39
  80303d:	e8 0b 11 00 00       	call   80414d <_panic>
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 10                	je     80305b <alloc_block_BF+0x16b>
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803053:	8b 52 04             	mov    0x4(%edx),%edx
  803056:	89 50 04             	mov    %edx,0x4(%eax)
  803059:	eb 0b                	jmp    803066 <alloc_block_BF+0x176>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	a3 30 50 80 00       	mov    %eax,0x805030
  803066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803069:	8b 40 04             	mov    0x4(%eax),%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	74 0f                	je     80307f <alloc_block_BF+0x18f>
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 40 04             	mov    0x4(%eax),%eax
  803076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803079:	8b 12                	mov    (%edx),%edx
  80307b:	89 10                	mov    %edx,(%eax)
  80307d:	eb 0a                	jmp    803089 <alloc_block_BF+0x199>
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309c:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a1:	48                   	dec    %eax
  8030a2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8030a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030aa:	e9 24 04 00 00       	jmp    8034d3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8030af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030b5:	76 13                	jbe    8030ca <alloc_block_BF+0x1da>
					{
						internal = 1;
  8030b7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8030be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8030c4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8030c7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8030ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8030cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d6:	74 07                	je     8030df <alloc_block_BF+0x1ef>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	eb 05                	jmp    8030e4 <alloc_block_BF+0x1f4>
  8030df:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8030e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	0f 85 bf fe ff ff    	jne    802fb5 <alloc_block_BF+0xc5>
  8030f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fa:	0f 85 b5 fe ff ff    	jne    802fb5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803100:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803104:	0f 84 26 02 00 00    	je     803330 <alloc_block_BF+0x440>
  80310a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310e:	0f 85 1c 02 00 00    	jne    803330 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803117:	2b 45 08             	sub    0x8(%ebp),%eax
  80311a:	83 e8 08             	sub    $0x8,%eax
  80311d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	8d 50 08             	lea    0x8(%eax),%edx
  803126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803129:	01 d0                	add    %edx,%eax
  80312b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	83 c0 08             	add    $0x8,%eax
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	6a 01                	push   $0x1
  803139:	50                   	push   %eax
  80313a:	ff 75 f0             	pushl  -0x10(%ebp)
  80313d:	e8 c3 f8 ff ff       	call   802a05 <set_block_data>
  803142:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	75 68                	jne    8031b7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80314f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803153:	75 17                	jne    80316c <alloc_block_BF+0x27c>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 54 4d 80 00       	push   $0x804d54
  80315d:	68 45 01 00 00       	push   $0x145
  803162:	68 39 4d 80 00       	push   $0x804d39
  803167:	e8 e1 0f 00 00       	call   80414d <_panic>
  80316c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803172:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803175:	89 10                	mov    %edx,(%eax)
  803177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 0d                	je     80318d <alloc_block_BF+0x29d>
  803180:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803185:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803188:	89 50 04             	mov    %edx,0x4(%eax)
  80318b:	eb 08                	jmp    803195 <alloc_block_BF+0x2a5>
  80318d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803190:	a3 30 50 80 00       	mov    %eax,0x805030
  803195:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803198:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80319d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ac:	40                   	inc    %eax
  8031ad:	a3 38 50 80 00       	mov    %eax,0x805038
  8031b2:	e9 dc 00 00 00       	jmp    803293 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	75 65                	jne    803225 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031c4:	75 17                	jne    8031dd <alloc_block_BF+0x2ed>
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	68 88 4d 80 00       	push   $0x804d88
  8031ce:	68 4a 01 00 00       	push   $0x14a
  8031d3:	68 39 4d 80 00       	push   $0x804d39
  8031d8:	e8 70 0f 00 00       	call   80414d <_panic>
  8031dd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	74 0c                	je     8031ff <alloc_block_BF+0x30f>
  8031f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8031f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	eb 08                	jmp    803207 <alloc_block_BF+0x317>
  8031ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803202:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803207:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80320a:	a3 30 50 80 00       	mov    %eax,0x805030
  80320f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803218:	a1 38 50 80 00       	mov    0x805038,%eax
  80321d:	40                   	inc    %eax
  80321e:	a3 38 50 80 00       	mov    %eax,0x805038
  803223:	eb 6e                	jmp    803293 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803229:	74 06                	je     803231 <alloc_block_BF+0x341>
  80322b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80322f:	75 17                	jne    803248 <alloc_block_BF+0x358>
  803231:	83 ec 04             	sub    $0x4,%esp
  803234:	68 ac 4d 80 00       	push   $0x804dac
  803239:	68 4f 01 00 00       	push   $0x14f
  80323e:	68 39 4d 80 00       	push   $0x804d39
  803243:	e8 05 0f 00 00       	call   80414d <_panic>
  803248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324b:	8b 10                	mov    (%eax),%edx
  80324d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803250:	89 10                	mov    %edx,(%eax)
  803252:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0b                	je     803266 <alloc_block_BF+0x376>
  80325b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803263:	89 50 04             	mov    %edx,0x4(%eax)
  803266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803269:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803271:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803274:	89 50 04             	mov    %edx,0x4(%eax)
  803277:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	75 08                	jne    803288 <alloc_block_BF+0x398>
  803280:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803283:	a3 30 50 80 00       	mov    %eax,0x805030
  803288:	a1 38 50 80 00       	mov    0x805038,%eax
  80328d:	40                   	inc    %eax
  80328e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803293:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803297:	75 17                	jne    8032b0 <alloc_block_BF+0x3c0>
  803299:	83 ec 04             	sub    $0x4,%esp
  80329c:	68 1b 4d 80 00       	push   $0x804d1b
  8032a1:	68 51 01 00 00       	push   $0x151
  8032a6:	68 39 4d 80 00       	push   $0x804d39
  8032ab:	e8 9d 0e 00 00       	call   80414d <_panic>
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 10                	je     8032c9 <alloc_block_BF+0x3d9>
  8032b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c1:	8b 52 04             	mov    0x4(%edx),%edx
  8032c4:	89 50 04             	mov    %edx,0x4(%eax)
  8032c7:	eb 0b                	jmp    8032d4 <alloc_block_BF+0x3e4>
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 40 04             	mov    0x4(%eax),%eax
  8032cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d7:	8b 40 04             	mov    0x4(%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0f                	je     8032ed <alloc_block_BF+0x3fd>
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e1:	8b 40 04             	mov    0x4(%eax),%eax
  8032e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e7:	8b 12                	mov    (%edx),%edx
  8032e9:	89 10                	mov    %edx,(%eax)
  8032eb:	eb 0a                	jmp    8032f7 <alloc_block_BF+0x407>
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330a:	a1 38 50 80 00       	mov    0x805038,%eax
  80330f:	48                   	dec    %eax
  803310:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	6a 00                	push   $0x0
  80331a:	ff 75 d0             	pushl  -0x30(%ebp)
  80331d:	ff 75 cc             	pushl  -0x34(%ebp)
  803320:	e8 e0 f6 ff ff       	call   802a05 <set_block_data>
  803325:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332b:	e9 a3 01 00 00       	jmp    8034d3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803330:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803334:	0f 85 9d 00 00 00    	jne    8033d7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	6a 01                	push   $0x1
  80333f:	ff 75 ec             	pushl  -0x14(%ebp)
  803342:	ff 75 f0             	pushl  -0x10(%ebp)
  803345:	e8 bb f6 ff ff       	call   802a05 <set_block_data>
  80334a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80334d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803351:	75 17                	jne    80336a <alloc_block_BF+0x47a>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 1b 4d 80 00       	push   $0x804d1b
  80335b:	68 58 01 00 00       	push   $0x158
  803360:	68 39 4d 80 00       	push   $0x804d39
  803365:	e8 e3 0d 00 00       	call   80414d <_panic>
  80336a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	85 c0                	test   %eax,%eax
  803371:	74 10                	je     803383 <alloc_block_BF+0x493>
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337b:	8b 52 04             	mov    0x4(%edx),%edx
  80337e:	89 50 04             	mov    %edx,0x4(%eax)
  803381:	eb 0b                	jmp    80338e <alloc_block_BF+0x49e>
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	a3 30 50 80 00       	mov    %eax,0x805030
  80338e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803391:	8b 40 04             	mov    0x4(%eax),%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	74 0f                	je     8033a7 <alloc_block_BF+0x4b7>
  803398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339b:	8b 40 04             	mov    0x4(%eax),%eax
  80339e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033a1:	8b 12                	mov    (%edx),%edx
  8033a3:	89 10                	mov    %edx,(%eax)
  8033a5:	eb 0a                	jmp    8033b1 <alloc_block_BF+0x4c1>
  8033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033aa:	8b 00                	mov    (%eax),%eax
  8033ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c4:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c9:	48                   	dec    %eax
  8033ca:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d2:	e9 fc 00 00 00       	jmp    8034d3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	83 c0 08             	add    $0x8,%eax
  8033dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033e0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033e7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033ea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033ed:	01 d0                	add    %edx,%eax
  8033ef:	48                   	dec    %eax
  8033f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8033f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8033fb:	f7 75 c4             	divl   -0x3c(%ebp)
  8033fe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803401:	29 d0                	sub    %edx,%eax
  803403:	c1 e8 0c             	shr    $0xc,%eax
  803406:	83 ec 0c             	sub    $0xc,%esp
  803409:	50                   	push   %eax
  80340a:	e8 b4 e7 ff ff       	call   801bc3 <sbrk>
  80340f:	83 c4 10             	add    $0x10,%esp
  803412:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803415:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803419:	75 0a                	jne    803425 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80341b:	b8 00 00 00 00       	mov    $0x0,%eax
  803420:	e9 ae 00 00 00       	jmp    8034d3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803425:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80342c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80342f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803432:	01 d0                	add    %edx,%eax
  803434:	48                   	dec    %eax
  803435:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803438:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80343b:	ba 00 00 00 00       	mov    $0x0,%edx
  803440:	f7 75 b8             	divl   -0x48(%ebp)
  803443:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803446:	29 d0                	sub    %edx,%eax
  803448:	8d 50 fc             	lea    -0x4(%eax),%edx
  80344b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80344e:	01 d0                	add    %edx,%eax
  803450:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803455:	a1 40 50 80 00       	mov    0x805040,%eax
  80345a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803460:	83 ec 0c             	sub    $0xc,%esp
  803463:	68 e0 4d 80 00       	push   $0x804de0
  803468:	e8 b4 d7 ff ff       	call   800c21 <cprintf>
  80346d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803470:	83 ec 08             	sub    $0x8,%esp
  803473:	ff 75 bc             	pushl  -0x44(%ebp)
  803476:	68 e5 4d 80 00       	push   $0x804de5
  80347b:	e8 a1 d7 ff ff       	call   800c21 <cprintf>
  803480:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803483:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80348a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80348d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803490:	01 d0                	add    %edx,%eax
  803492:	48                   	dec    %eax
  803493:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803496:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803499:	ba 00 00 00 00       	mov    $0x0,%edx
  80349e:	f7 75 b0             	divl   -0x50(%ebp)
  8034a1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034a4:	29 d0                	sub    %edx,%eax
  8034a6:	83 ec 04             	sub    $0x4,%esp
  8034a9:	6a 01                	push   $0x1
  8034ab:	50                   	push   %eax
  8034ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8034af:	e8 51 f5 ff ff       	call   802a05 <set_block_data>
  8034b4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8034b7:	83 ec 0c             	sub    $0xc,%esp
  8034ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8034bd:	e8 36 04 00 00       	call   8038f8 <free_block>
  8034c2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8034c5:	83 ec 0c             	sub    $0xc,%esp
  8034c8:	ff 75 08             	pushl  0x8(%ebp)
  8034cb:	e8 20 fa ff ff       	call   802ef0 <alloc_block_BF>
  8034d0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8034d3:	c9                   	leave  
  8034d4:	c3                   	ret    

008034d5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8034d5:	55                   	push   %ebp
  8034d6:	89 e5                	mov    %esp,%ebp
  8034d8:	53                   	push   %ebx
  8034d9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8034dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8034ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ee:	74 1e                	je     80350e <merging+0x39>
  8034f0:	ff 75 08             	pushl  0x8(%ebp)
  8034f3:	e8 bc f1 ff ff       	call   8026b4 <get_block_size>
  8034f8:	83 c4 04             	add    $0x4,%esp
  8034fb:	89 c2                	mov    %eax,%edx
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	01 d0                	add    %edx,%eax
  803502:	3b 45 10             	cmp    0x10(%ebp),%eax
  803505:	75 07                	jne    80350e <merging+0x39>
		prev_is_free = 1;
  803507:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80350e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803512:	74 1e                	je     803532 <merging+0x5d>
  803514:	ff 75 10             	pushl  0x10(%ebp)
  803517:	e8 98 f1 ff ff       	call   8026b4 <get_block_size>
  80351c:	83 c4 04             	add    $0x4,%esp
  80351f:	89 c2                	mov    %eax,%edx
  803521:	8b 45 10             	mov    0x10(%ebp),%eax
  803524:	01 d0                	add    %edx,%eax
  803526:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803529:	75 07                	jne    803532 <merging+0x5d>
		next_is_free = 1;
  80352b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803536:	0f 84 cc 00 00 00    	je     803608 <merging+0x133>
  80353c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803540:	0f 84 c2 00 00 00    	je     803608 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803546:	ff 75 08             	pushl  0x8(%ebp)
  803549:	e8 66 f1 ff ff       	call   8026b4 <get_block_size>
  80354e:	83 c4 04             	add    $0x4,%esp
  803551:	89 c3                	mov    %eax,%ebx
  803553:	ff 75 10             	pushl  0x10(%ebp)
  803556:	e8 59 f1 ff ff       	call   8026b4 <get_block_size>
  80355b:	83 c4 04             	add    $0x4,%esp
  80355e:	01 c3                	add    %eax,%ebx
  803560:	ff 75 0c             	pushl  0xc(%ebp)
  803563:	e8 4c f1 ff ff       	call   8026b4 <get_block_size>
  803568:	83 c4 04             	add    $0x4,%esp
  80356b:	01 d8                	add    %ebx,%eax
  80356d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803570:	6a 00                	push   $0x0
  803572:	ff 75 ec             	pushl  -0x14(%ebp)
  803575:	ff 75 08             	pushl  0x8(%ebp)
  803578:	e8 88 f4 ff ff       	call   802a05 <set_block_data>
  80357d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803580:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803584:	75 17                	jne    80359d <merging+0xc8>
  803586:	83 ec 04             	sub    $0x4,%esp
  803589:	68 1b 4d 80 00       	push   $0x804d1b
  80358e:	68 7d 01 00 00       	push   $0x17d
  803593:	68 39 4d 80 00       	push   $0x804d39
  803598:	e8 b0 0b 00 00       	call   80414d <_panic>
  80359d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a0:	8b 00                	mov    (%eax),%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	74 10                	je     8035b6 <merging+0xe1>
  8035a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ae:	8b 52 04             	mov    0x4(%edx),%edx
  8035b1:	89 50 04             	mov    %edx,0x4(%eax)
  8035b4:	eb 0b                	jmp    8035c1 <merging+0xec>
  8035b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b9:	8b 40 04             	mov    0x4(%eax),%eax
  8035bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c4:	8b 40 04             	mov    0x4(%eax),%eax
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	74 0f                	je     8035da <merging+0x105>
  8035cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ce:	8b 40 04             	mov    0x4(%eax),%eax
  8035d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d4:	8b 12                	mov    (%edx),%edx
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	eb 0a                	jmp    8035e4 <merging+0x10f>
  8035da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fc:	48                   	dec    %eax
  8035fd:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803602:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803603:	e9 ea 02 00 00       	jmp    8038f2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360c:	74 3b                	je     803649 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80360e:	83 ec 0c             	sub    $0xc,%esp
  803611:	ff 75 08             	pushl  0x8(%ebp)
  803614:	e8 9b f0 ff ff       	call   8026b4 <get_block_size>
  803619:	83 c4 10             	add    $0x10,%esp
  80361c:	89 c3                	mov    %eax,%ebx
  80361e:	83 ec 0c             	sub    $0xc,%esp
  803621:	ff 75 10             	pushl  0x10(%ebp)
  803624:	e8 8b f0 ff ff       	call   8026b4 <get_block_size>
  803629:	83 c4 10             	add    $0x10,%esp
  80362c:	01 d8                	add    %ebx,%eax
  80362e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803631:	83 ec 04             	sub    $0x4,%esp
  803634:	6a 00                	push   $0x0
  803636:	ff 75 e8             	pushl  -0x18(%ebp)
  803639:	ff 75 08             	pushl  0x8(%ebp)
  80363c:	e8 c4 f3 ff ff       	call   802a05 <set_block_data>
  803641:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803644:	e9 a9 02 00 00       	jmp    8038f2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803649:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80364d:	0f 84 2d 01 00 00    	je     803780 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803653:	83 ec 0c             	sub    $0xc,%esp
  803656:	ff 75 10             	pushl  0x10(%ebp)
  803659:	e8 56 f0 ff ff       	call   8026b4 <get_block_size>
  80365e:	83 c4 10             	add    $0x10,%esp
  803661:	89 c3                	mov    %eax,%ebx
  803663:	83 ec 0c             	sub    $0xc,%esp
  803666:	ff 75 0c             	pushl  0xc(%ebp)
  803669:	e8 46 f0 ff ff       	call   8026b4 <get_block_size>
  80366e:	83 c4 10             	add    $0x10,%esp
  803671:	01 d8                	add    %ebx,%eax
  803673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803676:	83 ec 04             	sub    $0x4,%esp
  803679:	6a 00                	push   $0x0
  80367b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80367e:	ff 75 10             	pushl  0x10(%ebp)
  803681:	e8 7f f3 ff ff       	call   802a05 <set_block_data>
  803686:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803689:	8b 45 10             	mov    0x10(%ebp),%eax
  80368c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80368f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803693:	74 06                	je     80369b <merging+0x1c6>
  803695:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803699:	75 17                	jne    8036b2 <merging+0x1dd>
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	68 f4 4d 80 00       	push   $0x804df4
  8036a3:	68 8d 01 00 00       	push   $0x18d
  8036a8:	68 39 4d 80 00       	push   $0x804d39
  8036ad:	e8 9b 0a 00 00       	call   80414d <_panic>
  8036b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b5:	8b 50 04             	mov    0x4(%eax),%edx
  8036b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c4:	89 10                	mov    %edx,(%eax)
  8036c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c9:	8b 40 04             	mov    0x4(%eax),%eax
  8036cc:	85 c0                	test   %eax,%eax
  8036ce:	74 0d                	je     8036dd <merging+0x208>
  8036d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d3:	8b 40 04             	mov    0x4(%eax),%eax
  8036d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036d9:	89 10                	mov    %edx,(%eax)
  8036db:	eb 08                	jmp    8036e5 <merging+0x210>
  8036dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036eb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f3:	40                   	inc    %eax
  8036f4:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8036f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036fd:	75 17                	jne    803716 <merging+0x241>
  8036ff:	83 ec 04             	sub    $0x4,%esp
  803702:	68 1b 4d 80 00       	push   $0x804d1b
  803707:	68 8e 01 00 00       	push   $0x18e
  80370c:	68 39 4d 80 00       	push   $0x804d39
  803711:	e8 37 0a 00 00       	call   80414d <_panic>
  803716:	8b 45 0c             	mov    0xc(%ebp),%eax
  803719:	8b 00                	mov    (%eax),%eax
  80371b:	85 c0                	test   %eax,%eax
  80371d:	74 10                	je     80372f <merging+0x25a>
  80371f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	8b 55 0c             	mov    0xc(%ebp),%edx
  803727:	8b 52 04             	mov    0x4(%edx),%edx
  80372a:	89 50 04             	mov    %edx,0x4(%eax)
  80372d:	eb 0b                	jmp    80373a <merging+0x265>
  80372f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803732:	8b 40 04             	mov    0x4(%eax),%eax
  803735:	a3 30 50 80 00       	mov    %eax,0x805030
  80373a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	85 c0                	test   %eax,%eax
  803742:	74 0f                	je     803753 <merging+0x27e>
  803744:	8b 45 0c             	mov    0xc(%ebp),%eax
  803747:	8b 40 04             	mov    0x4(%eax),%eax
  80374a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374d:	8b 12                	mov    (%edx),%edx
  80374f:	89 10                	mov    %edx,(%eax)
  803751:	eb 0a                	jmp    80375d <merging+0x288>
  803753:	8b 45 0c             	mov    0xc(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80375d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803766:	8b 45 0c             	mov    0xc(%ebp),%eax
  803769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803770:	a1 38 50 80 00       	mov    0x805038,%eax
  803775:	48                   	dec    %eax
  803776:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80377b:	e9 72 01 00 00       	jmp    8038f2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803780:	8b 45 10             	mov    0x10(%ebp),%eax
  803783:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378a:	74 79                	je     803805 <merging+0x330>
  80378c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803790:	74 73                	je     803805 <merging+0x330>
  803792:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803796:	74 06                	je     80379e <merging+0x2c9>
  803798:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80379c:	75 17                	jne    8037b5 <merging+0x2e0>
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	68 ac 4d 80 00       	push   $0x804dac
  8037a6:	68 94 01 00 00       	push   $0x194
  8037ab:	68 39 4d 80 00       	push   $0x804d39
  8037b0:	e8 98 09 00 00       	call   80414d <_panic>
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	8b 10                	mov    (%eax),%edx
  8037ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037bd:	89 10                	mov    %edx,(%eax)
  8037bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	85 c0                	test   %eax,%eax
  8037c6:	74 0b                	je     8037d3 <merging+0x2fe>
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	8b 00                	mov    (%eax),%eax
  8037cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037d0:	89 50 04             	mov    %edx,0x4(%eax)
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037d9:	89 10                	mov    %edx,(%eax)
  8037db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037de:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e1:	89 50 04             	mov    %edx,0x4(%eax)
  8037e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	75 08                	jne    8037f5 <merging+0x320>
  8037ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037fa:	40                   	inc    %eax
  8037fb:	a3 38 50 80 00       	mov    %eax,0x805038
  803800:	e9 ce 00 00 00       	jmp    8038d3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803805:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803809:	74 65                	je     803870 <merging+0x39b>
  80380b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80380f:	75 17                	jne    803828 <merging+0x353>
  803811:	83 ec 04             	sub    $0x4,%esp
  803814:	68 88 4d 80 00       	push   $0x804d88
  803819:	68 95 01 00 00       	push   $0x195
  80381e:	68 39 4d 80 00       	push   $0x804d39
  803823:	e8 25 09 00 00       	call   80414d <_panic>
  803828:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80382e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803831:	89 50 04             	mov    %edx,0x4(%eax)
  803834:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803837:	8b 40 04             	mov    0x4(%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	74 0c                	je     80384a <merging+0x375>
  80383e:	a1 30 50 80 00       	mov    0x805030,%eax
  803843:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803846:	89 10                	mov    %edx,(%eax)
  803848:	eb 08                	jmp    803852 <merging+0x37d>
  80384a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80384d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803852:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803855:	a3 30 50 80 00       	mov    %eax,0x805030
  80385a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803863:	a1 38 50 80 00       	mov    0x805038,%eax
  803868:	40                   	inc    %eax
  803869:	a3 38 50 80 00       	mov    %eax,0x805038
  80386e:	eb 63                	jmp    8038d3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803870:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803874:	75 17                	jne    80388d <merging+0x3b8>
  803876:	83 ec 04             	sub    $0x4,%esp
  803879:	68 54 4d 80 00       	push   $0x804d54
  80387e:	68 98 01 00 00       	push   $0x198
  803883:	68 39 4d 80 00       	push   $0x804d39
  803888:	e8 c0 08 00 00       	call   80414d <_panic>
  80388d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803893:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803896:	89 10                	mov    %edx,(%eax)
  803898:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	85 c0                	test   %eax,%eax
  80389f:	74 0d                	je     8038ae <merging+0x3d9>
  8038a1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038a9:	89 50 04             	mov    %edx,0x4(%eax)
  8038ac:	eb 08                	jmp    8038b6 <merging+0x3e1>
  8038ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cd:	40                   	inc    %eax
  8038ce:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8038d3:	83 ec 0c             	sub    $0xc,%esp
  8038d6:	ff 75 10             	pushl  0x10(%ebp)
  8038d9:	e8 d6 ed ff ff       	call   8026b4 <get_block_size>
  8038de:	83 c4 10             	add    $0x10,%esp
  8038e1:	83 ec 04             	sub    $0x4,%esp
  8038e4:	6a 00                	push   $0x0
  8038e6:	50                   	push   %eax
  8038e7:	ff 75 10             	pushl  0x10(%ebp)
  8038ea:	e8 16 f1 ff ff       	call   802a05 <set_block_data>
  8038ef:	83 c4 10             	add    $0x10,%esp
	}
}
  8038f2:	90                   	nop
  8038f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038f6:	c9                   	leave  
  8038f7:	c3                   	ret    

008038f8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8038f8:	55                   	push   %ebp
  8038f9:	89 e5                	mov    %esp,%ebp
  8038fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8038fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803903:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803906:	a1 30 50 80 00       	mov    0x805030,%eax
  80390b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80390e:	73 1b                	jae    80392b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803910:	a1 30 50 80 00       	mov    0x805030,%eax
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	ff 75 08             	pushl  0x8(%ebp)
  80391b:	6a 00                	push   $0x0
  80391d:	50                   	push   %eax
  80391e:	e8 b2 fb ff ff       	call   8034d5 <merging>
  803923:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803926:	e9 8b 00 00 00       	jmp    8039b6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80392b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803930:	3b 45 08             	cmp    0x8(%ebp),%eax
  803933:	76 18                	jbe    80394d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803935:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80393a:	83 ec 04             	sub    $0x4,%esp
  80393d:	ff 75 08             	pushl  0x8(%ebp)
  803940:	50                   	push   %eax
  803941:	6a 00                	push   $0x0
  803943:	e8 8d fb ff ff       	call   8034d5 <merging>
  803948:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80394b:	eb 69                	jmp    8039b6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80394d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803952:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803955:	eb 39                	jmp    803990 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80395d:	73 29                	jae    803988 <free_block+0x90>
  80395f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	3b 45 08             	cmp    0x8(%ebp),%eax
  803967:	76 1f                	jbe    803988 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803971:	83 ec 04             	sub    $0x4,%esp
  803974:	ff 75 08             	pushl  0x8(%ebp)
  803977:	ff 75 f0             	pushl  -0x10(%ebp)
  80397a:	ff 75 f4             	pushl  -0xc(%ebp)
  80397d:	e8 53 fb ff ff       	call   8034d5 <merging>
  803982:	83 c4 10             	add    $0x10,%esp
			break;
  803985:	90                   	nop
		}
	}
}
  803986:	eb 2e                	jmp    8039b6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803988:	a1 34 50 80 00       	mov    0x805034,%eax
  80398d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803994:	74 07                	je     80399d <free_block+0xa5>
  803996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	eb 05                	jmp    8039a2 <free_block+0xaa>
  80399d:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a2:	a3 34 50 80 00       	mov    %eax,0x805034
  8039a7:	a1 34 50 80 00       	mov    0x805034,%eax
  8039ac:	85 c0                	test   %eax,%eax
  8039ae:	75 a7                	jne    803957 <free_block+0x5f>
  8039b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b4:	75 a1                	jne    803957 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039b6:	90                   	nop
  8039b7:	c9                   	leave  
  8039b8:	c3                   	ret    

008039b9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8039b9:	55                   	push   %ebp
  8039ba:	89 e5                	mov    %esp,%ebp
  8039bc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8039bf:	ff 75 08             	pushl  0x8(%ebp)
  8039c2:	e8 ed ec ff ff       	call   8026b4 <get_block_size>
  8039c7:	83 c4 04             	add    $0x4,%esp
  8039ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8039cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8039d4:	eb 17                	jmp    8039ed <copy_data+0x34>
  8039d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8039d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039dc:	01 c2                	add    %eax,%edx
  8039de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	01 c8                	add    %ecx,%eax
  8039e6:	8a 00                	mov    (%eax),%al
  8039e8:	88 02                	mov    %al,(%edx)
  8039ea:	ff 45 fc             	incl   -0x4(%ebp)
  8039ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8039f3:	72 e1                	jb     8039d6 <copy_data+0x1d>
}
  8039f5:	90                   	nop
  8039f6:	c9                   	leave  
  8039f7:	c3                   	ret    

008039f8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8039f8:	55                   	push   %ebp
  8039f9:	89 e5                	mov    %esp,%ebp
  8039fb:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8039fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a02:	75 23                	jne    803a27 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a08:	74 13                	je     803a1d <realloc_block_FF+0x25>
  803a0a:	83 ec 0c             	sub    $0xc,%esp
  803a0d:	ff 75 0c             	pushl  0xc(%ebp)
  803a10:	e8 1f f0 ff ff       	call   802a34 <alloc_block_FF>
  803a15:	83 c4 10             	add    $0x10,%esp
  803a18:	e9 f4 06 00 00       	jmp    804111 <realloc_block_FF+0x719>
		return NULL;
  803a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a22:	e9 ea 06 00 00       	jmp    804111 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803a27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a2b:	75 18                	jne    803a45 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a2d:	83 ec 0c             	sub    $0xc,%esp
  803a30:	ff 75 08             	pushl  0x8(%ebp)
  803a33:	e8 c0 fe ff ff       	call   8038f8 <free_block>
  803a38:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a40:	e9 cc 06 00 00       	jmp    804111 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803a45:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a49:	77 07                	ja     803a52 <realloc_block_FF+0x5a>
  803a4b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a55:	83 e0 01             	and    $0x1,%eax
  803a58:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a5e:	83 c0 08             	add    $0x8,%eax
  803a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a64:	83 ec 0c             	sub    $0xc,%esp
  803a67:	ff 75 08             	pushl  0x8(%ebp)
  803a6a:	e8 45 ec ff ff       	call   8026b4 <get_block_size>
  803a6f:	83 c4 10             	add    $0x10,%esp
  803a72:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a78:	83 e8 08             	sub    $0x8,%eax
  803a7b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a81:	83 e8 04             	sub    $0x4,%eax
  803a84:	8b 00                	mov    (%eax),%eax
  803a86:	83 e0 fe             	and    $0xfffffffe,%eax
  803a89:	89 c2                	mov    %eax,%edx
  803a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8e:	01 d0                	add    %edx,%eax
  803a90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a93:	83 ec 0c             	sub    $0xc,%esp
  803a96:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a99:	e8 16 ec ff ff       	call   8026b4 <get_block_size>
  803a9e:	83 c4 10             	add    $0x10,%esp
  803aa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa7:	83 e8 08             	sub    $0x8,%eax
  803aaa:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ab3:	75 08                	jne    803abd <realloc_block_FF+0xc5>
	{
		 return va;
  803ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab8:	e9 54 06 00 00       	jmp    804111 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ac3:	0f 83 e5 03 00 00    	jae    803eae <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803acc:	2b 45 0c             	sub    0xc(%ebp),%eax
  803acf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ad2:	83 ec 0c             	sub    $0xc,%esp
  803ad5:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ad8:	e8 f0 eb ff ff       	call   8026cd <is_free_block>
  803add:	83 c4 10             	add    $0x10,%esp
  803ae0:	84 c0                	test   %al,%al
  803ae2:	0f 84 3b 01 00 00    	je     803c23 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803ae8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aeb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803aee:	01 d0                	add    %edx,%eax
  803af0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803af3:	83 ec 04             	sub    $0x4,%esp
  803af6:	6a 01                	push   $0x1
  803af8:	ff 75 f0             	pushl  -0x10(%ebp)
  803afb:	ff 75 08             	pushl  0x8(%ebp)
  803afe:	e8 02 ef ff ff       	call   802a05 <set_block_data>
  803b03:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	83 e8 04             	sub    $0x4,%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	83 e0 fe             	and    $0xfffffffe,%eax
  803b11:	89 c2                	mov    %eax,%edx
  803b13:	8b 45 08             	mov    0x8(%ebp),%eax
  803b16:	01 d0                	add    %edx,%eax
  803b18:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b1b:	83 ec 04             	sub    $0x4,%esp
  803b1e:	6a 00                	push   $0x0
  803b20:	ff 75 cc             	pushl  -0x34(%ebp)
  803b23:	ff 75 c8             	pushl  -0x38(%ebp)
  803b26:	e8 da ee ff ff       	call   802a05 <set_block_data>
  803b2b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b32:	74 06                	je     803b3a <realloc_block_FF+0x142>
  803b34:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b38:	75 17                	jne    803b51 <realloc_block_FF+0x159>
  803b3a:	83 ec 04             	sub    $0x4,%esp
  803b3d:	68 ac 4d 80 00       	push   $0x804dac
  803b42:	68 f6 01 00 00       	push   $0x1f6
  803b47:	68 39 4d 80 00       	push   $0x804d39
  803b4c:	e8 fc 05 00 00       	call   80414d <_panic>
  803b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b54:	8b 10                	mov    (%eax),%edx
  803b56:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b59:	89 10                	mov    %edx,(%eax)
  803b5b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b5e:	8b 00                	mov    (%eax),%eax
  803b60:	85 c0                	test   %eax,%eax
  803b62:	74 0b                	je     803b6f <realloc_block_FF+0x177>
  803b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b67:	8b 00                	mov    (%eax),%eax
  803b69:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b6c:	89 50 04             	mov    %edx,0x4(%eax)
  803b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b75:	89 10                	mov    %edx,(%eax)
  803b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b7d:	89 50 04             	mov    %edx,0x4(%eax)
  803b80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	75 08                	jne    803b91 <realloc_block_FF+0x199>
  803b89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b8c:	a3 30 50 80 00       	mov    %eax,0x805030
  803b91:	a1 38 50 80 00       	mov    0x805038,%eax
  803b96:	40                   	inc    %eax
  803b97:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ba0:	75 17                	jne    803bb9 <realloc_block_FF+0x1c1>
  803ba2:	83 ec 04             	sub    $0x4,%esp
  803ba5:	68 1b 4d 80 00       	push   $0x804d1b
  803baa:	68 f7 01 00 00       	push   $0x1f7
  803baf:	68 39 4d 80 00       	push   $0x804d39
  803bb4:	e8 94 05 00 00       	call   80414d <_panic>
  803bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbc:	8b 00                	mov    (%eax),%eax
  803bbe:	85 c0                	test   %eax,%eax
  803bc0:	74 10                	je     803bd2 <realloc_block_FF+0x1da>
  803bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bca:	8b 52 04             	mov    0x4(%edx),%edx
  803bcd:	89 50 04             	mov    %edx,0x4(%eax)
  803bd0:	eb 0b                	jmp    803bdd <realloc_block_FF+0x1e5>
  803bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd5:	8b 40 04             	mov    0x4(%eax),%eax
  803bd8:	a3 30 50 80 00       	mov    %eax,0x805030
  803bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be0:	8b 40 04             	mov    0x4(%eax),%eax
  803be3:	85 c0                	test   %eax,%eax
  803be5:	74 0f                	je     803bf6 <realloc_block_FF+0x1fe>
  803be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bea:	8b 40 04             	mov    0x4(%eax),%eax
  803bed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf0:	8b 12                	mov    (%edx),%edx
  803bf2:	89 10                	mov    %edx,(%eax)
  803bf4:	eb 0a                	jmp    803c00 <realloc_block_FF+0x208>
  803bf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf9:	8b 00                	mov    (%eax),%eax
  803bfb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c13:	a1 38 50 80 00       	mov    0x805038,%eax
  803c18:	48                   	dec    %eax
  803c19:	a3 38 50 80 00       	mov    %eax,0x805038
  803c1e:	e9 83 02 00 00       	jmp    803ea6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803c23:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c27:	0f 86 69 02 00 00    	jbe    803e96 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c2d:	83 ec 04             	sub    $0x4,%esp
  803c30:	6a 01                	push   $0x1
  803c32:	ff 75 f0             	pushl  -0x10(%ebp)
  803c35:	ff 75 08             	pushl  0x8(%ebp)
  803c38:	e8 c8 ed ff ff       	call   802a05 <set_block_data>
  803c3d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c40:	8b 45 08             	mov    0x8(%ebp),%eax
  803c43:	83 e8 04             	sub    $0x4,%eax
  803c46:	8b 00                	mov    (%eax),%eax
  803c48:	83 e0 fe             	and    $0xfffffffe,%eax
  803c4b:	89 c2                	mov    %eax,%edx
  803c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c50:	01 d0                	add    %edx,%eax
  803c52:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c55:	a1 38 50 80 00       	mov    0x805038,%eax
  803c5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c5d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c61:	75 68                	jne    803ccb <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c63:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c67:	75 17                	jne    803c80 <realloc_block_FF+0x288>
  803c69:	83 ec 04             	sub    $0x4,%esp
  803c6c:	68 54 4d 80 00       	push   $0x804d54
  803c71:	68 06 02 00 00       	push   $0x206
  803c76:	68 39 4d 80 00       	push   $0x804d39
  803c7b:	e8 cd 04 00 00       	call   80414d <_panic>
  803c80:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803c86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c89:	89 10                	mov    %edx,(%eax)
  803c8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	85 c0                	test   %eax,%eax
  803c92:	74 0d                	je     803ca1 <realloc_block_FF+0x2a9>
  803c94:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c9c:	89 50 04             	mov    %edx,0x4(%eax)
  803c9f:	eb 08                	jmp    803ca9 <realloc_block_FF+0x2b1>
  803ca1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca4:	a3 30 50 80 00       	mov    %eax,0x805030
  803ca9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cbb:	a1 38 50 80 00       	mov    0x805038,%eax
  803cc0:	40                   	inc    %eax
  803cc1:	a3 38 50 80 00       	mov    %eax,0x805038
  803cc6:	e9 b0 01 00 00       	jmp    803e7b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803ccb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803cd0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cd3:	76 68                	jbe    803d3d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cd5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cd9:	75 17                	jne    803cf2 <realloc_block_FF+0x2fa>
  803cdb:	83 ec 04             	sub    $0x4,%esp
  803cde:	68 54 4d 80 00       	push   $0x804d54
  803ce3:	68 0b 02 00 00       	push   $0x20b
  803ce8:	68 39 4d 80 00       	push   $0x804d39
  803ced:	e8 5b 04 00 00       	call   80414d <_panic>
  803cf2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803cf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfb:	89 10                	mov    %edx,(%eax)
  803cfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	85 c0                	test   %eax,%eax
  803d04:	74 0d                	je     803d13 <realloc_block_FF+0x31b>
  803d06:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d0b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d0e:	89 50 04             	mov    %edx,0x4(%eax)
  803d11:	eb 08                	jmp    803d1b <realloc_block_FF+0x323>
  803d13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d16:	a3 30 50 80 00       	mov    %eax,0x805030
  803d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d1e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d2d:	a1 38 50 80 00       	mov    0x805038,%eax
  803d32:	40                   	inc    %eax
  803d33:	a3 38 50 80 00       	mov    %eax,0x805038
  803d38:	e9 3e 01 00 00       	jmp    803e7b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d3d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d42:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d45:	73 68                	jae    803daf <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d47:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d4b:	75 17                	jne    803d64 <realloc_block_FF+0x36c>
  803d4d:	83 ec 04             	sub    $0x4,%esp
  803d50:	68 88 4d 80 00       	push   $0x804d88
  803d55:	68 10 02 00 00       	push   $0x210
  803d5a:	68 39 4d 80 00       	push   $0x804d39
  803d5f:	e8 e9 03 00 00       	call   80414d <_panic>
  803d64:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803d6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6d:	89 50 04             	mov    %edx,0x4(%eax)
  803d70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d73:	8b 40 04             	mov    0x4(%eax),%eax
  803d76:	85 c0                	test   %eax,%eax
  803d78:	74 0c                	je     803d86 <realloc_block_FF+0x38e>
  803d7a:	a1 30 50 80 00       	mov    0x805030,%eax
  803d7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d82:	89 10                	mov    %edx,(%eax)
  803d84:	eb 08                	jmp    803d8e <realloc_block_FF+0x396>
  803d86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d89:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d91:	a3 30 50 80 00       	mov    %eax,0x805030
  803d96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d9f:	a1 38 50 80 00       	mov    0x805038,%eax
  803da4:	40                   	inc    %eax
  803da5:	a3 38 50 80 00       	mov    %eax,0x805038
  803daa:	e9 cc 00 00 00       	jmp    803e7b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803db6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dbe:	e9 8a 00 00 00       	jmp    803e4d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803dc9:	73 7a                	jae    803e45 <realloc_block_FF+0x44d>
  803dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dce:	8b 00                	mov    (%eax),%eax
  803dd0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803dd3:	73 70                	jae    803e45 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dd9:	74 06                	je     803de1 <realloc_block_FF+0x3e9>
  803ddb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ddf:	75 17                	jne    803df8 <realloc_block_FF+0x400>
  803de1:	83 ec 04             	sub    $0x4,%esp
  803de4:	68 ac 4d 80 00       	push   $0x804dac
  803de9:	68 1a 02 00 00       	push   $0x21a
  803dee:	68 39 4d 80 00       	push   $0x804d39
  803df3:	e8 55 03 00 00       	call   80414d <_panic>
  803df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfb:	8b 10                	mov    (%eax),%edx
  803dfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e00:	89 10                	mov    %edx,(%eax)
  803e02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e05:	8b 00                	mov    (%eax),%eax
  803e07:	85 c0                	test   %eax,%eax
  803e09:	74 0b                	je     803e16 <realloc_block_FF+0x41e>
  803e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0e:	8b 00                	mov    (%eax),%eax
  803e10:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e13:	89 50 04             	mov    %edx,0x4(%eax)
  803e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e19:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e1c:	89 10                	mov    %edx,(%eax)
  803e1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e24:	89 50 04             	mov    %edx,0x4(%eax)
  803e27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2a:	8b 00                	mov    (%eax),%eax
  803e2c:	85 c0                	test   %eax,%eax
  803e2e:	75 08                	jne    803e38 <realloc_block_FF+0x440>
  803e30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e33:	a3 30 50 80 00       	mov    %eax,0x805030
  803e38:	a1 38 50 80 00       	mov    0x805038,%eax
  803e3d:	40                   	inc    %eax
  803e3e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803e43:	eb 36                	jmp    803e7b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e45:	a1 34 50 80 00       	mov    0x805034,%eax
  803e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e51:	74 07                	je     803e5a <realloc_block_FF+0x462>
  803e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e56:	8b 00                	mov    (%eax),%eax
  803e58:	eb 05                	jmp    803e5f <realloc_block_FF+0x467>
  803e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5f:	a3 34 50 80 00       	mov    %eax,0x805034
  803e64:	a1 34 50 80 00       	mov    0x805034,%eax
  803e69:	85 c0                	test   %eax,%eax
  803e6b:	0f 85 52 ff ff ff    	jne    803dc3 <realloc_block_FF+0x3cb>
  803e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e75:	0f 85 48 ff ff ff    	jne    803dc3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e7b:	83 ec 04             	sub    $0x4,%esp
  803e7e:	6a 00                	push   $0x0
  803e80:	ff 75 d8             	pushl  -0x28(%ebp)
  803e83:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e86:	e8 7a eb ff ff       	call   802a05 <set_block_data>
  803e8b:	83 c4 10             	add    $0x10,%esp
				return va;
  803e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e91:	e9 7b 02 00 00       	jmp    804111 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803e96:	83 ec 0c             	sub    $0xc,%esp
  803e99:	68 29 4e 80 00       	push   $0x804e29
  803e9e:	e8 7e cd ff ff       	call   800c21 <cprintf>
  803ea3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea9:	e9 63 02 00 00       	jmp    804111 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eb1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803eb4:	0f 86 4d 02 00 00    	jbe    804107 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803eba:	83 ec 0c             	sub    $0xc,%esp
  803ebd:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ec0:	e8 08 e8 ff ff       	call   8026cd <is_free_block>
  803ec5:	83 c4 10             	add    $0x10,%esp
  803ec8:	84 c0                	test   %al,%al
  803eca:	0f 84 37 02 00 00    	je     804107 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ed3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ed6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803ed9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803edc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803edf:	76 38                	jbe    803f19 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803ee1:	83 ec 0c             	sub    $0xc,%esp
  803ee4:	ff 75 08             	pushl  0x8(%ebp)
  803ee7:	e8 0c fa ff ff       	call   8038f8 <free_block>
  803eec:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803eef:	83 ec 0c             	sub    $0xc,%esp
  803ef2:	ff 75 0c             	pushl  0xc(%ebp)
  803ef5:	e8 3a eb ff ff       	call   802a34 <alloc_block_FF>
  803efa:	83 c4 10             	add    $0x10,%esp
  803efd:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f00:	83 ec 08             	sub    $0x8,%esp
  803f03:	ff 75 c0             	pushl  -0x40(%ebp)
  803f06:	ff 75 08             	pushl  0x8(%ebp)
  803f09:	e8 ab fa ff ff       	call   8039b9 <copy_data>
  803f0e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f11:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f14:	e9 f8 01 00 00       	jmp    804111 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f1c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f1f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f22:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f26:	0f 87 a0 00 00 00    	ja     803fcc <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f30:	75 17                	jne    803f49 <realloc_block_FF+0x551>
  803f32:	83 ec 04             	sub    $0x4,%esp
  803f35:	68 1b 4d 80 00       	push   $0x804d1b
  803f3a:	68 38 02 00 00       	push   $0x238
  803f3f:	68 39 4d 80 00       	push   $0x804d39
  803f44:	e8 04 02 00 00       	call   80414d <_panic>
  803f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4c:	8b 00                	mov    (%eax),%eax
  803f4e:	85 c0                	test   %eax,%eax
  803f50:	74 10                	je     803f62 <realloc_block_FF+0x56a>
  803f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f55:	8b 00                	mov    (%eax),%eax
  803f57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f5a:	8b 52 04             	mov    0x4(%edx),%edx
  803f5d:	89 50 04             	mov    %edx,0x4(%eax)
  803f60:	eb 0b                	jmp    803f6d <realloc_block_FF+0x575>
  803f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f65:	8b 40 04             	mov    0x4(%eax),%eax
  803f68:	a3 30 50 80 00       	mov    %eax,0x805030
  803f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f70:	8b 40 04             	mov    0x4(%eax),%eax
  803f73:	85 c0                	test   %eax,%eax
  803f75:	74 0f                	je     803f86 <realloc_block_FF+0x58e>
  803f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7a:	8b 40 04             	mov    0x4(%eax),%eax
  803f7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f80:	8b 12                	mov    (%edx),%edx
  803f82:	89 10                	mov    %edx,(%eax)
  803f84:	eb 0a                	jmp    803f90 <realloc_block_FF+0x598>
  803f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f89:	8b 00                	mov    (%eax),%eax
  803f8b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803f90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fa3:	a1 38 50 80 00       	mov    0x805038,%eax
  803fa8:	48                   	dec    %eax
  803fa9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803fae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fb4:	01 d0                	add    %edx,%eax
  803fb6:	83 ec 04             	sub    $0x4,%esp
  803fb9:	6a 01                	push   $0x1
  803fbb:	50                   	push   %eax
  803fbc:	ff 75 08             	pushl  0x8(%ebp)
  803fbf:	e8 41 ea ff ff       	call   802a05 <set_block_data>
  803fc4:	83 c4 10             	add    $0x10,%esp
  803fc7:	e9 36 01 00 00       	jmp    804102 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803fcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fcf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fd2:	01 d0                	add    %edx,%eax
  803fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803fd7:	83 ec 04             	sub    $0x4,%esp
  803fda:	6a 01                	push   $0x1
  803fdc:	ff 75 f0             	pushl  -0x10(%ebp)
  803fdf:	ff 75 08             	pushl  0x8(%ebp)
  803fe2:	e8 1e ea ff ff       	call   802a05 <set_block_data>
  803fe7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803fea:	8b 45 08             	mov    0x8(%ebp),%eax
  803fed:	83 e8 04             	sub    $0x4,%eax
  803ff0:	8b 00                	mov    (%eax),%eax
  803ff2:	83 e0 fe             	and    $0xfffffffe,%eax
  803ff5:	89 c2                	mov    %eax,%edx
  803ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffa:	01 d0                	add    %edx,%eax
  803ffc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803fff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804003:	74 06                	je     80400b <realloc_block_FF+0x613>
  804005:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804009:	75 17                	jne    804022 <realloc_block_FF+0x62a>
  80400b:	83 ec 04             	sub    $0x4,%esp
  80400e:	68 ac 4d 80 00       	push   $0x804dac
  804013:	68 44 02 00 00       	push   $0x244
  804018:	68 39 4d 80 00       	push   $0x804d39
  80401d:	e8 2b 01 00 00       	call   80414d <_panic>
  804022:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804025:	8b 10                	mov    (%eax),%edx
  804027:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80402a:	89 10                	mov    %edx,(%eax)
  80402c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80402f:	8b 00                	mov    (%eax),%eax
  804031:	85 c0                	test   %eax,%eax
  804033:	74 0b                	je     804040 <realloc_block_FF+0x648>
  804035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804038:	8b 00                	mov    (%eax),%eax
  80403a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80403d:	89 50 04             	mov    %edx,0x4(%eax)
  804040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804043:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804046:	89 10                	mov    %edx,(%eax)
  804048:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80404b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80404e:	89 50 04             	mov    %edx,0x4(%eax)
  804051:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804054:	8b 00                	mov    (%eax),%eax
  804056:	85 c0                	test   %eax,%eax
  804058:	75 08                	jne    804062 <realloc_block_FF+0x66a>
  80405a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80405d:	a3 30 50 80 00       	mov    %eax,0x805030
  804062:	a1 38 50 80 00       	mov    0x805038,%eax
  804067:	40                   	inc    %eax
  804068:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80406d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804071:	75 17                	jne    80408a <realloc_block_FF+0x692>
  804073:	83 ec 04             	sub    $0x4,%esp
  804076:	68 1b 4d 80 00       	push   $0x804d1b
  80407b:	68 45 02 00 00       	push   $0x245
  804080:	68 39 4d 80 00       	push   $0x804d39
  804085:	e8 c3 00 00 00       	call   80414d <_panic>
  80408a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408d:	8b 00                	mov    (%eax),%eax
  80408f:	85 c0                	test   %eax,%eax
  804091:	74 10                	je     8040a3 <realloc_block_FF+0x6ab>
  804093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804096:	8b 00                	mov    (%eax),%eax
  804098:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80409b:	8b 52 04             	mov    0x4(%edx),%edx
  80409e:	89 50 04             	mov    %edx,0x4(%eax)
  8040a1:	eb 0b                	jmp    8040ae <realloc_block_FF+0x6b6>
  8040a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a6:	8b 40 04             	mov    0x4(%eax),%eax
  8040a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8040ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b1:	8b 40 04             	mov    0x4(%eax),%eax
  8040b4:	85 c0                	test   %eax,%eax
  8040b6:	74 0f                	je     8040c7 <realloc_block_FF+0x6cf>
  8040b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040bb:	8b 40 04             	mov    0x4(%eax),%eax
  8040be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040c1:	8b 12                	mov    (%edx),%edx
  8040c3:	89 10                	mov    %edx,(%eax)
  8040c5:	eb 0a                	jmp    8040d1 <realloc_block_FF+0x6d9>
  8040c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ca:	8b 00                	mov    (%eax),%eax
  8040cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8040d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8040e9:	48                   	dec    %eax
  8040ea:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8040ef:	83 ec 04             	sub    $0x4,%esp
  8040f2:	6a 00                	push   $0x0
  8040f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8040f7:	ff 75 b8             	pushl  -0x48(%ebp)
  8040fa:	e8 06 e9 ff ff       	call   802a05 <set_block_data>
  8040ff:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804102:	8b 45 08             	mov    0x8(%ebp),%eax
  804105:	eb 0a                	jmp    804111 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804107:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80410e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804111:	c9                   	leave  
  804112:	c3                   	ret    

00804113 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804113:	55                   	push   %ebp
  804114:	89 e5                	mov    %esp,%ebp
  804116:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804119:	83 ec 04             	sub    $0x4,%esp
  80411c:	68 30 4e 80 00       	push   $0x804e30
  804121:	68 58 02 00 00       	push   $0x258
  804126:	68 39 4d 80 00       	push   $0x804d39
  80412b:	e8 1d 00 00 00       	call   80414d <_panic>

00804130 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804130:	55                   	push   %ebp
  804131:	89 e5                	mov    %esp,%ebp
  804133:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804136:	83 ec 04             	sub    $0x4,%esp
  804139:	68 58 4e 80 00       	push   $0x804e58
  80413e:	68 61 02 00 00       	push   $0x261
  804143:	68 39 4d 80 00       	push   $0x804d39
  804148:	e8 00 00 00 00       	call   80414d <_panic>

0080414d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80414d:	55                   	push   %ebp
  80414e:	89 e5                	mov    %esp,%ebp
  804150:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  804153:	8d 45 10             	lea    0x10(%ebp),%eax
  804156:	83 c0 04             	add    $0x4,%eax
  804159:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80415c:	a1 60 50 90 00       	mov    0x905060,%eax
  804161:	85 c0                	test   %eax,%eax
  804163:	74 16                	je     80417b <_panic+0x2e>
		cprintf("%s: ", argv0);
  804165:	a1 60 50 90 00       	mov    0x905060,%eax
  80416a:	83 ec 08             	sub    $0x8,%esp
  80416d:	50                   	push   %eax
  80416e:	68 80 4e 80 00       	push   $0x804e80
  804173:	e8 a9 ca ff ff       	call   800c21 <cprintf>
  804178:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80417b:	a1 00 50 80 00       	mov    0x805000,%eax
  804180:	ff 75 0c             	pushl  0xc(%ebp)
  804183:	ff 75 08             	pushl  0x8(%ebp)
  804186:	50                   	push   %eax
  804187:	68 85 4e 80 00       	push   $0x804e85
  80418c:	e8 90 ca ff ff       	call   800c21 <cprintf>
  804191:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  804194:	8b 45 10             	mov    0x10(%ebp),%eax
  804197:	83 ec 08             	sub    $0x8,%esp
  80419a:	ff 75 f4             	pushl  -0xc(%ebp)
  80419d:	50                   	push   %eax
  80419e:	e8 13 ca ff ff       	call   800bb6 <vcprintf>
  8041a3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8041a6:	83 ec 08             	sub    $0x8,%esp
  8041a9:	6a 00                	push   $0x0
  8041ab:	68 a1 4e 80 00       	push   $0x804ea1
  8041b0:	e8 01 ca ff ff       	call   800bb6 <vcprintf>
  8041b5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8041b8:	e8 82 c9 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  8041bd:	eb fe                	jmp    8041bd <_panic+0x70>

008041bf <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8041bf:	55                   	push   %ebp
  8041c0:	89 e5                	mov    %esp,%ebp
  8041c2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8041c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8041ca:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8041d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041d3:	39 c2                	cmp    %eax,%edx
  8041d5:	74 14                	je     8041eb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8041d7:	83 ec 04             	sub    $0x4,%esp
  8041da:	68 a4 4e 80 00       	push   $0x804ea4
  8041df:	6a 26                	push   $0x26
  8041e1:	68 f0 4e 80 00       	push   $0x804ef0
  8041e6:	e8 62 ff ff ff       	call   80414d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8041eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8041f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8041f9:	e9 c5 00 00 00       	jmp    8042c3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8041fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804201:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804208:	8b 45 08             	mov    0x8(%ebp),%eax
  80420b:	01 d0                	add    %edx,%eax
  80420d:	8b 00                	mov    (%eax),%eax
  80420f:	85 c0                	test   %eax,%eax
  804211:	75 08                	jne    80421b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804213:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804216:	e9 a5 00 00 00       	jmp    8042c0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80421b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804222:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804229:	eb 69                	jmp    804294 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80422b:	a1 20 50 80 00       	mov    0x805020,%eax
  804230:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804236:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804239:	89 d0                	mov    %edx,%eax
  80423b:	01 c0                	add    %eax,%eax
  80423d:	01 d0                	add    %edx,%eax
  80423f:	c1 e0 03             	shl    $0x3,%eax
  804242:	01 c8                	add    %ecx,%eax
  804244:	8a 40 04             	mov    0x4(%eax),%al
  804247:	84 c0                	test   %al,%al
  804249:	75 46                	jne    804291 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80424b:	a1 20 50 80 00       	mov    0x805020,%eax
  804250:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804256:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804259:	89 d0                	mov    %edx,%eax
  80425b:	01 c0                	add    %eax,%eax
  80425d:	01 d0                	add    %edx,%eax
  80425f:	c1 e0 03             	shl    $0x3,%eax
  804262:	01 c8                	add    %ecx,%eax
  804264:	8b 00                	mov    (%eax),%eax
  804266:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804269:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80426c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804271:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804276:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80427d:	8b 45 08             	mov    0x8(%ebp),%eax
  804280:	01 c8                	add    %ecx,%eax
  804282:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804284:	39 c2                	cmp    %eax,%edx
  804286:	75 09                	jne    804291 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804288:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80428f:	eb 15                	jmp    8042a6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804291:	ff 45 e8             	incl   -0x18(%ebp)
  804294:	a1 20 50 80 00       	mov    0x805020,%eax
  804299:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80429f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042a2:	39 c2                	cmp    %eax,%edx
  8042a4:	77 85                	ja     80422b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8042a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8042aa:	75 14                	jne    8042c0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8042ac:	83 ec 04             	sub    $0x4,%esp
  8042af:	68 fc 4e 80 00       	push   $0x804efc
  8042b4:	6a 3a                	push   $0x3a
  8042b6:	68 f0 4e 80 00       	push   $0x804ef0
  8042bb:	e8 8d fe ff ff       	call   80414d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8042c0:	ff 45 f0             	incl   -0x10(%ebp)
  8042c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8042c9:	0f 8c 2f ff ff ff    	jl     8041fe <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8042cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8042dd:	eb 26                	jmp    804305 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8042df:	a1 20 50 80 00       	mov    0x805020,%eax
  8042e4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8042ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8042ed:	89 d0                	mov    %edx,%eax
  8042ef:	01 c0                	add    %eax,%eax
  8042f1:	01 d0                	add    %edx,%eax
  8042f3:	c1 e0 03             	shl    $0x3,%eax
  8042f6:	01 c8                	add    %ecx,%eax
  8042f8:	8a 40 04             	mov    0x4(%eax),%al
  8042fb:	3c 01                	cmp    $0x1,%al
  8042fd:	75 03                	jne    804302 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8042ff:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804302:	ff 45 e0             	incl   -0x20(%ebp)
  804305:	a1 20 50 80 00       	mov    0x805020,%eax
  80430a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804313:	39 c2                	cmp    %eax,%edx
  804315:	77 c8                	ja     8042df <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80431a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80431d:	74 14                	je     804333 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80431f:	83 ec 04             	sub    $0x4,%esp
  804322:	68 50 4f 80 00       	push   $0x804f50
  804327:	6a 44                	push   $0x44
  804329:	68 f0 4e 80 00       	push   $0x804ef0
  80432e:	e8 1a fe ff ff       	call   80414d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804333:	90                   	nop
  804334:	c9                   	leave  
  804335:	c3                   	ret    
  804336:	66 90                	xchg   %ax,%ax

00804338 <__udivdi3>:
  804338:	55                   	push   %ebp
  804339:	57                   	push   %edi
  80433a:	56                   	push   %esi
  80433b:	53                   	push   %ebx
  80433c:	83 ec 1c             	sub    $0x1c,%esp
  80433f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804343:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80434b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80434f:	89 ca                	mov    %ecx,%edx
  804351:	89 f8                	mov    %edi,%eax
  804353:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804357:	85 f6                	test   %esi,%esi
  804359:	75 2d                	jne    804388 <__udivdi3+0x50>
  80435b:	39 cf                	cmp    %ecx,%edi
  80435d:	77 65                	ja     8043c4 <__udivdi3+0x8c>
  80435f:	89 fd                	mov    %edi,%ebp
  804361:	85 ff                	test   %edi,%edi
  804363:	75 0b                	jne    804370 <__udivdi3+0x38>
  804365:	b8 01 00 00 00       	mov    $0x1,%eax
  80436a:	31 d2                	xor    %edx,%edx
  80436c:	f7 f7                	div    %edi
  80436e:	89 c5                	mov    %eax,%ebp
  804370:	31 d2                	xor    %edx,%edx
  804372:	89 c8                	mov    %ecx,%eax
  804374:	f7 f5                	div    %ebp
  804376:	89 c1                	mov    %eax,%ecx
  804378:	89 d8                	mov    %ebx,%eax
  80437a:	f7 f5                	div    %ebp
  80437c:	89 cf                	mov    %ecx,%edi
  80437e:	89 fa                	mov    %edi,%edx
  804380:	83 c4 1c             	add    $0x1c,%esp
  804383:	5b                   	pop    %ebx
  804384:	5e                   	pop    %esi
  804385:	5f                   	pop    %edi
  804386:	5d                   	pop    %ebp
  804387:	c3                   	ret    
  804388:	39 ce                	cmp    %ecx,%esi
  80438a:	77 28                	ja     8043b4 <__udivdi3+0x7c>
  80438c:	0f bd fe             	bsr    %esi,%edi
  80438f:	83 f7 1f             	xor    $0x1f,%edi
  804392:	75 40                	jne    8043d4 <__udivdi3+0x9c>
  804394:	39 ce                	cmp    %ecx,%esi
  804396:	72 0a                	jb     8043a2 <__udivdi3+0x6a>
  804398:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80439c:	0f 87 9e 00 00 00    	ja     804440 <__udivdi3+0x108>
  8043a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043a7:	89 fa                	mov    %edi,%edx
  8043a9:	83 c4 1c             	add    $0x1c,%esp
  8043ac:	5b                   	pop    %ebx
  8043ad:	5e                   	pop    %esi
  8043ae:	5f                   	pop    %edi
  8043af:	5d                   	pop    %ebp
  8043b0:	c3                   	ret    
  8043b1:	8d 76 00             	lea    0x0(%esi),%esi
  8043b4:	31 ff                	xor    %edi,%edi
  8043b6:	31 c0                	xor    %eax,%eax
  8043b8:	89 fa                	mov    %edi,%edx
  8043ba:	83 c4 1c             	add    $0x1c,%esp
  8043bd:	5b                   	pop    %ebx
  8043be:	5e                   	pop    %esi
  8043bf:	5f                   	pop    %edi
  8043c0:	5d                   	pop    %ebp
  8043c1:	c3                   	ret    
  8043c2:	66 90                	xchg   %ax,%ax
  8043c4:	89 d8                	mov    %ebx,%eax
  8043c6:	f7 f7                	div    %edi
  8043c8:	31 ff                	xor    %edi,%edi
  8043ca:	89 fa                	mov    %edi,%edx
  8043cc:	83 c4 1c             	add    $0x1c,%esp
  8043cf:	5b                   	pop    %ebx
  8043d0:	5e                   	pop    %esi
  8043d1:	5f                   	pop    %edi
  8043d2:	5d                   	pop    %ebp
  8043d3:	c3                   	ret    
  8043d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043d9:	89 eb                	mov    %ebp,%ebx
  8043db:	29 fb                	sub    %edi,%ebx
  8043dd:	89 f9                	mov    %edi,%ecx
  8043df:	d3 e6                	shl    %cl,%esi
  8043e1:	89 c5                	mov    %eax,%ebp
  8043e3:	88 d9                	mov    %bl,%cl
  8043e5:	d3 ed                	shr    %cl,%ebp
  8043e7:	89 e9                	mov    %ebp,%ecx
  8043e9:	09 f1                	or     %esi,%ecx
  8043eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8043ef:	89 f9                	mov    %edi,%ecx
  8043f1:	d3 e0                	shl    %cl,%eax
  8043f3:	89 c5                	mov    %eax,%ebp
  8043f5:	89 d6                	mov    %edx,%esi
  8043f7:	88 d9                	mov    %bl,%cl
  8043f9:	d3 ee                	shr    %cl,%esi
  8043fb:	89 f9                	mov    %edi,%ecx
  8043fd:	d3 e2                	shl    %cl,%edx
  8043ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  804403:	88 d9                	mov    %bl,%cl
  804405:	d3 e8                	shr    %cl,%eax
  804407:	09 c2                	or     %eax,%edx
  804409:	89 d0                	mov    %edx,%eax
  80440b:	89 f2                	mov    %esi,%edx
  80440d:	f7 74 24 0c          	divl   0xc(%esp)
  804411:	89 d6                	mov    %edx,%esi
  804413:	89 c3                	mov    %eax,%ebx
  804415:	f7 e5                	mul    %ebp
  804417:	39 d6                	cmp    %edx,%esi
  804419:	72 19                	jb     804434 <__udivdi3+0xfc>
  80441b:	74 0b                	je     804428 <__udivdi3+0xf0>
  80441d:	89 d8                	mov    %ebx,%eax
  80441f:	31 ff                	xor    %edi,%edi
  804421:	e9 58 ff ff ff       	jmp    80437e <__udivdi3+0x46>
  804426:	66 90                	xchg   %ax,%ax
  804428:	8b 54 24 08          	mov    0x8(%esp),%edx
  80442c:	89 f9                	mov    %edi,%ecx
  80442e:	d3 e2                	shl    %cl,%edx
  804430:	39 c2                	cmp    %eax,%edx
  804432:	73 e9                	jae    80441d <__udivdi3+0xe5>
  804434:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804437:	31 ff                	xor    %edi,%edi
  804439:	e9 40 ff ff ff       	jmp    80437e <__udivdi3+0x46>
  80443e:	66 90                	xchg   %ax,%ax
  804440:	31 c0                	xor    %eax,%eax
  804442:	e9 37 ff ff ff       	jmp    80437e <__udivdi3+0x46>
  804447:	90                   	nop

00804448 <__umoddi3>:
  804448:	55                   	push   %ebp
  804449:	57                   	push   %edi
  80444a:	56                   	push   %esi
  80444b:	53                   	push   %ebx
  80444c:	83 ec 1c             	sub    $0x1c,%esp
  80444f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804453:	8b 74 24 34          	mov    0x34(%esp),%esi
  804457:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80445b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80445f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804463:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804467:	89 f3                	mov    %esi,%ebx
  804469:	89 fa                	mov    %edi,%edx
  80446b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80446f:	89 34 24             	mov    %esi,(%esp)
  804472:	85 c0                	test   %eax,%eax
  804474:	75 1a                	jne    804490 <__umoddi3+0x48>
  804476:	39 f7                	cmp    %esi,%edi
  804478:	0f 86 a2 00 00 00    	jbe    804520 <__umoddi3+0xd8>
  80447e:	89 c8                	mov    %ecx,%eax
  804480:	89 f2                	mov    %esi,%edx
  804482:	f7 f7                	div    %edi
  804484:	89 d0                	mov    %edx,%eax
  804486:	31 d2                	xor    %edx,%edx
  804488:	83 c4 1c             	add    $0x1c,%esp
  80448b:	5b                   	pop    %ebx
  80448c:	5e                   	pop    %esi
  80448d:	5f                   	pop    %edi
  80448e:	5d                   	pop    %ebp
  80448f:	c3                   	ret    
  804490:	39 f0                	cmp    %esi,%eax
  804492:	0f 87 ac 00 00 00    	ja     804544 <__umoddi3+0xfc>
  804498:	0f bd e8             	bsr    %eax,%ebp
  80449b:	83 f5 1f             	xor    $0x1f,%ebp
  80449e:	0f 84 ac 00 00 00    	je     804550 <__umoddi3+0x108>
  8044a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8044a9:	29 ef                	sub    %ebp,%edi
  8044ab:	89 fe                	mov    %edi,%esi
  8044ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044b1:	89 e9                	mov    %ebp,%ecx
  8044b3:	d3 e0                	shl    %cl,%eax
  8044b5:	89 d7                	mov    %edx,%edi
  8044b7:	89 f1                	mov    %esi,%ecx
  8044b9:	d3 ef                	shr    %cl,%edi
  8044bb:	09 c7                	or     %eax,%edi
  8044bd:	89 e9                	mov    %ebp,%ecx
  8044bf:	d3 e2                	shl    %cl,%edx
  8044c1:	89 14 24             	mov    %edx,(%esp)
  8044c4:	89 d8                	mov    %ebx,%eax
  8044c6:	d3 e0                	shl    %cl,%eax
  8044c8:	89 c2                	mov    %eax,%edx
  8044ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044ce:	d3 e0                	shl    %cl,%eax
  8044d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044d8:	89 f1                	mov    %esi,%ecx
  8044da:	d3 e8                	shr    %cl,%eax
  8044dc:	09 d0                	or     %edx,%eax
  8044de:	d3 eb                	shr    %cl,%ebx
  8044e0:	89 da                	mov    %ebx,%edx
  8044e2:	f7 f7                	div    %edi
  8044e4:	89 d3                	mov    %edx,%ebx
  8044e6:	f7 24 24             	mull   (%esp)
  8044e9:	89 c6                	mov    %eax,%esi
  8044eb:	89 d1                	mov    %edx,%ecx
  8044ed:	39 d3                	cmp    %edx,%ebx
  8044ef:	0f 82 87 00 00 00    	jb     80457c <__umoddi3+0x134>
  8044f5:	0f 84 91 00 00 00    	je     80458c <__umoddi3+0x144>
  8044fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8044ff:	29 f2                	sub    %esi,%edx
  804501:	19 cb                	sbb    %ecx,%ebx
  804503:	89 d8                	mov    %ebx,%eax
  804505:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804509:	d3 e0                	shl    %cl,%eax
  80450b:	89 e9                	mov    %ebp,%ecx
  80450d:	d3 ea                	shr    %cl,%edx
  80450f:	09 d0                	or     %edx,%eax
  804511:	89 e9                	mov    %ebp,%ecx
  804513:	d3 eb                	shr    %cl,%ebx
  804515:	89 da                	mov    %ebx,%edx
  804517:	83 c4 1c             	add    $0x1c,%esp
  80451a:	5b                   	pop    %ebx
  80451b:	5e                   	pop    %esi
  80451c:	5f                   	pop    %edi
  80451d:	5d                   	pop    %ebp
  80451e:	c3                   	ret    
  80451f:	90                   	nop
  804520:	89 fd                	mov    %edi,%ebp
  804522:	85 ff                	test   %edi,%edi
  804524:	75 0b                	jne    804531 <__umoddi3+0xe9>
  804526:	b8 01 00 00 00       	mov    $0x1,%eax
  80452b:	31 d2                	xor    %edx,%edx
  80452d:	f7 f7                	div    %edi
  80452f:	89 c5                	mov    %eax,%ebp
  804531:	89 f0                	mov    %esi,%eax
  804533:	31 d2                	xor    %edx,%edx
  804535:	f7 f5                	div    %ebp
  804537:	89 c8                	mov    %ecx,%eax
  804539:	f7 f5                	div    %ebp
  80453b:	89 d0                	mov    %edx,%eax
  80453d:	e9 44 ff ff ff       	jmp    804486 <__umoddi3+0x3e>
  804542:	66 90                	xchg   %ax,%ax
  804544:	89 c8                	mov    %ecx,%eax
  804546:	89 f2                	mov    %esi,%edx
  804548:	83 c4 1c             	add    $0x1c,%esp
  80454b:	5b                   	pop    %ebx
  80454c:	5e                   	pop    %esi
  80454d:	5f                   	pop    %edi
  80454e:	5d                   	pop    %ebp
  80454f:	c3                   	ret    
  804550:	3b 04 24             	cmp    (%esp),%eax
  804553:	72 06                	jb     80455b <__umoddi3+0x113>
  804555:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804559:	77 0f                	ja     80456a <__umoddi3+0x122>
  80455b:	89 f2                	mov    %esi,%edx
  80455d:	29 f9                	sub    %edi,%ecx
  80455f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804563:	89 14 24             	mov    %edx,(%esp)
  804566:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80456a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80456e:	8b 14 24             	mov    (%esp),%edx
  804571:	83 c4 1c             	add    $0x1c,%esp
  804574:	5b                   	pop    %ebx
  804575:	5e                   	pop    %esi
  804576:	5f                   	pop    %edi
  804577:	5d                   	pop    %ebp
  804578:	c3                   	ret    
  804579:	8d 76 00             	lea    0x0(%esi),%esi
  80457c:	2b 04 24             	sub    (%esp),%eax
  80457f:	19 fa                	sbb    %edi,%edx
  804581:	89 d1                	mov    %edx,%ecx
  804583:	89 c6                	mov    %eax,%esi
  804585:	e9 71 ff ff ff       	jmp    8044fb <__umoddi3+0xb3>
  80458a:	66 90                	xchg   %ax,%ax
  80458c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804590:	72 ea                	jb     80457c <__umoddi3+0x134>
  804592:	89 d9                	mov    %ebx,%ecx
  804594:	e9 62 ff ff ff       	jmp    8044fb <__umoddi3+0xb3>
