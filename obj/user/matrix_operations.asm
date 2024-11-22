
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
  80005e:	e8 a5 20 00 00       	call   802108 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 c0 45 80 00       	push   $0x8045c0
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 c4 45 80 00       	push   $0x8045c4
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 e8 45 80 00       	push   $0x8045e8
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 c4 45 80 00       	push   $0x8045c4
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 c0 45 80 00       	push   $0x8045c0
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 0c 46 80 00       	push   $0x80460c
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
  8000e6:	68 2c 46 80 00       	push   $0x80462c
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 4e 46 80 00       	push   $0x80464e
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 5c 46 80 00       	push   $0x80465c
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 6a 46 80 00       	push   $0x80466a
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 7a 46 80 00       	push   $0x80467a
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
  80017a:	68 84 46 80 00       	push   $0x804684
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
  8001a0:	e8 7d 1f 00 00       	call   802122 <sys_unlock_cons>

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
  8002d2:	e8 31 1e 00 00       	call   802108 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 a8 46 80 00       	push   $0x8046a8
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 c6 46 80 00       	push   $0x8046c6
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 dd 46 80 00       	push   $0x8046dd
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 f4 46 80 00       	push   $0x8046f4
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 7a 46 80 00       	push   $0x80467a
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
  80035e:	e8 bf 1d 00 00       	call   802122 <sys_unlock_cons>


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
  8003df:	e8 24 1d 00 00       	call   802108 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 0b 47 80 00       	push   $0x80470b
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 29 1d 00 00       	call   802122 <sys_unlock_cons>

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
  80048e:	e8 75 1c 00 00       	call   802108 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 24 47 80 00       	push   $0x804724
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
  8004c8:	e8 55 1c 00 00       	call   802122 <sys_unlock_cons>

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
  8008bf:	e8 0c 1b 00 00       	call   8023d0 <sys_get_virtual_time>
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
  80092b:	68 42 47 80 00       	push   $0x804742
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
  800946:	68 49 47 80 00       	push   $0x804749
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
  80099c:	68 4d 47 80 00       	push   $0x80474d
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
  8009b7:	68 49 47 80 00       	push   $0x804749
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
  8009e6:	e8 68 18 00 00       	call   802253 <sys_cputc>
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
  8009f7:	e8 f3 16 00 00       	call   8020ef <sys_cgetc>
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
  800a14:	e8 6b 19 00 00       	call   802384 <sys_getenvindex>
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
  800a82:	e8 81 16 00 00       	call   802108 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 70 47 80 00       	push   $0x804770
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
  800ab2:	68 98 47 80 00       	push   $0x804798
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
  800ae3:	68 c0 47 80 00       	push   $0x8047c0
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 50 80 00       	mov    0x805020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 18 48 80 00       	push   $0x804818
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 70 47 80 00       	push   $0x804770
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 01 16 00 00       	call   802122 <sys_unlock_cons>
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
  800b34:	e8 17 18 00 00       	call   802350 <sys_destroy_env>
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
  800b45:	e8 6c 18 00 00       	call   8023b6 <sys_exit_env>
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
  800b93:	e8 2e 15 00 00       	call   8020c6 <sys_cputs>
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
  800c0a:	e8 b7 14 00 00       	call   8020c6 <sys_cputs>
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
  800c54:	e8 af 14 00 00       	call   802108 <sys_lock_cons>
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
  800c74:	e8 a9 14 00 00       	call   802122 <sys_unlock_cons>
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
  800cbe:	e8 85 36 00 00       	call   804348 <__udivdi3>
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
  800d0e:	e8 45 37 00 00       	call   804458 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 54 4a 80 00       	add    $0x804a54,%eax
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
  800e69:	8b 04 85 78 4a 80 00 	mov    0x804a78(,%eax,4),%eax
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
  800f4a:	8b 34 9d c0 48 80 00 	mov    0x8048c0(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 65 4a 80 00       	push   $0x804a65
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
  800f6f:	68 6e 4a 80 00       	push   $0x804a6e
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
  800f9c:	be 71 4a 80 00       	mov    $0x804a71,%esi
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
  8012c7:	68 e8 4b 80 00       	push   $0x804be8
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
  801309:	68 eb 4b 80 00       	push   $0x804beb
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
  8013ba:	e8 49 0d 00 00       	call   802108 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 e8 4b 80 00       	push   $0x804be8
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
  80140d:	68 eb 4b 80 00       	push   $0x804beb
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
  8014b5:	e8 68 0c 00 00       	call   802122 <sys_unlock_cons>
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
  801baf:	68 fc 4b 80 00       	push   $0x804bfc
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 1e 4c 80 00       	push   $0x804c1e
  801bbe:	e8 9a 25 00 00       	call   80415d <_panic>

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
  801bcf:	e8 9d 0a 00 00       	call   802671 <sys_sbrk>
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
  801c4a:	e8 a6 08 00 00       	call   8024f5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 e6 0d 00 00       	call   802a44 <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 b8 08 00 00       	call   802526 <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 7f 12 00 00       	call   802f00 <alloc_block_BF>
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
  801de2:	e8 c1 08 00 00       	call   8026a8 <sys_allocate_user_mem>
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
  801e2a:	e8 95 08 00 00       	call   8026c4 <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 c8 1a 00 00       	call   803908 <free_block>
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
  801ed2:	e8 b5 07 00 00       	call   80268c <sys_free_user_mem>
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
  801ee0:	68 2c 4c 80 00       	push   $0x804c2c
  801ee5:	68 84 00 00 00       	push   $0x84
  801eea:	68 56 4c 80 00       	push   $0x804c56
  801eef:	e8 69 22 00 00       	call   80415d <_panic>
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
  801f0d:	eb 74                	jmp    801f83 <smalloc+0x8d>
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
  801f42:	eb 3f                	jmp    801f83 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f44:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f48:	ff 75 ec             	pushl  -0x14(%ebp)
  801f4b:	50                   	push   %eax
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	e8 3c 03 00 00       	call   802293 <sys_createSharedObject>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f5d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f61:	74 06                	je     801f69 <smalloc+0x73>
  801f63:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f67:	75 07                	jne    801f70 <smalloc+0x7a>
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	eb 13                	jmp    801f83 <smalloc+0x8d>
	 cprintf("153\n");
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	68 62 4c 80 00       	push   $0x804c62
  801f78:	e8 a4 ec ff ff       	call   800c21 <cprintf>
  801f7d:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	e8 24 03 00 00       	call   8022bd <sys_getSizeOfSharedObject>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f9f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fa3:	75 07                	jne    801fac <sget+0x27>
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	eb 5c                	jmp    802008 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fb2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	39 d0                	cmp    %edx,%eax
  801fc1:	7d 02                	jge    801fc5 <sget+0x40>
  801fc3:	89 d0                	mov    %edx,%eax
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	50                   	push   %eax
  801fc9:	e8 0b fc ff ff       	call   801bd9 <malloc>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fd8:	75 07                	jne    801fe1 <sget+0x5c>
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb 27                	jmp    802008 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	ff 75 e8             	pushl  -0x18(%ebp)
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 e8 02 00 00       	call   8022da <sys_getSharedObject>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ff8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ffc:	75 07                	jne    802005 <sget+0x80>
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  802003:	eb 03                	jmp    802008 <sget+0x83>
	return ptr;
  802005:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	68 68 4c 80 00       	push   $0x804c68
  802018:	68 c2 00 00 00       	push   $0xc2
  80201d:	68 56 4c 80 00       	push   $0x804c56
  802022:	e8 36 21 00 00       	call   80415d <_panic>

00802027 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	68 8c 4c 80 00       	push   $0x804c8c
  802035:	68 d9 00 00 00       	push   $0xd9
  80203a:	68 56 4c 80 00       	push   $0x804c56
  80203f:	e8 19 21 00 00       	call   80415d <_panic>

00802044 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	68 b2 4c 80 00       	push   $0x804cb2
  802052:	68 e5 00 00 00       	push   $0xe5
  802057:	68 56 4c 80 00       	push   $0x804c56
  80205c:	e8 fc 20 00 00       	call   80415d <_panic>

00802061 <shrink>:

}
void shrink(uint32 newSize)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	68 b2 4c 80 00       	push   $0x804cb2
  80206f:	68 ea 00 00 00       	push   $0xea
  802074:	68 56 4c 80 00       	push   $0x804c56
  802079:	e8 df 20 00 00       	call   80415d <_panic>

0080207e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	68 b2 4c 80 00       	push   $0x804cb2
  80208c:	68 ef 00 00 00       	push   $0xef
  802091:	68 56 4c 80 00       	push   $0x804c56
  802096:	e8 c2 20 00 00       	call   80415d <_panic>

0080209b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	57                   	push   %edi
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020b6:	cd 30                	int    $0x30
  8020b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    

008020c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	52                   	push   %edx
  8020de:	ff 75 0c             	pushl  0xc(%ebp)
  8020e1:	50                   	push   %eax
  8020e2:	6a 00                	push   $0x0
  8020e4:	e8 b2 ff ff ff       	call   80209b <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	90                   	nop
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 02                	push   $0x2
  8020fe:	e8 98 ff ff ff       	call   80209b <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 03                	push   $0x3
  802117:	e8 7f ff ff ff       	call   80209b <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	90                   	nop
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 04                	push   $0x4
  802131:	e8 65 ff ff ff       	call   80209b <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	90                   	nop
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 08                	push   $0x8
  80214f:	e8 47 ff ff ff       	call   80209b <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	56                   	push   %esi
  80215d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80215e:	8b 75 18             	mov    0x18(%ebp),%esi
  802161:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802164:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	56                   	push   %esi
  80216e:	53                   	push   %ebx
  80216f:	51                   	push   %ecx
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	6a 09                	push   $0x9
  802174:	e8 22 ff ff ff       	call   80209b <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    

00802183 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802186:	8b 55 0c             	mov    0xc(%ebp),%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	6a 0a                	push   $0xa
  802196:	e8 00 ff ff ff       	call   80209b <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	ff 75 08             	pushl  0x8(%ebp)
  8021af:	6a 0b                	push   $0xb
  8021b1:	e8 e5 fe ff ff       	call   80209b <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 0c                	push   $0xc
  8021ca:	e8 cc fe ff ff       	call   80209b <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 0d                	push   $0xd
  8021e3:	e8 b3 fe ff ff       	call   80209b <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 0e                	push   $0xe
  8021fc:	e8 9a fe ff ff       	call   80209b <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 0f                	push   $0xf
  802215:	e8 81 fe ff ff       	call   80209b <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	ff 75 08             	pushl  0x8(%ebp)
  80222d:	6a 10                	push   $0x10
  80222f:	e8 67 fe ff ff       	call   80209b <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 11                	push   $0x11
  802248:	e8 4e fe ff ff       	call   80209b <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
}
  802250:	90                   	nop
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_cputc>:

void
sys_cputc(const char c)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80225f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	50                   	push   %eax
  80226c:	6a 01                	push   $0x1
  80226e:	e8 28 fe ff ff       	call   80209b <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	90                   	nop
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 14                	push   $0x14
  802288:	e8 0e fe ff ff       	call   80209b <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 04             	sub    $0x4,%esp
  802299:	8b 45 10             	mov    0x10(%ebp),%eax
  80229c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80229f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	51                   	push   %ecx
  8022ac:	52                   	push   %edx
  8022ad:	ff 75 0c             	pushl  0xc(%ebp)
  8022b0:	50                   	push   %eax
  8022b1:	6a 15                	push   $0x15
  8022b3:	e8 e3 fd ff ff       	call   80209b <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	52                   	push   %edx
  8022cd:	50                   	push   %eax
  8022ce:	6a 16                	push   $0x16
  8022d0:	e8 c6 fd ff ff       	call   80209b <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	51                   	push   %ecx
  8022eb:	52                   	push   %edx
  8022ec:	50                   	push   %eax
  8022ed:	6a 17                	push   $0x17
  8022ef:	e8 a7 fd ff ff       	call   80209b <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	6a 18                	push   $0x18
  80230c:	e8 8a fd ff ff       	call   80209b <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	ff 75 14             	pushl  0x14(%ebp)
  802321:	ff 75 10             	pushl  0x10(%ebp)
  802324:	ff 75 0c             	pushl  0xc(%ebp)
  802327:	50                   	push   %eax
  802328:	6a 19                	push   $0x19
  80232a:	e8 6c fd ff ff       	call   80209b <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	50                   	push   %eax
  802343:	6a 1a                	push   $0x1a
  802345:	e8 51 fd ff ff       	call   80209b <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	90                   	nop
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	50                   	push   %eax
  80235f:	6a 1b                	push   $0x1b
  802361:	e8 35 fd ff ff       	call   80209b <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 05                	push   $0x5
  80237a:	e8 1c fd ff ff       	call   80209b <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 06                	push   $0x6
  802393:	e8 03 fd ff ff       	call   80209b <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 07                	push   $0x7
  8023ac:	e8 ea fc ff ff       	call   80209b <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 1c                	push   $0x1c
  8023c5:	e8 d1 fc ff ff       	call   80209b <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	90                   	nop
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023d9:	8d 50 04             	lea    0x4(%eax),%edx
  8023dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	52                   	push   %edx
  8023e6:	50                   	push   %eax
  8023e7:	6a 1d                	push   $0x1d
  8023e9:	e8 ad fc ff ff       	call   80209b <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8023f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023fa:	89 01                	mov    %eax,(%ecx)
  8023fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	c9                   	leave  
  802403:	c2 04 00             	ret    $0x4

00802406 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	ff 75 10             	pushl  0x10(%ebp)
  802410:	ff 75 0c             	pushl  0xc(%ebp)
  802413:	ff 75 08             	pushl  0x8(%ebp)
  802416:	6a 13                	push   $0x13
  802418:	e8 7e fc ff ff       	call   80209b <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
	return ;
  802420:	90                   	nop
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_rcr2>:
uint32 sys_rcr2()
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 1e                	push   $0x1e
  802432:	e8 64 fc ff ff       	call   80209b <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802448:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	50                   	push   %eax
  802455:	6a 1f                	push   $0x1f
  802457:	e8 3f fc ff ff       	call   80209b <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
	return ;
  80245f:	90                   	nop
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <rsttst>:
void rsttst()
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 21                	push   $0x21
  802471:	e8 25 fc ff ff       	call   80209b <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
	return ;
  802479:	90                   	nop
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 04             	sub    $0x4,%esp
  802482:	8b 45 14             	mov    0x14(%ebp),%eax
  802485:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802488:	8b 55 18             	mov    0x18(%ebp),%edx
  80248b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80248f:	52                   	push   %edx
  802490:	50                   	push   %eax
  802491:	ff 75 10             	pushl  0x10(%ebp)
  802494:	ff 75 0c             	pushl  0xc(%ebp)
  802497:	ff 75 08             	pushl  0x8(%ebp)
  80249a:	6a 20                	push   $0x20
  80249c:	e8 fa fb ff ff       	call   80209b <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a4:	90                   	nop
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <chktst>:
void chktst(uint32 n)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	ff 75 08             	pushl  0x8(%ebp)
  8024b5:	6a 22                	push   $0x22
  8024b7:	e8 df fb ff ff       	call   80209b <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8024bf:	90                   	nop
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <inctst>:

void inctst()
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 23                	push   $0x23
  8024d1:	e8 c5 fb ff ff       	call   80209b <syscall>
  8024d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d9:	90                   	nop
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <gettst>:
uint32 gettst()
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 24                	push   $0x24
  8024eb:	e8 ab fb ff ff       	call   80209b <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  802507:	e8 8f fb ff ff       	call   80209b <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
  80250f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802512:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802516:	75 07                	jne    80251f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802518:	b8 01 00 00 00       	mov    $0x1,%eax
  80251d:	eb 05                	jmp    802524 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 25                	push   $0x25
  802538:	e8 5e fb ff ff       	call   80209b <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
  802540:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802543:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802547:	75 07                	jne    802550 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802549:	b8 01 00 00 00       	mov    $0x1,%eax
  80254e:	eb 05                	jmp    802555 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 25                	push   $0x25
  802569:	e8 2d fb ff ff       	call   80209b <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
  802571:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802574:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802578:	75 07                	jne    802581 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	eb 05                	jmp    802586 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 25                	push   $0x25
  80259a:	e8 fc fa ff ff       	call   80209b <syscall>
  80259f:	83 c4 18             	add    $0x18,%esp
  8025a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025a5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025a9:	75 07                	jne    8025b2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b0:	eb 05                	jmp    8025b7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	ff 75 08             	pushl  0x8(%ebp)
  8025c7:	6a 26                	push   $0x26
  8025c9:	e8 cd fa ff ff       	call   80209b <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d1:	90                   	nop
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	6a 00                	push   $0x0
  8025e6:	53                   	push   %ebx
  8025e7:	51                   	push   %ecx
  8025e8:	52                   	push   %edx
  8025e9:	50                   	push   %eax
  8025ea:	6a 27                	push   $0x27
  8025ec:	e8 aa fa ff ff       	call   80209b <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
}
  8025f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	52                   	push   %edx
  802609:	50                   	push   %eax
  80260a:	6a 28                	push   $0x28
  80260c:	e8 8a fa ff ff       	call   80209b <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802619:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80261c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	6a 00                	push   $0x0
  802624:	51                   	push   %ecx
  802625:	ff 75 10             	pushl  0x10(%ebp)
  802628:	52                   	push   %edx
  802629:	50                   	push   %eax
  80262a:	6a 29                	push   $0x29
  80262c:	e8 6a fa ff ff       	call   80209b <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	ff 75 10             	pushl  0x10(%ebp)
  802640:	ff 75 0c             	pushl  0xc(%ebp)
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	6a 12                	push   $0x12
  802648:	e8 4e fa ff ff       	call   80209b <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
	return ;
  802650:	90                   	nop
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802656:	8b 55 0c             	mov    0xc(%ebp),%edx
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	52                   	push   %edx
  802663:	50                   	push   %eax
  802664:	6a 2a                	push   $0x2a
  802666:	e8 30 fa ff ff       	call   80209b <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
	return;
  80266e:	90                   	nop
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	50                   	push   %eax
  802680:	6a 2b                	push   $0x2b
  802682:	e8 14 fa ff ff       	call   80209b <syscall>
  802687:	83 c4 18             	add    $0x18,%esp
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	ff 75 0c             	pushl  0xc(%ebp)
  802698:	ff 75 08             	pushl  0x8(%ebp)
  80269b:	6a 2c                	push   $0x2c
  80269d:	e8 f9 f9 ff ff       	call   80209b <syscall>
  8026a2:	83 c4 18             	add    $0x18,%esp
	return;
  8026a5:	90                   	nop
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	ff 75 0c             	pushl  0xc(%ebp)
  8026b4:	ff 75 08             	pushl  0x8(%ebp)
  8026b7:	6a 2d                	push   $0x2d
  8026b9:	e8 dd f9 ff ff       	call   80209b <syscall>
  8026be:	83 c4 18             	add    $0x18,%esp
	return;
  8026c1:	90                   	nop
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	83 e8 04             	sub    $0x4,%eax
  8026d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8026d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	83 e8 04             	sub    $0x4,%eax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8026ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	83 e0 01             	and    $0x1,%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 94 c0             	sete   %al
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270b:	83 f8 02             	cmp    $0x2,%eax
  80270e:	74 2b                	je     80273b <alloc_block+0x40>
  802710:	83 f8 02             	cmp    $0x2,%eax
  802713:	7f 07                	jg     80271c <alloc_block+0x21>
  802715:	83 f8 01             	cmp    $0x1,%eax
  802718:	74 0e                	je     802728 <alloc_block+0x2d>
  80271a:	eb 58                	jmp    802774 <alloc_block+0x79>
  80271c:	83 f8 03             	cmp    $0x3,%eax
  80271f:	74 2d                	je     80274e <alloc_block+0x53>
  802721:	83 f8 04             	cmp    $0x4,%eax
  802724:	74 3b                	je     802761 <alloc_block+0x66>
  802726:	eb 4c                	jmp    802774 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802728:	83 ec 0c             	sub    $0xc,%esp
  80272b:	ff 75 08             	pushl  0x8(%ebp)
  80272e:	e8 11 03 00 00       	call   802a44 <alloc_block_FF>
  802733:	83 c4 10             	add    $0x10,%esp
  802736:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802739:	eb 4a                	jmp    802785 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80273b:	83 ec 0c             	sub    $0xc,%esp
  80273e:	ff 75 08             	pushl  0x8(%ebp)
  802741:	e8 fa 19 00 00       	call   804140 <alloc_block_NF>
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80274c:	eb 37                	jmp    802785 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	ff 75 08             	pushl  0x8(%ebp)
  802754:	e8 a7 07 00 00       	call   802f00 <alloc_block_BF>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80275f:	eb 24                	jmp    802785 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802761:	83 ec 0c             	sub    $0xc,%esp
  802764:	ff 75 08             	pushl  0x8(%ebp)
  802767:	e8 b7 19 00 00       	call   804123 <alloc_block_WF>
  80276c:	83 c4 10             	add    $0x10,%esp
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802772:	eb 11                	jmp    802785 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802774:	83 ec 0c             	sub    $0xc,%esp
  802777:	68 c4 4c 80 00       	push   $0x804cc4
  80277c:	e8 a0 e4 ff ff       	call   800c21 <cprintf>
  802781:	83 c4 10             	add    $0x10,%esp
		break;
  802784:	90                   	nop
	}
	return va;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	53                   	push   %ebx
  80278e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	68 e4 4c 80 00       	push   $0x804ce4
  802799:	e8 83 e4 ff ff       	call   800c21 <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027a1:	83 ec 0c             	sub    $0xc,%esp
  8027a4:	68 0f 4d 80 00       	push   $0x804d0f
  8027a9:	e8 73 e4 ff ff       	call   800c21 <cprintf>
  8027ae:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b7:	eb 37                	jmp    8027f0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8027bf:	e8 19 ff ff ff       	call   8026dd <is_free_block>
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	0f be d8             	movsbl %al,%ebx
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d0:	e8 ef fe ff ff       	call   8026c4 <get_block_size>
  8027d5:	83 c4 10             	add    $0x10,%esp
  8027d8:	83 ec 04             	sub    $0x4,%esp
  8027db:	53                   	push   %ebx
  8027dc:	50                   	push   %eax
  8027dd:	68 27 4d 80 00       	push   $0x804d27
  8027e2:	e8 3a e4 ff ff       	call   800c21 <cprintf>
  8027e7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8027ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f4:	74 07                	je     8027fd <print_blocks_list+0x73>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	eb 05                	jmp    802802 <print_blocks_list+0x78>
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	89 45 10             	mov    %eax,0x10(%ebp)
  802805:	8b 45 10             	mov    0x10(%ebp),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	75 ad                	jne    8027b9 <print_blocks_list+0x2f>
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	75 a7                	jne    8027b9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802812:	83 ec 0c             	sub    $0xc,%esp
  802815:	68 e4 4c 80 00       	push   $0x804ce4
  80281a:	e8 02 e4 ff ff       	call   800c21 <cprintf>
  80281f:	83 c4 10             	add    $0x10,%esp

}
  802822:	90                   	nop
  802823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80282e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802831:	83 e0 01             	and    $0x1,%eax
  802834:	85 c0                	test   %eax,%eax
  802836:	74 03                	je     80283b <initialize_dynamic_allocator+0x13>
  802838:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80283b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80283f:	0f 84 c7 01 00 00    	je     802a0c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802845:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80284c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80284f:	8b 55 08             	mov    0x8(%ebp),%edx
  802852:	8b 45 0c             	mov    0xc(%ebp),%eax
  802855:	01 d0                	add    %edx,%eax
  802857:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80285c:	0f 87 ad 01 00 00    	ja     802a0f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	0f 89 a5 01 00 00    	jns    802a12 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80286d:	8b 55 08             	mov    0x8(%ebp),%edx
  802870:	8b 45 0c             	mov    0xc(%ebp),%eax
  802873:	01 d0                	add    %edx,%eax
  802875:	83 e8 04             	sub    $0x4,%eax
  802878:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80287d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802884:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	e9 87 00 00 00       	jmp    802918 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802895:	75 14                	jne    8028ab <initialize_dynamic_allocator+0x83>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 3f 4d 80 00       	push   $0x804d3f
  80289f:	6a 79                	push   $0x79
  8028a1:	68 5d 4d 80 00       	push   $0x804d5d
  8028a6:	e8 b2 18 00 00       	call   80415d <_panic>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 10                	je     8028c4 <initialize_dynamic_allocator+0x9c>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	8b 52 04             	mov    0x4(%edx),%edx
  8028bf:	89 50 04             	mov    %edx,0x4(%eax)
  8028c2:	eb 0b                	jmp    8028cf <initialize_dynamic_allocator+0xa7>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 0f                	je     8028e8 <initialize_dynamic_allocator+0xc0>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e2:	8b 12                	mov    (%edx),%edx
  8028e4:	89 10                	mov    %edx,(%eax)
  8028e6:	eb 0a                	jmp    8028f2 <initialize_dynamic_allocator+0xca>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802905:	a1 38 50 80 00       	mov    0x805038,%eax
  80290a:	48                   	dec    %eax
  80290b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802910:	a1 34 50 80 00       	mov    0x805034,%eax
  802915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802918:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291c:	74 07                	je     802925 <initialize_dynamic_allocator+0xfd>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	eb 05                	jmp    80292a <initialize_dynamic_allocator+0x102>
  802925:	b8 00 00 00 00       	mov    $0x0,%eax
  80292a:	a3 34 50 80 00       	mov    %eax,0x805034
  80292f:	a1 34 50 80 00       	mov    0x805034,%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	0f 85 55 ff ff ff    	jne    802891 <initialize_dynamic_allocator+0x69>
  80293c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802940:	0f 85 4b ff ff ff    	jne    802891 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80294c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802955:	a1 44 50 80 00       	mov    0x805044,%eax
  80295a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80295f:	a1 40 50 80 00       	mov    0x805040,%eax
  802964:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	83 c0 08             	add    $0x8,%eax
  802970:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	83 c0 04             	add    $0x4,%eax
  802979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297c:	83 ea 08             	sub    $0x8,%edx
  80297f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802981:	8b 55 0c             	mov    0xc(%ebp),%edx
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	83 e8 08             	sub    $0x8,%eax
  80298c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298f:	83 ea 08             	sub    $0x8,%edx
  802992:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80299d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8029a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ab:	75 17                	jne    8029c4 <initialize_dynamic_allocator+0x19c>
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	68 78 4d 80 00       	push   $0x804d78
  8029b5:	68 90 00 00 00       	push   $0x90
  8029ba:	68 5d 4d 80 00       	push   $0x804d5d
  8029bf:	e8 99 17 00 00       	call   80415d <_panic>
  8029c4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	89 10                	mov    %edx,(%eax)
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	74 0d                	je     8029e5 <initialize_dynamic_allocator+0x1bd>
  8029d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e0:	89 50 04             	mov    %edx,0x4(%eax)
  8029e3:	eb 08                	jmp    8029ed <initialize_dynamic_allocator+0x1c5>
  8029e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802a04:	40                   	inc    %eax
  802a05:	a3 38 50 80 00       	mov    %eax,0x805038
  802a0a:	eb 07                	jmp    802a13 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a0c:	90                   	nop
  802a0d:	eb 04                	jmp    802a13 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a0f:	90                   	nop
  802a10:	eb 01                	jmp    802a13 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a12:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a18:	8b 45 10             	mov    0x10(%ebp),%eax
  802a1b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a27:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	83 e8 04             	sub    $0x4,%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	83 e0 fe             	and    $0xfffffffe,%eax
  802a34:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	01 c2                	add    %eax,%edx
  802a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3f:	89 02                	mov    %eax,(%edx)
}
  802a41:	90                   	nop
  802a42:	5d                   	pop    %ebp
  802a43:	c3                   	ret    

00802a44 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a44:	55                   	push   %ebp
  802a45:	89 e5                	mov    %esp,%ebp
  802a47:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	83 e0 01             	and    $0x1,%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 03                	je     802a57 <alloc_block_FF+0x13>
  802a54:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a57:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a5b:	77 07                	ja     802a64 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a5d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a64:	a1 24 50 80 00       	mov    0x805024,%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	75 73                	jne    802ae0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	83 c0 10             	add    $0x10,%eax
  802a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a76:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a83:	01 d0                	add    %edx,%eax
  802a85:	48                   	dec    %eax
  802a86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a91:	f7 75 ec             	divl   -0x14(%ebp)
  802a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a97:	29 d0                	sub    %edx,%eax
  802a99:	c1 e8 0c             	shr    $0xc,%eax
  802a9c:	83 ec 0c             	sub    $0xc,%esp
  802a9f:	50                   	push   %eax
  802aa0:	e8 1e f1 ff ff       	call   801bc3 <sbrk>
  802aa5:	83 c4 10             	add    $0x10,%esp
  802aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802aab:	83 ec 0c             	sub    $0xc,%esp
  802aae:	6a 00                	push   $0x0
  802ab0:	e8 0e f1 ff ff       	call   801bc3 <sbrk>
  802ab5:	83 c4 10             	add    $0x10,%esp
  802ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abe:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ac1:	83 ec 08             	sub    $0x8,%esp
  802ac4:	50                   	push   %eax
  802ac5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ac8:	e8 5b fd ff ff       	call   802828 <initialize_dynamic_allocator>
  802acd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ad0:	83 ec 0c             	sub    $0xc,%esp
  802ad3:	68 9b 4d 80 00       	push   $0x804d9b
  802ad8:	e8 44 e1 ff ff       	call   800c21 <cprintf>
  802add:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802ae0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae4:	75 0a                	jne    802af0 <alloc_block_FF+0xac>
	        return NULL;
  802ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aeb:	e9 0e 04 00 00       	jmp    802efe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802af0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802af7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aff:	e9 f3 02 00 00       	jmp    802df7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b0a:	83 ec 0c             	sub    $0xc,%esp
  802b0d:	ff 75 bc             	pushl  -0x44(%ebp)
  802b10:	e8 af fb ff ff       	call   8026c4 <get_block_size>
  802b15:	83 c4 10             	add    $0x10,%esp
  802b18:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	83 c0 08             	add    $0x8,%eax
  802b21:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b24:	0f 87 c5 02 00 00    	ja     802def <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	83 c0 18             	add    $0x18,%eax
  802b30:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b33:	0f 87 19 02 00 00    	ja     802d52 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b39:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b3c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b3f:	83 e8 08             	sub    $0x8,%eax
  802b42:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	8d 50 08             	lea    0x8(%eax),%edx
  802b4b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	83 c0 08             	add    $0x8,%eax
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	6a 01                	push   $0x1
  802b5e:	50                   	push   %eax
  802b5f:	ff 75 bc             	pushl  -0x44(%ebp)
  802b62:	e8 ae fe ff ff       	call   802a15 <set_block_data>
  802b67:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	75 68                	jne    802bdc <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b74:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b78:	75 17                	jne    802b91 <alloc_block_FF+0x14d>
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	68 78 4d 80 00       	push   $0x804d78
  802b82:	68 d7 00 00 00       	push   $0xd7
  802b87:	68 5d 4d 80 00       	push   $0x804d5d
  802b8c:	e8 cc 15 00 00       	call   80415d <_panic>
  802b91:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b97:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9a:	89 10                	mov    %edx,(%eax)
  802b9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 0d                	je     802bb2 <alloc_block_FF+0x16e>
  802ba5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802baa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	eb 08                	jmp    802bba <alloc_block_FF+0x176>
  802bb2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bbd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcc:	a1 38 50 80 00       	mov    0x805038,%eax
  802bd1:	40                   	inc    %eax
  802bd2:	a3 38 50 80 00       	mov    %eax,0x805038
  802bd7:	e9 dc 00 00 00       	jmp    802cb8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	75 65                	jne    802c4a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802be5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802be9:	75 17                	jne    802c02 <alloc_block_FF+0x1be>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 ac 4d 80 00       	push   $0x804dac
  802bf3:	68 db 00 00 00       	push   $0xdb
  802bf8:	68 5d 4d 80 00       	push   $0x804d5d
  802bfd:	e8 5b 15 00 00       	call   80415d <_panic>
  802c02:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c08:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0b:	89 50 04             	mov    %edx,0x4(%eax)
  802c0e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	74 0c                	je     802c24 <alloc_block_FF+0x1e0>
  802c18:	a1 30 50 80 00       	mov    0x805030,%eax
  802c1d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	eb 08                	jmp    802c2c <alloc_block_FF+0x1e8>
  802c24:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c27:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c2c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c34:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c42:	40                   	inc    %eax
  802c43:	a3 38 50 80 00       	mov    %eax,0x805038
  802c48:	eb 6e                	jmp    802cb8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4e:	74 06                	je     802c56 <alloc_block_FF+0x212>
  802c50:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c54:	75 17                	jne    802c6d <alloc_block_FF+0x229>
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	68 d0 4d 80 00       	push   $0x804dd0
  802c5e:	68 df 00 00 00       	push   $0xdf
  802c63:	68 5d 4d 80 00       	push   $0x804d5d
  802c68:	e8 f0 14 00 00       	call   80415d <_panic>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 10                	mov    (%eax),%edx
  802c72:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c75:	89 10                	mov    %edx,(%eax)
  802c77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0b                	je     802c8b <alloc_block_FF+0x247>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c91:	89 10                	mov    %edx,(%eax)
  802c93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%eax)
  802c9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	75 08                	jne    802cad <alloc_block_FF+0x269>
  802ca5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca8:	a3 30 50 80 00       	mov    %eax,0x805030
  802cad:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb2:	40                   	inc    %eax
  802cb3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbc:	75 17                	jne    802cd5 <alloc_block_FF+0x291>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 3f 4d 80 00       	push   $0x804d3f
  802cc6:	68 e1 00 00 00       	push   $0xe1
  802ccb:	68 5d 4d 80 00       	push   $0x804d5d
  802cd0:	e8 88 14 00 00       	call   80415d <_panic>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 10                	je     802cee <alloc_block_FF+0x2aa>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce6:	8b 52 04             	mov    0x4(%edx),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 0b                	jmp    802cf9 <alloc_block_FF+0x2b5>
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	a3 30 50 80 00       	mov    %eax,0x805030
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0f                	je     802d12 <alloc_block_FF+0x2ce>
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 0a                	jmp    802d1c <alloc_block_FF+0x2d8>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d34:	48                   	dec    %eax
  802d35:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802d3a:	83 ec 04             	sub    $0x4,%esp
  802d3d:	6a 00                	push   $0x0
  802d3f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d42:	ff 75 b0             	pushl  -0x50(%ebp)
  802d45:	e8 cb fc ff ff       	call   802a15 <set_block_data>
  802d4a:	83 c4 10             	add    $0x10,%esp
  802d4d:	e9 95 00 00 00       	jmp    802de7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	6a 01                	push   $0x1
  802d57:	ff 75 b8             	pushl  -0x48(%ebp)
  802d5a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d5d:	e8 b3 fc ff ff       	call   802a15 <set_block_data>
  802d62:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d69:	75 17                	jne    802d82 <alloc_block_FF+0x33e>
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	68 3f 4d 80 00       	push   $0x804d3f
  802d73:	68 e8 00 00 00       	push   $0xe8
  802d78:	68 5d 4d 80 00       	push   $0x804d5d
  802d7d:	e8 db 13 00 00       	call   80415d <_panic>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	74 10                	je     802d9b <alloc_block_FF+0x357>
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d93:	8b 52 04             	mov    0x4(%edx),%edx
  802d96:	89 50 04             	mov    %edx,0x4(%eax)
  802d99:	eb 0b                	jmp    802da6 <alloc_block_FF+0x362>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	a3 30 50 80 00       	mov    %eax,0x805030
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	74 0f                	je     802dbf <alloc_block_FF+0x37b>
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db9:	8b 12                	mov    (%edx),%edx
  802dbb:	89 10                	mov    %edx,(%eax)
  802dbd:	eb 0a                	jmp    802dc9 <alloc_block_FF+0x385>
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddc:	a1 38 50 80 00       	mov    0x805038,%eax
  802de1:	48                   	dec    %eax
  802de2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802de7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dea:	e9 0f 01 00 00       	jmp    802efe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802def:	a1 34 50 80 00       	mov    0x805034,%eax
  802df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	74 07                	je     802e04 <alloc_block_FF+0x3c0>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	eb 05                	jmp    802e09 <alloc_block_FF+0x3c5>
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	a3 34 50 80 00       	mov    %eax,0x805034
  802e0e:	a1 34 50 80 00       	mov    0x805034,%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	0f 85 e9 fc ff ff    	jne    802b04 <alloc_block_FF+0xc0>
  802e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1f:	0f 85 df fc ff ff    	jne    802b04 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	83 c0 08             	add    $0x8,%eax
  802e2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e2e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e35:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e3b:	01 d0                	add    %edx,%eax
  802e3d:	48                   	dec    %eax
  802e3e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e44:	ba 00 00 00 00       	mov    $0x0,%edx
  802e49:	f7 75 d8             	divl   -0x28(%ebp)
  802e4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e4f:	29 d0                	sub    %edx,%eax
  802e51:	c1 e8 0c             	shr    $0xc,%eax
  802e54:	83 ec 0c             	sub    $0xc,%esp
  802e57:	50                   	push   %eax
  802e58:	e8 66 ed ff ff       	call   801bc3 <sbrk>
  802e5d:	83 c4 10             	add    $0x10,%esp
  802e60:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e63:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e67:	75 0a                	jne    802e73 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e69:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6e:	e9 8b 00 00 00       	jmp    802efe <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e73:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e80:	01 d0                	add    %edx,%eax
  802e82:	48                   	dec    %eax
  802e83:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e86:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e89:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8e:	f7 75 cc             	divl   -0x34(%ebp)
  802e91:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e94:	29 d0                	sub    %edx,%eax
  802e96:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e9c:	01 d0                	add    %edx,%eax
  802e9e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802ea3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ea8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802eae:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802eb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eb8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ebb:	01 d0                	add    %edx,%eax
  802ebd:	48                   	dec    %eax
  802ebe:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ec1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ec4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec9:	f7 75 c4             	divl   -0x3c(%ebp)
  802ecc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ecf:	29 d0                	sub    %edx,%eax
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	6a 01                	push   $0x1
  802ed6:	50                   	push   %eax
  802ed7:	ff 75 d0             	pushl  -0x30(%ebp)
  802eda:	e8 36 fb ff ff       	call   802a15 <set_block_data>
  802edf:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ee2:	83 ec 0c             	sub    $0xc,%esp
  802ee5:	ff 75 d0             	pushl  -0x30(%ebp)
  802ee8:	e8 1b 0a 00 00       	call   803908 <free_block>
  802eed:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ef0:	83 ec 0c             	sub    $0xc,%esp
  802ef3:	ff 75 08             	pushl  0x8(%ebp)
  802ef6:	e8 49 fb ff ff       	call   802a44 <alloc_block_FF>
  802efb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802efe:	c9                   	leave  
  802eff:	c3                   	ret    

00802f00 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
  802f03:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	83 e0 01             	and    $0x1,%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 03                	je     802f13 <alloc_block_BF+0x13>
  802f10:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f13:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f17:	77 07                	ja     802f20 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f19:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f20:	a1 24 50 80 00       	mov    0x805024,%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	75 73                	jne    802f9c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	83 c0 10             	add    $0x10,%eax
  802f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f32:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	48                   	dec    %eax
  802f42:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f48:	ba 00 00 00 00       	mov    $0x0,%edx
  802f4d:	f7 75 e0             	divl   -0x20(%ebp)
  802f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f53:	29 d0                	sub    %edx,%eax
  802f55:	c1 e8 0c             	shr    $0xc,%eax
  802f58:	83 ec 0c             	sub    $0xc,%esp
  802f5b:	50                   	push   %eax
  802f5c:	e8 62 ec ff ff       	call   801bc3 <sbrk>
  802f61:	83 c4 10             	add    $0x10,%esp
  802f64:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f67:	83 ec 0c             	sub    $0xc,%esp
  802f6a:	6a 00                	push   $0x0
  802f6c:	e8 52 ec ff ff       	call   801bc3 <sbrk>
  802f71:	83 c4 10             	add    $0x10,%esp
  802f74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f7a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f7d:	83 ec 08             	sub    $0x8,%esp
  802f80:	50                   	push   %eax
  802f81:	ff 75 d8             	pushl  -0x28(%ebp)
  802f84:	e8 9f f8 ff ff       	call   802828 <initialize_dynamic_allocator>
  802f89:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f8c:	83 ec 0c             	sub    $0xc,%esp
  802f8f:	68 9b 4d 80 00       	push   $0x804d9b
  802f94:	e8 88 dc ff ff       	call   800c21 <cprintf>
  802f99:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802fa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802faa:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802fb1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802fb8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc0:	e9 1d 01 00 00       	jmp    8030e2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	ff 75 a8             	pushl  -0x58(%ebp)
  802fd1:	e8 ee f6 ff ff       	call   8026c4 <get_block_size>
  802fd6:	83 c4 10             	add    $0x10,%esp
  802fd9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	83 c0 08             	add    $0x8,%eax
  802fe2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fe5:	0f 87 ef 00 00 00    	ja     8030da <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	83 c0 18             	add    $0x18,%eax
  802ff1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ff4:	77 1d                	ja     803013 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ffc:	0f 86 d8 00 00 00    	jbe    8030da <alloc_block_BF+0x1da>
				{
					best_va = va;
  803002:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803005:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803008:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80300b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80300e:	e9 c7 00 00 00       	jmp    8030da <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	83 c0 08             	add    $0x8,%eax
  803019:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80301c:	0f 85 9d 00 00 00    	jne    8030bf <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	6a 01                	push   $0x1
  803027:	ff 75 a4             	pushl  -0x5c(%ebp)
  80302a:	ff 75 a8             	pushl  -0x58(%ebp)
  80302d:	e8 e3 f9 ff ff       	call   802a15 <set_block_data>
  803032:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803035:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803039:	75 17                	jne    803052 <alloc_block_BF+0x152>
  80303b:	83 ec 04             	sub    $0x4,%esp
  80303e:	68 3f 4d 80 00       	push   $0x804d3f
  803043:	68 2c 01 00 00       	push   $0x12c
  803048:	68 5d 4d 80 00       	push   $0x804d5d
  80304d:	e8 0b 11 00 00       	call   80415d <_panic>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 10                	je     80306b <alloc_block_BF+0x16b>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803063:	8b 52 04             	mov    0x4(%edx),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	eb 0b                	jmp    803076 <alloc_block_BF+0x176>
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	a3 30 50 80 00       	mov    %eax,0x805030
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 0f                	je     80308f <alloc_block_BF+0x18f>
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 04             	mov    0x4(%eax),%eax
  803086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803089:	8b 12                	mov    (%edx),%edx
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	eb 0a                	jmp    803099 <alloc_block_BF+0x199>
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b1:	48                   	dec    %eax
  8030b2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8030b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030ba:	e9 24 04 00 00       	jmp    8034e3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8030bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030c5:	76 13                	jbe    8030da <alloc_block_BF+0x1da>
					{
						internal = 1;
  8030c7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8030ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8030d4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8030d7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8030da:	a1 34 50 80 00       	mov    0x805034,%eax
  8030df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e6:	74 07                	je     8030ef <alloc_block_BF+0x1ef>
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	eb 05                	jmp    8030f4 <alloc_block_BF+0x1f4>
  8030ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8030fe:	85 c0                	test   %eax,%eax
  803100:	0f 85 bf fe ff ff    	jne    802fc5 <alloc_block_BF+0xc5>
  803106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310a:	0f 85 b5 fe ff ff    	jne    802fc5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803110:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803114:	0f 84 26 02 00 00    	je     803340 <alloc_block_BF+0x440>
  80311a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311e:	0f 85 1c 02 00 00    	jne    803340 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803127:	2b 45 08             	sub    0x8(%ebp),%eax
  80312a:	83 e8 08             	sub    $0x8,%eax
  80312d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8d 50 08             	lea    0x8(%eax),%edx
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	01 d0                	add    %edx,%eax
  80313b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	83 c0 08             	add    $0x8,%eax
  803144:	83 ec 04             	sub    $0x4,%esp
  803147:	6a 01                	push   $0x1
  803149:	50                   	push   %eax
  80314a:	ff 75 f0             	pushl  -0x10(%ebp)
  80314d:	e8 c3 f8 ff ff       	call   802a15 <set_block_data>
  803152:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	75 68                	jne    8031c7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80315f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803163:	75 17                	jne    80317c <alloc_block_BF+0x27c>
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	68 78 4d 80 00       	push   $0x804d78
  80316d:	68 45 01 00 00       	push   $0x145
  803172:	68 5d 4d 80 00       	push   $0x804d5d
  803177:	e8 e1 0f 00 00       	call   80415d <_panic>
  80317c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803182:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803185:	89 10                	mov    %edx,(%eax)
  803187:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	74 0d                	je     80319d <alloc_block_BF+0x29d>
  803190:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803195:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	eb 08                	jmp    8031a5 <alloc_block_BF+0x2a5>
  80319d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031bc:	40                   	inc    %eax
  8031bd:	a3 38 50 80 00       	mov    %eax,0x805038
  8031c2:	e9 dc 00 00 00       	jmp    8032a3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	75 65                	jne    803235 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031d4:	75 17                	jne    8031ed <alloc_block_BF+0x2ed>
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	68 ac 4d 80 00       	push   $0x804dac
  8031de:	68 4a 01 00 00       	push   $0x14a
  8031e3:	68 5d 4d 80 00       	push   $0x804d5d
  8031e8:	e8 70 0f 00 00       	call   80415d <_panic>
  8031ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0c                	je     80320f <alloc_block_BF+0x30f>
  803203:	a1 30 50 80 00       	mov    0x805030,%eax
  803208:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80320b:	89 10                	mov    %edx,(%eax)
  80320d:	eb 08                	jmp    803217 <alloc_block_BF+0x317>
  80320f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803212:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803217:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321a:	a3 30 50 80 00       	mov    %eax,0x805030
  80321f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803228:	a1 38 50 80 00       	mov    0x805038,%eax
  80322d:	40                   	inc    %eax
  80322e:	a3 38 50 80 00       	mov    %eax,0x805038
  803233:	eb 6e                	jmp    8032a3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803239:	74 06                	je     803241 <alloc_block_BF+0x341>
  80323b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80323f:	75 17                	jne    803258 <alloc_block_BF+0x358>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 d0 4d 80 00       	push   $0x804dd0
  803249:	68 4f 01 00 00       	push   $0x14f
  80324e:	68 5d 4d 80 00       	push   $0x804d5d
  803253:	e8 05 0f 00 00       	call   80415d <_panic>
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	8b 10                	mov    (%eax),%edx
  80325d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803260:	89 10                	mov    %edx,(%eax)
  803262:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	85 c0                	test   %eax,%eax
  803269:	74 0b                	je     803276 <alloc_block_BF+0x376>
  80326b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803279:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803281:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	75 08                	jne    803298 <alloc_block_BF+0x398>
  803290:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803293:	a3 30 50 80 00       	mov    %eax,0x805030
  803298:	a1 38 50 80 00       	mov    0x805038,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a7:	75 17                	jne    8032c0 <alloc_block_BF+0x3c0>
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	68 3f 4d 80 00       	push   $0x804d3f
  8032b1:	68 51 01 00 00       	push   $0x151
  8032b6:	68 5d 4d 80 00       	push   $0x804d5d
  8032bb:	e8 9d 0e 00 00       	call   80415d <_panic>
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	74 10                	je     8032d9 <alloc_block_BF+0x3d9>
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d1:	8b 52 04             	mov    0x4(%edx),%edx
  8032d4:	89 50 04             	mov    %edx,0x4(%eax)
  8032d7:	eb 0b                	jmp    8032e4 <alloc_block_BF+0x3e4>
  8032d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dc:	8b 40 04             	mov    0x4(%eax),%eax
  8032df:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	74 0f                	je     8032fd <alloc_block_BF+0x3fd>
  8032ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f1:	8b 40 04             	mov    0x4(%eax),%eax
  8032f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f7:	8b 12                	mov    (%edx),%edx
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	eb 0a                	jmp    803307 <alloc_block_BF+0x407>
  8032fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331a:	a1 38 50 80 00       	mov    0x805038,%eax
  80331f:	48                   	dec    %eax
  803320:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	6a 00                	push   $0x0
  80332a:	ff 75 d0             	pushl  -0x30(%ebp)
  80332d:	ff 75 cc             	pushl  -0x34(%ebp)
  803330:	e8 e0 f6 ff ff       	call   802a15 <set_block_data>
  803335:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333b:	e9 a3 01 00 00       	jmp    8034e3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803340:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803344:	0f 85 9d 00 00 00    	jne    8033e7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	6a 01                	push   $0x1
  80334f:	ff 75 ec             	pushl  -0x14(%ebp)
  803352:	ff 75 f0             	pushl  -0x10(%ebp)
  803355:	e8 bb f6 ff ff       	call   802a15 <set_block_data>
  80335a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80335d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803361:	75 17                	jne    80337a <alloc_block_BF+0x47a>
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	68 3f 4d 80 00       	push   $0x804d3f
  80336b:	68 58 01 00 00       	push   $0x158
  803370:	68 5d 4d 80 00       	push   $0x804d5d
  803375:	e8 e3 0d 00 00       	call   80415d <_panic>
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 10                	je     803393 <alloc_block_BF+0x493>
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338b:	8b 52 04             	mov    0x4(%edx),%edx
  80338e:	89 50 04             	mov    %edx,0x4(%eax)
  803391:	eb 0b                	jmp    80339e <alloc_block_BF+0x49e>
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	8b 40 04             	mov    0x4(%eax),%eax
  803399:	a3 30 50 80 00       	mov    %eax,0x805030
  80339e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a1:	8b 40 04             	mov    0x4(%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 0f                	je     8033b7 <alloc_block_BF+0x4b7>
  8033a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ab:	8b 40 04             	mov    0x4(%eax),%eax
  8033ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b1:	8b 12                	mov    (%edx),%edx
  8033b3:	89 10                	mov    %edx,(%eax)
  8033b5:	eb 0a                	jmp    8033c1 <alloc_block_BF+0x4c1>
  8033b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d9:	48                   	dec    %eax
  8033da:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e2:	e9 fc 00 00 00       	jmp    8034e3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	83 c0 08             	add    $0x8,%eax
  8033ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033f0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033f7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033fd:	01 d0                	add    %edx,%eax
  8033ff:	48                   	dec    %eax
  803400:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803403:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803406:	ba 00 00 00 00       	mov    $0x0,%edx
  80340b:	f7 75 c4             	divl   -0x3c(%ebp)
  80340e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803411:	29 d0                	sub    %edx,%eax
  803413:	c1 e8 0c             	shr    $0xc,%eax
  803416:	83 ec 0c             	sub    $0xc,%esp
  803419:	50                   	push   %eax
  80341a:	e8 a4 e7 ff ff       	call   801bc3 <sbrk>
  80341f:	83 c4 10             	add    $0x10,%esp
  803422:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803425:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803429:	75 0a                	jne    803435 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80342b:	b8 00 00 00 00       	mov    $0x0,%eax
  803430:	e9 ae 00 00 00       	jmp    8034e3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803435:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80343c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80343f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803442:	01 d0                	add    %edx,%eax
  803444:	48                   	dec    %eax
  803445:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803448:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80344b:	ba 00 00 00 00       	mov    $0x0,%edx
  803450:	f7 75 b8             	divl   -0x48(%ebp)
  803453:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803456:	29 d0                	sub    %edx,%eax
  803458:	8d 50 fc             	lea    -0x4(%eax),%edx
  80345b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80345e:	01 d0                	add    %edx,%eax
  803460:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803465:	a1 40 50 80 00       	mov    0x805040,%eax
  80346a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	68 04 4e 80 00       	push   $0x804e04
  803478:	e8 a4 d7 ff ff       	call   800c21 <cprintf>
  80347d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803480:	83 ec 08             	sub    $0x8,%esp
  803483:	ff 75 bc             	pushl  -0x44(%ebp)
  803486:	68 09 4e 80 00       	push   $0x804e09
  80348b:	e8 91 d7 ff ff       	call   800c21 <cprintf>
  803490:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803493:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80349a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80349d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034a0:	01 d0                	add    %edx,%eax
  8034a2:	48                   	dec    %eax
  8034a3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034a6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8034ae:	f7 75 b0             	divl   -0x50(%ebp)
  8034b1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034b4:	29 d0                	sub    %edx,%eax
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	6a 01                	push   $0x1
  8034bb:	50                   	push   %eax
  8034bc:	ff 75 bc             	pushl  -0x44(%ebp)
  8034bf:	e8 51 f5 ff ff       	call   802a15 <set_block_data>
  8034c4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8034c7:	83 ec 0c             	sub    $0xc,%esp
  8034ca:	ff 75 bc             	pushl  -0x44(%ebp)
  8034cd:	e8 36 04 00 00       	call   803908 <free_block>
  8034d2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8034d5:	83 ec 0c             	sub    $0xc,%esp
  8034d8:	ff 75 08             	pushl  0x8(%ebp)
  8034db:	e8 20 fa ff ff       	call   802f00 <alloc_block_BF>
  8034e0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8034e3:	c9                   	leave  
  8034e4:	c3                   	ret    

008034e5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8034e5:	55                   	push   %ebp
  8034e6:	89 e5                	mov    %esp,%ebp
  8034e8:	53                   	push   %ebx
  8034e9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8034ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8034fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fe:	74 1e                	je     80351e <merging+0x39>
  803500:	ff 75 08             	pushl  0x8(%ebp)
  803503:	e8 bc f1 ff ff       	call   8026c4 <get_block_size>
  803508:	83 c4 04             	add    $0x4,%esp
  80350b:	89 c2                	mov    %eax,%edx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	01 d0                	add    %edx,%eax
  803512:	3b 45 10             	cmp    0x10(%ebp),%eax
  803515:	75 07                	jne    80351e <merging+0x39>
		prev_is_free = 1;
  803517:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80351e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803522:	74 1e                	je     803542 <merging+0x5d>
  803524:	ff 75 10             	pushl  0x10(%ebp)
  803527:	e8 98 f1 ff ff       	call   8026c4 <get_block_size>
  80352c:	83 c4 04             	add    $0x4,%esp
  80352f:	89 c2                	mov    %eax,%edx
  803531:	8b 45 10             	mov    0x10(%ebp),%eax
  803534:	01 d0                	add    %edx,%eax
  803536:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803539:	75 07                	jne    803542 <merging+0x5d>
		next_is_free = 1;
  80353b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803546:	0f 84 cc 00 00 00    	je     803618 <merging+0x133>
  80354c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803550:	0f 84 c2 00 00 00    	je     803618 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803556:	ff 75 08             	pushl  0x8(%ebp)
  803559:	e8 66 f1 ff ff       	call   8026c4 <get_block_size>
  80355e:	83 c4 04             	add    $0x4,%esp
  803561:	89 c3                	mov    %eax,%ebx
  803563:	ff 75 10             	pushl  0x10(%ebp)
  803566:	e8 59 f1 ff ff       	call   8026c4 <get_block_size>
  80356b:	83 c4 04             	add    $0x4,%esp
  80356e:	01 c3                	add    %eax,%ebx
  803570:	ff 75 0c             	pushl  0xc(%ebp)
  803573:	e8 4c f1 ff ff       	call   8026c4 <get_block_size>
  803578:	83 c4 04             	add    $0x4,%esp
  80357b:	01 d8                	add    %ebx,%eax
  80357d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803580:	6a 00                	push   $0x0
  803582:	ff 75 ec             	pushl  -0x14(%ebp)
  803585:	ff 75 08             	pushl  0x8(%ebp)
  803588:	e8 88 f4 ff ff       	call   802a15 <set_block_data>
  80358d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803590:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803594:	75 17                	jne    8035ad <merging+0xc8>
  803596:	83 ec 04             	sub    $0x4,%esp
  803599:	68 3f 4d 80 00       	push   $0x804d3f
  80359e:	68 7d 01 00 00       	push   $0x17d
  8035a3:	68 5d 4d 80 00       	push   $0x804d5d
  8035a8:	e8 b0 0b 00 00       	call   80415d <_panic>
  8035ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b0:	8b 00                	mov    (%eax),%eax
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	74 10                	je     8035c6 <merging+0xe1>
  8035b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b9:	8b 00                	mov    (%eax),%eax
  8035bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035be:	8b 52 04             	mov    0x4(%edx),%edx
  8035c1:	89 50 04             	mov    %edx,0x4(%eax)
  8035c4:	eb 0b                	jmp    8035d1 <merging+0xec>
  8035c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c9:	8b 40 04             	mov    0x4(%eax),%eax
  8035cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d4:	8b 40 04             	mov    0x4(%eax),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	74 0f                	je     8035ea <merging+0x105>
  8035db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035de:	8b 40 04             	mov    0x4(%eax),%eax
  8035e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e4:	8b 12                	mov    (%edx),%edx
  8035e6:	89 10                	mov    %edx,(%eax)
  8035e8:	eb 0a                	jmp    8035f4 <merging+0x10f>
  8035ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803607:	a1 38 50 80 00       	mov    0x805038,%eax
  80360c:	48                   	dec    %eax
  80360d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803612:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803613:	e9 ea 02 00 00       	jmp    803902 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361c:	74 3b                	je     803659 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80361e:	83 ec 0c             	sub    $0xc,%esp
  803621:	ff 75 08             	pushl  0x8(%ebp)
  803624:	e8 9b f0 ff ff       	call   8026c4 <get_block_size>
  803629:	83 c4 10             	add    $0x10,%esp
  80362c:	89 c3                	mov    %eax,%ebx
  80362e:	83 ec 0c             	sub    $0xc,%esp
  803631:	ff 75 10             	pushl  0x10(%ebp)
  803634:	e8 8b f0 ff ff       	call   8026c4 <get_block_size>
  803639:	83 c4 10             	add    $0x10,%esp
  80363c:	01 d8                	add    %ebx,%eax
  80363e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803641:	83 ec 04             	sub    $0x4,%esp
  803644:	6a 00                	push   $0x0
  803646:	ff 75 e8             	pushl  -0x18(%ebp)
  803649:	ff 75 08             	pushl  0x8(%ebp)
  80364c:	e8 c4 f3 ff ff       	call   802a15 <set_block_data>
  803651:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803654:	e9 a9 02 00 00       	jmp    803902 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803659:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80365d:	0f 84 2d 01 00 00    	je     803790 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803663:	83 ec 0c             	sub    $0xc,%esp
  803666:	ff 75 10             	pushl  0x10(%ebp)
  803669:	e8 56 f0 ff ff       	call   8026c4 <get_block_size>
  80366e:	83 c4 10             	add    $0x10,%esp
  803671:	89 c3                	mov    %eax,%ebx
  803673:	83 ec 0c             	sub    $0xc,%esp
  803676:	ff 75 0c             	pushl  0xc(%ebp)
  803679:	e8 46 f0 ff ff       	call   8026c4 <get_block_size>
  80367e:	83 c4 10             	add    $0x10,%esp
  803681:	01 d8                	add    %ebx,%eax
  803683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803686:	83 ec 04             	sub    $0x4,%esp
  803689:	6a 00                	push   $0x0
  80368b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80368e:	ff 75 10             	pushl  0x10(%ebp)
  803691:	e8 7f f3 ff ff       	call   802a15 <set_block_data>
  803696:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803699:	8b 45 10             	mov    0x10(%ebp),%eax
  80369c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80369f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a3:	74 06                	je     8036ab <merging+0x1c6>
  8036a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036a9:	75 17                	jne    8036c2 <merging+0x1dd>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 18 4e 80 00       	push   $0x804e18
  8036b3:	68 8d 01 00 00       	push   $0x18d
  8036b8:	68 5d 4d 80 00       	push   $0x804d5d
  8036bd:	e8 9b 0a 00 00       	call   80415d <_panic>
  8036c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c5:	8b 50 04             	mov    0x4(%eax),%edx
  8036c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036cb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036d4:	89 10                	mov    %edx,(%eax)
  8036d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 0d                	je     8036ed <merging+0x208>
  8036e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e3:	8b 40 04             	mov    0x4(%eax),%eax
  8036e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036e9:	89 10                	mov    %edx,(%eax)
  8036eb:	eb 08                	jmp    8036f5 <merging+0x210>
  8036ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036fb:	89 50 04             	mov    %edx,0x4(%eax)
  8036fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803703:	40                   	inc    %eax
  803704:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80370d:	75 17                	jne    803726 <merging+0x241>
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 3f 4d 80 00       	push   $0x804d3f
  803717:	68 8e 01 00 00       	push   $0x18e
  80371c:	68 5d 4d 80 00       	push   $0x804d5d
  803721:	e8 37 0a 00 00       	call   80415d <_panic>
  803726:	8b 45 0c             	mov    0xc(%ebp),%eax
  803729:	8b 00                	mov    (%eax),%eax
  80372b:	85 c0                	test   %eax,%eax
  80372d:	74 10                	je     80373f <merging+0x25a>
  80372f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	8b 55 0c             	mov    0xc(%ebp),%edx
  803737:	8b 52 04             	mov    0x4(%edx),%edx
  80373a:	89 50 04             	mov    %edx,0x4(%eax)
  80373d:	eb 0b                	jmp    80374a <merging+0x265>
  80373f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803742:	8b 40 04             	mov    0x4(%eax),%eax
  803745:	a3 30 50 80 00       	mov    %eax,0x805030
  80374a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374d:	8b 40 04             	mov    0x4(%eax),%eax
  803750:	85 c0                	test   %eax,%eax
  803752:	74 0f                	je     803763 <merging+0x27e>
  803754:	8b 45 0c             	mov    0xc(%ebp),%eax
  803757:	8b 40 04             	mov    0x4(%eax),%eax
  80375a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80375d:	8b 12                	mov    (%edx),%edx
  80375f:	89 10                	mov    %edx,(%eax)
  803761:	eb 0a                	jmp    80376d <merging+0x288>
  803763:	8b 45 0c             	mov    0xc(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80376d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803776:	8b 45 0c             	mov    0xc(%ebp),%eax
  803779:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803780:	a1 38 50 80 00       	mov    0x805038,%eax
  803785:	48                   	dec    %eax
  803786:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80378b:	e9 72 01 00 00       	jmp    803902 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803790:	8b 45 10             	mov    0x10(%ebp),%eax
  803793:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803796:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80379a:	74 79                	je     803815 <merging+0x330>
  80379c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037a0:	74 73                	je     803815 <merging+0x330>
  8037a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a6:	74 06                	je     8037ae <merging+0x2c9>
  8037a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037ac:	75 17                	jne    8037c5 <merging+0x2e0>
  8037ae:	83 ec 04             	sub    $0x4,%esp
  8037b1:	68 d0 4d 80 00       	push   $0x804dd0
  8037b6:	68 94 01 00 00       	push   $0x194
  8037bb:	68 5d 4d 80 00       	push   $0x804d5d
  8037c0:	e8 98 09 00 00       	call   80415d <_panic>
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	8b 10                	mov    (%eax),%edx
  8037ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037cd:	89 10                	mov    %edx,(%eax)
  8037cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	85 c0                	test   %eax,%eax
  8037d6:	74 0b                	je     8037e3 <merging+0x2fe>
  8037d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f1:	89 50 04             	mov    %edx,0x4(%eax)
  8037f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	75 08                	jne    803805 <merging+0x320>
  8037fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803800:	a3 30 50 80 00       	mov    %eax,0x805030
  803805:	a1 38 50 80 00       	mov    0x805038,%eax
  80380a:	40                   	inc    %eax
  80380b:	a3 38 50 80 00       	mov    %eax,0x805038
  803810:	e9 ce 00 00 00       	jmp    8038e3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803819:	74 65                	je     803880 <merging+0x39b>
  80381b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80381f:	75 17                	jne    803838 <merging+0x353>
  803821:	83 ec 04             	sub    $0x4,%esp
  803824:	68 ac 4d 80 00       	push   $0x804dac
  803829:	68 95 01 00 00       	push   $0x195
  80382e:	68 5d 4d 80 00       	push   $0x804d5d
  803833:	e8 25 09 00 00       	call   80415d <_panic>
  803838:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80383e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803841:	89 50 04             	mov    %edx,0x4(%eax)
  803844:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803847:	8b 40 04             	mov    0x4(%eax),%eax
  80384a:	85 c0                	test   %eax,%eax
  80384c:	74 0c                	je     80385a <merging+0x375>
  80384e:	a1 30 50 80 00       	mov    0x805030,%eax
  803853:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803856:	89 10                	mov    %edx,(%eax)
  803858:	eb 08                	jmp    803862 <merging+0x37d>
  80385a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803862:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803865:	a3 30 50 80 00       	mov    %eax,0x805030
  80386a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80386d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803873:	a1 38 50 80 00       	mov    0x805038,%eax
  803878:	40                   	inc    %eax
  803879:	a3 38 50 80 00       	mov    %eax,0x805038
  80387e:	eb 63                	jmp    8038e3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803880:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803884:	75 17                	jne    80389d <merging+0x3b8>
  803886:	83 ec 04             	sub    $0x4,%esp
  803889:	68 78 4d 80 00       	push   $0x804d78
  80388e:	68 98 01 00 00       	push   $0x198
  803893:	68 5d 4d 80 00       	push   $0x804d5d
  803898:	e8 c0 08 00 00       	call   80415d <_panic>
  80389d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8038a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a6:	89 10                	mov    %edx,(%eax)
  8038a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	85 c0                	test   %eax,%eax
  8038af:	74 0d                	je     8038be <merging+0x3d9>
  8038b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038b9:	89 50 04             	mov    %edx,0x4(%eax)
  8038bc:	eb 08                	jmp    8038c6 <merging+0x3e1>
  8038be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038dd:	40                   	inc    %eax
  8038de:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8038e3:	83 ec 0c             	sub    $0xc,%esp
  8038e6:	ff 75 10             	pushl  0x10(%ebp)
  8038e9:	e8 d6 ed ff ff       	call   8026c4 <get_block_size>
  8038ee:	83 c4 10             	add    $0x10,%esp
  8038f1:	83 ec 04             	sub    $0x4,%esp
  8038f4:	6a 00                	push   $0x0
  8038f6:	50                   	push   %eax
  8038f7:	ff 75 10             	pushl  0x10(%ebp)
  8038fa:	e8 16 f1 ff ff       	call   802a15 <set_block_data>
  8038ff:	83 c4 10             	add    $0x10,%esp
	}
}
  803902:	90                   	nop
  803903:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803906:	c9                   	leave  
  803907:	c3                   	ret    

00803908 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803908:	55                   	push   %ebp
  803909:	89 e5                	mov    %esp,%ebp
  80390b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80390e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803913:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803916:	a1 30 50 80 00       	mov    0x805030,%eax
  80391b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80391e:	73 1b                	jae    80393b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803920:	a1 30 50 80 00       	mov    0x805030,%eax
  803925:	83 ec 04             	sub    $0x4,%esp
  803928:	ff 75 08             	pushl  0x8(%ebp)
  80392b:	6a 00                	push   $0x0
  80392d:	50                   	push   %eax
  80392e:	e8 b2 fb ff ff       	call   8034e5 <merging>
  803933:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803936:	e9 8b 00 00 00       	jmp    8039c6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80393b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803940:	3b 45 08             	cmp    0x8(%ebp),%eax
  803943:	76 18                	jbe    80395d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803945:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	ff 75 08             	pushl  0x8(%ebp)
  803950:	50                   	push   %eax
  803951:	6a 00                	push   $0x0
  803953:	e8 8d fb ff ff       	call   8034e5 <merging>
  803958:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80395b:	eb 69                	jmp    8039c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80395d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803965:	eb 39                	jmp    8039a0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80396d:	73 29                	jae    803998 <free_block+0x90>
  80396f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803972:	8b 00                	mov    (%eax),%eax
  803974:	3b 45 08             	cmp    0x8(%ebp),%eax
  803977:	76 1f                	jbe    803998 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397c:	8b 00                	mov    (%eax),%eax
  80397e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803981:	83 ec 04             	sub    $0x4,%esp
  803984:	ff 75 08             	pushl  0x8(%ebp)
  803987:	ff 75 f0             	pushl  -0x10(%ebp)
  80398a:	ff 75 f4             	pushl  -0xc(%ebp)
  80398d:	e8 53 fb ff ff       	call   8034e5 <merging>
  803992:	83 c4 10             	add    $0x10,%esp
			break;
  803995:	90                   	nop
		}
	}
}
  803996:	eb 2e                	jmp    8039c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803998:	a1 34 50 80 00       	mov    0x805034,%eax
  80399d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a4:	74 07                	je     8039ad <free_block+0xa5>
  8039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a9:	8b 00                	mov    (%eax),%eax
  8039ab:	eb 05                	jmp    8039b2 <free_block+0xaa>
  8039ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8039b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8039bc:	85 c0                	test   %eax,%eax
  8039be:	75 a7                	jne    803967 <free_block+0x5f>
  8039c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c4:	75 a1                	jne    803967 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039c6:	90                   	nop
  8039c7:	c9                   	leave  
  8039c8:	c3                   	ret    

008039c9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8039c9:	55                   	push   %ebp
  8039ca:	89 e5                	mov    %esp,%ebp
  8039cc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8039cf:	ff 75 08             	pushl  0x8(%ebp)
  8039d2:	e8 ed ec ff ff       	call   8026c4 <get_block_size>
  8039d7:	83 c4 04             	add    $0x4,%esp
  8039da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8039dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8039e4:	eb 17                	jmp    8039fd <copy_data+0x34>
  8039e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8039e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ec:	01 c2                	add    %eax,%edx
  8039ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	01 c8                	add    %ecx,%eax
  8039f6:	8a 00                	mov    (%eax),%al
  8039f8:	88 02                	mov    %al,(%edx)
  8039fa:	ff 45 fc             	incl   -0x4(%ebp)
  8039fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a03:	72 e1                	jb     8039e6 <copy_data+0x1d>
}
  803a05:	90                   	nop
  803a06:	c9                   	leave  
  803a07:	c3                   	ret    

00803a08 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a08:	55                   	push   %ebp
  803a09:	89 e5                	mov    %esp,%ebp
  803a0b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a12:	75 23                	jne    803a37 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a18:	74 13                	je     803a2d <realloc_block_FF+0x25>
  803a1a:	83 ec 0c             	sub    $0xc,%esp
  803a1d:	ff 75 0c             	pushl  0xc(%ebp)
  803a20:	e8 1f f0 ff ff       	call   802a44 <alloc_block_FF>
  803a25:	83 c4 10             	add    $0x10,%esp
  803a28:	e9 f4 06 00 00       	jmp    804121 <realloc_block_FF+0x719>
		return NULL;
  803a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a32:	e9 ea 06 00 00       	jmp    804121 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803a37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a3b:	75 18                	jne    803a55 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a3d:	83 ec 0c             	sub    $0xc,%esp
  803a40:	ff 75 08             	pushl  0x8(%ebp)
  803a43:	e8 c0 fe ff ff       	call   803908 <free_block>
  803a48:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a50:	e9 cc 06 00 00       	jmp    804121 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803a55:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a59:	77 07                	ja     803a62 <realloc_block_FF+0x5a>
  803a5b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a65:	83 e0 01             	and    $0x1,%eax
  803a68:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6e:	83 c0 08             	add    $0x8,%eax
  803a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a74:	83 ec 0c             	sub    $0xc,%esp
  803a77:	ff 75 08             	pushl  0x8(%ebp)
  803a7a:	e8 45 ec ff ff       	call   8026c4 <get_block_size>
  803a7f:	83 c4 10             	add    $0x10,%esp
  803a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a88:	83 e8 08             	sub    $0x8,%eax
  803a8b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a91:	83 e8 04             	sub    $0x4,%eax
  803a94:	8b 00                	mov    (%eax),%eax
  803a96:	83 e0 fe             	and    $0xfffffffe,%eax
  803a99:	89 c2                	mov    %eax,%edx
  803a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9e:	01 d0                	add    %edx,%eax
  803aa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803aa3:	83 ec 0c             	sub    $0xc,%esp
  803aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aa9:	e8 16 ec ff ff       	call   8026c4 <get_block_size>
  803aae:	83 c4 10             	add    $0x10,%esp
  803ab1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab7:	83 e8 08             	sub    $0x8,%eax
  803aba:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ac3:	75 08                	jne    803acd <realloc_block_FF+0xc5>
	{
		 return va;
  803ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac8:	e9 54 06 00 00       	jmp    804121 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ad3:	0f 83 e5 03 00 00    	jae    803ebe <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adc:	2b 45 0c             	sub    0xc(%ebp),%eax
  803adf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ae2:	83 ec 0c             	sub    $0xc,%esp
  803ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ae8:	e8 f0 eb ff ff       	call   8026dd <is_free_block>
  803aed:	83 c4 10             	add    $0x10,%esp
  803af0:	84 c0                	test   %al,%al
  803af2:	0f 84 3b 01 00 00    	je     803c33 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803af8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803afb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803afe:	01 d0                	add    %edx,%eax
  803b00:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b03:	83 ec 04             	sub    $0x4,%esp
  803b06:	6a 01                	push   $0x1
  803b08:	ff 75 f0             	pushl  -0x10(%ebp)
  803b0b:	ff 75 08             	pushl  0x8(%ebp)
  803b0e:	e8 02 ef ff ff       	call   802a15 <set_block_data>
  803b13:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b16:	8b 45 08             	mov    0x8(%ebp),%eax
  803b19:	83 e8 04             	sub    $0x4,%eax
  803b1c:	8b 00                	mov    (%eax),%eax
  803b1e:	83 e0 fe             	and    $0xfffffffe,%eax
  803b21:	89 c2                	mov    %eax,%edx
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	01 d0                	add    %edx,%eax
  803b28:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b2b:	83 ec 04             	sub    $0x4,%esp
  803b2e:	6a 00                	push   $0x0
  803b30:	ff 75 cc             	pushl  -0x34(%ebp)
  803b33:	ff 75 c8             	pushl  -0x38(%ebp)
  803b36:	e8 da ee ff ff       	call   802a15 <set_block_data>
  803b3b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b42:	74 06                	je     803b4a <realloc_block_FF+0x142>
  803b44:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b48:	75 17                	jne    803b61 <realloc_block_FF+0x159>
  803b4a:	83 ec 04             	sub    $0x4,%esp
  803b4d:	68 d0 4d 80 00       	push   $0x804dd0
  803b52:	68 f6 01 00 00       	push   $0x1f6
  803b57:	68 5d 4d 80 00       	push   $0x804d5d
  803b5c:	e8 fc 05 00 00       	call   80415d <_panic>
  803b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b64:	8b 10                	mov    (%eax),%edx
  803b66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b69:	89 10                	mov    %edx,(%eax)
  803b6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b6e:	8b 00                	mov    (%eax),%eax
  803b70:	85 c0                	test   %eax,%eax
  803b72:	74 0b                	je     803b7f <realloc_block_FF+0x177>
  803b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b77:	8b 00                	mov    (%eax),%eax
  803b79:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b7c:	89 50 04             	mov    %edx,0x4(%eax)
  803b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b82:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b85:	89 10                	mov    %edx,(%eax)
  803b87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b8d:	89 50 04             	mov    %edx,0x4(%eax)
  803b90:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b93:	8b 00                	mov    (%eax),%eax
  803b95:	85 c0                	test   %eax,%eax
  803b97:	75 08                	jne    803ba1 <realloc_block_FF+0x199>
  803b99:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b9c:	a3 30 50 80 00       	mov    %eax,0x805030
  803ba1:	a1 38 50 80 00       	mov    0x805038,%eax
  803ba6:	40                   	inc    %eax
  803ba7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bb0:	75 17                	jne    803bc9 <realloc_block_FF+0x1c1>
  803bb2:	83 ec 04             	sub    $0x4,%esp
  803bb5:	68 3f 4d 80 00       	push   $0x804d3f
  803bba:	68 f7 01 00 00       	push   $0x1f7
  803bbf:	68 5d 4d 80 00       	push   $0x804d5d
  803bc4:	e8 94 05 00 00       	call   80415d <_panic>
  803bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcc:	8b 00                	mov    (%eax),%eax
  803bce:	85 c0                	test   %eax,%eax
  803bd0:	74 10                	je     803be2 <realloc_block_FF+0x1da>
  803bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bda:	8b 52 04             	mov    0x4(%edx),%edx
  803bdd:	89 50 04             	mov    %edx,0x4(%eax)
  803be0:	eb 0b                	jmp    803bed <realloc_block_FF+0x1e5>
  803be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be5:	8b 40 04             	mov    0x4(%eax),%eax
  803be8:	a3 30 50 80 00       	mov    %eax,0x805030
  803bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf0:	8b 40 04             	mov    0x4(%eax),%eax
  803bf3:	85 c0                	test   %eax,%eax
  803bf5:	74 0f                	je     803c06 <realloc_block_FF+0x1fe>
  803bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfa:	8b 40 04             	mov    0x4(%eax),%eax
  803bfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c00:	8b 12                	mov    (%edx),%edx
  803c02:	89 10                	mov    %edx,(%eax)
  803c04:	eb 0a                	jmp    803c10 <realloc_block_FF+0x208>
  803c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c09:	8b 00                	mov    (%eax),%eax
  803c0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c23:	a1 38 50 80 00       	mov    0x805038,%eax
  803c28:	48                   	dec    %eax
  803c29:	a3 38 50 80 00       	mov    %eax,0x805038
  803c2e:	e9 83 02 00 00       	jmp    803eb6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803c33:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c37:	0f 86 69 02 00 00    	jbe    803ea6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c3d:	83 ec 04             	sub    $0x4,%esp
  803c40:	6a 01                	push   $0x1
  803c42:	ff 75 f0             	pushl  -0x10(%ebp)
  803c45:	ff 75 08             	pushl  0x8(%ebp)
  803c48:	e8 c8 ed ff ff       	call   802a15 <set_block_data>
  803c4d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c50:	8b 45 08             	mov    0x8(%ebp),%eax
  803c53:	83 e8 04             	sub    $0x4,%eax
  803c56:	8b 00                	mov    (%eax),%eax
  803c58:	83 e0 fe             	and    $0xfffffffe,%eax
  803c5b:	89 c2                	mov    %eax,%edx
  803c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c60:	01 d0                	add    %edx,%eax
  803c62:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c65:	a1 38 50 80 00       	mov    0x805038,%eax
  803c6a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c6d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c71:	75 68                	jne    803cdb <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c73:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c77:	75 17                	jne    803c90 <realloc_block_FF+0x288>
  803c79:	83 ec 04             	sub    $0x4,%esp
  803c7c:	68 78 4d 80 00       	push   $0x804d78
  803c81:	68 06 02 00 00       	push   $0x206
  803c86:	68 5d 4d 80 00       	push   $0x804d5d
  803c8b:	e8 cd 04 00 00       	call   80415d <_panic>
  803c90:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803c96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c99:	89 10                	mov    %edx,(%eax)
  803c9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	85 c0                	test   %eax,%eax
  803ca2:	74 0d                	je     803cb1 <realloc_block_FF+0x2a9>
  803ca4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ca9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cac:	89 50 04             	mov    %edx,0x4(%eax)
  803caf:	eb 08                	jmp    803cb9 <realloc_block_FF+0x2b1>
  803cb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb4:	a3 30 50 80 00       	mov    %eax,0x805030
  803cb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ccb:	a1 38 50 80 00       	mov    0x805038,%eax
  803cd0:	40                   	inc    %eax
  803cd1:	a3 38 50 80 00       	mov    %eax,0x805038
  803cd6:	e9 b0 01 00 00       	jmp    803e8b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803cdb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ce0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ce3:	76 68                	jbe    803d4d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ce5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ce9:	75 17                	jne    803d02 <realloc_block_FF+0x2fa>
  803ceb:	83 ec 04             	sub    $0x4,%esp
  803cee:	68 78 4d 80 00       	push   $0x804d78
  803cf3:	68 0b 02 00 00       	push   $0x20b
  803cf8:	68 5d 4d 80 00       	push   $0x804d5d
  803cfd:	e8 5b 04 00 00       	call   80415d <_panic>
  803d02:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0b:	89 10                	mov    %edx,(%eax)
  803d0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	85 c0                	test   %eax,%eax
  803d14:	74 0d                	je     803d23 <realloc_block_FF+0x31b>
  803d16:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d1b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d1e:	89 50 04             	mov    %edx,0x4(%eax)
  803d21:	eb 08                	jmp    803d2b <realloc_block_FF+0x323>
  803d23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d26:	a3 30 50 80 00       	mov    %eax,0x805030
  803d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d3d:	a1 38 50 80 00       	mov    0x805038,%eax
  803d42:	40                   	inc    %eax
  803d43:	a3 38 50 80 00       	mov    %eax,0x805038
  803d48:	e9 3e 01 00 00       	jmp    803e8b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d4d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d52:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d55:	73 68                	jae    803dbf <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d57:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d5b:	75 17                	jne    803d74 <realloc_block_FF+0x36c>
  803d5d:	83 ec 04             	sub    $0x4,%esp
  803d60:	68 ac 4d 80 00       	push   $0x804dac
  803d65:	68 10 02 00 00       	push   $0x210
  803d6a:	68 5d 4d 80 00       	push   $0x804d5d
  803d6f:	e8 e9 03 00 00       	call   80415d <_panic>
  803d74:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803d7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7d:	89 50 04             	mov    %edx,0x4(%eax)
  803d80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d83:	8b 40 04             	mov    0x4(%eax),%eax
  803d86:	85 c0                	test   %eax,%eax
  803d88:	74 0c                	je     803d96 <realloc_block_FF+0x38e>
  803d8a:	a1 30 50 80 00       	mov    0x805030,%eax
  803d8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d92:	89 10                	mov    %edx,(%eax)
  803d94:	eb 08                	jmp    803d9e <realloc_block_FF+0x396>
  803d96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d99:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da1:	a3 30 50 80 00       	mov    %eax,0x805030
  803da6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803daf:	a1 38 50 80 00       	mov    0x805038,%eax
  803db4:	40                   	inc    %eax
  803db5:	a3 38 50 80 00       	mov    %eax,0x805038
  803dba:	e9 cc 00 00 00       	jmp    803e8b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803dbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803dc6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dce:	e9 8a 00 00 00       	jmp    803e5d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803dd9:	73 7a                	jae    803e55 <realloc_block_FF+0x44d>
  803ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dde:	8b 00                	mov    (%eax),%eax
  803de0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803de3:	73 70                	jae    803e55 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803de9:	74 06                	je     803df1 <realloc_block_FF+0x3e9>
  803deb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803def:	75 17                	jne    803e08 <realloc_block_FF+0x400>
  803df1:	83 ec 04             	sub    $0x4,%esp
  803df4:	68 d0 4d 80 00       	push   $0x804dd0
  803df9:	68 1a 02 00 00       	push   $0x21a
  803dfe:	68 5d 4d 80 00       	push   $0x804d5d
  803e03:	e8 55 03 00 00       	call   80415d <_panic>
  803e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0b:	8b 10                	mov    (%eax),%edx
  803e0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e10:	89 10                	mov    %edx,(%eax)
  803e12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e15:	8b 00                	mov    (%eax),%eax
  803e17:	85 c0                	test   %eax,%eax
  803e19:	74 0b                	je     803e26 <realloc_block_FF+0x41e>
  803e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1e:	8b 00                	mov    (%eax),%eax
  803e20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e23:	89 50 04             	mov    %edx,0x4(%eax)
  803e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e29:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e2c:	89 10                	mov    %edx,(%eax)
  803e2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e34:	89 50 04             	mov    %edx,0x4(%eax)
  803e37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e3a:	8b 00                	mov    (%eax),%eax
  803e3c:	85 c0                	test   %eax,%eax
  803e3e:	75 08                	jne    803e48 <realloc_block_FF+0x440>
  803e40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e43:	a3 30 50 80 00       	mov    %eax,0x805030
  803e48:	a1 38 50 80 00       	mov    0x805038,%eax
  803e4d:	40                   	inc    %eax
  803e4e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803e53:	eb 36                	jmp    803e8b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e55:	a1 34 50 80 00       	mov    0x805034,%eax
  803e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e61:	74 07                	je     803e6a <realloc_block_FF+0x462>
  803e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e66:	8b 00                	mov    (%eax),%eax
  803e68:	eb 05                	jmp    803e6f <realloc_block_FF+0x467>
  803e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6f:	a3 34 50 80 00       	mov    %eax,0x805034
  803e74:	a1 34 50 80 00       	mov    0x805034,%eax
  803e79:	85 c0                	test   %eax,%eax
  803e7b:	0f 85 52 ff ff ff    	jne    803dd3 <realloc_block_FF+0x3cb>
  803e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e85:	0f 85 48 ff ff ff    	jne    803dd3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e8b:	83 ec 04             	sub    $0x4,%esp
  803e8e:	6a 00                	push   $0x0
  803e90:	ff 75 d8             	pushl  -0x28(%ebp)
  803e93:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e96:	e8 7a eb ff ff       	call   802a15 <set_block_data>
  803e9b:	83 c4 10             	add    $0x10,%esp
				return va;
  803e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea1:	e9 7b 02 00 00       	jmp    804121 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803ea6:	83 ec 0c             	sub    $0xc,%esp
  803ea9:	68 4d 4e 80 00       	push   $0x804e4d
  803eae:	e8 6e cd ff ff       	call   800c21 <cprintf>
  803eb3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb9:	e9 63 02 00 00       	jmp    804121 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ec1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ec4:	0f 86 4d 02 00 00    	jbe    804117 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803eca:	83 ec 0c             	sub    $0xc,%esp
  803ecd:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ed0:	e8 08 e8 ff ff       	call   8026dd <is_free_block>
  803ed5:	83 c4 10             	add    $0x10,%esp
  803ed8:	84 c0                	test   %al,%al
  803eda:	0f 84 37 02 00 00    	je     804117 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ee3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ee6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803ee9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803eec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803eef:	76 38                	jbe    803f29 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803ef1:	83 ec 0c             	sub    $0xc,%esp
  803ef4:	ff 75 08             	pushl  0x8(%ebp)
  803ef7:	e8 0c fa ff ff       	call   803908 <free_block>
  803efc:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803eff:	83 ec 0c             	sub    $0xc,%esp
  803f02:	ff 75 0c             	pushl  0xc(%ebp)
  803f05:	e8 3a eb ff ff       	call   802a44 <alloc_block_FF>
  803f0a:	83 c4 10             	add    $0x10,%esp
  803f0d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f10:	83 ec 08             	sub    $0x8,%esp
  803f13:	ff 75 c0             	pushl  -0x40(%ebp)
  803f16:	ff 75 08             	pushl  0x8(%ebp)
  803f19:	e8 ab fa ff ff       	call   8039c9 <copy_data>
  803f1e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f21:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f24:	e9 f8 01 00 00       	jmp    804121 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f2c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f2f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f32:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f36:	0f 87 a0 00 00 00    	ja     803fdc <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f40:	75 17                	jne    803f59 <realloc_block_FF+0x551>
  803f42:	83 ec 04             	sub    $0x4,%esp
  803f45:	68 3f 4d 80 00       	push   $0x804d3f
  803f4a:	68 38 02 00 00       	push   $0x238
  803f4f:	68 5d 4d 80 00       	push   $0x804d5d
  803f54:	e8 04 02 00 00       	call   80415d <_panic>
  803f59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5c:	8b 00                	mov    (%eax),%eax
  803f5e:	85 c0                	test   %eax,%eax
  803f60:	74 10                	je     803f72 <realloc_block_FF+0x56a>
  803f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f65:	8b 00                	mov    (%eax),%eax
  803f67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f6a:	8b 52 04             	mov    0x4(%edx),%edx
  803f6d:	89 50 04             	mov    %edx,0x4(%eax)
  803f70:	eb 0b                	jmp    803f7d <realloc_block_FF+0x575>
  803f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f75:	8b 40 04             	mov    0x4(%eax),%eax
  803f78:	a3 30 50 80 00       	mov    %eax,0x805030
  803f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f80:	8b 40 04             	mov    0x4(%eax),%eax
  803f83:	85 c0                	test   %eax,%eax
  803f85:	74 0f                	je     803f96 <realloc_block_FF+0x58e>
  803f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8a:	8b 40 04             	mov    0x4(%eax),%eax
  803f8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f90:	8b 12                	mov    (%edx),%edx
  803f92:	89 10                	mov    %edx,(%eax)
  803f94:	eb 0a                	jmp    803fa0 <realloc_block_FF+0x598>
  803f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f99:	8b 00                	mov    (%eax),%eax
  803f9b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fb3:	a1 38 50 80 00       	mov    0x805038,%eax
  803fb8:	48                   	dec    %eax
  803fb9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803fbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fc4:	01 d0                	add    %edx,%eax
  803fc6:	83 ec 04             	sub    $0x4,%esp
  803fc9:	6a 01                	push   $0x1
  803fcb:	50                   	push   %eax
  803fcc:	ff 75 08             	pushl  0x8(%ebp)
  803fcf:	e8 41 ea ff ff       	call   802a15 <set_block_data>
  803fd4:	83 c4 10             	add    $0x10,%esp
  803fd7:	e9 36 01 00 00       	jmp    804112 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803fdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fdf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fe2:	01 d0                	add    %edx,%eax
  803fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803fe7:	83 ec 04             	sub    $0x4,%esp
  803fea:	6a 01                	push   $0x1
  803fec:	ff 75 f0             	pushl  -0x10(%ebp)
  803fef:	ff 75 08             	pushl  0x8(%ebp)
  803ff2:	e8 1e ea ff ff       	call   802a15 <set_block_data>
  803ff7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffd:	83 e8 04             	sub    $0x4,%eax
  804000:	8b 00                	mov    (%eax),%eax
  804002:	83 e0 fe             	and    $0xfffffffe,%eax
  804005:	89 c2                	mov    %eax,%edx
  804007:	8b 45 08             	mov    0x8(%ebp),%eax
  80400a:	01 d0                	add    %edx,%eax
  80400c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80400f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804013:	74 06                	je     80401b <realloc_block_FF+0x613>
  804015:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804019:	75 17                	jne    804032 <realloc_block_FF+0x62a>
  80401b:	83 ec 04             	sub    $0x4,%esp
  80401e:	68 d0 4d 80 00       	push   $0x804dd0
  804023:	68 44 02 00 00       	push   $0x244
  804028:	68 5d 4d 80 00       	push   $0x804d5d
  80402d:	e8 2b 01 00 00       	call   80415d <_panic>
  804032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804035:	8b 10                	mov    (%eax),%edx
  804037:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80403a:	89 10                	mov    %edx,(%eax)
  80403c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80403f:	8b 00                	mov    (%eax),%eax
  804041:	85 c0                	test   %eax,%eax
  804043:	74 0b                	je     804050 <realloc_block_FF+0x648>
  804045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804048:	8b 00                	mov    (%eax),%eax
  80404a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80404d:	89 50 04             	mov    %edx,0x4(%eax)
  804050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804053:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804056:	89 10                	mov    %edx,(%eax)
  804058:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80405b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80405e:	89 50 04             	mov    %edx,0x4(%eax)
  804061:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804064:	8b 00                	mov    (%eax),%eax
  804066:	85 c0                	test   %eax,%eax
  804068:	75 08                	jne    804072 <realloc_block_FF+0x66a>
  80406a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80406d:	a3 30 50 80 00       	mov    %eax,0x805030
  804072:	a1 38 50 80 00       	mov    0x805038,%eax
  804077:	40                   	inc    %eax
  804078:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80407d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804081:	75 17                	jne    80409a <realloc_block_FF+0x692>
  804083:	83 ec 04             	sub    $0x4,%esp
  804086:	68 3f 4d 80 00       	push   $0x804d3f
  80408b:	68 45 02 00 00       	push   $0x245
  804090:	68 5d 4d 80 00       	push   $0x804d5d
  804095:	e8 c3 00 00 00       	call   80415d <_panic>
  80409a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409d:	8b 00                	mov    (%eax),%eax
  80409f:	85 c0                	test   %eax,%eax
  8040a1:	74 10                	je     8040b3 <realloc_block_FF+0x6ab>
  8040a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a6:	8b 00                	mov    (%eax),%eax
  8040a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ab:	8b 52 04             	mov    0x4(%edx),%edx
  8040ae:	89 50 04             	mov    %edx,0x4(%eax)
  8040b1:	eb 0b                	jmp    8040be <realloc_block_FF+0x6b6>
  8040b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b6:	8b 40 04             	mov    0x4(%eax),%eax
  8040b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8040be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c1:	8b 40 04             	mov    0x4(%eax),%eax
  8040c4:	85 c0                	test   %eax,%eax
  8040c6:	74 0f                	je     8040d7 <realloc_block_FF+0x6cf>
  8040c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040cb:	8b 40 04             	mov    0x4(%eax),%eax
  8040ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d1:	8b 12                	mov    (%edx),%edx
  8040d3:	89 10                	mov    %edx,(%eax)
  8040d5:	eb 0a                	jmp    8040e1 <realloc_block_FF+0x6d9>
  8040d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040da:	8b 00                	mov    (%eax),%eax
  8040dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8040e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8040f9:	48                   	dec    %eax
  8040fa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8040ff:	83 ec 04             	sub    $0x4,%esp
  804102:	6a 00                	push   $0x0
  804104:	ff 75 bc             	pushl  -0x44(%ebp)
  804107:	ff 75 b8             	pushl  -0x48(%ebp)
  80410a:	e8 06 e9 ff ff       	call   802a15 <set_block_data>
  80410f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804112:	8b 45 08             	mov    0x8(%ebp),%eax
  804115:	eb 0a                	jmp    804121 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804117:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80411e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804121:	c9                   	leave  
  804122:	c3                   	ret    

00804123 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804123:	55                   	push   %ebp
  804124:	89 e5                	mov    %esp,%ebp
  804126:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804129:	83 ec 04             	sub    $0x4,%esp
  80412c:	68 54 4e 80 00       	push   $0x804e54
  804131:	68 58 02 00 00       	push   $0x258
  804136:	68 5d 4d 80 00       	push   $0x804d5d
  80413b:	e8 1d 00 00 00       	call   80415d <_panic>

00804140 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804140:	55                   	push   %ebp
  804141:	89 e5                	mov    %esp,%ebp
  804143:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804146:	83 ec 04             	sub    $0x4,%esp
  804149:	68 7c 4e 80 00       	push   $0x804e7c
  80414e:	68 61 02 00 00       	push   $0x261
  804153:	68 5d 4d 80 00       	push   $0x804d5d
  804158:	e8 00 00 00 00       	call   80415d <_panic>

0080415d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80415d:	55                   	push   %ebp
  80415e:	89 e5                	mov    %esp,%ebp
  804160:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  804163:	8d 45 10             	lea    0x10(%ebp),%eax
  804166:	83 c0 04             	add    $0x4,%eax
  804169:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80416c:	a1 60 50 90 00       	mov    0x905060,%eax
  804171:	85 c0                	test   %eax,%eax
  804173:	74 16                	je     80418b <_panic+0x2e>
		cprintf("%s: ", argv0);
  804175:	a1 60 50 90 00       	mov    0x905060,%eax
  80417a:	83 ec 08             	sub    $0x8,%esp
  80417d:	50                   	push   %eax
  80417e:	68 a4 4e 80 00       	push   $0x804ea4
  804183:	e8 99 ca ff ff       	call   800c21 <cprintf>
  804188:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80418b:	a1 00 50 80 00       	mov    0x805000,%eax
  804190:	ff 75 0c             	pushl  0xc(%ebp)
  804193:	ff 75 08             	pushl  0x8(%ebp)
  804196:	50                   	push   %eax
  804197:	68 a9 4e 80 00       	push   $0x804ea9
  80419c:	e8 80 ca ff ff       	call   800c21 <cprintf>
  8041a1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8041a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8041a7:	83 ec 08             	sub    $0x8,%esp
  8041aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8041ad:	50                   	push   %eax
  8041ae:	e8 03 ca ff ff       	call   800bb6 <vcprintf>
  8041b3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8041b6:	83 ec 08             	sub    $0x8,%esp
  8041b9:	6a 00                	push   $0x0
  8041bb:	68 c5 4e 80 00       	push   $0x804ec5
  8041c0:	e8 f1 c9 ff ff       	call   800bb6 <vcprintf>
  8041c5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8041c8:	e8 72 c9 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  8041cd:	eb fe                	jmp    8041cd <_panic+0x70>

008041cf <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8041cf:	55                   	push   %ebp
  8041d0:	89 e5                	mov    %esp,%ebp
  8041d2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8041d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8041da:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8041e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041e3:	39 c2                	cmp    %eax,%edx
  8041e5:	74 14                	je     8041fb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8041e7:	83 ec 04             	sub    $0x4,%esp
  8041ea:	68 c8 4e 80 00       	push   $0x804ec8
  8041ef:	6a 26                	push   $0x26
  8041f1:	68 14 4f 80 00       	push   $0x804f14
  8041f6:	e8 62 ff ff ff       	call   80415d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8041fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  804202:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804209:	e9 c5 00 00 00       	jmp    8042d3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80420e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804211:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804218:	8b 45 08             	mov    0x8(%ebp),%eax
  80421b:	01 d0                	add    %edx,%eax
  80421d:	8b 00                	mov    (%eax),%eax
  80421f:	85 c0                	test   %eax,%eax
  804221:	75 08                	jne    80422b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804223:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804226:	e9 a5 00 00 00       	jmp    8042d0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80422b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804232:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804239:	eb 69                	jmp    8042a4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80423b:	a1 20 50 80 00       	mov    0x805020,%eax
  804240:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804246:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804249:	89 d0                	mov    %edx,%eax
  80424b:	01 c0                	add    %eax,%eax
  80424d:	01 d0                	add    %edx,%eax
  80424f:	c1 e0 03             	shl    $0x3,%eax
  804252:	01 c8                	add    %ecx,%eax
  804254:	8a 40 04             	mov    0x4(%eax),%al
  804257:	84 c0                	test   %al,%al
  804259:	75 46                	jne    8042a1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80425b:	a1 20 50 80 00       	mov    0x805020,%eax
  804260:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804269:	89 d0                	mov    %edx,%eax
  80426b:	01 c0                	add    %eax,%eax
  80426d:	01 d0                	add    %edx,%eax
  80426f:	c1 e0 03             	shl    $0x3,%eax
  804272:	01 c8                	add    %ecx,%eax
  804274:	8b 00                	mov    (%eax),%eax
  804276:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804279:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80427c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804281:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804286:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
  804290:	01 c8                	add    %ecx,%eax
  804292:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804294:	39 c2                	cmp    %eax,%edx
  804296:	75 09                	jne    8042a1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804298:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80429f:	eb 15                	jmp    8042b6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042a1:	ff 45 e8             	incl   -0x18(%ebp)
  8042a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8042a9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8042af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042b2:	39 c2                	cmp    %eax,%edx
  8042b4:	77 85                	ja     80423b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8042b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8042ba:	75 14                	jne    8042d0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8042bc:	83 ec 04             	sub    $0x4,%esp
  8042bf:	68 20 4f 80 00       	push   $0x804f20
  8042c4:	6a 3a                	push   $0x3a
  8042c6:	68 14 4f 80 00       	push   $0x804f14
  8042cb:	e8 8d fe ff ff       	call   80415d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8042d0:	ff 45 f0             	incl   -0x10(%ebp)
  8042d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8042d9:	0f 8c 2f ff ff ff    	jl     80420e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8042df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8042ed:	eb 26                	jmp    804315 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8042ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8042f4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8042fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8042fd:	89 d0                	mov    %edx,%eax
  8042ff:	01 c0                	add    %eax,%eax
  804301:	01 d0                	add    %edx,%eax
  804303:	c1 e0 03             	shl    $0x3,%eax
  804306:	01 c8                	add    %ecx,%eax
  804308:	8a 40 04             	mov    0x4(%eax),%al
  80430b:	3c 01                	cmp    $0x1,%al
  80430d:	75 03                	jne    804312 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80430f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804312:	ff 45 e0             	incl   -0x20(%ebp)
  804315:	a1 20 50 80 00       	mov    0x805020,%eax
  80431a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804320:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804323:	39 c2                	cmp    %eax,%edx
  804325:	77 c8                	ja     8042ef <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80432a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80432d:	74 14                	je     804343 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80432f:	83 ec 04             	sub    $0x4,%esp
  804332:	68 74 4f 80 00       	push   $0x804f74
  804337:	6a 44                	push   $0x44
  804339:	68 14 4f 80 00       	push   $0x804f14
  80433e:	e8 1a fe ff ff       	call   80415d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804343:	90                   	nop
  804344:	c9                   	leave  
  804345:	c3                   	ret    
  804346:	66 90                	xchg   %ax,%ax

00804348 <__udivdi3>:
  804348:	55                   	push   %ebp
  804349:	57                   	push   %edi
  80434a:	56                   	push   %esi
  80434b:	53                   	push   %ebx
  80434c:	83 ec 1c             	sub    $0x1c,%esp
  80434f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804353:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80435b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80435f:	89 ca                	mov    %ecx,%edx
  804361:	89 f8                	mov    %edi,%eax
  804363:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804367:	85 f6                	test   %esi,%esi
  804369:	75 2d                	jne    804398 <__udivdi3+0x50>
  80436b:	39 cf                	cmp    %ecx,%edi
  80436d:	77 65                	ja     8043d4 <__udivdi3+0x8c>
  80436f:	89 fd                	mov    %edi,%ebp
  804371:	85 ff                	test   %edi,%edi
  804373:	75 0b                	jne    804380 <__udivdi3+0x38>
  804375:	b8 01 00 00 00       	mov    $0x1,%eax
  80437a:	31 d2                	xor    %edx,%edx
  80437c:	f7 f7                	div    %edi
  80437e:	89 c5                	mov    %eax,%ebp
  804380:	31 d2                	xor    %edx,%edx
  804382:	89 c8                	mov    %ecx,%eax
  804384:	f7 f5                	div    %ebp
  804386:	89 c1                	mov    %eax,%ecx
  804388:	89 d8                	mov    %ebx,%eax
  80438a:	f7 f5                	div    %ebp
  80438c:	89 cf                	mov    %ecx,%edi
  80438e:	89 fa                	mov    %edi,%edx
  804390:	83 c4 1c             	add    $0x1c,%esp
  804393:	5b                   	pop    %ebx
  804394:	5e                   	pop    %esi
  804395:	5f                   	pop    %edi
  804396:	5d                   	pop    %ebp
  804397:	c3                   	ret    
  804398:	39 ce                	cmp    %ecx,%esi
  80439a:	77 28                	ja     8043c4 <__udivdi3+0x7c>
  80439c:	0f bd fe             	bsr    %esi,%edi
  80439f:	83 f7 1f             	xor    $0x1f,%edi
  8043a2:	75 40                	jne    8043e4 <__udivdi3+0x9c>
  8043a4:	39 ce                	cmp    %ecx,%esi
  8043a6:	72 0a                	jb     8043b2 <__udivdi3+0x6a>
  8043a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043ac:	0f 87 9e 00 00 00    	ja     804450 <__udivdi3+0x108>
  8043b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043b7:	89 fa                	mov    %edi,%edx
  8043b9:	83 c4 1c             	add    $0x1c,%esp
  8043bc:	5b                   	pop    %ebx
  8043bd:	5e                   	pop    %esi
  8043be:	5f                   	pop    %edi
  8043bf:	5d                   	pop    %ebp
  8043c0:	c3                   	ret    
  8043c1:	8d 76 00             	lea    0x0(%esi),%esi
  8043c4:	31 ff                	xor    %edi,%edi
  8043c6:	31 c0                	xor    %eax,%eax
  8043c8:	89 fa                	mov    %edi,%edx
  8043ca:	83 c4 1c             	add    $0x1c,%esp
  8043cd:	5b                   	pop    %ebx
  8043ce:	5e                   	pop    %esi
  8043cf:	5f                   	pop    %edi
  8043d0:	5d                   	pop    %ebp
  8043d1:	c3                   	ret    
  8043d2:	66 90                	xchg   %ax,%ax
  8043d4:	89 d8                	mov    %ebx,%eax
  8043d6:	f7 f7                	div    %edi
  8043d8:	31 ff                	xor    %edi,%edi
  8043da:	89 fa                	mov    %edi,%edx
  8043dc:	83 c4 1c             	add    $0x1c,%esp
  8043df:	5b                   	pop    %ebx
  8043e0:	5e                   	pop    %esi
  8043e1:	5f                   	pop    %edi
  8043e2:	5d                   	pop    %ebp
  8043e3:	c3                   	ret    
  8043e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043e9:	89 eb                	mov    %ebp,%ebx
  8043eb:	29 fb                	sub    %edi,%ebx
  8043ed:	89 f9                	mov    %edi,%ecx
  8043ef:	d3 e6                	shl    %cl,%esi
  8043f1:	89 c5                	mov    %eax,%ebp
  8043f3:	88 d9                	mov    %bl,%cl
  8043f5:	d3 ed                	shr    %cl,%ebp
  8043f7:	89 e9                	mov    %ebp,%ecx
  8043f9:	09 f1                	or     %esi,%ecx
  8043fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8043ff:	89 f9                	mov    %edi,%ecx
  804401:	d3 e0                	shl    %cl,%eax
  804403:	89 c5                	mov    %eax,%ebp
  804405:	89 d6                	mov    %edx,%esi
  804407:	88 d9                	mov    %bl,%cl
  804409:	d3 ee                	shr    %cl,%esi
  80440b:	89 f9                	mov    %edi,%ecx
  80440d:	d3 e2                	shl    %cl,%edx
  80440f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804413:	88 d9                	mov    %bl,%cl
  804415:	d3 e8                	shr    %cl,%eax
  804417:	09 c2                	or     %eax,%edx
  804419:	89 d0                	mov    %edx,%eax
  80441b:	89 f2                	mov    %esi,%edx
  80441d:	f7 74 24 0c          	divl   0xc(%esp)
  804421:	89 d6                	mov    %edx,%esi
  804423:	89 c3                	mov    %eax,%ebx
  804425:	f7 e5                	mul    %ebp
  804427:	39 d6                	cmp    %edx,%esi
  804429:	72 19                	jb     804444 <__udivdi3+0xfc>
  80442b:	74 0b                	je     804438 <__udivdi3+0xf0>
  80442d:	89 d8                	mov    %ebx,%eax
  80442f:	31 ff                	xor    %edi,%edi
  804431:	e9 58 ff ff ff       	jmp    80438e <__udivdi3+0x46>
  804436:	66 90                	xchg   %ax,%ax
  804438:	8b 54 24 08          	mov    0x8(%esp),%edx
  80443c:	89 f9                	mov    %edi,%ecx
  80443e:	d3 e2                	shl    %cl,%edx
  804440:	39 c2                	cmp    %eax,%edx
  804442:	73 e9                	jae    80442d <__udivdi3+0xe5>
  804444:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804447:	31 ff                	xor    %edi,%edi
  804449:	e9 40 ff ff ff       	jmp    80438e <__udivdi3+0x46>
  80444e:	66 90                	xchg   %ax,%ax
  804450:	31 c0                	xor    %eax,%eax
  804452:	e9 37 ff ff ff       	jmp    80438e <__udivdi3+0x46>
  804457:	90                   	nop

00804458 <__umoddi3>:
  804458:	55                   	push   %ebp
  804459:	57                   	push   %edi
  80445a:	56                   	push   %esi
  80445b:	53                   	push   %ebx
  80445c:	83 ec 1c             	sub    $0x1c,%esp
  80445f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804463:	8b 74 24 34          	mov    0x34(%esp),%esi
  804467:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80446b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80446f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804473:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804477:	89 f3                	mov    %esi,%ebx
  804479:	89 fa                	mov    %edi,%edx
  80447b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80447f:	89 34 24             	mov    %esi,(%esp)
  804482:	85 c0                	test   %eax,%eax
  804484:	75 1a                	jne    8044a0 <__umoddi3+0x48>
  804486:	39 f7                	cmp    %esi,%edi
  804488:	0f 86 a2 00 00 00    	jbe    804530 <__umoddi3+0xd8>
  80448e:	89 c8                	mov    %ecx,%eax
  804490:	89 f2                	mov    %esi,%edx
  804492:	f7 f7                	div    %edi
  804494:	89 d0                	mov    %edx,%eax
  804496:	31 d2                	xor    %edx,%edx
  804498:	83 c4 1c             	add    $0x1c,%esp
  80449b:	5b                   	pop    %ebx
  80449c:	5e                   	pop    %esi
  80449d:	5f                   	pop    %edi
  80449e:	5d                   	pop    %ebp
  80449f:	c3                   	ret    
  8044a0:	39 f0                	cmp    %esi,%eax
  8044a2:	0f 87 ac 00 00 00    	ja     804554 <__umoddi3+0xfc>
  8044a8:	0f bd e8             	bsr    %eax,%ebp
  8044ab:	83 f5 1f             	xor    $0x1f,%ebp
  8044ae:	0f 84 ac 00 00 00    	je     804560 <__umoddi3+0x108>
  8044b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8044b9:	29 ef                	sub    %ebp,%edi
  8044bb:	89 fe                	mov    %edi,%esi
  8044bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044c1:	89 e9                	mov    %ebp,%ecx
  8044c3:	d3 e0                	shl    %cl,%eax
  8044c5:	89 d7                	mov    %edx,%edi
  8044c7:	89 f1                	mov    %esi,%ecx
  8044c9:	d3 ef                	shr    %cl,%edi
  8044cb:	09 c7                	or     %eax,%edi
  8044cd:	89 e9                	mov    %ebp,%ecx
  8044cf:	d3 e2                	shl    %cl,%edx
  8044d1:	89 14 24             	mov    %edx,(%esp)
  8044d4:	89 d8                	mov    %ebx,%eax
  8044d6:	d3 e0                	shl    %cl,%eax
  8044d8:	89 c2                	mov    %eax,%edx
  8044da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044de:	d3 e0                	shl    %cl,%eax
  8044e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044e8:	89 f1                	mov    %esi,%ecx
  8044ea:	d3 e8                	shr    %cl,%eax
  8044ec:	09 d0                	or     %edx,%eax
  8044ee:	d3 eb                	shr    %cl,%ebx
  8044f0:	89 da                	mov    %ebx,%edx
  8044f2:	f7 f7                	div    %edi
  8044f4:	89 d3                	mov    %edx,%ebx
  8044f6:	f7 24 24             	mull   (%esp)
  8044f9:	89 c6                	mov    %eax,%esi
  8044fb:	89 d1                	mov    %edx,%ecx
  8044fd:	39 d3                	cmp    %edx,%ebx
  8044ff:	0f 82 87 00 00 00    	jb     80458c <__umoddi3+0x134>
  804505:	0f 84 91 00 00 00    	je     80459c <__umoddi3+0x144>
  80450b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80450f:	29 f2                	sub    %esi,%edx
  804511:	19 cb                	sbb    %ecx,%ebx
  804513:	89 d8                	mov    %ebx,%eax
  804515:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804519:	d3 e0                	shl    %cl,%eax
  80451b:	89 e9                	mov    %ebp,%ecx
  80451d:	d3 ea                	shr    %cl,%edx
  80451f:	09 d0                	or     %edx,%eax
  804521:	89 e9                	mov    %ebp,%ecx
  804523:	d3 eb                	shr    %cl,%ebx
  804525:	89 da                	mov    %ebx,%edx
  804527:	83 c4 1c             	add    $0x1c,%esp
  80452a:	5b                   	pop    %ebx
  80452b:	5e                   	pop    %esi
  80452c:	5f                   	pop    %edi
  80452d:	5d                   	pop    %ebp
  80452e:	c3                   	ret    
  80452f:	90                   	nop
  804530:	89 fd                	mov    %edi,%ebp
  804532:	85 ff                	test   %edi,%edi
  804534:	75 0b                	jne    804541 <__umoddi3+0xe9>
  804536:	b8 01 00 00 00       	mov    $0x1,%eax
  80453b:	31 d2                	xor    %edx,%edx
  80453d:	f7 f7                	div    %edi
  80453f:	89 c5                	mov    %eax,%ebp
  804541:	89 f0                	mov    %esi,%eax
  804543:	31 d2                	xor    %edx,%edx
  804545:	f7 f5                	div    %ebp
  804547:	89 c8                	mov    %ecx,%eax
  804549:	f7 f5                	div    %ebp
  80454b:	89 d0                	mov    %edx,%eax
  80454d:	e9 44 ff ff ff       	jmp    804496 <__umoddi3+0x3e>
  804552:	66 90                	xchg   %ax,%ax
  804554:	89 c8                	mov    %ecx,%eax
  804556:	89 f2                	mov    %esi,%edx
  804558:	83 c4 1c             	add    $0x1c,%esp
  80455b:	5b                   	pop    %ebx
  80455c:	5e                   	pop    %esi
  80455d:	5f                   	pop    %edi
  80455e:	5d                   	pop    %ebp
  80455f:	c3                   	ret    
  804560:	3b 04 24             	cmp    (%esp),%eax
  804563:	72 06                	jb     80456b <__umoddi3+0x113>
  804565:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804569:	77 0f                	ja     80457a <__umoddi3+0x122>
  80456b:	89 f2                	mov    %esi,%edx
  80456d:	29 f9                	sub    %edi,%ecx
  80456f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804573:	89 14 24             	mov    %edx,(%esp)
  804576:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80457a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80457e:	8b 14 24             	mov    (%esp),%edx
  804581:	83 c4 1c             	add    $0x1c,%esp
  804584:	5b                   	pop    %ebx
  804585:	5e                   	pop    %esi
  804586:	5f                   	pop    %edi
  804587:	5d                   	pop    %ebp
  804588:	c3                   	ret    
  804589:	8d 76 00             	lea    0x0(%esi),%esi
  80458c:	2b 04 24             	sub    (%esp),%eax
  80458f:	19 fa                	sbb    %edi,%edx
  804591:	89 d1                	mov    %edx,%ecx
  804593:	89 c6                	mov    %eax,%esi
  804595:	e9 71 ff ff ff       	jmp    80450b <__umoddi3+0xb3>
  80459a:	66 90                	xchg   %ax,%ax
  80459c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045a0:	72 ea                	jb     80458c <__umoddi3+0x134>
  8045a2:	89 d9                	mov    %ebx,%ecx
  8045a4:	e9 62 ff ff ff       	jmp    80450b <__umoddi3+0xb3>
