
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void MatrixMultiply(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 58 1a 00 00       	call   801a9b <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 82 1a 00 00       	call   801acd <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e0 3c 80 00       	push   $0x803ce0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 49 16 00 00       	call   8016b5 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 3c 80 00       	push   $0x803ce4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 33 16 00 00       	call   8016b5 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 3c 80 00       	push   $0x803cec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 16 16 00 00       	call   8016b5 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 fa 3c 80 00       	push   $0x803cfa
  8000b8:	e8 79 15 00 00       	call   801636 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	MatrixMultiply(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <MatrixMultiply>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 09 3d 80 00       	push   $0x803d09
  800117:	e8 4d 04 00 00       	call   800569 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <MatrixMultiply>:

///Quick sort
void MatrixMultiply(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 95 19 00 00       	call   801b00 <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 25 3d 80 00       	push   $0x803d25
  8002fb:	e8 69 02 00 00       	call   800569 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 27 3d 80 00       	push   $0x803d27
  80031d:	e8 47 02 00 00       	call   800569 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 2c 3d 80 00       	push   $0x803d2c
  80034b:	e8 19 02 00 00       	call   800569 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 53 17 00 00       	call   801ab4 <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800375:	01 c8                	add    %ecx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800382:	01 c8                	add    %ecx,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800390:	a1 20 50 80 00       	mov    0x805020,%eax
  800395:	8a 40 20             	mov    0x20(%eax),%al
  800398:	84 c0                	test   %al,%al
  80039a:	74 0d                	je     8003a9 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80039c:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a1:	83 c0 20             	add    $0x20,%eax
  8003a4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ad:	7e 0a                	jle    8003b9 <libmain+0x63>
		binaryname = argv[0];
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	ff 75 08             	pushl  0x8(%ebp)
  8003c2:	e8 71 fc ff ff       	call   800038 <_main>
  8003c7:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8003ca:	e8 69 14 00 00       	call   801838 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	68 48 3d 80 00       	push   $0x803d48
  8003d7:	e8 8d 01 00 00       	call   800569 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003df:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e4:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8003ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ef:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	52                   	push   %edx
  8003f9:	50                   	push   %eax
  8003fa:	68 70 3d 80 00       	push   $0x803d70
  8003ff:	e8 65 01 00 00       	call   800569 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800407:	a1 20 50 80 00       	mov    0x805020,%eax
  80040c:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800412:	a1 20 50 80 00       	mov    0x805020,%eax
  800417:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80041d:	a1 20 50 80 00       	mov    0x805020,%eax
  800422:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800428:	51                   	push   %ecx
  800429:	52                   	push   %edx
  80042a:	50                   	push   %eax
  80042b:	68 98 3d 80 00       	push   $0x803d98
  800430:	e8 34 01 00 00       	call   800569 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	50                   	push   %eax
  800447:	68 f0 3d 80 00       	push   $0x803df0
  80044c:	e8 18 01 00 00       	call   800569 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	68 48 3d 80 00       	push   $0x803d48
  80045c:	e8 08 01 00 00       	call   800569 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800464:	e8 e9 13 00 00       	call   801852 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800469:	e8 19 00 00 00       	call   800487 <exit>
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800477:	83 ec 0c             	sub    $0xc,%esp
  80047a:	6a 00                	push   $0x0
  80047c:	e8 ff 15 00 00       	call   801a80 <sys_destroy_env>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	90                   	nop
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <exit>:

void
exit(void)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048d:	e8 54 16 00 00       	call   801ae6 <sys_exit_env>
}
  800492:	90                   	nop
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	89 0a                	mov    %ecx,(%edx)
  8004a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ab:	88 d1                	mov    %dl,%cl
  8004ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004be:	75 2c                	jne    8004ec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c0:	a0 28 50 80 00       	mov    0x805028,%al
  8004c5:	0f b6 c0             	movzbl %al,%eax
  8004c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cb:	8b 12                	mov    (%edx),%edx
  8004cd:	89 d1                	mov    %edx,%ecx
  8004cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d2:	83 c2 08             	add    $0x8,%edx
  8004d5:	83 ec 04             	sub    $0x4,%esp
  8004d8:	50                   	push   %eax
  8004d9:	51                   	push   %ecx
  8004da:	52                   	push   %edx
  8004db:	e8 16 13 00 00       	call   8017f6 <sys_cputs>
  8004e0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	8b 40 04             	mov    0x4(%eax),%eax
  8004f2:	8d 50 01             	lea    0x1(%eax),%edx
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fb:	90                   	nop
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800507:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050e:	00 00 00 
	b.cnt = 0;
  800511:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800518:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	68 95 04 80 00       	push   $0x800495
  80052d:	e8 11 02 00 00       	call   800743 <vprintfmt>
  800532:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800535:	a0 28 50 80 00       	mov    0x805028,%al
  80053a:	0f b6 c0             	movzbl %al,%eax
  80053d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	50                   	push   %eax
  800547:	52                   	push   %edx
  800548:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054e:	83 c0 08             	add    $0x8,%eax
  800551:	50                   	push   %eax
  800552:	e8 9f 12 00 00       	call   8017f6 <sys_cputs>
  800557:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055a:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800561:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056f:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800576:	8d 45 0c             	lea    0xc(%ebp),%eax
  800579:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	ff 75 f4             	pushl  -0xc(%ebp)
  800585:	50                   	push   %eax
  800586:	e8 73 ff ff ff       	call   8004fe <vcprintf>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059c:	e8 97 12 00 00       	call   801838 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	e8 48 ff ff ff       	call   8004fe <vcprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bc:	e8 91 12 00 00       	call   801852 <sys_unlock_cons>
	return cnt;
  8005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 14             	sub    $0x14,%esp
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e4:	77 55                	ja     80063b <printnum+0x75>
  8005e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e9:	72 05                	jb     8005f0 <printnum+0x2a>
  8005eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ee:	77 4b                	ja     80063b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	52                   	push   %edx
  8005ff:	50                   	push   %eax
  800600:	ff 75 f4             	pushl  -0xc(%ebp)
  800603:	ff 75 f0             	pushl  -0x10(%ebp)
  800606:	e8 6d 34 00 00       	call   803a78 <__udivdi3>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	53                   	push   %ebx
  800615:	ff 75 18             	pushl  0x18(%ebp)
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	ff 75 08             	pushl  0x8(%ebp)
  800620:	e8 a1 ff ff ff       	call   8005c6 <printnum>
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	eb 1a                	jmp    800644 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 20             	pushl  0x20(%ebp)
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063b:	ff 4d 1c             	decl   0x1c(%ebp)
  80063e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800642:	7f e6                	jg     80062a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800652:	53                   	push   %ebx
  800653:	51                   	push   %ecx
  800654:	52                   	push   %edx
  800655:	50                   	push   %eax
  800656:	e8 2d 35 00 00       	call   803b88 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 34 40 80 00       	add    $0x804034,%eax
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f be c0             	movsbl %al,%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	50                   	push   %eax
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	ff d0                	call   *%eax
  800674:	83 c4 10             	add    $0x10,%esp
}
  800677:	90                   	nop
  800678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800680:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800684:	7e 1c                	jle    8006a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	8d 50 08             	lea    0x8(%eax),%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	89 10                	mov    %edx,(%eax)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	83 e8 08             	sub    $0x8,%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	eb 40                	jmp    8006e2 <getuint+0x65>
	else if (lflag)
  8006a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a6:	74 1e                	je     8006c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	eb 1c                	jmp    8006e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006eb:	7e 1c                	jle    800709 <getint+0x25>
		return va_arg(*ap, long long);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 08             	lea    0x8(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 08             	sub    $0x8,%eax
  800702:	8b 50 04             	mov    0x4(%eax),%edx
  800705:	8b 00                	mov    (%eax),%eax
  800707:	eb 38                	jmp    800741 <getint+0x5d>
	else if (lflag)
  800709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070d:	74 1a                	je     800729 <getint+0x45>
		return va_arg(*ap, long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	eb 18                	jmp    800741 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	89 10                	mov    %edx,(%eax)
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	99                   	cltd   
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	56                   	push   %esi
  800747:	53                   	push   %ebx
  800748:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074b:	eb 17                	jmp    800764 <vprintfmt+0x21>
			if (ch == '\0')
  80074d:	85 db                	test   %ebx,%ebx
  80074f:	0f 84 c1 03 00 00    	je     800b16 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	83 fb 25             	cmp    $0x25,%ebx
  800775:	75 d6                	jne    80074d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800777:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800782:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800789:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800790:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8d 50 01             	lea    0x1(%eax),%edx
  80079d:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f b6 d8             	movzbl %al,%ebx
  8007a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a8:	83 f8 5b             	cmp    $0x5b,%eax
  8007ab:	0f 87 3d 03 00 00    	ja     800aee <vprintfmt+0x3ab>
  8007b1:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
  8007b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007be:	eb d7                	jmp    800797 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c4:	eb d1                	jmp    800797 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d0:	89 d0                	mov    %edx,%eax
  8007d2:	c1 e0 02             	shl    $0x2,%eax
  8007d5:	01 d0                	add    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d8                	add    %ebx,%eax
  8007db:	83 e8 30             	sub    $0x30,%eax
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	8a 00                	mov    (%eax),%al
  8007e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ec:	7e 3e                	jle    80082c <vprintfmt+0xe9>
  8007ee:	83 fb 39             	cmp    $0x39,%ebx
  8007f1:	7f 39                	jg     80082c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f6:	eb d5                	jmp    8007cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080c:	eb 1f                	jmp    80082d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	79 83                	jns    800797 <vprintfmt+0x54>
				width = 0;
  800814:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081b:	e9 77 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800820:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800827:	e9 6b ff ff ff       	jmp    800797 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800831:	0f 89 60 ff ff ff    	jns    800797 <vprintfmt+0x54>
				width = precision, precision = -1;
  800837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800844:	e9 4e ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084c:	e9 46 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	e9 9b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800887:	85 db                	test   %ebx,%ebx
  800889:	79 02                	jns    80088d <vprintfmt+0x14a>
				err = -err;
  80088b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088d:	83 fb 64             	cmp    $0x64,%ebx
  800890:	7f 0b                	jg     80089d <vprintfmt+0x15a>
  800892:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 45 40 80 00       	push   $0x804045
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 70 02 00 00       	call   800b1e <printfmt>
  8008ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b1:	e9 5b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b6:	56                   	push   %esi
  8008b7:	68 4e 40 80 00       	push   $0x80404e
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 57 02 00 00       	call   800b1e <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	e9 42 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 30                	mov    (%eax),%esi
  8008e0:	85 f6                	test   %esi,%esi
  8008e2:	75 05                	jne    8008e9 <vprintfmt+0x1a6>
				p = "(null)";
  8008e4:	be 51 40 80 00       	mov    $0x804051,%esi
			if (width > 0 && padc != '-')
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7e 6d                	jle    80095c <vprintfmt+0x219>
  8008ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f3:	74 67                	je     80095c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	50                   	push   %eax
  8008fc:	56                   	push   %esi
  8008fd:	e8 1e 03 00 00       	call   800c20 <strnlen>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800908:	eb 16                	jmp    800920 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800924:	7f e4                	jg     80090a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	eb 34                	jmp    80095c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	74 1c                	je     80094a <vprintfmt+0x207>
  80092e:	83 fb 1f             	cmp    $0x1f,%ebx
  800931:	7e 05                	jle    800938 <vprintfmt+0x1f5>
  800933:	83 fb 7e             	cmp    $0x7e,%ebx
  800936:	7e 12                	jle    80094a <vprintfmt+0x207>
					putch('?', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 3f                	push   $0x3f
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb 0f                	jmp    800959 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	ff 4d e4             	decl   -0x1c(%ebp)
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	8d 70 01             	lea    0x1(%eax),%esi
  800961:	8a 00                	mov    (%eax),%al
  800963:	0f be d8             	movsbl %al,%ebx
  800966:	85 db                	test   %ebx,%ebx
  800968:	74 24                	je     80098e <vprintfmt+0x24b>
  80096a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096e:	78 b8                	js     800928 <vprintfmt+0x1e5>
  800970:	ff 4d e0             	decl   -0x20(%ebp)
  800973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800977:	79 af                	jns    800928 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800979:	eb 13                	jmp    80098e <vprintfmt+0x24b>
				putch(' ', putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	6a 20                	push   $0x20
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098b:	ff 4d e4             	decl   -0x1c(%ebp)
  80098e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800992:	7f e7                	jg     80097b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800994:	e9 78 01 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 e8             	pushl  -0x18(%ebp)
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	e8 3c fd ff ff       	call   8006e4 <getint>
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	79 23                	jns    8009de <vprintfmt+0x29b>
				putch('-', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 2d                	push   $0x2d
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d1:	f7 d8                	neg    %eax
  8009d3:	83 d2 00             	adc    $0x0,%edx
  8009d6:	f7 da                	neg    %edx
  8009d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e5:	e9 bc 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	e8 84 fc ff ff       	call   80067d <getuint>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a09:	e9 98 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 58                	push   $0x58
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 58                	push   $0x58
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 58                	push   $0x58
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			break;
  800a3e:	e9 ce 00 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 30                	push   $0x30
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 78                	push   $0x78
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a85:	eb 1f                	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	e8 e7 fb ff ff       	call   80067d <getuint>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	ff 75 f0             	pushl  -0x10(%ebp)
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 00 fb ff ff       	call   8005c6 <printnum>
  800ac6:	83 c4 20             	add    $0x20,%esp
			break;
  800ac9:	eb 46                	jmp    800b11 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	eb 35                	jmp    800b11 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adc:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800ae3:	eb 2c                	jmp    800b11 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae5:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800aec:	eb 23                	jmp    800b11 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	6a 25                	push   $0x25
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	ff d0                	call   *%eax
  800afb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afe:	ff 4d 10             	decl   0x10(%ebp)
  800b01:	eb 03                	jmp    800b06 <vprintfmt+0x3c3>
  800b03:	ff 4d 10             	decl   0x10(%ebp)
  800b06:	8b 45 10             	mov    0x10(%ebp),%eax
  800b09:	48                   	dec    %eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	3c 25                	cmp    $0x25,%al
  800b0e:	75 f3                	jne    800b03 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b10:	90                   	nop
		}
	}
  800b11:	e9 35 fc ff ff       	jmp    80074b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b16:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b24:	8d 45 10             	lea    0x10(%ebp),%eax
  800b27:	83 c0 04             	add    $0x4,%eax
  800b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	ff 75 f4             	pushl  -0xc(%ebp)
  800b33:	50                   	push   %eax
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	e8 04 fc ff ff       	call   800743 <vprintfmt>
  800b3f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 40 08             	mov    0x8(%eax),%eax
  800b4e:	8d 50 01             	lea    0x1(%eax),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8b 10                	mov    (%eax),%edx
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 40 04             	mov    0x4(%eax),%eax
  800b62:	39 c2                	cmp    %eax,%edx
  800b64:	73 12                	jae    800b78 <sprintputch+0x33>
		*b->buf++ = ch;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	89 0a                	mov    %ecx,(%edx)
  800b73:	8b 55 08             	mov    0x8(%ebp),%edx
  800b76:	88 10                	mov    %dl,(%eax)
}
  800b78:	90                   	nop
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba0:	74 06                	je     800ba8 <vsnprintf+0x2d>
  800ba2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba6:	7f 07                	jg     800baf <vsnprintf+0x34>
		return -E_INVAL;
  800ba8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bad:	eb 20                	jmp    800bcf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800baf:	ff 75 14             	pushl  0x14(%ebp)
  800bb2:	ff 75 10             	pushl  0x10(%ebp)
  800bb5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb8:	50                   	push   %eax
  800bb9:	68 45 0b 80 00       	push   $0x800b45
  800bbe:	e8 80 fb ff ff       	call   800743 <vprintfmt>
  800bc3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bda:	83 c0 04             	add    $0x4,%eax
  800bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	ff 75 08             	pushl  0x8(%ebp)
  800bed:	e8 89 ff ff ff       	call   800b7b <vsnprintf>
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0a:	eb 06                	jmp    800c12 <strlen+0x15>
		n++;
  800c0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0f:	ff 45 08             	incl   0x8(%ebp)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	84 c0                	test   %al,%al
  800c19:	75 f1                	jne    800c0c <strlen+0xf>
		n++;
	return n;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2d:	eb 09                	jmp    800c38 <strnlen+0x18>
		n++;
  800c2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c32:	ff 45 08             	incl   0x8(%ebp)
  800c35:	ff 4d 0c             	decl   0xc(%ebp)
  800c38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3c:	74 09                	je     800c47 <strnlen+0x27>
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	75 e8                	jne    800c2f <strnlen+0xf>
		n++;
	return n;
  800c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c58:	90                   	nop
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6b:	8a 12                	mov    (%edx),%dl
  800c6d:	88 10                	mov    %dl,(%eax)
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	75 e4                	jne    800c59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8d:	eb 1f                	jmp    800cae <strncpy+0x34>
		*dst++ = *src;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8d 50 01             	lea    0x1(%eax),%edx
  800c95:	89 55 08             	mov    %edx,0x8(%ebp)
  800c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9b:	8a 12                	mov    (%edx),%dl
  800c9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 03                	je     800cab <strncpy+0x31>
			src++;
  800ca8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cab:	ff 45 fc             	incl   -0x4(%ebp)
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb4:	72 d9                	jb     800c8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccb:	74 30                	je     800cfd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccd:	eb 16                	jmp    800ce5 <strlcpy+0x2a>
			*dst++ = *src++;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce1:	8a 12                	mov    (%edx),%dl
  800ce3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 09                	je     800cf7 <strlcpy+0x3c>
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 d8                	jne    800ccf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0c:	eb 06                	jmp    800d14 <strcmp+0xb>
		p++, q++;
  800d0e:	ff 45 08             	incl   0x8(%ebp)
  800d11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 0e                	je     800d2b <strcmp+0x22>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	38 c2                	cmp    %al,%dl
  800d29:	74 e3                	je     800d0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 d0             	movzbl %al,%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	29 c2                	sub    %eax,%edx
  800d3d:	89 d0                	mov    %edx,%eax
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d44:	eb 09                	jmp    800d4f <strncmp+0xe>
		n--, p++, q++;
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	ff 45 08             	incl   0x8(%ebp)
  800d4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	74 17                	je     800d6c <strncmp+0x2b>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	74 0e                	je     800d6c <strncmp+0x2b>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 10                	mov    (%eax),%dl
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	38 c2                	cmp    %al,%dl
  800d6a:	74 da                	je     800d46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	75 07                	jne    800d79 <strncmp+0x38>
		return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
  800d77:	eb 14                	jmp    800d8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9b:	eb 12                	jmp    800daf <strchr+0x20>
		if (*s == c)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da5:	75 05                	jne    800dac <strchr+0x1d>
			return (char *) s;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	eb 11                	jmp    800dbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	75 e5                	jne    800d9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 04             	sub    $0x4,%esp
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcb:	eb 0d                	jmp    800dda <strfind+0x1b>
		if (*s == c)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd5:	74 0e                	je     800de5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 ea                	jne    800dcd <strfind+0xe>
  800de3:	eb 01                	jmp    800de6 <strfind+0x27>
		if (*s == c)
			break;
  800de5:	90                   	nop
	return (char *) s;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800df7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dfd:	eb 0e                	jmp    800e0d <memset+0x22>
		*p++ = c;
  800dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e02:	8d 50 01             	lea    0x1(%eax),%edx
  800e05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e0d:	ff 4d f8             	decl   -0x8(%ebp)
  800e10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e14:	79 e9                	jns    800dff <memset+0x14>
		*p++ = c;

	return v;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e2d:	eb 16                	jmp    800e45 <memcpy+0x2a>
		*d++ = *s++;
  800e2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e32:	8d 50 01             	lea    0x1(%eax),%edx
  800e35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e41:	8a 12                	mov    (%edx),%dl
  800e43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	75 dd                	jne    800e2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6f:	73 50                	jae    800ec1 <memmove+0x6a>
  800e71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 d0                	add    %edx,%eax
  800e79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e7c:	76 43                	jbe    800ec1 <memmove+0x6a>
		s += n;
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e8a:	eb 10                	jmp    800e9c <memmove+0x45>
			*--d = *--s;
  800e8c:	ff 4d f8             	decl   -0x8(%ebp)
  800e8f:	ff 4d fc             	decl   -0x4(%ebp)
  800e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e95:	8a 10                	mov    (%eax),%dl
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	75 e3                	jne    800e8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ea9:	eb 23                	jmp    800ece <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ebd:	8a 12                	mov    (%edx),%dl
  800ebf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 dd                	jne    800eab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ee5:	eb 2a                	jmp    800f11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eea:	8a 10                	mov    (%eax),%dl
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	38 c2                	cmp    %al,%dl
  800ef3:	74 16                	je     800f0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 d0             	movzbl %al,%edx
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 c0             	movzbl %al,%eax
  800f05:	29 c2                	sub    %eax,%edx
  800f07:	89 d0                	mov    %edx,%eax
  800f09:	eb 18                	jmp    800f23 <memcmp+0x50>
		s1++, s2++;
  800f0b:	ff 45 fc             	incl   -0x4(%ebp)
  800f0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f11:	8b 45 10             	mov    0x10(%ebp),%eax
  800f14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f17:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	75 c9                	jne    800ee7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	01 d0                	add    %edx,%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f36:	eb 15                	jmp    800f4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f b6 d0             	movzbl %al,%edx
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	0f b6 c0             	movzbl %al,%eax
  800f46:	39 c2                	cmp    %eax,%edx
  800f48:	74 0d                	je     800f57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f53:	72 e3                	jb     800f38 <memfind+0x13>
  800f55:	eb 01                	jmp    800f58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f57:	90                   	nop
	return (void *) s;
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f71:	eb 03                	jmp    800f76 <strtol+0x19>
		s++;
  800f73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 20                	cmp    $0x20,%al
  800f7d:	74 f4                	je     800f73 <strtol+0x16>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 09                	cmp    $0x9,%al
  800f86:	74 eb                	je     800f73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 2b                	cmp    $0x2b,%al
  800f8f:	75 05                	jne    800f96 <strtol+0x39>
		s++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	eb 13                	jmp    800fa9 <strtol+0x4c>
	else if (*s == '-')
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 2d                	cmp    $0x2d,%al
  800f9d:	75 0a                	jne    800fa9 <strtol+0x4c>
		s++, neg = 1;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fad:	74 06                	je     800fb5 <strtol+0x58>
  800faf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fb3:	75 20                	jne    800fd5 <strtol+0x78>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 30                	cmp    $0x30,%al
  800fbc:	75 17                	jne    800fd5 <strtol+0x78>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	40                   	inc    %eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 78                	cmp    $0x78,%al
  800fc6:	75 0d                	jne    800fd5 <strtol+0x78>
		s += 2, base = 16;
  800fc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fd3:	eb 28                	jmp    800ffd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd9:	75 15                	jne    800ff0 <strtol+0x93>
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 30                	cmp    $0x30,%al
  800fe2:	75 0c                	jne    800ff0 <strtol+0x93>
		s++, base = 8;
  800fe4:	ff 45 08             	incl   0x8(%ebp)
  800fe7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fee:	eb 0d                	jmp    800ffd <strtol+0xa0>
	else if (base == 0)
  800ff0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff4:	75 07                	jne    800ffd <strtol+0xa0>
		base = 10;
  800ff6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 2f                	cmp    $0x2f,%al
  801004:	7e 19                	jle    80101f <strtol+0xc2>
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	3c 39                	cmp    $0x39,%al
  80100d:	7f 10                	jg     80101f <strtol+0xc2>
			dig = *s - '0';
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	0f be c0             	movsbl %al,%eax
  801017:	83 e8 30             	sub    $0x30,%eax
  80101a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80101d:	eb 42                	jmp    801061 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 60                	cmp    $0x60,%al
  801026:	7e 19                	jle    801041 <strtol+0xe4>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 7a                	cmp    $0x7a,%al
  80102f:	7f 10                	jg     801041 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 57             	sub    $0x57,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 20                	jmp    801061 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 40                	cmp    $0x40,%al
  801048:	7e 39                	jle    801083 <strtol+0x126>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 5a                	cmp    $0x5a,%al
  801051:	7f 30                	jg     801083 <strtol+0x126>
			dig = *s - 'A' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 37             	sub    $0x37,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801064:	3b 45 10             	cmp    0x10(%ebp),%eax
  801067:	7d 19                	jge    801082 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801069:	ff 45 08             	incl   0x8(%ebp)
  80106c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801073:	89 c2                	mov    %eax,%edx
  801075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801078:	01 d0                	add    %edx,%eax
  80107a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80107d:	e9 7b ff ff ff       	jmp    800ffd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801082:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801083:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801087:	74 08                	je     801091 <strtol+0x134>
		*endptr = (char *) s;
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801091:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801095:	74 07                	je     80109e <strtol+0x141>
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	f7 d8                	neg    %eax
  80109c:	eb 03                	jmp    8010a1 <strtol+0x144>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <ltostr>:

void
ltostr(long value, char *str)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bb:	79 13                	jns    8010d0 <ltostr+0x2d>
	{
		neg = 1;
  8010bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010cd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010d8:	99                   	cltd   
  8010d9:	f7 f9                	idiv   %ecx
  8010db:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e1:	8d 50 01             	lea    0x1(%eax),%edx
  8010e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e7:	89 c2                	mov    %eax,%edx
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	01 d0                	add    %edx,%eax
  8010ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f1:	83 c2 30             	add    $0x30,%edx
  8010f4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010fe:	f7 e9                	imul   %ecx
  801100:	c1 fa 02             	sar    $0x2,%edx
  801103:	89 c8                	mov    %ecx,%eax
  801105:	c1 f8 1f             	sar    $0x1f,%eax
  801108:	29 c2                	sub    %eax,%edx
  80110a:	89 d0                	mov    %edx,%eax
  80110c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80110f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801113:	75 bb                	jne    8010d0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111f:	48                   	dec    %eax
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801123:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801127:	74 3d                	je     801166 <ltostr+0xc3>
		start = 1 ;
  801129:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801130:	eb 34                	jmp    801166 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801132:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	01 d0                	add    %edx,%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80113f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	01 c2                	add    %eax,%edx
  801147:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 c8                	add    %ecx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801153:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	01 c2                	add    %eax,%edx
  80115b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80115e:	88 02                	mov    %al,(%edx)
		start++ ;
  801160:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801163:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801169:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80116c:	7c c4                	jl     801132 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80116e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	01 d0                	add    %edx,%eax
  801176:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801179:	90                   	nop
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

0080117c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801182:	ff 75 08             	pushl  0x8(%ebp)
  801185:	e8 73 fa ff ff       	call   800bfd <strlen>
  80118a:	83 c4 04             	add    $0x4,%esp
  80118d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801190:	ff 75 0c             	pushl  0xc(%ebp)
  801193:	e8 65 fa ff ff       	call   800bfd <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ac:	eb 17                	jmp    8011c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011c2:	ff 45 fc             	incl   -0x4(%ebp)
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011cb:	7c e1                	jl     8011ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011db:	eb 1f                	jmp    8011fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8d 50 01             	lea    0x1(%eax),%edx
  8011e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011e6:	89 c2                	mov    %eax,%edx
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	01 c2                	add    %eax,%edx
  8011ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c8                	add    %ecx,%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011f9:	ff 45 f8             	incl   -0x8(%ebp)
  8011fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801202:	7c d9                	jl     8011dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801204:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	c6 00 00             	movb   $0x0,(%eax)
}
  80120f:	90                   	nop
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801215:	8b 45 14             	mov    0x14(%ebp),%eax
  801218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80121e:	8b 45 14             	mov    0x14(%ebp),%eax
  801221:	8b 00                	mov    (%eax),%eax
  801223:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122a:	8b 45 10             	mov    0x10(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801235:	eb 0c                	jmp    801243 <strsplit+0x31>
			*string++ = 0;
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 08             	mov    %edx,0x8(%ebp)
  801240:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	84 c0                	test   %al,%al
  80124a:	74 18                	je     801264 <strsplit+0x52>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	0f be c0             	movsbl %al,%eax
  801254:	50                   	push   %eax
  801255:	ff 75 0c             	pushl  0xc(%ebp)
  801258:	e8 32 fb ff ff       	call   800d8f <strchr>
  80125d:	83 c4 08             	add    $0x8,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	75 d3                	jne    801237 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	84 c0                	test   %al,%al
  80126b:	74 5a                	je     8012c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80126d:	8b 45 14             	mov    0x14(%ebp),%eax
  801270:	8b 00                	mov    (%eax),%eax
  801272:	83 f8 0f             	cmp    $0xf,%eax
  801275:	75 07                	jne    80127e <strsplit+0x6c>
		{
			return 0;
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
  80127c:	eb 66                	jmp    8012e4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80127e:	8b 45 14             	mov    0x14(%ebp),%eax
  801281:	8b 00                	mov    (%eax),%eax
  801283:	8d 48 01             	lea    0x1(%eax),%ecx
  801286:	8b 55 14             	mov    0x14(%ebp),%edx
  801289:	89 0a                	mov    %ecx,(%edx)
  80128b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801292:	8b 45 10             	mov    0x10(%ebp),%eax
  801295:	01 c2                	add    %eax,%edx
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80129c:	eb 03                	jmp    8012a1 <strsplit+0x8f>
			string++;
  80129e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	84 c0                	test   %al,%al
  8012a8:	74 8b                	je     801235 <strsplit+0x23>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	0f be c0             	movsbl %al,%eax
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	e8 d4 fa ff ff       	call   800d8f <strchr>
  8012bb:	83 c4 08             	add    $0x8,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 dc                	je     80129e <strsplit+0x8c>
			string++;
	}
  8012c2:	e9 6e ff ff ff       	jmp    801235 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cb:	8b 00                	mov    (%eax),%eax
  8012cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	68 c8 41 80 00       	push   $0x8041c8
  8012f4:	68 3f 01 00 00       	push   $0x13f
  8012f9:	68 ea 41 80 00       	push   $0x8041ea
  8012fe:	e8 8a 25 00 00       	call   80388d <_panic>

00801303 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	ff 75 08             	pushl  0x8(%ebp)
  80130f:	e8 8d 0a 00 00       	call   801da1 <sys_sbrk>
  801314:	83 c4 10             	add    $0x10,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80131f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801323:	75 0a                	jne    80132f <malloc+0x16>
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	e9 07 02 00 00       	jmp    801536 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  80132f:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801336:	8b 55 08             	mov    0x8(%ebp),%edx
  801339:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80133c:	01 d0                	add    %edx,%eax
  80133e:	48                   	dec    %eax
  80133f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801342:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801345:	ba 00 00 00 00       	mov    $0x0,%edx
  80134a:	f7 75 dc             	divl   -0x24(%ebp)
  80134d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801350:	29 d0                	sub    %edx,%eax
  801352:	c1 e8 0c             	shr    $0xc,%eax
  801355:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801358:	a1 20 50 80 00       	mov    0x805020,%eax
  80135d:	8b 40 78             	mov    0x78(%eax),%eax
  801360:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801365:	29 c2                	sub    %eax,%edx
  801367:	89 d0                	mov    %edx,%eax
  801369:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80136c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80136f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801374:	c1 e8 0c             	shr    $0xc,%eax
  801377:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80137a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801381:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801388:	77 42                	ja     8013cc <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80138a:	e8 96 08 00 00       	call   801c25 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 16                	je     8013a9 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 d6 0d 00 00       	call   802174 <alloc_block_FF>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a4:	e9 8a 01 00 00       	jmp    801533 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013a9:	e8 a8 08 00 00       	call   801c56 <sys_isUHeapPlacementStrategyBESTFIT>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	0f 84 7d 01 00 00    	je     801533 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 6f 12 00 00       	call   802630 <alloc_block_BF>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013c7:	e9 67 01 00 00       	jmp    801533 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8013cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013cf:	48                   	dec    %eax
  8013d0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8013d3:	0f 86 53 01 00 00    	jbe    80152c <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8013d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8013de:	8b 40 78             	mov    0x78(%eax),%eax
  8013e1:	05 00 10 00 00       	add    $0x1000,%eax
  8013e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8013e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8013f0:	e9 de 00 00 00       	jmp    8014d3 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8013f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013fa:	8b 40 78             	mov    0x78(%eax),%eax
  8013fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801400:	29 c2                	sub    %eax,%edx
  801402:	89 d0                	mov    %edx,%eax
  801404:	2d 00 10 00 00       	sub    $0x1000,%eax
  801409:	c1 e8 0c             	shr    $0xc,%eax
  80140c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	0f 85 ab 00 00 00    	jne    8014c6 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  80141b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141e:	05 00 10 00 00       	add    $0x1000,%eax
  801423:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80142d:	eb 47                	jmp    801476 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80142f:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801436:	76 0a                	jbe    801442 <malloc+0x129>
  801438:	b8 00 00 00 00       	mov    $0x0,%eax
  80143d:	e9 f4 00 00 00       	jmp    801536 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801442:	a1 20 50 80 00       	mov    0x805020,%eax
  801447:	8b 40 78             	mov    0x78(%eax),%eax
  80144a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80144d:	29 c2                	sub    %eax,%edx
  80144f:	89 d0                	mov    %edx,%eax
  801451:	2d 00 10 00 00       	sub    $0x1000,%eax
  801456:	c1 e8 0c             	shr    $0xc,%eax
  801459:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801460:	85 c0                	test   %eax,%eax
  801462:	74 08                	je     80146c <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801467:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80146a:	eb 5a                	jmp    8014c6 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  80146c:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801473:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801476:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801479:	48                   	dec    %eax
  80147a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80147d:	77 b0                	ja     80142f <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80147f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801486:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80148d:	eb 2f                	jmp    8014be <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80148f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801492:	c1 e0 0c             	shl    $0xc,%eax
  801495:	89 c2                	mov    %eax,%edx
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	01 c2                	add    %eax,%edx
  80149c:	a1 20 50 80 00       	mov    0x805020,%eax
  8014a1:	8b 40 78             	mov    0x78(%eax),%eax
  8014a4:	29 c2                	sub    %eax,%edx
  8014a6:	89 d0                	mov    %edx,%eax
  8014a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ad:	c1 e8 0c             	shr    $0xc,%eax
  8014b0:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8014b7:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8014bb:	ff 45 e0             	incl   -0x20(%ebp)
  8014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014c4:	72 c9                	jb     80148f <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ca:	75 16                	jne    8014e2 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014cc:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014d3:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014da:	0f 86 15 ff ff ff    	jbe    8013f5 <malloc+0xdc>
  8014e0:	eb 01                	jmp    8014e3 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014e2:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8014e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014e7:	75 07                	jne    8014f0 <malloc+0x1d7>
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ee:	eb 46                	jmp    801536 <malloc+0x21d>
		ptr = (void*)i;
  8014f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8014f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8014fb:	8b 40 78             	mov    0x78(%eax),%eax
  8014fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801501:	29 c2                	sub    %eax,%edx
  801503:	89 d0                	mov    %edx,%eax
  801505:	2d 00 10 00 00       	sub    $0x1000,%eax
  80150a:	c1 e8 0c             	shr    $0xc,%eax
  80150d:	89 c2                	mov    %eax,%edx
  80150f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801512:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	ff 75 f0             	pushl  -0x10(%ebp)
  801522:	e8 b1 08 00 00       	call   801dd8 <sys_allocate_user_mem>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	eb 07                	jmp    801533 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax
  801531:	eb 03                	jmp    801536 <malloc+0x21d>
	}
	return ptr;
  801533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80153e:	a1 20 50 80 00       	mov    0x805020,%eax
  801543:	8b 40 78             	mov    0x78(%eax),%eax
  801546:	05 00 10 00 00       	add    $0x1000,%eax
  80154b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80154e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801555:	a1 20 50 80 00       	mov    0x805020,%eax
  80155a:	8b 50 78             	mov    0x78(%eax),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	39 c2                	cmp    %eax,%edx
  801562:	76 24                	jbe    801588 <free+0x50>
		size = get_block_size(va);
  801564:	83 ec 0c             	sub    $0xc,%esp
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 85 08 00 00       	call   801df4 <get_block_size>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 b8 1a 00 00       	call   803038 <free_block>
  801580:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801583:	e9 ac 00 00 00       	jmp    801634 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80158e:	0f 82 89 00 00 00    	jb     80161d <free+0xe5>
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  80159c:	77 7f                	ja     80161d <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80159e:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8015a6:	8b 40 78             	mov    0x78(%eax),%eax
  8015a9:	29 c2                	sub    %eax,%edx
  8015ab:	89 d0                	mov    %edx,%eax
  8015ad:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b2:	c1 e8 0c             	shr    $0xc,%eax
  8015b5:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8015bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	c1 e0 0c             	shl    $0xc,%eax
  8015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8015c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015cf:	eb 2f                	jmp    801600 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	c1 e0 0c             	shl    $0xc,%eax
  8015d7:	89 c2                	mov    %eax,%edx
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	01 c2                	add    %eax,%edx
  8015de:	a1 20 50 80 00       	mov    0x805020,%eax
  8015e3:	8b 40 78             	mov    0x78(%eax),%eax
  8015e6:	29 c2                	sub    %eax,%edx
  8015e8:	89 d0                	mov    %edx,%eax
  8015ea:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ef:	c1 e8 0c             	shr    $0xc,%eax
  8015f2:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  8015f9:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8015fd:	ff 45 f4             	incl   -0xc(%ebp)
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801606:	72 c9                	jb     8015d1 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	ff 75 ec             	pushl  -0x14(%ebp)
  801611:	50                   	push   %eax
  801612:	e8 a5 07 00 00       	call   801dbc <sys_free_user_mem>
  801617:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80161a:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80161b:	eb 17                	jmp    801634 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	68 f8 41 80 00       	push   $0x8041f8
  801625:	68 84 00 00 00       	push   $0x84
  80162a:	68 22 42 80 00       	push   $0x804222
  80162f:	e8 59 22 00 00       	call   80388d <_panic>
	}
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 28             	sub    $0x28,%esp
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801642:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801646:	75 07                	jne    80164f <smalloc+0x19>
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
  80164d:	eb 64                	jmp    8016b3 <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801655:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80165c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801662:	39 d0                	cmp    %edx,%eax
  801664:	73 02                	jae    801668 <smalloc+0x32>
  801666:	89 d0                	mov    %edx,%eax
  801668:	83 ec 0c             	sub    $0xc,%esp
  80166b:	50                   	push   %eax
  80166c:	e8 a8 fc ff ff       	call   801319 <malloc>
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801677:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167b:	75 07                	jne    801684 <smalloc+0x4e>
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
  801682:	eb 2f                	jmp    8016b3 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801684:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801688:	ff 75 ec             	pushl  -0x14(%ebp)
  80168b:	50                   	push   %eax
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 2c 03 00 00       	call   8019c3 <sys_createSharedObject>
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80169d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016a1:	74 06                	je     8016a9 <smalloc+0x73>
  8016a3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016a7:	75 07                	jne    8016b0 <smalloc+0x7a>
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 03                	jmp    8016b3 <smalloc+0x7d>
	 return ptr;
  8016b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	ff 75 08             	pushl  0x8(%ebp)
  8016c4:	e8 24 03 00 00       	call   8019ed <sys_getSizeOfSharedObject>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016cf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016d3:	75 07                	jne    8016dc <sget+0x27>
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 5c                	jmp    801738 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	39 d0                	cmp    %edx,%eax
  8016f1:	7d 02                	jge    8016f5 <sget+0x40>
  8016f3:	89 d0                	mov    %edx,%eax
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	50                   	push   %eax
  8016f9:	e8 1b fc ff ff       	call   801319 <malloc>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801704:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801708:	75 07                	jne    801711 <sget+0x5c>
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
  80170f:	eb 27                	jmp    801738 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	ff 75 e8             	pushl  -0x18(%ebp)
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	e8 e8 02 00 00       	call   801a0a <sys_getSharedObject>
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801728:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80172c:	75 07                	jne    801735 <sget+0x80>
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
  801733:	eb 03                	jmp    801738 <sget+0x83>
	return ptr;
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 30 42 80 00       	push   $0x804230
  801748:	68 c1 00 00 00       	push   $0xc1
  80174d:	68 22 42 80 00       	push   $0x804222
  801752:	e8 36 21 00 00       	call   80388d <_panic>

00801757 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	68 54 42 80 00       	push   $0x804254
  801765:	68 d8 00 00 00       	push   $0xd8
  80176a:	68 22 42 80 00       	push   $0x804222
  80176f:	e8 19 21 00 00       	call   80388d <_panic>

00801774 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	68 7a 42 80 00       	push   $0x80427a
  801782:	68 e4 00 00 00       	push   $0xe4
  801787:	68 22 42 80 00       	push   $0x804222
  80178c:	e8 fc 20 00 00       	call   80388d <_panic>

00801791 <shrink>:

}
void shrink(uint32 newSize)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	68 7a 42 80 00       	push   $0x80427a
  80179f:	68 e9 00 00 00       	push   $0xe9
  8017a4:	68 22 42 80 00       	push   $0x804222
  8017a9:	e8 df 20 00 00       	call   80388d <_panic>

008017ae <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 7a 42 80 00       	push   $0x80427a
  8017bc:	68 ee 00 00 00       	push   $0xee
  8017c1:	68 22 42 80 00       	push   $0x804222
  8017c6:	e8 c2 20 00 00       	call   80388d <_panic>

008017cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	57                   	push   %edi
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017e6:	cd 30                	int    $0x30
  8017e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	5b                   	pop    %ebx
  8017f2:	5e                   	pop    %esi
  8017f3:	5f                   	pop    %edi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801802:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	52                   	push   %edx
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	50                   	push   %eax
  801812:	6a 00                	push   $0x0
  801814:	e8 b2 ff ff ff       	call   8017cb <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	90                   	nop
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_cgetc>:

int
sys_cgetc(void)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 02                	push   $0x2
  80182e:	e8 98 ff ff ff       	call   8017cb <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 03                	push   $0x3
  801847:	e8 7f ff ff ff       	call   8017cb <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	90                   	nop
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 04                	push   $0x4
  801861:	e8 65 ff ff ff       	call   8017cb <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	90                   	nop
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 08                	push   $0x8
  80187f:	e8 47 ff ff ff       	call   8017cb <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80188e:	8b 75 18             	mov    0x18(%ebp),%esi
  801891:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801894:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	51                   	push   %ecx
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 09                	push   $0x9
  8018a4:	e8 22 ff ff ff       	call   8017cb <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 0a                	push   $0xa
  8018c6:	e8 00 ff ff ff       	call   8017cb <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	6a 0b                	push   $0xb
  8018e1:	e8 e5 fe ff ff       	call   8017cb <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 0c                	push   $0xc
  8018fa:	e8 cc fe ff ff       	call   8017cb <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 0d                	push   $0xd
  801913:	e8 b3 fe ff ff       	call   8017cb <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 0e                	push   $0xe
  80192c:	e8 9a fe ff ff       	call   8017cb <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 0f                	push   $0xf
  801945:	e8 81 fe ff ff       	call   8017cb <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 10                	push   $0x10
  80195f:	e8 67 fe ff ff       	call   8017cb <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 11                	push   $0x11
  801978:	e8 4e fe ff ff       	call   8017cb <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	90                   	nop
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_cputc>:

void
sys_cputc(const char c)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80198f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	50                   	push   %eax
  80199c:	6a 01                	push   $0x1
  80199e:	e8 28 fe ff ff       	call   8017cb <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	90                   	nop
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 14                	push   $0x14
  8019b8:	e8 0e fe ff ff       	call   8017cb <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	51                   	push   %ecx
  8019dc:	52                   	push   %edx
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	50                   	push   %eax
  8019e1:	6a 15                	push   $0x15
  8019e3:	e8 e3 fd ff ff       	call   8017cb <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 16                	push   $0x16
  801a00:	e8 c6 fd ff ff       	call   8017cb <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	51                   	push   %ecx
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	6a 17                	push   $0x17
  801a1f:	e8 a7 fd ff ff       	call   8017cb <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 18                	push   $0x18
  801a3c:	e8 8a fd ff ff       	call   8017cb <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	ff 75 14             	pushl  0x14(%ebp)
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	50                   	push   %eax
  801a58:	6a 19                	push   $0x19
  801a5a:	e8 6c fd ff ff       	call   8017cb <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	50                   	push   %eax
  801a73:	6a 1a                	push   $0x1a
  801a75:	e8 51 fd ff ff       	call   8017cb <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	90                   	nop
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	50                   	push   %eax
  801a8f:	6a 1b                	push   $0x1b
  801a91:	e8 35 fd ff ff       	call   8017cb <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 05                	push   $0x5
  801aaa:	e8 1c fd ff ff       	call   8017cb <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 06                	push   $0x6
  801ac3:	e8 03 fd ff ff       	call   8017cb <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 07                	push   $0x7
  801adc:	e8 ea fc ff ff       	call   8017cb <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_exit_env>:


void sys_exit_env(void)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 1c                	push   $0x1c
  801af5:	e8 d1 fc ff ff       	call   8017cb <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b09:	8d 50 04             	lea    0x4(%eax),%edx
  801b0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 1d                	push   $0x1d
  801b19:	e8 ad fc ff ff       	call   8017cb <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2a:	89 01                	mov    %eax,(%ecx)
  801b2c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	c9                   	leave  
  801b33:	c2 04 00             	ret    $0x4

00801b36 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 13                	push   $0x13
  801b48:	e8 7e fc ff ff       	call   8017cb <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 1e                	push   $0x1e
  801b62:	e8 64 fc ff ff       	call   8017cb <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b78:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	50                   	push   %eax
  801b85:	6a 1f                	push   $0x1f
  801b87:	e8 3f fc ff ff       	call   8017cb <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <rsttst>:
void rsttst()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 21                	push   $0x21
  801ba1:	e8 25 fc ff ff       	call   8017cb <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba9:	90                   	nop
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bb8:	8b 55 18             	mov    0x18(%ebp),%edx
  801bbb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	ff 75 10             	pushl  0x10(%ebp)
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	6a 20                	push   $0x20
  801bcc:	e8 fa fb ff ff       	call   8017cb <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <chktst>:
void chktst(uint32 n)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 08             	pushl  0x8(%ebp)
  801be5:	6a 22                	push   $0x22
  801be7:	e8 df fb ff ff       	call   8017cb <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <inctst>:

void inctst()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 23                	push   $0x23
  801c01:	e8 c5 fb ff ff       	call   8017cb <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <gettst>:
uint32 gettst()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 24                	push   $0x24
  801c1b:	e8 ab fb ff ff       	call   8017cb <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 25                	push   $0x25
  801c37:	e8 8f fb ff ff       	call   8017cb <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
  801c3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c42:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c46:	75 07                	jne    801c4f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c48:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4d:	eb 05                	jmp    801c54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 25                	push   $0x25
  801c68:	e8 5e fb ff ff       	call   8017cb <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
  801c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c73:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c77:	75 07                	jne    801c80 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c79:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7e:	eb 05                	jmp    801c85 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 25                	push   $0x25
  801c99:	e8 2d fb ff ff       	call   8017cb <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
  801ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ca4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ca8:	75 07                	jne    801cb1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	eb 05                	jmp    801cb6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 25                	push   $0x25
  801cca:	e8 fc fa ff ff       	call   8017cb <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
  801cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cd5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cd9:	75 07                	jne    801ce2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cdb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce0:	eb 05                	jmp    801ce7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	6a 26                	push   $0x26
  801cf9:	e8 cd fa ff ff       	call   8017cb <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	53                   	push   %ebx
  801d17:	51                   	push   %ecx
  801d18:	52                   	push   %edx
  801d19:	50                   	push   %eax
  801d1a:	6a 27                	push   $0x27
  801d1c:	e8 aa fa ff ff       	call   8017cb <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	6a 28                	push   $0x28
  801d3c:	e8 8a fa ff ff       	call   8017cb <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d49:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	51                   	push   %ecx
  801d55:	ff 75 10             	pushl  0x10(%ebp)
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 29                	push   $0x29
  801d5c:	e8 6a fa ff ff       	call   8017cb <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	ff 75 10             	pushl  0x10(%ebp)
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	ff 75 08             	pushl  0x8(%ebp)
  801d76:	6a 12                	push   $0x12
  801d78:	e8 4e fa ff ff       	call   8017cb <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d80:	90                   	nop
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	52                   	push   %edx
  801d93:	50                   	push   %eax
  801d94:	6a 2a                	push   $0x2a
  801d96:	e8 30 fa ff ff       	call   8017cb <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
	return;
  801d9e:	90                   	nop
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	50                   	push   %eax
  801db0:	6a 2b                	push   $0x2b
  801db2:	e8 14 fa ff ff       	call   8017cb <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	ff 75 08             	pushl  0x8(%ebp)
  801dcb:	6a 2c                	push   $0x2c
  801dcd:	e8 f9 f9 ff ff       	call   8017cb <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
	return;
  801dd5:	90                   	nop
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	ff 75 0c             	pushl  0xc(%ebp)
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	6a 2d                	push   $0x2d
  801de9:	e8 dd f9 ff ff       	call   8017cb <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	83 e8 04             	sub    $0x4,%eax
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	83 e8 04             	sub    $0x4,%eax
  801e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	83 e0 01             	and    $0x1,%eax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	0f 94 c0             	sete   %al
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3b:	83 f8 02             	cmp    $0x2,%eax
  801e3e:	74 2b                	je     801e6b <alloc_block+0x40>
  801e40:	83 f8 02             	cmp    $0x2,%eax
  801e43:	7f 07                	jg     801e4c <alloc_block+0x21>
  801e45:	83 f8 01             	cmp    $0x1,%eax
  801e48:	74 0e                	je     801e58 <alloc_block+0x2d>
  801e4a:	eb 58                	jmp    801ea4 <alloc_block+0x79>
  801e4c:	83 f8 03             	cmp    $0x3,%eax
  801e4f:	74 2d                	je     801e7e <alloc_block+0x53>
  801e51:	83 f8 04             	cmp    $0x4,%eax
  801e54:	74 3b                	je     801e91 <alloc_block+0x66>
  801e56:	eb 4c                	jmp    801ea4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	ff 75 08             	pushl  0x8(%ebp)
  801e5e:	e8 11 03 00 00       	call   802174 <alloc_block_FF>
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e69:	eb 4a                	jmp    801eb5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	e8 fa 19 00 00       	call   803870 <alloc_block_NF>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e7c:	eb 37                	jmp    801eb5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e7e:	83 ec 0c             	sub    $0xc,%esp
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	e8 a7 07 00 00       	call   802630 <alloc_block_BF>
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e8f:	eb 24                	jmp    801eb5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 08             	pushl  0x8(%ebp)
  801e97:	e8 b7 19 00 00       	call   803853 <alloc_block_WF>
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ea2:	eb 11                	jmp    801eb5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	68 8c 42 80 00       	push   $0x80428c
  801eac:	e8 b8 e6 ff ff       	call   800569 <cprintf>
  801eb1:	83 c4 10             	add    $0x10,%esp
		break;
  801eb4:	90                   	nop
	}
	return va;
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	53                   	push   %ebx
  801ebe:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	68 ac 42 80 00       	push   $0x8042ac
  801ec9:	e8 9b e6 ff ff       	call   800569 <cprintf>
  801ece:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	68 d7 42 80 00       	push   $0x8042d7
  801ed9:	e8 8b e6 ff ff       	call   800569 <cprintf>
  801ede:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee7:	eb 37                	jmp    801f20 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	ff 75 f4             	pushl  -0xc(%ebp)
  801eef:	e8 19 ff ff ff       	call   801e0d <is_free_block>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	0f be d8             	movsbl %al,%ebx
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	ff 75 f4             	pushl  -0xc(%ebp)
  801f00:	e8 ef fe ff ff       	call   801df4 <get_block_size>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	53                   	push   %ebx
  801f0c:	50                   	push   %eax
  801f0d:	68 ef 42 80 00       	push   $0x8042ef
  801f12:	e8 52 e6 ff ff       	call   800569 <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f24:	74 07                	je     801f2d <print_blocks_list+0x73>
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 00                	mov    (%eax),%eax
  801f2b:	eb 05                	jmp    801f32 <print_blocks_list+0x78>
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	89 45 10             	mov    %eax,0x10(%ebp)
  801f35:	8b 45 10             	mov    0x10(%ebp),%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	75 ad                	jne    801ee9 <print_blocks_list+0x2f>
  801f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f40:	75 a7                	jne    801ee9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f42:	83 ec 0c             	sub    $0xc,%esp
  801f45:	68 ac 42 80 00       	push   $0x8042ac
  801f4a:	e8 1a e6 ff ff       	call   800569 <cprintf>
  801f4f:	83 c4 10             	add    $0x10,%esp

}
  801f52:	90                   	nop
  801f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f61:	83 e0 01             	and    $0x1,%eax
  801f64:	85 c0                	test   %eax,%eax
  801f66:	74 03                	je     801f6b <initialize_dynamic_allocator+0x13>
  801f68:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6f:	0f 84 c7 01 00 00    	je     80213c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f75:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f7c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f85:	01 d0                	add    %edx,%eax
  801f87:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f8c:	0f 87 ad 01 00 00    	ja     80213f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	85 c0                	test   %eax,%eax
  801f97:	0f 89 a5 01 00 00    	jns    802142 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa3:	01 d0                	add    %edx,%eax
  801fa5:	83 e8 04             	sub    $0x4,%eax
  801fa8:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fb4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbc:	e9 87 00 00 00       	jmp    802048 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc5:	75 14                	jne    801fdb <initialize_dynamic_allocator+0x83>
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	68 07 43 80 00       	push   $0x804307
  801fcf:	6a 79                	push   $0x79
  801fd1:	68 25 43 80 00       	push   $0x804325
  801fd6:	e8 b2 18 00 00       	call   80388d <_panic>
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 00                	mov    (%eax),%eax
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	74 10                	je     801ff4 <initialize_dynamic_allocator+0x9c>
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	8b 00                	mov    (%eax),%eax
  801fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fec:	8b 52 04             	mov    0x4(%edx),%edx
  801fef:	89 50 04             	mov    %edx,0x4(%eax)
  801ff2:	eb 0b                	jmp    801fff <initialize_dynamic_allocator+0xa7>
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 40 04             	mov    0x4(%eax),%eax
  801ffa:	a3 30 50 80 00       	mov    %eax,0x805030
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	8b 40 04             	mov    0x4(%eax),%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	74 0f                	je     802018 <initialize_dynamic_allocator+0xc0>
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 40 04             	mov    0x4(%eax),%eax
  80200f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802012:	8b 12                	mov    (%edx),%edx
  802014:	89 10                	mov    %edx,(%eax)
  802016:	eb 0a                	jmp    802022 <initialize_dynamic_allocator+0xca>
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 00                	mov    (%eax),%eax
  80201d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802035:	a1 38 50 80 00       	mov    0x805038,%eax
  80203a:	48                   	dec    %eax
  80203b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802040:	a1 34 50 80 00       	mov    0x805034,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204c:	74 07                	je     802055 <initialize_dynamic_allocator+0xfd>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	eb 05                	jmp    80205a <initialize_dynamic_allocator+0x102>
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	a3 34 50 80 00       	mov    %eax,0x805034
  80205f:	a1 34 50 80 00       	mov    0x805034,%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	0f 85 55 ff ff ff    	jne    801fc1 <initialize_dynamic_allocator+0x69>
  80206c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802070:	0f 85 4b ff ff ff    	jne    801fc1 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80207c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802085:	a1 44 50 80 00       	mov    0x805044,%eax
  80208a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80208f:	a1 40 50 80 00       	mov    0x805040,%eax
  802094:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	83 c0 08             	add    $0x8,%eax
  8020a0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	83 c0 04             	add    $0x4,%eax
  8020a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ac:	83 ea 08             	sub    $0x8,%edx
  8020af:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	83 e8 08             	sub    $0x8,%eax
  8020bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bf:	83 ea 08             	sub    $0x8,%edx
  8020c2:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020db:	75 17                	jne    8020f4 <initialize_dynamic_allocator+0x19c>
  8020dd:	83 ec 04             	sub    $0x4,%esp
  8020e0:	68 40 43 80 00       	push   $0x804340
  8020e5:	68 90 00 00 00       	push   $0x90
  8020ea:	68 25 43 80 00       	push   $0x804325
  8020ef:	e8 99 17 00 00       	call   80388d <_panic>
  8020f4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fd:	89 10                	mov    %edx,(%eax)
  8020ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	85 c0                	test   %eax,%eax
  802106:	74 0d                	je     802115 <initialize_dynamic_allocator+0x1bd>
  802108:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80210d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802110:	89 50 04             	mov    %edx,0x4(%eax)
  802113:	eb 08                	jmp    80211d <initialize_dynamic_allocator+0x1c5>
  802115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802118:	a3 30 50 80 00       	mov    %eax,0x805030
  80211d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802120:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802128:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212f:	a1 38 50 80 00       	mov    0x805038,%eax
  802134:	40                   	inc    %eax
  802135:	a3 38 50 80 00       	mov    %eax,0x805038
  80213a:	eb 07                	jmp    802143 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80213c:	90                   	nop
  80213d:	eb 04                	jmp    802143 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80213f:	90                   	nop
  802140:	eb 01                	jmp    802143 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802142:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802148:	8b 45 10             	mov    0x10(%ebp),%eax
  80214b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8d 50 fc             	lea    -0x4(%eax),%edx
  802154:	8b 45 0c             	mov    0xc(%ebp),%eax
  802157:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	83 e8 04             	sub    $0x4,%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	83 e0 fe             	and    $0xfffffffe,%eax
  802164:	8d 50 f8             	lea    -0x8(%eax),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	01 c2                	add    %eax,%edx
  80216c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216f:	89 02                	mov    %eax,(%edx)
}
  802171:	90                   	nop
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    

00802174 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	83 e0 01             	and    $0x1,%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	74 03                	je     802187 <alloc_block_FF+0x13>
  802184:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802187:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80218b:	77 07                	ja     802194 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80218d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802194:	a1 24 50 80 00       	mov    0x805024,%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	75 73                	jne    802210 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	83 c0 10             	add    $0x10,%eax
  8021a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021a6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b3:	01 d0                	add    %edx,%eax
  8021b5:	48                   	dec    %eax
  8021b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c1:	f7 75 ec             	divl   -0x14(%ebp)
  8021c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021c7:	29 d0                	sub    %edx,%eax
  8021c9:	c1 e8 0c             	shr    $0xc,%eax
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	50                   	push   %eax
  8021d0:	e8 2e f1 ff ff       	call   801303 <sbrk>
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	6a 00                	push   $0x0
  8021e0:	e8 1e f1 ff ff       	call   801303 <sbrk>
  8021e5:	83 c4 10             	add    $0x10,%esp
  8021e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ee:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021f1:	83 ec 08             	sub    $0x8,%esp
  8021f4:	50                   	push   %eax
  8021f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021f8:	e8 5b fd ff ff       	call   801f58 <initialize_dynamic_allocator>
  8021fd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	68 63 43 80 00       	push   $0x804363
  802208:	e8 5c e3 ff ff       	call   800569 <cprintf>
  80220d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802210:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802214:	75 0a                	jne    802220 <alloc_block_FF+0xac>
	        return NULL;
  802216:	b8 00 00 00 00       	mov    $0x0,%eax
  80221b:	e9 0e 04 00 00       	jmp    80262e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802220:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802227:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80222c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222f:	e9 f3 02 00 00       	jmp    802527 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	ff 75 bc             	pushl  -0x44(%ebp)
  802240:	e8 af fb ff ff       	call   801df4 <get_block_size>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	83 c0 08             	add    $0x8,%eax
  802251:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802254:	0f 87 c5 02 00 00    	ja     80251f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	83 c0 18             	add    $0x18,%eax
  802260:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802263:	0f 87 19 02 00 00    	ja     802482 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802269:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80226c:	2b 45 08             	sub    0x8(%ebp),%eax
  80226f:	83 e8 08             	sub    $0x8,%eax
  802272:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8d 50 08             	lea    0x8(%eax),%edx
  80227b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80227e:	01 d0                	add    %edx,%eax
  802280:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	83 c0 08             	add    $0x8,%eax
  802289:	83 ec 04             	sub    $0x4,%esp
  80228c:	6a 01                	push   $0x1
  80228e:	50                   	push   %eax
  80228f:	ff 75 bc             	pushl  -0x44(%ebp)
  802292:	e8 ae fe ff ff       	call   802145 <set_block_data>
  802297:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 04             	mov    0x4(%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	75 68                	jne    80230c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022a4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022a8:	75 17                	jne    8022c1 <alloc_block_FF+0x14d>
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	68 40 43 80 00       	push   $0x804340
  8022b2:	68 d7 00 00 00       	push   $0xd7
  8022b7:	68 25 43 80 00       	push   $0x804325
  8022bc:	e8 cc 15 00 00       	call   80388d <_panic>
  8022c1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ca:	89 10                	mov    %edx,(%eax)
  8022cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022cf:	8b 00                	mov    (%eax),%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	74 0d                	je     8022e2 <alloc_block_FF+0x16e>
  8022d5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022da:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022dd:	89 50 04             	mov    %edx,0x4(%eax)
  8022e0:	eb 08                	jmp    8022ea <alloc_block_FF+0x176>
  8022e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fc:	a1 38 50 80 00       	mov    0x805038,%eax
  802301:	40                   	inc    %eax
  802302:	a3 38 50 80 00       	mov    %eax,0x805038
  802307:	e9 dc 00 00 00       	jmp    8023e8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	75 65                	jne    80237a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802315:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802319:	75 17                	jne    802332 <alloc_block_FF+0x1be>
  80231b:	83 ec 04             	sub    $0x4,%esp
  80231e:	68 74 43 80 00       	push   $0x804374
  802323:	68 db 00 00 00       	push   $0xdb
  802328:	68 25 43 80 00       	push   $0x804325
  80232d:	e8 5b 15 00 00       	call   80388d <_panic>
  802332:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802338:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233b:	89 50 04             	mov    %edx,0x4(%eax)
  80233e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802341:	8b 40 04             	mov    0x4(%eax),%eax
  802344:	85 c0                	test   %eax,%eax
  802346:	74 0c                	je     802354 <alloc_block_FF+0x1e0>
  802348:	a1 30 50 80 00       	mov    0x805030,%eax
  80234d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802350:	89 10                	mov    %edx,(%eax)
  802352:	eb 08                	jmp    80235c <alloc_block_FF+0x1e8>
  802354:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802357:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80235c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235f:	a3 30 50 80 00       	mov    %eax,0x805030
  802364:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236d:	a1 38 50 80 00       	mov    0x805038,%eax
  802372:	40                   	inc    %eax
  802373:	a3 38 50 80 00       	mov    %eax,0x805038
  802378:	eb 6e                	jmp    8023e8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80237a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237e:	74 06                	je     802386 <alloc_block_FF+0x212>
  802380:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802384:	75 17                	jne    80239d <alloc_block_FF+0x229>
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	68 98 43 80 00       	push   $0x804398
  80238e:	68 df 00 00 00       	push   $0xdf
  802393:	68 25 43 80 00       	push   $0x804325
  802398:	e8 f0 14 00 00       	call   80388d <_panic>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 10                	mov    (%eax),%edx
  8023a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a5:	89 10                	mov    %edx,(%eax)
  8023a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	74 0b                	je     8023bb <alloc_block_FF+0x247>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023b8:	89 50 04             	mov    %edx,0x4(%eax)
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c1:	89 10                	mov    %edx,(%eax)
  8023c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c9:	89 50 04             	mov    %edx,0x4(%eax)
  8023cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cf:	8b 00                	mov    (%eax),%eax
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	75 08                	jne    8023dd <alloc_block_FF+0x269>
  8023d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8023e2:	40                   	inc    %eax
  8023e3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ec:	75 17                	jne    802405 <alloc_block_FF+0x291>
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	68 07 43 80 00       	push   $0x804307
  8023f6:	68 e1 00 00 00       	push   $0xe1
  8023fb:	68 25 43 80 00       	push   $0x804325
  802400:	e8 88 14 00 00       	call   80388d <_panic>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	74 10                	je     80241e <alloc_block_FF+0x2aa>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802416:	8b 52 04             	mov    0x4(%edx),%edx
  802419:	89 50 04             	mov    %edx,0x4(%eax)
  80241c:	eb 0b                	jmp    802429 <alloc_block_FF+0x2b5>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 40 04             	mov    0x4(%eax),%eax
  802424:	a3 30 50 80 00       	mov    %eax,0x805030
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 40 04             	mov    0x4(%eax),%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	74 0f                	je     802442 <alloc_block_FF+0x2ce>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243c:	8b 12                	mov    (%edx),%edx
  80243e:	89 10                	mov    %edx,(%eax)
  802440:	eb 0a                	jmp    80244c <alloc_block_FF+0x2d8>
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245f:	a1 38 50 80 00       	mov    0x805038,%eax
  802464:	48                   	dec    %eax
  802465:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	6a 00                	push   $0x0
  80246f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802472:	ff 75 b0             	pushl  -0x50(%ebp)
  802475:	e8 cb fc ff ff       	call   802145 <set_block_data>
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	e9 95 00 00 00       	jmp    802517 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	6a 01                	push   $0x1
  802487:	ff 75 b8             	pushl  -0x48(%ebp)
  80248a:	ff 75 bc             	pushl  -0x44(%ebp)
  80248d:	e8 b3 fc ff ff       	call   802145 <set_block_data>
  802492:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802499:	75 17                	jne    8024b2 <alloc_block_FF+0x33e>
  80249b:	83 ec 04             	sub    $0x4,%esp
  80249e:	68 07 43 80 00       	push   $0x804307
  8024a3:	68 e8 00 00 00       	push   $0xe8
  8024a8:	68 25 43 80 00       	push   $0x804325
  8024ad:	e8 db 13 00 00       	call   80388d <_panic>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	74 10                	je     8024cb <alloc_block_FF+0x357>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c3:	8b 52 04             	mov    0x4(%edx),%edx
  8024c6:	89 50 04             	mov    %edx,0x4(%eax)
  8024c9:	eb 0b                	jmp    8024d6 <alloc_block_FF+0x362>
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 04             	mov    0x4(%eax),%eax
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	74 0f                	je     8024ef <alloc_block_FF+0x37b>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	8b 12                	mov    (%edx),%edx
  8024eb:	89 10                	mov    %edx,(%eax)
  8024ed:	eb 0a                	jmp    8024f9 <alloc_block_FF+0x385>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250c:	a1 38 50 80 00       	mov    0x805038,%eax
  802511:	48                   	dec    %eax
  802512:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802517:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80251a:	e9 0f 01 00 00       	jmp    80262e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80251f:	a1 34 50 80 00       	mov    0x805034,%eax
  802524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252b:	74 07                	je     802534 <alloc_block_FF+0x3c0>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	eb 05                	jmp    802539 <alloc_block_FF+0x3c5>
  802534:	b8 00 00 00 00       	mov    $0x0,%eax
  802539:	a3 34 50 80 00       	mov    %eax,0x805034
  80253e:	a1 34 50 80 00       	mov    0x805034,%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 85 e9 fc ff ff    	jne    802234 <alloc_block_FF+0xc0>
  80254b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254f:	0f 85 df fc ff ff    	jne    802234 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	83 c0 08             	add    $0x8,%eax
  80255b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80255e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802565:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802568:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80256b:	01 d0                	add    %edx,%eax
  80256d:	48                   	dec    %eax
  80256e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802574:	ba 00 00 00 00       	mov    $0x0,%edx
  802579:	f7 75 d8             	divl   -0x28(%ebp)
  80257c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80257f:	29 d0                	sub    %edx,%eax
  802581:	c1 e8 0c             	shr    $0xc,%eax
  802584:	83 ec 0c             	sub    $0xc,%esp
  802587:	50                   	push   %eax
  802588:	e8 76 ed ff ff       	call   801303 <sbrk>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802593:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802597:	75 0a                	jne    8025a3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802599:	b8 00 00 00 00       	mov    $0x0,%eax
  80259e:	e9 8b 00 00 00       	jmp    80262e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025a3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025b0:	01 d0                	add    %edx,%eax
  8025b2:	48                   	dec    %eax
  8025b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025be:	f7 75 cc             	divl   -0x34(%ebp)
  8025c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025c4:	29 d0                	sub    %edx,%eax
  8025c6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025de:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	48                   	dec    %eax
  8025ee:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f9:	f7 75 c4             	divl   -0x3c(%ebp)
  8025fc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025ff:	29 d0                	sub    %edx,%eax
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	6a 01                	push   $0x1
  802606:	50                   	push   %eax
  802607:	ff 75 d0             	pushl  -0x30(%ebp)
  80260a:	e8 36 fb ff ff       	call   802145 <set_block_data>
  80260f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802612:	83 ec 0c             	sub    $0xc,%esp
  802615:	ff 75 d0             	pushl  -0x30(%ebp)
  802618:	e8 1b 0a 00 00       	call   803038 <free_block>
  80261d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802620:	83 ec 0c             	sub    $0xc,%esp
  802623:	ff 75 08             	pushl  0x8(%ebp)
  802626:	e8 49 fb ff ff       	call   802174 <alloc_block_FF>
  80262b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	83 e0 01             	and    $0x1,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	74 03                	je     802643 <alloc_block_BF+0x13>
  802640:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802643:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802647:	77 07                	ja     802650 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802649:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802650:	a1 24 50 80 00       	mov    0x805024,%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	75 73                	jne    8026cc <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	83 c0 10             	add    $0x10,%eax
  80265f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802662:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802669:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80266c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266f:	01 d0                	add    %edx,%eax
  802671:	48                   	dec    %eax
  802672:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802678:	ba 00 00 00 00       	mov    $0x0,%edx
  80267d:	f7 75 e0             	divl   -0x20(%ebp)
  802680:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802683:	29 d0                	sub    %edx,%eax
  802685:	c1 e8 0c             	shr    $0xc,%eax
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	50                   	push   %eax
  80268c:	e8 72 ec ff ff       	call   801303 <sbrk>
  802691:	83 c4 10             	add    $0x10,%esp
  802694:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	6a 00                	push   $0x0
  80269c:	e8 62 ec ff ff       	call   801303 <sbrk>
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026aa:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026ad:	83 ec 08             	sub    $0x8,%esp
  8026b0:	50                   	push   %eax
  8026b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8026b4:	e8 9f f8 ff ff       	call   801f58 <initialize_dynamic_allocator>
  8026b9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 63 43 80 00       	push   $0x804363
  8026c4:	e8 a0 de ff ff       	call   800569 <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026da:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f0:	e9 1d 01 00 00       	jmp    802812 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026fb:	83 ec 0c             	sub    $0xc,%esp
  8026fe:	ff 75 a8             	pushl  -0x58(%ebp)
  802701:	e8 ee f6 ff ff       	call   801df4 <get_block_size>
  802706:	83 c4 10             	add    $0x10,%esp
  802709:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	83 c0 08             	add    $0x8,%eax
  802712:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802715:	0f 87 ef 00 00 00    	ja     80280a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	83 c0 18             	add    $0x18,%eax
  802721:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802724:	77 1d                	ja     802743 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802729:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80272c:	0f 86 d8 00 00 00    	jbe    80280a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802732:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802735:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802738:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80273b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80273e:	e9 c7 00 00 00       	jmp    80280a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	83 c0 08             	add    $0x8,%eax
  802749:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80274c:	0f 85 9d 00 00 00    	jne    8027ef <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802752:	83 ec 04             	sub    $0x4,%esp
  802755:	6a 01                	push   $0x1
  802757:	ff 75 a4             	pushl  -0x5c(%ebp)
  80275a:	ff 75 a8             	pushl  -0x58(%ebp)
  80275d:	e8 e3 f9 ff ff       	call   802145 <set_block_data>
  802762:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802765:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802769:	75 17                	jne    802782 <alloc_block_BF+0x152>
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	68 07 43 80 00       	push   $0x804307
  802773:	68 2c 01 00 00       	push   $0x12c
  802778:	68 25 43 80 00       	push   $0x804325
  80277d:	e8 0b 11 00 00       	call   80388d <_panic>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 10                	je     80279b <alloc_block_BF+0x16b>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802793:	8b 52 04             	mov    0x4(%edx),%edx
  802796:	89 50 04             	mov    %edx,0x4(%eax)
  802799:	eb 0b                	jmp    8027a6 <alloc_block_BF+0x176>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 0f                	je     8027bf <alloc_block_BF+0x18f>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b9:	8b 12                	mov    (%edx),%edx
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	eb 0a                	jmp    8027c9 <alloc_block_BF+0x199>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8027e1:	48                   	dec    %eax
  8027e2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027ea:	e9 24 04 00 00       	jmp    802c13 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027f5:	76 13                	jbe    80280a <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027f7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027fe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802801:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802804:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802807:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80280a:	a1 34 50 80 00       	mov    0x805034,%eax
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802816:	74 07                	je     80281f <alloc_block_BF+0x1ef>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	eb 05                	jmp    802824 <alloc_block_BF+0x1f4>
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	a3 34 50 80 00       	mov    %eax,0x805034
  802829:	a1 34 50 80 00       	mov    0x805034,%eax
  80282e:	85 c0                	test   %eax,%eax
  802830:	0f 85 bf fe ff ff    	jne    8026f5 <alloc_block_BF+0xc5>
  802836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283a:	0f 85 b5 fe ff ff    	jne    8026f5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802840:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802844:	0f 84 26 02 00 00    	je     802a70 <alloc_block_BF+0x440>
  80284a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80284e:	0f 85 1c 02 00 00    	jne    802a70 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802857:	2b 45 08             	sub    0x8(%ebp),%eax
  80285a:	83 e8 08             	sub    $0x8,%eax
  80285d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	8d 50 08             	lea    0x8(%eax),%edx
  802866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	83 c0 08             	add    $0x8,%eax
  802874:	83 ec 04             	sub    $0x4,%esp
  802877:	6a 01                	push   $0x1
  802879:	50                   	push   %eax
  80287a:	ff 75 f0             	pushl  -0x10(%ebp)
  80287d:	e8 c3 f8 ff ff       	call   802145 <set_block_data>
  802882:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	75 68                	jne    8028f7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80288f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802893:	75 17                	jne    8028ac <alloc_block_BF+0x27c>
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 40 43 80 00       	push   $0x804340
  80289d:	68 45 01 00 00       	push   $0x145
  8028a2:	68 25 43 80 00       	push   $0x804325
  8028a7:	e8 e1 0f 00 00       	call   80388d <_panic>
  8028ac:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b5:	89 10                	mov    %edx,(%eax)
  8028b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0d                	je     8028cd <alloc_block_BF+0x29d>
  8028c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028c5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028c8:	89 50 04             	mov    %edx,0x4(%eax)
  8028cb:	eb 08                	jmp    8028d5 <alloc_block_BF+0x2a5>
  8028cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8028d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ec:	40                   	inc    %eax
  8028ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8028f2:	e9 dc 00 00 00       	jmp    8029d3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	75 65                	jne    802965 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802900:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802904:	75 17                	jne    80291d <alloc_block_BF+0x2ed>
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 74 43 80 00       	push   $0x804374
  80290e:	68 4a 01 00 00       	push   $0x14a
  802913:	68 25 43 80 00       	push   $0x804325
  802918:	e8 70 0f 00 00       	call   80388d <_panic>
  80291d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802923:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802926:	89 50 04             	mov    %edx,0x4(%eax)
  802929:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 0c                	je     80293f <alloc_block_BF+0x30f>
  802933:	a1 30 50 80 00       	mov    0x805030,%eax
  802938:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80293b:	89 10                	mov    %edx,(%eax)
  80293d:	eb 08                	jmp    802947 <alloc_block_BF+0x317>
  80293f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802942:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802947:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294a:	a3 30 50 80 00       	mov    %eax,0x805030
  80294f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802952:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802958:	a1 38 50 80 00       	mov    0x805038,%eax
  80295d:	40                   	inc    %eax
  80295e:	a3 38 50 80 00       	mov    %eax,0x805038
  802963:	eb 6e                	jmp    8029d3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802965:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802969:	74 06                	je     802971 <alloc_block_BF+0x341>
  80296b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80296f:	75 17                	jne    802988 <alloc_block_BF+0x358>
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	68 98 43 80 00       	push   $0x804398
  802979:	68 4f 01 00 00       	push   $0x14f
  80297e:	68 25 43 80 00       	push   $0x804325
  802983:	e8 05 0f 00 00       	call   80388d <_panic>
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 10                	mov    (%eax),%edx
  80298d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802990:	89 10                	mov    %edx,(%eax)
  802992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	74 0b                	je     8029a6 <alloc_block_BF+0x376>
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ac:	89 10                	mov    %edx,(%eax)
  8029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%eax)
  8029b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	75 08                	jne    8029c8 <alloc_block_BF+0x398>
  8029c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029cd:	40                   	inc    %eax
  8029ce:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d7:	75 17                	jne    8029f0 <alloc_block_BF+0x3c0>
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 07 43 80 00       	push   $0x804307
  8029e1:	68 51 01 00 00       	push   $0x151
  8029e6:	68 25 43 80 00       	push   $0x804325
  8029eb:	e8 9d 0e 00 00       	call   80388d <_panic>
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	8b 00                	mov    (%eax),%eax
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	74 10                	je     802a09 <alloc_block_BF+0x3d9>
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a01:	8b 52 04             	mov    0x4(%edx),%edx
  802a04:	89 50 04             	mov    %edx,0x4(%eax)
  802a07:	eb 0b                	jmp    802a14 <alloc_block_BF+0x3e4>
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 40 04             	mov    0x4(%eax),%eax
  802a0f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	74 0f                	je     802a2d <alloc_block_BF+0x3fd>
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 40 04             	mov    0x4(%eax),%eax
  802a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a27:	8b 12                	mov    (%edx),%edx
  802a29:	89 10                	mov    %edx,(%eax)
  802a2b:	eb 0a                	jmp    802a37 <alloc_block_BF+0x407>
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a4f:	48                   	dec    %eax
  802a50:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	6a 00                	push   $0x0
  802a5a:	ff 75 d0             	pushl  -0x30(%ebp)
  802a5d:	ff 75 cc             	pushl  -0x34(%ebp)
  802a60:	e8 e0 f6 ff ff       	call   802145 <set_block_data>
  802a65:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6b:	e9 a3 01 00 00       	jmp    802c13 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a70:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a74:	0f 85 9d 00 00 00    	jne    802b17 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a7a:	83 ec 04             	sub    $0x4,%esp
  802a7d:	6a 01                	push   $0x1
  802a7f:	ff 75 ec             	pushl  -0x14(%ebp)
  802a82:	ff 75 f0             	pushl  -0x10(%ebp)
  802a85:	e8 bb f6 ff ff       	call   802145 <set_block_data>
  802a8a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a91:	75 17                	jne    802aaa <alloc_block_BF+0x47a>
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	68 07 43 80 00       	push   $0x804307
  802a9b:	68 58 01 00 00       	push   $0x158
  802aa0:	68 25 43 80 00       	push   $0x804325
  802aa5:	e8 e3 0d 00 00       	call   80388d <_panic>
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 10                	je     802ac3 <alloc_block_BF+0x493>
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abb:	8b 52 04             	mov    0x4(%edx),%edx
  802abe:	89 50 04             	mov    %edx,0x4(%eax)
  802ac1:	eb 0b                	jmp    802ace <alloc_block_BF+0x49e>
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	a3 30 50 80 00       	mov    %eax,0x805030
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 40 04             	mov    0x4(%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 0f                	je     802ae7 <alloc_block_BF+0x4b7>
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae1:	8b 12                	mov    (%edx),%edx
  802ae3:	89 10                	mov    %edx,(%eax)
  802ae5:	eb 0a                	jmp    802af1 <alloc_block_BF+0x4c1>
  802ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b04:	a1 38 50 80 00       	mov    0x805038,%eax
  802b09:	48                   	dec    %eax
  802b0a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	e9 fc 00 00 00       	jmp    802c13 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	83 c0 08             	add    $0x8,%eax
  802b1d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b20:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b27:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b2a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b2d:	01 d0                	add    %edx,%eax
  802b2f:	48                   	dec    %eax
  802b30:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b33:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b36:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3b:	f7 75 c4             	divl   -0x3c(%ebp)
  802b3e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b41:	29 d0                	sub    %edx,%eax
  802b43:	c1 e8 0c             	shr    $0xc,%eax
  802b46:	83 ec 0c             	sub    $0xc,%esp
  802b49:	50                   	push   %eax
  802b4a:	e8 b4 e7 ff ff       	call   801303 <sbrk>
  802b4f:	83 c4 10             	add    $0x10,%esp
  802b52:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b55:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b59:	75 0a                	jne    802b65 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b60:	e9 ae 00 00 00       	jmp    802c13 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b65:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b6c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b6f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b72:	01 d0                	add    %edx,%eax
  802b74:	48                   	dec    %eax
  802b75:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b80:	f7 75 b8             	divl   -0x48(%ebp)
  802b83:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b86:	29 d0                	sub    %edx,%eax
  802b88:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b8b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b8e:	01 d0                	add    %edx,%eax
  802b90:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b95:	a1 40 50 80 00       	mov    0x805040,%eax
  802b9a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ba0:	83 ec 0c             	sub    $0xc,%esp
  802ba3:	68 cc 43 80 00       	push   $0x8043cc
  802ba8:	e8 bc d9 ff ff       	call   800569 <cprintf>
  802bad:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802bb0:	83 ec 08             	sub    $0x8,%esp
  802bb3:	ff 75 bc             	pushl  -0x44(%ebp)
  802bb6:	68 d1 43 80 00       	push   $0x8043d1
  802bbb:	e8 a9 d9 ff ff       	call   800569 <cprintf>
  802bc0:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bc3:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bcd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bd0:	01 d0                	add    %edx,%eax
  802bd2:	48                   	dec    %eax
  802bd3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bd6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  802bde:	f7 75 b0             	divl   -0x50(%ebp)
  802be1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802be4:	29 d0                	sub    %edx,%eax
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	6a 01                	push   $0x1
  802beb:	50                   	push   %eax
  802bec:	ff 75 bc             	pushl  -0x44(%ebp)
  802bef:	e8 51 f5 ff ff       	call   802145 <set_block_data>
  802bf4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802bf7:	83 ec 0c             	sub    $0xc,%esp
  802bfa:	ff 75 bc             	pushl  -0x44(%ebp)
  802bfd:	e8 36 04 00 00       	call   803038 <free_block>
  802c02:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c05:	83 ec 0c             	sub    $0xc,%esp
  802c08:	ff 75 08             	pushl  0x8(%ebp)
  802c0b:	e8 20 fa ff ff       	call   802630 <alloc_block_BF>
  802c10:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
  802c18:	53                   	push   %ebx
  802c19:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2e:	74 1e                	je     802c4e <merging+0x39>
  802c30:	ff 75 08             	pushl  0x8(%ebp)
  802c33:	e8 bc f1 ff ff       	call   801df4 <get_block_size>
  802c38:	83 c4 04             	add    $0x4,%esp
  802c3b:	89 c2                	mov    %eax,%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	01 d0                	add    %edx,%eax
  802c42:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c45:	75 07                	jne    802c4e <merging+0x39>
		prev_is_free = 1;
  802c47:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c52:	74 1e                	je     802c72 <merging+0x5d>
  802c54:	ff 75 10             	pushl  0x10(%ebp)
  802c57:	e8 98 f1 ff ff       	call   801df4 <get_block_size>
  802c5c:	83 c4 04             	add    $0x4,%esp
  802c5f:	89 c2                	mov    %eax,%edx
  802c61:	8b 45 10             	mov    0x10(%ebp),%eax
  802c64:	01 d0                	add    %edx,%eax
  802c66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c69:	75 07                	jne    802c72 <merging+0x5d>
		next_is_free = 1;
  802c6b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c76:	0f 84 cc 00 00 00    	je     802d48 <merging+0x133>
  802c7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c80:	0f 84 c2 00 00 00    	je     802d48 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c86:	ff 75 08             	pushl  0x8(%ebp)
  802c89:	e8 66 f1 ff ff       	call   801df4 <get_block_size>
  802c8e:	83 c4 04             	add    $0x4,%esp
  802c91:	89 c3                	mov    %eax,%ebx
  802c93:	ff 75 10             	pushl  0x10(%ebp)
  802c96:	e8 59 f1 ff ff       	call   801df4 <get_block_size>
  802c9b:	83 c4 04             	add    $0x4,%esp
  802c9e:	01 c3                	add    %eax,%ebx
  802ca0:	ff 75 0c             	pushl  0xc(%ebp)
  802ca3:	e8 4c f1 ff ff       	call   801df4 <get_block_size>
  802ca8:	83 c4 04             	add    $0x4,%esp
  802cab:	01 d8                	add    %ebx,%eax
  802cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cb0:	6a 00                	push   $0x0
  802cb2:	ff 75 ec             	pushl  -0x14(%ebp)
  802cb5:	ff 75 08             	pushl  0x8(%ebp)
  802cb8:	e8 88 f4 ff ff       	call   802145 <set_block_data>
  802cbd:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc4:	75 17                	jne    802cdd <merging+0xc8>
  802cc6:	83 ec 04             	sub    $0x4,%esp
  802cc9:	68 07 43 80 00       	push   $0x804307
  802cce:	68 7d 01 00 00       	push   $0x17d
  802cd3:	68 25 43 80 00       	push   $0x804325
  802cd8:	e8 b0 0b 00 00       	call   80388d <_panic>
  802cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 10                	je     802cf6 <merging+0xe1>
  802ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cee:	8b 52 04             	mov    0x4(%edx),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	eb 0b                	jmp    802d01 <merging+0xec>
  802cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	a3 30 50 80 00       	mov    %eax,0x805030
  802d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0f                	je     802d1a <merging+0x105>
  802d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d14:	8b 12                	mov    (%edx),%edx
  802d16:	89 10                	mov    %edx,(%eax)
  802d18:	eb 0a                	jmp    802d24 <merging+0x10f>
  802d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d37:	a1 38 50 80 00       	mov    0x805038,%eax
  802d3c:	48                   	dec    %eax
  802d3d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d42:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d43:	e9 ea 02 00 00       	jmp    803032 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4c:	74 3b                	je     802d89 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d4e:	83 ec 0c             	sub    $0xc,%esp
  802d51:	ff 75 08             	pushl  0x8(%ebp)
  802d54:	e8 9b f0 ff ff       	call   801df4 <get_block_size>
  802d59:	83 c4 10             	add    $0x10,%esp
  802d5c:	89 c3                	mov    %eax,%ebx
  802d5e:	83 ec 0c             	sub    $0xc,%esp
  802d61:	ff 75 10             	pushl  0x10(%ebp)
  802d64:	e8 8b f0 ff ff       	call   801df4 <get_block_size>
  802d69:	83 c4 10             	add    $0x10,%esp
  802d6c:	01 d8                	add    %ebx,%eax
  802d6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d71:	83 ec 04             	sub    $0x4,%esp
  802d74:	6a 00                	push   $0x0
  802d76:	ff 75 e8             	pushl  -0x18(%ebp)
  802d79:	ff 75 08             	pushl  0x8(%ebp)
  802d7c:	e8 c4 f3 ff ff       	call   802145 <set_block_data>
  802d81:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d84:	e9 a9 02 00 00       	jmp    803032 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8d:	0f 84 2d 01 00 00    	je     802ec0 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d93:	83 ec 0c             	sub    $0xc,%esp
  802d96:	ff 75 10             	pushl  0x10(%ebp)
  802d99:	e8 56 f0 ff ff       	call   801df4 <get_block_size>
  802d9e:	83 c4 10             	add    $0x10,%esp
  802da1:	89 c3                	mov    %eax,%ebx
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	ff 75 0c             	pushl  0xc(%ebp)
  802da9:	e8 46 f0 ff ff       	call   801df4 <get_block_size>
  802dae:	83 c4 10             	add    $0x10,%esp
  802db1:	01 d8                	add    %ebx,%eax
  802db3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	6a 00                	push   $0x0
  802dbb:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dbe:	ff 75 10             	pushl  0x10(%ebp)
  802dc1:	e8 7f f3 ff ff       	call   802145 <set_block_data>
  802dc6:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  802dcc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd3:	74 06                	je     802ddb <merging+0x1c6>
  802dd5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dd9:	75 17                	jne    802df2 <merging+0x1dd>
  802ddb:	83 ec 04             	sub    $0x4,%esp
  802dde:	68 e0 43 80 00       	push   $0x8043e0
  802de3:	68 8d 01 00 00       	push   $0x18d
  802de8:	68 25 43 80 00       	push   $0x804325
  802ded:	e8 9b 0a 00 00       	call   80388d <_panic>
  802df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df5:	8b 50 04             	mov    0x4(%eax),%edx
  802df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfb:	89 50 04             	mov    %edx,0x4(%eax)
  802dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0d                	je     802e1d <merging+0x208>
  802e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e19:	89 10                	mov    %edx,(%eax)
  802e1b:	eb 08                	jmp    802e25 <merging+0x210>
  802e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e20:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	a1 38 50 80 00       	mov    0x805038,%eax
  802e33:	40                   	inc    %eax
  802e34:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e3d:	75 17                	jne    802e56 <merging+0x241>
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 07 43 80 00       	push   $0x804307
  802e47:	68 8e 01 00 00       	push   $0x18e
  802e4c:	68 25 43 80 00       	push   $0x804325
  802e51:	e8 37 0a 00 00       	call   80388d <_panic>
  802e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	74 10                	je     802e6f <merging+0x25a>
  802e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e67:	8b 52 04             	mov    0x4(%edx),%edx
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)
  802e6d:	eb 0b                	jmp    802e7a <merging+0x265>
  802e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	a3 30 50 80 00       	mov    %eax,0x805030
  802e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7d:	8b 40 04             	mov    0x4(%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 0f                	je     802e93 <merging+0x27e>
  802e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8d:	8b 12                	mov    (%edx),%edx
  802e8f:	89 10                	mov    %edx,(%eax)
  802e91:	eb 0a                	jmp    802e9d <merging+0x288>
  802e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb0:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb5:	48                   	dec    %eax
  802eb6:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ebb:	e9 72 01 00 00       	jmp    803032 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ec6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eca:	74 79                	je     802f45 <merging+0x330>
  802ecc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ed0:	74 73                	je     802f45 <merging+0x330>
  802ed2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed6:	74 06                	je     802ede <merging+0x2c9>
  802ed8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802edc:	75 17                	jne    802ef5 <merging+0x2e0>
  802ede:	83 ec 04             	sub    $0x4,%esp
  802ee1:	68 98 43 80 00       	push   $0x804398
  802ee6:	68 94 01 00 00       	push   $0x194
  802eeb:	68 25 43 80 00       	push   $0x804325
  802ef0:	e8 98 09 00 00       	call   80388d <_panic>
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 10                	mov    (%eax),%edx
  802efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efd:	89 10                	mov    %edx,(%eax)
  802eff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 0b                	je     802f13 <merging+0x2fe>
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f10:	89 50 04             	mov    %edx,0x4(%eax)
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f19:	89 10                	mov    %edx,(%eax)
  802f1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f21:	89 50 04             	mov    %edx,0x4(%eax)
  802f24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	75 08                	jne    802f35 <merging+0x320>
  802f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f30:	a3 30 50 80 00       	mov    %eax,0x805030
  802f35:	a1 38 50 80 00       	mov    0x805038,%eax
  802f3a:	40                   	inc    %eax
  802f3b:	a3 38 50 80 00       	mov    %eax,0x805038
  802f40:	e9 ce 00 00 00       	jmp    803013 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f49:	74 65                	je     802fb0 <merging+0x39b>
  802f4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f4f:	75 17                	jne    802f68 <merging+0x353>
  802f51:	83 ec 04             	sub    $0x4,%esp
  802f54:	68 74 43 80 00       	push   $0x804374
  802f59:	68 95 01 00 00       	push   $0x195
  802f5e:	68 25 43 80 00       	push   $0x804325
  802f63:	e8 25 09 00 00       	call   80388d <_panic>
  802f68:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f71:	89 50 04             	mov    %edx,0x4(%eax)
  802f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f77:	8b 40 04             	mov    0x4(%eax),%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	74 0c                	je     802f8a <merging+0x375>
  802f7e:	a1 30 50 80 00       	mov    0x805030,%eax
  802f83:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 08                	jmp    802f92 <merging+0x37d>
  802f8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f95:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa8:	40                   	inc    %eax
  802fa9:	a3 38 50 80 00       	mov    %eax,0x805038
  802fae:	eb 63                	jmp    803013 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fb4:	75 17                	jne    802fcd <merging+0x3b8>
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	68 40 43 80 00       	push   $0x804340
  802fbe:	68 98 01 00 00       	push   $0x198
  802fc3:	68 25 43 80 00       	push   $0x804325
  802fc8:	e8 c0 08 00 00       	call   80388d <_panic>
  802fcd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0d                	je     802fee <merging+0x3d9>
  802fe1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fe6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	eb 08                	jmp    802ff6 <merging+0x3e1>
  802fee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ffe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803001:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803008:	a1 38 50 80 00       	mov    0x805038,%eax
  80300d:	40                   	inc    %eax
  80300e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803013:	83 ec 0c             	sub    $0xc,%esp
  803016:	ff 75 10             	pushl  0x10(%ebp)
  803019:	e8 d6 ed ff ff       	call   801df4 <get_block_size>
  80301e:	83 c4 10             	add    $0x10,%esp
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	6a 00                	push   $0x0
  803026:	50                   	push   %eax
  803027:	ff 75 10             	pushl  0x10(%ebp)
  80302a:	e8 16 f1 ff ff       	call   802145 <set_block_data>
  80302f:	83 c4 10             	add    $0x10,%esp
	}
}
  803032:	90                   	nop
  803033:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803036:	c9                   	leave  
  803037:	c3                   	ret    

00803038 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803038:	55                   	push   %ebp
  803039:	89 e5                	mov    %esp,%ebp
  80303b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80303e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803046:	a1 30 50 80 00       	mov    0x805030,%eax
  80304b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304e:	73 1b                	jae    80306b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803050:	a1 30 50 80 00       	mov    0x805030,%eax
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	ff 75 08             	pushl  0x8(%ebp)
  80305b:	6a 00                	push   $0x0
  80305d:	50                   	push   %eax
  80305e:	e8 b2 fb ff ff       	call   802c15 <merging>
  803063:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803066:	e9 8b 00 00 00       	jmp    8030f6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80306b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803070:	3b 45 08             	cmp    0x8(%ebp),%eax
  803073:	76 18                	jbe    80308d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803075:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307a:	83 ec 04             	sub    $0x4,%esp
  80307d:	ff 75 08             	pushl  0x8(%ebp)
  803080:	50                   	push   %eax
  803081:	6a 00                	push   $0x0
  803083:	e8 8d fb ff ff       	call   802c15 <merging>
  803088:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80308b:	eb 69                	jmp    8030f6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80308d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803095:	eb 39                	jmp    8030d0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309d:	73 29                	jae    8030c8 <free_block+0x90>
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a7:	76 1f                	jbe    8030c8 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	ff 75 08             	pushl  0x8(%ebp)
  8030b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8030bd:	e8 53 fb ff ff       	call   802c15 <merging>
  8030c2:	83 c4 10             	add    $0x10,%esp
			break;
  8030c5:	90                   	nop
		}
	}
}
  8030c6:	eb 2e                	jmp    8030f6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030c8:	a1 34 50 80 00       	mov    0x805034,%eax
  8030cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d4:	74 07                	je     8030dd <free_block+0xa5>
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	eb 05                	jmp    8030e2 <free_block+0xaa>
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8030e7:	a1 34 50 80 00       	mov    0x805034,%eax
  8030ec:	85 c0                	test   %eax,%eax
  8030ee:	75 a7                	jne    803097 <free_block+0x5f>
  8030f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f4:	75 a1                	jne    803097 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030f6:	90                   	nop
  8030f7:	c9                   	leave  
  8030f8:	c3                   	ret    

008030f9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
  8030fc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030ff:	ff 75 08             	pushl  0x8(%ebp)
  803102:	e8 ed ec ff ff       	call   801df4 <get_block_size>
  803107:	83 c4 04             	add    $0x4,%esp
  80310a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80310d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803114:	eb 17                	jmp    80312d <copy_data+0x34>
  803116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311c:	01 c2                	add    %eax,%edx
  80311e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	01 c8                	add    %ecx,%eax
  803126:	8a 00                	mov    (%eax),%al
  803128:	88 02                	mov    %al,(%edx)
  80312a:	ff 45 fc             	incl   -0x4(%ebp)
  80312d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803130:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803133:	72 e1                	jb     803116 <copy_data+0x1d>
}
  803135:	90                   	nop
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
  80313b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80313e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803142:	75 23                	jne    803167 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803144:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803148:	74 13                	je     80315d <realloc_block_FF+0x25>
  80314a:	83 ec 0c             	sub    $0xc,%esp
  80314d:	ff 75 0c             	pushl  0xc(%ebp)
  803150:	e8 1f f0 ff ff       	call   802174 <alloc_block_FF>
  803155:	83 c4 10             	add    $0x10,%esp
  803158:	e9 f4 06 00 00       	jmp    803851 <realloc_block_FF+0x719>
		return NULL;
  80315d:	b8 00 00 00 00       	mov    $0x0,%eax
  803162:	e9 ea 06 00 00       	jmp    803851 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803167:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316b:	75 18                	jne    803185 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80316d:	83 ec 0c             	sub    $0xc,%esp
  803170:	ff 75 08             	pushl  0x8(%ebp)
  803173:	e8 c0 fe ff ff       	call   803038 <free_block>
  803178:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80317b:	b8 00 00 00 00       	mov    $0x0,%eax
  803180:	e9 cc 06 00 00       	jmp    803851 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803185:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803189:	77 07                	ja     803192 <realloc_block_FF+0x5a>
  80318b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803192:	8b 45 0c             	mov    0xc(%ebp),%eax
  803195:	83 e0 01             	and    $0x1,%eax
  803198:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319e:	83 c0 08             	add    $0x8,%eax
  8031a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031a4:	83 ec 0c             	sub    $0xc,%esp
  8031a7:	ff 75 08             	pushl  0x8(%ebp)
  8031aa:	e8 45 ec ff ff       	call   801df4 <get_block_size>
  8031af:	83 c4 10             	add    $0x10,%esp
  8031b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b8:	83 e8 08             	sub    $0x8,%eax
  8031bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	83 e8 04             	sub    $0x4,%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	83 e0 fe             	and    $0xfffffffe,%eax
  8031c9:	89 c2                	mov    %eax,%edx
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	01 d0                	add    %edx,%eax
  8031d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031d3:	83 ec 0c             	sub    $0xc,%esp
  8031d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031d9:	e8 16 ec ff ff       	call   801df4 <get_block_size>
  8031de:	83 c4 10             	add    $0x10,%esp
  8031e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e7:	83 e8 08             	sub    $0x8,%eax
  8031ea:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031f3:	75 08                	jne    8031fd <realloc_block_FF+0xc5>
	{
		 return va;
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	e9 54 06 00 00       	jmp    803851 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803200:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803203:	0f 83 e5 03 00 00    	jae    8035ee <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80320f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803212:	83 ec 0c             	sub    $0xc,%esp
  803215:	ff 75 e4             	pushl  -0x1c(%ebp)
  803218:	e8 f0 eb ff ff       	call   801e0d <is_free_block>
  80321d:	83 c4 10             	add    $0x10,%esp
  803220:	84 c0                	test   %al,%al
  803222:	0f 84 3b 01 00 00    	je     803363 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803228:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80322b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80322e:	01 d0                	add    %edx,%eax
  803230:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	6a 01                	push   $0x1
  803238:	ff 75 f0             	pushl  -0x10(%ebp)
  80323b:	ff 75 08             	pushl  0x8(%ebp)
  80323e:	e8 02 ef ff ff       	call   802145 <set_block_data>
  803243:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	83 e8 04             	sub    $0x4,%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	83 e0 fe             	and    $0xfffffffe,%eax
  803251:	89 c2                	mov    %eax,%edx
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	01 d0                	add    %edx,%eax
  803258:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80325b:	83 ec 04             	sub    $0x4,%esp
  80325e:	6a 00                	push   $0x0
  803260:	ff 75 cc             	pushl  -0x34(%ebp)
  803263:	ff 75 c8             	pushl  -0x38(%ebp)
  803266:	e8 da ee ff ff       	call   802145 <set_block_data>
  80326b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80326e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803272:	74 06                	je     80327a <realloc_block_FF+0x142>
  803274:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803278:	75 17                	jne    803291 <realloc_block_FF+0x159>
  80327a:	83 ec 04             	sub    $0x4,%esp
  80327d:	68 98 43 80 00       	push   $0x804398
  803282:	68 f6 01 00 00       	push   $0x1f6
  803287:	68 25 43 80 00       	push   $0x804325
  80328c:	e8 fc 05 00 00       	call   80388d <_panic>
  803291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803294:	8b 10                	mov    (%eax),%edx
  803296:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803299:	89 10                	mov    %edx,(%eax)
  80329b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80329e:	8b 00                	mov    (%eax),%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	74 0b                	je     8032af <realloc_block_FF+0x177>
  8032a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ac:	89 50 04             	mov    %edx,0x4(%eax)
  8032af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	75 08                	jne    8032d1 <realloc_block_FF+0x199>
  8032c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d6:	40                   	inc    %eax
  8032d7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032e0:	75 17                	jne    8032f9 <realloc_block_FF+0x1c1>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 07 43 80 00       	push   $0x804307
  8032ea:	68 f7 01 00 00       	push   $0x1f7
  8032ef:	68 25 43 80 00       	push   $0x804325
  8032f4:	e8 94 05 00 00       	call   80388d <_panic>
  8032f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 10                	je     803312 <realloc_block_FF+0x1da>
  803302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80330a:	8b 52 04             	mov    0x4(%edx),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	eb 0b                	jmp    80331d <realloc_block_FF+0x1e5>
  803312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	a3 30 50 80 00       	mov    %eax,0x805030
  80331d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803320:	8b 40 04             	mov    0x4(%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0f                	je     803336 <realloc_block_FF+0x1fe>
  803327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332a:	8b 40 04             	mov    0x4(%eax),%eax
  80332d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803330:	8b 12                	mov    (%edx),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	eb 0a                	jmp    803340 <realloc_block_FF+0x208>
  803336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803353:	a1 38 50 80 00       	mov    0x805038,%eax
  803358:	48                   	dec    %eax
  803359:	a3 38 50 80 00       	mov    %eax,0x805038
  80335e:	e9 83 02 00 00       	jmp    8035e6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803363:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803367:	0f 86 69 02 00 00    	jbe    8035d6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	6a 01                	push   $0x1
  803372:	ff 75 f0             	pushl  -0x10(%ebp)
  803375:	ff 75 08             	pushl  0x8(%ebp)
  803378:	e8 c8 ed ff ff       	call   802145 <set_block_data>
  80337d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	83 e8 04             	sub    $0x4,%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	83 e0 fe             	and    $0xfffffffe,%eax
  80338b:	89 c2                	mov    %eax,%edx
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	01 d0                	add    %edx,%eax
  803392:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803395:	a1 38 50 80 00       	mov    0x805038,%eax
  80339a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80339d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033a1:	75 68                	jne    80340b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033a7:	75 17                	jne    8033c0 <realloc_block_FF+0x288>
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	68 40 43 80 00       	push   $0x804340
  8033b1:	68 06 02 00 00       	push   $0x206
  8033b6:	68 25 43 80 00       	push   $0x804325
  8033bb:	e8 cd 04 00 00       	call   80388d <_panic>
  8033c0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	74 0d                	je     8033e1 <realloc_block_FF+0x2a9>
  8033d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033dc:	89 50 04             	mov    %edx,0x4(%eax)
  8033df:	eb 08                	jmp    8033e9 <realloc_block_FF+0x2b1>
  8033e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803400:	40                   	inc    %eax
  803401:	a3 38 50 80 00       	mov    %eax,0x805038
  803406:	e9 b0 01 00 00       	jmp    8035bb <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80340b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803410:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803413:	76 68                	jbe    80347d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803415:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803419:	75 17                	jne    803432 <realloc_block_FF+0x2fa>
  80341b:	83 ec 04             	sub    $0x4,%esp
  80341e:	68 40 43 80 00       	push   $0x804340
  803423:	68 0b 02 00 00       	push   $0x20b
  803428:	68 25 43 80 00       	push   $0x804325
  80342d:	e8 5b 04 00 00       	call   80388d <_panic>
  803432:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803438:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343b:	89 10                	mov    %edx,(%eax)
  80343d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 0d                	je     803453 <realloc_block_FF+0x31b>
  803446:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80344b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80344e:	89 50 04             	mov    %edx,0x4(%eax)
  803451:	eb 08                	jmp    80345b <realloc_block_FF+0x323>
  803453:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803456:	a3 30 50 80 00       	mov    %eax,0x805030
  80345b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803463:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803466:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346d:	a1 38 50 80 00       	mov    0x805038,%eax
  803472:	40                   	inc    %eax
  803473:	a3 38 50 80 00       	mov    %eax,0x805038
  803478:	e9 3e 01 00 00       	jmp    8035bb <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80347d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803482:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803485:	73 68                	jae    8034ef <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803487:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80348b:	75 17                	jne    8034a4 <realloc_block_FF+0x36c>
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	68 74 43 80 00       	push   $0x804374
  803495:	68 10 02 00 00       	push   $0x210
  80349a:	68 25 43 80 00       	push   $0x804325
  80349f:	e8 e9 03 00 00       	call   80388d <_panic>
  8034a4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ad:	89 50 04             	mov    %edx,0x4(%eax)
  8034b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b3:	8b 40 04             	mov    0x4(%eax),%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 0c                	je     8034c6 <realloc_block_FF+0x38e>
  8034ba:	a1 30 50 80 00       	mov    0x805030,%eax
  8034bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034c2:	89 10                	mov    %edx,(%eax)
  8034c4:	eb 08                	jmp    8034ce <realloc_block_FF+0x396>
  8034c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034df:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e4:	40                   	inc    %eax
  8034e5:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ea:	e9 cc 00 00 00       	jmp    8035bb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034f6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034fe:	e9 8a 00 00 00       	jmp    80358d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803509:	73 7a                	jae    803585 <realloc_block_FF+0x44d>
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803513:	73 70                	jae    803585 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803519:	74 06                	je     803521 <realloc_block_FF+0x3e9>
  80351b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80351f:	75 17                	jne    803538 <realloc_block_FF+0x400>
  803521:	83 ec 04             	sub    $0x4,%esp
  803524:	68 98 43 80 00       	push   $0x804398
  803529:	68 1a 02 00 00       	push   $0x21a
  80352e:	68 25 43 80 00       	push   $0x804325
  803533:	e8 55 03 00 00       	call   80388d <_panic>
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	8b 10                	mov    (%eax),%edx
  80353d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803540:	89 10                	mov    %edx,(%eax)
  803542:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	85 c0                	test   %eax,%eax
  803549:	74 0b                	je     803556 <realloc_block_FF+0x41e>
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	8b 00                	mov    (%eax),%eax
  803550:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803553:	89 50 04             	mov    %edx,0x4(%eax)
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355c:	89 10                	mov    %edx,(%eax)
  80355e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803564:	89 50 04             	mov    %edx,0x4(%eax)
  803567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	85 c0                	test   %eax,%eax
  80356e:	75 08                	jne    803578 <realloc_block_FF+0x440>
  803570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803573:	a3 30 50 80 00       	mov    %eax,0x805030
  803578:	a1 38 50 80 00       	mov    0x805038,%eax
  80357d:	40                   	inc    %eax
  80357e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803583:	eb 36                	jmp    8035bb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803585:	a1 34 50 80 00       	mov    0x805034,%eax
  80358a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80358d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803591:	74 07                	je     80359a <realloc_block_FF+0x462>
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	eb 05                	jmp    80359f <realloc_block_FF+0x467>
  80359a:	b8 00 00 00 00       	mov    $0x0,%eax
  80359f:	a3 34 50 80 00       	mov    %eax,0x805034
  8035a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	0f 85 52 ff ff ff    	jne    803503 <realloc_block_FF+0x3cb>
  8035b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b5:	0f 85 48 ff ff ff    	jne    803503 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035bb:	83 ec 04             	sub    $0x4,%esp
  8035be:	6a 00                	push   $0x0
  8035c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8035c3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035c6:	e8 7a eb ff ff       	call   802145 <set_block_data>
  8035cb:	83 c4 10             	add    $0x10,%esp
				return va;
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	e9 7b 02 00 00       	jmp    803851 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035d6:	83 ec 0c             	sub    $0xc,%esp
  8035d9:	68 15 44 80 00       	push   $0x804415
  8035de:	e8 86 cf ff ff       	call   800569 <cprintf>
  8035e3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	e9 63 02 00 00       	jmp    803851 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035f4:	0f 86 4d 02 00 00    	jbe    803847 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035fa:	83 ec 0c             	sub    $0xc,%esp
  8035fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  803600:	e8 08 e8 ff ff       	call   801e0d <is_free_block>
  803605:	83 c4 10             	add    $0x10,%esp
  803608:	84 c0                	test   %al,%al
  80360a:	0f 84 37 02 00 00    	je     803847 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803610:	8b 45 0c             	mov    0xc(%ebp),%eax
  803613:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803616:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803619:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80361c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80361f:	76 38                	jbe    803659 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803621:	83 ec 0c             	sub    $0xc,%esp
  803624:	ff 75 08             	pushl  0x8(%ebp)
  803627:	e8 0c fa ff ff       	call   803038 <free_block>
  80362c:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80362f:	83 ec 0c             	sub    $0xc,%esp
  803632:	ff 75 0c             	pushl  0xc(%ebp)
  803635:	e8 3a eb ff ff       	call   802174 <alloc_block_FF>
  80363a:	83 c4 10             	add    $0x10,%esp
  80363d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803640:	83 ec 08             	sub    $0x8,%esp
  803643:	ff 75 c0             	pushl  -0x40(%ebp)
  803646:	ff 75 08             	pushl  0x8(%ebp)
  803649:	e8 ab fa ff ff       	call   8030f9 <copy_data>
  80364e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803651:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803654:	e9 f8 01 00 00       	jmp    803851 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80365f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803662:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803666:	0f 87 a0 00 00 00    	ja     80370c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80366c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803670:	75 17                	jne    803689 <realloc_block_FF+0x551>
  803672:	83 ec 04             	sub    $0x4,%esp
  803675:	68 07 43 80 00       	push   $0x804307
  80367a:	68 38 02 00 00       	push   $0x238
  80367f:	68 25 43 80 00       	push   $0x804325
  803684:	e8 04 02 00 00       	call   80388d <_panic>
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	85 c0                	test   %eax,%eax
  803690:	74 10                	je     8036a2 <realloc_block_FF+0x56a>
  803692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80369a:	8b 52 04             	mov    0x4(%edx),%edx
  80369d:	89 50 04             	mov    %edx,0x4(%eax)
  8036a0:	eb 0b                	jmp    8036ad <realloc_block_FF+0x575>
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	8b 40 04             	mov    0x4(%eax),%eax
  8036a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b0:	8b 40 04             	mov    0x4(%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 0f                	je     8036c6 <realloc_block_FF+0x58e>
  8036b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ba:	8b 40 04             	mov    0x4(%eax),%eax
  8036bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c0:	8b 12                	mov    (%edx),%edx
  8036c2:	89 10                	mov    %edx,(%eax)
  8036c4:	eb 0a                	jmp    8036d0 <realloc_block_FF+0x598>
  8036c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c9:	8b 00                	mov    (%eax),%eax
  8036cb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e8:	48                   	dec    %eax
  8036e9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f4:	01 d0                	add    %edx,%eax
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	6a 01                	push   $0x1
  8036fb:	50                   	push   %eax
  8036fc:	ff 75 08             	pushl  0x8(%ebp)
  8036ff:	e8 41 ea ff ff       	call   802145 <set_block_data>
  803704:	83 c4 10             	add    $0x10,%esp
  803707:	e9 36 01 00 00       	jmp    803842 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80370c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80370f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803712:	01 d0                	add    %edx,%eax
  803714:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803717:	83 ec 04             	sub    $0x4,%esp
  80371a:	6a 01                	push   $0x1
  80371c:	ff 75 f0             	pushl  -0x10(%ebp)
  80371f:	ff 75 08             	pushl  0x8(%ebp)
  803722:	e8 1e ea ff ff       	call   802145 <set_block_data>
  803727:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	83 e8 04             	sub    $0x4,%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	83 e0 fe             	and    $0xfffffffe,%eax
  803735:	89 c2                	mov    %eax,%edx
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	01 d0                	add    %edx,%eax
  80373c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80373f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803743:	74 06                	je     80374b <realloc_block_FF+0x613>
  803745:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803749:	75 17                	jne    803762 <realloc_block_FF+0x62a>
  80374b:	83 ec 04             	sub    $0x4,%esp
  80374e:	68 98 43 80 00       	push   $0x804398
  803753:	68 44 02 00 00       	push   $0x244
  803758:	68 25 43 80 00       	push   $0x804325
  80375d:	e8 2b 01 00 00       	call   80388d <_panic>
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	8b 10                	mov    (%eax),%edx
  803767:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80376a:	89 10                	mov    %edx,(%eax)
  80376c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	85 c0                	test   %eax,%eax
  803773:	74 0b                	je     803780 <realloc_block_FF+0x648>
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80377d:	89 50 04             	mov    %edx,0x4(%eax)
  803780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803783:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803786:	89 10                	mov    %edx,(%eax)
  803788:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80378b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80378e:	89 50 04             	mov    %edx,0x4(%eax)
  803791:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803794:	8b 00                	mov    (%eax),%eax
  803796:	85 c0                	test   %eax,%eax
  803798:	75 08                	jne    8037a2 <realloc_block_FF+0x66a>
  80379a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379d:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a7:	40                   	inc    %eax
  8037a8:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b1:	75 17                	jne    8037ca <realloc_block_FF+0x692>
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 07 43 80 00       	push   $0x804307
  8037bb:	68 45 02 00 00       	push   $0x245
  8037c0:	68 25 43 80 00       	push   $0x804325
  8037c5:	e8 c3 00 00 00       	call   80388d <_panic>
  8037ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	74 10                	je     8037e3 <realloc_block_FF+0x6ab>
  8037d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037db:	8b 52 04             	mov    0x4(%edx),%edx
  8037de:	89 50 04             	mov    %edx,0x4(%eax)
  8037e1:	eb 0b                	jmp    8037ee <realloc_block_FF+0x6b6>
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 40 04             	mov    0x4(%eax),%eax
  8037e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8037ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f1:	8b 40 04             	mov    0x4(%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0f                	je     803807 <realloc_block_FF+0x6cf>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803801:	8b 12                	mov    (%edx),%edx
  803803:	89 10                	mov    %edx,(%eax)
  803805:	eb 0a                	jmp    803811 <realloc_block_FF+0x6d9>
  803807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803824:	a1 38 50 80 00       	mov    0x805038,%eax
  803829:	48                   	dec    %eax
  80382a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80382f:	83 ec 04             	sub    $0x4,%esp
  803832:	6a 00                	push   $0x0
  803834:	ff 75 bc             	pushl  -0x44(%ebp)
  803837:	ff 75 b8             	pushl  -0x48(%ebp)
  80383a:	e8 06 e9 ff ff       	call   802145 <set_block_data>
  80383f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	eb 0a                	jmp    803851 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803847:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803851:	c9                   	leave  
  803852:	c3                   	ret    

00803853 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803853:	55                   	push   %ebp
  803854:	89 e5                	mov    %esp,%ebp
  803856:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 1c 44 80 00       	push   $0x80441c
  803861:	68 58 02 00 00       	push   $0x258
  803866:	68 25 43 80 00       	push   $0x804325
  80386b:	e8 1d 00 00 00       	call   80388d <_panic>

00803870 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803870:	55                   	push   %ebp
  803871:	89 e5                	mov    %esp,%ebp
  803873:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803876:	83 ec 04             	sub    $0x4,%esp
  803879:	68 44 44 80 00       	push   $0x804444
  80387e:	68 61 02 00 00       	push   $0x261
  803883:	68 25 43 80 00       	push   $0x804325
  803888:	e8 00 00 00 00       	call   80388d <_panic>

0080388d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80388d:	55                   	push   %ebp
  80388e:	89 e5                	mov    %esp,%ebp
  803890:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803893:	8d 45 10             	lea    0x10(%ebp),%eax
  803896:	83 c0 04             	add    $0x4,%eax
  803899:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80389c:	a1 60 50 90 00       	mov    0x905060,%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 16                	je     8038bb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8038a5:	a1 60 50 90 00       	mov    0x905060,%eax
  8038aa:	83 ec 08             	sub    $0x8,%esp
  8038ad:	50                   	push   %eax
  8038ae:	68 6c 44 80 00       	push   $0x80446c
  8038b3:	e8 b1 cc ff ff       	call   800569 <cprintf>
  8038b8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8038bb:	a1 00 50 80 00       	mov    0x805000,%eax
  8038c0:	ff 75 0c             	pushl  0xc(%ebp)
  8038c3:	ff 75 08             	pushl  0x8(%ebp)
  8038c6:	50                   	push   %eax
  8038c7:	68 71 44 80 00       	push   $0x804471
  8038cc:	e8 98 cc ff ff       	call   800569 <cprintf>
  8038d1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8038d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8038d7:	83 ec 08             	sub    $0x8,%esp
  8038da:	ff 75 f4             	pushl  -0xc(%ebp)
  8038dd:	50                   	push   %eax
  8038de:	e8 1b cc ff ff       	call   8004fe <vcprintf>
  8038e3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8038e6:	83 ec 08             	sub    $0x8,%esp
  8038e9:	6a 00                	push   $0x0
  8038eb:	68 8d 44 80 00       	push   $0x80448d
  8038f0:	e8 09 cc ff ff       	call   8004fe <vcprintf>
  8038f5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8038f8:	e8 8a cb ff ff       	call   800487 <exit>

	// should not return here
	while (1) ;
  8038fd:	eb fe                	jmp    8038fd <_panic+0x70>

008038ff <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8038ff:	55                   	push   %ebp
  803900:	89 e5                	mov    %esp,%ebp
  803902:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803905:	a1 20 50 80 00       	mov    0x805020,%eax
  80390a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803910:	8b 45 0c             	mov    0xc(%ebp),%eax
  803913:	39 c2                	cmp    %eax,%edx
  803915:	74 14                	je     80392b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803917:	83 ec 04             	sub    $0x4,%esp
  80391a:	68 90 44 80 00       	push   $0x804490
  80391f:	6a 26                	push   $0x26
  803921:	68 dc 44 80 00       	push   $0x8044dc
  803926:	e8 62 ff ff ff       	call   80388d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80392b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803939:	e9 c5 00 00 00       	jmp    803a03 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80393e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803941:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	01 d0                	add    %edx,%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	85 c0                	test   %eax,%eax
  803951:	75 08                	jne    80395b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803953:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803956:	e9 a5 00 00 00       	jmp    803a00 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80395b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803962:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803969:	eb 69                	jmp    8039d4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80396b:	a1 20 50 80 00       	mov    0x805020,%eax
  803970:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803976:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803979:	89 d0                	mov    %edx,%eax
  80397b:	01 c0                	add    %eax,%eax
  80397d:	01 d0                	add    %edx,%eax
  80397f:	c1 e0 03             	shl    $0x3,%eax
  803982:	01 c8                	add    %ecx,%eax
  803984:	8a 40 04             	mov    0x4(%eax),%al
  803987:	84 c0                	test   %al,%al
  803989:	75 46                	jne    8039d1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80398b:	a1 20 50 80 00       	mov    0x805020,%eax
  803990:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803996:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803999:	89 d0                	mov    %edx,%eax
  80399b:	01 c0                	add    %eax,%eax
  80399d:	01 d0                	add    %edx,%eax
  80399f:	c1 e0 03             	shl    $0x3,%eax
  8039a2:	01 c8                	add    %ecx,%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8039a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8039b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8039bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c0:	01 c8                	add    %ecx,%eax
  8039c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039c4:	39 c2                	cmp    %eax,%edx
  8039c6:	75 09                	jne    8039d1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8039c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8039cf:	eb 15                	jmp    8039e6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039d1:	ff 45 e8             	incl   -0x18(%ebp)
  8039d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e2:	39 c2                	cmp    %eax,%edx
  8039e4:	77 85                	ja     80396b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8039e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039ea:	75 14                	jne    803a00 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 e8 44 80 00       	push   $0x8044e8
  8039f4:	6a 3a                	push   $0x3a
  8039f6:	68 dc 44 80 00       	push   $0x8044dc
  8039fb:	e8 8d fe ff ff       	call   80388d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a00:	ff 45 f0             	incl   -0x10(%ebp)
  803a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a06:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a09:	0f 8c 2f ff ff ff    	jl     80393e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a0f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a1d:	eb 26                	jmp    803a45 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a1f:	a1 20 50 80 00       	mov    0x805020,%eax
  803a24:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a2d:	89 d0                	mov    %edx,%eax
  803a2f:	01 c0                	add    %eax,%eax
  803a31:	01 d0                	add    %edx,%eax
  803a33:	c1 e0 03             	shl    $0x3,%eax
  803a36:	01 c8                	add    %ecx,%eax
  803a38:	8a 40 04             	mov    0x4(%eax),%al
  803a3b:	3c 01                	cmp    $0x1,%al
  803a3d:	75 03                	jne    803a42 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a3f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a42:	ff 45 e0             	incl   -0x20(%ebp)
  803a45:	a1 20 50 80 00       	mov    0x805020,%eax
  803a4a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a53:	39 c2                	cmp    %eax,%edx
  803a55:	77 c8                	ja     803a1f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a5d:	74 14                	je     803a73 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a5f:	83 ec 04             	sub    $0x4,%esp
  803a62:	68 3c 45 80 00       	push   $0x80453c
  803a67:	6a 44                	push   $0x44
  803a69:	68 dc 44 80 00       	push   $0x8044dc
  803a6e:	e8 1a fe ff ff       	call   80388d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a73:	90                   	nop
  803a74:	c9                   	leave  
  803a75:	c3                   	ret    
  803a76:	66 90                	xchg   %ax,%ax

00803a78 <__udivdi3>:
  803a78:	55                   	push   %ebp
  803a79:	57                   	push   %edi
  803a7a:	56                   	push   %esi
  803a7b:	53                   	push   %ebx
  803a7c:	83 ec 1c             	sub    $0x1c,%esp
  803a7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a8f:	89 ca                	mov    %ecx,%edx
  803a91:	89 f8                	mov    %edi,%eax
  803a93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a97:	85 f6                	test   %esi,%esi
  803a99:	75 2d                	jne    803ac8 <__udivdi3+0x50>
  803a9b:	39 cf                	cmp    %ecx,%edi
  803a9d:	77 65                	ja     803b04 <__udivdi3+0x8c>
  803a9f:	89 fd                	mov    %edi,%ebp
  803aa1:	85 ff                	test   %edi,%edi
  803aa3:	75 0b                	jne    803ab0 <__udivdi3+0x38>
  803aa5:	b8 01 00 00 00       	mov    $0x1,%eax
  803aaa:	31 d2                	xor    %edx,%edx
  803aac:	f7 f7                	div    %edi
  803aae:	89 c5                	mov    %eax,%ebp
  803ab0:	31 d2                	xor    %edx,%edx
  803ab2:	89 c8                	mov    %ecx,%eax
  803ab4:	f7 f5                	div    %ebp
  803ab6:	89 c1                	mov    %eax,%ecx
  803ab8:	89 d8                	mov    %ebx,%eax
  803aba:	f7 f5                	div    %ebp
  803abc:	89 cf                	mov    %ecx,%edi
  803abe:	89 fa                	mov    %edi,%edx
  803ac0:	83 c4 1c             	add    $0x1c,%esp
  803ac3:	5b                   	pop    %ebx
  803ac4:	5e                   	pop    %esi
  803ac5:	5f                   	pop    %edi
  803ac6:	5d                   	pop    %ebp
  803ac7:	c3                   	ret    
  803ac8:	39 ce                	cmp    %ecx,%esi
  803aca:	77 28                	ja     803af4 <__udivdi3+0x7c>
  803acc:	0f bd fe             	bsr    %esi,%edi
  803acf:	83 f7 1f             	xor    $0x1f,%edi
  803ad2:	75 40                	jne    803b14 <__udivdi3+0x9c>
  803ad4:	39 ce                	cmp    %ecx,%esi
  803ad6:	72 0a                	jb     803ae2 <__udivdi3+0x6a>
  803ad8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803adc:	0f 87 9e 00 00 00    	ja     803b80 <__udivdi3+0x108>
  803ae2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ae7:	89 fa                	mov    %edi,%edx
  803ae9:	83 c4 1c             	add    $0x1c,%esp
  803aec:	5b                   	pop    %ebx
  803aed:	5e                   	pop    %esi
  803aee:	5f                   	pop    %edi
  803aef:	5d                   	pop    %ebp
  803af0:	c3                   	ret    
  803af1:	8d 76 00             	lea    0x0(%esi),%esi
  803af4:	31 ff                	xor    %edi,%edi
  803af6:	31 c0                	xor    %eax,%eax
  803af8:	89 fa                	mov    %edi,%edx
  803afa:	83 c4 1c             	add    $0x1c,%esp
  803afd:	5b                   	pop    %ebx
  803afe:	5e                   	pop    %esi
  803aff:	5f                   	pop    %edi
  803b00:	5d                   	pop    %ebp
  803b01:	c3                   	ret    
  803b02:	66 90                	xchg   %ax,%ax
  803b04:	89 d8                	mov    %ebx,%eax
  803b06:	f7 f7                	div    %edi
  803b08:	31 ff                	xor    %edi,%edi
  803b0a:	89 fa                	mov    %edi,%edx
  803b0c:	83 c4 1c             	add    $0x1c,%esp
  803b0f:	5b                   	pop    %ebx
  803b10:	5e                   	pop    %esi
  803b11:	5f                   	pop    %edi
  803b12:	5d                   	pop    %ebp
  803b13:	c3                   	ret    
  803b14:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b19:	89 eb                	mov    %ebp,%ebx
  803b1b:	29 fb                	sub    %edi,%ebx
  803b1d:	89 f9                	mov    %edi,%ecx
  803b1f:	d3 e6                	shl    %cl,%esi
  803b21:	89 c5                	mov    %eax,%ebp
  803b23:	88 d9                	mov    %bl,%cl
  803b25:	d3 ed                	shr    %cl,%ebp
  803b27:	89 e9                	mov    %ebp,%ecx
  803b29:	09 f1                	or     %esi,%ecx
  803b2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b2f:	89 f9                	mov    %edi,%ecx
  803b31:	d3 e0                	shl    %cl,%eax
  803b33:	89 c5                	mov    %eax,%ebp
  803b35:	89 d6                	mov    %edx,%esi
  803b37:	88 d9                	mov    %bl,%cl
  803b39:	d3 ee                	shr    %cl,%esi
  803b3b:	89 f9                	mov    %edi,%ecx
  803b3d:	d3 e2                	shl    %cl,%edx
  803b3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b43:	88 d9                	mov    %bl,%cl
  803b45:	d3 e8                	shr    %cl,%eax
  803b47:	09 c2                	or     %eax,%edx
  803b49:	89 d0                	mov    %edx,%eax
  803b4b:	89 f2                	mov    %esi,%edx
  803b4d:	f7 74 24 0c          	divl   0xc(%esp)
  803b51:	89 d6                	mov    %edx,%esi
  803b53:	89 c3                	mov    %eax,%ebx
  803b55:	f7 e5                	mul    %ebp
  803b57:	39 d6                	cmp    %edx,%esi
  803b59:	72 19                	jb     803b74 <__udivdi3+0xfc>
  803b5b:	74 0b                	je     803b68 <__udivdi3+0xf0>
  803b5d:	89 d8                	mov    %ebx,%eax
  803b5f:	31 ff                	xor    %edi,%edi
  803b61:	e9 58 ff ff ff       	jmp    803abe <__udivdi3+0x46>
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b6c:	89 f9                	mov    %edi,%ecx
  803b6e:	d3 e2                	shl    %cl,%edx
  803b70:	39 c2                	cmp    %eax,%edx
  803b72:	73 e9                	jae    803b5d <__udivdi3+0xe5>
  803b74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b77:	31 ff                	xor    %edi,%edi
  803b79:	e9 40 ff ff ff       	jmp    803abe <__udivdi3+0x46>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	31 c0                	xor    %eax,%eax
  803b82:	e9 37 ff ff ff       	jmp    803abe <__udivdi3+0x46>
  803b87:	90                   	nop

00803b88 <__umoddi3>:
  803b88:	55                   	push   %ebp
  803b89:	57                   	push   %edi
  803b8a:	56                   	push   %esi
  803b8b:	53                   	push   %ebx
  803b8c:	83 ec 1c             	sub    $0x1c,%esp
  803b8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b93:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ba3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ba7:	89 f3                	mov    %esi,%ebx
  803ba9:	89 fa                	mov    %edi,%edx
  803bab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803baf:	89 34 24             	mov    %esi,(%esp)
  803bb2:	85 c0                	test   %eax,%eax
  803bb4:	75 1a                	jne    803bd0 <__umoddi3+0x48>
  803bb6:	39 f7                	cmp    %esi,%edi
  803bb8:	0f 86 a2 00 00 00    	jbe    803c60 <__umoddi3+0xd8>
  803bbe:	89 c8                	mov    %ecx,%eax
  803bc0:	89 f2                	mov    %esi,%edx
  803bc2:	f7 f7                	div    %edi
  803bc4:	89 d0                	mov    %edx,%eax
  803bc6:	31 d2                	xor    %edx,%edx
  803bc8:	83 c4 1c             	add    $0x1c,%esp
  803bcb:	5b                   	pop    %ebx
  803bcc:	5e                   	pop    %esi
  803bcd:	5f                   	pop    %edi
  803bce:	5d                   	pop    %ebp
  803bcf:	c3                   	ret    
  803bd0:	39 f0                	cmp    %esi,%eax
  803bd2:	0f 87 ac 00 00 00    	ja     803c84 <__umoddi3+0xfc>
  803bd8:	0f bd e8             	bsr    %eax,%ebp
  803bdb:	83 f5 1f             	xor    $0x1f,%ebp
  803bde:	0f 84 ac 00 00 00    	je     803c90 <__umoddi3+0x108>
  803be4:	bf 20 00 00 00       	mov    $0x20,%edi
  803be9:	29 ef                	sub    %ebp,%edi
  803beb:	89 fe                	mov    %edi,%esi
  803bed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bf1:	89 e9                	mov    %ebp,%ecx
  803bf3:	d3 e0                	shl    %cl,%eax
  803bf5:	89 d7                	mov    %edx,%edi
  803bf7:	89 f1                	mov    %esi,%ecx
  803bf9:	d3 ef                	shr    %cl,%edi
  803bfb:	09 c7                	or     %eax,%edi
  803bfd:	89 e9                	mov    %ebp,%ecx
  803bff:	d3 e2                	shl    %cl,%edx
  803c01:	89 14 24             	mov    %edx,(%esp)
  803c04:	89 d8                	mov    %ebx,%eax
  803c06:	d3 e0                	shl    %cl,%eax
  803c08:	89 c2                	mov    %eax,%edx
  803c0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c0e:	d3 e0                	shl    %cl,%eax
  803c10:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c14:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c18:	89 f1                	mov    %esi,%ecx
  803c1a:	d3 e8                	shr    %cl,%eax
  803c1c:	09 d0                	or     %edx,%eax
  803c1e:	d3 eb                	shr    %cl,%ebx
  803c20:	89 da                	mov    %ebx,%edx
  803c22:	f7 f7                	div    %edi
  803c24:	89 d3                	mov    %edx,%ebx
  803c26:	f7 24 24             	mull   (%esp)
  803c29:	89 c6                	mov    %eax,%esi
  803c2b:	89 d1                	mov    %edx,%ecx
  803c2d:	39 d3                	cmp    %edx,%ebx
  803c2f:	0f 82 87 00 00 00    	jb     803cbc <__umoddi3+0x134>
  803c35:	0f 84 91 00 00 00    	je     803ccc <__umoddi3+0x144>
  803c3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c3f:	29 f2                	sub    %esi,%edx
  803c41:	19 cb                	sbb    %ecx,%ebx
  803c43:	89 d8                	mov    %ebx,%eax
  803c45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c49:	d3 e0                	shl    %cl,%eax
  803c4b:	89 e9                	mov    %ebp,%ecx
  803c4d:	d3 ea                	shr    %cl,%edx
  803c4f:	09 d0                	or     %edx,%eax
  803c51:	89 e9                	mov    %ebp,%ecx
  803c53:	d3 eb                	shr    %cl,%ebx
  803c55:	89 da                	mov    %ebx,%edx
  803c57:	83 c4 1c             	add    $0x1c,%esp
  803c5a:	5b                   	pop    %ebx
  803c5b:	5e                   	pop    %esi
  803c5c:	5f                   	pop    %edi
  803c5d:	5d                   	pop    %ebp
  803c5e:	c3                   	ret    
  803c5f:	90                   	nop
  803c60:	89 fd                	mov    %edi,%ebp
  803c62:	85 ff                	test   %edi,%edi
  803c64:	75 0b                	jne    803c71 <__umoddi3+0xe9>
  803c66:	b8 01 00 00 00       	mov    $0x1,%eax
  803c6b:	31 d2                	xor    %edx,%edx
  803c6d:	f7 f7                	div    %edi
  803c6f:	89 c5                	mov    %eax,%ebp
  803c71:	89 f0                	mov    %esi,%eax
  803c73:	31 d2                	xor    %edx,%edx
  803c75:	f7 f5                	div    %ebp
  803c77:	89 c8                	mov    %ecx,%eax
  803c79:	f7 f5                	div    %ebp
  803c7b:	89 d0                	mov    %edx,%eax
  803c7d:	e9 44 ff ff ff       	jmp    803bc6 <__umoddi3+0x3e>
  803c82:	66 90                	xchg   %ax,%ax
  803c84:	89 c8                	mov    %ecx,%eax
  803c86:	89 f2                	mov    %esi,%edx
  803c88:	83 c4 1c             	add    $0x1c,%esp
  803c8b:	5b                   	pop    %ebx
  803c8c:	5e                   	pop    %esi
  803c8d:	5f                   	pop    %edi
  803c8e:	5d                   	pop    %ebp
  803c8f:	c3                   	ret    
  803c90:	3b 04 24             	cmp    (%esp),%eax
  803c93:	72 06                	jb     803c9b <__umoddi3+0x113>
  803c95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c99:	77 0f                	ja     803caa <__umoddi3+0x122>
  803c9b:	89 f2                	mov    %esi,%edx
  803c9d:	29 f9                	sub    %edi,%ecx
  803c9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ca3:	89 14 24             	mov    %edx,(%esp)
  803ca6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803caa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cae:	8b 14 24             	mov    (%esp),%edx
  803cb1:	83 c4 1c             	add    $0x1c,%esp
  803cb4:	5b                   	pop    %ebx
  803cb5:	5e                   	pop    %esi
  803cb6:	5f                   	pop    %edi
  803cb7:	5d                   	pop    %ebp
  803cb8:	c3                   	ret    
  803cb9:	8d 76 00             	lea    0x0(%esi),%esi
  803cbc:	2b 04 24             	sub    (%esp),%eax
  803cbf:	19 fa                	sbb    %edi,%edx
  803cc1:	89 d1                	mov    %edx,%ecx
  803cc3:	89 c6                	mov    %eax,%esi
  803cc5:	e9 71 ff ff ff       	jmp    803c3b <__umoddi3+0xb3>
  803cca:	66 90                	xchg   %ax,%ax
  803ccc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cd0:	72 ea                	jb     803cbc <__umoddi3+0x134>
  803cd2:	89 d9                	mov    %ebx,%ecx
  803cd4:	e9 62 ff ff ff       	jmp    803c3b <__umoddi3+0xb3>
