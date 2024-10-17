
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
  80005e:	e8 05 1d 00 00       	call   801d68 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 80 27 80 00       	push   $0x802780
  80006b:	e8 bf 0b 00 00       	call   800c2f <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 84 27 80 00       	push   $0x802784
  80007b:	e8 af 0b 00 00       	call   800c2f <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 a8 27 80 00       	push   $0x8027a8
  80008b:	e8 9f 0b 00 00       	call   800c2f <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 84 27 80 00       	push   $0x802784
  80009b:	e8 8f 0b 00 00       	call   800c2f <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 80 27 80 00       	push   $0x802780
  8000ab:	e8 7f 0b 00 00       	call   800c2f <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 cc 27 80 00       	push   $0x8027cc
  8000c2:	e8 fc 11 00 00       	call   8012c3 <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 4e 17 00 00       	call   80182b <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 ec 27 80 00       	push   $0x8027ec
  8000eb:	e8 3f 0b 00 00       	call   800c2f <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 0e 28 80 00       	push   $0x80280e
  8000fb:	e8 2f 0b 00 00       	call   800c2f <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 1c 28 80 00       	push   $0x80281c
  80010b:	e8 1f 0b 00 00       	call   800c2f <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 2a 28 80 00       	push   $0x80282a
  80011b:	e8 0f 0b 00 00       	call   800c2f <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 3a 28 80 00       	push   $0x80283a
  80012b:	e8 ff 0a 00 00       	call   800c2f <cprintf>
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
  80017a:	68 44 28 80 00       	push   $0x802844
  80017f:	e8 3f 11 00 00       	call   8012c3 <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 91 16 00 00       	call   80182b <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 dd 1b 00 00       	call   801d82 <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 33 1a 00 00       	call   801be7 <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 1e 1a 00 00       	call   801be7 <malloc>
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
  8001f2:	e8 f0 19 00 00       	call   801be7 <malloc>
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
  800216:	e8 cc 19 00 00       	call   801be7 <malloc>
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
  8002d2:	e8 91 1a 00 00       	call   801d68 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 68 28 80 00       	push   $0x802868
  8002df:	e8 4b 09 00 00       	call   800c2f <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 86 28 80 00       	push   $0x802886
  8002ef:	e8 3b 09 00 00       	call   800c2f <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 9d 28 80 00       	push   $0x80289d
  8002ff:	e8 2b 09 00 00       	call   800c2f <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 b4 28 80 00       	push   $0x8028b4
  80030f:	e8 1b 09 00 00       	call   800c2f <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 3a 28 80 00       	push   $0x80283a
  80031f:	e8 0b 09 00 00       	call   800c2f <cprintf>
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
  80035e:	e8 1f 1a 00 00       	call   801d82 <sys_unlock_cons>


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
  8003df:	e8 84 19 00 00       	call   801d68 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 cb 28 80 00       	push   $0x8028cb
  8003ec:	e8 3e 08 00 00       	call   800c2f <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 89 19 00 00       	call   801d82 <sys_unlock_cons>

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
  800417:	e8 f4 17 00 00       	call   801c10 <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 d7 17 00 00       	call   801c10 <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 ba 17 00 00       	call   801c10 <free>
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
  80046a:	e8 a1 17 00 00       	call   801c10 <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 93 17 00 00       	call   801c10 <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 85 17 00 00       	call   801c10 <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 d5 18 00 00       	call   801d68 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 e4 28 80 00       	push   $0x8028e4
  80049b:	e8 8f 07 00 00       	call   800c2f <cprintf>
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
  8004c8:	e8 b5 18 00 00       	call   801d82 <sys_unlock_cons>

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
  8004f0:	e8 f2 16 00 00       	call   801be7 <malloc>
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
  80051e:	e8 c4 16 00 00       	call   801be7 <malloc>
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
  80063e:	e8 a4 15 00 00       	call   801be7 <malloc>
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
  80066c:	e8 76 15 00 00       	call   801be7 <malloc>
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
  80071a:	e8 c8 14 00 00       	call   801be7 <malloc>
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
  800748:	e8 9a 14 00 00       	call   801be7 <malloc>
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
  8008bf:	e8 6c 17 00 00       	call   802030 <sys_get_virtual_time>
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
  80092b:	68 02 29 80 00       	push   $0x802902
  800930:	e8 fa 02 00 00       	call   800c2f <cprintf>
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
  800946:	68 09 29 80 00       	push   $0x802909
  80094b:	e8 df 02 00 00       	call   800c2f <cprintf>
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
  80099c:	68 0d 29 80 00       	push   $0x80290d
  8009a1:	e8 89 02 00 00       	call   800c2f <cprintf>
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
  8009b7:	68 09 29 80 00       	push   $0x802909
  8009bc:	e8 6e 02 00 00       	call   800c2f <cprintf>
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
  8009e6:	e8 c8 14 00 00       	call   801eb3 <sys_cputc>
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
  8009f7:	e8 53 13 00 00       	call   801d4f <sys_cgetc>
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
  800a14:	e8 cb 15 00 00       	call   801fe4 <sys_getenvindex>
  800a19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	c1 e0 06             	shl    $0x6,%eax
  800a24:	29 d0                	sub    %edx,%eax
  800a26:	c1 e0 02             	shl    $0x2,%eax
  800a29:	01 d0                	add    %edx,%eax
  800a2b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a32:	01 c8                	add    %ecx,%eax
  800a34:	c1 e0 03             	shl    $0x3,%eax
  800a37:	01 d0                	add    %edx,%eax
  800a39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a40:	29 c2                	sub    %eax,%edx
  800a42:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800a49:	89 c2                	mov    %eax,%edx
  800a4b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800a51:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a56:	a1 04 40 80 00       	mov    0x804004,%eax
  800a5b:	8a 40 20             	mov    0x20(%eax),%al
  800a5e:	84 c0                	test   %al,%al
  800a60:	74 0d                	je     800a6f <libmain+0x61>
		binaryname = myEnv->prog_name;
  800a62:	a1 04 40 80 00       	mov    0x804004,%eax
  800a67:	83 c0 20             	add    $0x20,%eax
  800a6a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a73:	7e 0a                	jle    800a7f <libmain+0x71>
		binaryname = argv[0];
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	8b 00                	mov    (%eax),%eax
  800a7a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	ff 75 08             	pushl  0x8(%ebp)
  800a88:	e8 ab f5 ff ff       	call   800038 <_main>
  800a8d:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800a90:	e8 d3 12 00 00       	call   801d68 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a95:	83 ec 0c             	sub    $0xc,%esp
  800a98:	68 30 29 80 00       	push   $0x802930
  800a9d:	e8 8d 01 00 00       	call   800c2f <cprintf>
  800aa2:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800aa5:	a1 04 40 80 00       	mov    0x804004,%eax
  800aaa:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800ab0:	a1 04 40 80 00       	mov    0x804004,%eax
  800ab5:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	52                   	push   %edx
  800abf:	50                   	push   %eax
  800ac0:	68 58 29 80 00       	push   $0x802958
  800ac5:	e8 65 01 00 00       	call   800c2f <cprintf>
  800aca:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800acd:	a1 04 40 80 00       	mov    0x804004,%eax
  800ad2:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800ad8:	a1 04 40 80 00       	mov    0x804004,%eax
  800add:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800ae3:	a1 04 40 80 00       	mov    0x804004,%eax
  800ae8:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800aee:	51                   	push   %ecx
  800aef:	52                   	push   %edx
  800af0:	50                   	push   %eax
  800af1:	68 80 29 80 00       	push   $0x802980
  800af6:	e8 34 01 00 00       	call   800c2f <cprintf>
  800afb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800afe:	a1 04 40 80 00       	mov    0x804004,%eax
  800b03:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	50                   	push   %eax
  800b0d:	68 d8 29 80 00       	push   $0x8029d8
  800b12:	e8 18 01 00 00       	call   800c2f <cprintf>
  800b17:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b1a:	83 ec 0c             	sub    $0xc,%esp
  800b1d:	68 30 29 80 00       	push   $0x802930
  800b22:	e8 08 01 00 00       	call   800c2f <cprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b2a:	e8 53 12 00 00       	call   801d82 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800b2f:	e8 19 00 00 00       	call   800b4d <exit>
}
  800b34:	90                   	nop
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800b3d:	83 ec 0c             	sub    $0xc,%esp
  800b40:	6a 00                	push   $0x0
  800b42:	e8 69 14 00 00       	call   801fb0 <sys_destroy_env>
  800b47:	83 c4 10             	add    $0x10,%esp
}
  800b4a:	90                   	nop
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <exit>:

void
exit(void)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800b53:	e8 be 14 00 00       	call   802016 <sys_exit_env>
}
  800b58:	90                   	nop
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 00                	mov    (%eax),%eax
  800b66:	8d 48 01             	lea    0x1(%eax),%ecx
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 0a                	mov    %ecx,(%edx)
  800b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b71:	88 d1                	mov    %dl,%cl
  800b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b76:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8b 00                	mov    (%eax),%eax
  800b7f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b84:	75 2c                	jne    800bb2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b86:	a0 08 40 80 00       	mov    0x804008,%al
  800b8b:	0f b6 c0             	movzbl %al,%eax
  800b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b91:	8b 12                	mov    (%edx),%edx
  800b93:	89 d1                	mov    %edx,%ecx
  800b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b98:	83 c2 08             	add    $0x8,%edx
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	50                   	push   %eax
  800b9f:	51                   	push   %ecx
  800ba0:	52                   	push   %edx
  800ba1:	e8 80 11 00 00       	call   801d26 <sys_cputs>
  800ba6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8b 40 04             	mov    0x4(%eax),%eax
  800bb8:	8d 50 01             	lea    0x1(%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bc1:	90                   	nop
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bcd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bd4:	00 00 00 
	b.cnt = 0;
  800bd7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bde:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	ff 75 08             	pushl  0x8(%ebp)
  800be7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bed:	50                   	push   %eax
  800bee:	68 5b 0b 80 00       	push   $0x800b5b
  800bf3:	e8 11 02 00 00       	call   800e09 <vprintfmt>
  800bf8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800bfb:	a0 08 40 80 00       	mov    0x804008,%al
  800c00:	0f b6 c0             	movzbl %al,%eax
  800c03:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c09:	83 ec 04             	sub    $0x4,%esp
  800c0c:	50                   	push   %eax
  800c0d:	52                   	push   %edx
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	83 c0 08             	add    $0x8,%eax
  800c17:	50                   	push   %eax
  800c18:	e8 09 11 00 00       	call   801d26 <sys_cputs>
  800c1d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c20:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  800c27:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c35:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  800c3c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4b:	50                   	push   %eax
  800c4c:	e8 73 ff ff ff       	call   800bc4 <vcprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c62:	e8 01 11 00 00       	call   801d68 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c67:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 f4             	pushl  -0xc(%ebp)
  800c76:	50                   	push   %eax
  800c77:	e8 48 ff ff ff       	call   800bc4 <vcprintf>
  800c7c:	83 c4 10             	add    $0x10,%esp
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c82:	e8 fb 10 00 00       	call   801d82 <sys_unlock_cons>
	return cnt;
  800c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 14             	sub    $0x14,%esp
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c9f:	8b 45 18             	mov    0x18(%ebp),%eax
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800caa:	77 55                	ja     800d01 <printnum+0x75>
  800cac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800caf:	72 05                	jb     800cb6 <printnum+0x2a>
  800cb1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cb4:	77 4b                	ja     800d01 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cb6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cb9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cbc:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc4:	52                   	push   %edx
  800cc5:	50                   	push   %eax
  800cc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc9:	ff 75 f0             	pushl  -0x10(%ebp)
  800ccc:	e8 43 18 00 00       	call   802514 <__udivdi3>
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	83 ec 04             	sub    $0x4,%esp
  800cd7:	ff 75 20             	pushl  0x20(%ebp)
  800cda:	53                   	push   %ebx
  800cdb:	ff 75 18             	pushl  0x18(%ebp)
  800cde:	52                   	push   %edx
  800cdf:	50                   	push   %eax
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	ff 75 08             	pushl  0x8(%ebp)
  800ce6:	e8 a1 ff ff ff       	call   800c8c <printnum>
  800ceb:	83 c4 20             	add    $0x20,%esp
  800cee:	eb 1a                	jmp    800d0a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	ff 75 20             	pushl  0x20(%ebp)
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	ff d0                	call   *%eax
  800cfe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d01:	ff 4d 1c             	decl   0x1c(%ebp)
  800d04:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d08:	7f e6                	jg     800cf0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d0a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d18:	53                   	push   %ebx
  800d19:	51                   	push   %ecx
  800d1a:	52                   	push   %edx
  800d1b:	50                   	push   %eax
  800d1c:	e8 03 19 00 00       	call   802624 <__umoddi3>
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	05 14 2c 80 00       	add    $0x802c14,%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	0f be c0             	movsbl %al,%eax
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	50                   	push   %eax
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	ff d0                	call   *%eax
  800d3a:	83 c4 10             	add    $0x10,%esp
}
  800d3d:	90                   	nop
  800d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d46:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d4a:	7e 1c                	jle    800d68 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	8d 50 08             	lea    0x8(%eax),%edx
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 10                	mov    %edx,(%eax)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	83 e8 08             	sub    $0x8,%eax
  800d61:	8b 50 04             	mov    0x4(%eax),%edx
  800d64:	8b 00                	mov    (%eax),%eax
  800d66:	eb 40                	jmp    800da8 <getuint+0x65>
	else if (lflag)
  800d68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6c:	74 1e                	je     800d8c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8b 00                	mov    (%eax),%eax
  800d73:	8d 50 04             	lea    0x4(%eax),%edx
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 10                	mov    %edx,(%eax)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8b 00                	mov    (%eax),%eax
  800d80:	83 e8 04             	sub    $0x4,%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8a:	eb 1c                	jmp    800da8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8b 00                	mov    (%eax),%eax
  800d91:	8d 50 04             	lea    0x4(%eax),%edx
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	89 10                	mov    %edx,(%eax)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	83 e8 04             	sub    $0x4,%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800db1:	7e 1c                	jle    800dcf <getint+0x25>
		return va_arg(*ap, long long);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 08             	lea    0x8(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 08             	sub    $0x8,%eax
  800dc8:	8b 50 04             	mov    0x4(%eax),%edx
  800dcb:	8b 00                	mov    (%eax),%eax
  800dcd:	eb 38                	jmp    800e07 <getint+0x5d>
	else if (lflag)
  800dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd3:	74 1a                	je     800def <getint+0x45>
		return va_arg(*ap, long);
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8b 00                	mov    (%eax),%eax
  800dda:	8d 50 04             	lea    0x4(%eax),%edx
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 10                	mov    %edx,(%eax)
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	83 e8 04             	sub    $0x4,%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	99                   	cltd   
  800ded:	eb 18                	jmp    800e07 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	8d 50 04             	lea    0x4(%eax),%edx
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 10                	mov    %edx,(%eax)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	83 e8 04             	sub    $0x4,%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	99                   	cltd   
}
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e11:	eb 17                	jmp    800e2a <vprintfmt+0x21>
			if (ch == '\0')
  800e13:	85 db                	test   %ebx,%ebx
  800e15:	0f 84 c1 03 00 00    	je     8011dc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	ff 75 0c             	pushl  0xc(%ebp)
  800e21:	53                   	push   %ebx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	ff d0                	call   *%eax
  800e27:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	8d 50 01             	lea    0x1(%eax),%edx
  800e30:	89 55 10             	mov    %edx,0x10(%ebp)
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d8             	movzbl %al,%ebx
  800e38:	83 fb 25             	cmp    $0x25,%ebx
  800e3b:	75 d6                	jne    800e13 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e3d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e41:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e4f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e56:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e60:	8d 50 01             	lea    0x1(%eax),%edx
  800e63:	89 55 10             	mov    %edx,0x10(%ebp)
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	0f b6 d8             	movzbl %al,%ebx
  800e6b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e6e:	83 f8 5b             	cmp    $0x5b,%eax
  800e71:	0f 87 3d 03 00 00    	ja     8011b4 <vprintfmt+0x3ab>
  800e77:	8b 04 85 38 2c 80 00 	mov    0x802c38(,%eax,4),%eax
  800e7e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e80:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e84:	eb d7                	jmp    800e5d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e86:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e8a:	eb d1                	jmp    800e5d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	c1 e0 02             	shl    $0x2,%eax
  800e9b:	01 d0                	add    %edx,%eax
  800e9d:	01 c0                	add    %eax,%eax
  800e9f:	01 d8                	add    %ebx,%eax
  800ea1:	83 e8 30             	sub    $0x30,%eax
  800ea4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800eaf:	83 fb 2f             	cmp    $0x2f,%ebx
  800eb2:	7e 3e                	jle    800ef2 <vprintfmt+0xe9>
  800eb4:	83 fb 39             	cmp    $0x39,%ebx
  800eb7:	7f 39                	jg     800ef2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ebc:	eb d5                	jmp    800e93 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec1:	83 c0 04             	add    $0x4,%eax
  800ec4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eca:	83 e8 04             	sub    $0x4,%eax
  800ecd:	8b 00                	mov    (%eax),%eax
  800ecf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ed2:	eb 1f                	jmp    800ef3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ed4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed8:	79 83                	jns    800e5d <vprintfmt+0x54>
				width = 0;
  800eda:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ee1:	e9 77 ff ff ff       	jmp    800e5d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ee6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eed:	e9 6b ff ff ff       	jmp    800e5d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ef2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ef3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef7:	0f 89 60 ff ff ff    	jns    800e5d <vprintfmt+0x54>
				width = precision, precision = -1;
  800efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f03:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f0a:	e9 4e ff ff ff       	jmp    800e5d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f0f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f12:	e9 46 ff ff ff       	jmp    800e5d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	83 c0 04             	add    $0x4,%eax
  800f1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f20:	8b 45 14             	mov    0x14(%ebp),%eax
  800f23:	83 e8 04             	sub    $0x4,%eax
  800f26:	8b 00                	mov    (%eax),%eax
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 0c             	pushl  0xc(%ebp)
  800f2e:	50                   	push   %eax
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	ff d0                	call   *%eax
  800f34:	83 c4 10             	add    $0x10,%esp
			break;
  800f37:	e9 9b 02 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 14             	mov    %eax,0x14(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 e8 04             	sub    $0x4,%eax
  800f4b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	79 02                	jns    800f53 <vprintfmt+0x14a>
				err = -err;
  800f51:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f53:	83 fb 64             	cmp    $0x64,%ebx
  800f56:	7f 0b                	jg     800f63 <vprintfmt+0x15a>
  800f58:	8b 34 9d 80 2a 80 00 	mov    0x802a80(,%ebx,4),%esi
  800f5f:	85 f6                	test   %esi,%esi
  800f61:	75 19                	jne    800f7c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f63:	53                   	push   %ebx
  800f64:	68 25 2c 80 00       	push   $0x802c25
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	ff 75 08             	pushl  0x8(%ebp)
  800f6f:	e8 70 02 00 00       	call   8011e4 <printfmt>
  800f74:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f77:	e9 5b 02 00 00       	jmp    8011d7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f7c:	56                   	push   %esi
  800f7d:	68 2e 2c 80 00       	push   $0x802c2e
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 57 02 00 00       	call   8011e4 <printfmt>
  800f8d:	83 c4 10             	add    $0x10,%esp
			break;
  800f90:	e9 42 02 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	83 c0 04             	add    $0x4,%eax
  800f9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa1:	83 e8 04             	sub    $0x4,%eax
  800fa4:	8b 30                	mov    (%eax),%esi
  800fa6:	85 f6                	test   %esi,%esi
  800fa8:	75 05                	jne    800faf <vprintfmt+0x1a6>
				p = "(null)";
  800faa:	be 31 2c 80 00       	mov    $0x802c31,%esi
			if (width > 0 && padc != '-')
  800faf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb3:	7e 6d                	jle    801022 <vprintfmt+0x219>
  800fb5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fb9:	74 67                	je     801022 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	50                   	push   %eax
  800fc2:	56                   	push   %esi
  800fc3:	e8 26 05 00 00       	call   8014ee <strnlen>
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fce:	eb 16                	jmp    800fe6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fd0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe3:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fea:	7f e4                	jg     800fd0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fec:	eb 34                	jmp    801022 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ff2:	74 1c                	je     801010 <vprintfmt+0x207>
  800ff4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff7:	7e 05                	jle    800ffe <vprintfmt+0x1f5>
  800ff9:	83 fb 7e             	cmp    $0x7e,%ebx
  800ffc:	7e 12                	jle    801010 <vprintfmt+0x207>
					putch('?', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 3f                	push   $0x3f
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	eb 0f                	jmp    80101f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	53                   	push   %ebx
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	ff d0                	call   *%eax
  80101c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80101f:	ff 4d e4             	decl   -0x1c(%ebp)
  801022:	89 f0                	mov    %esi,%eax
  801024:	8d 70 01             	lea    0x1(%eax),%esi
  801027:	8a 00                	mov    (%eax),%al
  801029:	0f be d8             	movsbl %al,%ebx
  80102c:	85 db                	test   %ebx,%ebx
  80102e:	74 24                	je     801054 <vprintfmt+0x24b>
  801030:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801034:	78 b8                	js     800fee <vprintfmt+0x1e5>
  801036:	ff 4d e0             	decl   -0x20(%ebp)
  801039:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80103d:	79 af                	jns    800fee <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103f:	eb 13                	jmp    801054 <vprintfmt+0x24b>
				putch(' ', putdat);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 0c             	pushl  0xc(%ebp)
  801047:	6a 20                	push   $0x20
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	ff d0                	call   *%eax
  80104e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801051:	ff 4d e4             	decl   -0x1c(%ebp)
  801054:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801058:	7f e7                	jg     801041 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80105a:	e9 78 01 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80105f:	83 ec 08             	sub    $0x8,%esp
  801062:	ff 75 e8             	pushl  -0x18(%ebp)
  801065:	8d 45 14             	lea    0x14(%ebp),%eax
  801068:	50                   	push   %eax
  801069:	e8 3c fd ff ff       	call   800daa <getint>
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107d:	85 d2                	test   %edx,%edx
  80107f:	79 23                	jns    8010a4 <vprintfmt+0x29b>
				putch('-', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 2d                	push   $0x2d
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801097:	f7 d8                	neg    %eax
  801099:	83 d2 00             	adc    $0x0,%edx
  80109c:	f7 da                	neg    %edx
  80109e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ab:	e9 bc 00 00 00       	jmp    80116c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8010b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b9:	50                   	push   %eax
  8010ba:	e8 84 fc ff ff       	call   800d43 <getuint>
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010c8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010cf:	e9 98 00 00 00       	jmp    80116c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	6a 58                	push   $0x58
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	ff d0                	call   *%eax
  8010e1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	6a 58                	push   $0x58
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	ff d0                	call   *%eax
  8010f1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	ff 75 0c             	pushl  0xc(%ebp)
  8010fa:	6a 58                	push   $0x58
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	ff d0                	call   *%eax
  801101:	83 c4 10             	add    $0x10,%esp
			break;
  801104:	e9 ce 00 00 00       	jmp    8011d7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	6a 30                	push   $0x30
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	ff d0                	call   *%eax
  801116:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	6a 78                	push   $0x78
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	ff d0                	call   *%eax
  801126:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801129:	8b 45 14             	mov    0x14(%ebp),%eax
  80112c:	83 c0 04             	add    $0x4,%eax
  80112f:	89 45 14             	mov    %eax,0x14(%ebp)
  801132:	8b 45 14             	mov    0x14(%ebp),%eax
  801135:	83 e8 04             	sub    $0x4,%eax
  801138:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80113a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801144:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80114b:	eb 1f                	jmp    80116c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	ff 75 e8             	pushl  -0x18(%ebp)
  801153:	8d 45 14             	lea    0x14(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	e8 e7 fb ff ff       	call   800d43 <getuint>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801162:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801165:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80116c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801170:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	52                   	push   %edx
  801177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117a:	50                   	push   %eax
  80117b:	ff 75 f4             	pushl  -0xc(%ebp)
  80117e:	ff 75 f0             	pushl  -0x10(%ebp)
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	ff 75 08             	pushl  0x8(%ebp)
  801187:	e8 00 fb ff ff       	call   800c8c <printnum>
  80118c:	83 c4 20             	add    $0x20,%esp
			break;
  80118f:	eb 46                	jmp    8011d7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801191:	83 ec 08             	sub    $0x8,%esp
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	53                   	push   %ebx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			break;
  8011a0:	eb 35                	jmp    8011d7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011a2:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  8011a9:	eb 2c                	jmp    8011d7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011ab:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  8011b2:	eb 23                	jmp    8011d7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	6a 25                	push   $0x25
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	ff d0                	call   *%eax
  8011c1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011c4:	ff 4d 10             	decl   0x10(%ebp)
  8011c7:	eb 03                	jmp    8011cc <vprintfmt+0x3c3>
  8011c9:	ff 4d 10             	decl   0x10(%ebp)
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	48                   	dec    %eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	3c 25                	cmp    $0x25,%al
  8011d4:	75 f3                	jne    8011c9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011d6:	90                   	nop
		}
	}
  8011d7:	e9 35 fc ff ff       	jmp    800e11 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011dc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e0:	5b                   	pop    %ebx
  8011e1:	5e                   	pop    %esi
  8011e2:	5d                   	pop    %ebp
  8011e3:	c3                   	ret    

008011e4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ea:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ed:	83 c0 04             	add    $0x4,%eax
  8011f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f9:	50                   	push   %eax
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	e8 04 fc ff ff       	call   800e09 <vprintfmt>
  801205:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	8b 40 08             	mov    0x8(%eax),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	8b 10                	mov    (%eax),%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	8b 40 04             	mov    0x4(%eax),%eax
  801228:	39 c2                	cmp    %eax,%edx
  80122a:	73 12                	jae    80123e <sprintputch+0x33>
		*b->buf++ = ch;
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 48 01             	lea    0x1(%eax),%ecx
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	89 0a                	mov    %ecx,(%edx)
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	88 10                	mov    %dl,(%eax)
}
  80123e:	90                   	nop
  80123f:	5d                   	pop    %ebp
  801240:	c3                   	ret    

00801241 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80125b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801262:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801266:	74 06                	je     80126e <vsnprintf+0x2d>
  801268:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80126c:	7f 07                	jg     801275 <vsnprintf+0x34>
		return -E_INVAL;
  80126e:	b8 03 00 00 00       	mov    $0x3,%eax
  801273:	eb 20                	jmp    801295 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801275:	ff 75 14             	pushl  0x14(%ebp)
  801278:	ff 75 10             	pushl  0x10(%ebp)
  80127b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80127e:	50                   	push   %eax
  80127f:	68 0b 12 80 00       	push   $0x80120b
  801284:	e8 80 fb ff ff       	call   800e09 <vprintfmt>
  801289:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80128c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80128f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801292:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80129d:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a0:	83 c0 04             	add    $0x4,%eax
  8012a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ac:	50                   	push   %eax
  8012ad:	ff 75 0c             	pushl  0xc(%ebp)
  8012b0:	ff 75 08             	pushl  0x8(%ebp)
  8012b3:	e8 89 ff ff ff       	call   801241 <vsnprintf>
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012cd:	74 13                	je     8012e2 <readline+0x1f>
		cprintf("%s", prompt);
  8012cf:	83 ec 08             	sub    $0x8,%esp
  8012d2:	ff 75 08             	pushl  0x8(%ebp)
  8012d5:	68 a8 2d 80 00       	push   $0x802da8
  8012da:	e8 50 f9 ff ff       	call   800c2f <cprintf>
  8012df:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	6a 00                	push   $0x0
  8012ee:	e8 11 f7 ff ff       	call   800a04 <iscons>
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012f9:	e8 f3 f6 ff ff       	call   8009f1 <getchar>
  8012fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801301:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801305:	79 22                	jns    801329 <readline+0x66>
			if (c != -E_EOF)
  801307:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80130b:	0f 84 ad 00 00 00    	je     8013be <readline+0xfb>
				cprintf("read error: %e\n", c);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	ff 75 ec             	pushl  -0x14(%ebp)
  801317:	68 ab 2d 80 00       	push   $0x802dab
  80131c:	e8 0e f9 ff ff       	call   800c2f <cprintf>
  801321:	83 c4 10             	add    $0x10,%esp
			break;
  801324:	e9 95 00 00 00       	jmp    8013be <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801329:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80132d:	7e 34                	jle    801363 <readline+0xa0>
  80132f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801336:	7f 2b                	jg     801363 <readline+0xa0>
			if (echoing)
  801338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133c:	74 0e                	je     80134c <readline+0x89>
				cputchar(c);
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	ff 75 ec             	pushl  -0x14(%ebp)
  801344:	e8 89 f6 ff ff       	call   8009d2 <cputchar>
  801349:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134f:	8d 50 01             	lea    0x1(%eax),%edx
  801352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80135f:	88 10                	mov    %dl,(%eax)
  801361:	eb 56                	jmp    8013b9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801363:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801367:	75 1f                	jne    801388 <readline+0xc5>
  801369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80136d:	7e 19                	jle    801388 <readline+0xc5>
			if (echoing)
  80136f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801373:	74 0e                	je     801383 <readline+0xc0>
				cputchar(c);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 ec             	pushl  -0x14(%ebp)
  80137b:	e8 52 f6 ff ff       	call   8009d2 <cputchar>
  801380:	83 c4 10             	add    $0x10,%esp

			i--;
  801383:	ff 4d f4             	decl   -0xc(%ebp)
  801386:	eb 31                	jmp    8013b9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801388:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80138c:	74 0a                	je     801398 <readline+0xd5>
  80138e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801392:	0f 85 61 ff ff ff    	jne    8012f9 <readline+0x36>
			if (echoing)
  801398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80139c:	74 0e                	je     8013ac <readline+0xe9>
				cputchar(c);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a4:	e8 29 f6 ff ff       	call   8009d2 <cputchar>
  8013a9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013b7:	eb 06                	jmp    8013bf <readline+0xfc>
		}
	}
  8013b9:	e9 3b ff ff ff       	jmp    8012f9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013be:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013bf:	90                   	nop
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013c8:	e8 9b 09 00 00       	call   801d68 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d1:	74 13                	je     8013e6 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	ff 75 08             	pushl  0x8(%ebp)
  8013d9:	68 a8 2d 80 00       	push   $0x802da8
  8013de:	e8 4c f8 ff ff       	call   800c2f <cprintf>
  8013e3:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	6a 00                	push   $0x0
  8013f2:	e8 0d f6 ff ff       	call   800a04 <iscons>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013fd:	e8 ef f5 ff ff       	call   8009f1 <getchar>
  801402:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801405:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801409:	79 22                	jns    80142d <atomic_readline+0x6b>
				if (c != -E_EOF)
  80140b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80140f:	0f 84 ad 00 00 00    	je     8014c2 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 ec             	pushl  -0x14(%ebp)
  80141b:	68 ab 2d 80 00       	push   $0x802dab
  801420:	e8 0a f8 ff ff       	call   800c2f <cprintf>
  801425:	83 c4 10             	add    $0x10,%esp
				break;
  801428:	e9 95 00 00 00       	jmp    8014c2 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80142d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801431:	7e 34                	jle    801467 <atomic_readline+0xa5>
  801433:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80143a:	7f 2b                	jg     801467 <atomic_readline+0xa5>
				if (echoing)
  80143c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801440:	74 0e                	je     801450 <atomic_readline+0x8e>
					cputchar(c);
  801442:	83 ec 0c             	sub    $0xc,%esp
  801445:	ff 75 ec             	pushl  -0x14(%ebp)
  801448:	e8 85 f5 ff ff       	call   8009d2 <cputchar>
  80144d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801453:	8d 50 01             	lea    0x1(%eax),%edx
  801456:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801459:	89 c2                	mov    %eax,%edx
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801463:	88 10                	mov    %dl,(%eax)
  801465:	eb 56                	jmp    8014bd <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801467:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80146b:	75 1f                	jne    80148c <atomic_readline+0xca>
  80146d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801471:	7e 19                	jle    80148c <atomic_readline+0xca>
				if (echoing)
  801473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801477:	74 0e                	je     801487 <atomic_readline+0xc5>
					cputchar(c);
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	ff 75 ec             	pushl  -0x14(%ebp)
  80147f:	e8 4e f5 ff ff       	call   8009d2 <cputchar>
  801484:	83 c4 10             	add    $0x10,%esp
				i--;
  801487:	ff 4d f4             	decl   -0xc(%ebp)
  80148a:	eb 31                	jmp    8014bd <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80148c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801490:	74 0a                	je     80149c <atomic_readline+0xda>
  801492:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801496:	0f 85 61 ff ff ff    	jne    8013fd <atomic_readline+0x3b>
				if (echoing)
  80149c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a0:	74 0e                	je     8014b0 <atomic_readline+0xee>
					cputchar(c);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8014a8:	e8 25 f5 ff ff       	call   8009d2 <cputchar>
  8014ad:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8014b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014bb:	eb 06                	jmp    8014c3 <atomic_readline+0x101>
			}
		}
  8014bd:	e9 3b ff ff ff       	jmp    8013fd <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014c2:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014c3:	e8 ba 08 00 00       	call   801d82 <sys_unlock_cons>
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d8:	eb 06                	jmp    8014e0 <strlen+0x15>
		n++;
  8014da:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014dd:	ff 45 08             	incl   0x8(%ebp)
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	84 c0                	test   %al,%al
  8014e7:	75 f1                	jne    8014da <strlen+0xf>
		n++;
	return n;
  8014e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014fb:	eb 09                	jmp    801506 <strnlen+0x18>
		n++;
  8014fd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	ff 4d 0c             	decl   0xc(%ebp)
  801506:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80150a:	74 09                	je     801515 <strnlen+0x27>
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	84 c0                	test   %al,%al
  801513:	75 e8                	jne    8014fd <strnlen+0xf>
		n++;
	return n;
  801515:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801526:	90                   	nop
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8d 50 01             	lea    0x1(%eax),%edx
  80152d:	89 55 08             	mov    %edx,0x8(%ebp)
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8d 4a 01             	lea    0x1(%edx),%ecx
  801536:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801539:	8a 12                	mov    (%edx),%dl
  80153b:	88 10                	mov    %dl,(%eax)
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 e4                	jne    801527 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155b:	eb 1f                	jmp    80157c <strncpy+0x34>
		*dst++ = *src;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8d 50 01             	lea    0x1(%eax),%edx
  801563:	89 55 08             	mov    %edx,0x8(%ebp)
  801566:	8b 55 0c             	mov    0xc(%ebp),%edx
  801569:	8a 12                	mov    (%edx),%dl
  80156b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	84 c0                	test   %al,%al
  801574:	74 03                	je     801579 <strncpy+0x31>
			src++;
  801576:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801579:	ff 45 fc             	incl   -0x4(%ebp)
  80157c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801582:	72 d9                	jb     80155d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801584:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801595:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801599:	74 30                	je     8015cb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80159b:	eb 16                	jmp    8015b3 <strlcpy+0x2a>
			*dst++ = *src++;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8d 50 01             	lea    0x1(%eax),%edx
  8015a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015af:	8a 12                	mov    (%edx),%dl
  8015b1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015b3:	ff 4d 10             	decl   0x10(%ebp)
  8015b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ba:	74 09                	je     8015c5 <strlcpy+0x3c>
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	84 c0                	test   %al,%al
  8015c3:	75 d8                	jne    80159d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d1:	29 c2                	sub    %eax,%edx
  8015d3:	89 d0                	mov    %edx,%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015da:	eb 06                	jmp    8015e2 <strcmp+0xb>
		p++, q++;
  8015dc:	ff 45 08             	incl   0x8(%ebp)
  8015df:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	84 c0                	test   %al,%al
  8015e9:	74 0e                	je     8015f9 <strcmp+0x22>
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8a 10                	mov    (%eax),%dl
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	38 c2                	cmp    %al,%dl
  8015f7:	74 e3                	je     8015dc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	8a 00                	mov    (%eax),%al
  8015fe:	0f b6 d0             	movzbl %al,%edx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	0f b6 c0             	movzbl %al,%eax
  801609:	29 c2                	sub    %eax,%edx
  80160b:	89 d0                	mov    %edx,%eax
}
  80160d:	5d                   	pop    %ebp
  80160e:	c3                   	ret    

0080160f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801612:	eb 09                	jmp    80161d <strncmp+0xe>
		n--, p++, q++;
  801614:	ff 4d 10             	decl   0x10(%ebp)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80161d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801621:	74 17                	je     80163a <strncmp+0x2b>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	74 0e                	je     80163a <strncmp+0x2b>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 10                	mov    (%eax),%dl
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	38 c2                	cmp    %al,%dl
  801638:	74 da                	je     801614 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 07                	jne    801647 <strncmp+0x38>
		return 0;
  801640:	b8 00 00 00 00       	mov    $0x0,%eax
  801645:	eb 14                	jmp    80165b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	0f b6 d0             	movzbl %al,%edx
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	0f b6 c0             	movzbl %al,%eax
  801657:	29 c2                	sub    %eax,%edx
  801659:	89 d0                	mov    %edx,%eax
}
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	8b 45 0c             	mov    0xc(%ebp),%eax
  801666:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801669:	eb 12                	jmp    80167d <strchr+0x20>
		if (*s == c)
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801673:	75 05                	jne    80167a <strchr+0x1d>
			return (char *) s;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	eb 11                	jmp    80168b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80167a:	ff 45 08             	incl   0x8(%ebp)
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	8a 00                	mov    (%eax),%al
  801682:	84 c0                	test   %al,%al
  801684:	75 e5                	jne    80166b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801699:	eb 0d                	jmp    8016a8 <strfind+0x1b>
		if (*s == c)
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016a3:	74 0e                	je     8016b3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016a5:	ff 45 08             	incl   0x8(%ebp)
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	84 c0                	test   %al,%al
  8016af:	75 ea                	jne    80169b <strfind+0xe>
  8016b1:	eb 01                	jmp    8016b4 <strfind+0x27>
		if (*s == c)
			break;
  8016b3:	90                   	nop
	return (char *) s;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016cb:	eb 0e                	jmp    8016db <memset+0x22>
		*p++ = c;
  8016cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d0:	8d 50 01             	lea    0x1(%eax),%edx
  8016d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016db:	ff 4d f8             	decl   -0x8(%ebp)
  8016de:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016e2:	79 e9                	jns    8016cd <memset+0x14>
		*p++ = c;

	return v;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016fb:	eb 16                	jmp    801713 <memcpy+0x2a>
		*d++ = *s++;
  8016fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801700:	8d 50 01             	lea    0x1(%eax),%edx
  801703:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801706:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801709:	8d 4a 01             	lea    0x1(%edx),%ecx
  80170c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80170f:	8a 12                	mov    (%edx),%dl
  801711:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	8d 50 ff             	lea    -0x1(%eax),%edx
  801719:	89 55 10             	mov    %edx,0x10(%ebp)
  80171c:	85 c0                	test   %eax,%eax
  80171e:	75 dd                	jne    8016fd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80172b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801737:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80173d:	73 50                	jae    80178f <memmove+0x6a>
  80173f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801742:	8b 45 10             	mov    0x10(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80174a:	76 43                	jbe    80178f <memmove+0x6a>
		s += n;
  80174c:	8b 45 10             	mov    0x10(%ebp),%eax
  80174f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801752:	8b 45 10             	mov    0x10(%ebp),%eax
  801755:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801758:	eb 10                	jmp    80176a <memmove+0x45>
			*--d = *--s;
  80175a:	ff 4d f8             	decl   -0x8(%ebp)
  80175d:	ff 4d fc             	decl   -0x4(%ebp)
  801760:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801763:	8a 10                	mov    (%eax),%dl
  801765:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801768:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80176a:	8b 45 10             	mov    0x10(%ebp),%eax
  80176d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801770:	89 55 10             	mov    %edx,0x10(%ebp)
  801773:	85 c0                	test   %eax,%eax
  801775:	75 e3                	jne    80175a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801777:	eb 23                	jmp    80179c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801779:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177c:	8d 50 01             	lea    0x1(%eax),%edx
  80177f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801782:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801785:	8d 4a 01             	lea    0x1(%edx),%ecx
  801788:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80178b:	8a 12                	mov    (%edx),%dl
  80178d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80178f:	8b 45 10             	mov    0x10(%ebp),%eax
  801792:	8d 50 ff             	lea    -0x1(%eax),%edx
  801795:	89 55 10             	mov    %edx,0x10(%ebp)
  801798:	85 c0                	test   %eax,%eax
  80179a:	75 dd                	jne    801779 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017b3:	eb 2a                	jmp    8017df <memcmp+0x3e>
		if (*s1 != *s2)
  8017b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b8:	8a 10                	mov    (%eax),%dl
  8017ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	38 c2                	cmp    %al,%dl
  8017c1:	74 16                	je     8017d9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	0f b6 d0             	movzbl %al,%edx
  8017cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	0f b6 c0             	movzbl %al,%eax
  8017d3:	29 c2                	sub    %eax,%edx
  8017d5:	89 d0                	mov    %edx,%eax
  8017d7:	eb 18                	jmp    8017f1 <memcmp+0x50>
		s1++, s2++;
  8017d9:	ff 45 fc             	incl   -0x4(%ebp)
  8017dc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017df:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	75 c9                	jne    8017b5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801804:	eb 15                	jmp    80181b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	0f b6 d0             	movzbl %al,%edx
  80180e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801811:	0f b6 c0             	movzbl %al,%eax
  801814:	39 c2                	cmp    %eax,%edx
  801816:	74 0d                	je     801825 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801818:	ff 45 08             	incl   0x8(%ebp)
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801821:	72 e3                	jb     801806 <memfind+0x13>
  801823:	eb 01                	jmp    801826 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801825:	90                   	nop
	return (void *) s;
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801831:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80183f:	eb 03                	jmp    801844 <strtol+0x19>
		s++;
  801841:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8a 00                	mov    (%eax),%al
  801849:	3c 20                	cmp    $0x20,%al
  80184b:	74 f4                	je     801841 <strtol+0x16>
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8a 00                	mov    (%eax),%al
  801852:	3c 09                	cmp    $0x9,%al
  801854:	74 eb                	je     801841 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	3c 2b                	cmp    $0x2b,%al
  80185d:	75 05                	jne    801864 <strtol+0x39>
		s++;
  80185f:	ff 45 08             	incl   0x8(%ebp)
  801862:	eb 13                	jmp    801877 <strtol+0x4c>
	else if (*s == '-')
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	8a 00                	mov    (%eax),%al
  801869:	3c 2d                	cmp    $0x2d,%al
  80186b:	75 0a                	jne    801877 <strtol+0x4c>
		s++, neg = 1;
  80186d:	ff 45 08             	incl   0x8(%ebp)
  801870:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801877:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187b:	74 06                	je     801883 <strtol+0x58>
  80187d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801881:	75 20                	jne    8018a3 <strtol+0x78>
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8a 00                	mov    (%eax),%al
  801888:	3c 30                	cmp    $0x30,%al
  80188a:	75 17                	jne    8018a3 <strtol+0x78>
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	40                   	inc    %eax
  801890:	8a 00                	mov    (%eax),%al
  801892:	3c 78                	cmp    $0x78,%al
  801894:	75 0d                	jne    8018a3 <strtol+0x78>
		s += 2, base = 16;
  801896:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80189a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018a1:	eb 28                	jmp    8018cb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018a7:	75 15                	jne    8018be <strtol+0x93>
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	8a 00                	mov    (%eax),%al
  8018ae:	3c 30                	cmp    $0x30,%al
  8018b0:	75 0c                	jne    8018be <strtol+0x93>
		s++, base = 8;
  8018b2:	ff 45 08             	incl   0x8(%ebp)
  8018b5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018bc:	eb 0d                	jmp    8018cb <strtol+0xa0>
	else if (base == 0)
  8018be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c2:	75 07                	jne    8018cb <strtol+0xa0>
		base = 10;
  8018c4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	3c 2f                	cmp    $0x2f,%al
  8018d2:	7e 19                	jle    8018ed <strtol+0xc2>
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8a 00                	mov    (%eax),%al
  8018d9:	3c 39                	cmp    $0x39,%al
  8018db:	7f 10                	jg     8018ed <strtol+0xc2>
			dig = *s - '0';
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8a 00                	mov    (%eax),%al
  8018e2:	0f be c0             	movsbl %al,%eax
  8018e5:	83 e8 30             	sub    $0x30,%eax
  8018e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018eb:	eb 42                	jmp    80192f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	8a 00                	mov    (%eax),%al
  8018f2:	3c 60                	cmp    $0x60,%al
  8018f4:	7e 19                	jle    80190f <strtol+0xe4>
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	3c 7a                	cmp    $0x7a,%al
  8018fd:	7f 10                	jg     80190f <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8a 00                	mov    (%eax),%al
  801904:	0f be c0             	movsbl %al,%eax
  801907:	83 e8 57             	sub    $0x57,%eax
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80190d:	eb 20                	jmp    80192f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	3c 40                	cmp    $0x40,%al
  801916:	7e 39                	jle    801951 <strtol+0x126>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	3c 5a                	cmp    $0x5a,%al
  80191f:	7f 30                	jg     801951 <strtol+0x126>
			dig = *s - 'A' + 10;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	0f be c0             	movsbl %al,%eax
  801929:	83 e8 37             	sub    $0x37,%eax
  80192c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801932:	3b 45 10             	cmp    0x10(%ebp),%eax
  801935:	7d 19                	jge    801950 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801937:	ff 45 08             	incl   0x8(%ebp)
  80193a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801941:	89 c2                	mov    %eax,%edx
  801943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801946:	01 d0                	add    %edx,%eax
  801948:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80194b:	e9 7b ff ff ff       	jmp    8018cb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801950:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801951:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801955:	74 08                	je     80195f <strtol+0x134>
		*endptr = (char *) s;
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	8b 55 08             	mov    0x8(%ebp),%edx
  80195d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80195f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801963:	74 07                	je     80196c <strtol+0x141>
  801965:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801968:	f7 d8                	neg    %eax
  80196a:	eb 03                	jmp    80196f <strtol+0x144>
  80196c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <ltostr>:

void
ltostr(long value, char *str)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801977:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80197e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801985:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801989:	79 13                	jns    80199e <ltostr+0x2d>
	{
		neg = 1;
  80198b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801992:	8b 45 0c             	mov    0xc(%ebp),%eax
  801995:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801998:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80199b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019a6:	99                   	cltd   
  8019a7:	f7 f9                	idiv   %ecx
  8019a9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019af:	8d 50 01             	lea    0x1(%eax),%edx
  8019b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019b5:	89 c2                	mov    %eax,%edx
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019bf:	83 c2 30             	add    $0x30,%edx
  8019c2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019cc:	f7 e9                	imul   %ecx
  8019ce:	c1 fa 02             	sar    $0x2,%edx
  8019d1:	89 c8                	mov    %ecx,%eax
  8019d3:	c1 f8 1f             	sar    $0x1f,%eax
  8019d6:	29 c2                	sub    %eax,%edx
  8019d8:	89 d0                	mov    %edx,%eax
  8019da:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8019dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019e1:	75 bb                	jne    80199e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ed:	48                   	dec    %eax
  8019ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019f5:	74 3d                	je     801a34 <ltostr+0xc3>
		start = 1 ;
  8019f7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019fe:	eb 34                	jmp    801a34 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a06:	01 d0                	add    %edx,%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a27:	01 c2                	add    %eax,%edx
  801a29:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a2c:	88 02                	mov    %al,(%edx)
		start++ ;
  801a2e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a31:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a3a:	7c c4                	jl     801a00 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a3c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a42:	01 d0                	add    %edx,%eax
  801a44:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	e8 73 fa ff ff       	call   8014cb <strlen>
  801a58:	83 c4 04             	add    $0x4,%esp
  801a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	e8 65 fa ff ff       	call   8014cb <strlen>
  801a66:	83 c4 04             	add    $0x4,%esp
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a7a:	eb 17                	jmp    801a93 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 c2                	add    %eax,%edx
  801a84:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	01 c8                	add    %ecx,%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a90:	ff 45 fc             	incl   -0x4(%ebp)
  801a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a99:	7c e1                	jl     801a7c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801aa2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801aa9:	eb 1f                	jmp    801aca <strcconcat+0x80>
		final[s++] = str2[i] ;
  801aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aae:	8d 50 01             	lea    0x1(%eax),%edx
  801ab1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ab4:	89 c2                	mov    %eax,%edx
  801ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab9:	01 c2                	add    %eax,%edx
  801abb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac1:	01 c8                	add    %ecx,%eax
  801ac3:	8a 00                	mov    (%eax),%al
  801ac5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ac7:	ff 45 f8             	incl   -0x8(%ebp)
  801aca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801acd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ad0:	7c d9                	jl     801aab <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ad2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad8:	01 d0                	add    %edx,%eax
  801ada:	c6 00 00             	movb   $0x0,(%eax)
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801aec:	8b 45 14             	mov    0x14(%ebp),%eax
  801aef:	8b 00                	mov    (%eax),%eax
  801af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af8:	8b 45 10             	mov    0x10(%ebp),%eax
  801afb:	01 d0                	add    %edx,%eax
  801afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b03:	eb 0c                	jmp    801b11 <strsplit+0x31>
			*string++ = 0;
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	8d 50 01             	lea    0x1(%eax),%edx
  801b0b:	89 55 08             	mov    %edx,0x8(%ebp)
  801b0e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	8a 00                	mov    (%eax),%al
  801b16:	84 c0                	test   %al,%al
  801b18:	74 18                	je     801b32 <strsplit+0x52>
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	8a 00                	mov    (%eax),%al
  801b1f:	0f be c0             	movsbl %al,%eax
  801b22:	50                   	push   %eax
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	e8 32 fb ff ff       	call   80165d <strchr>
  801b2b:	83 c4 08             	add    $0x8,%esp
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	75 d3                	jne    801b05 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	84 c0                	test   %al,%al
  801b39:	74 5a                	je     801b95 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3e:	8b 00                	mov    (%eax),%eax
  801b40:	83 f8 0f             	cmp    $0xf,%eax
  801b43:	75 07                	jne    801b4c <strsplit+0x6c>
		{
			return 0;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4a:	eb 66                	jmp    801bb2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4f:	8b 00                	mov    (%eax),%eax
  801b51:	8d 48 01             	lea    0x1(%eax),%ecx
  801b54:	8b 55 14             	mov    0x14(%ebp),%edx
  801b57:	89 0a                	mov    %ecx,(%edx)
  801b59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	01 c2                	add    %eax,%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b6a:	eb 03                	jmp    801b6f <strsplit+0x8f>
			string++;
  801b6c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	8a 00                	mov    (%eax),%al
  801b74:	84 c0                	test   %al,%al
  801b76:	74 8b                	je     801b03 <strsplit+0x23>
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	8a 00                	mov    (%eax),%al
  801b7d:	0f be c0             	movsbl %al,%eax
  801b80:	50                   	push   %eax
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	e8 d4 fa ff ff       	call   80165d <strchr>
  801b89:	83 c4 08             	add    $0x8,%esp
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	74 dc                	je     801b6c <strsplit+0x8c>
			string++;
	}
  801b90:	e9 6e ff ff ff       	jmp    801b03 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b95:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b96:	8b 45 14             	mov    0x14(%ebp),%eax
  801b99:	8b 00                	mov    (%eax),%eax
  801b9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	68 bc 2d 80 00       	push   $0x802dbc
  801bc2:	68 3f 01 00 00       	push   $0x13f
  801bc7:	68 de 2d 80 00       	push   $0x802dde
  801bcc:	e8 57 07 00 00       	call   802328 <_panic>

00801bd1 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	ff 75 08             	pushl  0x8(%ebp)
  801bdd:	e8 ef 06 00 00       	call   8022d1 <sys_sbrk>
  801be2:	83 c4 10             	add    $0x10,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bf1:	75 07                	jne    801bfa <malloc+0x13>
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	eb 14                	jmp    801c0e <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 ec 2d 80 00       	push   $0x802dec
  801c02:	6a 1b                	push   $0x1b
  801c04:	68 11 2e 80 00       	push   $0x802e11
  801c09:	e8 1a 07 00 00       	call   802328 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	68 20 2e 80 00       	push   $0x802e20
  801c1e:	6a 29                	push   $0x29
  801c20:	68 11 2e 80 00       	push   $0x802e11
  801c25:	e8 fe 06 00 00       	call   802328 <_panic>

00801c2a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 18             	sub    $0x18,%esp
  801c30:	8b 45 10             	mov    0x10(%ebp),%eax
  801c33:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801c36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c3a:	75 07                	jne    801c43 <smalloc+0x19>
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	eb 14                	jmp    801c57 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	68 44 2e 80 00       	push   $0x802e44
  801c4b:	6a 38                	push   $0x38
  801c4d:	68 11 2e 80 00       	push   $0x802e11
  801c52:	e8 d1 06 00 00       	call   802328 <_panic>
	return NULL;
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c5f:	83 ec 04             	sub    $0x4,%esp
  801c62:	68 6c 2e 80 00       	push   $0x802e6c
  801c67:	6a 43                	push   $0x43
  801c69:	68 11 2e 80 00       	push   $0x802e11
  801c6e:	e8 b5 06 00 00       	call   802328 <_panic>

00801c73 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	68 90 2e 80 00       	push   $0x802e90
  801c81:	6a 5b                	push   $0x5b
  801c83:	68 11 2e 80 00       	push   $0x802e11
  801c88:	e8 9b 06 00 00       	call   802328 <_panic>

00801c8d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	68 b4 2e 80 00       	push   $0x802eb4
  801c9b:	6a 72                	push   $0x72
  801c9d:	68 11 2e 80 00       	push   $0x802e11
  801ca2:	e8 81 06 00 00       	call   802328 <_panic>

00801ca7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	68 da 2e 80 00       	push   $0x802eda
  801cb5:	6a 7e                	push   $0x7e
  801cb7:	68 11 2e 80 00       	push   $0x802e11
  801cbc:	e8 67 06 00 00       	call   802328 <_panic>

00801cc1 <shrink>:

}
void shrink(uint32 newSize)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	68 da 2e 80 00       	push   $0x802eda
  801ccf:	68 83 00 00 00       	push   $0x83
  801cd4:	68 11 2e 80 00       	push   $0x802e11
  801cd9:	e8 4a 06 00 00       	call   802328 <_panic>

00801cde <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	68 da 2e 80 00       	push   $0x802eda
  801cec:	68 88 00 00 00       	push   $0x88
  801cf1:	68 11 2e 80 00       	push   $0x802e11
  801cf6:	e8 2d 06 00 00       	call   802328 <_panic>

00801cfb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	57                   	push   %edi
  801cff:	56                   	push   %esi
  801d00:	53                   	push   %ebx
  801d01:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d10:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d13:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d16:	cd 30                	int    $0x30
  801d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    

00801d26 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	52                   	push   %edx
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	50                   	push   %eax
  801d42:	6a 00                	push   $0x0
  801d44:	e8 b2 ff ff ff       	call   801cfb <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	90                   	nop
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_cgetc>:

int
sys_cgetc(void)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 02                	push   $0x2
  801d5e:	e8 98 ff ff ff       	call   801cfb <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 03                	push   $0x3
  801d77:	e8 7f ff ff ff       	call   801cfb <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	90                   	nop
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 04                	push   $0x4
  801d91:	e8 65 ff ff ff       	call   801cfb <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	90                   	nop
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	6a 08                	push   $0x8
  801daf:	e8 47 ff ff ff       	call   801cfb <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	56                   	push   %esi
  801dbd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dbe:	8b 75 18             	mov    0x18(%ebp),%esi
  801dc1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	51                   	push   %ecx
  801dd0:	52                   	push   %edx
  801dd1:	50                   	push   %eax
  801dd2:	6a 09                	push   $0x9
  801dd4:	e8 22 ff ff ff       	call   801cfb <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 0a                	push   $0xa
  801df6:	e8 00 ff ff ff       	call   801cfb <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	ff 75 08             	pushl  0x8(%ebp)
  801e0f:	6a 0b                	push   $0xb
  801e11:	e8 e5 fe ff ff       	call   801cfb <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 0c                	push   $0xc
  801e2a:	e8 cc fe ff ff       	call   801cfb <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 0d                	push   $0xd
  801e43:	e8 b3 fe ff ff       	call   801cfb <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 0e                	push   $0xe
  801e5c:	e8 9a fe ff ff       	call   801cfb <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 0f                	push   $0xf
  801e75:	e8 81 fe ff ff       	call   801cfb <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	ff 75 08             	pushl  0x8(%ebp)
  801e8d:	6a 10                	push   $0x10
  801e8f:	e8 67 fe ff ff       	call   801cfb <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 11                	push   $0x11
  801ea8:	e8 4e fe ff ff       	call   801cfb <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_cputc>:

void
sys_cputc(const char c)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ebf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	50                   	push   %eax
  801ecc:	6a 01                	push   $0x1
  801ece:	e8 28 fe ff ff       	call   801cfb <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	90                   	nop
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 14                	push   $0x14
  801ee8:	e8 0e fe ff ff       	call   801cfb <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  801efc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	6a 00                	push   $0x0
  801f0b:	51                   	push   %ecx
  801f0c:	52                   	push   %edx
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	50                   	push   %eax
  801f11:	6a 15                	push   $0x15
  801f13:	e8 e3 fd ff ff       	call   801cfb <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	6a 16                	push   $0x16
  801f30:	e8 c6 fd ff ff       	call   801cfb <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	51                   	push   %ecx
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	6a 17                	push   $0x17
  801f4f:	e8 a7 fd ff ff       	call   801cfb <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	52                   	push   %edx
  801f69:	50                   	push   %eax
  801f6a:	6a 18                	push   $0x18
  801f6c:	e8 8a fd ff ff       	call   801cfb <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	ff 75 14             	pushl  0x14(%ebp)
  801f81:	ff 75 10             	pushl  0x10(%ebp)
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	50                   	push   %eax
  801f88:	6a 19                	push   $0x19
  801f8a:	e8 6c fd ff ff       	call   801cfb <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	50                   	push   %eax
  801fa3:	6a 1a                	push   $0x1a
  801fa5:	e8 51 fd ff ff       	call   801cfb <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	90                   	nop
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	50                   	push   %eax
  801fbf:	6a 1b                	push   $0x1b
  801fc1:	e8 35 fd ff ff       	call   801cfb <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 05                	push   $0x5
  801fda:	e8 1c fd ff ff       	call   801cfb <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 06                	push   $0x6
  801ff3:	e8 03 fd ff ff       	call   801cfb <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 07                	push   $0x7
  80200c:	e8 ea fc ff ff       	call   801cfb <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_exit_env>:


void sys_exit_env(void)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 1c                	push   $0x1c
  802025:	e8 d1 fc ff ff       	call   801cfb <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802036:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802039:	8d 50 04             	lea    0x4(%eax),%edx
  80203c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	52                   	push   %edx
  802046:	50                   	push   %eax
  802047:	6a 1d                	push   $0x1d
  802049:	e8 ad fc ff ff       	call   801cfb <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
	return result;
  802051:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802054:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802057:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80205a:	89 01                	mov    %eax,(%ecx)
  80205c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	c9                   	leave  
  802063:	c2 04 00             	ret    $0x4

00802066 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 10             	pushl  0x10(%ebp)
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	ff 75 08             	pushl  0x8(%ebp)
  802076:	6a 13                	push   $0x13
  802078:	e8 7e fc ff ff       	call   801cfb <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
	return ;
  802080:	90                   	nop
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_rcr2>:
uint32 sys_rcr2()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 1e                	push   $0x1e
  802092:	e8 64 fc ff ff       	call   801cfb <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020a8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	50                   	push   %eax
  8020b5:	6a 1f                	push   $0x1f
  8020b7:	e8 3f fc ff ff       	call   801cfb <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bf:	90                   	nop
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <rsttst>:
void rsttst()
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 21                	push   $0x21
  8020d1:	e8 25 fc ff ff       	call   801cfb <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d9:	90                   	nop
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020e8:	8b 55 18             	mov    0x18(%ebp),%edx
  8020eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	ff 75 10             	pushl  0x10(%ebp)
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	6a 20                	push   $0x20
  8020fc:	e8 fa fb ff ff       	call   801cfb <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return ;
  802104:	90                   	nop
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <chktst>:
void chktst(uint32 n)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 08             	pushl  0x8(%ebp)
  802115:	6a 22                	push   $0x22
  802117:	e8 df fb ff ff       	call   801cfb <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
	return ;
  80211f:	90                   	nop
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <inctst>:

void inctst()
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 23                	push   $0x23
  802131:	e8 c5 fb ff ff       	call   801cfb <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
	return ;
  802139:	90                   	nop
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <gettst>:
uint32 gettst()
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 24                	push   $0x24
  80214b:	e8 ab fb ff ff       	call   801cfb <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 25                	push   $0x25
  802167:	e8 8f fb ff ff       	call   801cfb <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
  80216f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802172:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802176:	75 07                	jne    80217f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802178:	b8 01 00 00 00       	mov    $0x1,%eax
  80217d:	eb 05                	jmp    802184 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 25                	push   $0x25
  802198:	e8 5e fb ff ff       	call   801cfb <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
  8021a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021a3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021a7:	75 07                	jne    8021b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ae:	eb 05                	jmp    8021b5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 25                	push   $0x25
  8021c9:	e8 2d fb ff ff       	call   801cfb <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
  8021d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021d4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021d8:	75 07                	jne    8021e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021da:	b8 01 00 00 00       	mov    $0x1,%eax
  8021df:	eb 05                	jmp    8021e6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 25                	push   $0x25
  8021fa:	e8 fc fa ff ff       	call   801cfb <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
  802202:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802205:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802209:	75 07                	jne    802212 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80220b:	b8 01 00 00 00       	mov    $0x1,%eax
  802210:	eb 05                	jmp    802217 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	ff 75 08             	pushl  0x8(%ebp)
  802227:	6a 26                	push   $0x26
  802229:	e8 cd fa ff ff       	call   801cfb <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
	return ;
  802231:	90                   	nop
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802238:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	6a 00                	push   $0x0
  802246:	53                   	push   %ebx
  802247:	51                   	push   %ecx
  802248:	52                   	push   %edx
  802249:	50                   	push   %eax
  80224a:	6a 27                	push   $0x27
  80224c:	e8 aa fa ff ff       	call   801cfb <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80225c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	52                   	push   %edx
  802269:	50                   	push   %eax
  80226a:	6a 28                	push   $0x28
  80226c:	e8 8a fa ff ff       	call   801cfb <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802279:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80227c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	6a 00                	push   $0x0
  802284:	51                   	push   %ecx
  802285:	ff 75 10             	pushl  0x10(%ebp)
  802288:	52                   	push   %edx
  802289:	50                   	push   %eax
  80228a:	6a 29                	push   $0x29
  80228c:	e8 6a fa ff ff       	call   801cfb <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	ff 75 10             	pushl  0x10(%ebp)
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	6a 12                	push   $0x12
  8022a8:	e8 4e fa ff ff       	call   801cfb <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b0:	90                   	nop
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	52                   	push   %edx
  8022c3:	50                   	push   %eax
  8022c4:	6a 2a                	push   $0x2a
  8022c6:	e8 30 fa ff ff       	call   801cfb <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
	return;
  8022ce:	90                   	nop
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 ea 2e 80 00       	push   $0x802eea
  8022df:	68 2e 01 00 00       	push   $0x12e
  8022e4:	68 fe 2e 80 00       	push   $0x802efe
  8022e9:	e8 3a 00 00 00       	call   802328 <_panic>

008022ee <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8022f4:	83 ec 04             	sub    $0x4,%esp
  8022f7:	68 ea 2e 80 00       	push   $0x802eea
  8022fc:	68 35 01 00 00       	push   $0x135
  802301:	68 fe 2e 80 00       	push   $0x802efe
  802306:	e8 1d 00 00 00       	call   802328 <_panic>

0080230b <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 ea 2e 80 00       	push   $0x802eea
  802319:	68 3b 01 00 00       	push   $0x13b
  80231e:	68 fe 2e 80 00       	push   $0x802efe
  802323:	e8 00 00 00 00       	call   802328 <_panic>

00802328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80232e:	8d 45 10             	lea    0x10(%ebp),%eax
  802331:	83 c0 04             	add    $0x4,%eax
  802334:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802337:	a1 24 40 80 00       	mov    0x804024,%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 16                	je     802356 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802340:	a1 24 40 80 00       	mov    0x804024,%eax
  802345:	83 ec 08             	sub    $0x8,%esp
  802348:	50                   	push   %eax
  802349:	68 0c 2f 80 00       	push   $0x802f0c
  80234e:	e8 dc e8 ff ff       	call   800c2f <cprintf>
  802353:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802356:	a1 00 40 80 00       	mov    0x804000,%eax
  80235b:	ff 75 0c             	pushl  0xc(%ebp)
  80235e:	ff 75 08             	pushl  0x8(%ebp)
  802361:	50                   	push   %eax
  802362:	68 11 2f 80 00       	push   $0x802f11
  802367:	e8 c3 e8 ff ff       	call   800c2f <cprintf>
  80236c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80236f:	8b 45 10             	mov    0x10(%ebp),%eax
  802372:	83 ec 08             	sub    $0x8,%esp
  802375:	ff 75 f4             	pushl  -0xc(%ebp)
  802378:	50                   	push   %eax
  802379:	e8 46 e8 ff ff       	call   800bc4 <vcprintf>
  80237e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802381:	83 ec 08             	sub    $0x8,%esp
  802384:	6a 00                	push   $0x0
  802386:	68 2d 2f 80 00       	push   $0x802f2d
  80238b:	e8 34 e8 ff ff       	call   800bc4 <vcprintf>
  802390:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802393:	e8 b5 e7 ff ff       	call   800b4d <exit>

	// should not return here
	while (1) ;
  802398:	eb fe                	jmp    802398 <_panic+0x70>

0080239a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8023a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8023a5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ae:	39 c2                	cmp    %eax,%edx
  8023b0:	74 14                	je     8023c6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	68 30 2f 80 00       	push   $0x802f30
  8023ba:	6a 26                	push   $0x26
  8023bc:	68 7c 2f 80 00       	push   $0x802f7c
  8023c1:	e8 62 ff ff ff       	call   802328 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8023c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8023cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023d4:	e9 c5 00 00 00       	jmp    80249e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	01 d0                	add    %edx,%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	75 08                	jne    8023f6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8023ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8023f1:	e9 a5 00 00 00       	jmp    80249b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8023f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8023fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802404:	eb 69                	jmp    80246f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802406:	a1 04 40 80 00       	mov    0x804004,%eax
  80240b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802414:	89 d0                	mov    %edx,%eax
  802416:	01 c0                	add    %eax,%eax
  802418:	01 d0                	add    %edx,%eax
  80241a:	c1 e0 03             	shl    $0x3,%eax
  80241d:	01 c8                	add    %ecx,%eax
  80241f:	8a 40 04             	mov    0x4(%eax),%al
  802422:	84 c0                	test   %al,%al
  802424:	75 46                	jne    80246c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802426:	a1 04 40 80 00       	mov    0x804004,%eax
  80242b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802431:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802434:	89 d0                	mov    %edx,%eax
  802436:	01 c0                	add    %eax,%eax
  802438:	01 d0                	add    %edx,%eax
  80243a:	c1 e0 03             	shl    $0x3,%eax
  80243d:	01 c8                	add    %ecx,%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80244c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	01 c8                	add    %ecx,%eax
  80245d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80245f:	39 c2                	cmp    %eax,%edx
  802461:	75 09                	jne    80246c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802463:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80246a:	eb 15                	jmp    802481 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80246c:	ff 45 e8             	incl   -0x18(%ebp)
  80246f:	a1 04 40 80 00       	mov    0x804004,%eax
  802474:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80247a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80247d:	39 c2                	cmp    %eax,%edx
  80247f:	77 85                	ja     802406 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802481:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802485:	75 14                	jne    80249b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	68 88 2f 80 00       	push   $0x802f88
  80248f:	6a 3a                	push   $0x3a
  802491:	68 7c 2f 80 00       	push   $0x802f7c
  802496:	e8 8d fe ff ff       	call   802328 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80249b:	ff 45 f0             	incl   -0x10(%ebp)
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024a4:	0f 8c 2f ff ff ff    	jl     8023d9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8024aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8024b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024b8:	eb 26                	jmp    8024e0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8024ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8024bf:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8024c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	01 c0                	add    %eax,%eax
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	c1 e0 03             	shl    $0x3,%eax
  8024d1:	01 c8                	add    %ecx,%eax
  8024d3:	8a 40 04             	mov    0x4(%eax),%al
  8024d6:	3c 01                	cmp    $0x1,%al
  8024d8:	75 03                	jne    8024dd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8024da:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8024dd:	ff 45 e0             	incl   -0x20(%ebp)
  8024e0:	a1 04 40 80 00       	mov    0x804004,%eax
  8024e5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8024eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ee:	39 c2                	cmp    %eax,%edx
  8024f0:	77 c8                	ja     8024ba <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024f8:	74 14                	je     80250e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8024fa:	83 ec 04             	sub    $0x4,%esp
  8024fd:	68 dc 2f 80 00       	push   $0x802fdc
  802502:	6a 44                	push   $0x44
  802504:	68 7c 2f 80 00       	push   $0x802f7c
  802509:	e8 1a fe ff ff       	call   802328 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80250e:	90                   	nop
  80250f:	c9                   	leave  
  802510:	c3                   	ret    
  802511:	66 90                	xchg   %ax,%ax
  802513:	90                   	nop

00802514 <__udivdi3>:
  802514:	55                   	push   %ebp
  802515:	57                   	push   %edi
  802516:	56                   	push   %esi
  802517:	53                   	push   %ebx
  802518:	83 ec 1c             	sub    $0x1c,%esp
  80251b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80251f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802527:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80252b:	89 ca                	mov    %ecx,%edx
  80252d:	89 f8                	mov    %edi,%eax
  80252f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802533:	85 f6                	test   %esi,%esi
  802535:	75 2d                	jne    802564 <__udivdi3+0x50>
  802537:	39 cf                	cmp    %ecx,%edi
  802539:	77 65                	ja     8025a0 <__udivdi3+0x8c>
  80253b:	89 fd                	mov    %edi,%ebp
  80253d:	85 ff                	test   %edi,%edi
  80253f:	75 0b                	jne    80254c <__udivdi3+0x38>
  802541:	b8 01 00 00 00       	mov    $0x1,%eax
  802546:	31 d2                	xor    %edx,%edx
  802548:	f7 f7                	div    %edi
  80254a:	89 c5                	mov    %eax,%ebp
  80254c:	31 d2                	xor    %edx,%edx
  80254e:	89 c8                	mov    %ecx,%eax
  802550:	f7 f5                	div    %ebp
  802552:	89 c1                	mov    %eax,%ecx
  802554:	89 d8                	mov    %ebx,%eax
  802556:	f7 f5                	div    %ebp
  802558:	89 cf                	mov    %ecx,%edi
  80255a:	89 fa                	mov    %edi,%edx
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	39 ce                	cmp    %ecx,%esi
  802566:	77 28                	ja     802590 <__udivdi3+0x7c>
  802568:	0f bd fe             	bsr    %esi,%edi
  80256b:	83 f7 1f             	xor    $0x1f,%edi
  80256e:	75 40                	jne    8025b0 <__udivdi3+0x9c>
  802570:	39 ce                	cmp    %ecx,%esi
  802572:	72 0a                	jb     80257e <__udivdi3+0x6a>
  802574:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802578:	0f 87 9e 00 00 00    	ja     80261c <__udivdi3+0x108>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	89 fa                	mov    %edi,%edx
  802585:	83 c4 1c             	add    $0x1c,%esp
  802588:	5b                   	pop    %ebx
  802589:	5e                   	pop    %esi
  80258a:	5f                   	pop    %edi
  80258b:	5d                   	pop    %ebp
  80258c:	c3                   	ret    
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	31 ff                	xor    %edi,%edi
  802592:	31 c0                	xor    %eax,%eax
  802594:	89 fa                	mov    %edi,%edx
  802596:	83 c4 1c             	add    $0x1c,%esp
  802599:	5b                   	pop    %ebx
  80259a:	5e                   	pop    %esi
  80259b:	5f                   	pop    %edi
  80259c:	5d                   	pop    %ebp
  80259d:	c3                   	ret    
  80259e:	66 90                	xchg   %ax,%ax
  8025a0:	89 d8                	mov    %ebx,%eax
  8025a2:	f7 f7                	div    %edi
  8025a4:	31 ff                	xor    %edi,%edi
  8025a6:	89 fa                	mov    %edi,%edx
  8025a8:	83 c4 1c             	add    $0x1c,%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025b5:	89 eb                	mov    %ebp,%ebx
  8025b7:	29 fb                	sub    %edi,%ebx
  8025b9:	89 f9                	mov    %edi,%ecx
  8025bb:	d3 e6                	shl    %cl,%esi
  8025bd:	89 c5                	mov    %eax,%ebp
  8025bf:	88 d9                	mov    %bl,%cl
  8025c1:	d3 ed                	shr    %cl,%ebp
  8025c3:	89 e9                	mov    %ebp,%ecx
  8025c5:	09 f1                	or     %esi,%ecx
  8025c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025cb:	89 f9                	mov    %edi,%ecx
  8025cd:	d3 e0                	shl    %cl,%eax
  8025cf:	89 c5                	mov    %eax,%ebp
  8025d1:	89 d6                	mov    %edx,%esi
  8025d3:	88 d9                	mov    %bl,%cl
  8025d5:	d3 ee                	shr    %cl,%esi
  8025d7:	89 f9                	mov    %edi,%ecx
  8025d9:	d3 e2                	shl    %cl,%edx
  8025db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025df:	88 d9                	mov    %bl,%cl
  8025e1:	d3 e8                	shr    %cl,%eax
  8025e3:	09 c2                	or     %eax,%edx
  8025e5:	89 d0                	mov    %edx,%eax
  8025e7:	89 f2                	mov    %esi,%edx
  8025e9:	f7 74 24 0c          	divl   0xc(%esp)
  8025ed:	89 d6                	mov    %edx,%esi
  8025ef:	89 c3                	mov    %eax,%ebx
  8025f1:	f7 e5                	mul    %ebp
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	72 19                	jb     802610 <__udivdi3+0xfc>
  8025f7:	74 0b                	je     802604 <__udivdi3+0xf0>
  8025f9:	89 d8                	mov    %ebx,%eax
  8025fb:	31 ff                	xor    %edi,%edi
  8025fd:	e9 58 ff ff ff       	jmp    80255a <__udivdi3+0x46>
  802602:	66 90                	xchg   %ax,%ax
  802604:	8b 54 24 08          	mov    0x8(%esp),%edx
  802608:	89 f9                	mov    %edi,%ecx
  80260a:	d3 e2                	shl    %cl,%edx
  80260c:	39 c2                	cmp    %eax,%edx
  80260e:	73 e9                	jae    8025f9 <__udivdi3+0xe5>
  802610:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802613:	31 ff                	xor    %edi,%edi
  802615:	e9 40 ff ff ff       	jmp    80255a <__udivdi3+0x46>
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	31 c0                	xor    %eax,%eax
  80261e:	e9 37 ff ff ff       	jmp    80255a <__udivdi3+0x46>
  802623:	90                   	nop

00802624 <__umoddi3>:
  802624:	55                   	push   %ebp
  802625:	57                   	push   %edi
  802626:	56                   	push   %esi
  802627:	53                   	push   %ebx
  802628:	83 ec 1c             	sub    $0x1c,%esp
  80262b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80262f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802637:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80263b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80263f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802643:	89 f3                	mov    %esi,%ebx
  802645:	89 fa                	mov    %edi,%edx
  802647:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80264b:	89 34 24             	mov    %esi,(%esp)
  80264e:	85 c0                	test   %eax,%eax
  802650:	75 1a                	jne    80266c <__umoddi3+0x48>
  802652:	39 f7                	cmp    %esi,%edi
  802654:	0f 86 a2 00 00 00    	jbe    8026fc <__umoddi3+0xd8>
  80265a:	89 c8                	mov    %ecx,%eax
  80265c:	89 f2                	mov    %esi,%edx
  80265e:	f7 f7                	div    %edi
  802660:	89 d0                	mov    %edx,%eax
  802662:	31 d2                	xor    %edx,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	39 f0                	cmp    %esi,%eax
  80266e:	0f 87 ac 00 00 00    	ja     802720 <__umoddi3+0xfc>
  802674:	0f bd e8             	bsr    %eax,%ebp
  802677:	83 f5 1f             	xor    $0x1f,%ebp
  80267a:	0f 84 ac 00 00 00    	je     80272c <__umoddi3+0x108>
  802680:	bf 20 00 00 00       	mov    $0x20,%edi
  802685:	29 ef                	sub    %ebp,%edi
  802687:	89 fe                	mov    %edi,%esi
  802689:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80268d:	89 e9                	mov    %ebp,%ecx
  80268f:	d3 e0                	shl    %cl,%eax
  802691:	89 d7                	mov    %edx,%edi
  802693:	89 f1                	mov    %esi,%ecx
  802695:	d3 ef                	shr    %cl,%edi
  802697:	09 c7                	or     %eax,%edi
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	d3 e2                	shl    %cl,%edx
  80269d:	89 14 24             	mov    %edx,(%esp)
  8026a0:	89 d8                	mov    %ebx,%eax
  8026a2:	d3 e0                	shl    %cl,%eax
  8026a4:	89 c2                	mov    %eax,%edx
  8026a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026aa:	d3 e0                	shl    %cl,%eax
  8026ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b4:	89 f1                	mov    %esi,%ecx
  8026b6:	d3 e8                	shr    %cl,%eax
  8026b8:	09 d0                	or     %edx,%eax
  8026ba:	d3 eb                	shr    %cl,%ebx
  8026bc:	89 da                	mov    %ebx,%edx
  8026be:	f7 f7                	div    %edi
  8026c0:	89 d3                	mov    %edx,%ebx
  8026c2:	f7 24 24             	mull   (%esp)
  8026c5:	89 c6                	mov    %eax,%esi
  8026c7:	89 d1                	mov    %edx,%ecx
  8026c9:	39 d3                	cmp    %edx,%ebx
  8026cb:	0f 82 87 00 00 00    	jb     802758 <__umoddi3+0x134>
  8026d1:	0f 84 91 00 00 00    	je     802768 <__umoddi3+0x144>
  8026d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026db:	29 f2                	sub    %esi,%edx
  8026dd:	19 cb                	sbb    %ecx,%ebx
  8026df:	89 d8                	mov    %ebx,%eax
  8026e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026e5:	d3 e0                	shl    %cl,%eax
  8026e7:	89 e9                	mov    %ebp,%ecx
  8026e9:	d3 ea                	shr    %cl,%edx
  8026eb:	09 d0                	or     %edx,%eax
  8026ed:	89 e9                	mov    %ebp,%ecx
  8026ef:	d3 eb                	shr    %cl,%ebx
  8026f1:	89 da                	mov    %ebx,%edx
  8026f3:	83 c4 1c             	add    $0x1c,%esp
  8026f6:	5b                   	pop    %ebx
  8026f7:	5e                   	pop    %esi
  8026f8:	5f                   	pop    %edi
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    
  8026fb:	90                   	nop
  8026fc:	89 fd                	mov    %edi,%ebp
  8026fe:	85 ff                	test   %edi,%edi
  802700:	75 0b                	jne    80270d <__umoddi3+0xe9>
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
  802707:	31 d2                	xor    %edx,%edx
  802709:	f7 f7                	div    %edi
  80270b:	89 c5                	mov    %eax,%ebp
  80270d:	89 f0                	mov    %esi,%eax
  80270f:	31 d2                	xor    %edx,%edx
  802711:	f7 f5                	div    %ebp
  802713:	89 c8                	mov    %ecx,%eax
  802715:	f7 f5                	div    %ebp
  802717:	89 d0                	mov    %edx,%eax
  802719:	e9 44 ff ff ff       	jmp    802662 <__umoddi3+0x3e>
  80271e:	66 90                	xchg   %ax,%ax
  802720:	89 c8                	mov    %ecx,%eax
  802722:	89 f2                	mov    %esi,%edx
  802724:	83 c4 1c             	add    $0x1c,%esp
  802727:	5b                   	pop    %ebx
  802728:	5e                   	pop    %esi
  802729:	5f                   	pop    %edi
  80272a:	5d                   	pop    %ebp
  80272b:	c3                   	ret    
  80272c:	3b 04 24             	cmp    (%esp),%eax
  80272f:	72 06                	jb     802737 <__umoddi3+0x113>
  802731:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802735:	77 0f                	ja     802746 <__umoddi3+0x122>
  802737:	89 f2                	mov    %esi,%edx
  802739:	29 f9                	sub    %edi,%ecx
  80273b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80273f:	89 14 24             	mov    %edx,(%esp)
  802742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802746:	8b 44 24 04          	mov    0x4(%esp),%eax
  80274a:	8b 14 24             	mov    (%esp),%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	2b 04 24             	sub    (%esp),%eax
  80275b:	19 fa                	sbb    %edi,%edx
  80275d:	89 d1                	mov    %edx,%ecx
  80275f:	89 c6                	mov    %eax,%esi
  802761:	e9 71 ff ff ff       	jmp    8026d7 <__umoddi3+0xb3>
  802766:	66 90                	xchg   %ax,%ax
  802768:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80276c:	72 ea                	jb     802758 <__umoddi3+0x134>
  80276e:	89 d9                	mov    %ebx,%ecx
  802770:	e9 62 ff ff ff       	jmp    8026d7 <__umoddi3+0xb3>
