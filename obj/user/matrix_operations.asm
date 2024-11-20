
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
  80005e:	e8 ef 1c 00 00       	call   801d52 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 60 27 80 00       	push   $0x802760
  80006b:	e8 a9 0b 00 00       	call   800c19 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 64 27 80 00       	push   $0x802764
  80007b:	e8 99 0b 00 00       	call   800c19 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 88 27 80 00       	push   $0x802788
  80008b:	e8 89 0b 00 00       	call   800c19 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 64 27 80 00       	push   $0x802764
  80009b:	e8 79 0b 00 00       	call   800c19 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 60 27 80 00       	push   $0x802760
  8000ab:	e8 69 0b 00 00       	call   800c19 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 ac 27 80 00       	push   $0x8027ac
  8000c2:	e8 e6 11 00 00       	call   8012ad <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 38 17 00 00       	call   801815 <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 cc 27 80 00       	push   $0x8027cc
  8000eb:	e8 29 0b 00 00       	call   800c19 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 ee 27 80 00       	push   $0x8027ee
  8000fb:	e8 19 0b 00 00       	call   800c19 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 fc 27 80 00       	push   $0x8027fc
  80010b:	e8 09 0b 00 00       	call   800c19 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 0a 28 80 00       	push   $0x80280a
  80011b:	e8 f9 0a 00 00       	call   800c19 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 1a 28 80 00       	push   $0x80281a
  80012b:	e8 e9 0a 00 00       	call   800c19 <cprintf>
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
  80017a:	68 24 28 80 00       	push   $0x802824
  80017f:	e8 29 11 00 00       	call   8012ad <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 7b 16 00 00       	call   801815 <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 c7 1b 00 00       	call   801d6c <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 1d 1a 00 00       	call   801bd1 <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 08 1a 00 00       	call   801bd1 <malloc>
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
  8001f2:	e8 da 19 00 00       	call   801bd1 <malloc>
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
  800216:	e8 b6 19 00 00       	call   801bd1 <malloc>
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
  8002d2:	e8 7b 1a 00 00       	call   801d52 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 48 28 80 00       	push   $0x802848
  8002df:	e8 35 09 00 00       	call   800c19 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 66 28 80 00       	push   $0x802866
  8002ef:	e8 25 09 00 00       	call   800c19 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 7d 28 80 00       	push   $0x80287d
  8002ff:	e8 15 09 00 00       	call   800c19 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 94 28 80 00       	push   $0x802894
  80030f:	e8 05 09 00 00       	call   800c19 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 1a 28 80 00       	push   $0x80281a
  80031f:	e8 f5 08 00 00       	call   800c19 <cprintf>
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
  80035e:	e8 09 1a 00 00       	call   801d6c <sys_unlock_cons>


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
  8003df:	e8 6e 19 00 00       	call   801d52 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 ab 28 80 00       	push   $0x8028ab
  8003ec:	e8 28 08 00 00       	call   800c19 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 73 19 00 00       	call   801d6c <sys_unlock_cons>

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
  800417:	e8 de 17 00 00       	call   801bfa <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 c1 17 00 00       	call   801bfa <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 a4 17 00 00       	call   801bfa <free>
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
  80046a:	e8 8b 17 00 00       	call   801bfa <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 7d 17 00 00       	call   801bfa <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 6f 17 00 00       	call   801bfa <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 bf 18 00 00       	call   801d52 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 c4 28 80 00       	push   $0x8028c4
  80049b:	e8 79 07 00 00       	call   800c19 <cprintf>
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
  8004c8:	e8 9f 18 00 00       	call   801d6c <sys_unlock_cons>

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
  8004f0:	e8 dc 16 00 00       	call   801bd1 <malloc>
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
  80051e:	e8 ae 16 00 00       	call   801bd1 <malloc>
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
  80063e:	e8 8e 15 00 00       	call   801bd1 <malloc>
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
  80066c:	e8 60 15 00 00       	call   801bd1 <malloc>
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
  80071a:	e8 b2 14 00 00       	call   801bd1 <malloc>
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
  800748:	e8 84 14 00 00       	call   801bd1 <malloc>
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
  8008bf:	e8 56 17 00 00       	call   80201a <sys_get_virtual_time>
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
  80092b:	68 e2 28 80 00       	push   $0x8028e2
  800930:	e8 e4 02 00 00       	call   800c19 <cprintf>
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
  800946:	68 e9 28 80 00       	push   $0x8028e9
  80094b:	e8 c9 02 00 00       	call   800c19 <cprintf>
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
  80099c:	68 ed 28 80 00       	push   $0x8028ed
  8009a1:	e8 73 02 00 00       	call   800c19 <cprintf>
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
  8009b7:	68 e9 28 80 00       	push   $0x8028e9
  8009bc:	e8 58 02 00 00       	call   800c19 <cprintf>
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
  8009e6:	e8 b2 14 00 00       	call   801e9d <sys_cputc>
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
  8009f7:	e8 3d 13 00 00       	call   801d39 <sys_cgetc>
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
  800a14:	e8 b5 15 00 00       	call   801fce <sys_getenvindex>
  800a19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	c1 e0 02             	shl    $0x2,%eax
  800a24:	01 d0                	add    %edx,%eax
  800a26:	01 c0                	add    %eax,%eax
  800a28:	01 d0                	add    %edx,%eax
  800a2a:	c1 e0 02             	shl    $0x2,%eax
  800a2d:	01 d0                	add    %edx,%eax
  800a2f:	01 c0                	add    %eax,%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	c1 e0 04             	shl    $0x4,%eax
  800a36:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a3b:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a40:	a1 04 30 80 00       	mov    0x803004,%eax
  800a45:	8a 40 20             	mov    0x20(%eax),%al
  800a48:	84 c0                	test   %al,%al
  800a4a:	74 0d                	je     800a59 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800a4c:	a1 04 30 80 00       	mov    0x803004,%eax
  800a51:	83 c0 20             	add    $0x20,%eax
  800a54:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a5d:	7e 0a                	jle    800a69 <libmain+0x5b>
		binaryname = argv[0];
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	ff 75 08             	pushl  0x8(%ebp)
  800a72:	e8 c1 f5 ff ff       	call   800038 <_main>
  800a77:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800a7a:	e8 d3 12 00 00       	call   801d52 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	68 10 29 80 00       	push   $0x802910
  800a87:	e8 8d 01 00 00       	call   800c19 <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a8f:	a1 04 30 80 00       	mov    0x803004,%eax
  800a94:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800a9a:	a1 04 30 80 00       	mov    0x803004,%eax
  800a9f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	52                   	push   %edx
  800aa9:	50                   	push   %eax
  800aaa:	68 38 29 80 00       	push   $0x802938
  800aaf:	e8 65 01 00 00       	call   800c19 <cprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ab7:	a1 04 30 80 00       	mov    0x803004,%eax
  800abc:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800ac2:	a1 04 30 80 00       	mov    0x803004,%eax
  800ac7:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800acd:	a1 04 30 80 00       	mov    0x803004,%eax
  800ad2:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800ad8:	51                   	push   %ecx
  800ad9:	52                   	push   %edx
  800ada:	50                   	push   %eax
  800adb:	68 60 29 80 00       	push   $0x802960
  800ae0:	e8 34 01 00 00       	call   800c19 <cprintf>
  800ae5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ae8:	a1 04 30 80 00       	mov    0x803004,%eax
  800aed:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	50                   	push   %eax
  800af7:	68 b8 29 80 00       	push   $0x8029b8
  800afc:	e8 18 01 00 00       	call   800c19 <cprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b04:	83 ec 0c             	sub    $0xc,%esp
  800b07:	68 10 29 80 00       	push   $0x802910
  800b0c:	e8 08 01 00 00       	call   800c19 <cprintf>
  800b11:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b14:	e8 53 12 00 00       	call   801d6c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800b19:	e8 19 00 00 00       	call   800b37 <exit>
}
  800b1e:	90                   	nop
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800b27:	83 ec 0c             	sub    $0xc,%esp
  800b2a:	6a 00                	push   $0x0
  800b2c:	e8 69 14 00 00       	call   801f9a <sys_destroy_env>
  800b31:	83 c4 10             	add    $0x10,%esp
}
  800b34:	90                   	nop
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <exit>:

void
exit(void)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800b3d:	e8 be 14 00 00       	call   802000 <sys_exit_env>
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	8d 48 01             	lea    0x1(%eax),%ecx
  800b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b56:	89 0a                	mov    %ecx,(%edx)
  800b58:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5b:	88 d1                	mov    %dl,%cl
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b6e:	75 2c                	jne    800b9c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b70:	a0 08 30 80 00       	mov    0x803008,%al
  800b75:	0f b6 c0             	movzbl %al,%eax
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	8b 12                	mov    (%edx),%edx
  800b7d:	89 d1                	mov    %edx,%ecx
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	83 c2 08             	add    $0x8,%edx
  800b85:	83 ec 04             	sub    $0x4,%esp
  800b88:	50                   	push   %eax
  800b89:	51                   	push   %ecx
  800b8a:	52                   	push   %edx
  800b8b:	e8 80 11 00 00       	call   801d10 <sys_cputs>
  800b90:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	8b 40 04             	mov    0x4(%eax),%eax
  800ba2:	8d 50 01             	lea    0x1(%eax),%edx
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bab:	90                   	nop
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bb7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bbe:	00 00 00 
	b.cnt = 0;
  800bc1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bc8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	ff 75 08             	pushl  0x8(%ebp)
  800bd1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	68 45 0b 80 00       	push   $0x800b45
  800bdd:	e8 11 02 00 00       	call   800df3 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800be5:	a0 08 30 80 00       	mov    0x803008,%al
  800bea:	0f b6 c0             	movzbl %al,%eax
  800bed:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800bf3:	83 ec 04             	sub    $0x4,%esp
  800bf6:	50                   	push   %eax
  800bf7:	52                   	push   %edx
  800bf8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bfe:	83 c0 08             	add    $0x8,%eax
  800c01:	50                   	push   %eax
  800c02:	e8 09 11 00 00       	call   801d10 <sys_cputs>
  800c07:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c0a:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800c11:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c1f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800c26:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 f4             	pushl  -0xc(%ebp)
  800c35:	50                   	push   %eax
  800c36:	e8 73 ff ff ff       	call   800bae <vcprintf>
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c4c:	e8 01 11 00 00       	call   801d52 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c51:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	e8 48 ff ff ff       	call   800bae <vcprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c6c:	e8 fb 10 00 00       	call   801d6c <sys_unlock_cons>
	return cnt;
  800c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	53                   	push   %ebx
  800c7a:	83 ec 14             	sub    $0x14,%esp
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c83:	8b 45 14             	mov    0x14(%ebp),%eax
  800c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c89:	8b 45 18             	mov    0x18(%ebp),%eax
  800c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c91:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c94:	77 55                	ja     800ceb <printnum+0x75>
  800c96:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c99:	72 05                	jb     800ca0 <printnum+0x2a>
  800c9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c9e:	77 4b                	ja     800ceb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ca3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ca6:	8b 45 18             	mov    0x18(%ebp),%eax
  800ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cae:	52                   	push   %edx
  800caf:	50                   	push   %eax
  800cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb6:	e8 3d 18 00 00       	call   8024f8 <__udivdi3>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	ff 75 20             	pushl  0x20(%ebp)
  800cc4:	53                   	push   %ebx
  800cc5:	ff 75 18             	pushl  0x18(%ebp)
  800cc8:	52                   	push   %edx
  800cc9:	50                   	push   %eax
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	ff 75 08             	pushl  0x8(%ebp)
  800cd0:	e8 a1 ff ff ff       	call   800c76 <printnum>
  800cd5:	83 c4 20             	add    $0x20,%esp
  800cd8:	eb 1a                	jmp    800cf4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 20             	pushl  0x20(%ebp)
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	ff d0                	call   *%eax
  800ce8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ceb:	ff 4d 1c             	decl   0x1c(%ebp)
  800cee:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cf2:	7f e6                	jg     800cda <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cf4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cf7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d02:	53                   	push   %ebx
  800d03:	51                   	push   %ecx
  800d04:	52                   	push   %edx
  800d05:	50                   	push   %eax
  800d06:	e8 fd 18 00 00       	call   802608 <__umoddi3>
  800d0b:	83 c4 10             	add    $0x10,%esp
  800d0e:	05 f4 2b 80 00       	add    $0x802bf4,%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	0f be c0             	movsbl %al,%eax
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	50                   	push   %eax
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	ff d0                	call   *%eax
  800d24:	83 c4 10             	add    $0x10,%esp
}
  800d27:	90                   	nop
  800d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d30:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d34:	7e 1c                	jle    800d52 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8b 00                	mov    (%eax),%eax
  800d3b:	8d 50 08             	lea    0x8(%eax),%edx
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 10                	mov    %edx,(%eax)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 e8 08             	sub    $0x8,%eax
  800d4b:	8b 50 04             	mov    0x4(%eax),%edx
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	eb 40                	jmp    800d92 <getuint+0x65>
	else if (lflag)
  800d52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d56:	74 1e                	je     800d76 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	8d 50 04             	lea    0x4(%eax),%edx
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	89 10                	mov    %edx,(%eax)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	83 e8 04             	sub    $0x4,%eax
  800d6d:	8b 00                	mov    (%eax),%eax
  800d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d74:	eb 1c                	jmp    800d92 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8b 00                	mov    (%eax),%eax
  800d7b:	8d 50 04             	lea    0x4(%eax),%edx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	89 10                	mov    %edx,(%eax)
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8b 00                	mov    (%eax),%eax
  800d88:	83 e8 04             	sub    $0x4,%eax
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d97:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d9b:	7e 1c                	jle    800db9 <getint+0x25>
		return va_arg(*ap, long long);
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	8d 50 08             	lea    0x8(%eax),%edx
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 10                	mov    %edx,(%eax)
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8b 00                	mov    (%eax),%eax
  800daf:	83 e8 08             	sub    $0x8,%eax
  800db2:	8b 50 04             	mov    0x4(%eax),%edx
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	eb 38                	jmp    800df1 <getint+0x5d>
	else if (lflag)
  800db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbd:	74 1a                	je     800dd9 <getint+0x45>
		return va_arg(*ap, long);
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8b 00                	mov    (%eax),%eax
  800dc4:	8d 50 04             	lea    0x4(%eax),%edx
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 10                	mov    %edx,(%eax)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	83 e8 04             	sub    $0x4,%eax
  800dd4:	8b 00                	mov    (%eax),%eax
  800dd6:	99                   	cltd   
  800dd7:	eb 18                	jmp    800df1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	8d 50 04             	lea    0x4(%eax),%edx
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	89 10                	mov    %edx,(%eax)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8b 00                	mov    (%eax),%eax
  800deb:	83 e8 04             	sub    $0x4,%eax
  800dee:	8b 00                	mov    (%eax),%eax
  800df0:	99                   	cltd   
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfb:	eb 17                	jmp    800e14 <vprintfmt+0x21>
			if (ch == '\0')
  800dfd:	85 db                	test   %ebx,%ebx
  800dff:	0f 84 c1 03 00 00    	je     8011c6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	ff 75 0c             	pushl  0xc(%ebp)
  800e0b:	53                   	push   %ebx
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	ff d0                	call   *%eax
  800e11:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	8d 50 01             	lea    0x1(%eax),%edx
  800e1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	0f b6 d8             	movzbl %al,%ebx
  800e22:	83 fb 25             	cmp    $0x25,%ebx
  800e25:	75 d6                	jne    800dfd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e27:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e2b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e32:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e39:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e40:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	8d 50 01             	lea    0x1(%eax),%edx
  800e4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	0f b6 d8             	movzbl %al,%ebx
  800e55:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e58:	83 f8 5b             	cmp    $0x5b,%eax
  800e5b:	0f 87 3d 03 00 00    	ja     80119e <vprintfmt+0x3ab>
  800e61:	8b 04 85 18 2c 80 00 	mov    0x802c18(,%eax,4),%eax
  800e68:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e6a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e6e:	eb d7                	jmp    800e47 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e70:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e74:	eb d1                	jmp    800e47 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e80:	89 d0                	mov    %edx,%eax
  800e82:	c1 e0 02             	shl    $0x2,%eax
  800e85:	01 d0                	add    %edx,%eax
  800e87:	01 c0                	add    %eax,%eax
  800e89:	01 d8                	add    %ebx,%eax
  800e8b:	83 e8 30             	sub    $0x30,%eax
  800e8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e99:	83 fb 2f             	cmp    $0x2f,%ebx
  800e9c:	7e 3e                	jle    800edc <vprintfmt+0xe9>
  800e9e:	83 fb 39             	cmp    $0x39,%ebx
  800ea1:	7f 39                	jg     800edc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ea6:	eb d5                	jmp    800e7d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ebc:	eb 1f                	jmp    800edd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ebe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec2:	79 83                	jns    800e47 <vprintfmt+0x54>
				width = 0;
  800ec4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ecb:	e9 77 ff ff ff       	jmp    800e47 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ed0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ed7:	e9 6b ff ff ff       	jmp    800e47 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800edc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800edd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee1:	0f 89 60 ff ff ff    	jns    800e47 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ee7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ef4:	e9 4e ff ff ff       	jmp    800e47 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ef9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800efc:	e9 46 ff ff ff       	jmp    800e47 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f01:	8b 45 14             	mov    0x14(%ebp),%eax
  800f04:	83 c0 04             	add    $0x4,%eax
  800f07:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0d:	83 e8 04             	sub    $0x4,%eax
  800f10:	8b 00                	mov    (%eax),%eax
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	ff 75 0c             	pushl  0xc(%ebp)
  800f18:	50                   	push   %eax
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	ff d0                	call   *%eax
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 9b 02 00 00       	jmp    8011c1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f37:	85 db                	test   %ebx,%ebx
  800f39:	79 02                	jns    800f3d <vprintfmt+0x14a>
				err = -err;
  800f3b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f3d:	83 fb 64             	cmp    $0x64,%ebx
  800f40:	7f 0b                	jg     800f4d <vprintfmt+0x15a>
  800f42:	8b 34 9d 60 2a 80 00 	mov    0x802a60(,%ebx,4),%esi
  800f49:	85 f6                	test   %esi,%esi
  800f4b:	75 19                	jne    800f66 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f4d:	53                   	push   %ebx
  800f4e:	68 05 2c 80 00       	push   $0x802c05
  800f53:	ff 75 0c             	pushl  0xc(%ebp)
  800f56:	ff 75 08             	pushl  0x8(%ebp)
  800f59:	e8 70 02 00 00       	call   8011ce <printfmt>
  800f5e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f61:	e9 5b 02 00 00       	jmp    8011c1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f66:	56                   	push   %esi
  800f67:	68 0e 2c 80 00       	push   $0x802c0e
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	ff 75 08             	pushl  0x8(%ebp)
  800f72:	e8 57 02 00 00       	call   8011ce <printfmt>
  800f77:	83 c4 10             	add    $0x10,%esp
			break;
  800f7a:	e9 42 02 00 00       	jmp    8011c1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f82:	83 c0 04             	add    $0x4,%eax
  800f85:	89 45 14             	mov    %eax,0x14(%ebp)
  800f88:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8b:	83 e8 04             	sub    $0x4,%eax
  800f8e:	8b 30                	mov    (%eax),%esi
  800f90:	85 f6                	test   %esi,%esi
  800f92:	75 05                	jne    800f99 <vprintfmt+0x1a6>
				p = "(null)";
  800f94:	be 11 2c 80 00       	mov    $0x802c11,%esi
			if (width > 0 && padc != '-')
  800f99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f9d:	7e 6d                	jle    80100c <vprintfmt+0x219>
  800f9f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fa3:	74 67                	je     80100c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	50                   	push   %eax
  800fac:	56                   	push   %esi
  800fad:	e8 26 05 00 00       	call   8014d8 <strnlen>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fb8:	eb 16                	jmp    800fd0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fba:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	50                   	push   %eax
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	ff d0                	call   *%eax
  800fca:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fcd:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd4:	7f e4                	jg     800fba <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd6:	eb 34                	jmp    80100c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fdc:	74 1c                	je     800ffa <vprintfmt+0x207>
  800fde:	83 fb 1f             	cmp    $0x1f,%ebx
  800fe1:	7e 05                	jle    800fe8 <vprintfmt+0x1f5>
  800fe3:	83 fb 7e             	cmp    $0x7e,%ebx
  800fe6:	7e 12                	jle    800ffa <vprintfmt+0x207>
					putch('?', putdat);
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	ff 75 0c             	pushl  0xc(%ebp)
  800fee:	6a 3f                	push   $0x3f
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	ff d0                	call   *%eax
  800ff5:	83 c4 10             	add    $0x10,%esp
  800ff8:	eb 0f                	jmp    801009 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	ff 75 0c             	pushl  0xc(%ebp)
  801000:	53                   	push   %ebx
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801009:	ff 4d e4             	decl   -0x1c(%ebp)
  80100c:	89 f0                	mov    %esi,%eax
  80100e:	8d 70 01             	lea    0x1(%eax),%esi
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be d8             	movsbl %al,%ebx
  801016:	85 db                	test   %ebx,%ebx
  801018:	74 24                	je     80103e <vprintfmt+0x24b>
  80101a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80101e:	78 b8                	js     800fd8 <vprintfmt+0x1e5>
  801020:	ff 4d e0             	decl   -0x20(%ebp)
  801023:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801027:	79 af                	jns    800fd8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801029:	eb 13                	jmp    80103e <vprintfmt+0x24b>
				putch(' ', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 20                	push   $0x20
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103b:	ff 4d e4             	decl   -0x1c(%ebp)
  80103e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801042:	7f e7                	jg     80102b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801044:	e9 78 01 00 00       	jmp    8011c1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	ff 75 e8             	pushl  -0x18(%ebp)
  80104f:	8d 45 14             	lea    0x14(%ebp),%eax
  801052:	50                   	push   %eax
  801053:	e8 3c fd ff ff       	call   800d94 <getint>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801067:	85 d2                	test   %edx,%edx
  801069:	79 23                	jns    80108e <vprintfmt+0x29b>
				putch('-', putdat);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	6a 2d                	push   $0x2d
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	ff d0                	call   *%eax
  801078:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80107b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801081:	f7 d8                	neg    %eax
  801083:	83 d2 00             	adc    $0x0,%edx
  801086:	f7 da                	neg    %edx
  801088:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80108e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a3:	50                   	push   %eax
  8010a4:	e8 84 fc ff ff       	call   800d2d <getuint>
  8010a9:	83 c4 10             	add    $0x10,%esp
  8010ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010b2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010b9:	e9 98 00 00 00       	jmp    801156 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	6a 58                	push   $0x58
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	ff d0                	call   *%eax
  8010cb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	6a 58                	push   $0x58
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	6a 58                	push   $0x58
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	ff d0                	call   *%eax
  8010eb:	83 c4 10             	add    $0x10,%esp
			break;
  8010ee:	e9 ce 00 00 00       	jmp    8011c1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010f3:	83 ec 08             	sub    $0x8,%esp
  8010f6:	ff 75 0c             	pushl  0xc(%ebp)
  8010f9:	6a 30                	push   $0x30
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	ff d0                	call   *%eax
  801100:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	6a 78                	push   $0x78
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	ff d0                	call   *%eax
  801110:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	83 c0 04             	add    $0x4,%eax
  801119:	89 45 14             	mov    %eax,0x14(%ebp)
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	83 e8 04             	sub    $0x4,%eax
  801122:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801124:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80112e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801135:	eb 1f                	jmp    801156 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801137:	83 ec 08             	sub    $0x8,%esp
  80113a:	ff 75 e8             	pushl  -0x18(%ebp)
  80113d:	8d 45 14             	lea    0x14(%ebp),%eax
  801140:	50                   	push   %eax
  801141:	e8 e7 fb ff ff       	call   800d2d <getuint>
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80114f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801156:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80115a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80115d:	83 ec 04             	sub    $0x4,%esp
  801160:	52                   	push   %edx
  801161:	ff 75 e4             	pushl  -0x1c(%ebp)
  801164:	50                   	push   %eax
  801165:	ff 75 f4             	pushl  -0xc(%ebp)
  801168:	ff 75 f0             	pushl  -0x10(%ebp)
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	e8 00 fb ff ff       	call   800c76 <printnum>
  801176:	83 c4 20             	add    $0x20,%esp
			break;
  801179:	eb 46                	jmp    8011c1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	53                   	push   %ebx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	ff d0                	call   *%eax
  801187:	83 c4 10             	add    $0x10,%esp
			break;
  80118a:	eb 35                	jmp    8011c1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80118c:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  801193:	eb 2c                	jmp    8011c1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801195:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80119c:	eb 23                	jmp    8011c1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 0c             	pushl  0xc(%ebp)
  8011a4:	6a 25                	push   $0x25
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011ae:	ff 4d 10             	decl   0x10(%ebp)
  8011b1:	eb 03                	jmp    8011b6 <vprintfmt+0x3c3>
  8011b3:	ff 4d 10             	decl   0x10(%ebp)
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	48                   	dec    %eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 25                	cmp    $0x25,%al
  8011be:	75 f3                	jne    8011b3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011c0:	90                   	nop
		}
	}
  8011c1:	e9 35 fc ff ff       	jmp    800dfb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011c6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ca:	5b                   	pop    %ebx
  8011cb:	5e                   	pop    %esi
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8011d7:	83 c0 04             	add    $0x4,%eax
  8011da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e3:	50                   	push   %eax
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	e8 04 fc ff ff       	call   800df3 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011f2:	90                   	nop
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	8b 40 08             	mov    0x8(%eax),%eax
  8011fe:	8d 50 01             	lea    0x1(%eax),%edx
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8b 10                	mov    (%eax),%edx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	8b 40 04             	mov    0x4(%eax),%eax
  801212:	39 c2                	cmp    %eax,%edx
  801214:	73 12                	jae    801228 <sprintputch+0x33>
		*b->buf++ = ch;
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	8d 48 01             	lea    0x1(%eax),%ecx
  80121e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801221:	89 0a                	mov    %ecx,(%edx)
  801223:	8b 55 08             	mov    0x8(%ebp),%edx
  801226:	88 10                	mov    %dl,(%eax)
}
  801228:	90                   	nop
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801245:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80124c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801250:	74 06                	je     801258 <vsnprintf+0x2d>
  801252:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801256:	7f 07                	jg     80125f <vsnprintf+0x34>
		return -E_INVAL;
  801258:	b8 03 00 00 00       	mov    $0x3,%eax
  80125d:	eb 20                	jmp    80127f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80125f:	ff 75 14             	pushl  0x14(%ebp)
  801262:	ff 75 10             	pushl  0x10(%ebp)
  801265:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	68 f5 11 80 00       	push   $0x8011f5
  80126e:	e8 80 fb ff ff       	call   800df3 <vprintfmt>
  801273:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801287:	8d 45 10             	lea    0x10(%ebp),%eax
  80128a:	83 c0 04             	add    $0x4,%eax
  80128d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801290:	8b 45 10             	mov    0x10(%ebp),%eax
  801293:	ff 75 f4             	pushl  -0xc(%ebp)
  801296:	50                   	push   %eax
  801297:	ff 75 0c             	pushl  0xc(%ebp)
  80129a:	ff 75 08             	pushl  0x8(%ebp)
  80129d:	e8 89 ff ff ff       	call   80122b <vsnprintf>
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b7:	74 13                	je     8012cc <readline+0x1f>
		cprintf("%s", prompt);
  8012b9:	83 ec 08             	sub    $0x8,%esp
  8012bc:	ff 75 08             	pushl  0x8(%ebp)
  8012bf:	68 88 2d 80 00       	push   $0x802d88
  8012c4:	e8 50 f9 ff ff       	call   800c19 <cprintf>
  8012c9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	6a 00                	push   $0x0
  8012d8:	e8 27 f7 ff ff       	call   800a04 <iscons>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012e3:	e8 09 f7 ff ff       	call   8009f1 <getchar>
  8012e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ef:	79 22                	jns    801313 <readline+0x66>
			if (c != -E_EOF)
  8012f1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012f5:	0f 84 ad 00 00 00    	je     8013a8 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801301:	68 8b 2d 80 00       	push   $0x802d8b
  801306:	e8 0e f9 ff ff       	call   800c19 <cprintf>
  80130b:	83 c4 10             	add    $0x10,%esp
			break;
  80130e:	e9 95 00 00 00       	jmp    8013a8 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801313:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801317:	7e 34                	jle    80134d <readline+0xa0>
  801319:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801320:	7f 2b                	jg     80134d <readline+0xa0>
			if (echoing)
  801322:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801326:	74 0e                	je     801336 <readline+0x89>
				cputchar(c);
  801328:	83 ec 0c             	sub    $0xc,%esp
  80132b:	ff 75 ec             	pushl  -0x14(%ebp)
  80132e:	e8 9f f6 ff ff       	call   8009d2 <cputchar>
  801333:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80133f:	89 c2                	mov    %eax,%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801349:	88 10                	mov    %dl,(%eax)
  80134b:	eb 56                	jmp    8013a3 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80134d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801351:	75 1f                	jne    801372 <readline+0xc5>
  801353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801357:	7e 19                	jle    801372 <readline+0xc5>
			if (echoing)
  801359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135d:	74 0e                	je     80136d <readline+0xc0>
				cputchar(c);
  80135f:	83 ec 0c             	sub    $0xc,%esp
  801362:	ff 75 ec             	pushl  -0x14(%ebp)
  801365:	e8 68 f6 ff ff       	call   8009d2 <cputchar>
  80136a:	83 c4 10             	add    $0x10,%esp

			i--;
  80136d:	ff 4d f4             	decl   -0xc(%ebp)
  801370:	eb 31                	jmp    8013a3 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801372:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801376:	74 0a                	je     801382 <readline+0xd5>
  801378:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80137c:	0f 85 61 ff ff ff    	jne    8012e3 <readline+0x36>
			if (echoing)
  801382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801386:	74 0e                	je     801396 <readline+0xe9>
				cputchar(c);
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	ff 75 ec             	pushl  -0x14(%ebp)
  80138e:	e8 3f f6 ff ff       	call   8009d2 <cputchar>
  801393:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801396:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139c:	01 d0                	add    %edx,%eax
  80139e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013a1:	eb 06                	jmp    8013a9 <readline+0xfc>
		}
	}
  8013a3:	e9 3b ff ff ff       	jmp    8012e3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013a8:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013b2:	e8 9b 09 00 00       	call   801d52 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bb:	74 13                	je     8013d0 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 08             	pushl  0x8(%ebp)
  8013c3:	68 88 2d 80 00       	push   $0x802d88
  8013c8:	e8 4c f8 ff ff       	call   800c19 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	6a 00                	push   $0x0
  8013dc:	e8 23 f6 ff ff       	call   800a04 <iscons>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013e7:	e8 05 f6 ff ff       	call   8009f1 <getchar>
  8013ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013f3:	79 22                	jns    801417 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013f5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013f9:	0f 84 ad 00 00 00    	je     8014ac <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	ff 75 ec             	pushl  -0x14(%ebp)
  801405:	68 8b 2d 80 00       	push   $0x802d8b
  80140a:	e8 0a f8 ff ff       	call   800c19 <cprintf>
  80140f:	83 c4 10             	add    $0x10,%esp
				break;
  801412:	e9 95 00 00 00       	jmp    8014ac <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801417:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80141b:	7e 34                	jle    801451 <atomic_readline+0xa5>
  80141d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801424:	7f 2b                	jg     801451 <atomic_readline+0xa5>
				if (echoing)
  801426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142a:	74 0e                	je     80143a <atomic_readline+0x8e>
					cputchar(c);
  80142c:	83 ec 0c             	sub    $0xc,%esp
  80142f:	ff 75 ec             	pushl  -0x14(%ebp)
  801432:	e8 9b f5 ff ff       	call   8009d2 <cputchar>
  801437:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80143a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143d:	8d 50 01             	lea    0x1(%eax),%edx
  801440:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801443:	89 c2                	mov    %eax,%edx
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80144d:	88 10                	mov    %dl,(%eax)
  80144f:	eb 56                	jmp    8014a7 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801451:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801455:	75 1f                	jne    801476 <atomic_readline+0xca>
  801457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80145b:	7e 19                	jle    801476 <atomic_readline+0xca>
				if (echoing)
  80145d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801461:	74 0e                	je     801471 <atomic_readline+0xc5>
					cputchar(c);
  801463:	83 ec 0c             	sub    $0xc,%esp
  801466:	ff 75 ec             	pushl  -0x14(%ebp)
  801469:	e8 64 f5 ff ff       	call   8009d2 <cputchar>
  80146e:	83 c4 10             	add    $0x10,%esp
				i--;
  801471:	ff 4d f4             	decl   -0xc(%ebp)
  801474:	eb 31                	jmp    8014a7 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801476:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80147a:	74 0a                	je     801486 <atomic_readline+0xda>
  80147c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801480:	0f 85 61 ff ff ff    	jne    8013e7 <atomic_readline+0x3b>
				if (echoing)
  801486:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148a:	74 0e                	je     80149a <atomic_readline+0xee>
					cputchar(c);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	ff 75 ec             	pushl  -0x14(%ebp)
  801492:	e8 3b f5 ff ff       	call   8009d2 <cputchar>
  801497:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80149a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	01 d0                	add    %edx,%eax
  8014a2:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014a5:	eb 06                	jmp    8014ad <atomic_readline+0x101>
			}
		}
  8014a7:	e9 3b ff ff ff       	jmp    8013e7 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014ac:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014ad:	e8 ba 08 00 00       	call   801d6c <sys_unlock_cons>
}
  8014b2:	90                   	nop
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c2:	eb 06                	jmp    8014ca <strlen+0x15>
		n++;
  8014c4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c7:	ff 45 08             	incl   0x8(%ebp)
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 f1                	jne    8014c4 <strlen+0xf>
		n++;
	return n;
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e5:	eb 09                	jmp    8014f0 <strnlen+0x18>
		n++;
  8014e7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 4d 0c             	decl   0xc(%ebp)
  8014f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f4:	74 09                	je     8014ff <strnlen+0x27>
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	84 c0                	test   %al,%al
  8014fd:	75 e8                	jne    8014e7 <strnlen+0xf>
		n++;
	return n;
  8014ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801510:	90                   	nop
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8d 50 01             	lea    0x1(%eax),%edx
  801517:	89 55 08             	mov    %edx,0x8(%ebp)
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801520:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801523:	8a 12                	mov    (%edx),%dl
  801525:	88 10                	mov    %dl,(%eax)
  801527:	8a 00                	mov    (%eax),%al
  801529:	84 c0                	test   %al,%al
  80152b:	75 e4                	jne    801511 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80152d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80153e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801545:	eb 1f                	jmp    801566 <strncpy+0x34>
		*dst++ = *src;
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8d 50 01             	lea    0x1(%eax),%edx
  80154d:	89 55 08             	mov    %edx,0x8(%ebp)
  801550:	8b 55 0c             	mov    0xc(%ebp),%edx
  801553:	8a 12                	mov    (%edx),%dl
  801555:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	84 c0                	test   %al,%al
  80155e:	74 03                	je     801563 <strncpy+0x31>
			src++;
  801560:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801563:	ff 45 fc             	incl   -0x4(%ebp)
  801566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801569:	3b 45 10             	cmp    0x10(%ebp),%eax
  80156c:	72 d9                	jb     801547 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80156e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80157f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801583:	74 30                	je     8015b5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801585:	eb 16                	jmp    80159d <strlcpy+0x2a>
			*dst++ = *src++;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8d 50 01             	lea    0x1(%eax),%edx
  80158d:	89 55 08             	mov    %edx,0x8(%ebp)
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
  801593:	8d 4a 01             	lea    0x1(%edx),%ecx
  801596:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801599:	8a 12                	mov    (%edx),%dl
  80159b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80159d:	ff 4d 10             	decl   0x10(%ebp)
  8015a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a4:	74 09                	je     8015af <strlcpy+0x3c>
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	84 c0                	test   %al,%al
  8015ad:	75 d8                	jne    801587 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bb:	29 c2                	sub    %eax,%edx
  8015bd:	89 d0                	mov    %edx,%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015c4:	eb 06                	jmp    8015cc <strcmp+0xb>
		p++, q++;
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	84 c0                	test   %al,%al
  8015d3:	74 0e                	je     8015e3 <strcmp+0x22>
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8a 10                	mov    (%eax),%dl
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	38 c2                	cmp    %al,%dl
  8015e1:	74 e3                	je     8015c6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	0f b6 d0             	movzbl %al,%edx
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	0f b6 c0             	movzbl %al,%eax
  8015f3:	29 c2                	sub    %eax,%edx
  8015f5:	89 d0                	mov    %edx,%eax
}
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015fc:	eb 09                	jmp    801607 <strncmp+0xe>
		n--, p++, q++;
  8015fe:	ff 4d 10             	decl   0x10(%ebp)
  801601:	ff 45 08             	incl   0x8(%ebp)
  801604:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801607:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160b:	74 17                	je     801624 <strncmp+0x2b>
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	84 c0                	test   %al,%al
  801614:	74 0e                	je     801624 <strncmp+0x2b>
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8a 10                	mov    (%eax),%dl
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	38 c2                	cmp    %al,%dl
  801622:	74 da                	je     8015fe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801624:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801628:	75 07                	jne    801631 <strncmp+0x38>
		return 0;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
  80162f:	eb 14                	jmp    801645 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	0f b6 d0             	movzbl %al,%edx
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	0f b6 c0             	movzbl %al,%eax
  801641:	29 c2                	sub    %eax,%edx
  801643:	89 d0                	mov    %edx,%eax
}
  801645:	5d                   	pop    %ebp
  801646:	c3                   	ret    

00801647 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801653:	eb 12                	jmp    801667 <strchr+0x20>
		if (*s == c)
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80165d:	75 05                	jne    801664 <strchr+0x1d>
			return (char *) s;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	eb 11                	jmp    801675 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801664:	ff 45 08             	incl   0x8(%ebp)
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	84 c0                	test   %al,%al
  80166e:	75 e5                	jne    801655 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801683:	eb 0d                	jmp    801692 <strfind+0x1b>
		if (*s == c)
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80168d:	74 0e                	je     80169d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80168f:	ff 45 08             	incl   0x8(%ebp)
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	84 c0                	test   %al,%al
  801699:	75 ea                	jne    801685 <strfind+0xe>
  80169b:	eb 01                	jmp    80169e <strfind+0x27>
		if (*s == c)
			break;
  80169d:	90                   	nop
	return (char *) s;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016b5:	eb 0e                	jmp    8016c5 <memset+0x22>
		*p++ = c;
  8016b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ba:	8d 50 01             	lea    0x1(%eax),%edx
  8016bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016c5:	ff 4d f8             	decl   -0x8(%ebp)
  8016c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016cc:	79 e9                	jns    8016b7 <memset+0x14>
		*p++ = c;

	return v;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016e5:	eb 16                	jmp    8016fd <memcpy+0x2a>
		*d++ = *s++;
  8016e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ea:	8d 50 01             	lea    0x1(%eax),%edx
  8016ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016f9:	8a 12                	mov    (%edx),%dl
  8016fb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801700:	8d 50 ff             	lea    -0x1(%eax),%edx
  801703:	89 55 10             	mov    %edx,0x10(%ebp)
  801706:	85 c0                	test   %eax,%eax
  801708:	75 dd                	jne    8016e7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801721:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801727:	73 50                	jae    801779 <memmove+0x6a>
  801729:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172c:	8b 45 10             	mov    0x10(%ebp),%eax
  80172f:	01 d0                	add    %edx,%eax
  801731:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801734:	76 43                	jbe    801779 <memmove+0x6a>
		s += n;
  801736:	8b 45 10             	mov    0x10(%ebp),%eax
  801739:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80173c:	8b 45 10             	mov    0x10(%ebp),%eax
  80173f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801742:	eb 10                	jmp    801754 <memmove+0x45>
			*--d = *--s;
  801744:	ff 4d f8             	decl   -0x8(%ebp)
  801747:	ff 4d fc             	decl   -0x4(%ebp)
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	8a 10                	mov    (%eax),%dl
  80174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801752:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	8d 50 ff             	lea    -0x1(%eax),%edx
  80175a:	89 55 10             	mov    %edx,0x10(%ebp)
  80175d:	85 c0                	test   %eax,%eax
  80175f:	75 e3                	jne    801744 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801761:	eb 23                	jmp    801786 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801763:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801766:	8d 50 01             	lea    0x1(%eax),%edx
  801769:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80176c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80176f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801772:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801775:	8a 12                	mov    (%edx),%dl
  801777:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801779:	8b 45 10             	mov    0x10(%ebp),%eax
  80177c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80177f:	89 55 10             	mov    %edx,0x10(%ebp)
  801782:	85 c0                	test   %eax,%eax
  801784:	75 dd                	jne    801763 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80179d:	eb 2a                	jmp    8017c9 <memcmp+0x3e>
		if (*s1 != *s2)
  80179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a2:	8a 10                	mov    (%eax),%dl
  8017a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	38 c2                	cmp    %al,%dl
  8017ab:	74 16                	je     8017c3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	0f b6 d0             	movzbl %al,%edx
  8017b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	0f b6 c0             	movzbl %al,%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	eb 18                	jmp    8017db <memcmp+0x50>
		s1++, s2++;
  8017c3:	ff 45 fc             	incl   -0x4(%ebp)
  8017c6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	75 c9                	jne    80179f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017ee:	eb 15                	jmp    801805 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	0f b6 d0             	movzbl %al,%edx
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	0f b6 c0             	movzbl %al,%eax
  8017fe:	39 c2                	cmp    %eax,%edx
  801800:	74 0d                	je     80180f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801802:	ff 45 08             	incl   0x8(%ebp)
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80180b:	72 e3                	jb     8017f0 <memfind+0x13>
  80180d:	eb 01                	jmp    801810 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80180f:	90                   	nop
	return (void *) s;
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80181b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801822:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801829:	eb 03                	jmp    80182e <strtol+0x19>
		s++;
  80182b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 20                	cmp    $0x20,%al
  801835:	74 f4                	je     80182b <strtol+0x16>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 09                	cmp    $0x9,%al
  80183e:	74 eb                	je     80182b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 2b                	cmp    $0x2b,%al
  801847:	75 05                	jne    80184e <strtol+0x39>
		s++;
  801849:	ff 45 08             	incl   0x8(%ebp)
  80184c:	eb 13                	jmp    801861 <strtol+0x4c>
	else if (*s == '-')
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	3c 2d                	cmp    $0x2d,%al
  801855:	75 0a                	jne    801861 <strtol+0x4c>
		s++, neg = 1;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801861:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801865:	74 06                	je     80186d <strtol+0x58>
  801867:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80186b:	75 20                	jne    80188d <strtol+0x78>
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	3c 30                	cmp    $0x30,%al
  801874:	75 17                	jne    80188d <strtol+0x78>
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	40                   	inc    %eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 78                	cmp    $0x78,%al
  80187e:	75 0d                	jne    80188d <strtol+0x78>
		s += 2, base = 16;
  801880:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801884:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80188b:	eb 28                	jmp    8018b5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80188d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801891:	75 15                	jne    8018a8 <strtol+0x93>
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	3c 30                	cmp    $0x30,%al
  80189a:	75 0c                	jne    8018a8 <strtol+0x93>
		s++, base = 8;
  80189c:	ff 45 08             	incl   0x8(%ebp)
  80189f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018a6:	eb 0d                	jmp    8018b5 <strtol+0xa0>
	else if (base == 0)
  8018a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ac:	75 07                	jne    8018b5 <strtol+0xa0>
		base = 10;
  8018ae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	3c 2f                	cmp    $0x2f,%al
  8018bc:	7e 19                	jle    8018d7 <strtol+0xc2>
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	3c 39                	cmp    $0x39,%al
  8018c5:	7f 10                	jg     8018d7 <strtol+0xc2>
			dig = *s - '0';
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	0f be c0             	movsbl %al,%eax
  8018cf:	83 e8 30             	sub    $0x30,%eax
  8018d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018d5:	eb 42                	jmp    801919 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8a 00                	mov    (%eax),%al
  8018dc:	3c 60                	cmp    $0x60,%al
  8018de:	7e 19                	jle    8018f9 <strtol+0xe4>
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	3c 7a                	cmp    $0x7a,%al
  8018e7:	7f 10                	jg     8018f9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	0f be c0             	movsbl %al,%eax
  8018f1:	83 e8 57             	sub    $0x57,%eax
  8018f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f7:	eb 20                	jmp    801919 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3c 40                	cmp    $0x40,%al
  801900:	7e 39                	jle    80193b <strtol+0x126>
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	8a 00                	mov    (%eax),%al
  801907:	3c 5a                	cmp    $0x5a,%al
  801909:	7f 30                	jg     80193b <strtol+0x126>
			dig = *s - 'A' + 10;
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	0f be c0             	movsbl %al,%eax
  801913:	83 e8 37             	sub    $0x37,%eax
  801916:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80191f:	7d 19                	jge    80193a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801921:	ff 45 08             	incl   0x8(%ebp)
  801924:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801927:	0f af 45 10          	imul   0x10(%ebp),%eax
  80192b:	89 c2                	mov    %eax,%edx
  80192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801935:	e9 7b ff ff ff       	jmp    8018b5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80193a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80193b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80193f:	74 08                	je     801949 <strtol+0x134>
		*endptr = (char *) s;
  801941:	8b 45 0c             	mov    0xc(%ebp),%eax
  801944:	8b 55 08             	mov    0x8(%ebp),%edx
  801947:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801949:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80194d:	74 07                	je     801956 <strtol+0x141>
  80194f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801952:	f7 d8                	neg    %eax
  801954:	eb 03                	jmp    801959 <strtol+0x144>
  801956:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <ltostr>:

void
ltostr(long value, char *str)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801961:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801968:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80196f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801973:	79 13                	jns    801988 <ltostr+0x2d>
	{
		neg = 1;
  801975:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801982:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801985:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801990:	99                   	cltd   
  801991:	f7 f9                	idiv   %ecx
  801993:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	8d 50 01             	lea    0x1(%eax),%edx
  80199c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80199f:	89 c2                	mov    %eax,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019a9:	83 c2 30             	add    $0x30,%edx
  8019ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019b6:	f7 e9                	imul   %ecx
  8019b8:	c1 fa 02             	sar    $0x2,%edx
  8019bb:	89 c8                	mov    %ecx,%eax
  8019bd:	c1 f8 1f             	sar    $0x1f,%eax
  8019c0:	29 c2                	sub    %eax,%edx
  8019c2:	89 d0                	mov    %edx,%eax
  8019c4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8019c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019cb:	75 bb                	jne    801988 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d7:	48                   	dec    %eax
  8019d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019df:	74 3d                	je     801a1e <ltostr+0xc3>
		start = 1 ;
  8019e1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019e8:	eb 34                	jmp    801a1e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f0:	01 d0                	add    %edx,%eax
  8019f2:	8a 00                	mov    (%eax),%al
  8019f4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fd:	01 c2                	add    %eax,%edx
  8019ff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a05:	01 c8                	add    %ecx,%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	01 c2                	add    %eax,%edx
  801a13:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a16:	88 02                	mov    %al,(%edx)
		start++ ;
  801a18:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a1b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a21:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a24:	7c c4                	jl     8019ea <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a26:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2c:	01 d0                	add    %edx,%eax
  801a2e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a31:	90                   	nop
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	e8 73 fa ff ff       	call   8014b5 <strlen>
  801a42:	83 c4 04             	add    $0x4,%esp
  801a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	e8 65 fa ff ff       	call   8014b5 <strlen>
  801a50:	83 c4 04             	add    $0x4,%esp
  801a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a64:	eb 17                	jmp    801a7d <strcconcat+0x49>
		final[s] = str1[s] ;
  801a66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a69:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6c:	01 c2                	add    %eax,%edx
  801a6e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	01 c8                	add    %ecx,%eax
  801a76:	8a 00                	mov    (%eax),%al
  801a78:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a7a:	ff 45 fc             	incl   -0x4(%ebp)
  801a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a80:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a83:	7c e1                	jl     801a66 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a85:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a93:	eb 1f                	jmp    801ab4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a98:	8d 50 01             	lea    0x1(%eax),%edx
  801a9b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa3:	01 c2                	add    %eax,%edx
  801aa5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aab:	01 c8                	add    %ecx,%eax
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ab1:	ff 45 f8             	incl   -0x8(%ebp)
  801ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801aba:	7c d9                	jl     801a95 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801abc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	01 d0                	add    %edx,%eax
  801ac4:	c6 00 00             	movb   $0x0,(%eax)
}
  801ac7:	90                   	nop
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801acd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae5:	01 d0                	add    %edx,%eax
  801ae7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aed:	eb 0c                	jmp    801afb <strsplit+0x31>
			*string++ = 0;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	8d 50 01             	lea    0x1(%eax),%edx
  801af5:	89 55 08             	mov    %edx,0x8(%ebp)
  801af8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8a 00                	mov    (%eax),%al
  801b00:	84 c0                	test   %al,%al
  801b02:	74 18                	je     801b1c <strsplit+0x52>
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8a 00                	mov    (%eax),%al
  801b09:	0f be c0             	movsbl %al,%eax
  801b0c:	50                   	push   %eax
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	e8 32 fb ff ff       	call   801647 <strchr>
  801b15:	83 c4 08             	add    $0x8,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	75 d3                	jne    801aef <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	8a 00                	mov    (%eax),%al
  801b21:	84 c0                	test   %al,%al
  801b23:	74 5a                	je     801b7f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b25:	8b 45 14             	mov    0x14(%ebp),%eax
  801b28:	8b 00                	mov    (%eax),%eax
  801b2a:	83 f8 0f             	cmp    $0xf,%eax
  801b2d:	75 07                	jne    801b36 <strsplit+0x6c>
		{
			return 0;
  801b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b34:	eb 66                	jmp    801b9c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b36:	8b 45 14             	mov    0x14(%ebp),%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	8d 48 01             	lea    0x1(%eax),%ecx
  801b3e:	8b 55 14             	mov    0x14(%ebp),%edx
  801b41:	89 0a                	mov    %ecx,(%edx)
  801b43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	01 c2                	add    %eax,%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b54:	eb 03                	jmp    801b59 <strsplit+0x8f>
			string++;
  801b56:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	8a 00                	mov    (%eax),%al
  801b5e:	84 c0                	test   %al,%al
  801b60:	74 8b                	je     801aed <strsplit+0x23>
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	8a 00                	mov    (%eax),%al
  801b67:	0f be c0             	movsbl %al,%eax
  801b6a:	50                   	push   %eax
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	e8 d4 fa ff ff       	call   801647 <strchr>
  801b73:	83 c4 08             	add    $0x8,%esp
  801b76:	85 c0                	test   %eax,%eax
  801b78:	74 dc                	je     801b56 <strsplit+0x8c>
			string++;
	}
  801b7a:	e9 6e ff ff ff       	jmp    801aed <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b7f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b80:	8b 45 14             	mov    0x14(%ebp),%eax
  801b83:	8b 00                	mov    (%eax),%eax
  801b85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8f:	01 d0                	add    %edx,%eax
  801b91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b97:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	68 9c 2d 80 00       	push   $0x802d9c
  801bac:	68 3f 01 00 00       	push   $0x13f
  801bb1:	68 be 2d 80 00       	push   $0x802dbe
  801bb6:	e8 53 07 00 00       	call   80230e <_panic>

00801bbb <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	e8 ef 06 00 00       	call   8022bb <sys_sbrk>
  801bcc:	83 c4 10             	add    $0x10,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bdb:	75 07                	jne    801be4 <malloc+0x13>
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801be2:	eb 14                	jmp    801bf8 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	68 cc 2d 80 00       	push   $0x802dcc
  801bec:	6a 1b                	push   $0x1b
  801bee:	68 f1 2d 80 00       	push   $0x802df1
  801bf3:	e8 16 07 00 00       	call   80230e <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 00 2e 80 00       	push   $0x802e00
  801c08:	6a 29                	push   $0x29
  801c0a:	68 f1 2d 80 00       	push   $0x802df1
  801c0f:	e8 fa 06 00 00       	call   80230e <_panic>

00801c14 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 18             	sub    $0x18,%esp
  801c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801c20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c24:	75 07                	jne    801c2d <smalloc+0x19>
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2b:	eb 14                	jmp    801c41 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	68 24 2e 80 00       	push   $0x802e24
  801c35:	6a 38                	push   $0x38
  801c37:	68 f1 2d 80 00       	push   $0x802df1
  801c3c:	e8 cd 06 00 00       	call   80230e <_panic>
	return NULL;
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	68 4c 2e 80 00       	push   $0x802e4c
  801c51:	6a 43                	push   $0x43
  801c53:	68 f1 2d 80 00       	push   $0x802df1
  801c58:	e8 b1 06 00 00       	call   80230e <_panic>

00801c5d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c63:	83 ec 04             	sub    $0x4,%esp
  801c66:	68 70 2e 80 00       	push   $0x802e70
  801c6b:	6a 5b                	push   $0x5b
  801c6d:	68 f1 2d 80 00       	push   $0x802df1
  801c72:	e8 97 06 00 00       	call   80230e <_panic>

00801c77 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	68 94 2e 80 00       	push   $0x802e94
  801c85:	6a 72                	push   $0x72
  801c87:	68 f1 2d 80 00       	push   $0x802df1
  801c8c:	e8 7d 06 00 00       	call   80230e <_panic>

00801c91 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 ba 2e 80 00       	push   $0x802eba
  801c9f:	6a 7e                	push   $0x7e
  801ca1:	68 f1 2d 80 00       	push   $0x802df1
  801ca6:	e8 63 06 00 00       	call   80230e <_panic>

00801cab <shrink>:

}
void shrink(uint32 newSize)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	68 ba 2e 80 00       	push   $0x802eba
  801cb9:	68 83 00 00 00       	push   $0x83
  801cbe:	68 f1 2d 80 00       	push   $0x802df1
  801cc3:	e8 46 06 00 00       	call   80230e <_panic>

00801cc8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	68 ba 2e 80 00       	push   $0x802eba
  801cd6:	68 88 00 00 00       	push   $0x88
  801cdb:	68 f1 2d 80 00       	push   $0x802df1
  801ce0:	e8 29 06 00 00       	call   80230e <_panic>

00801ce5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	57                   	push   %edi
  801ce9:	56                   	push   %esi
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfa:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cfd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d00:	cd 30                	int    $0x30
  801d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    

00801d10 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	8b 45 10             	mov    0x10(%ebp),%eax
  801d19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	52                   	push   %edx
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	50                   	push   %eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 b2 ff ff ff       	call   801ce5 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	90                   	nop
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 02                	push   $0x2
  801d48:	e8 98 ff ff ff       	call   801ce5 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 03                	push   $0x3
  801d61:	e8 7f ff ff ff       	call   801ce5 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	90                   	nop
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 04                	push   $0x4
  801d7b:	e8 65 ff ff ff       	call   801ce5 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	90                   	nop
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	6a 08                	push   $0x8
  801d99:	e8 47 ff ff ff       	call   801ce5 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801da8:	8b 75 18             	mov    0x18(%ebp),%esi
  801dab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	56                   	push   %esi
  801db8:	53                   	push   %ebx
  801db9:	51                   	push   %ecx
  801dba:	52                   	push   %edx
  801dbb:	50                   	push   %eax
  801dbc:	6a 09                	push   $0x9
  801dbe:	e8 22 ff ff ff       	call   801ce5 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
}
  801dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    

00801dcd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	52                   	push   %edx
  801ddd:	50                   	push   %eax
  801dde:	6a 0a                	push   $0xa
  801de0:	e8 00 ff ff ff       	call   801ce5 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	ff 75 08             	pushl  0x8(%ebp)
  801df9:	6a 0b                	push   $0xb
  801dfb:	e8 e5 fe ff ff       	call   801ce5 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 0c                	push   $0xc
  801e14:	e8 cc fe ff ff       	call   801ce5 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 0d                	push   $0xd
  801e2d:	e8 b3 fe ff ff       	call   801ce5 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 0e                	push   $0xe
  801e46:	e8 9a fe ff ff       	call   801ce5 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 0f                	push   $0xf
  801e5f:	e8 81 fe ff ff       	call   801ce5 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	6a 10                	push   $0x10
  801e79:	e8 67 fe ff ff       	call   801ce5 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 11                	push   $0x11
  801e92:	e8 4e fe ff ff       	call   801ce5 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	90                   	nop
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_cputc>:

void
sys_cputc(const char c)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ea9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	50                   	push   %eax
  801eb6:	6a 01                	push   $0x1
  801eb8:	e8 28 fe ff ff       	call   801ce5 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	90                   	nop
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 14                	push   $0x14
  801ed2:	e8 0e fe ff ff       	call   801ce5 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	90                   	nop
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ee9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	51                   	push   %ecx
  801ef6:	52                   	push   %edx
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	50                   	push   %eax
  801efb:	6a 15                	push   $0x15
  801efd:	e8 e3 fd ff ff       	call   801ce5 <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 16                	push   $0x16
  801f1a:	e8 c6 fd ff ff       	call   801ce5 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	51                   	push   %ecx
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 17                	push   $0x17
  801f39:	e8 a7 fd ff ff       	call   801ce5 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 18                	push   $0x18
  801f56:	e8 8a fd ff ff       	call   801ce5 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	ff 75 14             	pushl  0x14(%ebp)
  801f6b:	ff 75 10             	pushl  0x10(%ebp)
  801f6e:	ff 75 0c             	pushl  0xc(%ebp)
  801f71:	50                   	push   %eax
  801f72:	6a 19                	push   $0x19
  801f74:	e8 6c fd ff ff       	call   801ce5 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	50                   	push   %eax
  801f8d:	6a 1a                	push   $0x1a
  801f8f:	e8 51 fd ff ff       	call   801ce5 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	90                   	nop
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	50                   	push   %eax
  801fa9:	6a 1b                	push   $0x1b
  801fab:	e8 35 fd ff ff       	call   801ce5 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 05                	push   $0x5
  801fc4:	e8 1c fd ff ff       	call   801ce5 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 06                	push   $0x6
  801fdd:	e8 03 fd ff ff       	call   801ce5 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 07                	push   $0x7
  801ff6:	e8 ea fc ff ff       	call   801ce5 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_exit_env>:


void sys_exit_env(void)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 1c                	push   $0x1c
  80200f:	e8 d1 fc ff ff       	call   801ce5 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	90                   	nop
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802020:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802023:	8d 50 04             	lea    0x4(%eax),%edx
  802026:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	6a 1d                	push   $0x1d
  802033:	e8 ad fc ff ff       	call   801ce5 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return result;
  80203b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802041:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802044:	89 01                	mov    %eax,(%ecx)
  802046:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	c9                   	leave  
  80204d:	c2 04 00             	ret    $0x4

00802050 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	ff 75 10             	pushl  0x10(%ebp)
  80205a:	ff 75 0c             	pushl  0xc(%ebp)
  80205d:	ff 75 08             	pushl  0x8(%ebp)
  802060:	6a 13                	push   $0x13
  802062:	e8 7e fc ff ff       	call   801ce5 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
	return ;
  80206a:	90                   	nop
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_rcr2>:
uint32 sys_rcr2()
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 1e                	push   $0x1e
  80207c:	e8 64 fc ff ff       	call   801ce5 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802092:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	50                   	push   %eax
  80209f:	6a 1f                	push   $0x1f
  8020a1:	e8 3f fc ff ff       	call   801ce5 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a9:	90                   	nop
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <rsttst>:
void rsttst()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 21                	push   $0x21
  8020bb:	e8 25 fc ff ff       	call   801ce5 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c3:	90                   	nop
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8020cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020d2:	8b 55 18             	mov    0x18(%ebp),%edx
  8020d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020d9:	52                   	push   %edx
  8020da:	50                   	push   %eax
  8020db:	ff 75 10             	pushl  0x10(%ebp)
  8020de:	ff 75 0c             	pushl  0xc(%ebp)
  8020e1:	ff 75 08             	pushl  0x8(%ebp)
  8020e4:	6a 20                	push   $0x20
  8020e6:	e8 fa fb ff ff       	call   801ce5 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ee:	90                   	nop
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <chktst>:
void chktst(uint32 n)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	ff 75 08             	pushl  0x8(%ebp)
  8020ff:	6a 22                	push   $0x22
  802101:	e8 df fb ff ff       	call   801ce5 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
	return ;
  802109:	90                   	nop
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <inctst>:

void inctst()
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 23                	push   $0x23
  80211b:	e8 c5 fb ff ff       	call   801ce5 <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
	return ;
  802123:	90                   	nop
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <gettst>:
uint32 gettst()
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 24                	push   $0x24
  802135:	e8 ab fb ff ff       	call   801ce5 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 25                	push   $0x25
  802151:	e8 8f fb ff ff       	call   801ce5 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
  802159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80215c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802160:	75 07                	jne    802169 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	eb 05                	jmp    80216e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 25                	push   $0x25
  802182:	e8 5e fb ff ff       	call   801ce5 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
  80218a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80218d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802191:	75 07                	jne    80219a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802193:	b8 01 00 00 00       	mov    $0x1,%eax
  802198:	eb 05                	jmp    80219f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 25                	push   $0x25
  8021b3:	e8 2d fb ff ff       	call   801ce5 <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
  8021bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021be:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021c2:	75 07                	jne    8021cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c9:	eb 05                	jmp    8021d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 25                	push   $0x25
  8021e4:	e8 fc fa ff ff       	call   801ce5 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
  8021ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021ef:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021f3:	75 07                	jne    8021fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fa:	eb 05                	jmp    802201 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	ff 75 08             	pushl  0x8(%ebp)
  802211:	6a 26                	push   $0x26
  802213:	e8 cd fa ff ff       	call   801ce5 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
	return ;
  80221b:	90                   	nop
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	6a 00                	push   $0x0
  802230:	53                   	push   %ebx
  802231:	51                   	push   %ecx
  802232:	52                   	push   %edx
  802233:	50                   	push   %eax
  802234:	6a 27                	push   $0x27
  802236:	e8 aa fa ff ff       	call   801ce5 <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802246:	8b 55 0c             	mov    0xc(%ebp),%edx
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	52                   	push   %edx
  802253:	50                   	push   %eax
  802254:	6a 28                	push   $0x28
  802256:	e8 8a fa ff ff       	call   801ce5 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802263:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802266:	8b 55 0c             	mov    0xc(%ebp),%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	51                   	push   %ecx
  80226f:	ff 75 10             	pushl  0x10(%ebp)
  802272:	52                   	push   %edx
  802273:	50                   	push   %eax
  802274:	6a 29                	push   $0x29
  802276:	e8 6a fa ff ff       	call   801ce5 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	ff 75 10             	pushl  0x10(%ebp)
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	ff 75 08             	pushl  0x8(%ebp)
  802290:	6a 12                	push   $0x12
  802292:	e8 4e fa ff ff       	call   801ce5 <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
	return ;
  80229a:	90                   	nop
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	52                   	push   %edx
  8022ad:	50                   	push   %eax
  8022ae:	6a 2a                	push   $0x2a
  8022b0:	e8 30 fa ff ff       	call   801ce5 <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
	return;
  8022b8:	90                   	nop
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	50                   	push   %eax
  8022ca:	6a 2b                	push   $0x2b
  8022cc:	e8 14 fa ff ff       	call   801ce5 <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	ff 75 0c             	pushl  0xc(%ebp)
  8022e2:	ff 75 08             	pushl  0x8(%ebp)
  8022e5:	6a 2c                	push   $0x2c
  8022e7:	e8 f9 f9 ff ff       	call   801ce5 <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
	return;
  8022ef:	90                   	nop
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	ff 75 08             	pushl  0x8(%ebp)
  802301:	6a 2d                	push   $0x2d
  802303:	e8 dd f9 ff ff       	call   801ce5 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
	return;
  80230b:	90                   	nop
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802314:	8d 45 10             	lea    0x10(%ebp),%eax
  802317:	83 c0 04             	add    $0x4,%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80231d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	74 16                	je     80233c <_panic+0x2e>
		cprintf("%s: ", argv0);
  802326:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80232b:	83 ec 08             	sub    $0x8,%esp
  80232e:	50                   	push   %eax
  80232f:	68 cc 2e 80 00       	push   $0x802ecc
  802334:	e8 e0 e8 ff ff       	call   800c19 <cprintf>
  802339:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80233c:	a1 00 30 80 00       	mov    0x803000,%eax
  802341:	ff 75 0c             	pushl  0xc(%ebp)
  802344:	ff 75 08             	pushl  0x8(%ebp)
  802347:	50                   	push   %eax
  802348:	68 d1 2e 80 00       	push   $0x802ed1
  80234d:	e8 c7 e8 ff ff       	call   800c19 <cprintf>
  802352:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802355:	8b 45 10             	mov    0x10(%ebp),%eax
  802358:	83 ec 08             	sub    $0x8,%esp
  80235b:	ff 75 f4             	pushl  -0xc(%ebp)
  80235e:	50                   	push   %eax
  80235f:	e8 4a e8 ff ff       	call   800bae <vcprintf>
  802364:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802367:	83 ec 08             	sub    $0x8,%esp
  80236a:	6a 00                	push   $0x0
  80236c:	68 ed 2e 80 00       	push   $0x802eed
  802371:	e8 38 e8 ff ff       	call   800bae <vcprintf>
  802376:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802379:	e8 b9 e7 ff ff       	call   800b37 <exit>

	// should not return here
	while (1) ;
  80237e:	eb fe                	jmp    80237e <_panic+0x70>

00802380 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802386:	a1 04 30 80 00       	mov    0x803004,%eax
  80238b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802391:	8b 45 0c             	mov    0xc(%ebp),%eax
  802394:	39 c2                	cmp    %eax,%edx
  802396:	74 14                	je     8023ac <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	68 f0 2e 80 00       	push   $0x802ef0
  8023a0:	6a 26                	push   $0x26
  8023a2:	68 3c 2f 80 00       	push   $0x802f3c
  8023a7:	e8 62 ff ff ff       	call   80230e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8023ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8023b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023ba:	e9 c5 00 00 00       	jmp    802484 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	01 d0                	add    %edx,%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	75 08                	jne    8023dc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8023d4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8023d7:	e9 a5 00 00 00       	jmp    802481 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8023dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8023e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023ea:	eb 69                	jmp    802455 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8023ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8023f1:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8023f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023fa:	89 d0                	mov    %edx,%eax
  8023fc:	01 c0                	add    %eax,%eax
  8023fe:	01 d0                	add    %edx,%eax
  802400:	c1 e0 03             	shl    $0x3,%eax
  802403:	01 c8                	add    %ecx,%eax
  802405:	8a 40 04             	mov    0x4(%eax),%al
  802408:	84 c0                	test   %al,%al
  80240a:	75 46                	jne    802452 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80240c:	a1 04 30 80 00       	mov    0x803004,%eax
  802411:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  802417:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80241a:	89 d0                	mov    %edx,%eax
  80241c:	01 c0                	add    %eax,%eax
  80241e:	01 d0                	add    %edx,%eax
  802420:	c1 e0 03             	shl    $0x3,%eax
  802423:	01 c8                	add    %ecx,%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80242a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80242d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802432:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	01 c8                	add    %ecx,%eax
  802443:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802445:	39 c2                	cmp    %eax,%edx
  802447:	75 09                	jne    802452 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802449:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802450:	eb 15                	jmp    802467 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802452:	ff 45 e8             	incl   -0x18(%ebp)
  802455:	a1 04 30 80 00       	mov    0x803004,%eax
  80245a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802463:	39 c2                	cmp    %eax,%edx
  802465:	77 85                	ja     8023ec <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80246b:	75 14                	jne    802481 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 48 2f 80 00       	push   $0x802f48
  802475:	6a 3a                	push   $0x3a
  802477:	68 3c 2f 80 00       	push   $0x802f3c
  80247c:	e8 8d fe ff ff       	call   80230e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802481:	ff 45 f0             	incl   -0x10(%ebp)
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80248a:	0f 8c 2f ff ff ff    	jl     8023bf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802490:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802497:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80249e:	eb 26                	jmp    8024c6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8024a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8024a5:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8024ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024ae:	89 d0                	mov    %edx,%eax
  8024b0:	01 c0                	add    %eax,%eax
  8024b2:	01 d0                	add    %edx,%eax
  8024b4:	c1 e0 03             	shl    $0x3,%eax
  8024b7:	01 c8                	add    %ecx,%eax
  8024b9:	8a 40 04             	mov    0x4(%eax),%al
  8024bc:	3c 01                	cmp    $0x1,%al
  8024be:	75 03                	jne    8024c3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8024c0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8024c3:	ff 45 e0             	incl   -0x20(%ebp)
  8024c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8024cb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8024d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d4:	39 c2                	cmp    %eax,%edx
  8024d6:	77 c8                	ja     8024a0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024de:	74 14                	je     8024f4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8024e0:	83 ec 04             	sub    $0x4,%esp
  8024e3:	68 9c 2f 80 00       	push   $0x802f9c
  8024e8:	6a 44                	push   $0x44
  8024ea:	68 3c 2f 80 00       	push   $0x802f3c
  8024ef:	e8 1a fe ff ff       	call   80230e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8024f4:	90                   	nop
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    
  8024f7:	90                   	nop

008024f8 <__udivdi3>:
  8024f8:	55                   	push   %ebp
  8024f9:	57                   	push   %edi
  8024fa:	56                   	push   %esi
  8024fb:	53                   	push   %ebx
  8024fc:	83 ec 1c             	sub    $0x1c,%esp
  8024ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802503:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802507:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80250b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80250f:	89 ca                	mov    %ecx,%edx
  802511:	89 f8                	mov    %edi,%eax
  802513:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802517:	85 f6                	test   %esi,%esi
  802519:	75 2d                	jne    802548 <__udivdi3+0x50>
  80251b:	39 cf                	cmp    %ecx,%edi
  80251d:	77 65                	ja     802584 <__udivdi3+0x8c>
  80251f:	89 fd                	mov    %edi,%ebp
  802521:	85 ff                	test   %edi,%edi
  802523:	75 0b                	jne    802530 <__udivdi3+0x38>
  802525:	b8 01 00 00 00       	mov    $0x1,%eax
  80252a:	31 d2                	xor    %edx,%edx
  80252c:	f7 f7                	div    %edi
  80252e:	89 c5                	mov    %eax,%ebp
  802530:	31 d2                	xor    %edx,%edx
  802532:	89 c8                	mov    %ecx,%eax
  802534:	f7 f5                	div    %ebp
  802536:	89 c1                	mov    %eax,%ecx
  802538:	89 d8                	mov    %ebx,%eax
  80253a:	f7 f5                	div    %ebp
  80253c:	89 cf                	mov    %ecx,%edi
  80253e:	89 fa                	mov    %edi,%edx
  802540:	83 c4 1c             	add    $0x1c,%esp
  802543:	5b                   	pop    %ebx
  802544:	5e                   	pop    %esi
  802545:	5f                   	pop    %edi
  802546:	5d                   	pop    %ebp
  802547:	c3                   	ret    
  802548:	39 ce                	cmp    %ecx,%esi
  80254a:	77 28                	ja     802574 <__udivdi3+0x7c>
  80254c:	0f bd fe             	bsr    %esi,%edi
  80254f:	83 f7 1f             	xor    $0x1f,%edi
  802552:	75 40                	jne    802594 <__udivdi3+0x9c>
  802554:	39 ce                	cmp    %ecx,%esi
  802556:	72 0a                	jb     802562 <__udivdi3+0x6a>
  802558:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80255c:	0f 87 9e 00 00 00    	ja     802600 <__udivdi3+0x108>
  802562:	b8 01 00 00 00       	mov    $0x1,%eax
  802567:	89 fa                	mov    %edi,%edx
  802569:	83 c4 1c             	add    $0x1c,%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	8d 76 00             	lea    0x0(%esi),%esi
  802574:	31 ff                	xor    %edi,%edi
  802576:	31 c0                	xor    %eax,%eax
  802578:	89 fa                	mov    %edi,%edx
  80257a:	83 c4 1c             	add    $0x1c,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5e                   	pop    %esi
  80257f:	5f                   	pop    %edi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    
  802582:	66 90                	xchg   %ax,%ax
  802584:	89 d8                	mov    %ebx,%eax
  802586:	f7 f7                	div    %edi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	89 fa                	mov    %edi,%edx
  80258c:	83 c4 1c             	add    $0x1c,%esp
  80258f:	5b                   	pop    %ebx
  802590:	5e                   	pop    %esi
  802591:	5f                   	pop    %edi
  802592:	5d                   	pop    %ebp
  802593:	c3                   	ret    
  802594:	bd 20 00 00 00       	mov    $0x20,%ebp
  802599:	89 eb                	mov    %ebp,%ebx
  80259b:	29 fb                	sub    %edi,%ebx
  80259d:	89 f9                	mov    %edi,%ecx
  80259f:	d3 e6                	shl    %cl,%esi
  8025a1:	89 c5                	mov    %eax,%ebp
  8025a3:	88 d9                	mov    %bl,%cl
  8025a5:	d3 ed                	shr    %cl,%ebp
  8025a7:	89 e9                	mov    %ebp,%ecx
  8025a9:	09 f1                	or     %esi,%ecx
  8025ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025af:	89 f9                	mov    %edi,%ecx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 c5                	mov    %eax,%ebp
  8025b5:	89 d6                	mov    %edx,%esi
  8025b7:	88 d9                	mov    %bl,%cl
  8025b9:	d3 ee                	shr    %cl,%esi
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e2                	shl    %cl,%edx
  8025bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c3:	88 d9                	mov    %bl,%cl
  8025c5:	d3 e8                	shr    %cl,%eax
  8025c7:	09 c2                	or     %eax,%edx
  8025c9:	89 d0                	mov    %edx,%eax
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	f7 74 24 0c          	divl   0xc(%esp)
  8025d1:	89 d6                	mov    %edx,%esi
  8025d3:	89 c3                	mov    %eax,%ebx
  8025d5:	f7 e5                	mul    %ebp
  8025d7:	39 d6                	cmp    %edx,%esi
  8025d9:	72 19                	jb     8025f4 <__udivdi3+0xfc>
  8025db:	74 0b                	je     8025e8 <__udivdi3+0xf0>
  8025dd:	89 d8                	mov    %ebx,%eax
  8025df:	31 ff                	xor    %edi,%edi
  8025e1:	e9 58 ff ff ff       	jmp    80253e <__udivdi3+0x46>
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8025ec:	89 f9                	mov    %edi,%ecx
  8025ee:	d3 e2                	shl    %cl,%edx
  8025f0:	39 c2                	cmp    %eax,%edx
  8025f2:	73 e9                	jae    8025dd <__udivdi3+0xe5>
  8025f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025f7:	31 ff                	xor    %edi,%edi
  8025f9:	e9 40 ff ff ff       	jmp    80253e <__udivdi3+0x46>
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	31 c0                	xor    %eax,%eax
  802602:	e9 37 ff ff ff       	jmp    80253e <__udivdi3+0x46>
  802607:	90                   	nop

00802608 <__umoddi3>:
  802608:	55                   	push   %ebp
  802609:	57                   	push   %edi
  80260a:	56                   	push   %esi
  80260b:	53                   	push   %ebx
  80260c:	83 ec 1c             	sub    $0x1c,%esp
  80260f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802613:	8b 74 24 34          	mov    0x34(%esp),%esi
  802617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80261b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80261f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802627:	89 f3                	mov    %esi,%ebx
  802629:	89 fa                	mov    %edi,%edx
  80262b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80262f:	89 34 24             	mov    %esi,(%esp)
  802632:	85 c0                	test   %eax,%eax
  802634:	75 1a                	jne    802650 <__umoddi3+0x48>
  802636:	39 f7                	cmp    %esi,%edi
  802638:	0f 86 a2 00 00 00    	jbe    8026e0 <__umoddi3+0xd8>
  80263e:	89 c8                	mov    %ecx,%eax
  802640:	89 f2                	mov    %esi,%edx
  802642:	f7 f7                	div    %edi
  802644:	89 d0                	mov    %edx,%eax
  802646:	31 d2                	xor    %edx,%edx
  802648:	83 c4 1c             	add    $0x1c,%esp
  80264b:	5b                   	pop    %ebx
  80264c:	5e                   	pop    %esi
  80264d:	5f                   	pop    %edi
  80264e:	5d                   	pop    %ebp
  80264f:	c3                   	ret    
  802650:	39 f0                	cmp    %esi,%eax
  802652:	0f 87 ac 00 00 00    	ja     802704 <__umoddi3+0xfc>
  802658:	0f bd e8             	bsr    %eax,%ebp
  80265b:	83 f5 1f             	xor    $0x1f,%ebp
  80265e:	0f 84 ac 00 00 00    	je     802710 <__umoddi3+0x108>
  802664:	bf 20 00 00 00       	mov    $0x20,%edi
  802669:	29 ef                	sub    %ebp,%edi
  80266b:	89 fe                	mov    %edi,%esi
  80266d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802671:	89 e9                	mov    %ebp,%ecx
  802673:	d3 e0                	shl    %cl,%eax
  802675:	89 d7                	mov    %edx,%edi
  802677:	89 f1                	mov    %esi,%ecx
  802679:	d3 ef                	shr    %cl,%edi
  80267b:	09 c7                	or     %eax,%edi
  80267d:	89 e9                	mov    %ebp,%ecx
  80267f:	d3 e2                	shl    %cl,%edx
  802681:	89 14 24             	mov    %edx,(%esp)
  802684:	89 d8                	mov    %ebx,%eax
  802686:	d3 e0                	shl    %cl,%eax
  802688:	89 c2                	mov    %eax,%edx
  80268a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80268e:	d3 e0                	shl    %cl,%eax
  802690:	89 44 24 04          	mov    %eax,0x4(%esp)
  802694:	8b 44 24 08          	mov    0x8(%esp),%eax
  802698:	89 f1                	mov    %esi,%ecx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	09 d0                	or     %edx,%eax
  80269e:	d3 eb                	shr    %cl,%ebx
  8026a0:	89 da                	mov    %ebx,%edx
  8026a2:	f7 f7                	div    %edi
  8026a4:	89 d3                	mov    %edx,%ebx
  8026a6:	f7 24 24             	mull   (%esp)
  8026a9:	89 c6                	mov    %eax,%esi
  8026ab:	89 d1                	mov    %edx,%ecx
  8026ad:	39 d3                	cmp    %edx,%ebx
  8026af:	0f 82 87 00 00 00    	jb     80273c <__umoddi3+0x134>
  8026b5:	0f 84 91 00 00 00    	je     80274c <__umoddi3+0x144>
  8026bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026bf:	29 f2                	sub    %esi,%edx
  8026c1:	19 cb                	sbb    %ecx,%ebx
  8026c3:	89 d8                	mov    %ebx,%eax
  8026c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026c9:	d3 e0                	shl    %cl,%eax
  8026cb:	89 e9                	mov    %ebp,%ecx
  8026cd:	d3 ea                	shr    %cl,%edx
  8026cf:	09 d0                	or     %edx,%eax
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 eb                	shr    %cl,%ebx
  8026d5:	89 da                	mov    %ebx,%edx
  8026d7:	83 c4 1c             	add    $0x1c,%esp
  8026da:	5b                   	pop    %ebx
  8026db:	5e                   	pop    %esi
  8026dc:	5f                   	pop    %edi
  8026dd:	5d                   	pop    %ebp
  8026de:	c3                   	ret    
  8026df:	90                   	nop
  8026e0:	89 fd                	mov    %edi,%ebp
  8026e2:	85 ff                	test   %edi,%edi
  8026e4:	75 0b                	jne    8026f1 <__umoddi3+0xe9>
  8026e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026eb:	31 d2                	xor    %edx,%edx
  8026ed:	f7 f7                	div    %edi
  8026ef:	89 c5                	mov    %eax,%ebp
  8026f1:	89 f0                	mov    %esi,%eax
  8026f3:	31 d2                	xor    %edx,%edx
  8026f5:	f7 f5                	div    %ebp
  8026f7:	89 c8                	mov    %ecx,%eax
  8026f9:	f7 f5                	div    %ebp
  8026fb:	89 d0                	mov    %edx,%eax
  8026fd:	e9 44 ff ff ff       	jmp    802646 <__umoddi3+0x3e>
  802702:	66 90                	xchg   %ax,%ax
  802704:	89 c8                	mov    %ecx,%eax
  802706:	89 f2                	mov    %esi,%edx
  802708:	83 c4 1c             	add    $0x1c,%esp
  80270b:	5b                   	pop    %ebx
  80270c:	5e                   	pop    %esi
  80270d:	5f                   	pop    %edi
  80270e:	5d                   	pop    %ebp
  80270f:	c3                   	ret    
  802710:	3b 04 24             	cmp    (%esp),%eax
  802713:	72 06                	jb     80271b <__umoddi3+0x113>
  802715:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802719:	77 0f                	ja     80272a <__umoddi3+0x122>
  80271b:	89 f2                	mov    %esi,%edx
  80271d:	29 f9                	sub    %edi,%ecx
  80271f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802723:	89 14 24             	mov    %edx,(%esp)
  802726:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80272a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80272e:	8b 14 24             	mov    (%esp),%edx
  802731:	83 c4 1c             	add    $0x1c,%esp
  802734:	5b                   	pop    %ebx
  802735:	5e                   	pop    %esi
  802736:	5f                   	pop    %edi
  802737:	5d                   	pop    %ebp
  802738:	c3                   	ret    
  802739:	8d 76 00             	lea    0x0(%esi),%esi
  80273c:	2b 04 24             	sub    (%esp),%eax
  80273f:	19 fa                	sbb    %edi,%edx
  802741:	89 d1                	mov    %edx,%ecx
  802743:	89 c6                	mov    %eax,%esi
  802745:	e9 71 ff ff ff       	jmp    8026bb <__umoddi3+0xb3>
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802750:	72 ea                	jb     80273c <__umoddi3+0x134>
  802752:	89 d9                	mov    %ebx,%ecx
  802754:	e9 62 ff ff ff       	jmp    8026bb <__umoddi3+0xb3>
