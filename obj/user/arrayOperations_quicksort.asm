
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
  80003e:	e8 68 1a 00 00       	call   801aab <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 92 1a 00 00       	call   801add <sys_getparentenvid>
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
  80005f:	68 00 3d 80 00       	push   $0x803d00
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 59 16 00 00       	call   8016c5 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 04 3d 80 00       	push   $0x803d04
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 43 16 00 00       	call   8016c5 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 0c 3d 80 00       	push   $0x803d0c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 26 16 00 00       	call   8016c5 <sget>
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
  8000b3:	68 1a 3d 80 00       	push   $0x803d1a
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
  800112:	68 29 3d 80 00       	push   $0x803d29
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
  800166:	e8 a5 19 00 00       	call   801b10 <sys_get_virtual_time>
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
  8002f6:	68 45 3d 80 00       	push   $0x803d45
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
  800318:	68 47 3d 80 00       	push   $0x803d47
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
  800346:	68 4c 3d 80 00       	push   $0x803d4c
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
  80035c:	e8 63 17 00 00       	call   801ac4 <sys_getenvindex>
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
  8003ca:	e8 79 14 00 00       	call   801848 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	68 68 3d 80 00       	push   $0x803d68
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
  8003fa:	68 90 3d 80 00       	push   $0x803d90
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
  80042b:	68 b8 3d 80 00       	push   $0x803db8
  800430:	e8 34 01 00 00       	call   800569 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	50                   	push   %eax
  800447:	68 10 3e 80 00       	push   $0x803e10
  80044c:	e8 18 01 00 00       	call   800569 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	68 68 3d 80 00       	push   $0x803d68
  80045c:	e8 08 01 00 00       	call   800569 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800464:	e8 f9 13 00 00       	call   801862 <sys_unlock_cons>
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
  80047c:	e8 0f 16 00 00       	call   801a90 <sys_destroy_env>
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
  80048d:	e8 64 16 00 00       	call   801af6 <sys_exit_env>
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
  8004db:	e8 26 13 00 00       	call   801806 <sys_cputs>
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
  800552:	e8 af 12 00 00       	call   801806 <sys_cputs>
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
  80059c:	e8 a7 12 00 00       	call   801848 <sys_lock_cons>
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
  8005bc:	e8 a1 12 00 00       	call   801862 <sys_unlock_cons>
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
  800606:	e8 7d 34 00 00       	call   803a88 <__udivdi3>
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
  800656:	e8 3d 35 00 00       	call   803b98 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 54 40 80 00       	add    $0x804054,%eax
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
  8007b1:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
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
  800892:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 65 40 80 00       	push   $0x804065
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
  8008b7:	68 6e 40 80 00       	push   $0x80406e
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
  8008e4:	be 71 40 80 00       	mov    $0x804071,%esi
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
  8012ef:	68 e8 41 80 00       	push   $0x8041e8
  8012f4:	68 3f 01 00 00       	push   $0x13f
  8012f9:	68 0a 42 80 00       	push   $0x80420a
  8012fe:	e8 9a 25 00 00       	call   80389d <_panic>

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
  80130f:	e8 9d 0a 00 00       	call   801db1 <sys_sbrk>
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
  80138a:	e8 a6 08 00 00       	call   801c35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 16                	je     8013a9 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 e6 0d 00 00       	call   802184 <alloc_block_FF>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a4:	e9 8a 01 00 00       	jmp    801533 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013a9:	e8 b8 08 00 00       	call   801c66 <sys_isUHeapPlacementStrategyBESTFIT>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	0f 84 7d 01 00 00    	je     801533 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 7f 12 00 00       	call   802640 <alloc_block_BF>
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
  801522:	e8 c1 08 00 00       	call   801de8 <sys_allocate_user_mem>
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
  80156a:	e8 95 08 00 00       	call   801e04 <get_block_size>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 c8 1a 00 00       	call   803048 <free_block>
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
  801612:	e8 b5 07 00 00       	call   801dcc <sys_free_user_mem>
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
  801620:	68 18 42 80 00       	push   $0x804218
  801625:	68 84 00 00 00       	push   $0x84
  80162a:	68 42 42 80 00       	push   $0x804242
  80162f:	e8 69 22 00 00       	call   80389d <_panic>
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
  80164d:	eb 74                	jmp    8016c3 <smalloc+0x8d>
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
  801682:	eb 3f                	jmp    8016c3 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801684:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801688:	ff 75 ec             	pushl  -0x14(%ebp)
  80168b:	50                   	push   %eax
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 3c 03 00 00       	call   8019d3 <sys_createSharedObject>
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80169d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016a1:	74 06                	je     8016a9 <smalloc+0x73>
  8016a3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016a7:	75 07                	jne    8016b0 <smalloc+0x7a>
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 13                	jmp    8016c3 <smalloc+0x8d>
	 cprintf("153\n");
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	68 4e 42 80 00       	push   $0x80424e
  8016b8:	e8 ac ee ff ff       	call   800569 <cprintf>
  8016bd:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8016c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	e8 24 03 00 00       	call   8019fd <sys_getSizeOfSharedObject>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016df:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e3:	75 07                	jne    8016ec <sget+0x27>
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb 5c                	jmp    801748 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016f2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	39 d0                	cmp    %edx,%eax
  801701:	7d 02                	jge    801705 <sget+0x40>
  801703:	89 d0                	mov    %edx,%eax
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	50                   	push   %eax
  801709:	e8 0b fc ff ff       	call   801319 <malloc>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801714:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801718:	75 07                	jne    801721 <sget+0x5c>
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
  80171f:	eb 27                	jmp    801748 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	ff 75 e8             	pushl  -0x18(%ebp)
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	e8 e8 02 00 00       	call   801a1a <sys_getSharedObject>
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801738:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80173c:	75 07                	jne    801745 <sget+0x80>
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	eb 03                	jmp    801748 <sget+0x83>
	return ptr;
  801745:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 54 42 80 00       	push   $0x804254
  801758:	68 c2 00 00 00       	push   $0xc2
  80175d:	68 42 42 80 00       	push   $0x804242
  801762:	e8 36 21 00 00       	call   80389d <_panic>

00801767 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 78 42 80 00       	push   $0x804278
  801775:	68 d9 00 00 00       	push   $0xd9
  80177a:	68 42 42 80 00       	push   $0x804242
  80177f:	e8 19 21 00 00       	call   80389d <_panic>

00801784 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	68 9e 42 80 00       	push   $0x80429e
  801792:	68 e5 00 00 00       	push   $0xe5
  801797:	68 42 42 80 00       	push   $0x804242
  80179c:	e8 fc 20 00 00       	call   80389d <_panic>

008017a1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 9e 42 80 00       	push   $0x80429e
  8017af:	68 ea 00 00 00       	push   $0xea
  8017b4:	68 42 42 80 00       	push   $0x804242
  8017b9:	e8 df 20 00 00       	call   80389d <_panic>

008017be <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 9e 42 80 00       	push   $0x80429e
  8017cc:	68 ef 00 00 00       	push   $0xef
  8017d1:	68 42 42 80 00       	push   $0x804242
  8017d6:	e8 c2 20 00 00       	call   80389d <_panic>

008017db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f6:	cd 30                	int    $0x30
  8017f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801812:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	52                   	push   %edx
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	50                   	push   %eax
  801822:	6a 00                	push   $0x0
  801824:	e8 b2 ff ff ff       	call   8017db <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_cgetc>:

int
sys_cgetc(void)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 02                	push   $0x2
  80183e:	e8 98 ff ff ff       	call   8017db <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 03                	push   $0x3
  801857:	e8 7f ff ff ff       	call   8017db <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	90                   	nop
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 04                	push   $0x4
  801871:	e8 65 ff ff ff       	call   8017db <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	90                   	nop
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80187f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	52                   	push   %edx
  80188c:	50                   	push   %eax
  80188d:	6a 08                	push   $0x8
  80188f:	e8 47 ff ff ff       	call   8017db <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	56                   	push   %esi
  80189d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80189e:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
  8018af:	51                   	push   %ecx
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	6a 09                	push   $0x9
  8018b4:	e8 22 ff ff ff       	call   8017db <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    

008018c3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 0a                	push   $0xa
  8018d6:	e8 00 ff ff ff       	call   8017db <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	ff 75 08             	pushl  0x8(%ebp)
  8018ef:	6a 0b                	push   $0xb
  8018f1:	e8 e5 fe ff ff       	call   8017db <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 0c                	push   $0xc
  80190a:	e8 cc fe ff ff       	call   8017db <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 0d                	push   $0xd
  801923:	e8 b3 fe ff ff       	call   8017db <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 0e                	push   $0xe
  80193c:	e8 9a fe ff ff       	call   8017db <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 0f                	push   $0xf
  801955:	e8 81 fe ff ff       	call   8017db <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 10                	push   $0x10
  80196f:	e8 67 fe ff ff       	call   8017db <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 11                	push   $0x11
  801988:	e8 4e fe ff ff       	call   8017db <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	90                   	nop
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_cputc>:

void
sys_cputc(const char c)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80199f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	50                   	push   %eax
  8019ac:	6a 01                	push   $0x1
  8019ae:	e8 28 fe ff ff       	call   8017db <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 14                	push   $0x14
  8019c8:	e8 0e fe ff ff       	call   8017db <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	90                   	nop
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	51                   	push   %ecx
  8019ec:	52                   	push   %edx
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	50                   	push   %eax
  8019f1:	6a 15                	push   $0x15
  8019f3:	e8 e3 fd ff ff       	call   8017db <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	52                   	push   %edx
  801a0d:	50                   	push   %eax
  801a0e:	6a 16                	push   $0x16
  801a10:	e8 c6 fd ff ff       	call   8017db <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	51                   	push   %ecx
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	6a 17                	push   $0x17
  801a2f:	e8 a7 fd ff ff       	call   8017db <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	6a 18                	push   $0x18
  801a4c:	e8 8a fd ff ff       	call   8017db <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	ff 75 14             	pushl  0x14(%ebp)
  801a61:	ff 75 10             	pushl  0x10(%ebp)
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	50                   	push   %eax
  801a68:	6a 19                	push   $0x19
  801a6a:	e8 6c fd ff ff       	call   8017db <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	50                   	push   %eax
  801a83:	6a 1a                	push   $0x1a
  801a85:	e8 51 fd ff ff       	call   8017db <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	90                   	nop
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	50                   	push   %eax
  801a9f:	6a 1b                	push   $0x1b
  801aa1:	e8 35 fd ff ff       	call   8017db <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 05                	push   $0x5
  801aba:	e8 1c fd ff ff       	call   8017db <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 06                	push   $0x6
  801ad3:	e8 03 fd ff ff       	call   8017db <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 07                	push   $0x7
  801aec:	e8 ea fc ff ff       	call   8017db <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_exit_env>:


void sys_exit_env(void)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 1c                	push   $0x1c
  801b05:	e8 d1 fc ff ff       	call   8017db <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	90                   	nop
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b16:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b19:	8d 50 04             	lea    0x4(%eax),%edx
  801b1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 1d                	push   $0x1d
  801b29:	e8 ad fc ff ff       	call   8017db <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3a:	89 01                	mov    %eax,(%ecx)
  801b3c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	c9                   	leave  
  801b43:	c2 04 00             	ret    $0x4

00801b46 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	ff 75 10             	pushl  0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	6a 13                	push   $0x13
  801b58:	e8 7e fc ff ff       	call   8017db <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b60:	90                   	nop
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 1e                	push   $0x1e
  801b72:	e8 64 fc ff ff       	call   8017db <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 04             	sub    $0x4,%esp
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b88:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	50                   	push   %eax
  801b95:	6a 1f                	push   $0x1f
  801b97:	e8 3f fc ff ff       	call   8017db <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9f:	90                   	nop
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <rsttst>:
void rsttst()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 21                	push   $0x21
  801bb1:	e8 25 fc ff ff       	call   8017db <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb9:	90                   	nop
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bc8:	8b 55 18             	mov    0x18(%ebp),%edx
  801bcb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bcf:	52                   	push   %edx
  801bd0:	50                   	push   %eax
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	6a 20                	push   $0x20
  801bdc:	e8 fa fb ff ff       	call   8017db <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <chktst>:
void chktst(uint32 n)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	ff 75 08             	pushl  0x8(%ebp)
  801bf5:	6a 22                	push   $0x22
  801bf7:	e8 df fb ff ff       	call   8017db <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bff:	90                   	nop
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <inctst>:

void inctst()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 23                	push   $0x23
  801c11:	e8 c5 fb ff ff       	call   8017db <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <gettst>:
uint32 gettst()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 24                	push   $0x24
  801c2b:	e8 ab fb ff ff       	call   8017db <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 25                	push   $0x25
  801c47:	e8 8f fb ff ff       	call   8017db <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
  801c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c52:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c56:	75 07                	jne    801c5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c58:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5d:	eb 05                	jmp    801c64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 25                	push   $0x25
  801c78:	e8 5e fb ff ff       	call   8017db <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
  801c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c83:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c87:	75 07                	jne    801c90 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	eb 05                	jmp    801c95 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 25                	push   $0x25
  801ca9:	e8 2d fb ff ff       	call   8017db <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
  801cb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cb4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cb8:	75 07                	jne    801cc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cba:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbf:	eb 05                	jmp    801cc6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 25                	push   $0x25
  801cda:	e8 fc fa ff ff       	call   8017db <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
  801ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ce5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ce9:	75 07                	jne    801cf2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ceb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf0:	eb 05                	jmp    801cf7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	6a 26                	push   $0x26
  801d09:	e8 cd fa ff ff       	call   8017db <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d11:	90                   	nop
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	53                   	push   %ebx
  801d27:	51                   	push   %ecx
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	6a 27                	push   $0x27
  801d2c:	e8 aa fa ff ff       	call   8017db <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	52                   	push   %edx
  801d49:	50                   	push   %eax
  801d4a:	6a 28                	push   $0x28
  801d4c:	e8 8a fa ff ff       	call   8017db <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d59:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	51                   	push   %ecx
  801d65:	ff 75 10             	pushl  0x10(%ebp)
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 29                	push   $0x29
  801d6c:	e8 6a fa ff ff       	call   8017db <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	ff 75 10             	pushl  0x10(%ebp)
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 12                	push   $0x12
  801d88:	e8 4e fa ff ff       	call   8017db <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	6a 2a                	push   $0x2a
  801da6:	e8 30 fa ff ff       	call   8017db <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
	return;
  801dae:	90                   	nop
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	50                   	push   %eax
  801dc0:	6a 2b                	push   $0x2b
  801dc2:	e8 14 fa ff ff       	call   8017db <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	ff 75 08             	pushl  0x8(%ebp)
  801ddb:	6a 2c                	push   $0x2c
  801ddd:	e8 f9 f9 ff ff       	call   8017db <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
	return;
  801de5:	90                   	nop
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	6a 2d                	push   $0x2d
  801df9:	e8 dd f9 ff ff       	call   8017db <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	83 e8 04             	sub    $0x4,%eax
  801e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	83 e8 04             	sub    $0x4,%eax
  801e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2f:	8b 00                	mov    (%eax),%eax
  801e31:	83 e0 01             	and    $0x1,%eax
  801e34:	85 c0                	test   %eax,%eax
  801e36:	0f 94 c0             	sete   %al
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4b:	83 f8 02             	cmp    $0x2,%eax
  801e4e:	74 2b                	je     801e7b <alloc_block+0x40>
  801e50:	83 f8 02             	cmp    $0x2,%eax
  801e53:	7f 07                	jg     801e5c <alloc_block+0x21>
  801e55:	83 f8 01             	cmp    $0x1,%eax
  801e58:	74 0e                	je     801e68 <alloc_block+0x2d>
  801e5a:	eb 58                	jmp    801eb4 <alloc_block+0x79>
  801e5c:	83 f8 03             	cmp    $0x3,%eax
  801e5f:	74 2d                	je     801e8e <alloc_block+0x53>
  801e61:	83 f8 04             	cmp    $0x4,%eax
  801e64:	74 3b                	je     801ea1 <alloc_block+0x66>
  801e66:	eb 4c                	jmp    801eb4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	ff 75 08             	pushl  0x8(%ebp)
  801e6e:	e8 11 03 00 00       	call   802184 <alloc_block_FF>
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e79:	eb 4a                	jmp    801ec5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	e8 fa 19 00 00       	call   803880 <alloc_block_NF>
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e8c:	eb 37                	jmp    801ec5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e8e:	83 ec 0c             	sub    $0xc,%esp
  801e91:	ff 75 08             	pushl  0x8(%ebp)
  801e94:	e8 a7 07 00 00       	call   802640 <alloc_block_BF>
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e9f:	eb 24                	jmp    801ec5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	e8 b7 19 00 00       	call   803863 <alloc_block_WF>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb2:	eb 11                	jmp    801ec5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	68 b0 42 80 00       	push   $0x8042b0
  801ebc:	e8 a8 e6 ff ff       	call   800569 <cprintf>
  801ec1:	83 c4 10             	add    $0x10,%esp
		break;
  801ec4:	90                   	nop
	}
	return va;
  801ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	68 d0 42 80 00       	push   $0x8042d0
  801ed9:	e8 8b e6 ff ff       	call   800569 <cprintf>
  801ede:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	68 fb 42 80 00       	push   $0x8042fb
  801ee9:	e8 7b e6 ff ff       	call   800569 <cprintf>
  801eee:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef7:	eb 37                	jmp    801f30 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 75 f4             	pushl  -0xc(%ebp)
  801eff:	e8 19 ff ff ff       	call   801e1d <is_free_block>
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	0f be d8             	movsbl %al,%ebx
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f10:	e8 ef fe ff ff       	call   801e04 <get_block_size>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	53                   	push   %ebx
  801f1c:	50                   	push   %eax
  801f1d:	68 13 43 80 00       	push   $0x804313
  801f22:	e8 42 e6 ff ff       	call   800569 <cprintf>
  801f27:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f34:	74 07                	je     801f3d <print_blocks_list+0x73>
  801f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f39:	8b 00                	mov    (%eax),%eax
  801f3b:	eb 05                	jmp    801f42 <print_blocks_list+0x78>
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	89 45 10             	mov    %eax,0x10(%ebp)
  801f45:	8b 45 10             	mov    0x10(%ebp),%eax
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	75 ad                	jne    801ef9 <print_blocks_list+0x2f>
  801f4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f50:	75 a7                	jne    801ef9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 d0 42 80 00       	push   $0x8042d0
  801f5a:	e8 0a e6 ff ff       	call   800569 <cprintf>
  801f5f:	83 c4 10             	add    $0x10,%esp

}
  801f62:	90                   	nop
  801f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f71:	83 e0 01             	and    $0x1,%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	74 03                	je     801f7b <initialize_dynamic_allocator+0x13>
  801f78:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f7f:	0f 84 c7 01 00 00    	je     80214c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f85:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f8c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f95:	01 d0                	add    %edx,%eax
  801f97:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f9c:	0f 87 ad 01 00 00    	ja     80214f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	0f 89 a5 01 00 00    	jns    802152 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fad:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb3:	01 d0                	add    %edx,%eax
  801fb5:	83 e8 04             	sub    $0x4,%eax
  801fb8:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fc4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcc:	e9 87 00 00 00       	jmp    802058 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd5:	75 14                	jne    801feb <initialize_dynamic_allocator+0x83>
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	68 2b 43 80 00       	push   $0x80432b
  801fdf:	6a 79                	push   $0x79
  801fe1:	68 49 43 80 00       	push   $0x804349
  801fe6:	e8 b2 18 00 00       	call   80389d <_panic>
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 00                	mov    (%eax),%eax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	74 10                	je     802004 <initialize_dynamic_allocator+0x9c>
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 00                	mov    (%eax),%eax
  801ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffc:	8b 52 04             	mov    0x4(%edx),%edx
  801fff:	89 50 04             	mov    %edx,0x4(%eax)
  802002:	eb 0b                	jmp    80200f <initialize_dynamic_allocator+0xa7>
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 40 04             	mov    0x4(%eax),%eax
  80200a:	a3 30 50 80 00       	mov    %eax,0x805030
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	8b 40 04             	mov    0x4(%eax),%eax
  802015:	85 c0                	test   %eax,%eax
  802017:	74 0f                	je     802028 <initialize_dynamic_allocator+0xc0>
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	8b 40 04             	mov    0x4(%eax),%eax
  80201f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802022:	8b 12                	mov    (%edx),%edx
  802024:	89 10                	mov    %edx,(%eax)
  802026:	eb 0a                	jmp    802032 <initialize_dynamic_allocator+0xca>
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 00                	mov    (%eax),%eax
  80202d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802045:	a1 38 50 80 00       	mov    0x805038,%eax
  80204a:	48                   	dec    %eax
  80204b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802050:	a1 34 50 80 00       	mov    0x805034,%eax
  802055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205c:	74 07                	je     802065 <initialize_dynamic_allocator+0xfd>
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 00                	mov    (%eax),%eax
  802063:	eb 05                	jmp    80206a <initialize_dynamic_allocator+0x102>
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	a3 34 50 80 00       	mov    %eax,0x805034
  80206f:	a1 34 50 80 00       	mov    0x805034,%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	0f 85 55 ff ff ff    	jne    801fd1 <initialize_dynamic_allocator+0x69>
  80207c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802080:	0f 85 4b ff ff ff    	jne    801fd1 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802095:	a1 44 50 80 00       	mov    0x805044,%eax
  80209a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80209f:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	83 c0 08             	add    $0x8,%eax
  8020b0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	83 c0 04             	add    $0x4,%eax
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	83 ea 08             	sub    $0x8,%edx
  8020bf:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	01 d0                	add    %edx,%eax
  8020c9:	83 e8 08             	sub    $0x8,%eax
  8020cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cf:	83 ea 08             	sub    $0x8,%edx
  8020d2:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020eb:	75 17                	jne    802104 <initialize_dynamic_allocator+0x19c>
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	68 64 43 80 00       	push   $0x804364
  8020f5:	68 90 00 00 00       	push   $0x90
  8020fa:	68 49 43 80 00       	push   $0x804349
  8020ff:	e8 99 17 00 00       	call   80389d <_panic>
  802104:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80210a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210d:	89 10                	mov    %edx,(%eax)
  80210f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802112:	8b 00                	mov    (%eax),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	74 0d                	je     802125 <initialize_dynamic_allocator+0x1bd>
  802118:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80211d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802120:	89 50 04             	mov    %edx,0x4(%eax)
  802123:	eb 08                	jmp    80212d <initialize_dynamic_allocator+0x1c5>
  802125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802128:	a3 30 50 80 00       	mov    %eax,0x805030
  80212d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802130:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802138:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213f:	a1 38 50 80 00       	mov    0x805038,%eax
  802144:	40                   	inc    %eax
  802145:	a3 38 50 80 00       	mov    %eax,0x805038
  80214a:	eb 07                	jmp    802153 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80214c:	90                   	nop
  80214d:	eb 04                	jmp    802153 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80214f:	90                   	nop
  802150:	eb 01                	jmp    802153 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802152:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802158:	8b 45 10             	mov    0x10(%ebp),%eax
  80215b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8d 50 fc             	lea    -0x4(%eax),%edx
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	83 e8 04             	sub    $0x4,%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	83 e0 fe             	and    $0xfffffffe,%eax
  802174:	8d 50 f8             	lea    -0x8(%eax),%edx
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	01 c2                	add    %eax,%edx
  80217c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217f:	89 02                	mov    %eax,(%edx)
}
  802181:	90                   	nop
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	83 e0 01             	and    $0x1,%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	74 03                	je     802197 <alloc_block_FF+0x13>
  802194:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802197:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80219b:	77 07                	ja     8021a4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80219d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	75 73                	jne    802220 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	83 c0 10             	add    $0x10,%eax
  8021b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021b6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	01 d0                	add    %edx,%eax
  8021c5:	48                   	dec    %eax
  8021c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d1:	f7 75 ec             	divl   -0x14(%ebp)
  8021d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d7:	29 d0                	sub    %edx,%eax
  8021d9:	c1 e8 0c             	shr    $0xc,%eax
  8021dc:	83 ec 0c             	sub    $0xc,%esp
  8021df:	50                   	push   %eax
  8021e0:	e8 1e f1 ff ff       	call   801303 <sbrk>
  8021e5:	83 c4 10             	add    $0x10,%esp
  8021e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	6a 00                	push   $0x0
  8021f0:	e8 0e f1 ff ff       	call   801303 <sbrk>
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fe:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802201:	83 ec 08             	sub    $0x8,%esp
  802204:	50                   	push   %eax
  802205:	ff 75 e4             	pushl  -0x1c(%ebp)
  802208:	e8 5b fd ff ff       	call   801f68 <initialize_dynamic_allocator>
  80220d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	68 87 43 80 00       	push   $0x804387
  802218:	e8 4c e3 ff ff       	call   800569 <cprintf>
  80221d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802224:	75 0a                	jne    802230 <alloc_block_FF+0xac>
	        return NULL;
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
  80222b:	e9 0e 04 00 00       	jmp    80263e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802237:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80223c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223f:	e9 f3 02 00 00       	jmp    802537 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80224a:	83 ec 0c             	sub    $0xc,%esp
  80224d:	ff 75 bc             	pushl  -0x44(%ebp)
  802250:	e8 af fb ff ff       	call   801e04 <get_block_size>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	83 c0 08             	add    $0x8,%eax
  802261:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802264:	0f 87 c5 02 00 00    	ja     80252f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	83 c0 18             	add    $0x18,%eax
  802270:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802273:	0f 87 19 02 00 00    	ja     802492 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802279:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80227c:	2b 45 08             	sub    0x8(%ebp),%eax
  80227f:	83 e8 08             	sub    $0x8,%eax
  802282:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8d 50 08             	lea    0x8(%eax),%edx
  80228b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80228e:	01 d0                	add    %edx,%eax
  802290:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	83 c0 08             	add    $0x8,%eax
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	6a 01                	push   $0x1
  80229e:	50                   	push   %eax
  80229f:	ff 75 bc             	pushl  -0x44(%ebp)
  8022a2:	e8 ae fe ff ff       	call   802155 <set_block_data>
  8022a7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	75 68                	jne    80231c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022b4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022b8:	75 17                	jne    8022d1 <alloc_block_FF+0x14d>
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	68 64 43 80 00       	push   $0x804364
  8022c2:	68 d7 00 00 00       	push   $0xd7
  8022c7:	68 49 43 80 00       	push   $0x804349
  8022cc:	e8 cc 15 00 00       	call   80389d <_panic>
  8022d1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022da:	89 10                	mov    %edx,(%eax)
  8022dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	74 0d                	je     8022f2 <alloc_block_FF+0x16e>
  8022e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ea:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ed:	89 50 04             	mov    %edx,0x4(%eax)
  8022f0:	eb 08                	jmp    8022fa <alloc_block_FF+0x176>
  8022f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8022fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802302:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230c:	a1 38 50 80 00       	mov    0x805038,%eax
  802311:	40                   	inc    %eax
  802312:	a3 38 50 80 00       	mov    %eax,0x805038
  802317:	e9 dc 00 00 00       	jmp    8023f8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	75 65                	jne    80238a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802325:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802329:	75 17                	jne    802342 <alloc_block_FF+0x1be>
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	68 98 43 80 00       	push   $0x804398
  802333:	68 db 00 00 00       	push   $0xdb
  802338:	68 49 43 80 00       	push   $0x804349
  80233d:	e8 5b 15 00 00       	call   80389d <_panic>
  802342:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802348:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802351:	8b 40 04             	mov    0x4(%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 0c                	je     802364 <alloc_block_FF+0x1e0>
  802358:	a1 30 50 80 00       	mov    0x805030,%eax
  80235d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802360:	89 10                	mov    %edx,(%eax)
  802362:	eb 08                	jmp    80236c <alloc_block_FF+0x1e8>
  802364:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802367:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80236c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236f:	a3 30 50 80 00       	mov    %eax,0x805030
  802374:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237d:	a1 38 50 80 00       	mov    0x805038,%eax
  802382:	40                   	inc    %eax
  802383:	a3 38 50 80 00       	mov    %eax,0x805038
  802388:	eb 6e                	jmp    8023f8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80238a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238e:	74 06                	je     802396 <alloc_block_FF+0x212>
  802390:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802394:	75 17                	jne    8023ad <alloc_block_FF+0x229>
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 bc 43 80 00       	push   $0x8043bc
  80239e:	68 df 00 00 00       	push   $0xdf
  8023a3:	68 49 43 80 00       	push   $0x804349
  8023a8:	e8 f0 14 00 00       	call   80389d <_panic>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 10                	mov    (%eax),%edx
  8023b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b5:	89 10                	mov    %edx,(%eax)
  8023b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 0b                	je     8023cb <alloc_block_FF+0x247>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c8:	89 50 04             	mov    %edx,0x4(%eax)
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d1:	89 10                	mov    %edx,(%eax)
  8023d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d9:	89 50 04             	mov    %edx,0x4(%eax)
  8023dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 08                	jne    8023ed <alloc_block_FF+0x269>
  8023e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f2:	40                   	inc    %eax
  8023f3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	75 17                	jne    802415 <alloc_block_FF+0x291>
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 2b 43 80 00       	push   $0x80432b
  802406:	68 e1 00 00 00       	push   $0xe1
  80240b:	68 49 43 80 00       	push   $0x804349
  802410:	e8 88 14 00 00       	call   80389d <_panic>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 10                	je     80242e <alloc_block_FF+0x2aa>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802426:	8b 52 04             	mov    0x4(%edx),%edx
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	eb 0b                	jmp    802439 <alloc_block_FF+0x2b5>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 40 04             	mov    0x4(%eax),%eax
  802434:	a3 30 50 80 00       	mov    %eax,0x805030
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 0f                	je     802452 <alloc_block_FF+0x2ce>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	8b 12                	mov    (%edx),%edx
  80244e:	89 10                	mov    %edx,(%eax)
  802450:	eb 0a                	jmp    80245c <alloc_block_FF+0x2d8>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246f:	a1 38 50 80 00       	mov    0x805038,%eax
  802474:	48                   	dec    %eax
  802475:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	6a 00                	push   $0x0
  80247f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802482:	ff 75 b0             	pushl  -0x50(%ebp)
  802485:	e8 cb fc ff ff       	call   802155 <set_block_data>
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	e9 95 00 00 00       	jmp    802527 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	6a 01                	push   $0x1
  802497:	ff 75 b8             	pushl  -0x48(%ebp)
  80249a:	ff 75 bc             	pushl  -0x44(%ebp)
  80249d:	e8 b3 fc ff ff       	call   802155 <set_block_data>
  8024a2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	75 17                	jne    8024c2 <alloc_block_FF+0x33e>
  8024ab:	83 ec 04             	sub    $0x4,%esp
  8024ae:	68 2b 43 80 00       	push   $0x80432b
  8024b3:	68 e8 00 00 00       	push   $0xe8
  8024b8:	68 49 43 80 00       	push   $0x804349
  8024bd:	e8 db 13 00 00       	call   80389d <_panic>
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 00                	mov    (%eax),%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	74 10                	je     8024db <alloc_block_FF+0x357>
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 00                	mov    (%eax),%eax
  8024d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d3:	8b 52 04             	mov    0x4(%edx),%edx
  8024d6:	89 50 04             	mov    %edx,0x4(%eax)
  8024d9:	eb 0b                	jmp    8024e6 <alloc_block_FF+0x362>
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 04             	mov    0x4(%eax),%eax
  8024e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 0f                	je     8024ff <alloc_block_FF+0x37b>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f9:	8b 12                	mov    (%edx),%edx
  8024fb:	89 10                	mov    %edx,(%eax)
  8024fd:	eb 0a                	jmp    802509 <alloc_block_FF+0x385>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251c:	a1 38 50 80 00       	mov    0x805038,%eax
  802521:	48                   	dec    %eax
  802522:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802527:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80252a:	e9 0f 01 00 00       	jmp    80263e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80252f:	a1 34 50 80 00       	mov    0x805034,%eax
  802534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253b:	74 07                	je     802544 <alloc_block_FF+0x3c0>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	eb 05                	jmp    802549 <alloc_block_FF+0x3c5>
  802544:	b8 00 00 00 00       	mov    $0x0,%eax
  802549:	a3 34 50 80 00       	mov    %eax,0x805034
  80254e:	a1 34 50 80 00       	mov    0x805034,%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	0f 85 e9 fc ff ff    	jne    802244 <alloc_block_FF+0xc0>
  80255b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255f:	0f 85 df fc ff ff    	jne    802244 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	83 c0 08             	add    $0x8,%eax
  80256b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80256e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802575:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802578:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80257b:	01 d0                	add    %edx,%eax
  80257d:	48                   	dec    %eax
  80257e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802581:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802584:	ba 00 00 00 00       	mov    $0x0,%edx
  802589:	f7 75 d8             	divl   -0x28(%ebp)
  80258c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80258f:	29 d0                	sub    %edx,%eax
  802591:	c1 e8 0c             	shr    $0xc,%eax
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	50                   	push   %eax
  802598:	e8 66 ed ff ff       	call   801303 <sbrk>
  80259d:	83 c4 10             	add    $0x10,%esp
  8025a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025a3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025a7:	75 0a                	jne    8025b3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	e9 8b 00 00 00       	jmp    80263e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025b3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025c0:	01 d0                	add    %edx,%eax
  8025c2:	48                   	dec    %eax
  8025c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ce:	f7 75 cc             	divl   -0x34(%ebp)
  8025d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025d4:	29 d0                	sub    %edx,%eax
  8025d6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025dc:	01 d0                	add    %edx,%eax
  8025de:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025ee:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025fb:	01 d0                	add    %edx,%eax
  8025fd:	48                   	dec    %eax
  8025fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802601:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802604:	ba 00 00 00 00       	mov    $0x0,%edx
  802609:	f7 75 c4             	divl   -0x3c(%ebp)
  80260c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80260f:	29 d0                	sub    %edx,%eax
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	6a 01                	push   $0x1
  802616:	50                   	push   %eax
  802617:	ff 75 d0             	pushl  -0x30(%ebp)
  80261a:	e8 36 fb ff ff       	call   802155 <set_block_data>
  80261f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802622:	83 ec 0c             	sub    $0xc,%esp
  802625:	ff 75 d0             	pushl  -0x30(%ebp)
  802628:	e8 1b 0a 00 00       	call   803048 <free_block>
  80262d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802630:	83 ec 0c             	sub    $0xc,%esp
  802633:	ff 75 08             	pushl  0x8(%ebp)
  802636:	e8 49 fb ff ff       	call   802184 <alloc_block_FF>
  80263b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	83 e0 01             	and    $0x1,%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 03                	je     802653 <alloc_block_BF+0x13>
  802650:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802653:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802657:	77 07                	ja     802660 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802659:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802660:	a1 24 50 80 00       	mov    0x805024,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	75 73                	jne    8026dc <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	83 c0 10             	add    $0x10,%eax
  80266f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802672:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802679:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80267c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267f:	01 d0                	add    %edx,%eax
  802681:	48                   	dec    %eax
  802682:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802685:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802688:	ba 00 00 00 00       	mov    $0x0,%edx
  80268d:	f7 75 e0             	divl   -0x20(%ebp)
  802690:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802693:	29 d0                	sub    %edx,%eax
  802695:	c1 e8 0c             	shr    $0xc,%eax
  802698:	83 ec 0c             	sub    $0xc,%esp
  80269b:	50                   	push   %eax
  80269c:	e8 62 ec ff ff       	call   801303 <sbrk>
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	6a 00                	push   $0x0
  8026ac:	e8 52 ec ff ff       	call   801303 <sbrk>
  8026b1:	83 c4 10             	add    $0x10,%esp
  8026b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ba:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026bd:	83 ec 08             	sub    $0x8,%esp
  8026c0:	50                   	push   %eax
  8026c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8026c4:	e8 9f f8 ff ff       	call   801f68 <initialize_dynamic_allocator>
  8026c9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	68 87 43 80 00       	push   $0x804387
  8026d4:	e8 90 de ff ff       	call   800569 <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026ea:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802700:	e9 1d 01 00 00       	jmp    802822 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	ff 75 a8             	pushl  -0x58(%ebp)
  802711:	e8 ee f6 ff ff       	call   801e04 <get_block_size>
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	83 c0 08             	add    $0x8,%eax
  802722:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802725:	0f 87 ef 00 00 00    	ja     80281a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	83 c0 18             	add    $0x18,%eax
  802731:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802734:	77 1d                	ja     802753 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802739:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80273c:	0f 86 d8 00 00 00    	jbe    80281a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802742:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802745:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802748:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80274b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80274e:	e9 c7 00 00 00       	jmp    80281a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	83 c0 08             	add    $0x8,%eax
  802759:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275c:	0f 85 9d 00 00 00    	jne    8027ff <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	6a 01                	push   $0x1
  802767:	ff 75 a4             	pushl  -0x5c(%ebp)
  80276a:	ff 75 a8             	pushl  -0x58(%ebp)
  80276d:	e8 e3 f9 ff ff       	call   802155 <set_block_data>
  802772:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802779:	75 17                	jne    802792 <alloc_block_BF+0x152>
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	68 2b 43 80 00       	push   $0x80432b
  802783:	68 2c 01 00 00       	push   $0x12c
  802788:	68 49 43 80 00       	push   $0x804349
  80278d:	e8 0b 11 00 00       	call   80389d <_panic>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 00                	mov    (%eax),%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	74 10                	je     8027ab <alloc_block_BF+0x16b>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a3:	8b 52 04             	mov    0x4(%edx),%edx
  8027a6:	89 50 04             	mov    %edx,0x4(%eax)
  8027a9:	eb 0b                	jmp    8027b6 <alloc_block_BF+0x176>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 04             	mov    0x4(%eax),%eax
  8027b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 0f                	je     8027cf <alloc_block_BF+0x18f>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	8b 12                	mov    (%edx),%edx
  8027cb:	89 10                	mov    %edx,(%eax)
  8027cd:	eb 0a                	jmp    8027d9 <alloc_block_BF+0x199>
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f1:	48                   	dec    %eax
  8027f2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027fa:	e9 24 04 00 00       	jmp    802c23 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802802:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802805:	76 13                	jbe    80281a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802807:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80280e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802811:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802814:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802817:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80281a:	a1 34 50 80 00       	mov    0x805034,%eax
  80281f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802826:	74 07                	je     80282f <alloc_block_BF+0x1ef>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	eb 05                	jmp    802834 <alloc_block_BF+0x1f4>
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
  802834:	a3 34 50 80 00       	mov    %eax,0x805034
  802839:	a1 34 50 80 00       	mov    0x805034,%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	0f 85 bf fe ff ff    	jne    802705 <alloc_block_BF+0xc5>
  802846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284a:	0f 85 b5 fe ff ff    	jne    802705 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802850:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802854:	0f 84 26 02 00 00    	je     802a80 <alloc_block_BF+0x440>
  80285a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80285e:	0f 85 1c 02 00 00    	jne    802a80 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	2b 45 08             	sub    0x8(%ebp),%eax
  80286a:	83 e8 08             	sub    $0x8,%eax
  80286d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	8d 50 08             	lea    0x8(%eax),%edx
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	83 c0 08             	add    $0x8,%eax
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	6a 01                	push   $0x1
  802889:	50                   	push   %eax
  80288a:	ff 75 f0             	pushl  -0x10(%ebp)
  80288d:	e8 c3 f8 ff ff       	call   802155 <set_block_data>
  802892:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 40 04             	mov    0x4(%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	75 68                	jne    802907 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80289f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a3:	75 17                	jne    8028bc <alloc_block_BF+0x27c>
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 64 43 80 00       	push   $0x804364
  8028ad:	68 45 01 00 00       	push   $0x145
  8028b2:	68 49 43 80 00       	push   $0x804349
  8028b7:	e8 e1 0f 00 00       	call   80389d <_panic>
  8028bc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c5:	89 10                	mov    %edx,(%eax)
  8028c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 0d                	je     8028dd <alloc_block_BF+0x29d>
  8028d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028d5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028d8:	89 50 04             	mov    %edx,0x4(%eax)
  8028db:	eb 08                	jmp    8028e5 <alloc_block_BF+0x2a5>
  8028dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8028e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fc:	40                   	inc    %eax
  8028fd:	a3 38 50 80 00       	mov    %eax,0x805038
  802902:	e9 dc 00 00 00       	jmp    8029e3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	75 65                	jne    802975 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802910:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802914:	75 17                	jne    80292d <alloc_block_BF+0x2ed>
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	68 98 43 80 00       	push   $0x804398
  80291e:	68 4a 01 00 00       	push   $0x14a
  802923:	68 49 43 80 00       	push   $0x804349
  802928:	e8 70 0f 00 00       	call   80389d <_panic>
  80292d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802933:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0c                	je     80294f <alloc_block_BF+0x30f>
  802943:	a1 30 50 80 00       	mov    0x805030,%eax
  802948:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	eb 08                	jmp    802957 <alloc_block_BF+0x317>
  80294f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802952:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802957:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295a:	a3 30 50 80 00       	mov    %eax,0x805030
  80295f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802968:	a1 38 50 80 00       	mov    0x805038,%eax
  80296d:	40                   	inc    %eax
  80296e:	a3 38 50 80 00       	mov    %eax,0x805038
  802973:	eb 6e                	jmp    8029e3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802975:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802979:	74 06                	je     802981 <alloc_block_BF+0x341>
  80297b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80297f:	75 17                	jne    802998 <alloc_block_BF+0x358>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 bc 43 80 00       	push   $0x8043bc
  802989:	68 4f 01 00 00       	push   $0x14f
  80298e:	68 49 43 80 00       	push   $0x804349
  802993:	e8 05 0f 00 00       	call   80389d <_panic>
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 10                	mov    (%eax),%edx
  80299d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a0:	89 10                	mov    %edx,(%eax)
  8029a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 0b                	je     8029b6 <alloc_block_BF+0x376>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b3:	89 50 04             	mov    %edx,0x4(%eax)
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029bc:	89 10                	mov    %edx,(%eax)
  8029be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	75 08                	jne    8029d8 <alloc_block_BF+0x398>
  8029d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029dd:	40                   	inc    %eax
  8029de:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e7:	75 17                	jne    802a00 <alloc_block_BF+0x3c0>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 2b 43 80 00       	push   $0x80432b
  8029f1:	68 51 01 00 00       	push   $0x151
  8029f6:	68 49 43 80 00       	push   $0x804349
  8029fb:	e8 9d 0e 00 00       	call   80389d <_panic>
  802a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 10                	je     802a19 <alloc_block_BF+0x3d9>
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a11:	8b 52 04             	mov    0x4(%edx),%edx
  802a14:	89 50 04             	mov    %edx,0x4(%eax)
  802a17:	eb 0b                	jmp    802a24 <alloc_block_BF+0x3e4>
  802a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1c:	8b 40 04             	mov    0x4(%eax),%eax
  802a1f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 0f                	je     802a3d <alloc_block_BF+0x3fd>
  802a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a31:	8b 40 04             	mov    0x4(%eax),%eax
  802a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a37:	8b 12                	mov    (%edx),%edx
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	eb 0a                	jmp    802a47 <alloc_block_BF+0x407>
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5f:	48                   	dec    %eax
  802a60:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	6a 00                	push   $0x0
  802a6a:	ff 75 d0             	pushl  -0x30(%ebp)
  802a6d:	ff 75 cc             	pushl  -0x34(%ebp)
  802a70:	e8 e0 f6 ff ff       	call   802155 <set_block_data>
  802a75:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	e9 a3 01 00 00       	jmp    802c23 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a80:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a84:	0f 85 9d 00 00 00    	jne    802b27 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	6a 01                	push   $0x1
  802a8f:	ff 75 ec             	pushl  -0x14(%ebp)
  802a92:	ff 75 f0             	pushl  -0x10(%ebp)
  802a95:	e8 bb f6 ff ff       	call   802155 <set_block_data>
  802a9a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa1:	75 17                	jne    802aba <alloc_block_BF+0x47a>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 2b 43 80 00       	push   $0x80432b
  802aab:	68 58 01 00 00       	push   $0x158
  802ab0:	68 49 43 80 00       	push   $0x804349
  802ab5:	e8 e3 0d 00 00       	call   80389d <_panic>
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 10                	je     802ad3 <alloc_block_BF+0x493>
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acb:	8b 52 04             	mov    0x4(%edx),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 0b                	jmp    802ade <alloc_block_BF+0x49e>
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	a3 30 50 80 00       	mov    %eax,0x805030
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0f                	je     802af7 <alloc_block_BF+0x4b7>
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af1:	8b 12                	mov    (%edx),%edx
  802af3:	89 10                	mov    %edx,(%eax)
  802af5:	eb 0a                	jmp    802b01 <alloc_block_BF+0x4c1>
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b14:	a1 38 50 80 00       	mov    0x805038,%eax
  802b19:	48                   	dec    %eax
  802b1a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	e9 fc 00 00 00       	jmp    802c23 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	83 c0 08             	add    $0x8,%eax
  802b2d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b30:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b37:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b3a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b3d:	01 d0                	add    %edx,%eax
  802b3f:	48                   	dec    %eax
  802b40:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b43:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b46:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4b:	f7 75 c4             	divl   -0x3c(%ebp)
  802b4e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b51:	29 d0                	sub    %edx,%eax
  802b53:	c1 e8 0c             	shr    $0xc,%eax
  802b56:	83 ec 0c             	sub    $0xc,%esp
  802b59:	50                   	push   %eax
  802b5a:	e8 a4 e7 ff ff       	call   801303 <sbrk>
  802b5f:	83 c4 10             	add    $0x10,%esp
  802b62:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b65:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b69:	75 0a                	jne    802b75 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b70:	e9 ae 00 00 00       	jmp    802c23 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b75:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b7c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b7f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b82:	01 d0                	add    %edx,%eax
  802b84:	48                   	dec    %eax
  802b85:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b90:	f7 75 b8             	divl   -0x48(%ebp)
  802b93:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b96:	29 d0                	sub    %edx,%eax
  802b98:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b9b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b9e:	01 d0                	add    %edx,%eax
  802ba0:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ba5:	a1 40 50 80 00       	mov    0x805040,%eax
  802baa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bb0:	83 ec 0c             	sub    $0xc,%esp
  802bb3:	68 f0 43 80 00       	push   $0x8043f0
  802bb8:	e8 ac d9 ff ff       	call   800569 <cprintf>
  802bbd:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802bc0:	83 ec 08             	sub    $0x8,%esp
  802bc3:	ff 75 bc             	pushl  -0x44(%ebp)
  802bc6:	68 f5 43 80 00       	push   $0x8043f5
  802bcb:	e8 99 d9 ff ff       	call   800569 <cprintf>
  802bd0:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bd3:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bda:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bdd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be0:	01 d0                	add    %edx,%eax
  802be2:	48                   	dec    %eax
  802be3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802be6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802be9:	ba 00 00 00 00       	mov    $0x0,%edx
  802bee:	f7 75 b0             	divl   -0x50(%ebp)
  802bf1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bf4:	29 d0                	sub    %edx,%eax
  802bf6:	83 ec 04             	sub    $0x4,%esp
  802bf9:	6a 01                	push   $0x1
  802bfb:	50                   	push   %eax
  802bfc:	ff 75 bc             	pushl  -0x44(%ebp)
  802bff:	e8 51 f5 ff ff       	call   802155 <set_block_data>
  802c04:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c07:	83 ec 0c             	sub    $0xc,%esp
  802c0a:	ff 75 bc             	pushl  -0x44(%ebp)
  802c0d:	e8 36 04 00 00       	call   803048 <free_block>
  802c12:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c15:	83 ec 0c             	sub    $0xc,%esp
  802c18:	ff 75 08             	pushl  0x8(%ebp)
  802c1b:	e8 20 fa ff ff       	call   802640 <alloc_block_BF>
  802c20:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    

00802c25 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
  802c28:	53                   	push   %ebx
  802c29:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3e:	74 1e                	je     802c5e <merging+0x39>
  802c40:	ff 75 08             	pushl  0x8(%ebp)
  802c43:	e8 bc f1 ff ff       	call   801e04 <get_block_size>
  802c48:	83 c4 04             	add    $0x4,%esp
  802c4b:	89 c2                	mov    %eax,%edx
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	01 d0                	add    %edx,%eax
  802c52:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c55:	75 07                	jne    802c5e <merging+0x39>
		prev_is_free = 1;
  802c57:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c62:	74 1e                	je     802c82 <merging+0x5d>
  802c64:	ff 75 10             	pushl  0x10(%ebp)
  802c67:	e8 98 f1 ff ff       	call   801e04 <get_block_size>
  802c6c:	83 c4 04             	add    $0x4,%esp
  802c6f:	89 c2                	mov    %eax,%edx
  802c71:	8b 45 10             	mov    0x10(%ebp),%eax
  802c74:	01 d0                	add    %edx,%eax
  802c76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c79:	75 07                	jne    802c82 <merging+0x5d>
		next_is_free = 1;
  802c7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c86:	0f 84 cc 00 00 00    	je     802d58 <merging+0x133>
  802c8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c90:	0f 84 c2 00 00 00    	je     802d58 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c96:	ff 75 08             	pushl  0x8(%ebp)
  802c99:	e8 66 f1 ff ff       	call   801e04 <get_block_size>
  802c9e:	83 c4 04             	add    $0x4,%esp
  802ca1:	89 c3                	mov    %eax,%ebx
  802ca3:	ff 75 10             	pushl  0x10(%ebp)
  802ca6:	e8 59 f1 ff ff       	call   801e04 <get_block_size>
  802cab:	83 c4 04             	add    $0x4,%esp
  802cae:	01 c3                	add    %eax,%ebx
  802cb0:	ff 75 0c             	pushl  0xc(%ebp)
  802cb3:	e8 4c f1 ff ff       	call   801e04 <get_block_size>
  802cb8:	83 c4 04             	add    $0x4,%esp
  802cbb:	01 d8                	add    %ebx,%eax
  802cbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cc0:	6a 00                	push   $0x0
  802cc2:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc5:	ff 75 08             	pushl  0x8(%ebp)
  802cc8:	e8 88 f4 ff ff       	call   802155 <set_block_data>
  802ccd:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd4:	75 17                	jne    802ced <merging+0xc8>
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 2b 43 80 00       	push   $0x80432b
  802cde:	68 7d 01 00 00       	push   $0x17d
  802ce3:	68 49 43 80 00       	push   $0x804349
  802ce8:	e8 b0 0b 00 00       	call   80389d <_panic>
  802ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 10                	je     802d06 <merging+0xe1>
  802cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfe:	8b 52 04             	mov    0x4(%edx),%edx
  802d01:	89 50 04             	mov    %edx,0x4(%eax)
  802d04:	eb 0b                	jmp    802d11 <merging+0xec>
  802d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0f                	je     802d2a <merging+0x105>
  802d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d24:	8b 12                	mov    (%edx),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	eb 0a                	jmp    802d34 <merging+0x10f>
  802d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d47:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4c:	48                   	dec    %eax
  802d4d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d52:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d53:	e9 ea 02 00 00       	jmp    803042 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5c:	74 3b                	je     802d99 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d5e:	83 ec 0c             	sub    $0xc,%esp
  802d61:	ff 75 08             	pushl  0x8(%ebp)
  802d64:	e8 9b f0 ff ff       	call   801e04 <get_block_size>
  802d69:	83 c4 10             	add    $0x10,%esp
  802d6c:	89 c3                	mov    %eax,%ebx
  802d6e:	83 ec 0c             	sub    $0xc,%esp
  802d71:	ff 75 10             	pushl  0x10(%ebp)
  802d74:	e8 8b f0 ff ff       	call   801e04 <get_block_size>
  802d79:	83 c4 10             	add    $0x10,%esp
  802d7c:	01 d8                	add    %ebx,%eax
  802d7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	6a 00                	push   $0x0
  802d86:	ff 75 e8             	pushl  -0x18(%ebp)
  802d89:	ff 75 08             	pushl  0x8(%ebp)
  802d8c:	e8 c4 f3 ff ff       	call   802155 <set_block_data>
  802d91:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d94:	e9 a9 02 00 00       	jmp    803042 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9d:	0f 84 2d 01 00 00    	je     802ed0 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	ff 75 10             	pushl  0x10(%ebp)
  802da9:	e8 56 f0 ff ff       	call   801e04 <get_block_size>
  802dae:	83 c4 10             	add    $0x10,%esp
  802db1:	89 c3                	mov    %eax,%ebx
  802db3:	83 ec 0c             	sub    $0xc,%esp
  802db6:	ff 75 0c             	pushl  0xc(%ebp)
  802db9:	e8 46 f0 ff ff       	call   801e04 <get_block_size>
  802dbe:	83 c4 10             	add    $0x10,%esp
  802dc1:	01 d8                	add    %ebx,%eax
  802dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	6a 00                	push   $0x0
  802dcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dce:	ff 75 10             	pushl  0x10(%ebp)
  802dd1:	e8 7f f3 ff ff       	call   802155 <set_block_data>
  802dd6:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  802ddc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de3:	74 06                	je     802deb <merging+0x1c6>
  802de5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802de9:	75 17                	jne    802e02 <merging+0x1dd>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 04 44 80 00       	push   $0x804404
  802df3:	68 8d 01 00 00       	push   $0x18d
  802df8:	68 49 43 80 00       	push   $0x804349
  802dfd:	e8 9b 0a 00 00       	call   80389d <_panic>
  802e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e05:	8b 50 04             	mov    0x4(%eax),%edx
  802e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0b:	89 50 04             	mov    %edx,0x4(%eax)
  802e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e14:	89 10                	mov    %edx,(%eax)
  802e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 0d                	je     802e2d <merging+0x208>
  802e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	eb 08                	jmp    802e35 <merging+0x210>
  802e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e30:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3b:	89 50 04             	mov    %edx,0x4(%eax)
  802e3e:	a1 38 50 80 00       	mov    0x805038,%eax
  802e43:	40                   	inc    %eax
  802e44:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4d:	75 17                	jne    802e66 <merging+0x241>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 2b 43 80 00       	push   $0x80432b
  802e57:	68 8e 01 00 00       	push   $0x18e
  802e5c:	68 49 43 80 00       	push   $0x804349
  802e61:	e8 37 0a 00 00       	call   80389d <_panic>
  802e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 10                	je     802e7f <merging+0x25a>
  802e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e77:	8b 52 04             	mov    0x4(%edx),%edx
  802e7a:	89 50 04             	mov    %edx,0x4(%eax)
  802e7d:	eb 0b                	jmp    802e8a <merging+0x265>
  802e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 0f                	je     802ea3 <merging+0x27e>
  802e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e97:	8b 40 04             	mov    0x4(%eax),%eax
  802e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9d:	8b 12                	mov    (%edx),%edx
  802e9f:	89 10                	mov    %edx,(%eax)
  802ea1:	eb 0a                	jmp    802ead <merging+0x288>
  802ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec5:	48                   	dec    %eax
  802ec6:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ecb:	e9 72 01 00 00       	jmp    803042 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ed6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eda:	74 79                	je     802f55 <merging+0x330>
  802edc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee0:	74 73                	je     802f55 <merging+0x330>
  802ee2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee6:	74 06                	je     802eee <merging+0x2c9>
  802ee8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eec:	75 17                	jne    802f05 <merging+0x2e0>
  802eee:	83 ec 04             	sub    $0x4,%esp
  802ef1:	68 bc 43 80 00       	push   $0x8043bc
  802ef6:	68 94 01 00 00       	push   $0x194
  802efb:	68 49 43 80 00       	push   $0x804349
  802f00:	e8 98 09 00 00       	call   80389d <_panic>
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	8b 10                	mov    (%eax),%edx
  802f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0b                	je     802f23 <merging+0x2fe>
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f31:	89 50 04             	mov    %edx,0x4(%eax)
  802f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	85 c0                	test   %eax,%eax
  802f3b:	75 08                	jne    802f45 <merging+0x320>
  802f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f40:	a3 30 50 80 00       	mov    %eax,0x805030
  802f45:	a1 38 50 80 00       	mov    0x805038,%eax
  802f4a:	40                   	inc    %eax
  802f4b:	a3 38 50 80 00       	mov    %eax,0x805038
  802f50:	e9 ce 00 00 00       	jmp    803023 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f59:	74 65                	je     802fc0 <merging+0x39b>
  802f5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f5f:	75 17                	jne    802f78 <merging+0x353>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 98 43 80 00       	push   $0x804398
  802f69:	68 95 01 00 00       	push   $0x195
  802f6e:	68 49 43 80 00       	push   $0x804349
  802f73:	e8 25 09 00 00       	call   80389d <_panic>
  802f78:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f87:	8b 40 04             	mov    0x4(%eax),%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	74 0c                	je     802f9a <merging+0x375>
  802f8e:	a1 30 50 80 00       	mov    0x805030,%eax
  802f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f96:	89 10                	mov    %edx,(%eax)
  802f98:	eb 08                	jmp    802fa2 <merging+0x37d>
  802f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa5:	a3 30 50 80 00       	mov    %eax,0x805030
  802faa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb8:	40                   	inc    %eax
  802fb9:	a3 38 50 80 00       	mov    %eax,0x805038
  802fbe:	eb 63                	jmp    803023 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc4:	75 17                	jne    802fdd <merging+0x3b8>
  802fc6:	83 ec 04             	sub    $0x4,%esp
  802fc9:	68 64 43 80 00       	push   $0x804364
  802fce:	68 98 01 00 00       	push   $0x198
  802fd3:	68 49 43 80 00       	push   $0x804349
  802fd8:	e8 c0 08 00 00       	call   80389d <_panic>
  802fdd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fe3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 0d                	je     802ffe <merging+0x3d9>
  802ff1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ff6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ff9:	89 50 04             	mov    %edx,0x4(%eax)
  802ffc:	eb 08                	jmp    803006 <merging+0x3e1>
  802ffe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803001:	a3 30 50 80 00       	mov    %eax,0x805030
  803006:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803009:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80300e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803011:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803018:	a1 38 50 80 00       	mov    0x805038,%eax
  80301d:	40                   	inc    %eax
  80301e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803023:	83 ec 0c             	sub    $0xc,%esp
  803026:	ff 75 10             	pushl  0x10(%ebp)
  803029:	e8 d6 ed ff ff       	call   801e04 <get_block_size>
  80302e:	83 c4 10             	add    $0x10,%esp
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	6a 00                	push   $0x0
  803036:	50                   	push   %eax
  803037:	ff 75 10             	pushl  0x10(%ebp)
  80303a:	e8 16 f1 ff ff       	call   802155 <set_block_data>
  80303f:	83 c4 10             	add    $0x10,%esp
	}
}
  803042:	90                   	nop
  803043:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803046:	c9                   	leave  
  803047:	c3                   	ret    

00803048 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803048:	55                   	push   %ebp
  803049:	89 e5                	mov    %esp,%ebp
  80304b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80304e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803053:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803056:	a1 30 50 80 00       	mov    0x805030,%eax
  80305b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305e:	73 1b                	jae    80307b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803060:	a1 30 50 80 00       	mov    0x805030,%eax
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	ff 75 08             	pushl  0x8(%ebp)
  80306b:	6a 00                	push   $0x0
  80306d:	50                   	push   %eax
  80306e:	e8 b2 fb ff ff       	call   802c25 <merging>
  803073:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803076:	e9 8b 00 00 00       	jmp    803106 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80307b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803080:	3b 45 08             	cmp    0x8(%ebp),%eax
  803083:	76 18                	jbe    80309d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803085:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	ff 75 08             	pushl  0x8(%ebp)
  803090:	50                   	push   %eax
  803091:	6a 00                	push   $0x0
  803093:	e8 8d fb ff ff       	call   802c25 <merging>
  803098:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80309b:	eb 69                	jmp    803106 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80309d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a5:	eb 39                	jmp    8030e0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ad:	73 29                	jae    8030d8 <free_block+0x90>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b7:	76 1f                	jbe    8030d8 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030c1:	83 ec 04             	sub    $0x4,%esp
  8030c4:	ff 75 08             	pushl  0x8(%ebp)
  8030c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8030cd:	e8 53 fb ff ff       	call   802c25 <merging>
  8030d2:	83 c4 10             	add    $0x10,%esp
			break;
  8030d5:	90                   	nop
		}
	}
}
  8030d6:	eb 2e                	jmp    803106 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8030dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e4:	74 07                	je     8030ed <free_block+0xa5>
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	eb 05                	jmp    8030f2 <free_block+0xaa>
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f7:	a1 34 50 80 00       	mov    0x805034,%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	75 a7                	jne    8030a7 <free_block+0x5f>
  803100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803104:	75 a1                	jne    8030a7 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803106:	90                   	nop
  803107:	c9                   	leave  
  803108:	c3                   	ret    

00803109 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803109:	55                   	push   %ebp
  80310a:	89 e5                	mov    %esp,%ebp
  80310c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80310f:	ff 75 08             	pushl  0x8(%ebp)
  803112:	e8 ed ec ff ff       	call   801e04 <get_block_size>
  803117:	83 c4 04             	add    $0x4,%esp
  80311a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80311d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803124:	eb 17                	jmp    80313d <copy_data+0x34>
  803126:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312c:	01 c2                	add    %eax,%edx
  80312e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	01 c8                	add    %ecx,%eax
  803136:	8a 00                	mov    (%eax),%al
  803138:	88 02                	mov    %al,(%edx)
  80313a:	ff 45 fc             	incl   -0x4(%ebp)
  80313d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803140:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803143:	72 e1                	jb     803126 <copy_data+0x1d>
}
  803145:	90                   	nop
  803146:	c9                   	leave  
  803147:	c3                   	ret    

00803148 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803148:	55                   	push   %ebp
  803149:	89 e5                	mov    %esp,%ebp
  80314b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80314e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803152:	75 23                	jne    803177 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803154:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803158:	74 13                	je     80316d <realloc_block_FF+0x25>
  80315a:	83 ec 0c             	sub    $0xc,%esp
  80315d:	ff 75 0c             	pushl  0xc(%ebp)
  803160:	e8 1f f0 ff ff       	call   802184 <alloc_block_FF>
  803165:	83 c4 10             	add    $0x10,%esp
  803168:	e9 f4 06 00 00       	jmp    803861 <realloc_block_FF+0x719>
		return NULL;
  80316d:	b8 00 00 00 00       	mov    $0x0,%eax
  803172:	e9 ea 06 00 00       	jmp    803861 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803177:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80317b:	75 18                	jne    803195 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80317d:	83 ec 0c             	sub    $0xc,%esp
  803180:	ff 75 08             	pushl  0x8(%ebp)
  803183:	e8 c0 fe ff ff       	call   803048 <free_block>
  803188:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80318b:	b8 00 00 00 00       	mov    $0x0,%eax
  803190:	e9 cc 06 00 00       	jmp    803861 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803195:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803199:	77 07                	ja     8031a2 <realloc_block_FF+0x5a>
  80319b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a5:	83 e0 01             	and    $0x1,%eax
  8031a8:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ae:	83 c0 08             	add    $0x8,%eax
  8031b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031b4:	83 ec 0c             	sub    $0xc,%esp
  8031b7:	ff 75 08             	pushl  0x8(%ebp)
  8031ba:	e8 45 ec ff ff       	call   801e04 <get_block_size>
  8031bf:	83 c4 10             	add    $0x10,%esp
  8031c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	83 e8 08             	sub    $0x8,%eax
  8031cb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	83 e8 04             	sub    $0x4,%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	83 e0 fe             	and    $0xfffffffe,%eax
  8031d9:	89 c2                	mov    %eax,%edx
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	01 d0                	add    %edx,%eax
  8031e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031e9:	e8 16 ec ff ff       	call   801e04 <get_block_size>
  8031ee:	83 c4 10             	add    $0x10,%esp
  8031f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f7:	83 e8 08             	sub    $0x8,%eax
  8031fa:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803200:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803203:	75 08                	jne    80320d <realloc_block_FF+0xc5>
	{
		 return va;
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	e9 54 06 00 00       	jmp    803861 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80320d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803210:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803213:	0f 83 e5 03 00 00    	jae    8035fe <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80321f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803222:	83 ec 0c             	sub    $0xc,%esp
  803225:	ff 75 e4             	pushl  -0x1c(%ebp)
  803228:	e8 f0 eb ff ff       	call   801e1d <is_free_block>
  80322d:	83 c4 10             	add    $0x10,%esp
  803230:	84 c0                	test   %al,%al
  803232:	0f 84 3b 01 00 00    	je     803373 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803238:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80323b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80323e:	01 d0                	add    %edx,%eax
  803240:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	6a 01                	push   $0x1
  803248:	ff 75 f0             	pushl  -0x10(%ebp)
  80324b:	ff 75 08             	pushl  0x8(%ebp)
  80324e:	e8 02 ef ff ff       	call   802155 <set_block_data>
  803253:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	83 e8 04             	sub    $0x4,%eax
  80325c:	8b 00                	mov    (%eax),%eax
  80325e:	83 e0 fe             	and    $0xfffffffe,%eax
  803261:	89 c2                	mov    %eax,%edx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	01 d0                	add    %edx,%eax
  803268:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	6a 00                	push   $0x0
  803270:	ff 75 cc             	pushl  -0x34(%ebp)
  803273:	ff 75 c8             	pushl  -0x38(%ebp)
  803276:	e8 da ee ff ff       	call   802155 <set_block_data>
  80327b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80327e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803282:	74 06                	je     80328a <realloc_block_FF+0x142>
  803284:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803288:	75 17                	jne    8032a1 <realloc_block_FF+0x159>
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	68 bc 43 80 00       	push   $0x8043bc
  803292:	68 f6 01 00 00       	push   $0x1f6
  803297:	68 49 43 80 00       	push   $0x804349
  80329c:	e8 fc 05 00 00       	call   80389d <_panic>
  8032a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a4:	8b 10                	mov    (%eax),%edx
  8032a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a9:	89 10                	mov    %edx,(%eax)
  8032ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	85 c0                	test   %eax,%eax
  8032b2:	74 0b                	je     8032bf <realloc_block_FF+0x177>
  8032b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032bc:	89 50 04             	mov    %edx,0x4(%eax)
  8032bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032c5:	89 10                	mov    %edx,(%eax)
  8032c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032cd:	89 50 04             	mov    %edx,0x4(%eax)
  8032d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	75 08                	jne    8032e1 <realloc_block_FF+0x199>
  8032d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e6:	40                   	inc    %eax
  8032e7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032f0:	75 17                	jne    803309 <realloc_block_FF+0x1c1>
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	68 2b 43 80 00       	push   $0x80432b
  8032fa:	68 f7 01 00 00       	push   $0x1f7
  8032ff:	68 49 43 80 00       	push   $0x804349
  803304:	e8 94 05 00 00       	call   80389d <_panic>
  803309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 10                	je     803322 <realloc_block_FF+0x1da>
  803312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331a:	8b 52 04             	mov    0x4(%edx),%edx
  80331d:	89 50 04             	mov    %edx,0x4(%eax)
  803320:	eb 0b                	jmp    80332d <realloc_block_FF+0x1e5>
  803322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803325:	8b 40 04             	mov    0x4(%eax),%eax
  803328:	a3 30 50 80 00       	mov    %eax,0x805030
  80332d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803330:	8b 40 04             	mov    0x4(%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 0f                	je     803346 <realloc_block_FF+0x1fe>
  803337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333a:	8b 40 04             	mov    0x4(%eax),%eax
  80333d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803340:	8b 12                	mov    (%edx),%edx
  803342:	89 10                	mov    %edx,(%eax)
  803344:	eb 0a                	jmp    803350 <realloc_block_FF+0x208>
  803346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803363:	a1 38 50 80 00       	mov    0x805038,%eax
  803368:	48                   	dec    %eax
  803369:	a3 38 50 80 00       	mov    %eax,0x805038
  80336e:	e9 83 02 00 00       	jmp    8035f6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803373:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803377:	0f 86 69 02 00 00    	jbe    8035e6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80337d:	83 ec 04             	sub    $0x4,%esp
  803380:	6a 01                	push   $0x1
  803382:	ff 75 f0             	pushl  -0x10(%ebp)
  803385:	ff 75 08             	pushl  0x8(%ebp)
  803388:	e8 c8 ed ff ff       	call   802155 <set_block_data>
  80338d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	83 e8 04             	sub    $0x4,%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	83 e0 fe             	and    $0xfffffffe,%eax
  80339b:	89 c2                	mov    %eax,%edx
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	01 d0                	add    %edx,%eax
  8033a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8033aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033ad:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033b1:	75 68                	jne    80341b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033b7:	75 17                	jne    8033d0 <realloc_block_FF+0x288>
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	68 64 43 80 00       	push   $0x804364
  8033c1:	68 06 02 00 00       	push   $0x206
  8033c6:	68 49 43 80 00       	push   $0x804349
  8033cb:	e8 cd 04 00 00       	call   80389d <_panic>
  8033d0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d9:	89 10                	mov    %edx,(%eax)
  8033db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	85 c0                	test   %eax,%eax
  8033e2:	74 0d                	je     8033f1 <realloc_block_FF+0x2a9>
  8033e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ec:	89 50 04             	mov    %edx,0x4(%eax)
  8033ef:	eb 08                	jmp    8033f9 <realloc_block_FF+0x2b1>
  8033f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803401:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340b:	a1 38 50 80 00       	mov    0x805038,%eax
  803410:	40                   	inc    %eax
  803411:	a3 38 50 80 00       	mov    %eax,0x805038
  803416:	e9 b0 01 00 00       	jmp    8035cb <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80341b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803420:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803423:	76 68                	jbe    80348d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803425:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803429:	75 17                	jne    803442 <realloc_block_FF+0x2fa>
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	68 64 43 80 00       	push   $0x804364
  803433:	68 0b 02 00 00       	push   $0x20b
  803438:	68 49 43 80 00       	push   $0x804349
  80343d:	e8 5b 04 00 00       	call   80389d <_panic>
  803442:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803448:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344b:	89 10                	mov    %edx,(%eax)
  80344d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	74 0d                	je     803463 <realloc_block_FF+0x31b>
  803456:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80345b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	eb 08                	jmp    80346b <realloc_block_FF+0x323>
  803463:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803466:	a3 30 50 80 00       	mov    %eax,0x805030
  80346b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803473:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803476:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347d:	a1 38 50 80 00       	mov    0x805038,%eax
  803482:	40                   	inc    %eax
  803483:	a3 38 50 80 00       	mov    %eax,0x805038
  803488:	e9 3e 01 00 00       	jmp    8035cb <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80348d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803492:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803495:	73 68                	jae    8034ff <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803497:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349b:	75 17                	jne    8034b4 <realloc_block_FF+0x36c>
  80349d:	83 ec 04             	sub    $0x4,%esp
  8034a0:	68 98 43 80 00       	push   $0x804398
  8034a5:	68 10 02 00 00       	push   $0x210
  8034aa:	68 49 43 80 00       	push   $0x804349
  8034af:	e8 e9 03 00 00       	call   80389d <_panic>
  8034b4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bd:	89 50 04             	mov    %edx,0x4(%eax)
  8034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c3:	8b 40 04             	mov    0x4(%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 0c                	je     8034d6 <realloc_block_FF+0x38e>
  8034ca:	a1 30 50 80 00       	mov    0x805030,%eax
  8034cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d2:	89 10                	mov    %edx,(%eax)
  8034d4:	eb 08                	jmp    8034de <realloc_block_FF+0x396>
  8034d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f4:	40                   	inc    %eax
  8034f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8034fa:	e9 cc 00 00 00       	jmp    8035cb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803506:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350e:	e9 8a 00 00 00       	jmp    80359d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803519:	73 7a                	jae    803595 <realloc_block_FF+0x44d>
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803523:	73 70                	jae    803595 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803529:	74 06                	je     803531 <realloc_block_FF+0x3e9>
  80352b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80352f:	75 17                	jne    803548 <realloc_block_FF+0x400>
  803531:	83 ec 04             	sub    $0x4,%esp
  803534:	68 bc 43 80 00       	push   $0x8043bc
  803539:	68 1a 02 00 00       	push   $0x21a
  80353e:	68 49 43 80 00       	push   $0x804349
  803543:	e8 55 03 00 00       	call   80389d <_panic>
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 10                	mov    (%eax),%edx
  80354d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803550:	89 10                	mov    %edx,(%eax)
  803552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 0b                	je     803566 <realloc_block_FF+0x41e>
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803563:	89 50 04             	mov    %edx,0x4(%eax)
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80356c:	89 10                	mov    %edx,(%eax)
  80356e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	75 08                	jne    803588 <realloc_block_FF+0x440>
  803580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803583:	a3 30 50 80 00       	mov    %eax,0x805030
  803588:	a1 38 50 80 00       	mov    0x805038,%eax
  80358d:	40                   	inc    %eax
  80358e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803593:	eb 36                	jmp    8035cb <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803595:	a1 34 50 80 00       	mov    0x805034,%eax
  80359a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a1:	74 07                	je     8035aa <realloc_block_FF+0x462>
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	eb 05                	jmp    8035af <realloc_block_FF+0x467>
  8035aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8035af:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8035b9:	85 c0                	test   %eax,%eax
  8035bb:	0f 85 52 ff ff ff    	jne    803513 <realloc_block_FF+0x3cb>
  8035c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c5:	0f 85 48 ff ff ff    	jne    803513 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	6a 00                	push   $0x0
  8035d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8035d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035d6:	e8 7a eb ff ff       	call   802155 <set_block_data>
  8035db:	83 c4 10             	add    $0x10,%esp
				return va;
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	e9 7b 02 00 00       	jmp    803861 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035e6:	83 ec 0c             	sub    $0xc,%esp
  8035e9:	68 39 44 80 00       	push   $0x804439
  8035ee:	e8 76 cf ff ff       	call   800569 <cprintf>
  8035f3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	e9 63 02 00 00       	jmp    803861 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803601:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803604:	0f 86 4d 02 00 00    	jbe    803857 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80360a:	83 ec 0c             	sub    $0xc,%esp
  80360d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803610:	e8 08 e8 ff ff       	call   801e1d <is_free_block>
  803615:	83 c4 10             	add    $0x10,%esp
  803618:	84 c0                	test   %al,%al
  80361a:	0f 84 37 02 00 00    	je     803857 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803620:	8b 45 0c             	mov    0xc(%ebp),%eax
  803623:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803626:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803629:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80362c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80362f:	76 38                	jbe    803669 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803631:	83 ec 0c             	sub    $0xc,%esp
  803634:	ff 75 08             	pushl  0x8(%ebp)
  803637:	e8 0c fa ff ff       	call   803048 <free_block>
  80363c:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80363f:	83 ec 0c             	sub    $0xc,%esp
  803642:	ff 75 0c             	pushl  0xc(%ebp)
  803645:	e8 3a eb ff ff       	call   802184 <alloc_block_FF>
  80364a:	83 c4 10             	add    $0x10,%esp
  80364d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803650:	83 ec 08             	sub    $0x8,%esp
  803653:	ff 75 c0             	pushl  -0x40(%ebp)
  803656:	ff 75 08             	pushl  0x8(%ebp)
  803659:	e8 ab fa ff ff       	call   803109 <copy_data>
  80365e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803661:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803664:	e9 f8 01 00 00       	jmp    803861 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803669:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80366f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803672:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803676:	0f 87 a0 00 00 00    	ja     80371c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80367c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803680:	75 17                	jne    803699 <realloc_block_FF+0x551>
  803682:	83 ec 04             	sub    $0x4,%esp
  803685:	68 2b 43 80 00       	push   $0x80432b
  80368a:	68 38 02 00 00       	push   $0x238
  80368f:	68 49 43 80 00       	push   $0x804349
  803694:	e8 04 02 00 00       	call   80389d <_panic>
  803699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 10                	je     8036b2 <realloc_block_FF+0x56a>
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	8b 00                	mov    (%eax),%eax
  8036a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036aa:	8b 52 04             	mov    0x4(%edx),%edx
  8036ad:	89 50 04             	mov    %edx,0x4(%eax)
  8036b0:	eb 0b                	jmp    8036bd <realloc_block_FF+0x575>
  8036b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b5:	8b 40 04             	mov    0x4(%eax),%eax
  8036b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c0:	8b 40 04             	mov    0x4(%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 0f                	je     8036d6 <realloc_block_FF+0x58e>
  8036c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ca:	8b 40 04             	mov    0x4(%eax),%eax
  8036cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d0:	8b 12                	mov    (%edx),%edx
  8036d2:	89 10                	mov    %edx,(%eax)
  8036d4:	eb 0a                	jmp    8036e0 <realloc_block_FF+0x598>
  8036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f8:	48                   	dec    %eax
  8036f9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803704:	01 d0                	add    %edx,%eax
  803706:	83 ec 04             	sub    $0x4,%esp
  803709:	6a 01                	push   $0x1
  80370b:	50                   	push   %eax
  80370c:	ff 75 08             	pushl  0x8(%ebp)
  80370f:	e8 41 ea ff ff       	call   802155 <set_block_data>
  803714:	83 c4 10             	add    $0x10,%esp
  803717:	e9 36 01 00 00       	jmp    803852 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80371c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80371f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803722:	01 d0                	add    %edx,%eax
  803724:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	6a 01                	push   $0x1
  80372c:	ff 75 f0             	pushl  -0x10(%ebp)
  80372f:	ff 75 08             	pushl  0x8(%ebp)
  803732:	e8 1e ea ff ff       	call   802155 <set_block_data>
  803737:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	83 e8 04             	sub    $0x4,%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	83 e0 fe             	and    $0xfffffffe,%eax
  803745:	89 c2                	mov    %eax,%edx
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	01 d0                	add    %edx,%eax
  80374c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80374f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803753:	74 06                	je     80375b <realloc_block_FF+0x613>
  803755:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803759:	75 17                	jne    803772 <realloc_block_FF+0x62a>
  80375b:	83 ec 04             	sub    $0x4,%esp
  80375e:	68 bc 43 80 00       	push   $0x8043bc
  803763:	68 44 02 00 00       	push   $0x244
  803768:	68 49 43 80 00       	push   $0x804349
  80376d:	e8 2b 01 00 00       	call   80389d <_panic>
  803772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803775:	8b 10                	mov    (%eax),%edx
  803777:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377a:	89 10                	mov    %edx,(%eax)
  80377c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	85 c0                	test   %eax,%eax
  803783:	74 0b                	je     803790 <realloc_block_FF+0x648>
  803785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80378d:	89 50 04             	mov    %edx,0x4(%eax)
  803790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803793:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803796:	89 10                	mov    %edx,(%eax)
  803798:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80379e:	89 50 04             	mov    %edx,0x4(%eax)
  8037a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a4:	8b 00                	mov    (%eax),%eax
  8037a6:	85 c0                	test   %eax,%eax
  8037a8:	75 08                	jne    8037b2 <realloc_block_FF+0x66a>
  8037aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ad:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037b7:	40                   	inc    %eax
  8037b8:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c1:	75 17                	jne    8037da <realloc_block_FF+0x692>
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	68 2b 43 80 00       	push   $0x80432b
  8037cb:	68 45 02 00 00       	push   $0x245
  8037d0:	68 49 43 80 00       	push   $0x804349
  8037d5:	e8 c3 00 00 00       	call   80389d <_panic>
  8037da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	85 c0                	test   %eax,%eax
  8037e1:	74 10                	je     8037f3 <realloc_block_FF+0x6ab>
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037eb:	8b 52 04             	mov    0x4(%edx),%edx
  8037ee:	89 50 04             	mov    %edx,0x4(%eax)
  8037f1:	eb 0b                	jmp    8037fe <realloc_block_FF+0x6b6>
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 40 04             	mov    0x4(%eax),%eax
  8037f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8037fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803801:	8b 40 04             	mov    0x4(%eax),%eax
  803804:	85 c0                	test   %eax,%eax
  803806:	74 0f                	je     803817 <realloc_block_FF+0x6cf>
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 40 04             	mov    0x4(%eax),%eax
  80380e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803811:	8b 12                	mov    (%edx),%edx
  803813:	89 10                	mov    %edx,(%eax)
  803815:	eb 0a                	jmp    803821 <realloc_block_FF+0x6d9>
  803817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381a:	8b 00                	mov    (%eax),%eax
  80381c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803824:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803834:	a1 38 50 80 00       	mov    0x805038,%eax
  803839:	48                   	dec    %eax
  80383a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80383f:	83 ec 04             	sub    $0x4,%esp
  803842:	6a 00                	push   $0x0
  803844:	ff 75 bc             	pushl  -0x44(%ebp)
  803847:	ff 75 b8             	pushl  -0x48(%ebp)
  80384a:	e8 06 e9 ff ff       	call   802155 <set_block_data>
  80384f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	eb 0a                	jmp    803861 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803857:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803861:	c9                   	leave  
  803862:	c3                   	ret    

00803863 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803863:	55                   	push   %ebp
  803864:	89 e5                	mov    %esp,%ebp
  803866:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803869:	83 ec 04             	sub    $0x4,%esp
  80386c:	68 40 44 80 00       	push   $0x804440
  803871:	68 58 02 00 00       	push   $0x258
  803876:	68 49 43 80 00       	push   $0x804349
  80387b:	e8 1d 00 00 00       	call   80389d <_panic>

00803880 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803880:	55                   	push   %ebp
  803881:	89 e5                	mov    %esp,%ebp
  803883:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803886:	83 ec 04             	sub    $0x4,%esp
  803889:	68 68 44 80 00       	push   $0x804468
  80388e:	68 61 02 00 00       	push   $0x261
  803893:	68 49 43 80 00       	push   $0x804349
  803898:	e8 00 00 00 00       	call   80389d <_panic>

0080389d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80389d:	55                   	push   %ebp
  80389e:	89 e5                	mov    %esp,%ebp
  8038a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8038a6:	83 c0 04             	add    $0x4,%eax
  8038a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8038ac:	a1 60 50 90 00       	mov    0x905060,%eax
  8038b1:	85 c0                	test   %eax,%eax
  8038b3:	74 16                	je     8038cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8038b5:	a1 60 50 90 00       	mov    0x905060,%eax
  8038ba:	83 ec 08             	sub    $0x8,%esp
  8038bd:	50                   	push   %eax
  8038be:	68 90 44 80 00       	push   $0x804490
  8038c3:	e8 a1 cc ff ff       	call   800569 <cprintf>
  8038c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8038cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8038d0:	ff 75 0c             	pushl  0xc(%ebp)
  8038d3:	ff 75 08             	pushl  0x8(%ebp)
  8038d6:	50                   	push   %eax
  8038d7:	68 95 44 80 00       	push   $0x804495
  8038dc:	e8 88 cc ff ff       	call   800569 <cprintf>
  8038e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8038e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8038e7:	83 ec 08             	sub    $0x8,%esp
  8038ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8038ed:	50                   	push   %eax
  8038ee:	e8 0b cc ff ff       	call   8004fe <vcprintf>
  8038f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8038f6:	83 ec 08             	sub    $0x8,%esp
  8038f9:	6a 00                	push   $0x0
  8038fb:	68 b1 44 80 00       	push   $0x8044b1
  803900:	e8 f9 cb ff ff       	call   8004fe <vcprintf>
  803905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803908:	e8 7a cb ff ff       	call   800487 <exit>

	// should not return here
	while (1) ;
  80390d:	eb fe                	jmp    80390d <_panic+0x70>

0080390f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80390f:	55                   	push   %ebp
  803910:	89 e5                	mov    %esp,%ebp
  803912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803915:	a1 20 50 80 00       	mov    0x805020,%eax
  80391a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803920:	8b 45 0c             	mov    0xc(%ebp),%eax
  803923:	39 c2                	cmp    %eax,%edx
  803925:	74 14                	je     80393b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803927:	83 ec 04             	sub    $0x4,%esp
  80392a:	68 b4 44 80 00       	push   $0x8044b4
  80392f:	6a 26                	push   $0x26
  803931:	68 00 45 80 00       	push   $0x804500
  803936:	e8 62 ff ff ff       	call   80389d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80393b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803942:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803949:	e9 c5 00 00 00       	jmp    803a13 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80394e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	01 d0                	add    %edx,%eax
  80395d:	8b 00                	mov    (%eax),%eax
  80395f:	85 c0                	test   %eax,%eax
  803961:	75 08                	jne    80396b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803963:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803966:	e9 a5 00 00 00       	jmp    803a10 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80396b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803972:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803979:	eb 69                	jmp    8039e4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80397b:	a1 20 50 80 00       	mov    0x805020,%eax
  803980:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803986:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803989:	89 d0                	mov    %edx,%eax
  80398b:	01 c0                	add    %eax,%eax
  80398d:	01 d0                	add    %edx,%eax
  80398f:	c1 e0 03             	shl    $0x3,%eax
  803992:	01 c8                	add    %ecx,%eax
  803994:	8a 40 04             	mov    0x4(%eax),%al
  803997:	84 c0                	test   %al,%al
  803999:	75 46                	jne    8039e1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80399b:	a1 20 50 80 00       	mov    0x805020,%eax
  8039a0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a9:	89 d0                	mov    %edx,%eax
  8039ab:	01 c0                	add    %eax,%eax
  8039ad:	01 d0                	add    %edx,%eax
  8039af:	c1 e0 03             	shl    $0x3,%eax
  8039b2:	01 c8                	add    %ecx,%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8039b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8039c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8039c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d0:	01 c8                	add    %ecx,%eax
  8039d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039d4:	39 c2                	cmp    %eax,%edx
  8039d6:	75 09                	jne    8039e1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8039d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8039df:	eb 15                	jmp    8039f6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039e1:	ff 45 e8             	incl   -0x18(%ebp)
  8039e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8039e9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f2:	39 c2                	cmp    %eax,%edx
  8039f4:	77 85                	ja     80397b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8039f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039fa:	75 14                	jne    803a10 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8039fc:	83 ec 04             	sub    $0x4,%esp
  8039ff:	68 0c 45 80 00       	push   $0x80450c
  803a04:	6a 3a                	push   $0x3a
  803a06:	68 00 45 80 00       	push   $0x804500
  803a0b:	e8 8d fe ff ff       	call   80389d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a10:	ff 45 f0             	incl   -0x10(%ebp)
  803a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a16:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a19:	0f 8c 2f ff ff ff    	jl     80394e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a2d:	eb 26                	jmp    803a55 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a2f:	a1 20 50 80 00       	mov    0x805020,%eax
  803a34:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a3d:	89 d0                	mov    %edx,%eax
  803a3f:	01 c0                	add    %eax,%eax
  803a41:	01 d0                	add    %edx,%eax
  803a43:	c1 e0 03             	shl    $0x3,%eax
  803a46:	01 c8                	add    %ecx,%eax
  803a48:	8a 40 04             	mov    0x4(%eax),%al
  803a4b:	3c 01                	cmp    $0x1,%al
  803a4d:	75 03                	jne    803a52 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a4f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a52:	ff 45 e0             	incl   -0x20(%ebp)
  803a55:	a1 20 50 80 00       	mov    0x805020,%eax
  803a5a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a63:	39 c2                	cmp    %eax,%edx
  803a65:	77 c8                	ja     803a2f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a6d:	74 14                	je     803a83 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a6f:	83 ec 04             	sub    $0x4,%esp
  803a72:	68 60 45 80 00       	push   $0x804560
  803a77:	6a 44                	push   $0x44
  803a79:	68 00 45 80 00       	push   $0x804500
  803a7e:	e8 1a fe ff ff       	call   80389d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a83:	90                   	nop
  803a84:	c9                   	leave  
  803a85:	c3                   	ret    
  803a86:	66 90                	xchg   %ax,%ax

00803a88 <__udivdi3>:
  803a88:	55                   	push   %ebp
  803a89:	57                   	push   %edi
  803a8a:	56                   	push   %esi
  803a8b:	53                   	push   %ebx
  803a8c:	83 ec 1c             	sub    $0x1c,%esp
  803a8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a9f:	89 ca                	mov    %ecx,%edx
  803aa1:	89 f8                	mov    %edi,%eax
  803aa3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803aa7:	85 f6                	test   %esi,%esi
  803aa9:	75 2d                	jne    803ad8 <__udivdi3+0x50>
  803aab:	39 cf                	cmp    %ecx,%edi
  803aad:	77 65                	ja     803b14 <__udivdi3+0x8c>
  803aaf:	89 fd                	mov    %edi,%ebp
  803ab1:	85 ff                	test   %edi,%edi
  803ab3:	75 0b                	jne    803ac0 <__udivdi3+0x38>
  803ab5:	b8 01 00 00 00       	mov    $0x1,%eax
  803aba:	31 d2                	xor    %edx,%edx
  803abc:	f7 f7                	div    %edi
  803abe:	89 c5                	mov    %eax,%ebp
  803ac0:	31 d2                	xor    %edx,%edx
  803ac2:	89 c8                	mov    %ecx,%eax
  803ac4:	f7 f5                	div    %ebp
  803ac6:	89 c1                	mov    %eax,%ecx
  803ac8:	89 d8                	mov    %ebx,%eax
  803aca:	f7 f5                	div    %ebp
  803acc:	89 cf                	mov    %ecx,%edi
  803ace:	89 fa                	mov    %edi,%edx
  803ad0:	83 c4 1c             	add    $0x1c,%esp
  803ad3:	5b                   	pop    %ebx
  803ad4:	5e                   	pop    %esi
  803ad5:	5f                   	pop    %edi
  803ad6:	5d                   	pop    %ebp
  803ad7:	c3                   	ret    
  803ad8:	39 ce                	cmp    %ecx,%esi
  803ada:	77 28                	ja     803b04 <__udivdi3+0x7c>
  803adc:	0f bd fe             	bsr    %esi,%edi
  803adf:	83 f7 1f             	xor    $0x1f,%edi
  803ae2:	75 40                	jne    803b24 <__udivdi3+0x9c>
  803ae4:	39 ce                	cmp    %ecx,%esi
  803ae6:	72 0a                	jb     803af2 <__udivdi3+0x6a>
  803ae8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803aec:	0f 87 9e 00 00 00    	ja     803b90 <__udivdi3+0x108>
  803af2:	b8 01 00 00 00       	mov    $0x1,%eax
  803af7:	89 fa                	mov    %edi,%edx
  803af9:	83 c4 1c             	add    $0x1c,%esp
  803afc:	5b                   	pop    %ebx
  803afd:	5e                   	pop    %esi
  803afe:	5f                   	pop    %edi
  803aff:	5d                   	pop    %ebp
  803b00:	c3                   	ret    
  803b01:	8d 76 00             	lea    0x0(%esi),%esi
  803b04:	31 ff                	xor    %edi,%edi
  803b06:	31 c0                	xor    %eax,%eax
  803b08:	89 fa                	mov    %edi,%edx
  803b0a:	83 c4 1c             	add    $0x1c,%esp
  803b0d:	5b                   	pop    %ebx
  803b0e:	5e                   	pop    %esi
  803b0f:	5f                   	pop    %edi
  803b10:	5d                   	pop    %ebp
  803b11:	c3                   	ret    
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	89 d8                	mov    %ebx,%eax
  803b16:	f7 f7                	div    %edi
  803b18:	31 ff                	xor    %edi,%edi
  803b1a:	89 fa                	mov    %edi,%edx
  803b1c:	83 c4 1c             	add    $0x1c,%esp
  803b1f:	5b                   	pop    %ebx
  803b20:	5e                   	pop    %esi
  803b21:	5f                   	pop    %edi
  803b22:	5d                   	pop    %ebp
  803b23:	c3                   	ret    
  803b24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b29:	89 eb                	mov    %ebp,%ebx
  803b2b:	29 fb                	sub    %edi,%ebx
  803b2d:	89 f9                	mov    %edi,%ecx
  803b2f:	d3 e6                	shl    %cl,%esi
  803b31:	89 c5                	mov    %eax,%ebp
  803b33:	88 d9                	mov    %bl,%cl
  803b35:	d3 ed                	shr    %cl,%ebp
  803b37:	89 e9                	mov    %ebp,%ecx
  803b39:	09 f1                	or     %esi,%ecx
  803b3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b3f:	89 f9                	mov    %edi,%ecx
  803b41:	d3 e0                	shl    %cl,%eax
  803b43:	89 c5                	mov    %eax,%ebp
  803b45:	89 d6                	mov    %edx,%esi
  803b47:	88 d9                	mov    %bl,%cl
  803b49:	d3 ee                	shr    %cl,%esi
  803b4b:	89 f9                	mov    %edi,%ecx
  803b4d:	d3 e2                	shl    %cl,%edx
  803b4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b53:	88 d9                	mov    %bl,%cl
  803b55:	d3 e8                	shr    %cl,%eax
  803b57:	09 c2                	or     %eax,%edx
  803b59:	89 d0                	mov    %edx,%eax
  803b5b:	89 f2                	mov    %esi,%edx
  803b5d:	f7 74 24 0c          	divl   0xc(%esp)
  803b61:	89 d6                	mov    %edx,%esi
  803b63:	89 c3                	mov    %eax,%ebx
  803b65:	f7 e5                	mul    %ebp
  803b67:	39 d6                	cmp    %edx,%esi
  803b69:	72 19                	jb     803b84 <__udivdi3+0xfc>
  803b6b:	74 0b                	je     803b78 <__udivdi3+0xf0>
  803b6d:	89 d8                	mov    %ebx,%eax
  803b6f:	31 ff                	xor    %edi,%edi
  803b71:	e9 58 ff ff ff       	jmp    803ace <__udivdi3+0x46>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b7c:	89 f9                	mov    %edi,%ecx
  803b7e:	d3 e2                	shl    %cl,%edx
  803b80:	39 c2                	cmp    %eax,%edx
  803b82:	73 e9                	jae    803b6d <__udivdi3+0xe5>
  803b84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b87:	31 ff                	xor    %edi,%edi
  803b89:	e9 40 ff ff ff       	jmp    803ace <__udivdi3+0x46>
  803b8e:	66 90                	xchg   %ax,%ax
  803b90:	31 c0                	xor    %eax,%eax
  803b92:	e9 37 ff ff ff       	jmp    803ace <__udivdi3+0x46>
  803b97:	90                   	nop

00803b98 <__umoddi3>:
  803b98:	55                   	push   %ebp
  803b99:	57                   	push   %edi
  803b9a:	56                   	push   %esi
  803b9b:	53                   	push   %ebx
  803b9c:	83 ec 1c             	sub    $0x1c,%esp
  803b9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ba3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ba7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803baf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bb7:	89 f3                	mov    %esi,%ebx
  803bb9:	89 fa                	mov    %edi,%edx
  803bbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bbf:	89 34 24             	mov    %esi,(%esp)
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	75 1a                	jne    803be0 <__umoddi3+0x48>
  803bc6:	39 f7                	cmp    %esi,%edi
  803bc8:	0f 86 a2 00 00 00    	jbe    803c70 <__umoddi3+0xd8>
  803bce:	89 c8                	mov    %ecx,%eax
  803bd0:	89 f2                	mov    %esi,%edx
  803bd2:	f7 f7                	div    %edi
  803bd4:	89 d0                	mov    %edx,%eax
  803bd6:	31 d2                	xor    %edx,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	39 f0                	cmp    %esi,%eax
  803be2:	0f 87 ac 00 00 00    	ja     803c94 <__umoddi3+0xfc>
  803be8:	0f bd e8             	bsr    %eax,%ebp
  803beb:	83 f5 1f             	xor    $0x1f,%ebp
  803bee:	0f 84 ac 00 00 00    	je     803ca0 <__umoddi3+0x108>
  803bf4:	bf 20 00 00 00       	mov    $0x20,%edi
  803bf9:	29 ef                	sub    %ebp,%edi
  803bfb:	89 fe                	mov    %edi,%esi
  803bfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c01:	89 e9                	mov    %ebp,%ecx
  803c03:	d3 e0                	shl    %cl,%eax
  803c05:	89 d7                	mov    %edx,%edi
  803c07:	89 f1                	mov    %esi,%ecx
  803c09:	d3 ef                	shr    %cl,%edi
  803c0b:	09 c7                	or     %eax,%edi
  803c0d:	89 e9                	mov    %ebp,%ecx
  803c0f:	d3 e2                	shl    %cl,%edx
  803c11:	89 14 24             	mov    %edx,(%esp)
  803c14:	89 d8                	mov    %ebx,%eax
  803c16:	d3 e0                	shl    %cl,%eax
  803c18:	89 c2                	mov    %eax,%edx
  803c1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c1e:	d3 e0                	shl    %cl,%eax
  803c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c28:	89 f1                	mov    %esi,%ecx
  803c2a:	d3 e8                	shr    %cl,%eax
  803c2c:	09 d0                	or     %edx,%eax
  803c2e:	d3 eb                	shr    %cl,%ebx
  803c30:	89 da                	mov    %ebx,%edx
  803c32:	f7 f7                	div    %edi
  803c34:	89 d3                	mov    %edx,%ebx
  803c36:	f7 24 24             	mull   (%esp)
  803c39:	89 c6                	mov    %eax,%esi
  803c3b:	89 d1                	mov    %edx,%ecx
  803c3d:	39 d3                	cmp    %edx,%ebx
  803c3f:	0f 82 87 00 00 00    	jb     803ccc <__umoddi3+0x134>
  803c45:	0f 84 91 00 00 00    	je     803cdc <__umoddi3+0x144>
  803c4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c4f:	29 f2                	sub    %esi,%edx
  803c51:	19 cb                	sbb    %ecx,%ebx
  803c53:	89 d8                	mov    %ebx,%eax
  803c55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c59:	d3 e0                	shl    %cl,%eax
  803c5b:	89 e9                	mov    %ebp,%ecx
  803c5d:	d3 ea                	shr    %cl,%edx
  803c5f:	09 d0                	or     %edx,%eax
  803c61:	89 e9                	mov    %ebp,%ecx
  803c63:	d3 eb                	shr    %cl,%ebx
  803c65:	89 da                	mov    %ebx,%edx
  803c67:	83 c4 1c             	add    $0x1c,%esp
  803c6a:	5b                   	pop    %ebx
  803c6b:	5e                   	pop    %esi
  803c6c:	5f                   	pop    %edi
  803c6d:	5d                   	pop    %ebp
  803c6e:	c3                   	ret    
  803c6f:	90                   	nop
  803c70:	89 fd                	mov    %edi,%ebp
  803c72:	85 ff                	test   %edi,%edi
  803c74:	75 0b                	jne    803c81 <__umoddi3+0xe9>
  803c76:	b8 01 00 00 00       	mov    $0x1,%eax
  803c7b:	31 d2                	xor    %edx,%edx
  803c7d:	f7 f7                	div    %edi
  803c7f:	89 c5                	mov    %eax,%ebp
  803c81:	89 f0                	mov    %esi,%eax
  803c83:	31 d2                	xor    %edx,%edx
  803c85:	f7 f5                	div    %ebp
  803c87:	89 c8                	mov    %ecx,%eax
  803c89:	f7 f5                	div    %ebp
  803c8b:	89 d0                	mov    %edx,%eax
  803c8d:	e9 44 ff ff ff       	jmp    803bd6 <__umoddi3+0x3e>
  803c92:	66 90                	xchg   %ax,%ax
  803c94:	89 c8                	mov    %ecx,%eax
  803c96:	89 f2                	mov    %esi,%edx
  803c98:	83 c4 1c             	add    $0x1c,%esp
  803c9b:	5b                   	pop    %ebx
  803c9c:	5e                   	pop    %esi
  803c9d:	5f                   	pop    %edi
  803c9e:	5d                   	pop    %ebp
  803c9f:	c3                   	ret    
  803ca0:	3b 04 24             	cmp    (%esp),%eax
  803ca3:	72 06                	jb     803cab <__umoddi3+0x113>
  803ca5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ca9:	77 0f                	ja     803cba <__umoddi3+0x122>
  803cab:	89 f2                	mov    %esi,%edx
  803cad:	29 f9                	sub    %edi,%ecx
  803caf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cb3:	89 14 24             	mov    %edx,(%esp)
  803cb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cbe:	8b 14 24             	mov    (%esp),%edx
  803cc1:	83 c4 1c             	add    $0x1c,%esp
  803cc4:	5b                   	pop    %ebx
  803cc5:	5e                   	pop    %esi
  803cc6:	5f                   	pop    %edi
  803cc7:	5d                   	pop    %ebp
  803cc8:	c3                   	ret    
  803cc9:	8d 76 00             	lea    0x0(%esi),%esi
  803ccc:	2b 04 24             	sub    (%esp),%eax
  803ccf:	19 fa                	sbb    %edi,%edx
  803cd1:	89 d1                	mov    %edx,%ecx
  803cd3:	89 c6                	mov    %eax,%esi
  803cd5:	e9 71 ff ff ff       	jmp    803c4b <__umoddi3+0xb3>
  803cda:	66 90                	xchg   %ax,%ax
  803cdc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ce0:	72 ea                	jb     803ccc <__umoddi3+0x134>
  803ce2:	89 d9                	mov    %ebx,%ecx
  803ce4:	e9 62 ff ff ff       	jmp    803c4b <__umoddi3+0xb3>
