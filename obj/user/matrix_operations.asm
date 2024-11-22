
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
  80005e:	e8 3d 20 00 00       	call   8020a0 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 60 45 80 00       	push   $0x804560
  80006b:	e8 b1 0b 00 00       	call   800c21 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 64 45 80 00       	push   $0x804564
  80007b:	e8 a1 0b 00 00       	call   800c21 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 88 45 80 00       	push   $0x804588
  80008b:	e8 91 0b 00 00       	call   800c21 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 64 45 80 00       	push   $0x804564
  80009b:	e8 81 0b 00 00       	call   800c21 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 60 45 80 00       	push   $0x804560
  8000ab:	e8 71 0b 00 00       	call   800c21 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 ac 45 80 00       	push   $0x8045ac
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
  8000e6:	68 cc 45 80 00       	push   $0x8045cc
  8000eb:	e8 31 0b 00 00       	call   800c21 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 ee 45 80 00       	push   $0x8045ee
  8000fb:	e8 21 0b 00 00       	call   800c21 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 fc 45 80 00       	push   $0x8045fc
  80010b:	e8 11 0b 00 00       	call   800c21 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 0a 46 80 00       	push   $0x80460a
  80011b:	e8 01 0b 00 00       	call   800c21 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 1a 46 80 00       	push   $0x80461a
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
  80017a:	68 24 46 80 00       	push   $0x804624
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
  8001a0:	e8 15 1f 00 00       	call   8020ba <sys_unlock_cons>

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
  8002d2:	e8 c9 1d 00 00       	call   8020a0 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 48 46 80 00       	push   $0x804648
  8002df:	e8 3d 09 00 00       	call   800c21 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 66 46 80 00       	push   $0x804666
  8002ef:	e8 2d 09 00 00       	call   800c21 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 7d 46 80 00       	push   $0x80467d
  8002ff:	e8 1d 09 00 00       	call   800c21 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 94 46 80 00       	push   $0x804694
  80030f:	e8 0d 09 00 00       	call   800c21 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 1a 46 80 00       	push   $0x80461a
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
  80035e:	e8 57 1d 00 00       	call   8020ba <sys_unlock_cons>


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
  8003df:	e8 bc 1c 00 00       	call   8020a0 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 ab 46 80 00       	push   $0x8046ab
  8003ec:	e8 30 08 00 00       	call   800c21 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 c1 1c 00 00       	call   8020ba <sys_unlock_cons>

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
  80048e:	e8 0d 1c 00 00       	call   8020a0 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 c4 46 80 00       	push   $0x8046c4
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
  8004c8:	e8 ed 1b 00 00       	call   8020ba <sys_unlock_cons>

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
  8008bf:	e8 a4 1a 00 00       	call   802368 <sys_get_virtual_time>
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
  80092b:	68 e2 46 80 00       	push   $0x8046e2
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
  800946:	68 e9 46 80 00       	push   $0x8046e9
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
  80099c:	68 ed 46 80 00       	push   $0x8046ed
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
  8009b7:	68 e9 46 80 00       	push   $0x8046e9
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
  8009e6:	e8 00 18 00 00       	call   8021eb <sys_cputc>
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
  8009f7:	e8 8b 16 00 00       	call   802087 <sys_cgetc>
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
  800a14:	e8 03 19 00 00       	call   80231c <sys_getenvindex>
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
  800a82:	e8 19 16 00 00       	call   8020a0 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	68 10 47 80 00       	push   $0x804710
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
  800ab2:	68 38 47 80 00       	push   $0x804738
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
  800ae3:	68 60 47 80 00       	push   $0x804760
  800ae8:	e8 34 01 00 00       	call   800c21 <cprintf>
  800aed:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af0:	a1 20 50 80 00       	mov    0x805020,%eax
  800af5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	50                   	push   %eax
  800aff:	68 b8 47 80 00       	push   $0x8047b8
  800b04:	e8 18 01 00 00       	call   800c21 <cprintf>
  800b09:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	68 10 47 80 00       	push   $0x804710
  800b14:	e8 08 01 00 00       	call   800c21 <cprintf>
  800b19:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800b1c:	e8 99 15 00 00       	call   8020ba <sys_unlock_cons>
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
  800b34:	e8 af 17 00 00       	call   8022e8 <sys_destroy_env>
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
  800b45:	e8 04 18 00 00       	call   80234e <sys_exit_env>
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
  800b93:	e8 c6 14 00 00       	call   80205e <sys_cputs>
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
  800c0a:	e8 4f 14 00 00       	call   80205e <sys_cputs>
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
  800c54:	e8 47 14 00 00       	call   8020a0 <sys_lock_cons>
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
  800c74:	e8 41 14 00 00       	call   8020ba <sys_unlock_cons>
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
  800cbe:	e8 1d 36 00 00       	call   8042e0 <__udivdi3>
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
  800d0e:	e8 dd 36 00 00       	call   8043f0 <__umoddi3>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	05 f4 49 80 00       	add    $0x8049f4,%eax
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
  800e69:	8b 04 85 18 4a 80 00 	mov    0x804a18(,%eax,4),%eax
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
  800f4a:	8b 34 9d 60 48 80 00 	mov    0x804860(,%ebx,4),%esi
  800f51:	85 f6                	test   %esi,%esi
  800f53:	75 19                	jne    800f6e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f55:	53                   	push   %ebx
  800f56:	68 05 4a 80 00       	push   $0x804a05
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
  800f6f:	68 0e 4a 80 00       	push   $0x804a0e
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
  800f9c:	be 11 4a 80 00       	mov    $0x804a11,%esi
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
  8012c7:	68 88 4b 80 00       	push   $0x804b88
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
  801309:	68 8b 4b 80 00       	push   $0x804b8b
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
  8013ba:	e8 e1 0c 00 00       	call   8020a0 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	74 13                	je     8013d8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	68 88 4b 80 00       	push   $0x804b88
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
  80140d:	68 8b 4b 80 00       	push   $0x804b8b
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
  8014b5:	e8 00 0c 00 00       	call   8020ba <sys_unlock_cons>
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
  801baf:	68 9c 4b 80 00       	push   $0x804b9c
  801bb4:	68 3f 01 00 00       	push   $0x13f
  801bb9:	68 be 4b 80 00       	push   $0x804bbe
  801bbe:	e8 32 25 00 00       	call   8040f5 <_panic>

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
  801bcf:	e8 35 0a 00 00       	call   802609 <sys_sbrk>
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
  801c4a:	e8 3e 08 00 00       	call   80248d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	74 16                	je     801c69 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 7e 0d 00 00       	call   8029dc <alloc_block_FF>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	e9 8a 01 00 00       	jmp    801df3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c69:	e8 50 08 00 00       	call   8024be <sys_isUHeapPlacementStrategyBESTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 84 7d 01 00 00    	je     801df3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 17 12 00 00       	call   802e98 <alloc_block_BF>
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
  801de2:	e8 59 08 00 00       	call   802640 <sys_allocate_user_mem>
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
  801e2a:	e8 2d 08 00 00       	call   80265c <get_block_size>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 60 1a 00 00       	call   8038a0 <free_block>
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
  801ed2:	e8 4d 07 00 00       	call   802624 <sys_free_user_mem>
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
  801ee0:	68 cc 4b 80 00       	push   $0x804bcc
  801ee5:	68 84 00 00 00       	push   $0x84
  801eea:	68 f6 4b 80 00       	push   $0x804bf6
  801eef:	e8 01 22 00 00       	call   8040f5 <_panic>
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
  801f52:	e8 d4 02 00 00       	call   80222b <sys_createSharedObject>
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
  801f73:	68 02 4c 80 00       	push   $0x804c02
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
  801f88:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	68 08 4c 80 00       	push   $0x804c08
  801f93:	68 a4 00 00 00       	push   $0xa4
  801f98:	68 f6 4b 80 00       	push   $0x804bf6
  801f9d:	e8 53 21 00 00       	call   8040f5 <_panic>

00801fa2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fa8:	83 ec 04             	sub    $0x4,%esp
  801fab:	68 2c 4c 80 00       	push   $0x804c2c
  801fb0:	68 bc 00 00 00       	push   $0xbc
  801fb5:	68 f6 4b 80 00       	push   $0x804bf6
  801fba:	e8 36 21 00 00       	call   8040f5 <_panic>

00801fbf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	68 50 4c 80 00       	push   $0x804c50
  801fcd:	68 d3 00 00 00       	push   $0xd3
  801fd2:	68 f6 4b 80 00       	push   $0x804bf6
  801fd7:	e8 19 21 00 00       	call   8040f5 <_panic>

00801fdc <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	68 76 4c 80 00       	push   $0x804c76
  801fea:	68 df 00 00 00       	push   $0xdf
  801fef:	68 f6 4b 80 00       	push   $0x804bf6
  801ff4:	e8 fc 20 00 00       	call   8040f5 <_panic>

00801ff9 <shrink>:

}
void shrink(uint32 newSize)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 76 4c 80 00       	push   $0x804c76
  802007:	68 e4 00 00 00       	push   $0xe4
  80200c:	68 f6 4b 80 00       	push   $0x804bf6
  802011:	e8 df 20 00 00       	call   8040f5 <_panic>

00802016 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 76 4c 80 00       	push   $0x804c76
  802024:	68 e9 00 00 00       	push   $0xe9
  802029:	68 f6 4b 80 00       	push   $0x804bf6
  80202e:	e8 c2 20 00 00       	call   8040f5 <_panic>

00802033 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	57                   	push   %edi
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802045:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802048:	8b 7d 18             	mov    0x18(%ebp),%edi
  80204b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80204e:	cd 30                	int    $0x30
  802050:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802053:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5f                   	pop    %edi
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    

0080205e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	8b 45 10             	mov    0x10(%ebp),%eax
  802067:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80206a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	52                   	push   %edx
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	50                   	push   %eax
  80207a:	6a 00                	push   $0x0
  80207c:	e8 b2 ff ff ff       	call   802033 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	90                   	nop
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_cgetc>:

int
sys_cgetc(void)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 02                	push   $0x2
  802096:	e8 98 ff ff ff       	call   802033 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 03                	push   $0x3
  8020af:	e8 7f ff ff ff       	call   802033 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	90                   	nop
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 04                	push   $0x4
  8020c9:	e8 65 ff ff ff       	call   802033 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	52                   	push   %edx
  8020e4:	50                   	push   %eax
  8020e5:	6a 08                	push   $0x8
  8020e7:	e8 47 ff ff ff       	call   802033 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	56                   	push   %esi
  8020f5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8020f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	56                   	push   %esi
  802106:	53                   	push   %ebx
  802107:	51                   	push   %ecx
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	6a 09                	push   $0x9
  80210c:	e8 22 ff ff ff       	call   802033 <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    

0080211b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80211e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	52                   	push   %edx
  80212b:	50                   	push   %eax
  80212c:	6a 0a                	push   $0xa
  80212e:	e8 00 ff ff ff       	call   802033 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	ff 75 0c             	pushl  0xc(%ebp)
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	6a 0b                	push   $0xb
  802149:	e8 e5 fe ff ff       	call   802033 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 0c                	push   $0xc
  802162:	e8 cc fe ff ff       	call   802033 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 0d                	push   $0xd
  80217b:	e8 b3 fe ff ff       	call   802033 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 0e                	push   $0xe
  802194:	e8 9a fe ff ff       	call   802033 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 0f                	push   $0xf
  8021ad:	e8 81 fe ff ff       	call   802033 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	ff 75 08             	pushl  0x8(%ebp)
  8021c5:	6a 10                	push   $0x10
  8021c7:	e8 67 fe ff ff       	call   802033 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 11                	push   $0x11
  8021e0:	e8 4e fe ff ff       	call   802033 <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	90                   	nop
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_cputc>:

void
sys_cputc(const char c)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	50                   	push   %eax
  802204:	6a 01                	push   $0x1
  802206:	e8 28 fe ff ff       	call   802033 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	90                   	nop
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 14                	push   $0x14
  802220:	e8 0e fe ff ff       	call   802033 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	90                   	nop
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	8b 45 10             	mov    0x10(%ebp),%eax
  802234:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802237:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80223a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	51                   	push   %ecx
  802244:	52                   	push   %edx
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	50                   	push   %eax
  802249:	6a 15                	push   $0x15
  80224b:	e8 e3 fd ff ff       	call   802033 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	52                   	push   %edx
  802265:	50                   	push   %eax
  802266:	6a 16                	push   $0x16
  802268:	e8 c6 fd ff ff       	call   802033 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802275:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	51                   	push   %ecx
  802283:	52                   	push   %edx
  802284:	50                   	push   %eax
  802285:	6a 17                	push   $0x17
  802287:	e8 a7 fd ff ff       	call   802033 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802294:	8b 55 0c             	mov    0xc(%ebp),%edx
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	52                   	push   %edx
  8022a1:	50                   	push   %eax
  8022a2:	6a 18                	push   $0x18
  8022a4:	e8 8a fd ff ff       	call   802033 <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 14             	pushl  0x14(%ebp)
  8022b9:	ff 75 10             	pushl  0x10(%ebp)
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	50                   	push   %eax
  8022c0:	6a 19                	push   $0x19
  8022c2:	e8 6c fd ff ff       	call   802033 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	50                   	push   %eax
  8022db:	6a 1a                	push   $0x1a
  8022dd:	e8 51 fd ff ff       	call   802033 <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	90                   	nop
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	50                   	push   %eax
  8022f7:	6a 1b                	push   $0x1b
  8022f9:	e8 35 fd ff ff       	call   802033 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 05                	push   $0x5
  802312:	e8 1c fd ff ff       	call   802033 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 06                	push   $0x6
  80232b:	e8 03 fd ff ff       	call   802033 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 07                	push   $0x7
  802344:	e8 ea fc ff ff       	call   802033 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_exit_env>:


void sys_exit_env(void)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 1c                	push   $0x1c
  80235d:	e8 d1 fc ff ff       	call   802033 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	90                   	nop
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80236e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802371:	8d 50 04             	lea    0x4(%eax),%edx
  802374:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	52                   	push   %edx
  80237e:	50                   	push   %eax
  80237f:	6a 1d                	push   $0x1d
  802381:	e8 ad fc ff ff       	call   802033 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
	return result;
  802389:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80238c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80238f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802392:	89 01                	mov    %eax,(%ecx)
  802394:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	c9                   	leave  
  80239b:	c2 04 00             	ret    $0x4

0080239e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	ff 75 10             	pushl  0x10(%ebp)
  8023a8:	ff 75 0c             	pushl  0xc(%ebp)
  8023ab:	ff 75 08             	pushl  0x8(%ebp)
  8023ae:	6a 13                	push   $0x13
  8023b0:	e8 7e fc ff ff       	call   802033 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b8:	90                   	nop
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_rcr2>:
uint32 sys_rcr2()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 1e                	push   $0x1e
  8023ca:	e8 64 fc ff ff       	call   802033 <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023e0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	50                   	push   %eax
  8023ed:	6a 1f                	push   $0x1f
  8023ef:	e8 3f fc ff ff       	call   802033 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f7:	90                   	nop
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <rsttst>:
void rsttst()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 21                	push   $0x21
  802409:	e8 25 fc ff ff       	call   802033 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
	return ;
  802411:	90                   	nop
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	8b 45 14             	mov    0x14(%ebp),%eax
  80241d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802420:	8b 55 18             	mov    0x18(%ebp),%edx
  802423:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802427:	52                   	push   %edx
  802428:	50                   	push   %eax
  802429:	ff 75 10             	pushl  0x10(%ebp)
  80242c:	ff 75 0c             	pushl  0xc(%ebp)
  80242f:	ff 75 08             	pushl  0x8(%ebp)
  802432:	6a 20                	push   $0x20
  802434:	e8 fa fb ff ff       	call   802033 <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
	return ;
  80243c:	90                   	nop
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <chktst>:
void chktst(uint32 n)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	ff 75 08             	pushl  0x8(%ebp)
  80244d:	6a 22                	push   $0x22
  80244f:	e8 df fb ff ff       	call   802033 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
	return ;
  802457:	90                   	nop
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <inctst>:

void inctst()
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 23                	push   $0x23
  802469:	e8 c5 fb ff ff       	call   802033 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
	return ;
  802471:	90                   	nop
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <gettst>:
uint32 gettst()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 24                	push   $0x24
  802483:	e8 ab fb ff ff       	call   802033 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 25                	push   $0x25
  80249f:	e8 8f fb ff ff       	call   802033 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
  8024a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024aa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024ae:	75 07                	jne    8024b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b5:	eb 05                	jmp    8024bc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 25                	push   $0x25
  8024d0:	e8 5e fb ff ff       	call   802033 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
  8024d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024db:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024df:	75 07                	jne    8024e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e6:	eb 05                	jmp    8024ed <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 25                	push   $0x25
  802501:	e8 2d fb ff ff       	call   802033 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
  802509:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80250c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802510:	75 07                	jne    802519 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802512:	b8 01 00 00 00       	mov    $0x1,%eax
  802517:	eb 05                	jmp    80251e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 25                	push   $0x25
  802532:	e8 fc fa ff ff       	call   802033 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
  80253a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80253d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802541:	75 07                	jne    80254a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802543:	b8 01 00 00 00       	mov    $0x1,%eax
  802548:	eb 05                	jmp    80254f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	ff 75 08             	pushl  0x8(%ebp)
  80255f:	6a 26                	push   $0x26
  802561:	e8 cd fa ff ff       	call   802033 <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
	return ;
  802569:	90                   	nop
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802570:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802573:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802576:	8b 55 0c             	mov    0xc(%ebp),%edx
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	6a 00                	push   $0x0
  80257e:	53                   	push   %ebx
  80257f:	51                   	push   %ecx
  802580:	52                   	push   %edx
  802581:	50                   	push   %eax
  802582:	6a 27                	push   $0x27
  802584:	e8 aa fa ff ff       	call   802033 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802594:	8b 55 0c             	mov    0xc(%ebp),%edx
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	52                   	push   %edx
  8025a1:	50                   	push   %eax
  8025a2:	6a 28                	push   $0x28
  8025a4:	e8 8a fa ff ff       	call   802033 <syscall>
  8025a9:	83 c4 18             	add    $0x18,%esp
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	6a 00                	push   $0x0
  8025bc:	51                   	push   %ecx
  8025bd:	ff 75 10             	pushl  0x10(%ebp)
  8025c0:	52                   	push   %edx
  8025c1:	50                   	push   %eax
  8025c2:	6a 29                	push   $0x29
  8025c4:	e8 6a fa ff ff       	call   802033 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	ff 75 10             	pushl  0x10(%ebp)
  8025d8:	ff 75 0c             	pushl  0xc(%ebp)
  8025db:	ff 75 08             	pushl  0x8(%ebp)
  8025de:	6a 12                	push   $0x12
  8025e0:	e8 4e fa ff ff       	call   802033 <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e8:	90                   	nop
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	52                   	push   %edx
  8025fb:	50                   	push   %eax
  8025fc:	6a 2a                	push   $0x2a
  8025fe:	e8 30 fa ff ff       	call   802033 <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
	return;
  802606:	90                   	nop
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	50                   	push   %eax
  802618:	6a 2b                	push   $0x2b
  80261a:	e8 14 fa ff ff       	call   802033 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	ff 75 0c             	pushl  0xc(%ebp)
  802630:	ff 75 08             	pushl  0x8(%ebp)
  802633:	6a 2c                	push   $0x2c
  802635:	e8 f9 f9 ff ff       	call   802033 <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
	return;
  80263d:	90                   	nop
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	ff 75 0c             	pushl  0xc(%ebp)
  80264c:	ff 75 08             	pushl  0x8(%ebp)
  80264f:	6a 2d                	push   $0x2d
  802651:	e8 dd f9 ff ff       	call   802033 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
	return;
  802659:	90                   	nop
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	83 e8 04             	sub    $0x4,%eax
  802668:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80266b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	83 e8 04             	sub    $0x4,%eax
  802681:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802684:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	83 e0 01             	and    $0x1,%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	0f 94 c0             	sete   %al
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802699:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8026a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a3:	83 f8 02             	cmp    $0x2,%eax
  8026a6:	74 2b                	je     8026d3 <alloc_block+0x40>
  8026a8:	83 f8 02             	cmp    $0x2,%eax
  8026ab:	7f 07                	jg     8026b4 <alloc_block+0x21>
  8026ad:	83 f8 01             	cmp    $0x1,%eax
  8026b0:	74 0e                	je     8026c0 <alloc_block+0x2d>
  8026b2:	eb 58                	jmp    80270c <alloc_block+0x79>
  8026b4:	83 f8 03             	cmp    $0x3,%eax
  8026b7:	74 2d                	je     8026e6 <alloc_block+0x53>
  8026b9:	83 f8 04             	cmp    $0x4,%eax
  8026bc:	74 3b                	je     8026f9 <alloc_block+0x66>
  8026be:	eb 4c                	jmp    80270c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8026c0:	83 ec 0c             	sub    $0xc,%esp
  8026c3:	ff 75 08             	pushl  0x8(%ebp)
  8026c6:	e8 11 03 00 00       	call   8029dc <alloc_block_FF>
  8026cb:	83 c4 10             	add    $0x10,%esp
  8026ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026d1:	eb 4a                	jmp    80271d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026d3:	83 ec 0c             	sub    $0xc,%esp
  8026d6:	ff 75 08             	pushl  0x8(%ebp)
  8026d9:	e8 fa 19 00 00       	call   8040d8 <alloc_block_NF>
  8026de:	83 c4 10             	add    $0x10,%esp
  8026e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026e4:	eb 37                	jmp    80271d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	e8 a7 07 00 00       	call   802e98 <alloc_block_BF>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026f7:	eb 24                	jmp    80271d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8026f9:	83 ec 0c             	sub    $0xc,%esp
  8026fc:	ff 75 08             	pushl  0x8(%ebp)
  8026ff:	e8 b7 19 00 00       	call   8040bb <alloc_block_WF>
  802704:	83 c4 10             	add    $0x10,%esp
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80270a:	eb 11                	jmp    80271d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80270c:	83 ec 0c             	sub    $0xc,%esp
  80270f:	68 88 4c 80 00       	push   $0x804c88
  802714:	e8 08 e5 ff ff       	call   800c21 <cprintf>
  802719:	83 c4 10             	add    $0x10,%esp
		break;
  80271c:	90                   	nop
	}
	return va;
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	53                   	push   %ebx
  802726:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802729:	83 ec 0c             	sub    $0xc,%esp
  80272c:	68 a8 4c 80 00       	push   $0x804ca8
  802731:	e8 eb e4 ff ff       	call   800c21 <cprintf>
  802736:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802739:	83 ec 0c             	sub    $0xc,%esp
  80273c:	68 d3 4c 80 00       	push   $0x804cd3
  802741:	e8 db e4 ff ff       	call   800c21 <cprintf>
  802746:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274f:	eb 37                	jmp    802788 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	ff 75 f4             	pushl  -0xc(%ebp)
  802757:	e8 19 ff ff ff       	call   802675 <is_free_block>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	0f be d8             	movsbl %al,%ebx
  802762:	83 ec 0c             	sub    $0xc,%esp
  802765:	ff 75 f4             	pushl  -0xc(%ebp)
  802768:	e8 ef fe ff ff       	call   80265c <get_block_size>
  80276d:	83 c4 10             	add    $0x10,%esp
  802770:	83 ec 04             	sub    $0x4,%esp
  802773:	53                   	push   %ebx
  802774:	50                   	push   %eax
  802775:	68 eb 4c 80 00       	push   $0x804ceb
  80277a:	e8 a2 e4 ff ff       	call   800c21 <cprintf>
  80277f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802782:	8b 45 10             	mov    0x10(%ebp),%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	74 07                	je     802795 <print_blocks_list+0x73>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	eb 05                	jmp    80279a <print_blocks_list+0x78>
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	89 45 10             	mov    %eax,0x10(%ebp)
  80279d:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	75 ad                	jne    802751 <print_blocks_list+0x2f>
  8027a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a8:	75 a7                	jne    802751 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8027aa:	83 ec 0c             	sub    $0xc,%esp
  8027ad:	68 a8 4c 80 00       	push   $0x804ca8
  8027b2:	e8 6a e4 ff ff       	call   800c21 <cprintf>
  8027b7:	83 c4 10             	add    $0x10,%esp

}
  8027ba:	90                   	nop
  8027bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8027c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c9:	83 e0 01             	and    $0x1,%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	74 03                	je     8027d3 <initialize_dynamic_allocator+0x13>
  8027d0:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027d7:	0f 84 c7 01 00 00    	je     8029a4 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027dd:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8027e4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8027e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ed:	01 d0                	add    %edx,%eax
  8027ef:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027f4:	0f 87 ad 01 00 00    	ja     8029a7 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	0f 89 a5 01 00 00    	jns    8029aa <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802805:	8b 55 08             	mov    0x8(%ebp),%edx
  802808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280b:	01 d0                	add    %edx,%eax
  80280d:	83 e8 04             	sub    $0x4,%eax
  802810:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802815:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80281c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	e9 87 00 00 00       	jmp    8028b0 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282d:	75 14                	jne    802843 <initialize_dynamic_allocator+0x83>
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	68 03 4d 80 00       	push   $0x804d03
  802837:	6a 79                	push   $0x79
  802839:	68 21 4d 80 00       	push   $0x804d21
  80283e:	e8 b2 18 00 00       	call   8040f5 <_panic>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 00                	mov    (%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 10                	je     80285c <initialize_dynamic_allocator+0x9c>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	8b 52 04             	mov    0x4(%edx),%edx
  802857:	89 50 04             	mov    %edx,0x4(%eax)
  80285a:	eb 0b                	jmp    802867 <initialize_dynamic_allocator+0xa7>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	a3 30 50 80 00       	mov    %eax,0x805030
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 0f                	je     802880 <initialize_dynamic_allocator+0xc0>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287a:	8b 12                	mov    (%edx),%edx
  80287c:	89 10                	mov    %edx,(%eax)
  80287e:	eb 0a                	jmp    80288a <initialize_dynamic_allocator+0xca>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289d:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a2:	48                   	dec    %eax
  8028a3:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8028a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b4:	74 07                	je     8028bd <initialize_dynamic_allocator+0xfd>
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	eb 05                	jmp    8028c2 <initialize_dynamic_allocator+0x102>
  8028bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8028c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	0f 85 55 ff ff ff    	jne    802829 <initialize_dynamic_allocator+0x69>
  8028d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d8:	0f 85 4b ff ff ff    	jne    802829 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8028ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8028f2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8028f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8028fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 08             	add    $0x8,%eax
  802908:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	83 c0 04             	add    $0x4,%eax
  802911:	8b 55 0c             	mov    0xc(%ebp),%edx
  802914:	83 ea 08             	sub    $0x8,%edx
  802917:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	83 e8 08             	sub    $0x8,%eax
  802924:	8b 55 0c             	mov    0xc(%ebp),%edx
  802927:	83 ea 08             	sub    $0x8,%edx
  80292a:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802938:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80293f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802943:	75 17                	jne    80295c <initialize_dynamic_allocator+0x19c>
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 3c 4d 80 00       	push   $0x804d3c
  80294d:	68 90 00 00 00       	push   $0x90
  802952:	68 21 4d 80 00       	push   $0x804d21
  802957:	e8 99 17 00 00       	call   8040f5 <_panic>
  80295c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	89 10                	mov    %edx,(%eax)
  802967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	85 c0                	test   %eax,%eax
  80296e:	74 0d                	je     80297d <initialize_dynamic_allocator+0x1bd>
  802970:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802975:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802978:	89 50 04             	mov    %edx,0x4(%eax)
  80297b:	eb 08                	jmp    802985 <initialize_dynamic_allocator+0x1c5>
  80297d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802980:	a3 30 50 80 00       	mov    %eax,0x805030
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802997:	a1 38 50 80 00       	mov    0x805038,%eax
  80299c:	40                   	inc    %eax
  80299d:	a3 38 50 80 00       	mov    %eax,0x805038
  8029a2:	eb 07                	jmp    8029ab <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8029a4:	90                   	nop
  8029a5:	eb 04                	jmp    8029ab <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8029a7:	90                   	nop
  8029a8:	eb 01                	jmp    8029ab <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8029aa:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8029ab:	c9                   	leave  
  8029ac:	c3                   	ret    

008029ad <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8029ad:	55                   	push   %ebp
  8029ae:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8029b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8029b3:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029bf:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	83 e8 04             	sub    $0x4,%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	83 e0 fe             	and    $0xfffffffe,%eax
  8029cc:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	01 c2                	add    %eax,%edx
  8029d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d7:	89 02                	mov    %eax,(%edx)
}
  8029d9:	90                   	nop
  8029da:	5d                   	pop    %ebp
  8029db:	c3                   	ret    

008029dc <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	83 e0 01             	and    $0x1,%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 03                	je     8029ef <alloc_block_FF+0x13>
  8029ec:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029ef:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029f3:	77 07                	ja     8029fc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029f5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029fc:	a1 24 50 80 00       	mov    0x805024,%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	75 73                	jne    802a78 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	83 c0 10             	add    $0x10,%eax
  802a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a0e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	01 d0                	add    %edx,%eax
  802a1d:	48                   	dec    %eax
  802a1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a24:	ba 00 00 00 00       	mov    $0x0,%edx
  802a29:	f7 75 ec             	divl   -0x14(%ebp)
  802a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2f:	29 d0                	sub    %edx,%eax
  802a31:	c1 e8 0c             	shr    $0xc,%eax
  802a34:	83 ec 0c             	sub    $0xc,%esp
  802a37:	50                   	push   %eax
  802a38:	e8 86 f1 ff ff       	call   801bc3 <sbrk>
  802a3d:	83 c4 10             	add    $0x10,%esp
  802a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a43:	83 ec 0c             	sub    $0xc,%esp
  802a46:	6a 00                	push   $0x0
  802a48:	e8 76 f1 ff ff       	call   801bc3 <sbrk>
  802a4d:	83 c4 10             	add    $0x10,%esp
  802a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a56:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a59:	83 ec 08             	sub    $0x8,%esp
  802a5c:	50                   	push   %eax
  802a5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a60:	e8 5b fd ff ff       	call   8027c0 <initialize_dynamic_allocator>
  802a65:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a68:	83 ec 0c             	sub    $0xc,%esp
  802a6b:	68 5f 4d 80 00       	push   $0x804d5f
  802a70:	e8 ac e1 ff ff       	call   800c21 <cprintf>
  802a75:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7c:	75 0a                	jne    802a88 <alloc_block_FF+0xac>
	        return NULL;
  802a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a83:	e9 0e 04 00 00       	jmp    802e96 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a8f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a97:	e9 f3 02 00 00       	jmp    802d8f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802aa2:	83 ec 0c             	sub    $0xc,%esp
  802aa5:	ff 75 bc             	pushl  -0x44(%ebp)
  802aa8:	e8 af fb ff ff       	call   80265c <get_block_size>
  802aad:	83 c4 10             	add    $0x10,%esp
  802ab0:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	83 c0 08             	add    $0x8,%eax
  802ab9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802abc:	0f 87 c5 02 00 00    	ja     802d87 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	83 c0 18             	add    $0x18,%eax
  802ac8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802acb:	0f 87 19 02 00 00    	ja     802cea <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ad1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ad4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad7:	83 e8 08             	sub    $0x8,%eax
  802ada:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8d 50 08             	lea    0x8(%eax),%edx
  802ae3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ae6:	01 d0                	add    %edx,%eax
  802ae8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	83 c0 08             	add    $0x8,%eax
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	6a 01                	push   $0x1
  802af6:	50                   	push   %eax
  802af7:	ff 75 bc             	pushl  -0x44(%ebp)
  802afa:	e8 ae fe ff ff       	call   8029ad <set_block_data>
  802aff:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	75 68                	jne    802b74 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b0c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b10:	75 17                	jne    802b29 <alloc_block_FF+0x14d>
  802b12:	83 ec 04             	sub    $0x4,%esp
  802b15:	68 3c 4d 80 00       	push   $0x804d3c
  802b1a:	68 d7 00 00 00       	push   $0xd7
  802b1f:	68 21 4d 80 00       	push   $0x804d21
  802b24:	e8 cc 15 00 00       	call   8040f5 <_panic>
  802b29:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b32:	89 10                	mov    %edx,(%eax)
  802b34:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 0d                	je     802b4a <alloc_block_FF+0x16e>
  802b3d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b42:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b45:	89 50 04             	mov    %edx,0x4(%eax)
  802b48:	eb 08                	jmp    802b52 <alloc_block_FF+0x176>
  802b4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b52:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b64:	a1 38 50 80 00       	mov    0x805038,%eax
  802b69:	40                   	inc    %eax
  802b6a:	a3 38 50 80 00       	mov    %eax,0x805038
  802b6f:	e9 dc 00 00 00       	jmp    802c50 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	75 65                	jne    802be2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b7d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b81:	75 17                	jne    802b9a <alloc_block_FF+0x1be>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 70 4d 80 00       	push   $0x804d70
  802b8b:	68 db 00 00 00       	push   $0xdb
  802b90:	68 21 4d 80 00       	push   $0x804d21
  802b95:	e8 5b 15 00 00       	call   8040f5 <_panic>
  802b9a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ba0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0c                	je     802bbc <alloc_block_FF+0x1e0>
  802bb0:	a1 30 50 80 00       	mov    0x805030,%eax
  802bb5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	eb 08                	jmp    802bc4 <alloc_block_FF+0x1e8>
  802bbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bbf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bcc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bda:	40                   	inc    %eax
  802bdb:	a3 38 50 80 00       	mov    %eax,0x805038
  802be0:	eb 6e                	jmp    802c50 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be6:	74 06                	je     802bee <alloc_block_FF+0x212>
  802be8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bec:	75 17                	jne    802c05 <alloc_block_FF+0x229>
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	68 94 4d 80 00       	push   $0x804d94
  802bf6:	68 df 00 00 00       	push   $0xdf
  802bfb:	68 21 4d 80 00       	push   $0x804d21
  802c00:	e8 f0 14 00 00       	call   8040f5 <_panic>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 10                	mov    (%eax),%edx
  802c0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0d:	89 10                	mov    %edx,(%eax)
  802c0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	74 0b                	je     802c23 <alloc_block_FF+0x247>
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c20:	89 50 04             	mov    %edx,0x4(%eax)
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c31:	89 50 04             	mov    %edx,0x4(%eax)
  802c34:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	75 08                	jne    802c45 <alloc_block_FF+0x269>
  802c3d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c40:	a3 30 50 80 00       	mov    %eax,0x805030
  802c45:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4a:	40                   	inc    %eax
  802c4b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c54:	75 17                	jne    802c6d <alloc_block_FF+0x291>
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	68 03 4d 80 00       	push   $0x804d03
  802c5e:	68 e1 00 00 00       	push   $0xe1
  802c63:	68 21 4d 80 00       	push   $0x804d21
  802c68:	e8 88 14 00 00       	call   8040f5 <_panic>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 10                	je     802c86 <alloc_block_FF+0x2aa>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7e:	8b 52 04             	mov    0x4(%edx),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	eb 0b                	jmp    802c91 <alloc_block_FF+0x2b5>
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	a3 30 50 80 00       	mov    %eax,0x805030
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0f                	je     802caa <alloc_block_FF+0x2ce>
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca4:	8b 12                	mov    (%edx),%edx
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	eb 0a                	jmp    802cb4 <alloc_block_FF+0x2d8>
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccc:	48                   	dec    %eax
  802ccd:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802cd2:	83 ec 04             	sub    $0x4,%esp
  802cd5:	6a 00                	push   $0x0
  802cd7:	ff 75 b4             	pushl  -0x4c(%ebp)
  802cda:	ff 75 b0             	pushl  -0x50(%ebp)
  802cdd:	e8 cb fc ff ff       	call   8029ad <set_block_data>
  802ce2:	83 c4 10             	add    $0x10,%esp
  802ce5:	e9 95 00 00 00       	jmp    802d7f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	6a 01                	push   $0x1
  802cef:	ff 75 b8             	pushl  -0x48(%ebp)
  802cf2:	ff 75 bc             	pushl  -0x44(%ebp)
  802cf5:	e8 b3 fc ff ff       	call   8029ad <set_block_data>
  802cfa:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d01:	75 17                	jne    802d1a <alloc_block_FF+0x33e>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 03 4d 80 00       	push   $0x804d03
  802d0b:	68 e8 00 00 00       	push   $0xe8
  802d10:	68 21 4d 80 00       	push   $0x804d21
  802d15:	e8 db 13 00 00       	call   8040f5 <_panic>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <alloc_block_FF+0x357>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <alloc_block_FF+0x362>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <alloc_block_FF+0x37b>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <alloc_block_FF+0x385>
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 38 50 80 00       	mov    0x805038,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802d7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d82:	e9 0f 01 00 00       	jmp    802e96 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d87:	a1 34 50 80 00       	mov    0x805034,%eax
  802d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	74 07                	je     802d9c <alloc_block_FF+0x3c0>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	eb 05                	jmp    802da1 <alloc_block_FF+0x3c5>
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802da1:	a3 34 50 80 00       	mov    %eax,0x805034
  802da6:	a1 34 50 80 00       	mov    0x805034,%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	0f 85 e9 fc ff ff    	jne    802a9c <alloc_block_FF+0xc0>
  802db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db7:	0f 85 df fc ff ff    	jne    802a9c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	83 c0 08             	add    $0x8,%eax
  802dc3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dc6:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802dcd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dd3:	01 d0                	add    %edx,%eax
  802dd5:	48                   	dec    %eax
  802dd6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  802de1:	f7 75 d8             	divl   -0x28(%ebp)
  802de4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802de7:	29 d0                	sub    %edx,%eax
  802de9:	c1 e8 0c             	shr    $0xc,%eax
  802dec:	83 ec 0c             	sub    $0xc,%esp
  802def:	50                   	push   %eax
  802df0:	e8 ce ed ff ff       	call   801bc3 <sbrk>
  802df5:	83 c4 10             	add    $0x10,%esp
  802df8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802dfb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802dff:	75 0a                	jne    802e0b <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e01:	b8 00 00 00 00       	mov    $0x0,%eax
  802e06:	e9 8b 00 00 00       	jmp    802e96 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e0b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e12:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e18:	01 d0                	add    %edx,%eax
  802e1a:	48                   	dec    %eax
  802e1b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e21:	ba 00 00 00 00       	mov    $0x0,%edx
  802e26:	f7 75 cc             	divl   -0x34(%ebp)
  802e29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e2c:	29 d0                	sub    %edx,%eax
  802e2e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e31:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e34:	01 d0                	add    %edx,%eax
  802e36:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802e3b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e46:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e53:	01 d0                	add    %edx,%eax
  802e55:	48                   	dec    %eax
  802e56:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e61:	f7 75 c4             	divl   -0x3c(%ebp)
  802e64:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e67:	29 d0                	sub    %edx,%eax
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	6a 01                	push   $0x1
  802e6e:	50                   	push   %eax
  802e6f:	ff 75 d0             	pushl  -0x30(%ebp)
  802e72:	e8 36 fb ff ff       	call   8029ad <set_block_data>
  802e77:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e7a:	83 ec 0c             	sub    $0xc,%esp
  802e7d:	ff 75 d0             	pushl  -0x30(%ebp)
  802e80:	e8 1b 0a 00 00       	call   8038a0 <free_block>
  802e85:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e88:	83 ec 0c             	sub    $0xc,%esp
  802e8b:	ff 75 08             	pushl  0x8(%ebp)
  802e8e:	e8 49 fb ff ff       	call   8029dc <alloc_block_FF>
  802e93:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e96:	c9                   	leave  
  802e97:	c3                   	ret    

00802e98 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e98:	55                   	push   %ebp
  802e99:	89 e5                	mov    %esp,%ebp
  802e9b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	83 e0 01             	and    $0x1,%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 03                	je     802eab <alloc_block_BF+0x13>
  802ea8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802eab:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802eaf:	77 07                	ja     802eb8 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802eb1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802eb8:	a1 24 50 80 00       	mov    0x805024,%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	75 73                	jne    802f34 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	83 c0 10             	add    $0x10,%eax
  802ec7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802eca:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ed1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed7:	01 d0                	add    %edx,%eax
  802ed9:	48                   	dec    %eax
  802eda:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee5:	f7 75 e0             	divl   -0x20(%ebp)
  802ee8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eeb:	29 d0                	sub    %edx,%eax
  802eed:	c1 e8 0c             	shr    $0xc,%eax
  802ef0:	83 ec 0c             	sub    $0xc,%esp
  802ef3:	50                   	push   %eax
  802ef4:	e8 ca ec ff ff       	call   801bc3 <sbrk>
  802ef9:	83 c4 10             	add    $0x10,%esp
  802efc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802eff:	83 ec 0c             	sub    $0xc,%esp
  802f02:	6a 00                	push   $0x0
  802f04:	e8 ba ec ff ff       	call   801bc3 <sbrk>
  802f09:	83 c4 10             	add    $0x10,%esp
  802f0c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f12:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f15:	83 ec 08             	sub    $0x8,%esp
  802f18:	50                   	push   %eax
  802f19:	ff 75 d8             	pushl  -0x28(%ebp)
  802f1c:	e8 9f f8 ff ff       	call   8027c0 <initialize_dynamic_allocator>
  802f21:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f24:	83 ec 0c             	sub    $0xc,%esp
  802f27:	68 5f 4d 80 00       	push   $0x804d5f
  802f2c:	e8 f0 dc ff ff       	call   800c21 <cprintf>
  802f31:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f42:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f50:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f58:	e9 1d 01 00 00       	jmp    80307a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f63:	83 ec 0c             	sub    $0xc,%esp
  802f66:	ff 75 a8             	pushl  -0x58(%ebp)
  802f69:	e8 ee f6 ff ff       	call   80265c <get_block_size>
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	83 c0 08             	add    $0x8,%eax
  802f7a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f7d:	0f 87 ef 00 00 00    	ja     803072 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	83 c0 18             	add    $0x18,%eax
  802f89:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f8c:	77 1d                	ja     802fab <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f91:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f94:	0f 86 d8 00 00 00    	jbe    803072 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f9a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802fa0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fa6:	e9 c7 00 00 00       	jmp    803072 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	83 c0 08             	add    $0x8,%eax
  802fb1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fb4:	0f 85 9d 00 00 00    	jne    803057 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802fba:	83 ec 04             	sub    $0x4,%esp
  802fbd:	6a 01                	push   $0x1
  802fbf:	ff 75 a4             	pushl  -0x5c(%ebp)
  802fc2:	ff 75 a8             	pushl  -0x58(%ebp)
  802fc5:	e8 e3 f9 ff ff       	call   8029ad <set_block_data>
  802fca:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd1:	75 17                	jne    802fea <alloc_block_BF+0x152>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	68 03 4d 80 00       	push   $0x804d03
  802fdb:	68 2c 01 00 00       	push   $0x12c
  802fe0:	68 21 4d 80 00       	push   $0x804d21
  802fe5:	e8 0b 11 00 00       	call   8040f5 <_panic>
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	74 10                	je     803003 <alloc_block_BF+0x16b>
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffb:	8b 52 04             	mov    0x4(%edx),%edx
  802ffe:	89 50 04             	mov    %edx,0x4(%eax)
  803001:	eb 0b                	jmp    80300e <alloc_block_BF+0x176>
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	a3 30 50 80 00       	mov    %eax,0x805030
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	74 0f                	je     803027 <alloc_block_BF+0x18f>
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	8b 40 04             	mov    0x4(%eax),%eax
  80301e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803021:	8b 12                	mov    (%edx),%edx
  803023:	89 10                	mov    %edx,(%eax)
  803025:	eb 0a                	jmp    803031 <alloc_block_BF+0x199>
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803044:	a1 38 50 80 00       	mov    0x805038,%eax
  803049:	48                   	dec    %eax
  80304a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80304f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803052:	e9 24 04 00 00       	jmp    80347b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80305d:	76 13                	jbe    803072 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80305f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803066:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803069:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80306c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80306f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803072:	a1 34 50 80 00       	mov    0x805034,%eax
  803077:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307e:	74 07                	je     803087 <alloc_block_BF+0x1ef>
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	eb 05                	jmp    80308c <alloc_block_BF+0x1f4>
  803087:	b8 00 00 00 00       	mov    $0x0,%eax
  80308c:	a3 34 50 80 00       	mov    %eax,0x805034
  803091:	a1 34 50 80 00       	mov    0x805034,%eax
  803096:	85 c0                	test   %eax,%eax
  803098:	0f 85 bf fe ff ff    	jne    802f5d <alloc_block_BF+0xc5>
  80309e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a2:	0f 85 b5 fe ff ff    	jne    802f5d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8030a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ac:	0f 84 26 02 00 00    	je     8032d8 <alloc_block_BF+0x440>
  8030b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b6:	0f 85 1c 02 00 00    	jne    8032d8 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8030c2:	83 e8 08             	sub    $0x8,%eax
  8030c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8d 50 08             	lea    0x8(%eax),%edx
  8030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d1:	01 d0                	add    %edx,%eax
  8030d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	83 c0 08             	add    $0x8,%eax
  8030dc:	83 ec 04             	sub    $0x4,%esp
  8030df:	6a 01                	push   $0x1
  8030e1:	50                   	push   %eax
  8030e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e5:	e8 c3 f8 ff ff       	call   8029ad <set_block_data>
  8030ea:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8030ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	85 c0                	test   %eax,%eax
  8030f5:	75 68                	jne    80315f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030fb:	75 17                	jne    803114 <alloc_block_BF+0x27c>
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 3c 4d 80 00       	push   $0x804d3c
  803105:	68 45 01 00 00       	push   $0x145
  80310a:	68 21 4d 80 00       	push   $0x804d21
  80310f:	e8 e1 0f 00 00       	call   8040f5 <_panic>
  803114:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80311a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311d:	89 10                	mov    %edx,(%eax)
  80311f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 0d                	je     803135 <alloc_block_BF+0x29d>
  803128:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80312d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803130:	89 50 04             	mov    %edx,0x4(%eax)
  803133:	eb 08                	jmp    80313d <alloc_block_BF+0x2a5>
  803135:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803138:	a3 30 50 80 00       	mov    %eax,0x805030
  80313d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803140:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803145:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803148:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314f:	a1 38 50 80 00       	mov    0x805038,%eax
  803154:	40                   	inc    %eax
  803155:	a3 38 50 80 00       	mov    %eax,0x805038
  80315a:	e9 dc 00 00 00       	jmp    80323b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	85 c0                	test   %eax,%eax
  803166:	75 65                	jne    8031cd <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803168:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80316c:	75 17                	jne    803185 <alloc_block_BF+0x2ed>
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	68 70 4d 80 00       	push   $0x804d70
  803176:	68 4a 01 00 00       	push   $0x14a
  80317b:	68 21 4d 80 00       	push   $0x804d21
  803180:	e8 70 0f 00 00       	call   8040f5 <_panic>
  803185:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80318b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803194:	8b 40 04             	mov    0x4(%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 0c                	je     8031a7 <alloc_block_BF+0x30f>
  80319b:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031a3:	89 10                	mov    %edx,(%eax)
  8031a5:	eb 08                	jmp    8031af <alloc_block_BF+0x317>
  8031a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c5:	40                   	inc    %eax
  8031c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8031cb:	eb 6e                	jmp    80323b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8031cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d1:	74 06                	je     8031d9 <alloc_block_BF+0x341>
  8031d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031d7:	75 17                	jne    8031f0 <alloc_block_BF+0x358>
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 94 4d 80 00       	push   $0x804d94
  8031e1:	68 4f 01 00 00       	push   $0x14f
  8031e6:	68 21 4d 80 00       	push   $0x804d21
  8031eb:	e8 05 0f 00 00       	call   8040f5 <_panic>
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 10                	mov    (%eax),%edx
  8031f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f8:	89 10                	mov    %edx,(%eax)
  8031fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0b                	je     80320e <alloc_block_BF+0x376>
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80320b:	89 50 04             	mov    %edx,0x4(%eax)
  80320e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803211:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	75 08                	jne    803230 <alloc_block_BF+0x398>
  803228:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80322b:	a3 30 50 80 00       	mov    %eax,0x805030
  803230:	a1 38 50 80 00       	mov    0x805038,%eax
  803235:	40                   	inc    %eax
  803236:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80323b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323f:	75 17                	jne    803258 <alloc_block_BF+0x3c0>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 03 4d 80 00       	push   $0x804d03
  803249:	68 51 01 00 00       	push   $0x151
  80324e:	68 21 4d 80 00       	push   $0x804d21
  803253:	e8 9d 0e 00 00       	call   8040f5 <_panic>
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 10                	je     803271 <alloc_block_BF+0x3d9>
  803261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803269:	8b 52 04             	mov    0x4(%edx),%edx
  80326c:	89 50 04             	mov    %edx,0x4(%eax)
  80326f:	eb 0b                	jmp    80327c <alloc_block_BF+0x3e4>
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	8b 40 04             	mov    0x4(%eax),%eax
  803277:	a3 30 50 80 00       	mov    %eax,0x805030
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	85 c0                	test   %eax,%eax
  803284:	74 0f                	je     803295 <alloc_block_BF+0x3fd>
  803286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803289:	8b 40 04             	mov    0x4(%eax),%eax
  80328c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328f:	8b 12                	mov    (%edx),%edx
  803291:	89 10                	mov    %edx,(%eax)
  803293:	eb 0a                	jmp    80329f <alloc_block_BF+0x407>
  803295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8032b7:	48                   	dec    %eax
  8032b8:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	6a 00                	push   $0x0
  8032c2:	ff 75 d0             	pushl  -0x30(%ebp)
  8032c5:	ff 75 cc             	pushl  -0x34(%ebp)
  8032c8:	e8 e0 f6 ff ff       	call   8029ad <set_block_data>
  8032cd:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d3:	e9 a3 01 00 00       	jmp    80347b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8032d8:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032dc:	0f 85 9d 00 00 00    	jne    80337f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	6a 01                	push   $0x1
  8032e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8032ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ed:	e8 bb f6 ff ff       	call   8029ad <set_block_data>
  8032f2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f9:	75 17                	jne    803312 <alloc_block_BF+0x47a>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 03 4d 80 00       	push   $0x804d03
  803303:	68 58 01 00 00       	push   $0x158
  803308:	68 21 4d 80 00       	push   $0x804d21
  80330d:	e8 e3 0d 00 00       	call   8040f5 <_panic>
  803312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 10                	je     80332b <alloc_block_BF+0x493>
  80331b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803323:	8b 52 04             	mov    0x4(%edx),%edx
  803326:	89 50 04             	mov    %edx,0x4(%eax)
  803329:	eb 0b                	jmp    803336 <alloc_block_BF+0x49e>
  80332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332e:	8b 40 04             	mov    0x4(%eax),%eax
  803331:	a3 30 50 80 00       	mov    %eax,0x805030
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	8b 40 04             	mov    0x4(%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	74 0f                	je     80334f <alloc_block_BF+0x4b7>
  803340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803349:	8b 12                	mov    (%edx),%edx
  80334b:	89 10                	mov    %edx,(%eax)
  80334d:	eb 0a                	jmp    803359 <alloc_block_BF+0x4c1>
  80334f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803365:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336c:	a1 38 50 80 00       	mov    0x805038,%eax
  803371:	48                   	dec    %eax
  803372:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337a:	e9 fc 00 00 00       	jmp    80347b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	83 c0 08             	add    $0x8,%eax
  803385:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803388:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80338f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803392:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803395:	01 d0                	add    %edx,%eax
  803397:	48                   	dec    %eax
  803398:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80339b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80339e:	ba 00 00 00 00       	mov    $0x0,%edx
  8033a3:	f7 75 c4             	divl   -0x3c(%ebp)
  8033a6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033a9:	29 d0                	sub    %edx,%eax
  8033ab:	c1 e8 0c             	shr    $0xc,%eax
  8033ae:	83 ec 0c             	sub    $0xc,%esp
  8033b1:	50                   	push   %eax
  8033b2:	e8 0c e8 ff ff       	call   801bc3 <sbrk>
  8033b7:	83 c4 10             	add    $0x10,%esp
  8033ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8033bd:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8033c1:	75 0a                	jne    8033cd <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c8:	e9 ae 00 00 00       	jmp    80347b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033cd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033d4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033da:	01 d0                	add    %edx,%eax
  8033dc:	48                   	dec    %eax
  8033dd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8033e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8033e8:	f7 75 b8             	divl   -0x48(%ebp)
  8033eb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033ee:	29 d0                	sub    %edx,%eax
  8033f0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033f3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033f6:	01 d0                	add    %edx,%eax
  8033f8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8033fd:	a1 40 50 80 00       	mov    0x805040,%eax
  803402:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803408:	83 ec 0c             	sub    $0xc,%esp
  80340b:	68 c8 4d 80 00       	push   $0x804dc8
  803410:	e8 0c d8 ff ff       	call   800c21 <cprintf>
  803415:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803418:	83 ec 08             	sub    $0x8,%esp
  80341b:	ff 75 bc             	pushl  -0x44(%ebp)
  80341e:	68 cd 4d 80 00       	push   $0x804dcd
  803423:	e8 f9 d7 ff ff       	call   800c21 <cprintf>
  803428:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80342b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803432:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803435:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803438:	01 d0                	add    %edx,%eax
  80343a:	48                   	dec    %eax
  80343b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80343e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803441:	ba 00 00 00 00       	mov    $0x0,%edx
  803446:	f7 75 b0             	divl   -0x50(%ebp)
  803449:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80344c:	29 d0                	sub    %edx,%eax
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	6a 01                	push   $0x1
  803453:	50                   	push   %eax
  803454:	ff 75 bc             	pushl  -0x44(%ebp)
  803457:	e8 51 f5 ff ff       	call   8029ad <set_block_data>
  80345c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80345f:	83 ec 0c             	sub    $0xc,%esp
  803462:	ff 75 bc             	pushl  -0x44(%ebp)
  803465:	e8 36 04 00 00       	call   8038a0 <free_block>
  80346a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80346d:	83 ec 0c             	sub    $0xc,%esp
  803470:	ff 75 08             	pushl  0x8(%ebp)
  803473:	e8 20 fa ff ff       	call   802e98 <alloc_block_BF>
  803478:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80347b:	c9                   	leave  
  80347c:	c3                   	ret    

0080347d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80347d:	55                   	push   %ebp
  80347e:	89 e5                	mov    %esp,%ebp
  803480:	53                   	push   %ebx
  803481:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80348b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803492:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803496:	74 1e                	je     8034b6 <merging+0x39>
  803498:	ff 75 08             	pushl  0x8(%ebp)
  80349b:	e8 bc f1 ff ff       	call   80265c <get_block_size>
  8034a0:	83 c4 04             	add    $0x4,%esp
  8034a3:	89 c2                	mov    %eax,%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	01 d0                	add    %edx,%eax
  8034aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8034ad:	75 07                	jne    8034b6 <merging+0x39>
		prev_is_free = 1;
  8034af:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8034b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ba:	74 1e                	je     8034da <merging+0x5d>
  8034bc:	ff 75 10             	pushl  0x10(%ebp)
  8034bf:	e8 98 f1 ff ff       	call   80265c <get_block_size>
  8034c4:	83 c4 04             	add    $0x4,%esp
  8034c7:	89 c2                	mov    %eax,%edx
  8034c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cc:	01 d0                	add    %edx,%eax
  8034ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034d1:	75 07                	jne    8034da <merging+0x5d>
		next_is_free = 1;
  8034d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8034da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034de:	0f 84 cc 00 00 00    	je     8035b0 <merging+0x133>
  8034e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e8:	0f 84 c2 00 00 00    	je     8035b0 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034ee:	ff 75 08             	pushl  0x8(%ebp)
  8034f1:	e8 66 f1 ff ff       	call   80265c <get_block_size>
  8034f6:	83 c4 04             	add    $0x4,%esp
  8034f9:	89 c3                	mov    %eax,%ebx
  8034fb:	ff 75 10             	pushl  0x10(%ebp)
  8034fe:	e8 59 f1 ff ff       	call   80265c <get_block_size>
  803503:	83 c4 04             	add    $0x4,%esp
  803506:	01 c3                	add    %eax,%ebx
  803508:	ff 75 0c             	pushl  0xc(%ebp)
  80350b:	e8 4c f1 ff ff       	call   80265c <get_block_size>
  803510:	83 c4 04             	add    $0x4,%esp
  803513:	01 d8                	add    %ebx,%eax
  803515:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803518:	6a 00                	push   $0x0
  80351a:	ff 75 ec             	pushl  -0x14(%ebp)
  80351d:	ff 75 08             	pushl  0x8(%ebp)
  803520:	e8 88 f4 ff ff       	call   8029ad <set_block_data>
  803525:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80352c:	75 17                	jne    803545 <merging+0xc8>
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	68 03 4d 80 00       	push   $0x804d03
  803536:	68 7d 01 00 00       	push   $0x17d
  80353b:	68 21 4d 80 00       	push   $0x804d21
  803540:	e8 b0 0b 00 00       	call   8040f5 <_panic>
  803545:	8b 45 0c             	mov    0xc(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 10                	je     80355e <merging+0xe1>
  80354e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	8b 55 0c             	mov    0xc(%ebp),%edx
  803556:	8b 52 04             	mov    0x4(%edx),%edx
  803559:	89 50 04             	mov    %edx,0x4(%eax)
  80355c:	eb 0b                	jmp    803569 <merging+0xec>
  80355e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803561:	8b 40 04             	mov    0x4(%eax),%eax
  803564:	a3 30 50 80 00       	mov    %eax,0x805030
  803569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356c:	8b 40 04             	mov    0x4(%eax),%eax
  80356f:	85 c0                	test   %eax,%eax
  803571:	74 0f                	je     803582 <merging+0x105>
  803573:	8b 45 0c             	mov    0xc(%ebp),%eax
  803576:	8b 40 04             	mov    0x4(%eax),%eax
  803579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80357c:	8b 12                	mov    (%edx),%edx
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	eb 0a                	jmp    80358c <merging+0x10f>
  803582:	8b 45 0c             	mov    0xc(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80358c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803595:	8b 45 0c             	mov    0xc(%ebp),%eax
  803598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359f:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a4:	48                   	dec    %eax
  8035a5:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8035aa:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035ab:	e9 ea 02 00 00       	jmp    80389a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8035b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b4:	74 3b                	je     8035f1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8035b6:	83 ec 0c             	sub    $0xc,%esp
  8035b9:	ff 75 08             	pushl  0x8(%ebp)
  8035bc:	e8 9b f0 ff ff       	call   80265c <get_block_size>
  8035c1:	83 c4 10             	add    $0x10,%esp
  8035c4:	89 c3                	mov    %eax,%ebx
  8035c6:	83 ec 0c             	sub    $0xc,%esp
  8035c9:	ff 75 10             	pushl  0x10(%ebp)
  8035cc:	e8 8b f0 ff ff       	call   80265c <get_block_size>
  8035d1:	83 c4 10             	add    $0x10,%esp
  8035d4:	01 d8                	add    %ebx,%eax
  8035d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035d9:	83 ec 04             	sub    $0x4,%esp
  8035dc:	6a 00                	push   $0x0
  8035de:	ff 75 e8             	pushl  -0x18(%ebp)
  8035e1:	ff 75 08             	pushl  0x8(%ebp)
  8035e4:	e8 c4 f3 ff ff       	call   8029ad <set_block_data>
  8035e9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035ec:	e9 a9 02 00 00       	jmp    80389a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035f5:	0f 84 2d 01 00 00    	je     803728 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035fb:	83 ec 0c             	sub    $0xc,%esp
  8035fe:	ff 75 10             	pushl  0x10(%ebp)
  803601:	e8 56 f0 ff ff       	call   80265c <get_block_size>
  803606:	83 c4 10             	add    $0x10,%esp
  803609:	89 c3                	mov    %eax,%ebx
  80360b:	83 ec 0c             	sub    $0xc,%esp
  80360e:	ff 75 0c             	pushl  0xc(%ebp)
  803611:	e8 46 f0 ff ff       	call   80265c <get_block_size>
  803616:	83 c4 10             	add    $0x10,%esp
  803619:	01 d8                	add    %ebx,%eax
  80361b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80361e:	83 ec 04             	sub    $0x4,%esp
  803621:	6a 00                	push   $0x0
  803623:	ff 75 e4             	pushl  -0x1c(%ebp)
  803626:	ff 75 10             	pushl  0x10(%ebp)
  803629:	e8 7f f3 ff ff       	call   8029ad <set_block_data>
  80362e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803631:	8b 45 10             	mov    0x10(%ebp),%eax
  803634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803637:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80363b:	74 06                	je     803643 <merging+0x1c6>
  80363d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803641:	75 17                	jne    80365a <merging+0x1dd>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 dc 4d 80 00       	push   $0x804ddc
  80364b:	68 8d 01 00 00       	push   $0x18d
  803650:	68 21 4d 80 00       	push   $0x804d21
  803655:	e8 9b 0a 00 00       	call   8040f5 <_panic>
  80365a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365d:	8b 50 04             	mov    0x4(%eax),%edx
  803660:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803663:	89 50 04             	mov    %edx,0x4(%eax)
  803666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803671:	8b 40 04             	mov    0x4(%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 0d                	je     803685 <merging+0x208>
  803678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367b:	8b 40 04             	mov    0x4(%eax),%eax
  80367e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803681:	89 10                	mov    %edx,(%eax)
  803683:	eb 08                	jmp    80368d <merging+0x210>
  803685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803688:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80368d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803690:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803693:	89 50 04             	mov    %edx,0x4(%eax)
  803696:	a1 38 50 80 00       	mov    0x805038,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8036a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a5:	75 17                	jne    8036be <merging+0x241>
  8036a7:	83 ec 04             	sub    $0x4,%esp
  8036aa:	68 03 4d 80 00       	push   $0x804d03
  8036af:	68 8e 01 00 00       	push   $0x18e
  8036b4:	68 21 4d 80 00       	push   $0x804d21
  8036b9:	e8 37 0a 00 00       	call   8040f5 <_panic>
  8036be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 10                	je     8036d7 <merging+0x25a>
  8036c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036cf:	8b 52 04             	mov    0x4(%edx),%edx
  8036d2:	89 50 04             	mov    %edx,0x4(%eax)
  8036d5:	eb 0b                	jmp    8036e2 <merging+0x265>
  8036d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e5:	8b 40 04             	mov    0x4(%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 0f                	je     8036fb <merging+0x27e>
  8036ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ef:	8b 40 04             	mov    0x4(%eax),%eax
  8036f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036f5:	8b 12                	mov    (%edx),%edx
  8036f7:	89 10                	mov    %edx,(%eax)
  8036f9:	eb 0a                	jmp    803705 <merging+0x288>
  8036fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803705:	8b 45 0c             	mov    0xc(%ebp),%eax
  803708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803718:	a1 38 50 80 00       	mov    0x805038,%eax
  80371d:	48                   	dec    %eax
  80371e:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803723:	e9 72 01 00 00       	jmp    80389a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803728:	8b 45 10             	mov    0x10(%ebp),%eax
  80372b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80372e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803732:	74 79                	je     8037ad <merging+0x330>
  803734:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803738:	74 73                	je     8037ad <merging+0x330>
  80373a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80373e:	74 06                	je     803746 <merging+0x2c9>
  803740:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803744:	75 17                	jne    80375d <merging+0x2e0>
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	68 94 4d 80 00       	push   $0x804d94
  80374e:	68 94 01 00 00       	push   $0x194
  803753:	68 21 4d 80 00       	push   $0x804d21
  803758:	e8 98 09 00 00       	call   8040f5 <_panic>
  80375d:	8b 45 08             	mov    0x8(%ebp),%eax
  803760:	8b 10                	mov    (%eax),%edx
  803762:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803765:	89 10                	mov    %edx,(%eax)
  803767:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	85 c0                	test   %eax,%eax
  80376e:	74 0b                	je     80377b <merging+0x2fe>
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	8b 00                	mov    (%eax),%eax
  803775:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803778:	89 50 04             	mov    %edx,0x4(%eax)
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803781:	89 10                	mov    %edx,(%eax)
  803783:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803786:	8b 55 08             	mov    0x8(%ebp),%edx
  803789:	89 50 04             	mov    %edx,0x4(%eax)
  80378c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378f:	8b 00                	mov    (%eax),%eax
  803791:	85 c0                	test   %eax,%eax
  803793:	75 08                	jne    80379d <merging+0x320>
  803795:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803798:	a3 30 50 80 00       	mov    %eax,0x805030
  80379d:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a2:	40                   	inc    %eax
  8037a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8037a8:	e9 ce 00 00 00       	jmp    80387b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8037ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b1:	74 65                	je     803818 <merging+0x39b>
  8037b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b7:	75 17                	jne    8037d0 <merging+0x353>
  8037b9:	83 ec 04             	sub    $0x4,%esp
  8037bc:	68 70 4d 80 00       	push   $0x804d70
  8037c1:	68 95 01 00 00       	push   $0x195
  8037c6:	68 21 4d 80 00       	push   $0x804d21
  8037cb:	e8 25 09 00 00       	call   8040f5 <_panic>
  8037d0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d9:	89 50 04             	mov    %edx,0x4(%eax)
  8037dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037df:	8b 40 04             	mov    0x4(%eax),%eax
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	74 0c                	je     8037f2 <merging+0x375>
  8037e6:	a1 30 50 80 00       	mov    0x805030,%eax
  8037eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ee:	89 10                	mov    %edx,(%eax)
  8037f0:	eb 08                	jmp    8037fa <merging+0x37d>
  8037f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803802:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380b:	a1 38 50 80 00       	mov    0x805038,%eax
  803810:	40                   	inc    %eax
  803811:	a3 38 50 80 00       	mov    %eax,0x805038
  803816:	eb 63                	jmp    80387b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803818:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80381c:	75 17                	jne    803835 <merging+0x3b8>
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 3c 4d 80 00       	push   $0x804d3c
  803826:	68 98 01 00 00       	push   $0x198
  80382b:	68 21 4d 80 00       	push   $0x804d21
  803830:	e8 c0 08 00 00       	call   8040f5 <_panic>
  803835:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80383b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383e:	89 10                	mov    %edx,(%eax)
  803840:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	74 0d                	je     803856 <merging+0x3d9>
  803849:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80384e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803851:	89 50 04             	mov    %edx,0x4(%eax)
  803854:	eb 08                	jmp    80385e <merging+0x3e1>
  803856:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803859:	a3 30 50 80 00       	mov    %eax,0x805030
  80385e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803861:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803866:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803869:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803870:	a1 38 50 80 00       	mov    0x805038,%eax
  803875:	40                   	inc    %eax
  803876:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80387b:	83 ec 0c             	sub    $0xc,%esp
  80387e:	ff 75 10             	pushl  0x10(%ebp)
  803881:	e8 d6 ed ff ff       	call   80265c <get_block_size>
  803886:	83 c4 10             	add    $0x10,%esp
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	6a 00                	push   $0x0
  80388e:	50                   	push   %eax
  80388f:	ff 75 10             	pushl  0x10(%ebp)
  803892:	e8 16 f1 ff ff       	call   8029ad <set_block_data>
  803897:	83 c4 10             	add    $0x10,%esp
	}
}
  80389a:	90                   	nop
  80389b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80389e:	c9                   	leave  
  80389f:	c3                   	ret    

008038a0 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8038a0:	55                   	push   %ebp
  8038a1:	89 e5                	mov    %esp,%ebp
  8038a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8038a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8038ae:	a1 30 50 80 00       	mov    0x805030,%eax
  8038b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038b6:	73 1b                	jae    8038d3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8038b8:	a1 30 50 80 00       	mov    0x805030,%eax
  8038bd:	83 ec 04             	sub    $0x4,%esp
  8038c0:	ff 75 08             	pushl  0x8(%ebp)
  8038c3:	6a 00                	push   $0x0
  8038c5:	50                   	push   %eax
  8038c6:	e8 b2 fb ff ff       	call   80347d <merging>
  8038cb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038ce:	e9 8b 00 00 00       	jmp    80395e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8038d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038db:	76 18                	jbe    8038f5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8038dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038e2:	83 ec 04             	sub    $0x4,%esp
  8038e5:	ff 75 08             	pushl  0x8(%ebp)
  8038e8:	50                   	push   %eax
  8038e9:	6a 00                	push   $0x0
  8038eb:	e8 8d fb ff ff       	call   80347d <merging>
  8038f0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038f3:	eb 69                	jmp    80395e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038fd:	eb 39                	jmp    803938 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803902:	3b 45 08             	cmp    0x8(%ebp),%eax
  803905:	73 29                	jae    803930 <free_block+0x90>
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80390f:	76 1f                	jbe    803930 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803919:	83 ec 04             	sub    $0x4,%esp
  80391c:	ff 75 08             	pushl  0x8(%ebp)
  80391f:	ff 75 f0             	pushl  -0x10(%ebp)
  803922:	ff 75 f4             	pushl  -0xc(%ebp)
  803925:	e8 53 fb ff ff       	call   80347d <merging>
  80392a:	83 c4 10             	add    $0x10,%esp
			break;
  80392d:	90                   	nop
		}
	}
}
  80392e:	eb 2e                	jmp    80395e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803930:	a1 34 50 80 00       	mov    0x805034,%eax
  803935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393c:	74 07                	je     803945 <free_block+0xa5>
  80393e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	eb 05                	jmp    80394a <free_block+0xaa>
  803945:	b8 00 00 00 00       	mov    $0x0,%eax
  80394a:	a3 34 50 80 00       	mov    %eax,0x805034
  80394f:	a1 34 50 80 00       	mov    0x805034,%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	75 a7                	jne    8038ff <free_block+0x5f>
  803958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395c:	75 a1                	jne    8038ff <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80395e:	90                   	nop
  80395f:	c9                   	leave  
  803960:	c3                   	ret    

00803961 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803961:	55                   	push   %ebp
  803962:	89 e5                	mov    %esp,%ebp
  803964:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803967:	ff 75 08             	pushl  0x8(%ebp)
  80396a:	e8 ed ec ff ff       	call   80265c <get_block_size>
  80396f:	83 c4 04             	add    $0x4,%esp
  803972:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803975:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80397c:	eb 17                	jmp    803995 <copy_data+0x34>
  80397e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803981:	8b 45 0c             	mov    0xc(%ebp),%eax
  803984:	01 c2                	add    %eax,%edx
  803986:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	01 c8                	add    %ecx,%eax
  80398e:	8a 00                	mov    (%eax),%al
  803990:	88 02                	mov    %al,(%edx)
  803992:	ff 45 fc             	incl   -0x4(%ebp)
  803995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80399b:	72 e1                	jb     80397e <copy_data+0x1d>
}
  80399d:	90                   	nop
  80399e:	c9                   	leave  
  80399f:	c3                   	ret    

008039a0 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8039a0:	55                   	push   %ebp
  8039a1:	89 e5                	mov    %esp,%ebp
  8039a3:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8039a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039aa:	75 23                	jne    8039cf <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8039ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039b0:	74 13                	je     8039c5 <realloc_block_FF+0x25>
  8039b2:	83 ec 0c             	sub    $0xc,%esp
  8039b5:	ff 75 0c             	pushl  0xc(%ebp)
  8039b8:	e8 1f f0 ff ff       	call   8029dc <alloc_block_FF>
  8039bd:	83 c4 10             	add    $0x10,%esp
  8039c0:	e9 f4 06 00 00       	jmp    8040b9 <realloc_block_FF+0x719>
		return NULL;
  8039c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ca:	e9 ea 06 00 00       	jmp    8040b9 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8039cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039d3:	75 18                	jne    8039ed <realloc_block_FF+0x4d>
	{
		free_block(va);
  8039d5:	83 ec 0c             	sub    $0xc,%esp
  8039d8:	ff 75 08             	pushl  0x8(%ebp)
  8039db:	e8 c0 fe ff ff       	call   8038a0 <free_block>
  8039e0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8039e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e8:	e9 cc 06 00 00       	jmp    8040b9 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8039ed:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039f1:	77 07                	ja     8039fa <realloc_block_FF+0x5a>
  8039f3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039fd:	83 e0 01             	and    $0x1,%eax
  803a00:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a06:	83 c0 08             	add    $0x8,%eax
  803a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a0c:	83 ec 0c             	sub    $0xc,%esp
  803a0f:	ff 75 08             	pushl  0x8(%ebp)
  803a12:	e8 45 ec ff ff       	call   80265c <get_block_size>
  803a17:	83 c4 10             	add    $0x10,%esp
  803a1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a20:	83 e8 08             	sub    $0x8,%eax
  803a23:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a26:	8b 45 08             	mov    0x8(%ebp),%eax
  803a29:	83 e8 04             	sub    $0x4,%eax
  803a2c:	8b 00                	mov    (%eax),%eax
  803a2e:	83 e0 fe             	and    $0xfffffffe,%eax
  803a31:	89 c2                	mov    %eax,%edx
  803a33:	8b 45 08             	mov    0x8(%ebp),%eax
  803a36:	01 d0                	add    %edx,%eax
  803a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a3b:	83 ec 0c             	sub    $0xc,%esp
  803a3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a41:	e8 16 ec ff ff       	call   80265c <get_block_size>
  803a46:	83 c4 10             	add    $0x10,%esp
  803a49:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a4f:	83 e8 08             	sub    $0x8,%eax
  803a52:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a58:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a5b:	75 08                	jne    803a65 <realloc_block_FF+0xc5>
	{
		 return va;
  803a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a60:	e9 54 06 00 00       	jmp    8040b9 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a68:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a6b:	0f 83 e5 03 00 00    	jae    803e56 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a77:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a7a:	83 ec 0c             	sub    $0xc,%esp
  803a7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a80:	e8 f0 eb ff ff       	call   802675 <is_free_block>
  803a85:	83 c4 10             	add    $0x10,%esp
  803a88:	84 c0                	test   %al,%al
  803a8a:	0f 84 3b 01 00 00    	je     803bcb <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a93:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a96:	01 d0                	add    %edx,%eax
  803a98:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a9b:	83 ec 04             	sub    $0x4,%esp
  803a9e:	6a 01                	push   $0x1
  803aa0:	ff 75 f0             	pushl  -0x10(%ebp)
  803aa3:	ff 75 08             	pushl  0x8(%ebp)
  803aa6:	e8 02 ef ff ff       	call   8029ad <set_block_data>
  803aab:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803aae:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab1:	83 e8 04             	sub    $0x4,%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	83 e0 fe             	and    $0xfffffffe,%eax
  803ab9:	89 c2                	mov    %eax,%edx
  803abb:	8b 45 08             	mov    0x8(%ebp),%eax
  803abe:	01 d0                	add    %edx,%eax
  803ac0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803ac3:	83 ec 04             	sub    $0x4,%esp
  803ac6:	6a 00                	push   $0x0
  803ac8:	ff 75 cc             	pushl  -0x34(%ebp)
  803acb:	ff 75 c8             	pushl  -0x38(%ebp)
  803ace:	e8 da ee ff ff       	call   8029ad <set_block_data>
  803ad3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ad6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ada:	74 06                	je     803ae2 <realloc_block_FF+0x142>
  803adc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ae0:	75 17                	jne    803af9 <realloc_block_FF+0x159>
  803ae2:	83 ec 04             	sub    $0x4,%esp
  803ae5:	68 94 4d 80 00       	push   $0x804d94
  803aea:	68 f6 01 00 00       	push   $0x1f6
  803aef:	68 21 4d 80 00       	push   $0x804d21
  803af4:	e8 fc 05 00 00       	call   8040f5 <_panic>
  803af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afc:	8b 10                	mov    (%eax),%edx
  803afe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b01:	89 10                	mov    %edx,(%eax)
  803b03:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b06:	8b 00                	mov    (%eax),%eax
  803b08:	85 c0                	test   %eax,%eax
  803b0a:	74 0b                	je     803b17 <realloc_block_FF+0x177>
  803b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0f:	8b 00                	mov    (%eax),%eax
  803b11:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b14:	89 50 04             	mov    %edx,0x4(%eax)
  803b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b1d:	89 10                	mov    %edx,(%eax)
  803b1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b25:	89 50 04             	mov    %edx,0x4(%eax)
  803b28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b2b:	8b 00                	mov    (%eax),%eax
  803b2d:	85 c0                	test   %eax,%eax
  803b2f:	75 08                	jne    803b39 <realloc_block_FF+0x199>
  803b31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b34:	a3 30 50 80 00       	mov    %eax,0x805030
  803b39:	a1 38 50 80 00       	mov    0x805038,%eax
  803b3e:	40                   	inc    %eax
  803b3f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b48:	75 17                	jne    803b61 <realloc_block_FF+0x1c1>
  803b4a:	83 ec 04             	sub    $0x4,%esp
  803b4d:	68 03 4d 80 00       	push   $0x804d03
  803b52:	68 f7 01 00 00       	push   $0x1f7
  803b57:	68 21 4d 80 00       	push   $0x804d21
  803b5c:	e8 94 05 00 00       	call   8040f5 <_panic>
  803b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	74 10                	je     803b7a <realloc_block_FF+0x1da>
  803b6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6d:	8b 00                	mov    (%eax),%eax
  803b6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b72:	8b 52 04             	mov    0x4(%edx),%edx
  803b75:	89 50 04             	mov    %edx,0x4(%eax)
  803b78:	eb 0b                	jmp    803b85 <realloc_block_FF+0x1e5>
  803b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7d:	8b 40 04             	mov    0x4(%eax),%eax
  803b80:	a3 30 50 80 00       	mov    %eax,0x805030
  803b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b88:	8b 40 04             	mov    0x4(%eax),%eax
  803b8b:	85 c0                	test   %eax,%eax
  803b8d:	74 0f                	je     803b9e <realloc_block_FF+0x1fe>
  803b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b92:	8b 40 04             	mov    0x4(%eax),%eax
  803b95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b98:	8b 12                	mov    (%edx),%edx
  803b9a:	89 10                	mov    %edx,(%eax)
  803b9c:	eb 0a                	jmp    803ba8 <realloc_block_FF+0x208>
  803b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bbb:	a1 38 50 80 00       	mov    0x805038,%eax
  803bc0:	48                   	dec    %eax
  803bc1:	a3 38 50 80 00       	mov    %eax,0x805038
  803bc6:	e9 83 02 00 00       	jmp    803e4e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803bcb:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803bcf:	0f 86 69 02 00 00    	jbe    803e3e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803bd5:	83 ec 04             	sub    $0x4,%esp
  803bd8:	6a 01                	push   $0x1
  803bda:	ff 75 f0             	pushl  -0x10(%ebp)
  803bdd:	ff 75 08             	pushl  0x8(%ebp)
  803be0:	e8 c8 ed ff ff       	call   8029ad <set_block_data>
  803be5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803be8:	8b 45 08             	mov    0x8(%ebp),%eax
  803beb:	83 e8 04             	sub    $0x4,%eax
  803bee:	8b 00                	mov    (%eax),%eax
  803bf0:	83 e0 fe             	and    $0xfffffffe,%eax
  803bf3:	89 c2                	mov    %eax,%edx
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	01 d0                	add    %edx,%eax
  803bfa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803bfd:	a1 38 50 80 00       	mov    0x805038,%eax
  803c02:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c05:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c09:	75 68                	jne    803c73 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c0b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c0f:	75 17                	jne    803c28 <realloc_block_FF+0x288>
  803c11:	83 ec 04             	sub    $0x4,%esp
  803c14:	68 3c 4d 80 00       	push   $0x804d3c
  803c19:	68 06 02 00 00       	push   $0x206
  803c1e:	68 21 4d 80 00       	push   $0x804d21
  803c23:	e8 cd 04 00 00       	call   8040f5 <_panic>
  803c28:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803c2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c31:	89 10                	mov    %edx,(%eax)
  803c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c36:	8b 00                	mov    (%eax),%eax
  803c38:	85 c0                	test   %eax,%eax
  803c3a:	74 0d                	je     803c49 <realloc_block_FF+0x2a9>
  803c3c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c44:	89 50 04             	mov    %edx,0x4(%eax)
  803c47:	eb 08                	jmp    803c51 <realloc_block_FF+0x2b1>
  803c49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4c:	a3 30 50 80 00       	mov    %eax,0x805030
  803c51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c54:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c63:	a1 38 50 80 00       	mov    0x805038,%eax
  803c68:	40                   	inc    %eax
  803c69:	a3 38 50 80 00       	mov    %eax,0x805038
  803c6e:	e9 b0 01 00 00       	jmp    803e23 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c73:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c78:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c7b:	76 68                	jbe    803ce5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c81:	75 17                	jne    803c9a <realloc_block_FF+0x2fa>
  803c83:	83 ec 04             	sub    $0x4,%esp
  803c86:	68 3c 4d 80 00       	push   $0x804d3c
  803c8b:	68 0b 02 00 00       	push   $0x20b
  803c90:	68 21 4d 80 00       	push   $0x804d21
  803c95:	e8 5b 04 00 00       	call   8040f5 <_panic>
  803c9a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803ca0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca3:	89 10                	mov    %edx,(%eax)
  803ca5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca8:	8b 00                	mov    (%eax),%eax
  803caa:	85 c0                	test   %eax,%eax
  803cac:	74 0d                	je     803cbb <realloc_block_FF+0x31b>
  803cae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803cb3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb6:	89 50 04             	mov    %edx,0x4(%eax)
  803cb9:	eb 08                	jmp    803cc3 <realloc_block_FF+0x323>
  803cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbe:	a3 30 50 80 00       	mov    %eax,0x805030
  803cc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ccb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cd5:	a1 38 50 80 00       	mov    0x805038,%eax
  803cda:	40                   	inc    %eax
  803cdb:	a3 38 50 80 00       	mov    %eax,0x805038
  803ce0:	e9 3e 01 00 00       	jmp    803e23 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803ce5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803cea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ced:	73 68                	jae    803d57 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cf3:	75 17                	jne    803d0c <realloc_block_FF+0x36c>
  803cf5:	83 ec 04             	sub    $0x4,%esp
  803cf8:	68 70 4d 80 00       	push   $0x804d70
  803cfd:	68 10 02 00 00       	push   $0x210
  803d02:	68 21 4d 80 00       	push   $0x804d21
  803d07:	e8 e9 03 00 00       	call   8040f5 <_panic>
  803d0c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803d12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d15:	89 50 04             	mov    %edx,0x4(%eax)
  803d18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d1b:	8b 40 04             	mov    0x4(%eax),%eax
  803d1e:	85 c0                	test   %eax,%eax
  803d20:	74 0c                	je     803d2e <realloc_block_FF+0x38e>
  803d22:	a1 30 50 80 00       	mov    0x805030,%eax
  803d27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d2a:	89 10                	mov    %edx,(%eax)
  803d2c:	eb 08                	jmp    803d36 <realloc_block_FF+0x396>
  803d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d39:	a3 30 50 80 00       	mov    %eax,0x805030
  803d3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d47:	a1 38 50 80 00       	mov    0x805038,%eax
  803d4c:	40                   	inc    %eax
  803d4d:	a3 38 50 80 00       	mov    %eax,0x805038
  803d52:	e9 cc 00 00 00       	jmp    803e23 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d5e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d66:	e9 8a 00 00 00       	jmp    803df5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d71:	73 7a                	jae    803ded <realloc_block_FF+0x44d>
  803d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d76:	8b 00                	mov    (%eax),%eax
  803d78:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d7b:	73 70                	jae    803ded <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d81:	74 06                	je     803d89 <realloc_block_FF+0x3e9>
  803d83:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d87:	75 17                	jne    803da0 <realloc_block_FF+0x400>
  803d89:	83 ec 04             	sub    $0x4,%esp
  803d8c:	68 94 4d 80 00       	push   $0x804d94
  803d91:	68 1a 02 00 00       	push   $0x21a
  803d96:	68 21 4d 80 00       	push   $0x804d21
  803d9b:	e8 55 03 00 00       	call   8040f5 <_panic>
  803da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da3:	8b 10                	mov    (%eax),%edx
  803da5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da8:	89 10                	mov    %edx,(%eax)
  803daa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dad:	8b 00                	mov    (%eax),%eax
  803daf:	85 c0                	test   %eax,%eax
  803db1:	74 0b                	je     803dbe <realloc_block_FF+0x41e>
  803db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db6:	8b 00                	mov    (%eax),%eax
  803db8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dbb:	89 50 04             	mov    %edx,0x4(%eax)
  803dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dc4:	89 10                	mov    %edx,(%eax)
  803dc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dcc:	89 50 04             	mov    %edx,0x4(%eax)
  803dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd2:	8b 00                	mov    (%eax),%eax
  803dd4:	85 c0                	test   %eax,%eax
  803dd6:	75 08                	jne    803de0 <realloc_block_FF+0x440>
  803dd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ddb:	a3 30 50 80 00       	mov    %eax,0x805030
  803de0:	a1 38 50 80 00       	mov    0x805038,%eax
  803de5:	40                   	inc    %eax
  803de6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803deb:	eb 36                	jmp    803e23 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ded:	a1 34 50 80 00       	mov    0x805034,%eax
  803df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803df9:	74 07                	je     803e02 <realloc_block_FF+0x462>
  803dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfe:	8b 00                	mov    (%eax),%eax
  803e00:	eb 05                	jmp    803e07 <realloc_block_FF+0x467>
  803e02:	b8 00 00 00 00       	mov    $0x0,%eax
  803e07:	a3 34 50 80 00       	mov    %eax,0x805034
  803e0c:	a1 34 50 80 00       	mov    0x805034,%eax
  803e11:	85 c0                	test   %eax,%eax
  803e13:	0f 85 52 ff ff ff    	jne    803d6b <realloc_block_FF+0x3cb>
  803e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e1d:	0f 85 48 ff ff ff    	jne    803d6b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e23:	83 ec 04             	sub    $0x4,%esp
  803e26:	6a 00                	push   $0x0
  803e28:	ff 75 d8             	pushl  -0x28(%ebp)
  803e2b:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e2e:	e8 7a eb ff ff       	call   8029ad <set_block_data>
  803e33:	83 c4 10             	add    $0x10,%esp
				return va;
  803e36:	8b 45 08             	mov    0x8(%ebp),%eax
  803e39:	e9 7b 02 00 00       	jmp    8040b9 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803e3e:	83 ec 0c             	sub    $0xc,%esp
  803e41:	68 11 4e 80 00       	push   $0x804e11
  803e46:	e8 d6 cd ff ff       	call   800c21 <cprintf>
  803e4b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e51:	e9 63 02 00 00       	jmp    8040b9 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e59:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e5c:	0f 86 4d 02 00 00    	jbe    8040af <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803e62:	83 ec 0c             	sub    $0xc,%esp
  803e65:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e68:	e8 08 e8 ff ff       	call   802675 <is_free_block>
  803e6d:	83 c4 10             	add    $0x10,%esp
  803e70:	84 c0                	test   %al,%al
  803e72:	0f 84 37 02 00 00    	je     8040af <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e7b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e84:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e87:	76 38                	jbe    803ec1 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e89:	83 ec 0c             	sub    $0xc,%esp
  803e8c:	ff 75 08             	pushl  0x8(%ebp)
  803e8f:	e8 0c fa ff ff       	call   8038a0 <free_block>
  803e94:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e97:	83 ec 0c             	sub    $0xc,%esp
  803e9a:	ff 75 0c             	pushl  0xc(%ebp)
  803e9d:	e8 3a eb ff ff       	call   8029dc <alloc_block_FF>
  803ea2:	83 c4 10             	add    $0x10,%esp
  803ea5:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803ea8:	83 ec 08             	sub    $0x8,%esp
  803eab:	ff 75 c0             	pushl  -0x40(%ebp)
  803eae:	ff 75 08             	pushl  0x8(%ebp)
  803eb1:	e8 ab fa ff ff       	call   803961 <copy_data>
  803eb6:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803eb9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ebc:	e9 f8 01 00 00       	jmp    8040b9 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ec4:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ec7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803eca:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ece:	0f 87 a0 00 00 00    	ja     803f74 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ed4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ed8:	75 17                	jne    803ef1 <realloc_block_FF+0x551>
  803eda:	83 ec 04             	sub    $0x4,%esp
  803edd:	68 03 4d 80 00       	push   $0x804d03
  803ee2:	68 38 02 00 00       	push   $0x238
  803ee7:	68 21 4d 80 00       	push   $0x804d21
  803eec:	e8 04 02 00 00       	call   8040f5 <_panic>
  803ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef4:	8b 00                	mov    (%eax),%eax
  803ef6:	85 c0                	test   %eax,%eax
  803ef8:	74 10                	je     803f0a <realloc_block_FF+0x56a>
  803efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efd:	8b 00                	mov    (%eax),%eax
  803eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f02:	8b 52 04             	mov    0x4(%edx),%edx
  803f05:	89 50 04             	mov    %edx,0x4(%eax)
  803f08:	eb 0b                	jmp    803f15 <realloc_block_FF+0x575>
  803f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0d:	8b 40 04             	mov    0x4(%eax),%eax
  803f10:	a3 30 50 80 00       	mov    %eax,0x805030
  803f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f18:	8b 40 04             	mov    0x4(%eax),%eax
  803f1b:	85 c0                	test   %eax,%eax
  803f1d:	74 0f                	je     803f2e <realloc_block_FF+0x58e>
  803f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f22:	8b 40 04             	mov    0x4(%eax),%eax
  803f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f28:	8b 12                	mov    (%edx),%edx
  803f2a:	89 10                	mov    %edx,(%eax)
  803f2c:	eb 0a                	jmp    803f38 <realloc_block_FF+0x598>
  803f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f31:	8b 00                	mov    (%eax),%eax
  803f33:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f4b:	a1 38 50 80 00       	mov    0x805038,%eax
  803f50:	48                   	dec    %eax
  803f51:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f5c:	01 d0                	add    %edx,%eax
  803f5e:	83 ec 04             	sub    $0x4,%esp
  803f61:	6a 01                	push   $0x1
  803f63:	50                   	push   %eax
  803f64:	ff 75 08             	pushl  0x8(%ebp)
  803f67:	e8 41 ea ff ff       	call   8029ad <set_block_data>
  803f6c:	83 c4 10             	add    $0x10,%esp
  803f6f:	e9 36 01 00 00       	jmp    8040aa <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f7a:	01 d0                	add    %edx,%eax
  803f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f7f:	83 ec 04             	sub    $0x4,%esp
  803f82:	6a 01                	push   $0x1
  803f84:	ff 75 f0             	pushl  -0x10(%ebp)
  803f87:	ff 75 08             	pushl  0x8(%ebp)
  803f8a:	e8 1e ea ff ff       	call   8029ad <set_block_data>
  803f8f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f92:	8b 45 08             	mov    0x8(%ebp),%eax
  803f95:	83 e8 04             	sub    $0x4,%eax
  803f98:	8b 00                	mov    (%eax),%eax
  803f9a:	83 e0 fe             	and    $0xfffffffe,%eax
  803f9d:	89 c2                	mov    %eax,%edx
  803f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa2:	01 d0                	add    %edx,%eax
  803fa4:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803fa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fab:	74 06                	je     803fb3 <realloc_block_FF+0x613>
  803fad:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803fb1:	75 17                	jne    803fca <realloc_block_FF+0x62a>
  803fb3:	83 ec 04             	sub    $0x4,%esp
  803fb6:	68 94 4d 80 00       	push   $0x804d94
  803fbb:	68 44 02 00 00       	push   $0x244
  803fc0:	68 21 4d 80 00       	push   $0x804d21
  803fc5:	e8 2b 01 00 00       	call   8040f5 <_panic>
  803fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcd:	8b 10                	mov    (%eax),%edx
  803fcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fd2:	89 10                	mov    %edx,(%eax)
  803fd4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fd7:	8b 00                	mov    (%eax),%eax
  803fd9:	85 c0                	test   %eax,%eax
  803fdb:	74 0b                	je     803fe8 <realloc_block_FF+0x648>
  803fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe0:	8b 00                	mov    (%eax),%eax
  803fe2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fe5:	89 50 04             	mov    %edx,0x4(%eax)
  803fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803feb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fee:	89 10                	mov    %edx,(%eax)
  803ff0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ff3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff6:	89 50 04             	mov    %edx,0x4(%eax)
  803ff9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ffc:	8b 00                	mov    (%eax),%eax
  803ffe:	85 c0                	test   %eax,%eax
  804000:	75 08                	jne    80400a <realloc_block_FF+0x66a>
  804002:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804005:	a3 30 50 80 00       	mov    %eax,0x805030
  80400a:	a1 38 50 80 00       	mov    0x805038,%eax
  80400f:	40                   	inc    %eax
  804010:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804015:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804019:	75 17                	jne    804032 <realloc_block_FF+0x692>
  80401b:	83 ec 04             	sub    $0x4,%esp
  80401e:	68 03 4d 80 00       	push   $0x804d03
  804023:	68 45 02 00 00       	push   $0x245
  804028:	68 21 4d 80 00       	push   $0x804d21
  80402d:	e8 c3 00 00 00       	call   8040f5 <_panic>
  804032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804035:	8b 00                	mov    (%eax),%eax
  804037:	85 c0                	test   %eax,%eax
  804039:	74 10                	je     80404b <realloc_block_FF+0x6ab>
  80403b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403e:	8b 00                	mov    (%eax),%eax
  804040:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804043:	8b 52 04             	mov    0x4(%edx),%edx
  804046:	89 50 04             	mov    %edx,0x4(%eax)
  804049:	eb 0b                	jmp    804056 <realloc_block_FF+0x6b6>
  80404b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404e:	8b 40 04             	mov    0x4(%eax),%eax
  804051:	a3 30 50 80 00       	mov    %eax,0x805030
  804056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804059:	8b 40 04             	mov    0x4(%eax),%eax
  80405c:	85 c0                	test   %eax,%eax
  80405e:	74 0f                	je     80406f <realloc_block_FF+0x6cf>
  804060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804063:	8b 40 04             	mov    0x4(%eax),%eax
  804066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804069:	8b 12                	mov    (%edx),%edx
  80406b:	89 10                	mov    %edx,(%eax)
  80406d:	eb 0a                	jmp    804079 <realloc_block_FF+0x6d9>
  80406f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804072:	8b 00                	mov    (%eax),%eax
  804074:	a3 2c 50 80 00       	mov    %eax,0x80502c
  804079:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804082:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804085:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80408c:	a1 38 50 80 00       	mov    0x805038,%eax
  804091:	48                   	dec    %eax
  804092:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  804097:	83 ec 04             	sub    $0x4,%esp
  80409a:	6a 00                	push   $0x0
  80409c:	ff 75 bc             	pushl  -0x44(%ebp)
  80409f:	ff 75 b8             	pushl  -0x48(%ebp)
  8040a2:	e8 06 e9 ff ff       	call   8029ad <set_block_data>
  8040a7:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8040aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ad:	eb 0a                	jmp    8040b9 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8040af:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8040b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8040b9:	c9                   	leave  
  8040ba:	c3                   	ret    

008040bb <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040bb:	55                   	push   %ebp
  8040bc:	89 e5                	mov    %esp,%ebp
  8040be:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040c1:	83 ec 04             	sub    $0x4,%esp
  8040c4:	68 18 4e 80 00       	push   $0x804e18
  8040c9:	68 58 02 00 00       	push   $0x258
  8040ce:	68 21 4d 80 00       	push   $0x804d21
  8040d3:	e8 1d 00 00 00       	call   8040f5 <_panic>

008040d8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040d8:	55                   	push   %ebp
  8040d9:	89 e5                	mov    %esp,%ebp
  8040db:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040de:	83 ec 04             	sub    $0x4,%esp
  8040e1:	68 40 4e 80 00       	push   $0x804e40
  8040e6:	68 61 02 00 00       	push   $0x261
  8040eb:	68 21 4d 80 00       	push   $0x804d21
  8040f0:	e8 00 00 00 00       	call   8040f5 <_panic>

008040f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8040f5:	55                   	push   %ebp
  8040f6:	89 e5                	mov    %esp,%ebp
  8040f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8040fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8040fe:	83 c0 04             	add    $0x4,%eax
  804101:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804104:	a1 60 50 90 00       	mov    0x905060,%eax
  804109:	85 c0                	test   %eax,%eax
  80410b:	74 16                	je     804123 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80410d:	a1 60 50 90 00       	mov    0x905060,%eax
  804112:	83 ec 08             	sub    $0x8,%esp
  804115:	50                   	push   %eax
  804116:	68 68 4e 80 00       	push   $0x804e68
  80411b:	e8 01 cb ff ff       	call   800c21 <cprintf>
  804120:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  804123:	a1 00 50 80 00       	mov    0x805000,%eax
  804128:	ff 75 0c             	pushl  0xc(%ebp)
  80412b:	ff 75 08             	pushl  0x8(%ebp)
  80412e:	50                   	push   %eax
  80412f:	68 6d 4e 80 00       	push   $0x804e6d
  804134:	e8 e8 ca ff ff       	call   800c21 <cprintf>
  804139:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80413c:	8b 45 10             	mov    0x10(%ebp),%eax
  80413f:	83 ec 08             	sub    $0x8,%esp
  804142:	ff 75 f4             	pushl  -0xc(%ebp)
  804145:	50                   	push   %eax
  804146:	e8 6b ca ff ff       	call   800bb6 <vcprintf>
  80414b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80414e:	83 ec 08             	sub    $0x8,%esp
  804151:	6a 00                	push   $0x0
  804153:	68 89 4e 80 00       	push   $0x804e89
  804158:	e8 59 ca ff ff       	call   800bb6 <vcprintf>
  80415d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  804160:	e8 da c9 ff ff       	call   800b3f <exit>

	// should not return here
	while (1) ;
  804165:	eb fe                	jmp    804165 <_panic+0x70>

00804167 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  804167:	55                   	push   %ebp
  804168:	89 e5                	mov    %esp,%ebp
  80416a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80416d:	a1 20 50 80 00       	mov    0x805020,%eax
  804172:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80417b:	39 c2                	cmp    %eax,%edx
  80417d:	74 14                	je     804193 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80417f:	83 ec 04             	sub    $0x4,%esp
  804182:	68 8c 4e 80 00       	push   $0x804e8c
  804187:	6a 26                	push   $0x26
  804189:	68 d8 4e 80 00       	push   $0x804ed8
  80418e:	e8 62 ff ff ff       	call   8040f5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80419a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8041a1:	e9 c5 00 00 00       	jmp    80426b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8041a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8041b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b3:	01 d0                	add    %edx,%eax
  8041b5:	8b 00                	mov    (%eax),%eax
  8041b7:	85 c0                	test   %eax,%eax
  8041b9:	75 08                	jne    8041c3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8041bb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8041be:	e9 a5 00 00 00       	jmp    804268 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8041c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8041ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8041d1:	eb 69                	jmp    80423c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8041d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8041d8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8041de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041e1:	89 d0                	mov    %edx,%eax
  8041e3:	01 c0                	add    %eax,%eax
  8041e5:	01 d0                	add    %edx,%eax
  8041e7:	c1 e0 03             	shl    $0x3,%eax
  8041ea:	01 c8                	add    %ecx,%eax
  8041ec:	8a 40 04             	mov    0x4(%eax),%al
  8041ef:	84 c0                	test   %al,%al
  8041f1:	75 46                	jne    804239 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8041f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8041f8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8041fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804201:	89 d0                	mov    %edx,%eax
  804203:	01 c0                	add    %eax,%eax
  804205:	01 d0                	add    %edx,%eax
  804207:	c1 e0 03             	shl    $0x3,%eax
  80420a:	01 c8                	add    %ecx,%eax
  80420c:	8b 00                	mov    (%eax),%eax
  80420e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804211:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804214:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804219:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80421b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80421e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  804225:	8b 45 08             	mov    0x8(%ebp),%eax
  804228:	01 c8                	add    %ecx,%eax
  80422a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80422c:	39 c2                	cmp    %eax,%edx
  80422e:	75 09                	jne    804239 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804230:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  804237:	eb 15                	jmp    80424e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804239:	ff 45 e8             	incl   -0x18(%ebp)
  80423c:	a1 20 50 80 00       	mov    0x805020,%eax
  804241:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80424a:	39 c2                	cmp    %eax,%edx
  80424c:	77 85                	ja     8041d3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80424e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804252:	75 14                	jne    804268 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  804254:	83 ec 04             	sub    $0x4,%esp
  804257:	68 e4 4e 80 00       	push   $0x804ee4
  80425c:	6a 3a                	push   $0x3a
  80425e:	68 d8 4e 80 00       	push   $0x804ed8
  804263:	e8 8d fe ff ff       	call   8040f5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  804268:	ff 45 f0             	incl   -0x10(%ebp)
  80426b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80426e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804271:	0f 8c 2f ff ff ff    	jl     8041a6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  804277:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80427e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804285:	eb 26                	jmp    8042ad <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  804287:	a1 20 50 80 00       	mov    0x805020,%eax
  80428c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  804292:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804295:	89 d0                	mov    %edx,%eax
  804297:	01 c0                	add    %eax,%eax
  804299:	01 d0                	add    %edx,%eax
  80429b:	c1 e0 03             	shl    $0x3,%eax
  80429e:	01 c8                	add    %ecx,%eax
  8042a0:	8a 40 04             	mov    0x4(%eax),%al
  8042a3:	3c 01                	cmp    $0x1,%al
  8042a5:	75 03                	jne    8042aa <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8042a7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042aa:	ff 45 e0             	incl   -0x20(%ebp)
  8042ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8042b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8042b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042bb:	39 c2                	cmp    %eax,%edx
  8042bd:	77 c8                	ja     804287 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8042bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8042c5:	74 14                	je     8042db <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8042c7:	83 ec 04             	sub    $0x4,%esp
  8042ca:	68 38 4f 80 00       	push   $0x804f38
  8042cf:	6a 44                	push   $0x44
  8042d1:	68 d8 4e 80 00       	push   $0x804ed8
  8042d6:	e8 1a fe ff ff       	call   8040f5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8042db:	90                   	nop
  8042dc:	c9                   	leave  
  8042dd:	c3                   	ret    
  8042de:	66 90                	xchg   %ax,%ax

008042e0 <__udivdi3>:
  8042e0:	55                   	push   %ebp
  8042e1:	57                   	push   %edi
  8042e2:	56                   	push   %esi
  8042e3:	53                   	push   %ebx
  8042e4:	83 ec 1c             	sub    $0x1c,%esp
  8042e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042f7:	89 ca                	mov    %ecx,%edx
  8042f9:	89 f8                	mov    %edi,%eax
  8042fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042ff:	85 f6                	test   %esi,%esi
  804301:	75 2d                	jne    804330 <__udivdi3+0x50>
  804303:	39 cf                	cmp    %ecx,%edi
  804305:	77 65                	ja     80436c <__udivdi3+0x8c>
  804307:	89 fd                	mov    %edi,%ebp
  804309:	85 ff                	test   %edi,%edi
  80430b:	75 0b                	jne    804318 <__udivdi3+0x38>
  80430d:	b8 01 00 00 00       	mov    $0x1,%eax
  804312:	31 d2                	xor    %edx,%edx
  804314:	f7 f7                	div    %edi
  804316:	89 c5                	mov    %eax,%ebp
  804318:	31 d2                	xor    %edx,%edx
  80431a:	89 c8                	mov    %ecx,%eax
  80431c:	f7 f5                	div    %ebp
  80431e:	89 c1                	mov    %eax,%ecx
  804320:	89 d8                	mov    %ebx,%eax
  804322:	f7 f5                	div    %ebp
  804324:	89 cf                	mov    %ecx,%edi
  804326:	89 fa                	mov    %edi,%edx
  804328:	83 c4 1c             	add    $0x1c,%esp
  80432b:	5b                   	pop    %ebx
  80432c:	5e                   	pop    %esi
  80432d:	5f                   	pop    %edi
  80432e:	5d                   	pop    %ebp
  80432f:	c3                   	ret    
  804330:	39 ce                	cmp    %ecx,%esi
  804332:	77 28                	ja     80435c <__udivdi3+0x7c>
  804334:	0f bd fe             	bsr    %esi,%edi
  804337:	83 f7 1f             	xor    $0x1f,%edi
  80433a:	75 40                	jne    80437c <__udivdi3+0x9c>
  80433c:	39 ce                	cmp    %ecx,%esi
  80433e:	72 0a                	jb     80434a <__udivdi3+0x6a>
  804340:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804344:	0f 87 9e 00 00 00    	ja     8043e8 <__udivdi3+0x108>
  80434a:	b8 01 00 00 00       	mov    $0x1,%eax
  80434f:	89 fa                	mov    %edi,%edx
  804351:	83 c4 1c             	add    $0x1c,%esp
  804354:	5b                   	pop    %ebx
  804355:	5e                   	pop    %esi
  804356:	5f                   	pop    %edi
  804357:	5d                   	pop    %ebp
  804358:	c3                   	ret    
  804359:	8d 76 00             	lea    0x0(%esi),%esi
  80435c:	31 ff                	xor    %edi,%edi
  80435e:	31 c0                	xor    %eax,%eax
  804360:	89 fa                	mov    %edi,%edx
  804362:	83 c4 1c             	add    $0x1c,%esp
  804365:	5b                   	pop    %ebx
  804366:	5e                   	pop    %esi
  804367:	5f                   	pop    %edi
  804368:	5d                   	pop    %ebp
  804369:	c3                   	ret    
  80436a:	66 90                	xchg   %ax,%ax
  80436c:	89 d8                	mov    %ebx,%eax
  80436e:	f7 f7                	div    %edi
  804370:	31 ff                	xor    %edi,%edi
  804372:	89 fa                	mov    %edi,%edx
  804374:	83 c4 1c             	add    $0x1c,%esp
  804377:	5b                   	pop    %ebx
  804378:	5e                   	pop    %esi
  804379:	5f                   	pop    %edi
  80437a:	5d                   	pop    %ebp
  80437b:	c3                   	ret    
  80437c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804381:	89 eb                	mov    %ebp,%ebx
  804383:	29 fb                	sub    %edi,%ebx
  804385:	89 f9                	mov    %edi,%ecx
  804387:	d3 e6                	shl    %cl,%esi
  804389:	89 c5                	mov    %eax,%ebp
  80438b:	88 d9                	mov    %bl,%cl
  80438d:	d3 ed                	shr    %cl,%ebp
  80438f:	89 e9                	mov    %ebp,%ecx
  804391:	09 f1                	or     %esi,%ecx
  804393:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804397:	89 f9                	mov    %edi,%ecx
  804399:	d3 e0                	shl    %cl,%eax
  80439b:	89 c5                	mov    %eax,%ebp
  80439d:	89 d6                	mov    %edx,%esi
  80439f:	88 d9                	mov    %bl,%cl
  8043a1:	d3 ee                	shr    %cl,%esi
  8043a3:	89 f9                	mov    %edi,%ecx
  8043a5:	d3 e2                	shl    %cl,%edx
  8043a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043ab:	88 d9                	mov    %bl,%cl
  8043ad:	d3 e8                	shr    %cl,%eax
  8043af:	09 c2                	or     %eax,%edx
  8043b1:	89 d0                	mov    %edx,%eax
  8043b3:	89 f2                	mov    %esi,%edx
  8043b5:	f7 74 24 0c          	divl   0xc(%esp)
  8043b9:	89 d6                	mov    %edx,%esi
  8043bb:	89 c3                	mov    %eax,%ebx
  8043bd:	f7 e5                	mul    %ebp
  8043bf:	39 d6                	cmp    %edx,%esi
  8043c1:	72 19                	jb     8043dc <__udivdi3+0xfc>
  8043c3:	74 0b                	je     8043d0 <__udivdi3+0xf0>
  8043c5:	89 d8                	mov    %ebx,%eax
  8043c7:	31 ff                	xor    %edi,%edi
  8043c9:	e9 58 ff ff ff       	jmp    804326 <__udivdi3+0x46>
  8043ce:	66 90                	xchg   %ax,%ax
  8043d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043d4:	89 f9                	mov    %edi,%ecx
  8043d6:	d3 e2                	shl    %cl,%edx
  8043d8:	39 c2                	cmp    %eax,%edx
  8043da:	73 e9                	jae    8043c5 <__udivdi3+0xe5>
  8043dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8043df:	31 ff                	xor    %edi,%edi
  8043e1:	e9 40 ff ff ff       	jmp    804326 <__udivdi3+0x46>
  8043e6:	66 90                	xchg   %ax,%ax
  8043e8:	31 c0                	xor    %eax,%eax
  8043ea:	e9 37 ff ff ff       	jmp    804326 <__udivdi3+0x46>
  8043ef:	90                   	nop

008043f0 <__umoddi3>:
  8043f0:	55                   	push   %ebp
  8043f1:	57                   	push   %edi
  8043f2:	56                   	push   %esi
  8043f3:	53                   	push   %ebx
  8043f4:	83 ec 1c             	sub    $0x1c,%esp
  8043f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804403:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804407:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80440b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80440f:	89 f3                	mov    %esi,%ebx
  804411:	89 fa                	mov    %edi,%edx
  804413:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804417:	89 34 24             	mov    %esi,(%esp)
  80441a:	85 c0                	test   %eax,%eax
  80441c:	75 1a                	jne    804438 <__umoddi3+0x48>
  80441e:	39 f7                	cmp    %esi,%edi
  804420:	0f 86 a2 00 00 00    	jbe    8044c8 <__umoddi3+0xd8>
  804426:	89 c8                	mov    %ecx,%eax
  804428:	89 f2                	mov    %esi,%edx
  80442a:	f7 f7                	div    %edi
  80442c:	89 d0                	mov    %edx,%eax
  80442e:	31 d2                	xor    %edx,%edx
  804430:	83 c4 1c             	add    $0x1c,%esp
  804433:	5b                   	pop    %ebx
  804434:	5e                   	pop    %esi
  804435:	5f                   	pop    %edi
  804436:	5d                   	pop    %ebp
  804437:	c3                   	ret    
  804438:	39 f0                	cmp    %esi,%eax
  80443a:	0f 87 ac 00 00 00    	ja     8044ec <__umoddi3+0xfc>
  804440:	0f bd e8             	bsr    %eax,%ebp
  804443:	83 f5 1f             	xor    $0x1f,%ebp
  804446:	0f 84 ac 00 00 00    	je     8044f8 <__umoddi3+0x108>
  80444c:	bf 20 00 00 00       	mov    $0x20,%edi
  804451:	29 ef                	sub    %ebp,%edi
  804453:	89 fe                	mov    %edi,%esi
  804455:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804459:	89 e9                	mov    %ebp,%ecx
  80445b:	d3 e0                	shl    %cl,%eax
  80445d:	89 d7                	mov    %edx,%edi
  80445f:	89 f1                	mov    %esi,%ecx
  804461:	d3 ef                	shr    %cl,%edi
  804463:	09 c7                	or     %eax,%edi
  804465:	89 e9                	mov    %ebp,%ecx
  804467:	d3 e2                	shl    %cl,%edx
  804469:	89 14 24             	mov    %edx,(%esp)
  80446c:	89 d8                	mov    %ebx,%eax
  80446e:	d3 e0                	shl    %cl,%eax
  804470:	89 c2                	mov    %eax,%edx
  804472:	8b 44 24 08          	mov    0x8(%esp),%eax
  804476:	d3 e0                	shl    %cl,%eax
  804478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80447c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804480:	89 f1                	mov    %esi,%ecx
  804482:	d3 e8                	shr    %cl,%eax
  804484:	09 d0                	or     %edx,%eax
  804486:	d3 eb                	shr    %cl,%ebx
  804488:	89 da                	mov    %ebx,%edx
  80448a:	f7 f7                	div    %edi
  80448c:	89 d3                	mov    %edx,%ebx
  80448e:	f7 24 24             	mull   (%esp)
  804491:	89 c6                	mov    %eax,%esi
  804493:	89 d1                	mov    %edx,%ecx
  804495:	39 d3                	cmp    %edx,%ebx
  804497:	0f 82 87 00 00 00    	jb     804524 <__umoddi3+0x134>
  80449d:	0f 84 91 00 00 00    	je     804534 <__umoddi3+0x144>
  8044a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8044a7:	29 f2                	sub    %esi,%edx
  8044a9:	19 cb                	sbb    %ecx,%ebx
  8044ab:	89 d8                	mov    %ebx,%eax
  8044ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8044b1:	d3 e0                	shl    %cl,%eax
  8044b3:	89 e9                	mov    %ebp,%ecx
  8044b5:	d3 ea                	shr    %cl,%edx
  8044b7:	09 d0                	or     %edx,%eax
  8044b9:	89 e9                	mov    %ebp,%ecx
  8044bb:	d3 eb                	shr    %cl,%ebx
  8044bd:	89 da                	mov    %ebx,%edx
  8044bf:	83 c4 1c             	add    $0x1c,%esp
  8044c2:	5b                   	pop    %ebx
  8044c3:	5e                   	pop    %esi
  8044c4:	5f                   	pop    %edi
  8044c5:	5d                   	pop    %ebp
  8044c6:	c3                   	ret    
  8044c7:	90                   	nop
  8044c8:	89 fd                	mov    %edi,%ebp
  8044ca:	85 ff                	test   %edi,%edi
  8044cc:	75 0b                	jne    8044d9 <__umoddi3+0xe9>
  8044ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8044d3:	31 d2                	xor    %edx,%edx
  8044d5:	f7 f7                	div    %edi
  8044d7:	89 c5                	mov    %eax,%ebp
  8044d9:	89 f0                	mov    %esi,%eax
  8044db:	31 d2                	xor    %edx,%edx
  8044dd:	f7 f5                	div    %ebp
  8044df:	89 c8                	mov    %ecx,%eax
  8044e1:	f7 f5                	div    %ebp
  8044e3:	89 d0                	mov    %edx,%eax
  8044e5:	e9 44 ff ff ff       	jmp    80442e <__umoddi3+0x3e>
  8044ea:	66 90                	xchg   %ax,%ax
  8044ec:	89 c8                	mov    %ecx,%eax
  8044ee:	89 f2                	mov    %esi,%edx
  8044f0:	83 c4 1c             	add    $0x1c,%esp
  8044f3:	5b                   	pop    %ebx
  8044f4:	5e                   	pop    %esi
  8044f5:	5f                   	pop    %edi
  8044f6:	5d                   	pop    %ebp
  8044f7:	c3                   	ret    
  8044f8:	3b 04 24             	cmp    (%esp),%eax
  8044fb:	72 06                	jb     804503 <__umoddi3+0x113>
  8044fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804501:	77 0f                	ja     804512 <__umoddi3+0x122>
  804503:	89 f2                	mov    %esi,%edx
  804505:	29 f9                	sub    %edi,%ecx
  804507:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80450b:	89 14 24             	mov    %edx,(%esp)
  80450e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804512:	8b 44 24 04          	mov    0x4(%esp),%eax
  804516:	8b 14 24             	mov    (%esp),%edx
  804519:	83 c4 1c             	add    $0x1c,%esp
  80451c:	5b                   	pop    %ebx
  80451d:	5e                   	pop    %esi
  80451e:	5f                   	pop    %edi
  80451f:	5d                   	pop    %ebp
  804520:	c3                   	ret    
  804521:	8d 76 00             	lea    0x0(%esi),%esi
  804524:	2b 04 24             	sub    (%esp),%eax
  804527:	19 fa                	sbb    %edi,%edx
  804529:	89 d1                	mov    %edx,%ecx
  80452b:	89 c6                	mov    %eax,%esi
  80452d:	e9 71 ff ff ff       	jmp    8044a3 <__umoddi3+0xb3>
  804532:	66 90                	xchg   %ax,%ax
  804534:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804538:	72 ea                	jb     804524 <__umoddi3+0x134>
  80453a:	89 d9                	mov    %ebx,%ecx
  80453c:	e9 62 ff ff ff       	jmp    8044a3 <__umoddi3+0xb3>
