
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
  80005e:	e8 12 21 00 00       	call   802175 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 20 46 80 00       	push   $0x804620
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 24 46 80 00       	push   $0x804624
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 48 46 80 00       	push   $0x804648
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 24 46 80 00       	push   $0x804624
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 20 46 80 00       	push   $0x804620
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 6c 46 80 00       	push   $0x80466c
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
  8000e6:	68 8c 46 80 00       	push   $0x80468c
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 ae 46 80 00       	push   $0x8046ae
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 bc 46 80 00       	push   $0x8046bc
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 ca 46 80 00       	push   $0x8046ca
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 da 46 80 00       	push   $0x8046da
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
  80017a:	68 e4 46 80 00       	push   $0x8046e4
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
  8001a0:	e8 ea 1f 00 00       	call   80218f <sys_unlock_cons>

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
  8002d2:	e8 9e 1e 00 00       	call   802175 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 08 47 80 00       	push   $0x804708
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 26 47 80 00       	push   $0x804726
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 3d 47 80 00       	push   $0x80473d
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 54 47 80 00       	push   $0x804754
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 da 46 80 00       	push   $0x8046da
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
  80035e:	e8 2c 1e 00 00       	call   80218f <sys_unlock_cons>


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
  8003df:	e8 91 1d 00 00       	call   802175 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 6b 47 80 00       	push   $0x80476b
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 96 1d 00 00       	call   80218f <sys_unlock_cons>

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
  80048e:	e8 e2 1c 00 00       	call   802175 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 84 47 80 00       	push   $0x804784
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
  8004c8:	e8 c2 1c 00 00       	call   80218f <sys_unlock_cons>

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
  8008bf:	e8 79 1b 00 00       	call   80243d <sys_get_virtual_time>
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
  80092b:	68 a2 47 80 00       	push   $0x8047a2
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
  800946:	68 a9 47 80 00       	push   $0x8047a9
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
  80099c:	68 ad 47 80 00       	push   $0x8047ad
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
  8009b7:	68 a9 47 80 00       	push   $0x8047a9
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
  8009e6:	e8 d5 18 00 00       	call   8022c0 <sys_cputc>
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
  8009f7:	e8 60 17 00 00       	call   80215c <sys_cgetc>
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
  800a14:	e8 d8 19 00 00       	call   8023f1 <sys_getenvindex>
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
  800a82:	e8 ee 16 00 00       	call   802175 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 d0 47 80 00       	push   $0x8047d0
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
  800ab2:	68 f8 47 80 00       	push   $0x8047f8
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
  800ae3:	68 20 48 80 00       	push   $0x804820
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 60 80 00       	mov    0x806020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 78 48 80 00       	push   $0x804878
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 d0 47 80 00       	push   $0x8047d0
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 6e 16 00 00       	call   80218f <sys_unlock_cons>
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
  800b34:	e8 84 18 00 00       	call   8023bd <sys_destroy_env>
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
  800b45:	e8 d9 18 00 00       	call   802423 <sys_exit_env>
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
  800b93:	e8 9b 15 00 00       	call   802133 <sys_cputs>
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
  800c0a:	e8 24 15 00 00       	call   802133 <sys_cputs>
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
  800c54:	e8 1c 15 00 00       	call   802175 <sys_lock_cons>
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
  800c74:	e8 16 15 00 00       	call   80218f <sys_unlock_cons>
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
  800cbe:	e8 f1 36 00 00       	call   8043b4 <__udivdi3>
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
  800d0e:	e8 b1 37 00 00       	call   8044c4 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 b4 4a 80 00       	add    $0x804ab4,%eax
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
  800e69:	8b 04 85 d8 4a 80 00 	mov    0x804ad8(,%eax,4),%eax
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
  800f4a:	8b 34 9d 20 49 80 00 	mov    0x804920(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 c5 4a 80 00       	push   $0x804ac5
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
  800f6f:	68 ce 4a 80 00       	push   $0x804ace
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
  800f9c:	be d1 4a 80 00       	mov    $0x804ad1,%esi
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
  8012c7:	68 48 4c 80 00       	push   $0x804c48
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
  801309:	68 4b 4c 80 00       	push   $0x804c4b
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
  8013ba:	e8 b6 0d 00 00       	call   802175 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 48 4c 80 00       	push   $0x804c48
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
  80140d:	68 4b 4c 80 00       	push   $0x804c4b
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
  8014b5:	e8 d5 0c 00 00       	call   80218f <sys_unlock_cons>
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
  801baf:	68 5c 4c 80 00       	push   $0x804c5c
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 7e 4c 80 00       	push   $0x804c7e
  801bbe:	e8 07 26 00 00       	call   8041ca <_panic>

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
  801bcf:	e8 0a 0b 00 00       	call   8026de <sys_sbrk>
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
  801c4a:	e8 13 09 00 00       	call   802562 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 53 0e 00 00       	call   802ab1 <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 25 09 00 00       	call   802593 <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 ec 12 00 00       	call   802f6d <alloc_block_BF>
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
  801ccc:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  801d19:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  801dd2:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  801de2:	e8 2e 09 00 00       	call   802715 <sys_allocate_user_mem>
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
  801e2a:	e8 02 09 00 00       	call   802731 <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 35 1b 00 00       	call   803975 <free_block>
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
  801e8f:	eb 2f                	jmp    801ec0 <free+0xc8>
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
  801ed2:	e8 22 08 00 00       	call   8026f9 <sys_free_user_mem>
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
  801ee0:	68 8c 4c 80 00       	push   $0x804c8c
  801ee5:	68 85 00 00 00       	push   $0x85
  801eea:	68 b6 4c 80 00       	push   $0x804cb6
  801eef:	e8 d6 22 00 00       	call   8041ca <_panic>
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
  801f55:	e8 a6 03 00 00       	call   802300 <sys_createSharedObject>
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
  801f79:	68 c2 4c 80 00       	push   $0x804cc2
  801f7e:	e8 9e ec ff ff       	call   800c21 <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801f86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f89:	a1 20 60 80 00       	mov    0x806020,%eax
  801f8e:	8b 40 78             	mov    0x78(%eax),%eax
  801f91:	29 c2                	sub    %eax,%edx
  801f93:	89 d0                	mov    %edx,%eax
  801f95:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f9a:	c1 e8 0c             	shr    $0xc,%eax
  801f9d:	89 c2                	mov    %eax,%edx
  801f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa2:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
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
  801fbd:	e8 68 03 00 00       	call   80232a <sys_getSizeOfSharedObject>
  801fc2:	83 c4 10             	add    $0x10,%esp
  801fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801fc8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fcc:	75 07                	jne    801fd5 <sget+0x27>
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	eb 7f                	jmp    802054 <sget+0xa6>
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
  802008:	eb 4a                	jmp    802054 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	ff 75 e8             	pushl  -0x18(%ebp)
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	e8 2c 03 00 00       	call   802347 <sys_getSharedObject>
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802021:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802024:	a1 20 60 80 00       	mov    0x806020,%eax
  802029:	8b 40 78             	mov    0x78(%eax),%eax
  80202c:	29 c2                	sub    %eax,%edx
  80202e:	89 d0                	mov    %edx,%eax
  802030:	2d 00 10 00 00       	sub    $0x1000,%eax
  802035:	c1 e8 0c             	shr    $0xc,%eax
  802038:	89 c2                	mov    %eax,%edx
  80203a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203d:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802044:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802048:	75 07                	jne    802051 <sget+0xa3>
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	eb 03                	jmp    802054 <sget+0xa6>
	return ptr;
  802051:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80205c:	8b 55 08             	mov    0x8(%ebp),%edx
  80205f:	a1 20 60 80 00       	mov    0x806020,%eax
  802064:	8b 40 78             	mov    0x78(%eax),%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802070:	c1 e8 0c             	shr    $0xc,%eax
  802073:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80207a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80207d:	83 ec 08             	sub    $0x8,%esp
  802080:	ff 75 08             	pushl  0x8(%ebp)
  802083:	ff 75 f4             	pushl  -0xc(%ebp)
  802086:	e8 db 02 00 00       	call   802366 <sys_freeSharedObject>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802091:	90                   	nop
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 d4 4c 80 00       	push   $0x804cd4
  8020a2:	68 de 00 00 00       	push   $0xde
  8020a7:	68 b6 4c 80 00       	push   $0x804cb6
  8020ac:	e8 19 21 00 00       	call   8041ca <_panic>

008020b1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	68 fa 4c 80 00       	push   $0x804cfa
  8020bf:	68 ea 00 00 00       	push   $0xea
  8020c4:	68 b6 4c 80 00       	push   $0x804cb6
  8020c9:	e8 fc 20 00 00       	call   8041ca <_panic>

008020ce <shrink>:

}
void shrink(uint32 newSize)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	68 fa 4c 80 00       	push   $0x804cfa
  8020dc:	68 ef 00 00 00       	push   $0xef
  8020e1:	68 b6 4c 80 00       	push   $0x804cb6
  8020e6:	e8 df 20 00 00       	call   8041ca <_panic>

008020eb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 fa 4c 80 00       	push   $0x804cfa
  8020f9:	68 f4 00 00 00       	push   $0xf4
  8020fe:	68 b6 4c 80 00       	push   $0x804cb6
  802103:	e8 c2 20 00 00       	call   8041ca <_panic>

00802108 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	57                   	push   %edi
  80210c:	56                   	push   %esi
  80210d:	53                   	push   %ebx
  80210e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80211d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802120:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802123:	cd 30                	int    $0x30
  802125:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802128:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	5b                   	pop    %ebx
  80212f:	5e                   	pop    %esi
  802130:	5f                   	pop    %edi
  802131:	5d                   	pop    %ebp
  802132:	c3                   	ret    

00802133 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	8b 45 10             	mov    0x10(%ebp),%eax
  80213c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80213f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	52                   	push   %edx
  80214b:	ff 75 0c             	pushl  0xc(%ebp)
  80214e:	50                   	push   %eax
  80214f:	6a 00                	push   $0x0
  802151:	e8 b2 ff ff ff       	call   802108 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
}
  802159:	90                   	nop
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_cgetc>:

int
sys_cgetc(void)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 02                	push   $0x2
  80216b:	e8 98 ff ff ff       	call   802108 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 03                	push   $0x3
  802184:	e8 7f ff ff ff       	call   802108 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	90                   	nop
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 04                	push   $0x4
  80219e:	e8 65 ff ff ff       	call   802108 <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	90                   	nop
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	52                   	push   %edx
  8021b9:	50                   	push   %eax
  8021ba:	6a 08                	push   $0x8
  8021bc:	e8 47 ff ff ff       	call   802108 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	56                   	push   %esi
  8021ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8021ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	56                   	push   %esi
  8021db:	53                   	push   %ebx
  8021dc:	51                   	push   %ecx
  8021dd:	52                   	push   %edx
  8021de:	50                   	push   %eax
  8021df:	6a 09                	push   $0x9
  8021e1:	e8 22 ff ff ff       	call   802108 <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
}
  8021e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ec:	5b                   	pop    %ebx
  8021ed:	5e                   	pop    %esi
  8021ee:	5d                   	pop    %ebp
  8021ef:	c3                   	ret    

008021f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	52                   	push   %edx
  802200:	50                   	push   %eax
  802201:	6a 0a                	push   $0xa
  802203:	e8 00 ff ff ff       	call   802108 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	ff 75 0c             	pushl  0xc(%ebp)
  802219:	ff 75 08             	pushl  0x8(%ebp)
  80221c:	6a 0b                	push   $0xb
  80221e:	e8 e5 fe ff ff       	call   802108 <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 0c                	push   $0xc
  802237:	e8 cc fe ff ff       	call   802108 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 0d                	push   $0xd
  802250:	e8 b3 fe ff ff       	call   802108 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 0e                	push   $0xe
  802269:	e8 9a fe ff ff       	call   802108 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
}
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 0f                	push   $0xf
  802282:	e8 81 fe ff ff       	call   802108 <syscall>
  802287:	83 c4 18             	add    $0x18,%esp
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	ff 75 08             	pushl  0x8(%ebp)
  80229a:	6a 10                	push   $0x10
  80229c:	e8 67 fe ff ff       	call   802108 <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 11                	push   $0x11
  8022b5:	e8 4e fe ff ff       	call   802108 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	50                   	push   %eax
  8022d9:	6a 01                	push   $0x1
  8022db:	e8 28 fe ff ff       	call   802108 <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 14                	push   $0x14
  8022f5:	e8 0e fe ff ff       	call   802108 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	90                   	nop
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	8b 45 10             	mov    0x10(%ebp),%eax
  802309:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80230c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80230f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	51                   	push   %ecx
  802319:	52                   	push   %edx
  80231a:	ff 75 0c             	pushl  0xc(%ebp)
  80231d:	50                   	push   %eax
  80231e:	6a 15                	push   $0x15
  802320:	e8 e3 fd ff ff       	call   802108 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80232d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	52                   	push   %edx
  80233a:	50                   	push   %eax
  80233b:	6a 16                	push   $0x16
  80233d:	e8 c6 fd ff ff       	call   802108 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80234a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	51                   	push   %ecx
  802358:	52                   	push   %edx
  802359:	50                   	push   %eax
  80235a:	6a 17                	push   $0x17
  80235c:	e8 a7 fd ff ff       	call   802108 <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	52                   	push   %edx
  802376:	50                   	push   %eax
  802377:	6a 18                	push   $0x18
  802379:	e8 8a fd ff ff       	call   802108 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	6a 00                	push   $0x0
  80238b:	ff 75 14             	pushl  0x14(%ebp)
  80238e:	ff 75 10             	pushl  0x10(%ebp)
  802391:	ff 75 0c             	pushl  0xc(%ebp)
  802394:	50                   	push   %eax
  802395:	6a 19                	push   $0x19
  802397:	e8 6c fd ff ff       	call   802108 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	50                   	push   %eax
  8023b0:	6a 1a                	push   $0x1a
  8023b2:	e8 51 fd ff ff       	call   802108 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	90                   	nop
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	50                   	push   %eax
  8023cc:	6a 1b                	push   $0x1b
  8023ce:	e8 35 fd ff ff       	call   802108 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 05                	push   $0x5
  8023e7:	e8 1c fd ff ff       	call   802108 <syscall>
  8023ec:	83 c4 18             	add    $0x18,%esp
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 06                	push   $0x6
  802400:	e8 03 fd ff ff       	call   802108 <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 07                	push   $0x7
  802419:	e8 ea fc ff ff       	call   802108 <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_exit_env>:


void sys_exit_env(void)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 1c                	push   $0x1c
  802432:	e8 d1 fc ff ff       	call   802108 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	90                   	nop
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802443:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802446:	8d 50 04             	lea    0x4(%eax),%edx
  802449:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	52                   	push   %edx
  802453:	50                   	push   %eax
  802454:	6a 1d                	push   $0x1d
  802456:	e8 ad fc ff ff       	call   802108 <syscall>
  80245b:	83 c4 18             	add    $0x18,%esp
	return result;
  80245e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802461:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802467:	89 01                	mov    %eax,(%ecx)
  802469:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	c9                   	leave  
  802470:	c2 04 00             	ret    $0x4

00802473 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	ff 75 10             	pushl  0x10(%ebp)
  80247d:	ff 75 0c             	pushl  0xc(%ebp)
  802480:	ff 75 08             	pushl  0x8(%ebp)
  802483:	6a 13                	push   $0x13
  802485:	e8 7e fc ff ff       	call   802108 <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
	return ;
  80248d:	90                   	nop
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_rcr2>:
uint32 sys_rcr2()
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 1e                	push   $0x1e
  80249f:	e8 64 fc ff ff       	call   802108 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	50                   	push   %eax
  8024c2:	6a 1f                	push   $0x1f
  8024c4:	e8 3f fc ff ff       	call   802108 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cc:	90                   	nop
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <rsttst>:
void rsttst()
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 21                	push   $0x21
  8024de:	e8 25 fc ff ff       	call   802108 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e6:	90                   	nop
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 04             	sub    $0x4,%esp
  8024ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8024f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	ff 75 10             	pushl  0x10(%ebp)
  802501:	ff 75 0c             	pushl  0xc(%ebp)
  802504:	ff 75 08             	pushl  0x8(%ebp)
  802507:	6a 20                	push   $0x20
  802509:	e8 fa fb ff ff       	call   802108 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
	return ;
  802511:	90                   	nop
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <chktst>:
void chktst(uint32 n)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	ff 75 08             	pushl  0x8(%ebp)
  802522:	6a 22                	push   $0x22
  802524:	e8 df fb ff ff       	call   802108 <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
	return ;
  80252c:	90                   	nop
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <inctst>:

void inctst()
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 23                	push   $0x23
  80253e:	e8 c5 fb ff ff       	call   802108 <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
	return ;
  802546:	90                   	nop
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <gettst>:
uint32 gettst()
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 24                	push   $0x24
  802558:	e8 ab fb ff ff       	call   802108 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 25                	push   $0x25
  802574:	e8 8f fb ff ff       	call   802108 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
  80257c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80257f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802583:	75 07                	jne    80258c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802585:	b8 01 00 00 00       	mov    $0x1,%eax
  80258a:	eb 05                	jmp    802591 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 25                	push   $0x25
  8025a5:	e8 5e fb ff ff       	call   802108 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
  8025ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b4:	75 07                	jne    8025bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	eb 05                	jmp    8025c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 25                	push   $0x25
  8025d6:	e8 2d fb ff ff       	call   802108 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
  8025de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e5:	75 07                	jne    8025ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ec:	eb 05                	jmp    8025f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 25                	push   $0x25
  802607:	e8 fc fa ff ff       	call   802108 <syscall>
  80260c:	83 c4 18             	add    $0x18,%esp
  80260f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802612:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802616:	75 07                	jne    80261f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802618:	b8 01 00 00 00       	mov    $0x1,%eax
  80261d:	eb 05                	jmp    802624 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	ff 75 08             	pushl  0x8(%ebp)
  802634:	6a 26                	push   $0x26
  802636:	e8 cd fa ff ff       	call   802108 <syscall>
  80263b:	83 c4 18             	add    $0x18,%esp
	return ;
  80263e:	90                   	nop
}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802645:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802648:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	6a 00                	push   $0x0
  802653:	53                   	push   %ebx
  802654:	51                   	push   %ecx
  802655:	52                   	push   %edx
  802656:	50                   	push   %eax
  802657:	6a 27                	push   $0x27
  802659:	e8 aa fa ff ff       	call   802108 <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
}
  802661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	52                   	push   %edx
  802676:	50                   	push   %eax
  802677:	6a 28                	push   $0x28
  802679:	e8 8a fa ff ff       	call   802108 <syscall>
  80267e:	83 c4 18             	add    $0x18,%esp
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802686:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	6a 00                	push   $0x0
  802691:	51                   	push   %ecx
  802692:	ff 75 10             	pushl  0x10(%ebp)
  802695:	52                   	push   %edx
  802696:	50                   	push   %eax
  802697:	6a 29                	push   $0x29
  802699:	e8 6a fa ff ff       	call   802108 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	ff 75 10             	pushl  0x10(%ebp)
  8026ad:	ff 75 0c             	pushl  0xc(%ebp)
  8026b0:	ff 75 08             	pushl  0x8(%ebp)
  8026b3:	6a 12                	push   $0x12
  8026b5:	e8 4e fa ff ff       	call   802108 <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bd:	90                   	nop
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	52                   	push   %edx
  8026d0:	50                   	push   %eax
  8026d1:	6a 2a                	push   $0x2a
  8026d3:	e8 30 fa ff ff       	call   802108 <syscall>
  8026d8:	83 c4 18             	add    $0x18,%esp
	return;
  8026db:	90                   	nop
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	50                   	push   %eax
  8026ed:	6a 2b                	push   $0x2b
  8026ef:	e8 14 fa ff ff       	call   802108 <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	ff 75 0c             	pushl  0xc(%ebp)
  802705:	ff 75 08             	pushl  0x8(%ebp)
  802708:	6a 2c                	push   $0x2c
  80270a:	e8 f9 f9 ff ff       	call   802108 <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
	return;
  802712:	90                   	nop
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	ff 75 0c             	pushl  0xc(%ebp)
  802721:	ff 75 08             	pushl  0x8(%ebp)
  802724:	6a 2d                	push   $0x2d
  802726:	e8 dd f9 ff ff       	call   802108 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
	return;
  80272e:	90                   	nop
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	83 e8 04             	sub    $0x4,%eax
  80273d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802740:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	83 e8 04             	sub    $0x4,%eax
  802756:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802759:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80275c:	8b 00                	mov    (%eax),%eax
  80275e:	83 e0 01             	and    $0x1,%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	0f 94 c0             	sete   %al
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80276e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802775:	8b 45 0c             	mov    0xc(%ebp),%eax
  802778:	83 f8 02             	cmp    $0x2,%eax
  80277b:	74 2b                	je     8027a8 <alloc_block+0x40>
  80277d:	83 f8 02             	cmp    $0x2,%eax
  802780:	7f 07                	jg     802789 <alloc_block+0x21>
  802782:	83 f8 01             	cmp    $0x1,%eax
  802785:	74 0e                	je     802795 <alloc_block+0x2d>
  802787:	eb 58                	jmp    8027e1 <alloc_block+0x79>
  802789:	83 f8 03             	cmp    $0x3,%eax
  80278c:	74 2d                	je     8027bb <alloc_block+0x53>
  80278e:	83 f8 04             	cmp    $0x4,%eax
  802791:	74 3b                	je     8027ce <alloc_block+0x66>
  802793:	eb 4c                	jmp    8027e1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802795:	83 ec 0c             	sub    $0xc,%esp
  802798:	ff 75 08             	pushl  0x8(%ebp)
  80279b:	e8 11 03 00 00       	call   802ab1 <alloc_block_FF>
  8027a0:	83 c4 10             	add    $0x10,%esp
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a6:	eb 4a                	jmp    8027f2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	ff 75 08             	pushl  0x8(%ebp)
  8027ae:	e8 fa 19 00 00       	call   8041ad <alloc_block_NF>
  8027b3:	83 c4 10             	add    $0x10,%esp
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b9:	eb 37                	jmp    8027f2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027bb:	83 ec 0c             	sub    $0xc,%esp
  8027be:	ff 75 08             	pushl  0x8(%ebp)
  8027c1:	e8 a7 07 00 00       	call   802f6d <alloc_block_BF>
  8027c6:	83 c4 10             	add    $0x10,%esp
  8027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027cc:	eb 24                	jmp    8027f2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027ce:	83 ec 0c             	sub    $0xc,%esp
  8027d1:	ff 75 08             	pushl  0x8(%ebp)
  8027d4:	e8 b7 19 00 00       	call   804190 <alloc_block_WF>
  8027d9:	83 c4 10             	add    $0x10,%esp
  8027dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027df:	eb 11                	jmp    8027f2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027e1:	83 ec 0c             	sub    $0xc,%esp
  8027e4:	68 0c 4d 80 00       	push   $0x804d0c
  8027e9:	e8 33 e4 ff ff       	call   800c21 <cprintf>
  8027ee:	83 c4 10             	add    $0x10,%esp
		break;
  8027f1:	90                   	nop
	}
	return va;
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	53                   	push   %ebx
  8027fb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	68 2c 4d 80 00       	push   $0x804d2c
  802806:	e8 16 e4 ff ff       	call   800c21 <cprintf>
  80280b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	68 57 4d 80 00       	push   $0x804d57
  802816:	e8 06 e4 ff ff       	call   800c21 <cprintf>
  80281b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	eb 37                	jmp    80285d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802826:	83 ec 0c             	sub    $0xc,%esp
  802829:	ff 75 f4             	pushl  -0xc(%ebp)
  80282c:	e8 19 ff ff ff       	call   80274a <is_free_block>
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	0f be d8             	movsbl %al,%ebx
  802837:	83 ec 0c             	sub    $0xc,%esp
  80283a:	ff 75 f4             	pushl  -0xc(%ebp)
  80283d:	e8 ef fe ff ff       	call   802731 <get_block_size>
  802842:	83 c4 10             	add    $0x10,%esp
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	53                   	push   %ebx
  802849:	50                   	push   %eax
  80284a:	68 6f 4d 80 00       	push   $0x804d6f
  80284f:	e8 cd e3 ff ff       	call   800c21 <cprintf>
  802854:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802857:	8b 45 10             	mov    0x10(%ebp),%eax
  80285a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802861:	74 07                	je     80286a <print_blocks_list+0x73>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 00                	mov    (%eax),%eax
  802868:	eb 05                	jmp    80286f <print_blocks_list+0x78>
  80286a:	b8 00 00 00 00       	mov    $0x0,%eax
  80286f:	89 45 10             	mov    %eax,0x10(%ebp)
  802872:	8b 45 10             	mov    0x10(%ebp),%eax
  802875:	85 c0                	test   %eax,%eax
  802877:	75 ad                	jne    802826 <print_blocks_list+0x2f>
  802879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287d:	75 a7                	jne    802826 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80287f:	83 ec 0c             	sub    $0xc,%esp
  802882:	68 2c 4d 80 00       	push   $0x804d2c
  802887:	e8 95 e3 ff ff       	call   800c21 <cprintf>
  80288c:	83 c4 10             	add    $0x10,%esp

}
  80288f:	90                   	nop
  802890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80289b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289e:	83 e0 01             	and    $0x1,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	74 03                	je     8028a8 <initialize_dynamic_allocator+0x13>
  8028a5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8028a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028ac:	0f 84 c7 01 00 00    	je     802a79 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8028b2:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8028b9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8028bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c2:	01 d0                	add    %edx,%eax
  8028c4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028c9:	0f 87 ad 01 00 00    	ja     802a7c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	0f 89 a5 01 00 00    	jns    802a7f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028da:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	83 e8 04             	sub    $0x4,%eax
  8028e5:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8028ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028f1:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8028f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f9:	e9 87 00 00 00       	jmp    802985 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802902:	75 14                	jne    802918 <initialize_dynamic_allocator+0x83>
  802904:	83 ec 04             	sub    $0x4,%esp
  802907:	68 87 4d 80 00       	push   $0x804d87
  80290c:	6a 79                	push   $0x79
  80290e:	68 a5 4d 80 00       	push   $0x804da5
  802913:	e8 b2 18 00 00       	call   8041ca <_panic>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 10                	je     802931 <initialize_dynamic_allocator+0x9c>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802929:	8b 52 04             	mov    0x4(%edx),%edx
  80292c:	89 50 04             	mov    %edx,0x4(%eax)
  80292f:	eb 0b                	jmp    80293c <initialize_dynamic_allocator+0xa7>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	a3 30 60 80 00       	mov    %eax,0x806030
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 0f                	je     802955 <initialize_dynamic_allocator+0xc0>
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294f:	8b 12                	mov    (%edx),%edx
  802951:	89 10                	mov    %edx,(%eax)
  802953:	eb 0a                	jmp    80295f <initialize_dynamic_allocator+0xca>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802972:	a1 38 60 80 00       	mov    0x806038,%eax
  802977:	48                   	dec    %eax
  802978:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80297d:	a1 34 60 80 00       	mov    0x806034,%eax
  802982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802989:	74 07                	je     802992 <initialize_dynamic_allocator+0xfd>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	eb 05                	jmp    802997 <initialize_dynamic_allocator+0x102>
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	a3 34 60 80 00       	mov    %eax,0x806034
  80299c:	a1 34 60 80 00       	mov    0x806034,%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	0f 85 55 ff ff ff    	jne    8028fe <initialize_dynamic_allocator+0x69>
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	0f 85 4b ff ff ff    	jne    8028fe <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8029c2:	a1 44 60 80 00       	mov    0x806044,%eax
  8029c7:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  8029cc:	a1 40 60 80 00       	mov    0x806040,%eax
  8029d1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	83 c0 08             	add    $0x8,%eax
  8029dd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	83 c0 04             	add    $0x4,%eax
  8029e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e9:	83 ea 08             	sub    $0x8,%edx
  8029ec:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	01 d0                	add    %edx,%eax
  8029f6:	83 e8 08             	sub    $0x8,%eax
  8029f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029fc:	83 ea 08             	sub    $0x8,%edx
  8029ff:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a18:	75 17                	jne    802a31 <initialize_dynamic_allocator+0x19c>
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 c0 4d 80 00       	push   $0x804dc0
  802a22:	68 90 00 00 00       	push   $0x90
  802a27:	68 a5 4d 80 00       	push   $0x804da5
  802a2c:	e8 99 17 00 00       	call   8041ca <_panic>
  802a31:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3a:	89 10                	mov    %edx,(%eax)
  802a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	74 0d                	je     802a52 <initialize_dynamic_allocator+0x1bd>
  802a45:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802a4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a4d:	89 50 04             	mov    %edx,0x4(%eax)
  802a50:	eb 08                	jmp    802a5a <initialize_dynamic_allocator+0x1c5>
  802a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a55:	a3 30 60 80 00       	mov    %eax,0x806030
  802a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6c:	a1 38 60 80 00       	mov    0x806038,%eax
  802a71:	40                   	inc    %eax
  802a72:	a3 38 60 80 00       	mov    %eax,0x806038
  802a77:	eb 07                	jmp    802a80 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a79:	90                   	nop
  802a7a:	eb 04                	jmp    802a80 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a7c:	90                   	nop
  802a7d:	eb 01                	jmp    802a80 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a7f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a85:	8b 45 10             	mov    0x10(%ebp),%eax
  802a88:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a94:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	83 e8 04             	sub    $0x4,%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	83 e0 fe             	and    $0xfffffffe,%eax
  802aa1:	8d 50 f8             	lea    -0x8(%eax),%edx
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	01 c2                	add    %eax,%edx
  802aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aac:	89 02                	mov    %eax,(%edx)
}
  802aae:	90                   	nop
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    

00802ab1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802ab1:	55                   	push   %ebp
  802ab2:	89 e5                	mov    %esp,%ebp
  802ab4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	83 e0 01             	and    $0x1,%eax
  802abd:	85 c0                	test   %eax,%eax
  802abf:	74 03                	je     802ac4 <alloc_block_FF+0x13>
  802ac1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ac4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ac8:	77 07                	ja     802ad1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802aca:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ad1:	a1 24 60 80 00       	mov    0x806024,%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	75 73                	jne    802b4d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	83 c0 10             	add    $0x10,%eax
  802ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ae3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af0:	01 d0                	add    %edx,%eax
  802af2:	48                   	dec    %eax
  802af3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	ba 00 00 00 00       	mov    $0x0,%edx
  802afe:	f7 75 ec             	divl   -0x14(%ebp)
  802b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b04:	29 d0                	sub    %edx,%eax
  802b06:	c1 e8 0c             	shr    $0xc,%eax
  802b09:	83 ec 0c             	sub    $0xc,%esp
  802b0c:	50                   	push   %eax
  802b0d:	e8 b1 f0 ff ff       	call   801bc3 <sbrk>
  802b12:	83 c4 10             	add    $0x10,%esp
  802b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b18:	83 ec 0c             	sub    $0xc,%esp
  802b1b:	6a 00                	push   $0x0
  802b1d:	e8 a1 f0 ff ff       	call   801bc3 <sbrk>
  802b22:	83 c4 10             	add    $0x10,%esp
  802b25:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b2e:	83 ec 08             	sub    $0x8,%esp
  802b31:	50                   	push   %eax
  802b32:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b35:	e8 5b fd ff ff       	call   802895 <initialize_dynamic_allocator>
  802b3a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b3d:	83 ec 0c             	sub    $0xc,%esp
  802b40:	68 e3 4d 80 00       	push   $0x804de3
  802b45:	e8 d7 e0 ff ff       	call   800c21 <cprintf>
  802b4a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b51:	75 0a                	jne    802b5d <alloc_block_FF+0xac>
	        return NULL;
  802b53:	b8 00 00 00 00       	mov    $0x0,%eax
  802b58:	e9 0e 04 00 00       	jmp    802f6b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b64:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6c:	e9 f3 02 00 00       	jmp    802e64 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b77:	83 ec 0c             	sub    $0xc,%esp
  802b7a:	ff 75 bc             	pushl  -0x44(%ebp)
  802b7d:	e8 af fb ff ff       	call   802731 <get_block_size>
  802b82:	83 c4 10             	add    $0x10,%esp
  802b85:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	83 c0 08             	add    $0x8,%eax
  802b8e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b91:	0f 87 c5 02 00 00    	ja     802e5c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	83 c0 18             	add    $0x18,%eax
  802b9d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ba0:	0f 87 19 02 00 00    	ja     802dbf <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ba6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ba9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bac:	83 e8 08             	sub    $0x8,%eax
  802baf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8d 50 08             	lea    0x8(%eax),%edx
  802bb8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bbb:	01 d0                	add    %edx,%eax
  802bbd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	83 c0 08             	add    $0x8,%eax
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	6a 01                	push   $0x1
  802bcb:	50                   	push   %eax
  802bcc:	ff 75 bc             	pushl  -0x44(%ebp)
  802bcf:	e8 ae fe ff ff       	call   802a82 <set_block_data>
  802bd4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	75 68                	jne    802c49 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802be1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802be5:	75 17                	jne    802bfe <alloc_block_FF+0x14d>
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 c0 4d 80 00       	push   $0x804dc0
  802bef:	68 d7 00 00 00       	push   $0xd7
  802bf4:	68 a5 4d 80 00       	push   $0x804da5
  802bf9:	e8 cc 15 00 00       	call   8041ca <_panic>
  802bfe:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802c04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c07:	89 10                	mov    %edx,(%eax)
  802c09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 0d                	je     802c1f <alloc_block_FF+0x16e>
  802c12:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c17:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c1a:	89 50 04             	mov    %edx,0x4(%eax)
  802c1d:	eb 08                	jmp    802c27 <alloc_block_FF+0x176>
  802c1f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c22:	a3 30 60 80 00       	mov    %eax,0x806030
  802c27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802c2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c39:	a1 38 60 80 00       	mov    0x806038,%eax
  802c3e:	40                   	inc    %eax
  802c3f:	a3 38 60 80 00       	mov    %eax,0x806038
  802c44:	e9 dc 00 00 00       	jmp    802d25 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	75 65                	jne    802cb7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c52:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c56:	75 17                	jne    802c6f <alloc_block_FF+0x1be>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 f4 4d 80 00       	push   $0x804df4
  802c60:	68 db 00 00 00       	push   $0xdb
  802c65:	68 a5 4d 80 00       	push   $0x804da5
  802c6a:	e8 5b 15 00 00       	call   8041ca <_panic>
  802c6f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802c75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c78:	89 50 04             	mov    %edx,0x4(%eax)
  802c7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c7e:	8b 40 04             	mov    0x4(%eax),%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	74 0c                	je     802c91 <alloc_block_FF+0x1e0>
  802c85:	a1 30 60 80 00       	mov    0x806030,%eax
  802c8a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c8d:	89 10                	mov    %edx,(%eax)
  802c8f:	eb 08                	jmp    802c99 <alloc_block_FF+0x1e8>
  802c91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c94:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802c99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c9c:	a3 30 60 80 00       	mov    %eax,0x806030
  802ca1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802caa:	a1 38 60 80 00       	mov    0x806038,%eax
  802caf:	40                   	inc    %eax
  802cb0:	a3 38 60 80 00       	mov    %eax,0x806038
  802cb5:	eb 6e                	jmp    802d25 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802cb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbb:	74 06                	je     802cc3 <alloc_block_FF+0x212>
  802cbd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cc1:	75 17                	jne    802cda <alloc_block_FF+0x229>
  802cc3:	83 ec 04             	sub    $0x4,%esp
  802cc6:	68 18 4e 80 00       	push   $0x804e18
  802ccb:	68 df 00 00 00       	push   $0xdf
  802cd0:	68 a5 4d 80 00       	push   $0x804da5
  802cd5:	e8 f0 14 00 00       	call   8041ca <_panic>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 10                	mov    (%eax),%edx
  802cdf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0b                	je     802cf8 <alloc_block_FF+0x247>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cf5:	89 50 04             	mov    %edx,0x4(%eax)
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cfe:	89 10                	mov    %edx,(%eax)
  802d00:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	75 08                	jne    802d1a <alloc_block_FF+0x269>
  802d12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d15:	a3 30 60 80 00       	mov    %eax,0x806030
  802d1a:	a1 38 60 80 00       	mov    0x806038,%eax
  802d1f:	40                   	inc    %eax
  802d20:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d29:	75 17                	jne    802d42 <alloc_block_FF+0x291>
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	68 87 4d 80 00       	push   $0x804d87
  802d33:	68 e1 00 00 00       	push   $0xe1
  802d38:	68 a5 4d 80 00       	push   $0x804da5
  802d3d:	e8 88 14 00 00       	call   8041ca <_panic>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 10                	je     802d5b <alloc_block_FF+0x2aa>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d53:	8b 52 04             	mov    0x4(%edx),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 0b                	jmp    802d66 <alloc_block_FF+0x2b5>
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	a3 30 60 80 00       	mov    %eax,0x806030
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 0f                	je     802d7f <alloc_block_FF+0x2ce>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 04             	mov    0x4(%eax),%eax
  802d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d79:	8b 12                	mov    (%edx),%edx
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	eb 0a                	jmp    802d89 <alloc_block_FF+0x2d8>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9c:	a1 38 60 80 00       	mov    0x806038,%eax
  802da1:	48                   	dec    %eax
  802da2:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	6a 00                	push   $0x0
  802dac:	ff 75 b4             	pushl  -0x4c(%ebp)
  802daf:	ff 75 b0             	pushl  -0x50(%ebp)
  802db2:	e8 cb fc ff ff       	call   802a82 <set_block_data>
  802db7:	83 c4 10             	add    $0x10,%esp
  802dba:	e9 95 00 00 00       	jmp    802e54 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802dbf:	83 ec 04             	sub    $0x4,%esp
  802dc2:	6a 01                	push   $0x1
  802dc4:	ff 75 b8             	pushl  -0x48(%ebp)
  802dc7:	ff 75 bc             	pushl  -0x44(%ebp)
  802dca:	e8 b3 fc ff ff       	call   802a82 <set_block_data>
  802dcf:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd6:	75 17                	jne    802def <alloc_block_FF+0x33e>
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	68 87 4d 80 00       	push   $0x804d87
  802de0:	68 e8 00 00 00       	push   $0xe8
  802de5:	68 a5 4d 80 00       	push   $0x804da5
  802dea:	e8 db 13 00 00       	call   8041ca <_panic>
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 10                	je     802e08 <alloc_block_FF+0x357>
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e00:	8b 52 04             	mov    0x4(%edx),%edx
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	eb 0b                	jmp    802e13 <alloc_block_FF+0x362>
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	a3 30 60 80 00       	mov    %eax,0x806030
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0f                	je     802e2c <alloc_block_FF+0x37b>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e26:	8b 12                	mov    (%edx),%edx
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	eb 0a                	jmp    802e36 <alloc_block_FF+0x385>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e49:	a1 38 60 80 00       	mov    0x806038,%eax
  802e4e:	48                   	dec    %eax
  802e4f:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802e54:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e57:	e9 0f 01 00 00       	jmp    802f6b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e5c:	a1 34 60 80 00       	mov    0x806034,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e68:	74 07                	je     802e71 <alloc_block_FF+0x3c0>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	eb 05                	jmp    802e76 <alloc_block_FF+0x3c5>
  802e71:	b8 00 00 00 00       	mov    $0x0,%eax
  802e76:	a3 34 60 80 00       	mov    %eax,0x806034
  802e7b:	a1 34 60 80 00       	mov    0x806034,%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	0f 85 e9 fc ff ff    	jne    802b71 <alloc_block_FF+0xc0>
  802e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8c:	0f 85 df fc ff ff    	jne    802b71 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	83 c0 08             	add    $0x8,%eax
  802e98:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e9b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ea2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ea5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	48                   	dec    %eax
  802eab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802eae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb6:	f7 75 d8             	divl   -0x28(%ebp)
  802eb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ebc:	29 d0                	sub    %edx,%eax
  802ebe:	c1 e8 0c             	shr    $0xc,%eax
  802ec1:	83 ec 0c             	sub    $0xc,%esp
  802ec4:	50                   	push   %eax
  802ec5:	e8 f9 ec ff ff       	call   801bc3 <sbrk>
  802eca:	83 c4 10             	add    $0x10,%esp
  802ecd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ed0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ed4:	75 0a                	jne    802ee0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  802edb:	e9 8b 00 00 00       	jmp    802f6b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ee0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ee7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eed:	01 d0                	add    %edx,%eax
  802eef:	48                   	dec    %eax
  802ef0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ef3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ef6:	ba 00 00 00 00       	mov    $0x0,%edx
  802efb:	f7 75 cc             	divl   -0x34(%ebp)
  802efe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f01:	29 d0                	sub    %edx,%eax
  802f03:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f09:	01 d0                	add    %edx,%eax
  802f0b:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  802f10:	a1 40 60 80 00       	mov    0x806040,%eax
  802f15:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f1b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f28:	01 d0                	add    %edx,%eax
  802f2a:	48                   	dec    %eax
  802f2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f31:	ba 00 00 00 00       	mov    $0x0,%edx
  802f36:	f7 75 c4             	divl   -0x3c(%ebp)
  802f39:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f3c:	29 d0                	sub    %edx,%eax
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	6a 01                	push   $0x1
  802f43:	50                   	push   %eax
  802f44:	ff 75 d0             	pushl  -0x30(%ebp)
  802f47:	e8 36 fb ff ff       	call   802a82 <set_block_data>
  802f4c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f4f:	83 ec 0c             	sub    $0xc,%esp
  802f52:	ff 75 d0             	pushl  -0x30(%ebp)
  802f55:	e8 1b 0a 00 00       	call   803975 <free_block>
  802f5a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f5d:	83 ec 0c             	sub    $0xc,%esp
  802f60:	ff 75 08             	pushl  0x8(%ebp)
  802f63:	e8 49 fb ff ff       	call   802ab1 <alloc_block_FF>
  802f68:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f6b:	c9                   	leave  
  802f6c:	c3                   	ret    

00802f6d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f6d:	55                   	push   %ebp
  802f6e:	89 e5                	mov    %esp,%ebp
  802f70:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	83 e0 01             	and    $0x1,%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 03                	je     802f80 <alloc_block_BF+0x13>
  802f7d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f80:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f84:	77 07                	ja     802f8d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f86:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f8d:	a1 24 60 80 00       	mov    0x806024,%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	75 73                	jne    803009 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	83 c0 10             	add    $0x10,%eax
  802f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f9f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802fa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fac:	01 d0                	add    %edx,%eax
  802fae:	48                   	dec    %eax
  802faf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802fba:	f7 75 e0             	divl   -0x20(%ebp)
  802fbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc0:	29 d0                	sub    %edx,%eax
  802fc2:	c1 e8 0c             	shr    $0xc,%eax
  802fc5:	83 ec 0c             	sub    $0xc,%esp
  802fc8:	50                   	push   %eax
  802fc9:	e8 f5 eb ff ff       	call   801bc3 <sbrk>
  802fce:	83 c4 10             	add    $0x10,%esp
  802fd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fd4:	83 ec 0c             	sub    $0xc,%esp
  802fd7:	6a 00                	push   $0x0
  802fd9:	e8 e5 eb ff ff       	call   801bc3 <sbrk>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fe4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fe7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fea:	83 ec 08             	sub    $0x8,%esp
  802fed:	50                   	push   %eax
  802fee:	ff 75 d8             	pushl  -0x28(%ebp)
  802ff1:	e8 9f f8 ff ff       	call   802895 <initialize_dynamic_allocator>
  802ff6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	68 e3 4d 80 00       	push   $0x804de3
  803001:	e8 1b dc ff ff       	call   800c21 <cprintf>
  803006:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803009:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803010:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803017:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80301e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803025:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80302a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302d:	e9 1d 01 00 00       	jmp    80314f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803038:	83 ec 0c             	sub    $0xc,%esp
  80303b:	ff 75 a8             	pushl  -0x58(%ebp)
  80303e:	e8 ee f6 ff ff       	call   802731 <get_block_size>
  803043:	83 c4 10             	add    $0x10,%esp
  803046:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	83 c0 08             	add    $0x8,%eax
  80304f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803052:	0f 87 ef 00 00 00    	ja     803147 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	83 c0 18             	add    $0x18,%eax
  80305e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803061:	77 1d                	ja     803080 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803066:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803069:	0f 86 d8 00 00 00    	jbe    803147 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80306f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803072:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803075:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803078:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80307b:	e9 c7 00 00 00       	jmp    803147 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	83 c0 08             	add    $0x8,%eax
  803086:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803089:	0f 85 9d 00 00 00    	jne    80312c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	6a 01                	push   $0x1
  803094:	ff 75 a4             	pushl  -0x5c(%ebp)
  803097:	ff 75 a8             	pushl  -0x58(%ebp)
  80309a:	e8 e3 f9 ff ff       	call   802a82 <set_block_data>
  80309f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8030a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a6:	75 17                	jne    8030bf <alloc_block_BF+0x152>
  8030a8:	83 ec 04             	sub    $0x4,%esp
  8030ab:	68 87 4d 80 00       	push   $0x804d87
  8030b0:	68 2c 01 00 00       	push   $0x12c
  8030b5:	68 a5 4d 80 00       	push   $0x804da5
  8030ba:	e8 0b 11 00 00       	call   8041ca <_panic>
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 10                	je     8030d8 <alloc_block_BF+0x16b>
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d0:	8b 52 04             	mov    0x4(%edx),%edx
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	eb 0b                	jmp    8030e3 <alloc_block_BF+0x176>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	a3 30 60 80 00       	mov    %eax,0x806030
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0f                	je     8030fc <alloc_block_BF+0x18f>
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f6:	8b 12                	mov    (%edx),%edx
  8030f8:	89 10                	mov    %edx,(%eax)
  8030fa:	eb 0a                	jmp    803106 <alloc_block_BF+0x199>
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803119:	a1 38 60 80 00       	mov    0x806038,%eax
  80311e:	48                   	dec    %eax
  80311f:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803124:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803127:	e9 24 04 00 00       	jmp    803550 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803132:	76 13                	jbe    803147 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803134:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80313b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80313e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803141:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803144:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803147:	a1 34 60 80 00       	mov    0x806034,%eax
  80314c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803153:	74 07                	je     80315c <alloc_block_BF+0x1ef>
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	eb 05                	jmp    803161 <alloc_block_BF+0x1f4>
  80315c:	b8 00 00 00 00       	mov    $0x0,%eax
  803161:	a3 34 60 80 00       	mov    %eax,0x806034
  803166:	a1 34 60 80 00       	mov    0x806034,%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	0f 85 bf fe ff ff    	jne    803032 <alloc_block_BF+0xc5>
  803173:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803177:	0f 85 b5 fe ff ff    	jne    803032 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80317d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803181:	0f 84 26 02 00 00    	je     8033ad <alloc_block_BF+0x440>
  803187:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80318b:	0f 85 1c 02 00 00    	jne    8033ad <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803194:	2b 45 08             	sub    0x8(%ebp),%eax
  803197:	83 e8 08             	sub    $0x8,%eax
  80319a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	8d 50 08             	lea    0x8(%eax),%edx
  8031a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a6:	01 d0                	add    %edx,%eax
  8031a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	83 c0 08             	add    $0x8,%eax
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	6a 01                	push   $0x1
  8031b6:	50                   	push   %eax
  8031b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ba:	e8 c3 f8 ff ff       	call   802a82 <set_block_data>
  8031bf:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	75 68                	jne    803234 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031d0:	75 17                	jne    8031e9 <alloc_block_BF+0x27c>
  8031d2:	83 ec 04             	sub    $0x4,%esp
  8031d5:	68 c0 4d 80 00       	push   $0x804dc0
  8031da:	68 45 01 00 00       	push   $0x145
  8031df:	68 a5 4d 80 00       	push   $0x804da5
  8031e4:	e8 e1 0f 00 00       	call   8041ca <_panic>
  8031e9:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8031ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f2:	89 10                	mov    %edx,(%eax)
  8031f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 0d                	je     80320a <alloc_block_BF+0x29d>
  8031fd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803202:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803205:	89 50 04             	mov    %edx,0x4(%eax)
  803208:	eb 08                	jmp    803212 <alloc_block_BF+0x2a5>
  80320a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80320d:	a3 30 60 80 00       	mov    %eax,0x806030
  803212:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803215:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80321a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803224:	a1 38 60 80 00       	mov    0x806038,%eax
  803229:	40                   	inc    %eax
  80322a:	a3 38 60 80 00       	mov    %eax,0x806038
  80322f:	e9 dc 00 00 00       	jmp    803310 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	75 65                	jne    8032a2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80323d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803241:	75 17                	jne    80325a <alloc_block_BF+0x2ed>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 f4 4d 80 00       	push   $0x804df4
  80324b:	68 4a 01 00 00       	push   $0x14a
  803250:	68 a5 4d 80 00       	push   $0x804da5
  803255:	e8 70 0f 00 00       	call   8041ca <_panic>
  80325a:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803260:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803263:	89 50 04             	mov    %edx,0x4(%eax)
  803266:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803269:	8b 40 04             	mov    0x4(%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 0c                	je     80327c <alloc_block_BF+0x30f>
  803270:	a1 30 60 80 00       	mov    0x806030,%eax
  803275:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	eb 08                	jmp    803284 <alloc_block_BF+0x317>
  80327c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803284:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803287:	a3 30 60 80 00       	mov    %eax,0x806030
  80328c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80328f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803295:	a1 38 60 80 00       	mov    0x806038,%eax
  80329a:	40                   	inc    %eax
  80329b:	a3 38 60 80 00       	mov    %eax,0x806038
  8032a0:	eb 6e                	jmp    803310 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8032a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a6:	74 06                	je     8032ae <alloc_block_BF+0x341>
  8032a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032ac:	75 17                	jne    8032c5 <alloc_block_BF+0x358>
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	68 18 4e 80 00       	push   $0x804e18
  8032b6:	68 4f 01 00 00       	push   $0x14f
  8032bb:	68 a5 4d 80 00       	push   $0x804da5
  8032c0:	e8 05 0f 00 00       	call   8041ca <_panic>
  8032c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c8:	8b 10                	mov    (%eax),%edx
  8032ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 0b                	je     8032e3 <alloc_block_BF+0x376>
  8032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032e0:	89 50 04             	mov    %edx,0x4(%eax)
  8032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032e9:	89 10                	mov    %edx,(%eax)
  8032eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f1:	89 50 04             	mov    %edx,0x4(%eax)
  8032f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	75 08                	jne    803305 <alloc_block_BF+0x398>
  8032fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803300:	a3 30 60 80 00       	mov    %eax,0x806030
  803305:	a1 38 60 80 00       	mov    0x806038,%eax
  80330a:	40                   	inc    %eax
  80330b:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803310:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803314:	75 17                	jne    80332d <alloc_block_BF+0x3c0>
  803316:	83 ec 04             	sub    $0x4,%esp
  803319:	68 87 4d 80 00       	push   $0x804d87
  80331e:	68 51 01 00 00       	push   $0x151
  803323:	68 a5 4d 80 00       	push   $0x804da5
  803328:	e8 9d 0e 00 00       	call   8041ca <_panic>
  80332d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 10                	je     803346 <alloc_block_BF+0x3d9>
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80333e:	8b 52 04             	mov    0x4(%edx),%edx
  803341:	89 50 04             	mov    %edx,0x4(%eax)
  803344:	eb 0b                	jmp    803351 <alloc_block_BF+0x3e4>
  803346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803349:	8b 40 04             	mov    0x4(%eax),%eax
  80334c:	a3 30 60 80 00       	mov    %eax,0x806030
  803351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803354:	8b 40 04             	mov    0x4(%eax),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	74 0f                	je     80336a <alloc_block_BF+0x3fd>
  80335b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803364:	8b 12                	mov    (%edx),%edx
  803366:	89 10                	mov    %edx,(%eax)
  803368:	eb 0a                	jmp    803374 <alloc_block_BF+0x407>
  80336a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803380:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803387:	a1 38 60 80 00       	mov    0x806038,%eax
  80338c:	48                   	dec    %eax
  80338d:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	6a 00                	push   $0x0
  803397:	ff 75 d0             	pushl  -0x30(%ebp)
  80339a:	ff 75 cc             	pushl  -0x34(%ebp)
  80339d:	e8 e0 f6 ff ff       	call   802a82 <set_block_data>
  8033a2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8033a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a8:	e9 a3 01 00 00       	jmp    803550 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8033ad:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8033b1:	0f 85 9d 00 00 00    	jne    803454 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8033b7:	83 ec 04             	sub    $0x4,%esp
  8033ba:	6a 01                	push   $0x1
  8033bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8033bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8033c2:	e8 bb f6 ff ff       	call   802a82 <set_block_data>
  8033c7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ce:	75 17                	jne    8033e7 <alloc_block_BF+0x47a>
  8033d0:	83 ec 04             	sub    $0x4,%esp
  8033d3:	68 87 4d 80 00       	push   $0x804d87
  8033d8:	68 58 01 00 00       	push   $0x158
  8033dd:	68 a5 4d 80 00       	push   $0x804da5
  8033e2:	e8 e3 0d 00 00       	call   8041ca <_panic>
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	85 c0                	test   %eax,%eax
  8033ee:	74 10                	je     803400 <alloc_block_BF+0x493>
  8033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f8:	8b 52 04             	mov    0x4(%edx),%edx
  8033fb:	89 50 04             	mov    %edx,0x4(%eax)
  8033fe:	eb 0b                	jmp    80340b <alloc_block_BF+0x49e>
  803400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803403:	8b 40 04             	mov    0x4(%eax),%eax
  803406:	a3 30 60 80 00       	mov    %eax,0x806030
  80340b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340e:	8b 40 04             	mov    0x4(%eax),%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	74 0f                	je     803424 <alloc_block_BF+0x4b7>
  803415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803418:	8b 40 04             	mov    0x4(%eax),%eax
  80341b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341e:	8b 12                	mov    (%edx),%edx
  803420:	89 10                	mov    %edx,(%eax)
  803422:	eb 0a                	jmp    80342e <alloc_block_BF+0x4c1>
  803424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803441:	a1 38 60 80 00       	mov    0x806038,%eax
  803446:	48                   	dec    %eax
  803447:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  80344c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344f:	e9 fc 00 00 00       	jmp    803550 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	83 c0 08             	add    $0x8,%eax
  80345a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80345d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803464:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803467:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80346a:	01 d0                	add    %edx,%eax
  80346c:	48                   	dec    %eax
  80346d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803470:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803473:	ba 00 00 00 00       	mov    $0x0,%edx
  803478:	f7 75 c4             	divl   -0x3c(%ebp)
  80347b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80347e:	29 d0                	sub    %edx,%eax
  803480:	c1 e8 0c             	shr    $0xc,%eax
  803483:	83 ec 0c             	sub    $0xc,%esp
  803486:	50                   	push   %eax
  803487:	e8 37 e7 ff ff       	call   801bc3 <sbrk>
  80348c:	83 c4 10             	add    $0x10,%esp
  80348f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803492:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803496:	75 0a                	jne    8034a2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
  80349d:	e9 ae 00 00 00       	jmp    803550 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034a2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8034a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034af:	01 d0                	add    %edx,%eax
  8034b1:	48                   	dec    %eax
  8034b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8034b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8034bd:	f7 75 b8             	divl   -0x48(%ebp)
  8034c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034c3:	29 d0                	sub    %edx,%eax
  8034c5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034cb:	01 d0                	add    %edx,%eax
  8034cd:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8034d2:	a1 40 60 80 00       	mov    0x806040,%eax
  8034d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8034dd:	83 ec 0c             	sub    $0xc,%esp
  8034e0:	68 4c 4e 80 00       	push   $0x804e4c
  8034e5:	e8 37 d7 ff ff       	call   800c21 <cprintf>
  8034ea:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8034ed:	83 ec 08             	sub    $0x8,%esp
  8034f0:	ff 75 bc             	pushl  -0x44(%ebp)
  8034f3:	68 51 4e 80 00       	push   $0x804e51
  8034f8:	e8 24 d7 ff ff       	call   800c21 <cprintf>
  8034fd:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803500:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803507:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80350a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80350d:	01 d0                	add    %edx,%eax
  80350f:	48                   	dec    %eax
  803510:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803513:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803516:	ba 00 00 00 00       	mov    $0x0,%edx
  80351b:	f7 75 b0             	divl   -0x50(%ebp)
  80351e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803521:	29 d0                	sub    %edx,%eax
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	6a 01                	push   $0x1
  803528:	50                   	push   %eax
  803529:	ff 75 bc             	pushl  -0x44(%ebp)
  80352c:	e8 51 f5 ff ff       	call   802a82 <set_block_data>
  803531:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803534:	83 ec 0c             	sub    $0xc,%esp
  803537:	ff 75 bc             	pushl  -0x44(%ebp)
  80353a:	e8 36 04 00 00       	call   803975 <free_block>
  80353f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803542:	83 ec 0c             	sub    $0xc,%esp
  803545:	ff 75 08             	pushl  0x8(%ebp)
  803548:	e8 20 fa ff ff       	call   802f6d <alloc_block_BF>
  80354d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803550:	c9                   	leave  
  803551:	c3                   	ret    

00803552 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803552:	55                   	push   %ebp
  803553:	89 e5                	mov    %esp,%ebp
  803555:	53                   	push   %ebx
  803556:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803567:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356b:	74 1e                	je     80358b <merging+0x39>
  80356d:	ff 75 08             	pushl  0x8(%ebp)
  803570:	e8 bc f1 ff ff       	call   802731 <get_block_size>
  803575:	83 c4 04             	add    $0x4,%esp
  803578:	89 c2                	mov    %eax,%edx
  80357a:	8b 45 08             	mov    0x8(%ebp),%eax
  80357d:	01 d0                	add    %edx,%eax
  80357f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803582:	75 07                	jne    80358b <merging+0x39>
		prev_is_free = 1;
  803584:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80358b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80358f:	74 1e                	je     8035af <merging+0x5d>
  803591:	ff 75 10             	pushl  0x10(%ebp)
  803594:	e8 98 f1 ff ff       	call   802731 <get_block_size>
  803599:	83 c4 04             	add    $0x4,%esp
  80359c:	89 c2                	mov    %eax,%edx
  80359e:	8b 45 10             	mov    0x10(%ebp),%eax
  8035a1:	01 d0                	add    %edx,%eax
  8035a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035a6:	75 07                	jne    8035af <merging+0x5d>
		next_is_free = 1;
  8035a8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8035af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b3:	0f 84 cc 00 00 00    	je     803685 <merging+0x133>
  8035b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035bd:	0f 84 c2 00 00 00    	je     803685 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8035c3:	ff 75 08             	pushl  0x8(%ebp)
  8035c6:	e8 66 f1 ff ff       	call   802731 <get_block_size>
  8035cb:	83 c4 04             	add    $0x4,%esp
  8035ce:	89 c3                	mov    %eax,%ebx
  8035d0:	ff 75 10             	pushl  0x10(%ebp)
  8035d3:	e8 59 f1 ff ff       	call   802731 <get_block_size>
  8035d8:	83 c4 04             	add    $0x4,%esp
  8035db:	01 c3                	add    %eax,%ebx
  8035dd:	ff 75 0c             	pushl  0xc(%ebp)
  8035e0:	e8 4c f1 ff ff       	call   802731 <get_block_size>
  8035e5:	83 c4 04             	add    $0x4,%esp
  8035e8:	01 d8                	add    %ebx,%eax
  8035ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035ed:	6a 00                	push   $0x0
  8035ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8035f2:	ff 75 08             	pushl  0x8(%ebp)
  8035f5:	e8 88 f4 ff ff       	call   802a82 <set_block_data>
  8035fa:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803601:	75 17                	jne    80361a <merging+0xc8>
  803603:	83 ec 04             	sub    $0x4,%esp
  803606:	68 87 4d 80 00       	push   $0x804d87
  80360b:	68 7d 01 00 00       	push   $0x17d
  803610:	68 a5 4d 80 00       	push   $0x804da5
  803615:	e8 b0 0b 00 00       	call   8041ca <_panic>
  80361a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361d:	8b 00                	mov    (%eax),%eax
  80361f:	85 c0                	test   %eax,%eax
  803621:	74 10                	je     803633 <merging+0xe1>
  803623:	8b 45 0c             	mov    0xc(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80362b:	8b 52 04             	mov    0x4(%edx),%edx
  80362e:	89 50 04             	mov    %edx,0x4(%eax)
  803631:	eb 0b                	jmp    80363e <merging+0xec>
  803633:	8b 45 0c             	mov    0xc(%ebp),%eax
  803636:	8b 40 04             	mov    0x4(%eax),%eax
  803639:	a3 30 60 80 00       	mov    %eax,0x806030
  80363e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803641:	8b 40 04             	mov    0x4(%eax),%eax
  803644:	85 c0                	test   %eax,%eax
  803646:	74 0f                	je     803657 <merging+0x105>
  803648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364b:	8b 40 04             	mov    0x4(%eax),%eax
  80364e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803651:	8b 12                	mov    (%edx),%edx
  803653:	89 10                	mov    %edx,(%eax)
  803655:	eb 0a                	jmp    803661 <merging+0x10f>
  803657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365a:	8b 00                	mov    (%eax),%eax
  80365c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803661:	8b 45 0c             	mov    0xc(%ebp),%eax
  803664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803674:	a1 38 60 80 00       	mov    0x806038,%eax
  803679:	48                   	dec    %eax
  80367a:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80367f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803680:	e9 ea 02 00 00       	jmp    80396f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803689:	74 3b                	je     8036c6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80368b:	83 ec 0c             	sub    $0xc,%esp
  80368e:	ff 75 08             	pushl  0x8(%ebp)
  803691:	e8 9b f0 ff ff       	call   802731 <get_block_size>
  803696:	83 c4 10             	add    $0x10,%esp
  803699:	89 c3                	mov    %eax,%ebx
  80369b:	83 ec 0c             	sub    $0xc,%esp
  80369e:	ff 75 10             	pushl  0x10(%ebp)
  8036a1:	e8 8b f0 ff ff       	call   802731 <get_block_size>
  8036a6:	83 c4 10             	add    $0x10,%esp
  8036a9:	01 d8                	add    %ebx,%eax
  8036ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	6a 00                	push   $0x0
  8036b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8036b6:	ff 75 08             	pushl  0x8(%ebp)
  8036b9:	e8 c4 f3 ff ff       	call   802a82 <set_block_data>
  8036be:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036c1:	e9 a9 02 00 00       	jmp    80396f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8036c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ca:	0f 84 2d 01 00 00    	je     8037fd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8036d0:	83 ec 0c             	sub    $0xc,%esp
  8036d3:	ff 75 10             	pushl  0x10(%ebp)
  8036d6:	e8 56 f0 ff ff       	call   802731 <get_block_size>
  8036db:	83 c4 10             	add    $0x10,%esp
  8036de:	89 c3                	mov    %eax,%ebx
  8036e0:	83 ec 0c             	sub    $0xc,%esp
  8036e3:	ff 75 0c             	pushl  0xc(%ebp)
  8036e6:	e8 46 f0 ff ff       	call   802731 <get_block_size>
  8036eb:	83 c4 10             	add    $0x10,%esp
  8036ee:	01 d8                	add    %ebx,%eax
  8036f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	6a 00                	push   $0x0
  8036f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036fb:	ff 75 10             	pushl  0x10(%ebp)
  8036fe:	e8 7f f3 ff ff       	call   802a82 <set_block_data>
  803703:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803706:	8b 45 10             	mov    0x10(%ebp),%eax
  803709:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80370c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803710:	74 06                	je     803718 <merging+0x1c6>
  803712:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803716:	75 17                	jne    80372f <merging+0x1dd>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 60 4e 80 00       	push   $0x804e60
  803720:	68 8d 01 00 00       	push   $0x18d
  803725:	68 a5 4d 80 00       	push   $0x804da5
  80372a:	e8 9b 0a 00 00       	call   8041ca <_panic>
  80372f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803732:	8b 50 04             	mov    0x4(%eax),%edx
  803735:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803738:	89 50 04             	mov    %edx,0x4(%eax)
  80373b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80373e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803741:	89 10                	mov    %edx,(%eax)
  803743:	8b 45 0c             	mov    0xc(%ebp),%eax
  803746:	8b 40 04             	mov    0x4(%eax),%eax
  803749:	85 c0                	test   %eax,%eax
  80374b:	74 0d                	je     80375a <merging+0x208>
  80374d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803750:	8b 40 04             	mov    0x4(%eax),%eax
  803753:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803756:	89 10                	mov    %edx,(%eax)
  803758:	eb 08                	jmp    803762 <merging+0x210>
  80375a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803762:	8b 45 0c             	mov    0xc(%ebp),%eax
  803765:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803768:	89 50 04             	mov    %edx,0x4(%eax)
  80376b:	a1 38 60 80 00       	mov    0x806038,%eax
  803770:	40                   	inc    %eax
  803771:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803776:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80377a:	75 17                	jne    803793 <merging+0x241>
  80377c:	83 ec 04             	sub    $0x4,%esp
  80377f:	68 87 4d 80 00       	push   $0x804d87
  803784:	68 8e 01 00 00       	push   $0x18e
  803789:	68 a5 4d 80 00       	push   $0x804da5
  80378e:	e8 37 0a 00 00       	call   8041ca <_panic>
  803793:	8b 45 0c             	mov    0xc(%ebp),%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	74 10                	je     8037ac <merging+0x25a>
  80379c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037a4:	8b 52 04             	mov    0x4(%edx),%edx
  8037a7:	89 50 04             	mov    %edx,0x4(%eax)
  8037aa:	eb 0b                	jmp    8037b7 <merging+0x265>
  8037ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037af:	8b 40 04             	mov    0x4(%eax),%eax
  8037b2:	a3 30 60 80 00       	mov    %eax,0x806030
  8037b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ba:	8b 40 04             	mov    0x4(%eax),%eax
  8037bd:	85 c0                	test   %eax,%eax
  8037bf:	74 0f                	je     8037d0 <merging+0x27e>
  8037c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c4:	8b 40 04             	mov    0x4(%eax),%eax
  8037c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037ca:	8b 12                	mov    (%edx),%edx
  8037cc:	89 10                	mov    %edx,(%eax)
  8037ce:	eb 0a                	jmp    8037da <merging+0x288>
  8037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d3:	8b 00                	mov    (%eax),%eax
  8037d5:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8037da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ed:	a1 38 60 80 00       	mov    0x806038,%eax
  8037f2:	48                   	dec    %eax
  8037f3:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037f8:	e9 72 01 00 00       	jmp    80396f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037fd:	8b 45 10             	mov    0x10(%ebp),%eax
  803800:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803803:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803807:	74 79                	je     803882 <merging+0x330>
  803809:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80380d:	74 73                	je     803882 <merging+0x330>
  80380f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803813:	74 06                	je     80381b <merging+0x2c9>
  803815:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803819:	75 17                	jne    803832 <merging+0x2e0>
  80381b:	83 ec 04             	sub    $0x4,%esp
  80381e:	68 18 4e 80 00       	push   $0x804e18
  803823:	68 94 01 00 00       	push   $0x194
  803828:	68 a5 4d 80 00       	push   $0x804da5
  80382d:	e8 98 09 00 00       	call   8041ca <_panic>
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 10                	mov    (%eax),%edx
  803837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383a:	89 10                	mov    %edx,(%eax)
  80383c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 0b                	je     803850 <merging+0x2fe>
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	8b 00                	mov    (%eax),%eax
  80384a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80384d:	89 50 04             	mov    %edx,0x4(%eax)
  803850:	8b 45 08             	mov    0x8(%ebp),%eax
  803853:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803856:	89 10                	mov    %edx,(%eax)
  803858:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385b:	8b 55 08             	mov    0x8(%ebp),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	85 c0                	test   %eax,%eax
  803868:	75 08                	jne    803872 <merging+0x320>
  80386a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80386d:	a3 30 60 80 00       	mov    %eax,0x806030
  803872:	a1 38 60 80 00       	mov    0x806038,%eax
  803877:	40                   	inc    %eax
  803878:	a3 38 60 80 00       	mov    %eax,0x806038
  80387d:	e9 ce 00 00 00       	jmp    803950 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803882:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803886:	74 65                	je     8038ed <merging+0x39b>
  803888:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80388c:	75 17                	jne    8038a5 <merging+0x353>
  80388e:	83 ec 04             	sub    $0x4,%esp
  803891:	68 f4 4d 80 00       	push   $0x804df4
  803896:	68 95 01 00 00       	push   $0x195
  80389b:	68 a5 4d 80 00       	push   $0x804da5
  8038a0:	e8 25 09 00 00       	call   8041ca <_panic>
  8038a5:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8038ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ae:	89 50 04             	mov    %edx,0x4(%eax)
  8038b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b4:	8b 40 04             	mov    0x4(%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 0c                	je     8038c7 <merging+0x375>
  8038bb:	a1 30 60 80 00       	mov    0x806030,%eax
  8038c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038c3:	89 10                	mov    %edx,(%eax)
  8038c5:	eb 08                	jmp    8038cf <merging+0x37d>
  8038c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ca:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d2:	a3 30 60 80 00       	mov    %eax,0x806030
  8038d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e0:	a1 38 60 80 00       	mov    0x806038,%eax
  8038e5:	40                   	inc    %eax
  8038e6:	a3 38 60 80 00       	mov    %eax,0x806038
  8038eb:	eb 63                	jmp    803950 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038f1:	75 17                	jne    80390a <merging+0x3b8>
  8038f3:	83 ec 04             	sub    $0x4,%esp
  8038f6:	68 c0 4d 80 00       	push   $0x804dc0
  8038fb:	68 98 01 00 00       	push   $0x198
  803900:	68 a5 4d 80 00       	push   $0x804da5
  803905:	e8 c0 08 00 00       	call   8041ca <_panic>
  80390a:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803913:	89 10                	mov    %edx,(%eax)
  803915:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	85 c0                	test   %eax,%eax
  80391c:	74 0d                	je     80392b <merging+0x3d9>
  80391e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803923:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803926:	89 50 04             	mov    %edx,0x4(%eax)
  803929:	eb 08                	jmp    803933 <merging+0x3e1>
  80392b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392e:	a3 30 60 80 00       	mov    %eax,0x806030
  803933:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803936:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80393b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80393e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803945:	a1 38 60 80 00       	mov    0x806038,%eax
  80394a:	40                   	inc    %eax
  80394b:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803950:	83 ec 0c             	sub    $0xc,%esp
  803953:	ff 75 10             	pushl  0x10(%ebp)
  803956:	e8 d6 ed ff ff       	call   802731 <get_block_size>
  80395b:	83 c4 10             	add    $0x10,%esp
  80395e:	83 ec 04             	sub    $0x4,%esp
  803961:	6a 00                	push   $0x0
  803963:	50                   	push   %eax
  803964:	ff 75 10             	pushl  0x10(%ebp)
  803967:	e8 16 f1 ff ff       	call   802a82 <set_block_data>
  80396c:	83 c4 10             	add    $0x10,%esp
	}
}
  80396f:	90                   	nop
  803970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803973:	c9                   	leave  
  803974:	c3                   	ret    

00803975 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803975:	55                   	push   %ebp
  803976:	89 e5                	mov    %esp,%ebp
  803978:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80397b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803980:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803983:	a1 30 60 80 00       	mov    0x806030,%eax
  803988:	3b 45 08             	cmp    0x8(%ebp),%eax
  80398b:	73 1b                	jae    8039a8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80398d:	a1 30 60 80 00       	mov    0x806030,%eax
  803992:	83 ec 04             	sub    $0x4,%esp
  803995:	ff 75 08             	pushl  0x8(%ebp)
  803998:	6a 00                	push   $0x0
  80399a:	50                   	push   %eax
  80399b:	e8 b2 fb ff ff       	call   803552 <merging>
  8039a0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039a3:	e9 8b 00 00 00       	jmp    803a33 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8039a8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039b0:	76 18                	jbe    8039ca <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8039b2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	ff 75 08             	pushl  0x8(%ebp)
  8039bd:	50                   	push   %eax
  8039be:	6a 00                	push   $0x0
  8039c0:	e8 8d fb ff ff       	call   803552 <merging>
  8039c5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039c8:	eb 69                	jmp    803a33 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039ca:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039d2:	eb 39                	jmp    803a0d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039da:	73 29                	jae    803a05 <free_block+0x90>
  8039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039df:	8b 00                	mov    (%eax),%eax
  8039e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039e4:	76 1f                	jbe    803a05 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e9:	8b 00                	mov    (%eax),%eax
  8039eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039ee:	83 ec 04             	sub    $0x4,%esp
  8039f1:	ff 75 08             	pushl  0x8(%ebp)
  8039f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8039f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8039fa:	e8 53 fb ff ff       	call   803552 <merging>
  8039ff:	83 c4 10             	add    $0x10,%esp
			break;
  803a02:	90                   	nop
		}
	}
}
  803a03:	eb 2e                	jmp    803a33 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a05:	a1 34 60 80 00       	mov    0x806034,%eax
  803a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a11:	74 07                	je     803a1a <free_block+0xa5>
  803a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	eb 05                	jmp    803a1f <free_block+0xaa>
  803a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1f:	a3 34 60 80 00       	mov    %eax,0x806034
  803a24:	a1 34 60 80 00       	mov    0x806034,%eax
  803a29:	85 c0                	test   %eax,%eax
  803a2b:	75 a7                	jne    8039d4 <free_block+0x5f>
  803a2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a31:	75 a1                	jne    8039d4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a33:	90                   	nop
  803a34:	c9                   	leave  
  803a35:	c3                   	ret    

00803a36 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a36:	55                   	push   %ebp
  803a37:	89 e5                	mov    %esp,%ebp
  803a39:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a3c:	ff 75 08             	pushl  0x8(%ebp)
  803a3f:	e8 ed ec ff ff       	call   802731 <get_block_size>
  803a44:	83 c4 04             	add    $0x4,%esp
  803a47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a51:	eb 17                	jmp    803a6a <copy_data+0x34>
  803a53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a59:	01 c2                	add    %eax,%edx
  803a5b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a61:	01 c8                	add    %ecx,%eax
  803a63:	8a 00                	mov    (%eax),%al
  803a65:	88 02                	mov    %al,(%edx)
  803a67:	ff 45 fc             	incl   -0x4(%ebp)
  803a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a70:	72 e1                	jb     803a53 <copy_data+0x1d>
}
  803a72:	90                   	nop
  803a73:	c9                   	leave  
  803a74:	c3                   	ret    

00803a75 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a75:	55                   	push   %ebp
  803a76:	89 e5                	mov    %esp,%ebp
  803a78:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a7f:	75 23                	jne    803aa4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a85:	74 13                	je     803a9a <realloc_block_FF+0x25>
  803a87:	83 ec 0c             	sub    $0xc,%esp
  803a8a:	ff 75 0c             	pushl  0xc(%ebp)
  803a8d:	e8 1f f0 ff ff       	call   802ab1 <alloc_block_FF>
  803a92:	83 c4 10             	add    $0x10,%esp
  803a95:	e9 f4 06 00 00       	jmp    80418e <realloc_block_FF+0x719>
		return NULL;
  803a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9f:	e9 ea 06 00 00       	jmp    80418e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803aa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803aa8:	75 18                	jne    803ac2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803aaa:	83 ec 0c             	sub    $0xc,%esp
  803aad:	ff 75 08             	pushl  0x8(%ebp)
  803ab0:	e8 c0 fe ff ff       	call   803975 <free_block>
  803ab5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  803abd:	e9 cc 06 00 00       	jmp    80418e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803ac2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803ac6:	77 07                	ja     803acf <realloc_block_FF+0x5a>
  803ac8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad2:	83 e0 01             	and    $0x1,%eax
  803ad5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803adb:	83 c0 08             	add    $0x8,%eax
  803ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803ae1:	83 ec 0c             	sub    $0xc,%esp
  803ae4:	ff 75 08             	pushl  0x8(%ebp)
  803ae7:	e8 45 ec ff ff       	call   802731 <get_block_size>
  803aec:	83 c4 10             	add    $0x10,%esp
  803aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af5:	83 e8 08             	sub    $0x8,%eax
  803af8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803afb:	8b 45 08             	mov    0x8(%ebp),%eax
  803afe:	83 e8 04             	sub    $0x4,%eax
  803b01:	8b 00                	mov    (%eax),%eax
  803b03:	83 e0 fe             	and    $0xfffffffe,%eax
  803b06:	89 c2                	mov    %eax,%edx
  803b08:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0b:	01 d0                	add    %edx,%eax
  803b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803b10:	83 ec 0c             	sub    $0xc,%esp
  803b13:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b16:	e8 16 ec ff ff       	call   802731 <get_block_size>
  803b1b:	83 c4 10             	add    $0x10,%esp
  803b1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b24:	83 e8 08             	sub    $0x8,%eax
  803b27:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b30:	75 08                	jne    803b3a <realloc_block_FF+0xc5>
	{
		 return va;
  803b32:	8b 45 08             	mov    0x8(%ebp),%eax
  803b35:	e9 54 06 00 00       	jmp    80418e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b40:	0f 83 e5 03 00 00    	jae    803f2b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b49:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b4f:	83 ec 0c             	sub    $0xc,%esp
  803b52:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b55:	e8 f0 eb ff ff       	call   80274a <is_free_block>
  803b5a:	83 c4 10             	add    $0x10,%esp
  803b5d:	84 c0                	test   %al,%al
  803b5f:	0f 84 3b 01 00 00    	je     803ca0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b6b:	01 d0                	add    %edx,%eax
  803b6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b70:	83 ec 04             	sub    $0x4,%esp
  803b73:	6a 01                	push   $0x1
  803b75:	ff 75 f0             	pushl  -0x10(%ebp)
  803b78:	ff 75 08             	pushl  0x8(%ebp)
  803b7b:	e8 02 ef ff ff       	call   802a82 <set_block_data>
  803b80:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b83:	8b 45 08             	mov    0x8(%ebp),%eax
  803b86:	83 e8 04             	sub    $0x4,%eax
  803b89:	8b 00                	mov    (%eax),%eax
  803b8b:	83 e0 fe             	and    $0xfffffffe,%eax
  803b8e:	89 c2                	mov    %eax,%edx
  803b90:	8b 45 08             	mov    0x8(%ebp),%eax
  803b93:	01 d0                	add    %edx,%eax
  803b95:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b98:	83 ec 04             	sub    $0x4,%esp
  803b9b:	6a 00                	push   $0x0
  803b9d:	ff 75 cc             	pushl  -0x34(%ebp)
  803ba0:	ff 75 c8             	pushl  -0x38(%ebp)
  803ba3:	e8 da ee ff ff       	call   802a82 <set_block_data>
  803ba8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803bab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803baf:	74 06                	je     803bb7 <realloc_block_FF+0x142>
  803bb1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803bb5:	75 17                	jne    803bce <realloc_block_FF+0x159>
  803bb7:	83 ec 04             	sub    $0x4,%esp
  803bba:	68 18 4e 80 00       	push   $0x804e18
  803bbf:	68 f6 01 00 00       	push   $0x1f6
  803bc4:	68 a5 4d 80 00       	push   $0x804da5
  803bc9:	e8 fc 05 00 00       	call   8041ca <_panic>
  803bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd1:	8b 10                	mov    (%eax),%edx
  803bd3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bd6:	89 10                	mov    %edx,(%eax)
  803bd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bdb:	8b 00                	mov    (%eax),%eax
  803bdd:	85 c0                	test   %eax,%eax
  803bdf:	74 0b                	je     803bec <realloc_block_FF+0x177>
  803be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be4:	8b 00                	mov    (%eax),%eax
  803be6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803be9:	89 50 04             	mov    %edx,0x4(%eax)
  803bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bf2:	89 10                	mov    %edx,(%eax)
  803bf4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bfa:	89 50 04             	mov    %edx,0x4(%eax)
  803bfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c00:	8b 00                	mov    (%eax),%eax
  803c02:	85 c0                	test   %eax,%eax
  803c04:	75 08                	jne    803c0e <realloc_block_FF+0x199>
  803c06:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c09:	a3 30 60 80 00       	mov    %eax,0x806030
  803c0e:	a1 38 60 80 00       	mov    0x806038,%eax
  803c13:	40                   	inc    %eax
  803c14:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c1d:	75 17                	jne    803c36 <realloc_block_FF+0x1c1>
  803c1f:	83 ec 04             	sub    $0x4,%esp
  803c22:	68 87 4d 80 00       	push   $0x804d87
  803c27:	68 f7 01 00 00       	push   $0x1f7
  803c2c:	68 a5 4d 80 00       	push   $0x804da5
  803c31:	e8 94 05 00 00       	call   8041ca <_panic>
  803c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c39:	8b 00                	mov    (%eax),%eax
  803c3b:	85 c0                	test   %eax,%eax
  803c3d:	74 10                	je     803c4f <realloc_block_FF+0x1da>
  803c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c42:	8b 00                	mov    (%eax),%eax
  803c44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c47:	8b 52 04             	mov    0x4(%edx),%edx
  803c4a:	89 50 04             	mov    %edx,0x4(%eax)
  803c4d:	eb 0b                	jmp    803c5a <realloc_block_FF+0x1e5>
  803c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c52:	8b 40 04             	mov    0x4(%eax),%eax
  803c55:	a3 30 60 80 00       	mov    %eax,0x806030
  803c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5d:	8b 40 04             	mov    0x4(%eax),%eax
  803c60:	85 c0                	test   %eax,%eax
  803c62:	74 0f                	je     803c73 <realloc_block_FF+0x1fe>
  803c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c67:	8b 40 04             	mov    0x4(%eax),%eax
  803c6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c6d:	8b 12                	mov    (%edx),%edx
  803c6f:	89 10                	mov    %edx,(%eax)
  803c71:	eb 0a                	jmp    803c7d <realloc_block_FF+0x208>
  803c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c76:	8b 00                	mov    (%eax),%eax
  803c78:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c90:	a1 38 60 80 00       	mov    0x806038,%eax
  803c95:	48                   	dec    %eax
  803c96:	a3 38 60 80 00       	mov    %eax,0x806038
  803c9b:	e9 83 02 00 00       	jmp    803f23 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803ca0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803ca4:	0f 86 69 02 00 00    	jbe    803f13 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803caa:	83 ec 04             	sub    $0x4,%esp
  803cad:	6a 01                	push   $0x1
  803caf:	ff 75 f0             	pushl  -0x10(%ebp)
  803cb2:	ff 75 08             	pushl  0x8(%ebp)
  803cb5:	e8 c8 ed ff ff       	call   802a82 <set_block_data>
  803cba:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc0:	83 e8 04             	sub    $0x4,%eax
  803cc3:	8b 00                	mov    (%eax),%eax
  803cc5:	83 e0 fe             	and    $0xfffffffe,%eax
  803cc8:	89 c2                	mov    %eax,%edx
  803cca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccd:	01 d0                	add    %edx,%eax
  803ccf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803cd2:	a1 38 60 80 00       	mov    0x806038,%eax
  803cd7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803cda:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803cde:	75 68                	jne    803d48 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ce0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ce4:	75 17                	jne    803cfd <realloc_block_FF+0x288>
  803ce6:	83 ec 04             	sub    $0x4,%esp
  803ce9:	68 c0 4d 80 00       	push   $0x804dc0
  803cee:	68 06 02 00 00       	push   $0x206
  803cf3:	68 a5 4d 80 00       	push   $0x804da5
  803cf8:	e8 cd 04 00 00       	call   8041ca <_panic>
  803cfd:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803d03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d06:	89 10                	mov    %edx,(%eax)
  803d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0b:	8b 00                	mov    (%eax),%eax
  803d0d:	85 c0                	test   %eax,%eax
  803d0f:	74 0d                	je     803d1e <realloc_block_FF+0x2a9>
  803d11:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d19:	89 50 04             	mov    %edx,0x4(%eax)
  803d1c:	eb 08                	jmp    803d26 <realloc_block_FF+0x2b1>
  803d1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d21:	a3 30 60 80 00       	mov    %eax,0x806030
  803d26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d29:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d38:	a1 38 60 80 00       	mov    0x806038,%eax
  803d3d:	40                   	inc    %eax
  803d3e:	a3 38 60 80 00       	mov    %eax,0x806038
  803d43:	e9 b0 01 00 00       	jmp    803ef8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d48:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d4d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d50:	76 68                	jbe    803dba <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d52:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d56:	75 17                	jne    803d6f <realloc_block_FF+0x2fa>
  803d58:	83 ec 04             	sub    $0x4,%esp
  803d5b:	68 c0 4d 80 00       	push   $0x804dc0
  803d60:	68 0b 02 00 00       	push   $0x20b
  803d65:	68 a5 4d 80 00       	push   $0x804da5
  803d6a:	e8 5b 04 00 00       	call   8041ca <_panic>
  803d6f:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d78:	89 10                	mov    %edx,(%eax)
  803d7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7d:	8b 00                	mov    (%eax),%eax
  803d7f:	85 c0                	test   %eax,%eax
  803d81:	74 0d                	je     803d90 <realloc_block_FF+0x31b>
  803d83:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d88:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d8b:	89 50 04             	mov    %edx,0x4(%eax)
  803d8e:	eb 08                	jmp    803d98 <realloc_block_FF+0x323>
  803d90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d93:	a3 30 60 80 00       	mov    %eax,0x806030
  803d98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d9b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803da0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803daa:	a1 38 60 80 00       	mov    0x806038,%eax
  803daf:	40                   	inc    %eax
  803db0:	a3 38 60 80 00       	mov    %eax,0x806038
  803db5:	e9 3e 01 00 00       	jmp    803ef8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803dba:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803dbf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803dc2:	73 68                	jae    803e2c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803dc4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dc8:	75 17                	jne    803de1 <realloc_block_FF+0x36c>
  803dca:	83 ec 04             	sub    $0x4,%esp
  803dcd:	68 f4 4d 80 00       	push   $0x804df4
  803dd2:	68 10 02 00 00       	push   $0x210
  803dd7:	68 a5 4d 80 00       	push   $0x804da5
  803ddc:	e8 e9 03 00 00       	call   8041ca <_panic>
  803de1:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803de7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dea:	89 50 04             	mov    %edx,0x4(%eax)
  803ded:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803df0:	8b 40 04             	mov    0x4(%eax),%eax
  803df3:	85 c0                	test   %eax,%eax
  803df5:	74 0c                	je     803e03 <realloc_block_FF+0x38e>
  803df7:	a1 30 60 80 00       	mov    0x806030,%eax
  803dfc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dff:	89 10                	mov    %edx,(%eax)
  803e01:	eb 08                	jmp    803e0b <realloc_block_FF+0x396>
  803e03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e06:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e0e:	a3 30 60 80 00       	mov    %eax,0x806030
  803e13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e1c:	a1 38 60 80 00       	mov    0x806038,%eax
  803e21:	40                   	inc    %eax
  803e22:	a3 38 60 80 00       	mov    %eax,0x806038
  803e27:	e9 cc 00 00 00       	jmp    803ef8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e33:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e3b:	e9 8a 00 00 00       	jmp    803eca <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e43:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e46:	73 7a                	jae    803ec2 <realloc_block_FF+0x44d>
  803e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4b:	8b 00                	mov    (%eax),%eax
  803e4d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e50:	73 70                	jae    803ec2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e56:	74 06                	je     803e5e <realloc_block_FF+0x3e9>
  803e58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e5c:	75 17                	jne    803e75 <realloc_block_FF+0x400>
  803e5e:	83 ec 04             	sub    $0x4,%esp
  803e61:	68 18 4e 80 00       	push   $0x804e18
  803e66:	68 1a 02 00 00       	push   $0x21a
  803e6b:	68 a5 4d 80 00       	push   $0x804da5
  803e70:	e8 55 03 00 00       	call   8041ca <_panic>
  803e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e78:	8b 10                	mov    (%eax),%edx
  803e7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7d:	89 10                	mov    %edx,(%eax)
  803e7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e82:	8b 00                	mov    (%eax),%eax
  803e84:	85 c0                	test   %eax,%eax
  803e86:	74 0b                	je     803e93 <realloc_block_FF+0x41e>
  803e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8b:	8b 00                	mov    (%eax),%eax
  803e8d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e90:	89 50 04             	mov    %edx,0x4(%eax)
  803e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e99:	89 10                	mov    %edx,(%eax)
  803e9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ea1:	89 50 04             	mov    %edx,0x4(%eax)
  803ea4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea7:	8b 00                	mov    (%eax),%eax
  803ea9:	85 c0                	test   %eax,%eax
  803eab:	75 08                	jne    803eb5 <realloc_block_FF+0x440>
  803ead:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb0:	a3 30 60 80 00       	mov    %eax,0x806030
  803eb5:	a1 38 60 80 00       	mov    0x806038,%eax
  803eba:	40                   	inc    %eax
  803ebb:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803ec0:	eb 36                	jmp    803ef8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ec2:	a1 34 60 80 00       	mov    0x806034,%eax
  803ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ece:	74 07                	je     803ed7 <realloc_block_FF+0x462>
  803ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed3:	8b 00                	mov    (%eax),%eax
  803ed5:	eb 05                	jmp    803edc <realloc_block_FF+0x467>
  803ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  803edc:	a3 34 60 80 00       	mov    %eax,0x806034
  803ee1:	a1 34 60 80 00       	mov    0x806034,%eax
  803ee6:	85 c0                	test   %eax,%eax
  803ee8:	0f 85 52 ff ff ff    	jne    803e40 <realloc_block_FF+0x3cb>
  803eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ef2:	0f 85 48 ff ff ff    	jne    803e40 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ef8:	83 ec 04             	sub    $0x4,%esp
  803efb:	6a 00                	push   $0x0
  803efd:	ff 75 d8             	pushl  -0x28(%ebp)
  803f00:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f03:	e8 7a eb ff ff       	call   802a82 <set_block_data>
  803f08:	83 c4 10             	add    $0x10,%esp
				return va;
  803f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0e:	e9 7b 02 00 00       	jmp    80418e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803f13:	83 ec 0c             	sub    $0xc,%esp
  803f16:	68 95 4e 80 00       	push   $0x804e95
  803f1b:	e8 01 cd ff ff       	call   800c21 <cprintf>
  803f20:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803f23:	8b 45 08             	mov    0x8(%ebp),%eax
  803f26:	e9 63 02 00 00       	jmp    80418e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f2e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f31:	0f 86 4d 02 00 00    	jbe    804184 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f37:	83 ec 0c             	sub    $0xc,%esp
  803f3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f3d:	e8 08 e8 ff ff       	call   80274a <is_free_block>
  803f42:	83 c4 10             	add    $0x10,%esp
  803f45:	84 c0                	test   %al,%al
  803f47:	0f 84 37 02 00 00    	je     804184 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f50:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f59:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f5c:	76 38                	jbe    803f96 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f5e:	83 ec 0c             	sub    $0xc,%esp
  803f61:	ff 75 08             	pushl  0x8(%ebp)
  803f64:	e8 0c fa ff ff       	call   803975 <free_block>
  803f69:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f6c:	83 ec 0c             	sub    $0xc,%esp
  803f6f:	ff 75 0c             	pushl  0xc(%ebp)
  803f72:	e8 3a eb ff ff       	call   802ab1 <alloc_block_FF>
  803f77:	83 c4 10             	add    $0x10,%esp
  803f7a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f7d:	83 ec 08             	sub    $0x8,%esp
  803f80:	ff 75 c0             	pushl  -0x40(%ebp)
  803f83:	ff 75 08             	pushl  0x8(%ebp)
  803f86:	e8 ab fa ff ff       	call   803a36 <copy_data>
  803f8b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f8e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f91:	e9 f8 01 00 00       	jmp    80418e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f99:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f9c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f9f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803fa3:	0f 87 a0 00 00 00    	ja     804049 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803fa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fad:	75 17                	jne    803fc6 <realloc_block_FF+0x551>
  803faf:	83 ec 04             	sub    $0x4,%esp
  803fb2:	68 87 4d 80 00       	push   $0x804d87
  803fb7:	68 38 02 00 00       	push   $0x238
  803fbc:	68 a5 4d 80 00       	push   $0x804da5
  803fc1:	e8 04 02 00 00       	call   8041ca <_panic>
  803fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc9:	8b 00                	mov    (%eax),%eax
  803fcb:	85 c0                	test   %eax,%eax
  803fcd:	74 10                	je     803fdf <realloc_block_FF+0x56a>
  803fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd2:	8b 00                	mov    (%eax),%eax
  803fd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd7:	8b 52 04             	mov    0x4(%edx),%edx
  803fda:	89 50 04             	mov    %edx,0x4(%eax)
  803fdd:	eb 0b                	jmp    803fea <realloc_block_FF+0x575>
  803fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe2:	8b 40 04             	mov    0x4(%eax),%eax
  803fe5:	a3 30 60 80 00       	mov    %eax,0x806030
  803fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fed:	8b 40 04             	mov    0x4(%eax),%eax
  803ff0:	85 c0                	test   %eax,%eax
  803ff2:	74 0f                	je     804003 <realloc_block_FF+0x58e>
  803ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff7:	8b 40 04             	mov    0x4(%eax),%eax
  803ffa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ffd:	8b 12                	mov    (%edx),%edx
  803fff:	89 10                	mov    %edx,(%eax)
  804001:	eb 0a                	jmp    80400d <realloc_block_FF+0x598>
  804003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804006:	8b 00                	mov    (%eax),%eax
  804008:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80400d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804010:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804019:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804020:	a1 38 60 80 00       	mov    0x806038,%eax
  804025:	48                   	dec    %eax
  804026:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80402b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80402e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804031:	01 d0                	add    %edx,%eax
  804033:	83 ec 04             	sub    $0x4,%esp
  804036:	6a 01                	push   $0x1
  804038:	50                   	push   %eax
  804039:	ff 75 08             	pushl  0x8(%ebp)
  80403c:	e8 41 ea ff ff       	call   802a82 <set_block_data>
  804041:	83 c4 10             	add    $0x10,%esp
  804044:	e9 36 01 00 00       	jmp    80417f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804049:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80404c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80404f:	01 d0                	add    %edx,%eax
  804051:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804054:	83 ec 04             	sub    $0x4,%esp
  804057:	6a 01                	push   $0x1
  804059:	ff 75 f0             	pushl  -0x10(%ebp)
  80405c:	ff 75 08             	pushl  0x8(%ebp)
  80405f:	e8 1e ea ff ff       	call   802a82 <set_block_data>
  804064:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804067:	8b 45 08             	mov    0x8(%ebp),%eax
  80406a:	83 e8 04             	sub    $0x4,%eax
  80406d:	8b 00                	mov    (%eax),%eax
  80406f:	83 e0 fe             	and    $0xfffffffe,%eax
  804072:	89 c2                	mov    %eax,%edx
  804074:	8b 45 08             	mov    0x8(%ebp),%eax
  804077:	01 d0                	add    %edx,%eax
  804079:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80407c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804080:	74 06                	je     804088 <realloc_block_FF+0x613>
  804082:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804086:	75 17                	jne    80409f <realloc_block_FF+0x62a>
  804088:	83 ec 04             	sub    $0x4,%esp
  80408b:	68 18 4e 80 00       	push   $0x804e18
  804090:	68 44 02 00 00       	push   $0x244
  804095:	68 a5 4d 80 00       	push   $0x804da5
  80409a:	e8 2b 01 00 00       	call   8041ca <_panic>
  80409f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a2:	8b 10                	mov    (%eax),%edx
  8040a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040a7:	89 10                	mov    %edx,(%eax)
  8040a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040ac:	8b 00                	mov    (%eax),%eax
  8040ae:	85 c0                	test   %eax,%eax
  8040b0:	74 0b                	je     8040bd <realloc_block_FF+0x648>
  8040b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b5:	8b 00                	mov    (%eax),%eax
  8040b7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040ba:	89 50 04             	mov    %edx,0x4(%eax)
  8040bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040c3:	89 10                	mov    %edx,(%eax)
  8040c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040cb:	89 50 04             	mov    %edx,0x4(%eax)
  8040ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040d1:	8b 00                	mov    (%eax),%eax
  8040d3:	85 c0                	test   %eax,%eax
  8040d5:	75 08                	jne    8040df <realloc_block_FF+0x66a>
  8040d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040da:	a3 30 60 80 00       	mov    %eax,0x806030
  8040df:	a1 38 60 80 00       	mov    0x806038,%eax
  8040e4:	40                   	inc    %eax
  8040e5:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040ee:	75 17                	jne    804107 <realloc_block_FF+0x692>
  8040f0:	83 ec 04             	sub    $0x4,%esp
  8040f3:	68 87 4d 80 00       	push   $0x804d87
  8040f8:	68 45 02 00 00       	push   $0x245
  8040fd:	68 a5 4d 80 00       	push   $0x804da5
  804102:	e8 c3 00 00 00       	call   8041ca <_panic>
  804107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410a:	8b 00                	mov    (%eax),%eax
  80410c:	85 c0                	test   %eax,%eax
  80410e:	74 10                	je     804120 <realloc_block_FF+0x6ab>
  804110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804113:	8b 00                	mov    (%eax),%eax
  804115:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804118:	8b 52 04             	mov    0x4(%edx),%edx
  80411b:	89 50 04             	mov    %edx,0x4(%eax)
  80411e:	eb 0b                	jmp    80412b <realloc_block_FF+0x6b6>
  804120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804123:	8b 40 04             	mov    0x4(%eax),%eax
  804126:	a3 30 60 80 00       	mov    %eax,0x806030
  80412b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412e:	8b 40 04             	mov    0x4(%eax),%eax
  804131:	85 c0                	test   %eax,%eax
  804133:	74 0f                	je     804144 <realloc_block_FF+0x6cf>
  804135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804138:	8b 40 04             	mov    0x4(%eax),%eax
  80413b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80413e:	8b 12                	mov    (%edx),%edx
  804140:	89 10                	mov    %edx,(%eax)
  804142:	eb 0a                	jmp    80414e <realloc_block_FF+0x6d9>
  804144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804147:	8b 00                	mov    (%eax),%eax
  804149:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80414e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804151:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804161:	a1 38 60 80 00       	mov    0x806038,%eax
  804166:	48                   	dec    %eax
  804167:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  80416c:	83 ec 04             	sub    $0x4,%esp
  80416f:	6a 00                	push   $0x0
  804171:	ff 75 bc             	pushl  -0x44(%ebp)
  804174:	ff 75 b8             	pushl  -0x48(%ebp)
  804177:	e8 06 e9 ff ff       	call   802a82 <set_block_data>
  80417c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80417f:	8b 45 08             	mov    0x8(%ebp),%eax
  804182:	eb 0a                	jmp    80418e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804184:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80418b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80418e:	c9                   	leave  
  80418f:	c3                   	ret    

00804190 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804190:	55                   	push   %ebp
  804191:	89 e5                	mov    %esp,%ebp
  804193:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804196:	83 ec 04             	sub    $0x4,%esp
  804199:	68 9c 4e 80 00       	push   $0x804e9c
  80419e:	68 58 02 00 00       	push   $0x258
  8041a3:	68 a5 4d 80 00       	push   $0x804da5
  8041a8:	e8 1d 00 00 00       	call   8041ca <_panic>

008041ad <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8041ad:	55                   	push   %ebp
  8041ae:	89 e5                	mov    %esp,%ebp
  8041b0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8041b3:	83 ec 04             	sub    $0x4,%esp
  8041b6:	68 c4 4e 80 00       	push   $0x804ec4
  8041bb:	68 61 02 00 00       	push   $0x261
  8041c0:	68 a5 4d 80 00       	push   $0x804da5
  8041c5:	e8 00 00 00 00       	call   8041ca <_panic>

008041ca <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8041ca:	55                   	push   %ebp
  8041cb:	89 e5                	mov    %esp,%ebp
  8041cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8041d0:	8d 45 10             	lea    0x10(%ebp),%eax
  8041d3:	83 c0 04             	add    $0x4,%eax
  8041d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8041d9:	a1 60 60 98 00       	mov    0x986060,%eax
  8041de:	85 c0                	test   %eax,%eax
  8041e0:	74 16                	je     8041f8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8041e2:	a1 60 60 98 00       	mov    0x986060,%eax
  8041e7:	83 ec 08             	sub    $0x8,%esp
  8041ea:	50                   	push   %eax
  8041eb:	68 ec 4e 80 00       	push   $0x804eec
  8041f0:	e8 2c ca ff ff       	call   800c21 <cprintf>
  8041f5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8041f8:	a1 00 60 80 00       	mov    0x806000,%eax
  8041fd:	ff 75 0c             	pushl  0xc(%ebp)
  804200:	ff 75 08             	pushl  0x8(%ebp)
  804203:	50                   	push   %eax
  804204:	68 f1 4e 80 00       	push   $0x804ef1
  804209:	e8 13 ca ff ff       	call   800c21 <cprintf>
  80420e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  804211:	8b 45 10             	mov    0x10(%ebp),%eax
  804214:	83 ec 08             	sub    $0x8,%esp
  804217:	ff 75 f4             	pushl  -0xc(%ebp)
  80421a:	50                   	push   %eax
  80421b:	e8 96 c9 ff ff       	call   800bb6 <vcprintf>
  804220:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804223:	83 ec 08             	sub    $0x8,%esp
  804226:	6a 00                	push   $0x0
  804228:	68 0d 4f 80 00       	push   $0x804f0d
  80422d:	e8 84 c9 ff ff       	call   800bb6 <vcprintf>
  804232:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  804235:	e8 05 c9 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  80423a:	eb fe                	jmp    80423a <_panic+0x70>

0080423c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80423c:	55                   	push   %ebp
  80423d:	89 e5                	mov    %esp,%ebp
  80423f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804242:	a1 20 60 80 00       	mov    0x806020,%eax
  804247:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80424d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804250:	39 c2                	cmp    %eax,%edx
  804252:	74 14                	je     804268 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  804254:	83 ec 04             	sub    $0x4,%esp
  804257:	68 10 4f 80 00       	push   $0x804f10
  80425c:	6a 26                	push   $0x26
  80425e:	68 5c 4f 80 00       	push   $0x804f5c
  804263:	e8 62 ff ff ff       	call   8041ca <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804268:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80426f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804276:	e9 c5 00 00 00       	jmp    804340 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80427b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80427e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804285:	8b 45 08             	mov    0x8(%ebp),%eax
  804288:	01 d0                	add    %edx,%eax
  80428a:	8b 00                	mov    (%eax),%eax
  80428c:	85 c0                	test   %eax,%eax
  80428e:	75 08                	jne    804298 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804290:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804293:	e9 a5 00 00 00       	jmp    80433d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804298:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80429f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8042a6:	eb 69                	jmp    804311 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8042a8:	a1 20 60 80 00       	mov    0x806020,%eax
  8042ad:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8042b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042b6:	89 d0                	mov    %edx,%eax
  8042b8:	01 c0                	add    %eax,%eax
  8042ba:	01 d0                	add    %edx,%eax
  8042bc:	c1 e0 03             	shl    $0x3,%eax
  8042bf:	01 c8                	add    %ecx,%eax
  8042c1:	8a 40 04             	mov    0x4(%eax),%al
  8042c4:	84 c0                	test   %al,%al
  8042c6:	75 46                	jne    80430e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8042c8:	a1 20 60 80 00       	mov    0x806020,%eax
  8042cd:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8042d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042d6:	89 d0                	mov    %edx,%eax
  8042d8:	01 c0                	add    %eax,%eax
  8042da:	01 d0                	add    %edx,%eax
  8042dc:	c1 e0 03             	shl    $0x3,%eax
  8042df:	01 c8                	add    %ecx,%eax
  8042e1:	8b 00                	mov    (%eax),%eax
  8042e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8042e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8042ee:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8042f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8042fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fd:	01 c8                	add    %ecx,%eax
  8042ff:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804301:	39 c2                	cmp    %eax,%edx
  804303:	75 09                	jne    80430e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804305:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80430c:	eb 15                	jmp    804323 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80430e:	ff 45 e8             	incl   -0x18(%ebp)
  804311:	a1 20 60 80 00       	mov    0x806020,%eax
  804316:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80431c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80431f:	39 c2                	cmp    %eax,%edx
  804321:	77 85                	ja     8042a8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804323:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804327:	75 14                	jne    80433d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  804329:	83 ec 04             	sub    $0x4,%esp
  80432c:	68 68 4f 80 00       	push   $0x804f68
  804331:	6a 3a                	push   $0x3a
  804333:	68 5c 4f 80 00       	push   $0x804f5c
  804338:	e8 8d fe ff ff       	call   8041ca <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80433d:	ff 45 f0             	incl   -0x10(%ebp)
  804340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804343:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804346:	0f 8c 2f ff ff ff    	jl     80427b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80434c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804353:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80435a:	eb 26                	jmp    804382 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80435c:	a1 20 60 80 00       	mov    0x806020,%eax
  804361:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804367:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80436a:	89 d0                	mov    %edx,%eax
  80436c:	01 c0                	add    %eax,%eax
  80436e:	01 d0                	add    %edx,%eax
  804370:	c1 e0 03             	shl    $0x3,%eax
  804373:	01 c8                	add    %ecx,%eax
  804375:	8a 40 04             	mov    0x4(%eax),%al
  804378:	3c 01                	cmp    $0x1,%al
  80437a:	75 03                	jne    80437f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80437c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80437f:	ff 45 e0             	incl   -0x20(%ebp)
  804382:	a1 20 60 80 00       	mov    0x806020,%eax
  804387:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80438d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804390:	39 c2                	cmp    %eax,%edx
  804392:	77 c8                	ja     80435c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804397:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80439a:	74 14                	je     8043b0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80439c:	83 ec 04             	sub    $0x4,%esp
  80439f:	68 bc 4f 80 00       	push   $0x804fbc
  8043a4:	6a 44                	push   $0x44
  8043a6:	68 5c 4f 80 00       	push   $0x804f5c
  8043ab:	e8 1a fe ff ff       	call   8041ca <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8043b0:	90                   	nop
  8043b1:	c9                   	leave  
  8043b2:	c3                   	ret    
  8043b3:	90                   	nop

008043b4 <__udivdi3>:
  8043b4:	55                   	push   %ebp
  8043b5:	57                   	push   %edi
  8043b6:	56                   	push   %esi
  8043b7:	53                   	push   %ebx
  8043b8:	83 ec 1c             	sub    $0x1c,%esp
  8043bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043cb:	89 ca                	mov    %ecx,%edx
  8043cd:	89 f8                	mov    %edi,%eax
  8043cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043d3:	85 f6                	test   %esi,%esi
  8043d5:	75 2d                	jne    804404 <__udivdi3+0x50>
  8043d7:	39 cf                	cmp    %ecx,%edi
  8043d9:	77 65                	ja     804440 <__udivdi3+0x8c>
  8043db:	89 fd                	mov    %edi,%ebp
  8043dd:	85 ff                	test   %edi,%edi
  8043df:	75 0b                	jne    8043ec <__udivdi3+0x38>
  8043e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8043e6:	31 d2                	xor    %edx,%edx
  8043e8:	f7 f7                	div    %edi
  8043ea:	89 c5                	mov    %eax,%ebp
  8043ec:	31 d2                	xor    %edx,%edx
  8043ee:	89 c8                	mov    %ecx,%eax
  8043f0:	f7 f5                	div    %ebp
  8043f2:	89 c1                	mov    %eax,%ecx
  8043f4:	89 d8                	mov    %ebx,%eax
  8043f6:	f7 f5                	div    %ebp
  8043f8:	89 cf                	mov    %ecx,%edi
  8043fa:	89 fa                	mov    %edi,%edx
  8043fc:	83 c4 1c             	add    $0x1c,%esp
  8043ff:	5b                   	pop    %ebx
  804400:	5e                   	pop    %esi
  804401:	5f                   	pop    %edi
  804402:	5d                   	pop    %ebp
  804403:	c3                   	ret    
  804404:	39 ce                	cmp    %ecx,%esi
  804406:	77 28                	ja     804430 <__udivdi3+0x7c>
  804408:	0f bd fe             	bsr    %esi,%edi
  80440b:	83 f7 1f             	xor    $0x1f,%edi
  80440e:	75 40                	jne    804450 <__udivdi3+0x9c>
  804410:	39 ce                	cmp    %ecx,%esi
  804412:	72 0a                	jb     80441e <__udivdi3+0x6a>
  804414:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804418:	0f 87 9e 00 00 00    	ja     8044bc <__udivdi3+0x108>
  80441e:	b8 01 00 00 00       	mov    $0x1,%eax
  804423:	89 fa                	mov    %edi,%edx
  804425:	83 c4 1c             	add    $0x1c,%esp
  804428:	5b                   	pop    %ebx
  804429:	5e                   	pop    %esi
  80442a:	5f                   	pop    %edi
  80442b:	5d                   	pop    %ebp
  80442c:	c3                   	ret    
  80442d:	8d 76 00             	lea    0x0(%esi),%esi
  804430:	31 ff                	xor    %edi,%edi
  804432:	31 c0                	xor    %eax,%eax
  804434:	89 fa                	mov    %edi,%edx
  804436:	83 c4 1c             	add    $0x1c,%esp
  804439:	5b                   	pop    %ebx
  80443a:	5e                   	pop    %esi
  80443b:	5f                   	pop    %edi
  80443c:	5d                   	pop    %ebp
  80443d:	c3                   	ret    
  80443e:	66 90                	xchg   %ax,%ax
  804440:	89 d8                	mov    %ebx,%eax
  804442:	f7 f7                	div    %edi
  804444:	31 ff                	xor    %edi,%edi
  804446:	89 fa                	mov    %edi,%edx
  804448:	83 c4 1c             	add    $0x1c,%esp
  80444b:	5b                   	pop    %ebx
  80444c:	5e                   	pop    %esi
  80444d:	5f                   	pop    %edi
  80444e:	5d                   	pop    %ebp
  80444f:	c3                   	ret    
  804450:	bd 20 00 00 00       	mov    $0x20,%ebp
  804455:	89 eb                	mov    %ebp,%ebx
  804457:	29 fb                	sub    %edi,%ebx
  804459:	89 f9                	mov    %edi,%ecx
  80445b:	d3 e6                	shl    %cl,%esi
  80445d:	89 c5                	mov    %eax,%ebp
  80445f:	88 d9                	mov    %bl,%cl
  804461:	d3 ed                	shr    %cl,%ebp
  804463:	89 e9                	mov    %ebp,%ecx
  804465:	09 f1                	or     %esi,%ecx
  804467:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80446b:	89 f9                	mov    %edi,%ecx
  80446d:	d3 e0                	shl    %cl,%eax
  80446f:	89 c5                	mov    %eax,%ebp
  804471:	89 d6                	mov    %edx,%esi
  804473:	88 d9                	mov    %bl,%cl
  804475:	d3 ee                	shr    %cl,%esi
  804477:	89 f9                	mov    %edi,%ecx
  804479:	d3 e2                	shl    %cl,%edx
  80447b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80447f:	88 d9                	mov    %bl,%cl
  804481:	d3 e8                	shr    %cl,%eax
  804483:	09 c2                	or     %eax,%edx
  804485:	89 d0                	mov    %edx,%eax
  804487:	89 f2                	mov    %esi,%edx
  804489:	f7 74 24 0c          	divl   0xc(%esp)
  80448d:	89 d6                	mov    %edx,%esi
  80448f:	89 c3                	mov    %eax,%ebx
  804491:	f7 e5                	mul    %ebp
  804493:	39 d6                	cmp    %edx,%esi
  804495:	72 19                	jb     8044b0 <__udivdi3+0xfc>
  804497:	74 0b                	je     8044a4 <__udivdi3+0xf0>
  804499:	89 d8                	mov    %ebx,%eax
  80449b:	31 ff                	xor    %edi,%edi
  80449d:	e9 58 ff ff ff       	jmp    8043fa <__udivdi3+0x46>
  8044a2:	66 90                	xchg   %ax,%ax
  8044a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044a8:	89 f9                	mov    %edi,%ecx
  8044aa:	d3 e2                	shl    %cl,%edx
  8044ac:	39 c2                	cmp    %eax,%edx
  8044ae:	73 e9                	jae    804499 <__udivdi3+0xe5>
  8044b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044b3:	31 ff                	xor    %edi,%edi
  8044b5:	e9 40 ff ff ff       	jmp    8043fa <__udivdi3+0x46>
  8044ba:	66 90                	xchg   %ax,%ax
  8044bc:	31 c0                	xor    %eax,%eax
  8044be:	e9 37 ff ff ff       	jmp    8043fa <__udivdi3+0x46>
  8044c3:	90                   	nop

008044c4 <__umoddi3>:
  8044c4:	55                   	push   %ebp
  8044c5:	57                   	push   %edi
  8044c6:	56                   	push   %esi
  8044c7:	53                   	push   %ebx
  8044c8:	83 ec 1c             	sub    $0x1c,%esp
  8044cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044e3:	89 f3                	mov    %esi,%ebx
  8044e5:	89 fa                	mov    %edi,%edx
  8044e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044eb:	89 34 24             	mov    %esi,(%esp)
  8044ee:	85 c0                	test   %eax,%eax
  8044f0:	75 1a                	jne    80450c <__umoddi3+0x48>
  8044f2:	39 f7                	cmp    %esi,%edi
  8044f4:	0f 86 a2 00 00 00    	jbe    80459c <__umoddi3+0xd8>
  8044fa:	89 c8                	mov    %ecx,%eax
  8044fc:	89 f2                	mov    %esi,%edx
  8044fe:	f7 f7                	div    %edi
  804500:	89 d0                	mov    %edx,%eax
  804502:	31 d2                	xor    %edx,%edx
  804504:	83 c4 1c             	add    $0x1c,%esp
  804507:	5b                   	pop    %ebx
  804508:	5e                   	pop    %esi
  804509:	5f                   	pop    %edi
  80450a:	5d                   	pop    %ebp
  80450b:	c3                   	ret    
  80450c:	39 f0                	cmp    %esi,%eax
  80450e:	0f 87 ac 00 00 00    	ja     8045c0 <__umoddi3+0xfc>
  804514:	0f bd e8             	bsr    %eax,%ebp
  804517:	83 f5 1f             	xor    $0x1f,%ebp
  80451a:	0f 84 ac 00 00 00    	je     8045cc <__umoddi3+0x108>
  804520:	bf 20 00 00 00       	mov    $0x20,%edi
  804525:	29 ef                	sub    %ebp,%edi
  804527:	89 fe                	mov    %edi,%esi
  804529:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80452d:	89 e9                	mov    %ebp,%ecx
  80452f:	d3 e0                	shl    %cl,%eax
  804531:	89 d7                	mov    %edx,%edi
  804533:	89 f1                	mov    %esi,%ecx
  804535:	d3 ef                	shr    %cl,%edi
  804537:	09 c7                	or     %eax,%edi
  804539:	89 e9                	mov    %ebp,%ecx
  80453b:	d3 e2                	shl    %cl,%edx
  80453d:	89 14 24             	mov    %edx,(%esp)
  804540:	89 d8                	mov    %ebx,%eax
  804542:	d3 e0                	shl    %cl,%eax
  804544:	89 c2                	mov    %eax,%edx
  804546:	8b 44 24 08          	mov    0x8(%esp),%eax
  80454a:	d3 e0                	shl    %cl,%eax
  80454c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804550:	8b 44 24 08          	mov    0x8(%esp),%eax
  804554:	89 f1                	mov    %esi,%ecx
  804556:	d3 e8                	shr    %cl,%eax
  804558:	09 d0                	or     %edx,%eax
  80455a:	d3 eb                	shr    %cl,%ebx
  80455c:	89 da                	mov    %ebx,%edx
  80455e:	f7 f7                	div    %edi
  804560:	89 d3                	mov    %edx,%ebx
  804562:	f7 24 24             	mull   (%esp)
  804565:	89 c6                	mov    %eax,%esi
  804567:	89 d1                	mov    %edx,%ecx
  804569:	39 d3                	cmp    %edx,%ebx
  80456b:	0f 82 87 00 00 00    	jb     8045f8 <__umoddi3+0x134>
  804571:	0f 84 91 00 00 00    	je     804608 <__umoddi3+0x144>
  804577:	8b 54 24 04          	mov    0x4(%esp),%edx
  80457b:	29 f2                	sub    %esi,%edx
  80457d:	19 cb                	sbb    %ecx,%ebx
  80457f:	89 d8                	mov    %ebx,%eax
  804581:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804585:	d3 e0                	shl    %cl,%eax
  804587:	89 e9                	mov    %ebp,%ecx
  804589:	d3 ea                	shr    %cl,%edx
  80458b:	09 d0                	or     %edx,%eax
  80458d:	89 e9                	mov    %ebp,%ecx
  80458f:	d3 eb                	shr    %cl,%ebx
  804591:	89 da                	mov    %ebx,%edx
  804593:	83 c4 1c             	add    $0x1c,%esp
  804596:	5b                   	pop    %ebx
  804597:	5e                   	pop    %esi
  804598:	5f                   	pop    %edi
  804599:	5d                   	pop    %ebp
  80459a:	c3                   	ret    
  80459b:	90                   	nop
  80459c:	89 fd                	mov    %edi,%ebp
  80459e:	85 ff                	test   %edi,%edi
  8045a0:	75 0b                	jne    8045ad <__umoddi3+0xe9>
  8045a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8045a7:	31 d2                	xor    %edx,%edx
  8045a9:	f7 f7                	div    %edi
  8045ab:	89 c5                	mov    %eax,%ebp
  8045ad:	89 f0                	mov    %esi,%eax
  8045af:	31 d2                	xor    %edx,%edx
  8045b1:	f7 f5                	div    %ebp
  8045b3:	89 c8                	mov    %ecx,%eax
  8045b5:	f7 f5                	div    %ebp
  8045b7:	89 d0                	mov    %edx,%eax
  8045b9:	e9 44 ff ff ff       	jmp    804502 <__umoddi3+0x3e>
  8045be:	66 90                	xchg   %ax,%ax
  8045c0:	89 c8                	mov    %ecx,%eax
  8045c2:	89 f2                	mov    %esi,%edx
  8045c4:	83 c4 1c             	add    $0x1c,%esp
  8045c7:	5b                   	pop    %ebx
  8045c8:	5e                   	pop    %esi
  8045c9:	5f                   	pop    %edi
  8045ca:	5d                   	pop    %ebp
  8045cb:	c3                   	ret    
  8045cc:	3b 04 24             	cmp    (%esp),%eax
  8045cf:	72 06                	jb     8045d7 <__umoddi3+0x113>
  8045d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045d5:	77 0f                	ja     8045e6 <__umoddi3+0x122>
  8045d7:	89 f2                	mov    %esi,%edx
  8045d9:	29 f9                	sub    %edi,%ecx
  8045db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045df:	89 14 24             	mov    %edx,(%esp)
  8045e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045ea:	8b 14 24             	mov    (%esp),%edx
  8045ed:	83 c4 1c             	add    $0x1c,%esp
  8045f0:	5b                   	pop    %ebx
  8045f1:	5e                   	pop    %esi
  8045f2:	5f                   	pop    %edi
  8045f3:	5d                   	pop    %ebp
  8045f4:	c3                   	ret    
  8045f5:	8d 76 00             	lea    0x0(%esi),%esi
  8045f8:	2b 04 24             	sub    (%esp),%eax
  8045fb:	19 fa                	sbb    %edi,%edx
  8045fd:	89 d1                	mov    %edx,%ecx
  8045ff:	89 c6                	mov    %eax,%esi
  804601:	e9 71 ff ff ff       	jmp    804577 <__umoddi3+0xb3>
  804606:	66 90                	xchg   %ax,%ax
  804608:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80460c:	72 ea                	jb     8045f8 <__umoddi3+0x134>
  80460e:	89 d9                	mov    %ebx,%ecx
  804610:	e9 62 ff ff ff       	jmp    804577 <__umoddi3+0xb3>
