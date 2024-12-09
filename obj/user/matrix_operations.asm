
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
  800066:	68 80 46 80 00       	push   $0x804680
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 84 46 80 00       	push   $0x804684
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 a8 46 80 00       	push   $0x8046a8
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 84 46 80 00       	push   $0x804684
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 80 46 80 00       	push   $0x804680
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 cc 46 80 00       	push   $0x8046cc
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
  8000e6:	68 ec 46 80 00       	push   $0x8046ec
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 0e 47 80 00       	push   $0x80470e
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 1c 47 80 00       	push   $0x80471c
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 2a 47 80 00       	push   $0x80472a
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 3a 47 80 00       	push   $0x80473a
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
  80017a:	68 44 47 80 00       	push   $0x804744
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
  8002da:	68 68 47 80 00       	push   $0x804768
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 86 47 80 00       	push   $0x804786
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 9d 47 80 00       	push   $0x80479d
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 b4 47 80 00       	push   $0x8047b4
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 3a 47 80 00       	push   $0x80473a
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
  8003e7:	68 cb 47 80 00       	push   $0x8047cb
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
  800496:	68 e4 47 80 00       	push   $0x8047e4
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
  80092b:	68 02 48 80 00       	push   $0x804802
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
  800946:	68 09 48 80 00       	push   $0x804809
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
  80099c:	68 0d 48 80 00       	push   $0x80480d
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
  8009b7:	68 09 48 80 00       	push   $0x804809
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
  800a82:	e8 dc 16 00 00       	call   802163 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 30 48 80 00       	push   $0x804830
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
  800ab2:	68 58 48 80 00       	push   $0x804858
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
  800ae3:	68 80 48 80 00       	push   $0x804880
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 60 80 00       	mov    0x806020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 d8 48 80 00       	push   $0x8048d8
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 30 48 80 00       	push   $0x804830
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
  800b78:	a0 28 60 80 00       	mov    0x806028,%al
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
  800bed:	a0 28 60 80 00       	mov    0x806028,%al
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
  800c12:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
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
  800c27:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
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
  800cbe:	e8 49 37 00 00       	call   80440c <__udivdi3>
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
  800d0e:	e8 09 38 00 00       	call   80451c <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 14 4b 80 00       	add    $0x804b14,%eax
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
  800e69:	8b 04 85 38 4b 80 00 	mov    0x804b38(,%eax,4),%eax
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
  800f4a:	8b 34 9d 80 49 80 00 	mov    0x804980(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 25 4b 80 00       	push   $0x804b25
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
  800f6f:	68 2e 4b 80 00       	push   $0x804b2e
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
  800f9c:	be 31 4b 80 00       	mov    $0x804b31,%esi
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
  801194:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  80119b:	eb 2c                	jmp    8011c9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80119d:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
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
  8012c7:	68 a8 4c 80 00       	push   $0x804ca8
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
  801309:	68 ab 4c 80 00       	push   $0x804cab
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
  8013cb:	68 a8 4c 80 00       	push   $0x804ca8
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
  80140d:	68 ab 4c 80 00       	push   $0x804cab
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
  801baf:	68 bc 4c 80 00       	push   $0x804cbc
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 de 4c 80 00       	push   $0x804cde
  801bbe:	e8 5e 26 00 00       	call   804221 <_panic>

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
  801c4a:	e8 01 09 00 00       	call   802550 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 dd 0e 00 00       	call   802b3b <alloc_block_FF>
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
  801c7c:	e8 76 13 00 00       	call   802ff7 <alloc_block_BF>
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
  801c99:	a1 20 60 80 00       	mov    0x806020,%eax
  801c9e:	8b 40 78             	mov    0x78(%eax),%eax
  801ca1:	05 00 10 00 00       	add    $0x1000,%eax
  801ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801ca9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801cb0:	e9 de 00 00 00       	jmp    801d93 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801cb5:	a1 20 60 80 00       	mov    0x806020,%eax
  801cba:	8b 40 78             	mov    0x78(%eax),%eax
  801cbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cc0:	29 c2                	sub    %eax,%edx
  801cc2:	89 d0                	mov    %edx,%eax
  801cc4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc9:	c1 e8 0c             	shr    $0xc,%eax
  801ccc:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  801d02:	a1 20 60 80 00       	mov    0x806020,%eax
  801d07:	8b 40 78             	mov    0x78(%eax),%eax
  801d0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d0d:	29 c2                	sub    %eax,%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d16:	c1 e8 0c             	shr    $0xc,%eax
  801d19:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  801d5c:	a1 20 60 80 00       	mov    0x806020,%eax
  801d61:	8b 40 78             	mov    0x78(%eax),%eax
  801d64:	29 c2                	sub    %eax,%edx
  801d66:	89 d0                	mov    %edx,%eax
  801d68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6d:	c1 e8 0c             	shr    $0xc,%eax
  801d70:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
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
  801db6:	a1 20 60 80 00       	mov    0x806020,%eax
  801dbb:	8b 40 78             	mov    0x78(%eax),%eax
  801dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc1:	29 c2                	sub    %eax,%edx
  801dc3:	89 d0                	mov    %edx,%eax
  801dc5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dca:	c1 e8 0c             	shr    $0xc,%eax
  801dcd:	89 c2                	mov    %eax,%edx
  801dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dd2:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
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
  801e2a:	e8 8c 09 00 00       	call   8027bb <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 9c 1b 00 00       	call   8039dc <free_block>
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
  801e75:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
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
  801eb2:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
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
  801ee0:	68 ec 4c 80 00       	push   $0x804cec
  801ee5:	68 87 00 00 00       	push   $0x87
  801eea:	68 16 4d 80 00       	push   $0x804d16
  801eef:	e8 2d 23 00 00       	call   804221 <_panic>
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
  801f77:	a1 20 60 80 00       	mov    0x806020,%eax
  801f7c:	8b 40 78             	mov    0x78(%eax),%eax
  801f7f:	29 c2                	sub    %eax,%edx
  801f81:	89 d0                	mov    %edx,%eax
  801f83:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f88:	c1 e8 0c             	shr    $0xc,%eax
  801f8b:	89 c2                	mov    %eax,%edx
  801f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f90:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
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
  802012:	a1 20 60 80 00       	mov    0x806020,%eax
  802017:	8b 40 78             	mov    0x78(%eax),%eax
  80201a:	29 c2                	sub    %eax,%edx
  80201c:	89 d0                	mov    %edx,%eax
  80201e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802023:	c1 e8 0c             	shr    $0xc,%eax
  802026:	89 c2                	mov    %eax,%edx
  802028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80202b:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
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
  80204d:	a1 20 60 80 00       	mov    0x806020,%eax
  802052:	8b 40 78             	mov    0x78(%eax),%eax
  802055:	29 c2                	sub    %eax,%edx
  802057:	89 d0                	mov    %edx,%eax
  802059:	2d 00 10 00 00       	sub    $0x1000,%eax
  80205e:	c1 e8 0c             	shr    $0xc,%eax
  802061:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  80208b:	68 24 4d 80 00       	push   $0x804d24
  802090:	68 e4 00 00 00       	push   $0xe4
  802095:	68 16 4d 80 00       	push   $0x804d16
  80209a:	e8 82 21 00 00       	call   804221 <_panic>

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
  8020a8:	68 4a 4d 80 00       	push   $0x804d4a
  8020ad:	68 f0 00 00 00       	push   $0xf0
  8020b2:	68 16 4d 80 00       	push   $0x804d16
  8020b7:	e8 65 21 00 00       	call   804221 <_panic>

008020bc <shrink>:

}
void shrink(uint32 newSize)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	68 4a 4d 80 00       	push   $0x804d4a
  8020ca:	68 f5 00 00 00       	push   $0xf5
  8020cf:	68 16 4d 80 00       	push   $0x804d16
  8020d4:	e8 48 21 00 00       	call   804221 <_panic>

008020d9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	68 4a 4d 80 00       	push   $0x804d4a
  8020e7:	68 fa 00 00 00       	push   $0xfa
  8020ec:	68 16 4d 80 00       	push   $0x804d16
  8020f1:	e8 2b 21 00 00       	call   804221 <_panic>

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

0080271f <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 2e                	push   $0x2e
  802731:	e8 c0 f9 ff ff       	call   8020f6 <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
  802739:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80273c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	50                   	push   %eax
  802750:	6a 2f                	push   $0x2f
  802752:	e8 9f f9 ff ff       	call   8020f6 <syscall>
  802757:	83 c4 18             	add    $0x18,%esp
	return;
  80275a:	90                   	nop
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802760:	8b 55 0c             	mov    0xc(%ebp),%edx
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	52                   	push   %edx
  80276d:	50                   	push   %eax
  80276e:	6a 30                	push   $0x30
  802770:	e8 81 f9 ff ff       	call   8020f6 <syscall>
  802775:	83 c4 18             	add    $0x18,%esp
	return;
  802778:	90                   	nop
}
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
  80277e:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	50                   	push   %eax
  80278d:	6a 31                	push   $0x31
  80278f:	e8 62 f9 ff ff       	call   8020f6 <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
  802797:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80279a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	50                   	push   %eax
  8027ae:	6a 32                	push   $0x32
  8027b0:	e8 41 f9 ff ff       	call   8020f6 <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
	return;
  8027b8:	90                   	nop
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	83 e8 04             	sub    $0x4,%eax
  8027c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8027ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	83 e8 04             	sub    $0x4,%eax
  8027e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8027e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	83 e0 01             	and    $0x1,%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	0f 94 c0             	sete   %al
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
  8027f5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8027f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8027ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802802:	83 f8 02             	cmp    $0x2,%eax
  802805:	74 2b                	je     802832 <alloc_block+0x40>
  802807:	83 f8 02             	cmp    $0x2,%eax
  80280a:	7f 07                	jg     802813 <alloc_block+0x21>
  80280c:	83 f8 01             	cmp    $0x1,%eax
  80280f:	74 0e                	je     80281f <alloc_block+0x2d>
  802811:	eb 58                	jmp    80286b <alloc_block+0x79>
  802813:	83 f8 03             	cmp    $0x3,%eax
  802816:	74 2d                	je     802845 <alloc_block+0x53>
  802818:	83 f8 04             	cmp    $0x4,%eax
  80281b:	74 3b                	je     802858 <alloc_block+0x66>
  80281d:	eb 4c                	jmp    80286b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	ff 75 08             	pushl  0x8(%ebp)
  802825:	e8 11 03 00 00       	call   802b3b <alloc_block_FF>
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802830:	eb 4a                	jmp    80287c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802832:	83 ec 0c             	sub    $0xc,%esp
  802835:	ff 75 08             	pushl  0x8(%ebp)
  802838:	e8 c7 19 00 00       	call   804204 <alloc_block_NF>
  80283d:	83 c4 10             	add    $0x10,%esp
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802843:	eb 37                	jmp    80287c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802845:	83 ec 0c             	sub    $0xc,%esp
  802848:	ff 75 08             	pushl  0x8(%ebp)
  80284b:	e8 a7 07 00 00       	call   802ff7 <alloc_block_BF>
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802856:	eb 24                	jmp    80287c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802858:	83 ec 0c             	sub    $0xc,%esp
  80285b:	ff 75 08             	pushl  0x8(%ebp)
  80285e:	e8 84 19 00 00       	call   8041e7 <alloc_block_WF>
  802863:	83 c4 10             	add    $0x10,%esp
  802866:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802869:	eb 11                	jmp    80287c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80286b:	83 ec 0c             	sub    $0xc,%esp
  80286e:	68 5c 4d 80 00       	push   $0x804d5c
  802873:	e8 a9 e3 ff ff       	call   800c21 <cprintf>
  802878:	83 c4 10             	add    $0x10,%esp
		break;
  80287b:	90                   	nop
	}
	return va;
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80287f:	c9                   	leave  
  802880:	c3                   	ret    

00802881 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
  802884:	53                   	push   %ebx
  802885:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802888:	83 ec 0c             	sub    $0xc,%esp
  80288b:	68 7c 4d 80 00       	push   $0x804d7c
  802890:	e8 8c e3 ff ff       	call   800c21 <cprintf>
  802895:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802898:	83 ec 0c             	sub    $0xc,%esp
  80289b:	68 a7 4d 80 00       	push   $0x804da7
  8028a0:	e8 7c e3 ff ff       	call   800c21 <cprintf>
  8028a5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ae:	eb 37                	jmp    8028e7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8028b0:	83 ec 0c             	sub    $0xc,%esp
  8028b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8028b6:	e8 19 ff ff ff       	call   8027d4 <is_free_block>
  8028bb:	83 c4 10             	add    $0x10,%esp
  8028be:	0f be d8             	movsbl %al,%ebx
  8028c1:	83 ec 0c             	sub    $0xc,%esp
  8028c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8028c7:	e8 ef fe ff ff       	call   8027bb <get_block_size>
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	53                   	push   %ebx
  8028d3:	50                   	push   %eax
  8028d4:	68 bf 4d 80 00       	push   $0x804dbf
  8028d9:	e8 43 e3 ff ff       	call   800c21 <cprintf>
  8028de:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8028e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028eb:	74 07                	je     8028f4 <print_blocks_list+0x73>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	eb 05                	jmp    8028f9 <print_blocks_list+0x78>
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f9:	89 45 10             	mov    %eax,0x10(%ebp)
  8028fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	75 ad                	jne    8028b0 <print_blocks_list+0x2f>
  802903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802907:	75 a7                	jne    8028b0 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802909:	83 ec 0c             	sub    $0xc,%esp
  80290c:	68 7c 4d 80 00       	push   $0x804d7c
  802911:	e8 0b e3 ff ff       	call   800c21 <cprintf>
  802916:	83 c4 10             	add    $0x10,%esp

}
  802919:	90                   	nop
  80291a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
  802922:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802925:	8b 45 0c             	mov    0xc(%ebp),%eax
  802928:	83 e0 01             	and    $0x1,%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 03                	je     802932 <initialize_dynamic_allocator+0x13>
  80292f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802932:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802936:	0f 84 c7 01 00 00    	je     802b03 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80293c:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802943:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802946:	8b 55 08             	mov    0x8(%ebp),%edx
  802949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294c:	01 d0                	add    %edx,%eax
  80294e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802953:	0f 87 ad 01 00 00    	ja     802b06 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	0f 89 a5 01 00 00    	jns    802b09 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802964:	8b 55 08             	mov    0x8(%ebp),%edx
  802967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296a:	01 d0                	add    %edx,%eax
  80296c:	83 e8 04             	sub    $0x4,%eax
  80296f:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80297b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802983:	e9 87 00 00 00       	jmp    802a0f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298c:	75 14                	jne    8029a2 <initialize_dynamic_allocator+0x83>
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	68 d7 4d 80 00       	push   $0x804dd7
  802996:	6a 79                	push   $0x79
  802998:	68 f5 4d 80 00       	push   $0x804df5
  80299d:	e8 7f 18 00 00       	call   804221 <_panic>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 10                	je     8029bb <initialize_dynamic_allocator+0x9c>
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b3:	8b 52 04             	mov    0x4(%edx),%edx
  8029b6:	89 50 04             	mov    %edx,0x4(%eax)
  8029b9:	eb 0b                	jmp    8029c6 <initialize_dynamic_allocator+0xa7>
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 04             	mov    0x4(%eax),%eax
  8029c1:	a3 30 60 80 00       	mov    %eax,0x806030
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	74 0f                	je     8029df <initialize_dynamic_allocator+0xc0>
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 04             	mov    0x4(%eax),%eax
  8029d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d9:	8b 12                	mov    (%edx),%edx
  8029db:	89 10                	mov    %edx,(%eax)
  8029dd:	eb 0a                	jmp    8029e9 <initialize_dynamic_allocator+0xca>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fc:	a1 38 60 80 00       	mov    0x806038,%eax
  802a01:	48                   	dec    %eax
  802a02:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a07:	a1 34 60 80 00       	mov    0x806034,%eax
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a13:	74 07                	je     802a1c <initialize_dynamic_allocator+0xfd>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	eb 05                	jmp    802a21 <initialize_dynamic_allocator+0x102>
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a21:	a3 34 60 80 00       	mov    %eax,0x806034
  802a26:	a1 34 60 80 00       	mov    0x806034,%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	0f 85 55 ff ff ff    	jne    802988 <initialize_dynamic_allocator+0x69>
  802a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a37:	0f 85 4b ff ff ff    	jne    802988 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a4c:	a1 44 60 80 00       	mov    0x806044,%eax
  802a51:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802a56:	a1 40 60 80 00       	mov    0x806040,%eax
  802a5b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	83 c0 08             	add    $0x8,%eax
  802a67:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	83 c0 04             	add    $0x4,%eax
  802a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a73:	83 ea 08             	sub    $0x8,%edx
  802a76:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	01 d0                	add    %edx,%eax
  802a80:	83 e8 08             	sub    $0x8,%eax
  802a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a86:	83 ea 08             	sub    $0x8,%edx
  802a89:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa2:	75 17                	jne    802abb <initialize_dynamic_allocator+0x19c>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 10 4e 80 00       	push   $0x804e10
  802aac:	68 90 00 00 00       	push   $0x90
  802ab1:	68 f5 4d 80 00       	push   $0x804df5
  802ab6:	e8 66 17 00 00       	call   804221 <_panic>
  802abb:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	89 10                	mov    %edx,(%eax)
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 0d                	je     802adc <initialize_dynamic_allocator+0x1bd>
  802acf:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ad4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad7:	89 50 04             	mov    %edx,0x4(%eax)
  802ada:	eb 08                	jmp    802ae4 <initialize_dynamic_allocator+0x1c5>
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	a3 30 60 80 00       	mov    %eax,0x806030
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af6:	a1 38 60 80 00       	mov    0x806038,%eax
  802afb:	40                   	inc    %eax
  802afc:	a3 38 60 80 00       	mov    %eax,0x806038
  802b01:	eb 07                	jmp    802b0a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b03:	90                   	nop
  802b04:	eb 04                	jmp    802b0a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b06:	90                   	nop
  802b07:	eb 01                	jmp    802b0a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b09:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  802b12:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b1e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	83 e8 04             	sub    $0x4,%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	83 e0 fe             	and    $0xfffffffe,%eax
  802b2b:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	01 c2                	add    %eax,%edx
  802b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b36:	89 02                	mov    %eax,(%edx)
}
  802b38:	90                   	nop
  802b39:	5d                   	pop    %ebp
  802b3a:	c3                   	ret    

00802b3b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	83 e0 01             	and    $0x1,%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 03                	je     802b4e <alloc_block_FF+0x13>
  802b4b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b4e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b52:	77 07                	ja     802b5b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b54:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b5b:	a1 24 60 80 00       	mov    0x806024,%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	75 73                	jne    802bd7 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	83 c0 10             	add    $0x10,%eax
  802b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b6d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802b74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	01 d0                	add    %edx,%eax
  802b7c:	48                   	dec    %eax
  802b7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b83:	ba 00 00 00 00       	mov    $0x0,%edx
  802b88:	f7 75 ec             	divl   -0x14(%ebp)
  802b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8e:	29 d0                	sub    %edx,%eax
  802b90:	c1 e8 0c             	shr    $0xc,%eax
  802b93:	83 ec 0c             	sub    $0xc,%esp
  802b96:	50                   	push   %eax
  802b97:	e8 27 f0 ff ff       	call   801bc3 <sbrk>
  802b9c:	83 c4 10             	add    $0x10,%esp
  802b9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ba2:	83 ec 0c             	sub    $0xc,%esp
  802ba5:	6a 00                	push   $0x0
  802ba7:	e8 17 f0 ff ff       	call   801bc3 <sbrk>
  802bac:	83 c4 10             	add    $0x10,%esp
  802baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bb8:	83 ec 08             	sub    $0x8,%esp
  802bbb:	50                   	push   %eax
  802bbc:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bbf:	e8 5b fd ff ff       	call   80291f <initialize_dynamic_allocator>
  802bc4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802bc7:	83 ec 0c             	sub    $0xc,%esp
  802bca:	68 33 4e 80 00       	push   $0x804e33
  802bcf:	e8 4d e0 ff ff       	call   800c21 <cprintf>
  802bd4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdb:	75 0a                	jne    802be7 <alloc_block_FF+0xac>
	        return NULL;
  802bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802be2:	e9 0e 04 00 00       	jmp    802ff5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bee:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf6:	e9 f3 02 00 00       	jmp    802eee <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c01:	83 ec 0c             	sub    $0xc,%esp
  802c04:	ff 75 bc             	pushl  -0x44(%ebp)
  802c07:	e8 af fb ff ff       	call   8027bb <get_block_size>
  802c0c:	83 c4 10             	add    $0x10,%esp
  802c0f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	83 c0 08             	add    $0x8,%eax
  802c18:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c1b:	0f 87 c5 02 00 00    	ja     802ee6 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	83 c0 18             	add    $0x18,%eax
  802c27:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c2a:	0f 87 19 02 00 00    	ja     802e49 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802c30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c33:	2b 45 08             	sub    0x8(%ebp),%eax
  802c36:	83 e8 08             	sub    $0x8,%eax
  802c39:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8d 50 08             	lea    0x8(%eax),%edx
  802c42:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c45:	01 d0                	add    %edx,%eax
  802c47:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	83 c0 08             	add    $0x8,%eax
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	6a 01                	push   $0x1
  802c55:	50                   	push   %eax
  802c56:	ff 75 bc             	pushl  -0x44(%ebp)
  802c59:	e8 ae fe ff ff       	call   802b0c <set_block_data>
  802c5e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 40 04             	mov    0x4(%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	75 68                	jne    802cd3 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c6b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c6f:	75 17                	jne    802c88 <alloc_block_FF+0x14d>
  802c71:	83 ec 04             	sub    $0x4,%esp
  802c74:	68 10 4e 80 00       	push   $0x804e10
  802c79:	68 d7 00 00 00       	push   $0xd7
  802c7e:	68 f5 4d 80 00       	push   $0x804df5
  802c83:	e8 99 15 00 00       	call   804221 <_panic>
  802c88:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802c8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c91:	89 10                	mov    %edx,(%eax)
  802c93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	74 0d                	je     802ca9 <alloc_block_FF+0x16e>
  802c9c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ca1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ca4:	89 50 04             	mov    %edx,0x4(%eax)
  802ca7:	eb 08                	jmp    802cb1 <alloc_block_FF+0x176>
  802ca9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cac:	a3 30 60 80 00       	mov    %eax,0x806030
  802cb1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802cb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc3:	a1 38 60 80 00       	mov    0x806038,%eax
  802cc8:	40                   	inc    %eax
  802cc9:	a3 38 60 80 00       	mov    %eax,0x806038
  802cce:	e9 dc 00 00 00       	jmp    802daf <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	75 65                	jne    802d41 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cdc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ce0:	75 17                	jne    802cf9 <alloc_block_FF+0x1be>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 44 4e 80 00       	push   $0x804e44
  802cea:	68 db 00 00 00       	push   $0xdb
  802cef:	68 f5 4d 80 00       	push   $0x804df5
  802cf4:	e8 28 15 00 00       	call   804221 <_panic>
  802cf9:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802cff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 0c                	je     802d1b <alloc_block_FF+0x1e0>
  802d0f:	a1 30 60 80 00       	mov    0x806030,%eax
  802d14:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d17:	89 10                	mov    %edx,(%eax)
  802d19:	eb 08                	jmp    802d23 <alloc_block_FF+0x1e8>
  802d1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d1e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d26:	a3 30 60 80 00       	mov    %eax,0x806030
  802d2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d34:	a1 38 60 80 00       	mov    0x806038,%eax
  802d39:	40                   	inc    %eax
  802d3a:	a3 38 60 80 00       	mov    %eax,0x806038
  802d3f:	eb 6e                	jmp    802daf <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d45:	74 06                	je     802d4d <alloc_block_FF+0x212>
  802d47:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d4b:	75 17                	jne    802d64 <alloc_block_FF+0x229>
  802d4d:	83 ec 04             	sub    $0x4,%esp
  802d50:	68 68 4e 80 00       	push   $0x804e68
  802d55:	68 df 00 00 00       	push   $0xdf
  802d5a:	68 f5 4d 80 00       	push   $0x804df5
  802d5f:	e8 bd 14 00 00       	call   804221 <_panic>
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 10                	mov    (%eax),%edx
  802d69:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d6c:	89 10                	mov    %edx,(%eax)
  802d6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 0b                	je     802d82 <alloc_block_FF+0x247>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d7f:	89 50 04             	mov    %edx,0x4(%eax)
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d90:	89 50 04             	mov    %edx,0x4(%eax)
  802d93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	85 c0                	test   %eax,%eax
  802d9a:	75 08                	jne    802da4 <alloc_block_FF+0x269>
  802d9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9f:	a3 30 60 80 00       	mov    %eax,0x806030
  802da4:	a1 38 60 80 00       	mov    0x806038,%eax
  802da9:	40                   	inc    %eax
  802daa:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db3:	75 17                	jne    802dcc <alloc_block_FF+0x291>
  802db5:	83 ec 04             	sub    $0x4,%esp
  802db8:	68 d7 4d 80 00       	push   $0x804dd7
  802dbd:	68 e1 00 00 00       	push   $0xe1
  802dc2:	68 f5 4d 80 00       	push   $0x804df5
  802dc7:	e8 55 14 00 00       	call   804221 <_panic>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	74 10                	je     802de5 <alloc_block_FF+0x2aa>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddd:	8b 52 04             	mov    0x4(%edx),%edx
  802de0:	89 50 04             	mov    %edx,0x4(%eax)
  802de3:	eb 0b                	jmp    802df0 <alloc_block_FF+0x2b5>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	a3 30 60 80 00       	mov    %eax,0x806030
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 0f                	je     802e09 <alloc_block_FF+0x2ce>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e03:	8b 12                	mov    (%edx),%edx
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	eb 0a                	jmp    802e13 <alloc_block_FF+0x2d8>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e26:	a1 38 60 80 00       	mov    0x806038,%eax
  802e2b:	48                   	dec    %eax
  802e2c:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	6a 00                	push   $0x0
  802e36:	ff 75 b4             	pushl  -0x4c(%ebp)
  802e39:	ff 75 b0             	pushl  -0x50(%ebp)
  802e3c:	e8 cb fc ff ff       	call   802b0c <set_block_data>
  802e41:	83 c4 10             	add    $0x10,%esp
  802e44:	e9 95 00 00 00       	jmp    802ede <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	6a 01                	push   $0x1
  802e4e:	ff 75 b8             	pushl  -0x48(%ebp)
  802e51:	ff 75 bc             	pushl  -0x44(%ebp)
  802e54:	e8 b3 fc ff ff       	call   802b0c <set_block_data>
  802e59:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e60:	75 17                	jne    802e79 <alloc_block_FF+0x33e>
  802e62:	83 ec 04             	sub    $0x4,%esp
  802e65:	68 d7 4d 80 00       	push   $0x804dd7
  802e6a:	68 e8 00 00 00       	push   $0xe8
  802e6f:	68 f5 4d 80 00       	push   $0x804df5
  802e74:	e8 a8 13 00 00       	call   804221 <_panic>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 10                	je     802e92 <alloc_block_FF+0x357>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8a:	8b 52 04             	mov    0x4(%edx),%edx
  802e8d:	89 50 04             	mov    %edx,0x4(%eax)
  802e90:	eb 0b                	jmp    802e9d <alloc_block_FF+0x362>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 04             	mov    0x4(%eax),%eax
  802e98:	a3 30 60 80 00       	mov    %eax,0x806030
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 40 04             	mov    0x4(%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0f                	je     802eb6 <alloc_block_FF+0x37b>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb0:	8b 12                	mov    (%edx),%edx
  802eb2:	89 10                	mov    %edx,(%eax)
  802eb4:	eb 0a                	jmp    802ec0 <alloc_block_FF+0x385>
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed3:	a1 38 60 80 00       	mov    0x806038,%eax
  802ed8:	48                   	dec    %eax
  802ed9:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802ede:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ee1:	e9 0f 01 00 00       	jmp    802ff5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ee6:	a1 34 60 80 00       	mov    0x806034,%eax
  802eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef2:	74 07                	je     802efb <alloc_block_FF+0x3c0>
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	eb 05                	jmp    802f00 <alloc_block_FF+0x3c5>
  802efb:	b8 00 00 00 00       	mov    $0x0,%eax
  802f00:	a3 34 60 80 00       	mov    %eax,0x806034
  802f05:	a1 34 60 80 00       	mov    0x806034,%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	0f 85 e9 fc ff ff    	jne    802bfb <alloc_block_FF+0xc0>
  802f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f16:	0f 85 df fc ff ff    	jne    802bfb <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	83 c0 08             	add    $0x8,%eax
  802f22:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f25:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	48                   	dec    %eax
  802f35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802f40:	f7 75 d8             	divl   -0x28(%ebp)
  802f43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f46:	29 d0                	sub    %edx,%eax
  802f48:	c1 e8 0c             	shr    $0xc,%eax
  802f4b:	83 ec 0c             	sub    $0xc,%esp
  802f4e:	50                   	push   %eax
  802f4f:	e8 6f ec ff ff       	call   801bc3 <sbrk>
  802f54:	83 c4 10             	add    $0x10,%esp
  802f57:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f5a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f5e:	75 0a                	jne    802f6a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f60:	b8 00 00 00 00       	mov    $0x0,%eax
  802f65:	e9 8b 00 00 00       	jmp    802ff5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f6a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f77:	01 d0                	add    %edx,%eax
  802f79:	48                   	dec    %eax
  802f7a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f80:	ba 00 00 00 00       	mov    $0x0,%edx
  802f85:	f7 75 cc             	divl   -0x34(%ebp)
  802f88:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f8b:	29 d0                	sub    %edx,%eax
  802f8d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f90:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f93:	01 d0                	add    %edx,%eax
  802f95:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  802f9a:	a1 40 60 80 00       	mov    0x806040,%eax
  802f9f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fa5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802fac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802faf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fb2:	01 d0                	add    %edx,%eax
  802fb4:	48                   	dec    %eax
  802fb5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802fb8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fbb:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc0:	f7 75 c4             	divl   -0x3c(%ebp)
  802fc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fc6:	29 d0                	sub    %edx,%eax
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	6a 01                	push   $0x1
  802fcd:	50                   	push   %eax
  802fce:	ff 75 d0             	pushl  -0x30(%ebp)
  802fd1:	e8 36 fb ff ff       	call   802b0c <set_block_data>
  802fd6:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802fd9:	83 ec 0c             	sub    $0xc,%esp
  802fdc:	ff 75 d0             	pushl  -0x30(%ebp)
  802fdf:	e8 f8 09 00 00       	call   8039dc <free_block>
  802fe4:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802fe7:	83 ec 0c             	sub    $0xc,%esp
  802fea:	ff 75 08             	pushl  0x8(%ebp)
  802fed:	e8 49 fb ff ff       	call   802b3b <alloc_block_FF>
  802ff2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802ff5:	c9                   	leave  
  802ff6:	c3                   	ret    

00802ff7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ff7:	55                   	push   %ebp
  802ff8:	89 e5                	mov    %esp,%ebp
  802ffa:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	83 e0 01             	and    $0x1,%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 03                	je     80300a <alloc_block_BF+0x13>
  803007:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80300a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80300e:	77 07                	ja     803017 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803010:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803017:	a1 24 60 80 00       	mov    0x806024,%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	75 73                	jne    803093 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	83 c0 10             	add    $0x10,%eax
  803026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803029:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803030:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803033:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803036:	01 d0                	add    %edx,%eax
  803038:	48                   	dec    %eax
  803039:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80303c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303f:	ba 00 00 00 00       	mov    $0x0,%edx
  803044:	f7 75 e0             	divl   -0x20(%ebp)
  803047:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304a:	29 d0                	sub    %edx,%eax
  80304c:	c1 e8 0c             	shr    $0xc,%eax
  80304f:	83 ec 0c             	sub    $0xc,%esp
  803052:	50                   	push   %eax
  803053:	e8 6b eb ff ff       	call   801bc3 <sbrk>
  803058:	83 c4 10             	add    $0x10,%esp
  80305b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80305e:	83 ec 0c             	sub    $0xc,%esp
  803061:	6a 00                	push   $0x0
  803063:	e8 5b eb ff ff       	call   801bc3 <sbrk>
  803068:	83 c4 10             	add    $0x10,%esp
  80306b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80306e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803071:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803074:	83 ec 08             	sub    $0x8,%esp
  803077:	50                   	push   %eax
  803078:	ff 75 d8             	pushl  -0x28(%ebp)
  80307b:	e8 9f f8 ff ff       	call   80291f <initialize_dynamic_allocator>
  803080:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803083:	83 ec 0c             	sub    $0xc,%esp
  803086:	68 33 4e 80 00       	push   $0x804e33
  80308b:	e8 91 db ff ff       	call   800c21 <cprintf>
  803090:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803093:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80309a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8030a1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8030a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8030af:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8030b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b7:	e9 1d 01 00 00       	jmp    8031d9 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8030c2:	83 ec 0c             	sub    $0xc,%esp
  8030c5:	ff 75 a8             	pushl  -0x58(%ebp)
  8030c8:	e8 ee f6 ff ff       	call   8027bb <get_block_size>
  8030cd:	83 c4 10             	add    $0x10,%esp
  8030d0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	83 c0 08             	add    $0x8,%eax
  8030d9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030dc:	0f 87 ef 00 00 00    	ja     8031d1 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	83 c0 18             	add    $0x18,%eax
  8030e8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030eb:	77 1d                	ja     80310a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030f3:	0f 86 d8 00 00 00    	jbe    8031d1 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8030f9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8030ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803102:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803105:	e9 c7 00 00 00       	jmp    8031d1 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	83 c0 08             	add    $0x8,%eax
  803110:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803113:	0f 85 9d 00 00 00    	jne    8031b6 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803119:	83 ec 04             	sub    $0x4,%esp
  80311c:	6a 01                	push   $0x1
  80311e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803121:	ff 75 a8             	pushl  -0x58(%ebp)
  803124:	e8 e3 f9 ff ff       	call   802b0c <set_block_data>
  803129:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80312c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803130:	75 17                	jne    803149 <alloc_block_BF+0x152>
  803132:	83 ec 04             	sub    $0x4,%esp
  803135:	68 d7 4d 80 00       	push   $0x804dd7
  80313a:	68 2c 01 00 00       	push   $0x12c
  80313f:	68 f5 4d 80 00       	push   $0x804df5
  803144:	e8 d8 10 00 00       	call   804221 <_panic>
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	74 10                	je     803162 <alloc_block_BF+0x16b>
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80315a:	8b 52 04             	mov    0x4(%edx),%edx
  80315d:	89 50 04             	mov    %edx,0x4(%eax)
  803160:	eb 0b                	jmp    80316d <alloc_block_BF+0x176>
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	a3 30 60 80 00       	mov    %eax,0x806030
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	74 0f                	je     803186 <alloc_block_BF+0x18f>
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803180:	8b 12                	mov    (%edx),%edx
  803182:	89 10                	mov    %edx,(%eax)
  803184:	eb 0a                	jmp    803190 <alloc_block_BF+0x199>
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a3:	a1 38 60 80 00       	mov    0x806038,%eax
  8031a8:	48                   	dec    %eax
  8031a9:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  8031ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031b1:	e9 01 04 00 00       	jmp    8035b7 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031bc:	76 13                	jbe    8031d1 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8031be:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8031c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8031cb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8031ce:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8031d1:	a1 34 60 80 00       	mov    0x806034,%eax
  8031d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031dd:	74 07                	je     8031e6 <alloc_block_BF+0x1ef>
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	eb 05                	jmp    8031eb <alloc_block_BF+0x1f4>
  8031e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031eb:	a3 34 60 80 00       	mov    %eax,0x806034
  8031f0:	a1 34 60 80 00       	mov    0x806034,%eax
  8031f5:	85 c0                	test   %eax,%eax
  8031f7:	0f 85 bf fe ff ff    	jne    8030bc <alloc_block_BF+0xc5>
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	0f 85 b5 fe ff ff    	jne    8030bc <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80320b:	0f 84 26 02 00 00    	je     803437 <alloc_block_BF+0x440>
  803211:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803215:	0f 85 1c 02 00 00    	jne    803437 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80321b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321e:	2b 45 08             	sub    0x8(%ebp),%eax
  803221:	83 e8 08             	sub    $0x8,%eax
  803224:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	8d 50 08             	lea    0x8(%eax),%edx
  80322d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803230:	01 d0                	add    %edx,%eax
  803232:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	83 c0 08             	add    $0x8,%eax
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	6a 01                	push   $0x1
  803240:	50                   	push   %eax
  803241:	ff 75 f0             	pushl  -0x10(%ebp)
  803244:	e8 c3 f8 ff ff       	call   802b0c <set_block_data>
  803249:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	75 68                	jne    8032be <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803256:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80325a:	75 17                	jne    803273 <alloc_block_BF+0x27c>
  80325c:	83 ec 04             	sub    $0x4,%esp
  80325f:	68 10 4e 80 00       	push   $0x804e10
  803264:	68 45 01 00 00       	push   $0x145
  803269:	68 f5 4d 80 00       	push   $0x804df5
  80326e:	e8 ae 0f 00 00       	call   804221 <_panic>
  803273:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803279:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	74 0d                	je     803294 <alloc_block_BF+0x29d>
  803287:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80328c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	eb 08                	jmp    80329c <alloc_block_BF+0x2a5>
  803294:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803297:	a3 30 60 80 00       	mov    %eax,0x806030
  80329c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80329f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8032a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ae:	a1 38 60 80 00       	mov    0x806038,%eax
  8032b3:	40                   	inc    %eax
  8032b4:	a3 38 60 80 00       	mov    %eax,0x806038
  8032b9:	e9 dc 00 00 00       	jmp    80339a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8032be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	75 65                	jne    80332c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032cb:	75 17                	jne    8032e4 <alloc_block_BF+0x2ed>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 44 4e 80 00       	push   $0x804e44
  8032d5:	68 4a 01 00 00       	push   $0x14a
  8032da:	68 f5 4d 80 00       	push   $0x804df5
  8032df:	e8 3d 0f 00 00       	call   804221 <_panic>
  8032e4:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8032ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ed:	89 50 04             	mov    %edx,0x4(%eax)
  8032f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f3:	8b 40 04             	mov    0x4(%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	74 0c                	je     803306 <alloc_block_BF+0x30f>
  8032fa:	a1 30 60 80 00       	mov    0x806030,%eax
  8032ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803302:	89 10                	mov    %edx,(%eax)
  803304:	eb 08                	jmp    80330e <alloc_block_BF+0x317>
  803306:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803309:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80330e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803311:	a3 30 60 80 00       	mov    %eax,0x806030
  803316:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331f:	a1 38 60 80 00       	mov    0x806038,%eax
  803324:	40                   	inc    %eax
  803325:	a3 38 60 80 00       	mov    %eax,0x806038
  80332a:	eb 6e                	jmp    80339a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80332c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803330:	74 06                	je     803338 <alloc_block_BF+0x341>
  803332:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803336:	75 17                	jne    80334f <alloc_block_BF+0x358>
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	68 68 4e 80 00       	push   $0x804e68
  803340:	68 4f 01 00 00       	push   $0x14f
  803345:	68 f5 4d 80 00       	push   $0x804df5
  80334a:	e8 d2 0e 00 00       	call   804221 <_panic>
  80334f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803352:	8b 10                	mov    (%eax),%edx
  803354:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803357:	89 10                	mov    %edx,(%eax)
  803359:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	74 0b                	je     80336d <alloc_block_BF+0x376>
  803362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803373:	89 10                	mov    %edx,(%eax)
  803375:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803378:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337b:	89 50 04             	mov    %edx,0x4(%eax)
  80337e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803381:	8b 00                	mov    (%eax),%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	75 08                	jne    80338f <alloc_block_BF+0x398>
  803387:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80338a:	a3 30 60 80 00       	mov    %eax,0x806030
  80338f:	a1 38 60 80 00       	mov    0x806038,%eax
  803394:	40                   	inc    %eax
  803395:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80339a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80339e:	75 17                	jne    8033b7 <alloc_block_BF+0x3c0>
  8033a0:	83 ec 04             	sub    $0x4,%esp
  8033a3:	68 d7 4d 80 00       	push   $0x804dd7
  8033a8:	68 51 01 00 00       	push   $0x151
  8033ad:	68 f5 4d 80 00       	push   $0x804df5
  8033b2:	e8 6a 0e 00 00       	call   804221 <_panic>
  8033b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 10                	je     8033d0 <alloc_block_BF+0x3d9>
  8033c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c8:	8b 52 04             	mov    0x4(%edx),%edx
  8033cb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ce:	eb 0b                	jmp    8033db <alloc_block_BF+0x3e4>
  8033d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	a3 30 60 80 00       	mov    %eax,0x806030
  8033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	74 0f                	je     8033f4 <alloc_block_BF+0x3fd>
  8033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e8:	8b 40 04             	mov    0x4(%eax),%eax
  8033eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033ee:	8b 12                	mov    (%edx),%edx
  8033f0:	89 10                	mov    %edx,(%eax)
  8033f2:	eb 0a                	jmp    8033fe <alloc_block_BF+0x407>
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803411:	a1 38 60 80 00       	mov    0x806038,%eax
  803416:	48                   	dec    %eax
  803417:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80341c:	83 ec 04             	sub    $0x4,%esp
  80341f:	6a 00                	push   $0x0
  803421:	ff 75 d0             	pushl  -0x30(%ebp)
  803424:	ff 75 cc             	pushl  -0x34(%ebp)
  803427:	e8 e0 f6 ff ff       	call   802b0c <set_block_data>
  80342c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	e9 80 01 00 00       	jmp    8035b7 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803437:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80343b:	0f 85 9d 00 00 00    	jne    8034de <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803441:	83 ec 04             	sub    $0x4,%esp
  803444:	6a 01                	push   $0x1
  803446:	ff 75 ec             	pushl  -0x14(%ebp)
  803449:	ff 75 f0             	pushl  -0x10(%ebp)
  80344c:	e8 bb f6 ff ff       	call   802b0c <set_block_data>
  803451:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803454:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803458:	75 17                	jne    803471 <alloc_block_BF+0x47a>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 d7 4d 80 00       	push   $0x804dd7
  803462:	68 58 01 00 00       	push   $0x158
  803467:	68 f5 4d 80 00       	push   $0x804df5
  80346c:	e8 b0 0d 00 00       	call   804221 <_panic>
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	85 c0                	test   %eax,%eax
  803478:	74 10                	je     80348a <alloc_block_BF+0x493>
  80347a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803482:	8b 52 04             	mov    0x4(%edx),%edx
  803485:	89 50 04             	mov    %edx,0x4(%eax)
  803488:	eb 0b                	jmp    803495 <alloc_block_BF+0x49e>
  80348a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348d:	8b 40 04             	mov    0x4(%eax),%eax
  803490:	a3 30 60 80 00       	mov    %eax,0x806030
  803495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 0f                	je     8034ae <alloc_block_BF+0x4b7>
  80349f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a8:	8b 12                	mov    (%edx),%edx
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	eb 0a                	jmp    8034b8 <alloc_block_BF+0x4c1>
  8034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cb:	a1 38 60 80 00       	mov    0x806038,%eax
  8034d0:	48                   	dec    %eax
  8034d1:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  8034d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d9:	e9 d9 00 00 00       	jmp    8035b7 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	83 c0 08             	add    $0x8,%eax
  8034e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8034e7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8034ee:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034f4:	01 d0                	add    %edx,%eax
  8034f6:	48                   	dec    %eax
  8034f7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8034fa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034fd:	ba 00 00 00 00       	mov    $0x0,%edx
  803502:	f7 75 c4             	divl   -0x3c(%ebp)
  803505:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803508:	29 d0                	sub    %edx,%eax
  80350a:	c1 e8 0c             	shr    $0xc,%eax
  80350d:	83 ec 0c             	sub    $0xc,%esp
  803510:	50                   	push   %eax
  803511:	e8 ad e6 ff ff       	call   801bc3 <sbrk>
  803516:	83 c4 10             	add    $0x10,%esp
  803519:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80351c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803520:	75 0a                	jne    80352c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803522:	b8 00 00 00 00       	mov    $0x0,%eax
  803527:	e9 8b 00 00 00       	jmp    8035b7 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80352c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803533:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803536:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	48                   	dec    %eax
  80353c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80353f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803542:	ba 00 00 00 00       	mov    $0x0,%edx
  803547:	f7 75 b8             	divl   -0x48(%ebp)
  80354a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80354d:	29 d0                	sub    %edx,%eax
  80354f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803552:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803555:	01 d0                	add    %edx,%eax
  803557:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  80355c:	a1 40 60 80 00       	mov    0x806040,%eax
  803561:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803567:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80356e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803574:	01 d0                	add    %edx,%eax
  803576:	48                   	dec    %eax
  803577:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80357a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80357d:	ba 00 00 00 00       	mov    $0x0,%edx
  803582:	f7 75 b0             	divl   -0x50(%ebp)
  803585:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803588:	29 d0                	sub    %edx,%eax
  80358a:	83 ec 04             	sub    $0x4,%esp
  80358d:	6a 01                	push   $0x1
  80358f:	50                   	push   %eax
  803590:	ff 75 bc             	pushl  -0x44(%ebp)
  803593:	e8 74 f5 ff ff       	call   802b0c <set_block_data>
  803598:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80359b:	83 ec 0c             	sub    $0xc,%esp
  80359e:	ff 75 bc             	pushl  -0x44(%ebp)
  8035a1:	e8 36 04 00 00       	call   8039dc <free_block>
  8035a6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8035a9:	83 ec 0c             	sub    $0xc,%esp
  8035ac:	ff 75 08             	pushl  0x8(%ebp)
  8035af:	e8 43 fa ff ff       	call   802ff7 <alloc_block_BF>
  8035b4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8035b7:	c9                   	leave  
  8035b8:	c3                   	ret    

008035b9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8035b9:	55                   	push   %ebp
  8035ba:	89 e5                	mov    %esp,%ebp
  8035bc:	53                   	push   %ebx
  8035bd:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8035c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8035ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d2:	74 1e                	je     8035f2 <merging+0x39>
  8035d4:	ff 75 08             	pushl  0x8(%ebp)
  8035d7:	e8 df f1 ff ff       	call   8027bb <get_block_size>
  8035dc:	83 c4 04             	add    $0x4,%esp
  8035df:	89 c2                	mov    %eax,%edx
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	01 d0                	add    %edx,%eax
  8035e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8035e9:	75 07                	jne    8035f2 <merging+0x39>
		prev_is_free = 1;
  8035eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8035f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035f6:	74 1e                	je     803616 <merging+0x5d>
  8035f8:	ff 75 10             	pushl  0x10(%ebp)
  8035fb:	e8 bb f1 ff ff       	call   8027bb <get_block_size>
  803600:	83 c4 04             	add    $0x4,%esp
  803603:	89 c2                	mov    %eax,%edx
  803605:	8b 45 10             	mov    0x10(%ebp),%eax
  803608:	01 d0                	add    %edx,%eax
  80360a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80360d:	75 07                	jne    803616 <merging+0x5d>
		next_is_free = 1;
  80360f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361a:	0f 84 cc 00 00 00    	je     8036ec <merging+0x133>
  803620:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803624:	0f 84 c2 00 00 00    	je     8036ec <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80362a:	ff 75 08             	pushl  0x8(%ebp)
  80362d:	e8 89 f1 ff ff       	call   8027bb <get_block_size>
  803632:	83 c4 04             	add    $0x4,%esp
  803635:	89 c3                	mov    %eax,%ebx
  803637:	ff 75 10             	pushl  0x10(%ebp)
  80363a:	e8 7c f1 ff ff       	call   8027bb <get_block_size>
  80363f:	83 c4 04             	add    $0x4,%esp
  803642:	01 c3                	add    %eax,%ebx
  803644:	ff 75 0c             	pushl  0xc(%ebp)
  803647:	e8 6f f1 ff ff       	call   8027bb <get_block_size>
  80364c:	83 c4 04             	add    $0x4,%esp
  80364f:	01 d8                	add    %ebx,%eax
  803651:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803654:	6a 00                	push   $0x0
  803656:	ff 75 ec             	pushl  -0x14(%ebp)
  803659:	ff 75 08             	pushl  0x8(%ebp)
  80365c:	e8 ab f4 ff ff       	call   802b0c <set_block_data>
  803661:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803668:	75 17                	jne    803681 <merging+0xc8>
  80366a:	83 ec 04             	sub    $0x4,%esp
  80366d:	68 d7 4d 80 00       	push   $0x804dd7
  803672:	68 7d 01 00 00       	push   $0x17d
  803677:	68 f5 4d 80 00       	push   $0x804df5
  80367c:	e8 a0 0b 00 00       	call   804221 <_panic>
  803681:	8b 45 0c             	mov    0xc(%ebp),%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 10                	je     80369a <merging+0xe1>
  80368a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803692:	8b 52 04             	mov    0x4(%edx),%edx
  803695:	89 50 04             	mov    %edx,0x4(%eax)
  803698:	eb 0b                	jmp    8036a5 <merging+0xec>
  80369a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369d:	8b 40 04             	mov    0x4(%eax),%eax
  8036a0:	a3 30 60 80 00       	mov    %eax,0x806030
  8036a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a8:	8b 40 04             	mov    0x4(%eax),%eax
  8036ab:	85 c0                	test   %eax,%eax
  8036ad:	74 0f                	je     8036be <merging+0x105>
  8036af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b2:	8b 40 04             	mov    0x4(%eax),%eax
  8036b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036b8:	8b 12                	mov    (%edx),%edx
  8036ba:	89 10                	mov    %edx,(%eax)
  8036bc:	eb 0a                	jmp    8036c8 <merging+0x10f>
  8036be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8036c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036db:	a1 38 60 80 00       	mov    0x806038,%eax
  8036e0:	48                   	dec    %eax
  8036e1:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8036e6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036e7:	e9 ea 02 00 00       	jmp    8039d6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8036ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f0:	74 3b                	je     80372d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8036f2:	83 ec 0c             	sub    $0xc,%esp
  8036f5:	ff 75 08             	pushl  0x8(%ebp)
  8036f8:	e8 be f0 ff ff       	call   8027bb <get_block_size>
  8036fd:	83 c4 10             	add    $0x10,%esp
  803700:	89 c3                	mov    %eax,%ebx
  803702:	83 ec 0c             	sub    $0xc,%esp
  803705:	ff 75 10             	pushl  0x10(%ebp)
  803708:	e8 ae f0 ff ff       	call   8027bb <get_block_size>
  80370d:	83 c4 10             	add    $0x10,%esp
  803710:	01 d8                	add    %ebx,%eax
  803712:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803715:	83 ec 04             	sub    $0x4,%esp
  803718:	6a 00                	push   $0x0
  80371a:	ff 75 e8             	pushl  -0x18(%ebp)
  80371d:	ff 75 08             	pushl  0x8(%ebp)
  803720:	e8 e7 f3 ff ff       	call   802b0c <set_block_data>
  803725:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803728:	e9 a9 02 00 00       	jmp    8039d6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80372d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803731:	0f 84 2d 01 00 00    	je     803864 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803737:	83 ec 0c             	sub    $0xc,%esp
  80373a:	ff 75 10             	pushl  0x10(%ebp)
  80373d:	e8 79 f0 ff ff       	call   8027bb <get_block_size>
  803742:	83 c4 10             	add    $0x10,%esp
  803745:	89 c3                	mov    %eax,%ebx
  803747:	83 ec 0c             	sub    $0xc,%esp
  80374a:	ff 75 0c             	pushl  0xc(%ebp)
  80374d:	e8 69 f0 ff ff       	call   8027bb <get_block_size>
  803752:	83 c4 10             	add    $0x10,%esp
  803755:	01 d8                	add    %ebx,%eax
  803757:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80375a:	83 ec 04             	sub    $0x4,%esp
  80375d:	6a 00                	push   $0x0
  80375f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803762:	ff 75 10             	pushl  0x10(%ebp)
  803765:	e8 a2 f3 ff ff       	call   802b0c <set_block_data>
  80376a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80376d:	8b 45 10             	mov    0x10(%ebp),%eax
  803770:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803773:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803777:	74 06                	je     80377f <merging+0x1c6>
  803779:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80377d:	75 17                	jne    803796 <merging+0x1dd>
  80377f:	83 ec 04             	sub    $0x4,%esp
  803782:	68 9c 4e 80 00       	push   $0x804e9c
  803787:	68 8d 01 00 00       	push   $0x18d
  80378c:	68 f5 4d 80 00       	push   $0x804df5
  803791:	e8 8b 0a 00 00       	call   804221 <_panic>
  803796:	8b 45 0c             	mov    0xc(%ebp),%eax
  803799:	8b 50 04             	mov    0x4(%eax),%edx
  80379c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379f:	89 50 04             	mov    %edx,0x4(%eax)
  8037a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ad:	8b 40 04             	mov    0x4(%eax),%eax
  8037b0:	85 c0                	test   %eax,%eax
  8037b2:	74 0d                	je     8037c1 <merging+0x208>
  8037b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037bd:	89 10                	mov    %edx,(%eax)
  8037bf:	eb 08                	jmp    8037c9 <merging+0x210>
  8037c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8037c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037cf:	89 50 04             	mov    %edx,0x4(%eax)
  8037d2:	a1 38 60 80 00       	mov    0x806038,%eax
  8037d7:	40                   	inc    %eax
  8037d8:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  8037dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037e1:	75 17                	jne    8037fa <merging+0x241>
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	68 d7 4d 80 00       	push   $0x804dd7
  8037eb:	68 8e 01 00 00       	push   $0x18e
  8037f0:	68 f5 4d 80 00       	push   $0x804df5
  8037f5:	e8 27 0a 00 00       	call   804221 <_panic>
  8037fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 10                	je     803813 <merging+0x25a>
  803803:	8b 45 0c             	mov    0xc(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80380b:	8b 52 04             	mov    0x4(%edx),%edx
  80380e:	89 50 04             	mov    %edx,0x4(%eax)
  803811:	eb 0b                	jmp    80381e <merging+0x265>
  803813:	8b 45 0c             	mov    0xc(%ebp),%eax
  803816:	8b 40 04             	mov    0x4(%eax),%eax
  803819:	a3 30 60 80 00       	mov    %eax,0x806030
  80381e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803821:	8b 40 04             	mov    0x4(%eax),%eax
  803824:	85 c0                	test   %eax,%eax
  803826:	74 0f                	je     803837 <merging+0x27e>
  803828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382b:	8b 40 04             	mov    0x4(%eax),%eax
  80382e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803831:	8b 12                	mov    (%edx),%edx
  803833:	89 10                	mov    %edx,(%eax)
  803835:	eb 0a                	jmp    803841 <merging+0x288>
  803837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803841:	8b 45 0c             	mov    0xc(%ebp),%eax
  803844:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803854:	a1 38 60 80 00       	mov    0x806038,%eax
  803859:	48                   	dec    %eax
  80385a:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80385f:	e9 72 01 00 00       	jmp    8039d6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803864:	8b 45 10             	mov    0x10(%ebp),%eax
  803867:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80386a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80386e:	74 79                	je     8038e9 <merging+0x330>
  803870:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803874:	74 73                	je     8038e9 <merging+0x330>
  803876:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80387a:	74 06                	je     803882 <merging+0x2c9>
  80387c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803880:	75 17                	jne    803899 <merging+0x2e0>
  803882:	83 ec 04             	sub    $0x4,%esp
  803885:	68 68 4e 80 00       	push   $0x804e68
  80388a:	68 94 01 00 00       	push   $0x194
  80388f:	68 f5 4d 80 00       	push   $0x804df5
  803894:	e8 88 09 00 00       	call   804221 <_panic>
  803899:	8b 45 08             	mov    0x8(%ebp),%eax
  80389c:	8b 10                	mov    (%eax),%edx
  80389e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a1:	89 10                	mov    %edx,(%eax)
  8038a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	74 0b                	je     8038b7 <merging+0x2fe>
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038b4:	89 50 04             	mov    %edx,0x4(%eax)
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038bd:	89 10                	mov    %edx,(%eax)
  8038bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c5:	89 50 04             	mov    %edx,0x4(%eax)
  8038c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038cb:	8b 00                	mov    (%eax),%eax
  8038cd:	85 c0                	test   %eax,%eax
  8038cf:	75 08                	jne    8038d9 <merging+0x320>
  8038d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d4:	a3 30 60 80 00       	mov    %eax,0x806030
  8038d9:	a1 38 60 80 00       	mov    0x806038,%eax
  8038de:	40                   	inc    %eax
  8038df:	a3 38 60 80 00       	mov    %eax,0x806038
  8038e4:	e9 ce 00 00 00       	jmp    8039b7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8038e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ed:	74 65                	je     803954 <merging+0x39b>
  8038ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038f3:	75 17                	jne    80390c <merging+0x353>
  8038f5:	83 ec 04             	sub    $0x4,%esp
  8038f8:	68 44 4e 80 00       	push   $0x804e44
  8038fd:	68 95 01 00 00       	push   $0x195
  803902:	68 f5 4d 80 00       	push   $0x804df5
  803907:	e8 15 09 00 00       	call   804221 <_panic>
  80390c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803912:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803915:	89 50 04             	mov    %edx,0x4(%eax)
  803918:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391b:	8b 40 04             	mov    0x4(%eax),%eax
  80391e:	85 c0                	test   %eax,%eax
  803920:	74 0c                	je     80392e <merging+0x375>
  803922:	a1 30 60 80 00       	mov    0x806030,%eax
  803927:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	eb 08                	jmp    803936 <merging+0x37d>
  80392e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803931:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803939:	a3 30 60 80 00       	mov    %eax,0x806030
  80393e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803947:	a1 38 60 80 00       	mov    0x806038,%eax
  80394c:	40                   	inc    %eax
  80394d:	a3 38 60 80 00       	mov    %eax,0x806038
  803952:	eb 63                	jmp    8039b7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803954:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803958:	75 17                	jne    803971 <merging+0x3b8>
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 10 4e 80 00       	push   $0x804e10
  803962:	68 98 01 00 00       	push   $0x198
  803967:	68 f5 4d 80 00       	push   $0x804df5
  80396c:	e8 b0 08 00 00       	call   804221 <_panic>
  803971:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803977:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397a:	89 10                	mov    %edx,(%eax)
  80397c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397f:	8b 00                	mov    (%eax),%eax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 0d                	je     803992 <merging+0x3d9>
  803985:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80398a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80398d:	89 50 04             	mov    %edx,0x4(%eax)
  803990:	eb 08                	jmp    80399a <merging+0x3e1>
  803992:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803995:	a3 30 60 80 00       	mov    %eax,0x806030
  80399a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ac:	a1 38 60 80 00       	mov    0x806038,%eax
  8039b1:	40                   	inc    %eax
  8039b2:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  8039b7:	83 ec 0c             	sub    $0xc,%esp
  8039ba:	ff 75 10             	pushl  0x10(%ebp)
  8039bd:	e8 f9 ed ff ff       	call   8027bb <get_block_size>
  8039c2:	83 c4 10             	add    $0x10,%esp
  8039c5:	83 ec 04             	sub    $0x4,%esp
  8039c8:	6a 00                	push   $0x0
  8039ca:	50                   	push   %eax
  8039cb:	ff 75 10             	pushl  0x10(%ebp)
  8039ce:	e8 39 f1 ff ff       	call   802b0c <set_block_data>
  8039d3:	83 c4 10             	add    $0x10,%esp
	}
}
  8039d6:	90                   	nop
  8039d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039da:	c9                   	leave  
  8039db:	c3                   	ret    

008039dc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8039dc:	55                   	push   %ebp
  8039dd:	89 e5                	mov    %esp,%ebp
  8039df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8039e2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039e7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8039ea:	a1 30 60 80 00       	mov    0x806030,%eax
  8039ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039f2:	73 1b                	jae    803a0f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8039f4:	a1 30 60 80 00       	mov    0x806030,%eax
  8039f9:	83 ec 04             	sub    $0x4,%esp
  8039fc:	ff 75 08             	pushl  0x8(%ebp)
  8039ff:	6a 00                	push   $0x0
  803a01:	50                   	push   %eax
  803a02:	e8 b2 fb ff ff       	call   8035b9 <merging>
  803a07:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a0a:	e9 8b 00 00 00       	jmp    803a9a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a0f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a14:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a17:	76 18                	jbe    803a31 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a19:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a1e:	83 ec 04             	sub    $0x4,%esp
  803a21:	ff 75 08             	pushl  0x8(%ebp)
  803a24:	50                   	push   %eax
  803a25:	6a 00                	push   $0x0
  803a27:	e8 8d fb ff ff       	call   8035b9 <merging>
  803a2c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a2f:	eb 69                	jmp    803a9a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a31:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a39:	eb 39                	jmp    803a74 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a41:	73 29                	jae    803a6c <free_block+0x90>
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	8b 00                	mov    (%eax),%eax
  803a48:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a4b:	76 1f                	jbe    803a6c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a50:	8b 00                	mov    (%eax),%eax
  803a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803a55:	83 ec 04             	sub    $0x4,%esp
  803a58:	ff 75 08             	pushl  0x8(%ebp)
  803a5b:	ff 75 f0             	pushl  -0x10(%ebp)
  803a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  803a61:	e8 53 fb ff ff       	call   8035b9 <merging>
  803a66:	83 c4 10             	add    $0x10,%esp
			break;
  803a69:	90                   	nop
		}
	}
}
  803a6a:	eb 2e                	jmp    803a9a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a6c:	a1 34 60 80 00       	mov    0x806034,%eax
  803a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a78:	74 07                	je     803a81 <free_block+0xa5>
  803a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7d:	8b 00                	mov    (%eax),%eax
  803a7f:	eb 05                	jmp    803a86 <free_block+0xaa>
  803a81:	b8 00 00 00 00       	mov    $0x0,%eax
  803a86:	a3 34 60 80 00       	mov    %eax,0x806034
  803a8b:	a1 34 60 80 00       	mov    0x806034,%eax
  803a90:	85 c0                	test   %eax,%eax
  803a92:	75 a7                	jne    803a3b <free_block+0x5f>
  803a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a98:	75 a1                	jne    803a3b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a9a:	90                   	nop
  803a9b:	c9                   	leave  
  803a9c:	c3                   	ret    

00803a9d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a9d:	55                   	push   %ebp
  803a9e:	89 e5                	mov    %esp,%ebp
  803aa0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803aa3:	ff 75 08             	pushl  0x8(%ebp)
  803aa6:	e8 10 ed ff ff       	call   8027bb <get_block_size>
  803aab:	83 c4 04             	add    $0x4,%esp
  803aae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803ab1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803ab8:	eb 17                	jmp    803ad1 <copy_data+0x34>
  803aba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac0:	01 c2                	add    %eax,%edx
  803ac2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac8:	01 c8                	add    %ecx,%eax
  803aca:	8a 00                	mov    (%eax),%al
  803acc:	88 02                	mov    %al,(%edx)
  803ace:	ff 45 fc             	incl   -0x4(%ebp)
  803ad1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ad4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803ad7:	72 e1                	jb     803aba <copy_data+0x1d>
}
  803ad9:	90                   	nop
  803ada:	c9                   	leave  
  803adb:	c3                   	ret    

00803adc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803adc:	55                   	push   %ebp
  803add:	89 e5                	mov    %esp,%ebp
  803adf:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ae6:	75 23                	jne    803b0b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803ae8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803aec:	74 13                	je     803b01 <realloc_block_FF+0x25>
  803aee:	83 ec 0c             	sub    $0xc,%esp
  803af1:	ff 75 0c             	pushl  0xc(%ebp)
  803af4:	e8 42 f0 ff ff       	call   802b3b <alloc_block_FF>
  803af9:	83 c4 10             	add    $0x10,%esp
  803afc:	e9 e4 06 00 00       	jmp    8041e5 <realloc_block_FF+0x709>
		return NULL;
  803b01:	b8 00 00 00 00       	mov    $0x0,%eax
  803b06:	e9 da 06 00 00       	jmp    8041e5 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b0f:	75 18                	jne    803b29 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b11:	83 ec 0c             	sub    $0xc,%esp
  803b14:	ff 75 08             	pushl  0x8(%ebp)
  803b17:	e8 c0 fe ff ff       	call   8039dc <free_block>
  803b1c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b24:	e9 bc 06 00 00       	jmp    8041e5 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803b29:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b2d:	77 07                	ja     803b36 <realloc_block_FF+0x5a>
  803b2f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b39:	83 e0 01             	and    $0x1,%eax
  803b3c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b42:	83 c0 08             	add    $0x8,%eax
  803b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b48:	83 ec 0c             	sub    $0xc,%esp
  803b4b:	ff 75 08             	pushl  0x8(%ebp)
  803b4e:	e8 68 ec ff ff       	call   8027bb <get_block_size>
  803b53:	83 c4 10             	add    $0x10,%esp
  803b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b5c:	83 e8 08             	sub    $0x8,%eax
  803b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803b62:	8b 45 08             	mov    0x8(%ebp),%eax
  803b65:	83 e8 04             	sub    $0x4,%eax
  803b68:	8b 00                	mov    (%eax),%eax
  803b6a:	83 e0 fe             	and    $0xfffffffe,%eax
  803b6d:	89 c2                	mov    %eax,%edx
  803b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b72:	01 d0                	add    %edx,%eax
  803b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803b77:	83 ec 0c             	sub    $0xc,%esp
  803b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b7d:	e8 39 ec ff ff       	call   8027bb <get_block_size>
  803b82:	83 c4 10             	add    $0x10,%esp
  803b85:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b8b:	83 e8 08             	sub    $0x8,%eax
  803b8e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b94:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b97:	75 08                	jne    803ba1 <realloc_block_FF+0xc5>
	{
		 return va;
  803b99:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9c:	e9 44 06 00 00       	jmp    8041e5 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ba7:	0f 83 d5 03 00 00    	jae    803f82 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb0:	2b 45 0c             	sub    0xc(%ebp),%eax
  803bb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803bb6:	83 ec 0c             	sub    $0xc,%esp
  803bb9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bbc:	e8 13 ec ff ff       	call   8027d4 <is_free_block>
  803bc1:	83 c4 10             	add    $0x10,%esp
  803bc4:	84 c0                	test   %al,%al
  803bc6:	0f 84 3b 01 00 00    	je     803d07 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803bcc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bcf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bd2:	01 d0                	add    %edx,%eax
  803bd4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803bd7:	83 ec 04             	sub    $0x4,%esp
  803bda:	6a 01                	push   $0x1
  803bdc:	ff 75 f0             	pushl  -0x10(%ebp)
  803bdf:	ff 75 08             	pushl  0x8(%ebp)
  803be2:	e8 25 ef ff ff       	call   802b0c <set_block_data>
  803be7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803bea:	8b 45 08             	mov    0x8(%ebp),%eax
  803bed:	83 e8 04             	sub    $0x4,%eax
  803bf0:	8b 00                	mov    (%eax),%eax
  803bf2:	83 e0 fe             	and    $0xfffffffe,%eax
  803bf5:	89 c2                	mov    %eax,%edx
  803bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfa:	01 d0                	add    %edx,%eax
  803bfc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803bff:	83 ec 04             	sub    $0x4,%esp
  803c02:	6a 00                	push   $0x0
  803c04:	ff 75 cc             	pushl  -0x34(%ebp)
  803c07:	ff 75 c8             	pushl  -0x38(%ebp)
  803c0a:	e8 fd ee ff ff       	call   802b0c <set_block_data>
  803c0f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c16:	74 06                	je     803c1e <realloc_block_FF+0x142>
  803c18:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c1c:	75 17                	jne    803c35 <realloc_block_FF+0x159>
  803c1e:	83 ec 04             	sub    $0x4,%esp
  803c21:	68 68 4e 80 00       	push   $0x804e68
  803c26:	68 f6 01 00 00       	push   $0x1f6
  803c2b:	68 f5 4d 80 00       	push   $0x804df5
  803c30:	e8 ec 05 00 00       	call   804221 <_panic>
  803c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c38:	8b 10                	mov    (%eax),%edx
  803c3a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c3d:	89 10                	mov    %edx,(%eax)
  803c3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c42:	8b 00                	mov    (%eax),%eax
  803c44:	85 c0                	test   %eax,%eax
  803c46:	74 0b                	je     803c53 <realloc_block_FF+0x177>
  803c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4b:	8b 00                	mov    (%eax),%eax
  803c4d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c50:	89 50 04             	mov    %edx,0x4(%eax)
  803c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c56:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c59:	89 10                	mov    %edx,(%eax)
  803c5b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c61:	89 50 04             	mov    %edx,0x4(%eax)
  803c64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c67:	8b 00                	mov    (%eax),%eax
  803c69:	85 c0                	test   %eax,%eax
  803c6b:	75 08                	jne    803c75 <realloc_block_FF+0x199>
  803c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c70:	a3 30 60 80 00       	mov    %eax,0x806030
  803c75:	a1 38 60 80 00       	mov    0x806038,%eax
  803c7a:	40                   	inc    %eax
  803c7b:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c84:	75 17                	jne    803c9d <realloc_block_FF+0x1c1>
  803c86:	83 ec 04             	sub    $0x4,%esp
  803c89:	68 d7 4d 80 00       	push   $0x804dd7
  803c8e:	68 f7 01 00 00       	push   $0x1f7
  803c93:	68 f5 4d 80 00       	push   $0x804df5
  803c98:	e8 84 05 00 00       	call   804221 <_panic>
  803c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca0:	8b 00                	mov    (%eax),%eax
  803ca2:	85 c0                	test   %eax,%eax
  803ca4:	74 10                	je     803cb6 <realloc_block_FF+0x1da>
  803ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca9:	8b 00                	mov    (%eax),%eax
  803cab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cae:	8b 52 04             	mov    0x4(%edx),%edx
  803cb1:	89 50 04             	mov    %edx,0x4(%eax)
  803cb4:	eb 0b                	jmp    803cc1 <realloc_block_FF+0x1e5>
  803cb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb9:	8b 40 04             	mov    0x4(%eax),%eax
  803cbc:	a3 30 60 80 00       	mov    %eax,0x806030
  803cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc4:	8b 40 04             	mov    0x4(%eax),%eax
  803cc7:	85 c0                	test   %eax,%eax
  803cc9:	74 0f                	je     803cda <realloc_block_FF+0x1fe>
  803ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cce:	8b 40 04             	mov    0x4(%eax),%eax
  803cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd4:	8b 12                	mov    (%edx),%edx
  803cd6:	89 10                	mov    %edx,(%eax)
  803cd8:	eb 0a                	jmp    803ce4 <realloc_block_FF+0x208>
  803cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ce4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ced:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf7:	a1 38 60 80 00       	mov    0x806038,%eax
  803cfc:	48                   	dec    %eax
  803cfd:	a3 38 60 80 00       	mov    %eax,0x806038
  803d02:	e9 73 02 00 00       	jmp    803f7a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803d07:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d0b:	0f 86 69 02 00 00    	jbe    803f7a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d11:	83 ec 04             	sub    $0x4,%esp
  803d14:	6a 01                	push   $0x1
  803d16:	ff 75 f0             	pushl  -0x10(%ebp)
  803d19:	ff 75 08             	pushl  0x8(%ebp)
  803d1c:	e8 eb ed ff ff       	call   802b0c <set_block_data>
  803d21:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d24:	8b 45 08             	mov    0x8(%ebp),%eax
  803d27:	83 e8 04             	sub    $0x4,%eax
  803d2a:	8b 00                	mov    (%eax),%eax
  803d2c:	83 e0 fe             	and    $0xfffffffe,%eax
  803d2f:	89 c2                	mov    %eax,%edx
  803d31:	8b 45 08             	mov    0x8(%ebp),%eax
  803d34:	01 d0                	add    %edx,%eax
  803d36:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d39:	a1 38 60 80 00       	mov    0x806038,%eax
  803d3e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d41:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d45:	75 68                	jne    803daf <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d47:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d4b:	75 17                	jne    803d64 <realloc_block_FF+0x288>
  803d4d:	83 ec 04             	sub    $0x4,%esp
  803d50:	68 10 4e 80 00       	push   $0x804e10
  803d55:	68 06 02 00 00       	push   $0x206
  803d5a:	68 f5 4d 80 00       	push   $0x804df5
  803d5f:	e8 bd 04 00 00       	call   804221 <_panic>
  803d64:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803d6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6d:	89 10                	mov    %edx,(%eax)
  803d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	85 c0                	test   %eax,%eax
  803d76:	74 0d                	je     803d85 <realloc_block_FF+0x2a9>
  803d78:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d80:	89 50 04             	mov    %edx,0x4(%eax)
  803d83:	eb 08                	jmp    803d8d <realloc_block_FF+0x2b1>
  803d85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d88:	a3 30 60 80 00       	mov    %eax,0x806030
  803d8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d90:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d9f:	a1 38 60 80 00       	mov    0x806038,%eax
  803da4:	40                   	inc    %eax
  803da5:	a3 38 60 80 00       	mov    %eax,0x806038
  803daa:	e9 b0 01 00 00       	jmp    803f5f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803daf:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803db4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803db7:	76 68                	jbe    803e21 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803db9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dbd:	75 17                	jne    803dd6 <realloc_block_FF+0x2fa>
  803dbf:	83 ec 04             	sub    $0x4,%esp
  803dc2:	68 10 4e 80 00       	push   $0x804e10
  803dc7:	68 0b 02 00 00       	push   $0x20b
  803dcc:	68 f5 4d 80 00       	push   $0x804df5
  803dd1:	e8 4b 04 00 00       	call   804221 <_panic>
  803dd6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803ddc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ddf:	89 10                	mov    %edx,(%eax)
  803de1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de4:	8b 00                	mov    (%eax),%eax
  803de6:	85 c0                	test   %eax,%eax
  803de8:	74 0d                	je     803df7 <realloc_block_FF+0x31b>
  803dea:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803def:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803df2:	89 50 04             	mov    %edx,0x4(%eax)
  803df5:	eb 08                	jmp    803dff <realloc_block_FF+0x323>
  803df7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dfa:	a3 30 60 80 00       	mov    %eax,0x806030
  803dff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e02:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e11:	a1 38 60 80 00       	mov    0x806038,%eax
  803e16:	40                   	inc    %eax
  803e17:	a3 38 60 80 00       	mov    %eax,0x806038
  803e1c:	e9 3e 01 00 00       	jmp    803f5f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e21:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e26:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e29:	73 68                	jae    803e93 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e2b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e2f:	75 17                	jne    803e48 <realloc_block_FF+0x36c>
  803e31:	83 ec 04             	sub    $0x4,%esp
  803e34:	68 44 4e 80 00       	push   $0x804e44
  803e39:	68 10 02 00 00       	push   $0x210
  803e3e:	68 f5 4d 80 00       	push   $0x804df5
  803e43:	e8 d9 03 00 00       	call   804221 <_panic>
  803e48:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e51:	89 50 04             	mov    %edx,0x4(%eax)
  803e54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e57:	8b 40 04             	mov    0x4(%eax),%eax
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	74 0c                	je     803e6a <realloc_block_FF+0x38e>
  803e5e:	a1 30 60 80 00       	mov    0x806030,%eax
  803e63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e66:	89 10                	mov    %edx,(%eax)
  803e68:	eb 08                	jmp    803e72 <realloc_block_FF+0x396>
  803e6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e75:	a3 30 60 80 00       	mov    %eax,0x806030
  803e7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e83:	a1 38 60 80 00       	mov    0x806038,%eax
  803e88:	40                   	inc    %eax
  803e89:	a3 38 60 80 00       	mov    %eax,0x806038
  803e8e:	e9 cc 00 00 00       	jmp    803f5f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e9a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ea2:	e9 8a 00 00 00       	jmp    803f31 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eaa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ead:	73 7a                	jae    803f29 <realloc_block_FF+0x44d>
  803eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb2:	8b 00                	mov    (%eax),%eax
  803eb4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803eb7:	73 70                	jae    803f29 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ebd:	74 06                	je     803ec5 <realloc_block_FF+0x3e9>
  803ebf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ec3:	75 17                	jne    803edc <realloc_block_FF+0x400>
  803ec5:	83 ec 04             	sub    $0x4,%esp
  803ec8:	68 68 4e 80 00       	push   $0x804e68
  803ecd:	68 1a 02 00 00       	push   $0x21a
  803ed2:	68 f5 4d 80 00       	push   $0x804df5
  803ed7:	e8 45 03 00 00       	call   804221 <_panic>
  803edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803edf:	8b 10                	mov    (%eax),%edx
  803ee1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ee4:	89 10                	mov    %edx,(%eax)
  803ee6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	85 c0                	test   %eax,%eax
  803eed:	74 0b                	je     803efa <realloc_block_FF+0x41e>
  803eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef2:	8b 00                	mov    (%eax),%eax
  803ef4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ef7:	89 50 04             	mov    %edx,0x4(%eax)
  803efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f00:	89 10                	mov    %edx,(%eax)
  803f02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f08:	89 50 04             	mov    %edx,0x4(%eax)
  803f0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f0e:	8b 00                	mov    (%eax),%eax
  803f10:	85 c0                	test   %eax,%eax
  803f12:	75 08                	jne    803f1c <realloc_block_FF+0x440>
  803f14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f17:	a3 30 60 80 00       	mov    %eax,0x806030
  803f1c:	a1 38 60 80 00       	mov    0x806038,%eax
  803f21:	40                   	inc    %eax
  803f22:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803f27:	eb 36                	jmp    803f5f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f29:	a1 34 60 80 00       	mov    0x806034,%eax
  803f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f35:	74 07                	je     803f3e <realloc_block_FF+0x462>
  803f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3a:	8b 00                	mov    (%eax),%eax
  803f3c:	eb 05                	jmp    803f43 <realloc_block_FF+0x467>
  803f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f43:	a3 34 60 80 00       	mov    %eax,0x806034
  803f48:	a1 34 60 80 00       	mov    0x806034,%eax
  803f4d:	85 c0                	test   %eax,%eax
  803f4f:	0f 85 52 ff ff ff    	jne    803ea7 <realloc_block_FF+0x3cb>
  803f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f59:	0f 85 48 ff ff ff    	jne    803ea7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803f5f:	83 ec 04             	sub    $0x4,%esp
  803f62:	6a 00                	push   $0x0
  803f64:	ff 75 d8             	pushl  -0x28(%ebp)
  803f67:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f6a:	e8 9d eb ff ff       	call   802b0c <set_block_data>
  803f6f:	83 c4 10             	add    $0x10,%esp
				return va;
  803f72:	8b 45 08             	mov    0x8(%ebp),%eax
  803f75:	e9 6b 02 00 00       	jmp    8041e5 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7d:	e9 63 02 00 00       	jmp    8041e5 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f85:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f88:	0f 86 4d 02 00 00    	jbe    8041db <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803f8e:	83 ec 0c             	sub    $0xc,%esp
  803f91:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f94:	e8 3b e8 ff ff       	call   8027d4 <is_free_block>
  803f99:	83 c4 10             	add    $0x10,%esp
  803f9c:	84 c0                	test   %al,%al
  803f9e:	0f 84 37 02 00 00    	je     8041db <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fa7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803faa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803fad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fb0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803fb3:	76 38                	jbe    803fed <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803fb5:	83 ec 0c             	sub    $0xc,%esp
  803fb8:	ff 75 0c             	pushl  0xc(%ebp)
  803fbb:	e8 7b eb ff ff       	call   802b3b <alloc_block_FF>
  803fc0:	83 c4 10             	add    $0x10,%esp
  803fc3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803fc6:	83 ec 08             	sub    $0x8,%esp
  803fc9:	ff 75 c0             	pushl  -0x40(%ebp)
  803fcc:	ff 75 08             	pushl  0x8(%ebp)
  803fcf:	e8 c9 fa ff ff       	call   803a9d <copy_data>
  803fd4:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803fd7:	83 ec 0c             	sub    $0xc,%esp
  803fda:	ff 75 08             	pushl  0x8(%ebp)
  803fdd:	e8 fa f9 ff ff       	call   8039dc <free_block>
  803fe2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803fe5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803fe8:	e9 f8 01 00 00       	jmp    8041e5 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ff0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ff3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ff6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ffa:	0f 87 a0 00 00 00    	ja     8040a0 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804000:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804004:	75 17                	jne    80401d <realloc_block_FF+0x541>
  804006:	83 ec 04             	sub    $0x4,%esp
  804009:	68 d7 4d 80 00       	push   $0x804dd7
  80400e:	68 38 02 00 00       	push   $0x238
  804013:	68 f5 4d 80 00       	push   $0x804df5
  804018:	e8 04 02 00 00       	call   804221 <_panic>
  80401d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804020:	8b 00                	mov    (%eax),%eax
  804022:	85 c0                	test   %eax,%eax
  804024:	74 10                	je     804036 <realloc_block_FF+0x55a>
  804026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804029:	8b 00                	mov    (%eax),%eax
  80402b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80402e:	8b 52 04             	mov    0x4(%edx),%edx
  804031:	89 50 04             	mov    %edx,0x4(%eax)
  804034:	eb 0b                	jmp    804041 <realloc_block_FF+0x565>
  804036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804039:	8b 40 04             	mov    0x4(%eax),%eax
  80403c:	a3 30 60 80 00       	mov    %eax,0x806030
  804041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804044:	8b 40 04             	mov    0x4(%eax),%eax
  804047:	85 c0                	test   %eax,%eax
  804049:	74 0f                	je     80405a <realloc_block_FF+0x57e>
  80404b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404e:	8b 40 04             	mov    0x4(%eax),%eax
  804051:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804054:	8b 12                	mov    (%edx),%edx
  804056:	89 10                	mov    %edx,(%eax)
  804058:	eb 0a                	jmp    804064 <realloc_block_FF+0x588>
  80405a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405d:	8b 00                	mov    (%eax),%eax
  80405f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804077:	a1 38 60 80 00       	mov    0x806038,%eax
  80407c:	48                   	dec    %eax
  80407d:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804085:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804088:	01 d0                	add    %edx,%eax
  80408a:	83 ec 04             	sub    $0x4,%esp
  80408d:	6a 01                	push   $0x1
  80408f:	50                   	push   %eax
  804090:	ff 75 08             	pushl  0x8(%ebp)
  804093:	e8 74 ea ff ff       	call   802b0c <set_block_data>
  804098:	83 c4 10             	add    $0x10,%esp
  80409b:	e9 36 01 00 00       	jmp    8041d6 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8040a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040a6:	01 d0                	add    %edx,%eax
  8040a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8040ab:	83 ec 04             	sub    $0x4,%esp
  8040ae:	6a 01                	push   $0x1
  8040b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8040b3:	ff 75 08             	pushl  0x8(%ebp)
  8040b6:	e8 51 ea ff ff       	call   802b0c <set_block_data>
  8040bb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8040be:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c1:	83 e8 04             	sub    $0x4,%eax
  8040c4:	8b 00                	mov    (%eax),%eax
  8040c6:	83 e0 fe             	and    $0xfffffffe,%eax
  8040c9:	89 c2                	mov    %eax,%edx
  8040cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ce:	01 d0                	add    %edx,%eax
  8040d0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040d7:	74 06                	je     8040df <realloc_block_FF+0x603>
  8040d9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8040dd:	75 17                	jne    8040f6 <realloc_block_FF+0x61a>
  8040df:	83 ec 04             	sub    $0x4,%esp
  8040e2:	68 68 4e 80 00       	push   $0x804e68
  8040e7:	68 44 02 00 00       	push   $0x244
  8040ec:	68 f5 4d 80 00       	push   $0x804df5
  8040f1:	e8 2b 01 00 00       	call   804221 <_panic>
  8040f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f9:	8b 10                	mov    (%eax),%edx
  8040fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040fe:	89 10                	mov    %edx,(%eax)
  804100:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804103:	8b 00                	mov    (%eax),%eax
  804105:	85 c0                	test   %eax,%eax
  804107:	74 0b                	je     804114 <realloc_block_FF+0x638>
  804109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410c:	8b 00                	mov    (%eax),%eax
  80410e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804111:	89 50 04             	mov    %edx,0x4(%eax)
  804114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804117:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80411a:	89 10                	mov    %edx,(%eax)
  80411c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80411f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804122:	89 50 04             	mov    %edx,0x4(%eax)
  804125:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804128:	8b 00                	mov    (%eax),%eax
  80412a:	85 c0                	test   %eax,%eax
  80412c:	75 08                	jne    804136 <realloc_block_FF+0x65a>
  80412e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804131:	a3 30 60 80 00       	mov    %eax,0x806030
  804136:	a1 38 60 80 00       	mov    0x806038,%eax
  80413b:	40                   	inc    %eax
  80413c:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804141:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804145:	75 17                	jne    80415e <realloc_block_FF+0x682>
  804147:	83 ec 04             	sub    $0x4,%esp
  80414a:	68 d7 4d 80 00       	push   $0x804dd7
  80414f:	68 45 02 00 00       	push   $0x245
  804154:	68 f5 4d 80 00       	push   $0x804df5
  804159:	e8 c3 00 00 00       	call   804221 <_panic>
  80415e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804161:	8b 00                	mov    (%eax),%eax
  804163:	85 c0                	test   %eax,%eax
  804165:	74 10                	je     804177 <realloc_block_FF+0x69b>
  804167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80416a:	8b 00                	mov    (%eax),%eax
  80416c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80416f:	8b 52 04             	mov    0x4(%edx),%edx
  804172:	89 50 04             	mov    %edx,0x4(%eax)
  804175:	eb 0b                	jmp    804182 <realloc_block_FF+0x6a6>
  804177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80417a:	8b 40 04             	mov    0x4(%eax),%eax
  80417d:	a3 30 60 80 00       	mov    %eax,0x806030
  804182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804185:	8b 40 04             	mov    0x4(%eax),%eax
  804188:	85 c0                	test   %eax,%eax
  80418a:	74 0f                	je     80419b <realloc_block_FF+0x6bf>
  80418c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418f:	8b 40 04             	mov    0x4(%eax),%eax
  804192:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804195:	8b 12                	mov    (%edx),%edx
  804197:	89 10                	mov    %edx,(%eax)
  804199:	eb 0a                	jmp    8041a5 <realloc_block_FF+0x6c9>
  80419b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419e:	8b 00                	mov    (%eax),%eax
  8041a0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b8:	a1 38 60 80 00       	mov    0x806038,%eax
  8041bd:	48                   	dec    %eax
  8041be:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  8041c3:	83 ec 04             	sub    $0x4,%esp
  8041c6:	6a 00                	push   $0x0
  8041c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8041cb:	ff 75 b8             	pushl  -0x48(%ebp)
  8041ce:	e8 39 e9 ff ff       	call   802b0c <set_block_data>
  8041d3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8041d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d9:	eb 0a                	jmp    8041e5 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8041db:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8041e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8041e5:	c9                   	leave  
  8041e6:	c3                   	ret    

008041e7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8041e7:	55                   	push   %ebp
  8041e8:	89 e5                	mov    %esp,%ebp
  8041ea:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8041ed:	83 ec 04             	sub    $0x4,%esp
  8041f0:	68 d4 4e 80 00       	push   $0x804ed4
  8041f5:	68 58 02 00 00       	push   $0x258
  8041fa:	68 f5 4d 80 00       	push   $0x804df5
  8041ff:	e8 1d 00 00 00       	call   804221 <_panic>

00804204 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804204:	55                   	push   %ebp
  804205:	89 e5                	mov    %esp,%ebp
  804207:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80420a:	83 ec 04             	sub    $0x4,%esp
  80420d:	68 fc 4e 80 00       	push   $0x804efc
  804212:	68 61 02 00 00       	push   $0x261
  804217:	68 f5 4d 80 00       	push   $0x804df5
  80421c:	e8 00 00 00 00       	call   804221 <_panic>

00804221 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  804221:	55                   	push   %ebp
  804222:	89 e5                	mov    %esp,%ebp
  804224:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  804227:	8d 45 10             	lea    0x10(%ebp),%eax
  80422a:	83 c0 04             	add    $0x4,%eax
  80422d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804230:	a1 60 60 98 00       	mov    0x986060,%eax
  804235:	85 c0                	test   %eax,%eax
  804237:	74 16                	je     80424f <_panic+0x2e>
		cprintf("%s: ", argv0);
  804239:	a1 60 60 98 00       	mov    0x986060,%eax
  80423e:	83 ec 08             	sub    $0x8,%esp
  804241:	50                   	push   %eax
  804242:	68 24 4f 80 00       	push   $0x804f24
  804247:	e8 d5 c9 ff ff       	call   800c21 <cprintf>
  80424c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80424f:	a1 00 60 80 00       	mov    0x806000,%eax
  804254:	ff 75 0c             	pushl  0xc(%ebp)
  804257:	ff 75 08             	pushl  0x8(%ebp)
  80425a:	50                   	push   %eax
  80425b:	68 29 4f 80 00       	push   $0x804f29
  804260:	e8 bc c9 ff ff       	call   800c21 <cprintf>
  804265:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  804268:	8b 45 10             	mov    0x10(%ebp),%eax
  80426b:	83 ec 08             	sub    $0x8,%esp
  80426e:	ff 75 f4             	pushl  -0xc(%ebp)
  804271:	50                   	push   %eax
  804272:	e8 3f c9 ff ff       	call   800bb6 <vcprintf>
  804277:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80427a:	83 ec 08             	sub    $0x8,%esp
  80427d:	6a 00                	push   $0x0
  80427f:	68 45 4f 80 00       	push   $0x804f45
  804284:	e8 2d c9 ff ff       	call   800bb6 <vcprintf>
  804289:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80428c:	e8 ae c8 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  804291:	eb fe                	jmp    804291 <_panic+0x70>

00804293 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  804293:	55                   	push   %ebp
  804294:	89 e5                	mov    %esp,%ebp
  804296:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804299:	a1 20 60 80 00       	mov    0x806020,%eax
  80429e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8042a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042a7:	39 c2                	cmp    %eax,%edx
  8042a9:	74 14                	je     8042bf <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8042ab:	83 ec 04             	sub    $0x4,%esp
  8042ae:	68 48 4f 80 00       	push   $0x804f48
  8042b3:	6a 26                	push   $0x26
  8042b5:	68 94 4f 80 00       	push   $0x804f94
  8042ba:	e8 62 ff ff ff       	call   804221 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8042bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8042c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8042cd:	e9 c5 00 00 00       	jmp    804397 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8042d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8042dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8042df:	01 d0                	add    %edx,%eax
  8042e1:	8b 00                	mov    (%eax),%eax
  8042e3:	85 c0                	test   %eax,%eax
  8042e5:	75 08                	jne    8042ef <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8042e7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8042ea:	e9 a5 00 00 00       	jmp    804394 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8042ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8042fd:	eb 69                	jmp    804368 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8042ff:	a1 20 60 80 00       	mov    0x806020,%eax
  804304:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80430a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80430d:	89 d0                	mov    %edx,%eax
  80430f:	01 c0                	add    %eax,%eax
  804311:	01 d0                	add    %edx,%eax
  804313:	c1 e0 03             	shl    $0x3,%eax
  804316:	01 c8                	add    %ecx,%eax
  804318:	8a 40 04             	mov    0x4(%eax),%al
  80431b:	84 c0                	test   %al,%al
  80431d:	75 46                	jne    804365 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80431f:	a1 20 60 80 00       	mov    0x806020,%eax
  804324:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80432a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80432d:	89 d0                	mov    %edx,%eax
  80432f:	01 c0                	add    %eax,%eax
  804331:	01 d0                	add    %edx,%eax
  804333:	c1 e0 03             	shl    $0x3,%eax
  804336:	01 c8                	add    %ecx,%eax
  804338:	8b 00                	mov    (%eax),%eax
  80433a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80433d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804340:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804345:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80434a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  804351:	8b 45 08             	mov    0x8(%ebp),%eax
  804354:	01 c8                	add    %ecx,%eax
  804356:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804358:	39 c2                	cmp    %eax,%edx
  80435a:	75 09                	jne    804365 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80435c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  804363:	eb 15                	jmp    80437a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804365:	ff 45 e8             	incl   -0x18(%ebp)
  804368:	a1 20 60 80 00       	mov    0x806020,%eax
  80436d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804376:	39 c2                	cmp    %eax,%edx
  804378:	77 85                	ja     8042ff <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80437a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80437e:	75 14                	jne    804394 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  804380:	83 ec 04             	sub    $0x4,%esp
  804383:	68 a0 4f 80 00       	push   $0x804fa0
  804388:	6a 3a                	push   $0x3a
  80438a:	68 94 4f 80 00       	push   $0x804f94
  80438f:	e8 8d fe ff ff       	call   804221 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  804394:	ff 45 f0             	incl   -0x10(%ebp)
  804397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80439a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80439d:	0f 8c 2f ff ff ff    	jl     8042d2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8043a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8043aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8043b1:	eb 26                	jmp    8043d9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8043b3:	a1 20 60 80 00       	mov    0x806020,%eax
  8043b8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8043be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043c1:	89 d0                	mov    %edx,%eax
  8043c3:	01 c0                	add    %eax,%eax
  8043c5:	01 d0                	add    %edx,%eax
  8043c7:	c1 e0 03             	shl    $0x3,%eax
  8043ca:	01 c8                	add    %ecx,%eax
  8043cc:	8a 40 04             	mov    0x4(%eax),%al
  8043cf:	3c 01                	cmp    $0x1,%al
  8043d1:	75 03                	jne    8043d6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8043d3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8043d6:	ff 45 e0             	incl   -0x20(%ebp)
  8043d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8043de:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8043e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043e7:	39 c2                	cmp    %eax,%edx
  8043e9:	77 c8                	ja     8043b3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8043eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8043f1:	74 14                	je     804407 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8043f3:	83 ec 04             	sub    $0x4,%esp
  8043f6:	68 f4 4f 80 00       	push   $0x804ff4
  8043fb:	6a 44                	push   $0x44
  8043fd:	68 94 4f 80 00       	push   $0x804f94
  804402:	e8 1a fe ff ff       	call   804221 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804407:	90                   	nop
  804408:	c9                   	leave  
  804409:	c3                   	ret    
  80440a:	66 90                	xchg   %ax,%ax

0080440c <__udivdi3>:
  80440c:	55                   	push   %ebp
  80440d:	57                   	push   %edi
  80440e:	56                   	push   %esi
  80440f:	53                   	push   %ebx
  804410:	83 ec 1c             	sub    $0x1c,%esp
  804413:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804417:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80441b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80441f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804423:	89 ca                	mov    %ecx,%edx
  804425:	89 f8                	mov    %edi,%eax
  804427:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80442b:	85 f6                	test   %esi,%esi
  80442d:	75 2d                	jne    80445c <__udivdi3+0x50>
  80442f:	39 cf                	cmp    %ecx,%edi
  804431:	77 65                	ja     804498 <__udivdi3+0x8c>
  804433:	89 fd                	mov    %edi,%ebp
  804435:	85 ff                	test   %edi,%edi
  804437:	75 0b                	jne    804444 <__udivdi3+0x38>
  804439:	b8 01 00 00 00       	mov    $0x1,%eax
  80443e:	31 d2                	xor    %edx,%edx
  804440:	f7 f7                	div    %edi
  804442:	89 c5                	mov    %eax,%ebp
  804444:	31 d2                	xor    %edx,%edx
  804446:	89 c8                	mov    %ecx,%eax
  804448:	f7 f5                	div    %ebp
  80444a:	89 c1                	mov    %eax,%ecx
  80444c:	89 d8                	mov    %ebx,%eax
  80444e:	f7 f5                	div    %ebp
  804450:	89 cf                	mov    %ecx,%edi
  804452:	89 fa                	mov    %edi,%edx
  804454:	83 c4 1c             	add    $0x1c,%esp
  804457:	5b                   	pop    %ebx
  804458:	5e                   	pop    %esi
  804459:	5f                   	pop    %edi
  80445a:	5d                   	pop    %ebp
  80445b:	c3                   	ret    
  80445c:	39 ce                	cmp    %ecx,%esi
  80445e:	77 28                	ja     804488 <__udivdi3+0x7c>
  804460:	0f bd fe             	bsr    %esi,%edi
  804463:	83 f7 1f             	xor    $0x1f,%edi
  804466:	75 40                	jne    8044a8 <__udivdi3+0x9c>
  804468:	39 ce                	cmp    %ecx,%esi
  80446a:	72 0a                	jb     804476 <__udivdi3+0x6a>
  80446c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804470:	0f 87 9e 00 00 00    	ja     804514 <__udivdi3+0x108>
  804476:	b8 01 00 00 00       	mov    $0x1,%eax
  80447b:	89 fa                	mov    %edi,%edx
  80447d:	83 c4 1c             	add    $0x1c,%esp
  804480:	5b                   	pop    %ebx
  804481:	5e                   	pop    %esi
  804482:	5f                   	pop    %edi
  804483:	5d                   	pop    %ebp
  804484:	c3                   	ret    
  804485:	8d 76 00             	lea    0x0(%esi),%esi
  804488:	31 ff                	xor    %edi,%edi
  80448a:	31 c0                	xor    %eax,%eax
  80448c:	89 fa                	mov    %edi,%edx
  80448e:	83 c4 1c             	add    $0x1c,%esp
  804491:	5b                   	pop    %ebx
  804492:	5e                   	pop    %esi
  804493:	5f                   	pop    %edi
  804494:	5d                   	pop    %ebp
  804495:	c3                   	ret    
  804496:	66 90                	xchg   %ax,%ax
  804498:	89 d8                	mov    %ebx,%eax
  80449a:	f7 f7                	div    %edi
  80449c:	31 ff                	xor    %edi,%edi
  80449e:	89 fa                	mov    %edi,%edx
  8044a0:	83 c4 1c             	add    $0x1c,%esp
  8044a3:	5b                   	pop    %ebx
  8044a4:	5e                   	pop    %esi
  8044a5:	5f                   	pop    %edi
  8044a6:	5d                   	pop    %ebp
  8044a7:	c3                   	ret    
  8044a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8044ad:	89 eb                	mov    %ebp,%ebx
  8044af:	29 fb                	sub    %edi,%ebx
  8044b1:	89 f9                	mov    %edi,%ecx
  8044b3:	d3 e6                	shl    %cl,%esi
  8044b5:	89 c5                	mov    %eax,%ebp
  8044b7:	88 d9                	mov    %bl,%cl
  8044b9:	d3 ed                	shr    %cl,%ebp
  8044bb:	89 e9                	mov    %ebp,%ecx
  8044bd:	09 f1                	or     %esi,%ecx
  8044bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8044c3:	89 f9                	mov    %edi,%ecx
  8044c5:	d3 e0                	shl    %cl,%eax
  8044c7:	89 c5                	mov    %eax,%ebp
  8044c9:	89 d6                	mov    %edx,%esi
  8044cb:	88 d9                	mov    %bl,%cl
  8044cd:	d3 ee                	shr    %cl,%esi
  8044cf:	89 f9                	mov    %edi,%ecx
  8044d1:	d3 e2                	shl    %cl,%edx
  8044d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044d7:	88 d9                	mov    %bl,%cl
  8044d9:	d3 e8                	shr    %cl,%eax
  8044db:	09 c2                	or     %eax,%edx
  8044dd:	89 d0                	mov    %edx,%eax
  8044df:	89 f2                	mov    %esi,%edx
  8044e1:	f7 74 24 0c          	divl   0xc(%esp)
  8044e5:	89 d6                	mov    %edx,%esi
  8044e7:	89 c3                	mov    %eax,%ebx
  8044e9:	f7 e5                	mul    %ebp
  8044eb:	39 d6                	cmp    %edx,%esi
  8044ed:	72 19                	jb     804508 <__udivdi3+0xfc>
  8044ef:	74 0b                	je     8044fc <__udivdi3+0xf0>
  8044f1:	89 d8                	mov    %ebx,%eax
  8044f3:	31 ff                	xor    %edi,%edi
  8044f5:	e9 58 ff ff ff       	jmp    804452 <__udivdi3+0x46>
  8044fa:	66 90                	xchg   %ax,%ax
  8044fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804500:	89 f9                	mov    %edi,%ecx
  804502:	d3 e2                	shl    %cl,%edx
  804504:	39 c2                	cmp    %eax,%edx
  804506:	73 e9                	jae    8044f1 <__udivdi3+0xe5>
  804508:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80450b:	31 ff                	xor    %edi,%edi
  80450d:	e9 40 ff ff ff       	jmp    804452 <__udivdi3+0x46>
  804512:	66 90                	xchg   %ax,%ax
  804514:	31 c0                	xor    %eax,%eax
  804516:	e9 37 ff ff ff       	jmp    804452 <__udivdi3+0x46>
  80451b:	90                   	nop

0080451c <__umoddi3>:
  80451c:	55                   	push   %ebp
  80451d:	57                   	push   %edi
  80451e:	56                   	push   %esi
  80451f:	53                   	push   %ebx
  804520:	83 ec 1c             	sub    $0x1c,%esp
  804523:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804527:	8b 74 24 34          	mov    0x34(%esp),%esi
  80452b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80452f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804533:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804537:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80453b:	89 f3                	mov    %esi,%ebx
  80453d:	89 fa                	mov    %edi,%edx
  80453f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804543:	89 34 24             	mov    %esi,(%esp)
  804546:	85 c0                	test   %eax,%eax
  804548:	75 1a                	jne    804564 <__umoddi3+0x48>
  80454a:	39 f7                	cmp    %esi,%edi
  80454c:	0f 86 a2 00 00 00    	jbe    8045f4 <__umoddi3+0xd8>
  804552:	89 c8                	mov    %ecx,%eax
  804554:	89 f2                	mov    %esi,%edx
  804556:	f7 f7                	div    %edi
  804558:	89 d0                	mov    %edx,%eax
  80455a:	31 d2                	xor    %edx,%edx
  80455c:	83 c4 1c             	add    $0x1c,%esp
  80455f:	5b                   	pop    %ebx
  804560:	5e                   	pop    %esi
  804561:	5f                   	pop    %edi
  804562:	5d                   	pop    %ebp
  804563:	c3                   	ret    
  804564:	39 f0                	cmp    %esi,%eax
  804566:	0f 87 ac 00 00 00    	ja     804618 <__umoddi3+0xfc>
  80456c:	0f bd e8             	bsr    %eax,%ebp
  80456f:	83 f5 1f             	xor    $0x1f,%ebp
  804572:	0f 84 ac 00 00 00    	je     804624 <__umoddi3+0x108>
  804578:	bf 20 00 00 00       	mov    $0x20,%edi
  80457d:	29 ef                	sub    %ebp,%edi
  80457f:	89 fe                	mov    %edi,%esi
  804581:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804585:	89 e9                	mov    %ebp,%ecx
  804587:	d3 e0                	shl    %cl,%eax
  804589:	89 d7                	mov    %edx,%edi
  80458b:	89 f1                	mov    %esi,%ecx
  80458d:	d3 ef                	shr    %cl,%edi
  80458f:	09 c7                	or     %eax,%edi
  804591:	89 e9                	mov    %ebp,%ecx
  804593:	d3 e2                	shl    %cl,%edx
  804595:	89 14 24             	mov    %edx,(%esp)
  804598:	89 d8                	mov    %ebx,%eax
  80459a:	d3 e0                	shl    %cl,%eax
  80459c:	89 c2                	mov    %eax,%edx
  80459e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045a2:	d3 e0                	shl    %cl,%eax
  8045a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045ac:	89 f1                	mov    %esi,%ecx
  8045ae:	d3 e8                	shr    %cl,%eax
  8045b0:	09 d0                	or     %edx,%eax
  8045b2:	d3 eb                	shr    %cl,%ebx
  8045b4:	89 da                	mov    %ebx,%edx
  8045b6:	f7 f7                	div    %edi
  8045b8:	89 d3                	mov    %edx,%ebx
  8045ba:	f7 24 24             	mull   (%esp)
  8045bd:	89 c6                	mov    %eax,%esi
  8045bf:	89 d1                	mov    %edx,%ecx
  8045c1:	39 d3                	cmp    %edx,%ebx
  8045c3:	0f 82 87 00 00 00    	jb     804650 <__umoddi3+0x134>
  8045c9:	0f 84 91 00 00 00    	je     804660 <__umoddi3+0x144>
  8045cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8045d3:	29 f2                	sub    %esi,%edx
  8045d5:	19 cb                	sbb    %ecx,%ebx
  8045d7:	89 d8                	mov    %ebx,%eax
  8045d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045dd:	d3 e0                	shl    %cl,%eax
  8045df:	89 e9                	mov    %ebp,%ecx
  8045e1:	d3 ea                	shr    %cl,%edx
  8045e3:	09 d0                	or     %edx,%eax
  8045e5:	89 e9                	mov    %ebp,%ecx
  8045e7:	d3 eb                	shr    %cl,%ebx
  8045e9:	89 da                	mov    %ebx,%edx
  8045eb:	83 c4 1c             	add    $0x1c,%esp
  8045ee:	5b                   	pop    %ebx
  8045ef:	5e                   	pop    %esi
  8045f0:	5f                   	pop    %edi
  8045f1:	5d                   	pop    %ebp
  8045f2:	c3                   	ret    
  8045f3:	90                   	nop
  8045f4:	89 fd                	mov    %edi,%ebp
  8045f6:	85 ff                	test   %edi,%edi
  8045f8:	75 0b                	jne    804605 <__umoddi3+0xe9>
  8045fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8045ff:	31 d2                	xor    %edx,%edx
  804601:	f7 f7                	div    %edi
  804603:	89 c5                	mov    %eax,%ebp
  804605:	89 f0                	mov    %esi,%eax
  804607:	31 d2                	xor    %edx,%edx
  804609:	f7 f5                	div    %ebp
  80460b:	89 c8                	mov    %ecx,%eax
  80460d:	f7 f5                	div    %ebp
  80460f:	89 d0                	mov    %edx,%eax
  804611:	e9 44 ff ff ff       	jmp    80455a <__umoddi3+0x3e>
  804616:	66 90                	xchg   %ax,%ax
  804618:	89 c8                	mov    %ecx,%eax
  80461a:	89 f2                	mov    %esi,%edx
  80461c:	83 c4 1c             	add    $0x1c,%esp
  80461f:	5b                   	pop    %ebx
  804620:	5e                   	pop    %esi
  804621:	5f                   	pop    %edi
  804622:	5d                   	pop    %ebp
  804623:	c3                   	ret    
  804624:	3b 04 24             	cmp    (%esp),%eax
  804627:	72 06                	jb     80462f <__umoddi3+0x113>
  804629:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80462d:	77 0f                	ja     80463e <__umoddi3+0x122>
  80462f:	89 f2                	mov    %esi,%edx
  804631:	29 f9                	sub    %edi,%ecx
  804633:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804637:	89 14 24             	mov    %edx,(%esp)
  80463a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80463e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804642:	8b 14 24             	mov    (%esp),%edx
  804645:	83 c4 1c             	add    $0x1c,%esp
  804648:	5b                   	pop    %ebx
  804649:	5e                   	pop    %esi
  80464a:	5f                   	pop    %edi
  80464b:	5d                   	pop    %ebp
  80464c:	c3                   	ret    
  80464d:	8d 76 00             	lea    0x0(%esi),%esi
  804650:	2b 04 24             	sub    (%esp),%eax
  804653:	19 fa                	sbb    %edi,%edx
  804655:	89 d1                	mov    %edx,%ecx
  804657:	89 c6                	mov    %eax,%esi
  804659:	e9 71 ff ff ff       	jmp    8045cf <__umoddi3+0xb3>
  80465e:	66 90                	xchg   %ax,%ax
  804660:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804664:	72 ea                	jb     804650 <__umoddi3+0x134>
  804666:	89 d9                	mov    %ebx,%ecx
  804668:	e9 62 ff ff ff       	jmp    8045cf <__umoddi3+0xb3>
