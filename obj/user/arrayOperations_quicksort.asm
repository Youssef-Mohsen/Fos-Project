
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
  80003e:	e8 00 1a 00 00       	call   801a43 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 2a 1a 00 00       	call   801a75 <sys_getparentenvid>
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
  80005f:	68 a0 3c 80 00       	push   $0x803ca0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 59 16 00 00       	call   8016c5 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a4 3c 80 00       	push   $0x803ca4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 43 16 00 00       	call   8016c5 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ac 3c 80 00       	push   $0x803cac
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
  8000b3:	68 ba 3c 80 00       	push   $0x803cba
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
  800112:	68 c9 3c 80 00       	push   $0x803cc9
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
  800166:	e8 3d 19 00 00       	call   801aa8 <sys_get_virtual_time>
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
  8002f6:	68 e5 3c 80 00       	push   $0x803ce5
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
  800318:	68 e7 3c 80 00       	push   $0x803ce7
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
  800346:	68 ec 3c 80 00       	push   $0x803cec
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
  80035c:	e8 fb 16 00 00       	call   801a5c <sys_getenvindex>
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
  8003ca:	e8 11 14 00 00       	call   8017e0 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	68 08 3d 80 00       	push   $0x803d08
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
  8003fa:	68 30 3d 80 00       	push   $0x803d30
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
  80042b:	68 58 3d 80 00       	push   $0x803d58
  800430:	e8 34 01 00 00       	call   800569 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	50                   	push   %eax
  800447:	68 b0 3d 80 00       	push   $0x803db0
  80044c:	e8 18 01 00 00       	call   800569 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	68 08 3d 80 00       	push   $0x803d08
  80045c:	e8 08 01 00 00       	call   800569 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800464:	e8 91 13 00 00       	call   8017fa <sys_unlock_cons>
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
  80047c:	e8 a7 15 00 00       	call   801a28 <sys_destroy_env>
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
  80048d:	e8 fc 15 00 00       	call   801a8e <sys_exit_env>
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
  8004db:	e8 be 12 00 00       	call   80179e <sys_cputs>
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
  800552:	e8 47 12 00 00       	call   80179e <sys_cputs>
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
  80059c:	e8 3f 12 00 00       	call   8017e0 <sys_lock_cons>
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
  8005bc:	e8 39 12 00 00       	call   8017fa <sys_unlock_cons>
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
  800606:	e8 15 34 00 00       	call   803a20 <__udivdi3>
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
  800656:	e8 d5 34 00 00       	call   803b30 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 f4 3f 80 00       	add    $0x803ff4,%eax
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
  8007b1:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
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
  800892:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 05 40 80 00       	push   $0x804005
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
  8008b7:	68 0e 40 80 00       	push   $0x80400e
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
  8008e4:	be 11 40 80 00       	mov    $0x804011,%esi
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
  8012ef:	68 88 41 80 00       	push   $0x804188
  8012f4:	68 3f 01 00 00       	push   $0x13f
  8012f9:	68 aa 41 80 00       	push   $0x8041aa
  8012fe:	e8 32 25 00 00       	call   803835 <_panic>

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
  80130f:	e8 35 0a 00 00       	call   801d49 <sys_sbrk>
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
  80138a:	e8 3e 08 00 00       	call   801bcd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 16                	je     8013a9 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 7e 0d 00 00       	call   80211c <alloc_block_FF>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a4:	e9 8a 01 00 00       	jmp    801533 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013a9:	e8 50 08 00 00       	call   801bfe <sys_isUHeapPlacementStrategyBESTFIT>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	0f 84 7d 01 00 00    	je     801533 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 17 12 00 00       	call   8025d8 <alloc_block_BF>
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
  801522:	e8 59 08 00 00       	call   801d80 <sys_allocate_user_mem>
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
  80156a:	e8 2d 08 00 00       	call   801d9c <get_block_size>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 60 1a 00 00       	call   802fe0 <free_block>
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
  801612:	e8 4d 07 00 00       	call   801d64 <sys_free_user_mem>
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
  801620:	68 b8 41 80 00       	push   $0x8041b8
  801625:	68 84 00 00 00       	push   $0x84
  80162a:	68 e2 41 80 00       	push   $0x8041e2
  80162f:	e8 01 22 00 00       	call   803835 <_panic>
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
  801692:	e8 d4 02 00 00       	call   80196b <sys_createSharedObject>
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
  8016b3:	68 ee 41 80 00       	push   $0x8041ee
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
  8016c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 f4 41 80 00       	push   $0x8041f4
  8016d3:	68 a4 00 00 00       	push   $0xa4
  8016d8:	68 e2 41 80 00       	push   $0x8041e2
  8016dd:	e8 53 21 00 00       	call   803835 <_panic>

008016e2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 18 42 80 00       	push   $0x804218
  8016f0:	68 bc 00 00 00       	push   $0xbc
  8016f5:	68 e2 41 80 00       	push   $0x8041e2
  8016fa:	e8 36 21 00 00       	call   803835 <_panic>

008016ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 3c 42 80 00       	push   $0x80423c
  80170d:	68 d3 00 00 00       	push   $0xd3
  801712:	68 e2 41 80 00       	push   $0x8041e2
  801717:	e8 19 21 00 00       	call   803835 <_panic>

0080171c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	68 62 42 80 00       	push   $0x804262
  80172a:	68 df 00 00 00       	push   $0xdf
  80172f:	68 e2 41 80 00       	push   $0x8041e2
  801734:	e8 fc 20 00 00       	call   803835 <_panic>

00801739 <shrink>:

}
void shrink(uint32 newSize)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 62 42 80 00       	push   $0x804262
  801747:	68 e4 00 00 00       	push   $0xe4
  80174c:	68 e2 41 80 00       	push   $0x8041e2
  801751:	e8 df 20 00 00       	call   803835 <_panic>

00801756 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	68 62 42 80 00       	push   $0x804262
  801764:	68 e9 00 00 00       	push   $0xe9
  801769:	68 e2 41 80 00       	push   $0x8041e2
  80176e:	e8 c2 20 00 00       	call   803835 <_panic>

00801773 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801785:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801788:	8b 7d 18             	mov    0x18(%ebp),%edi
  80178b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80178e:	cd 30                	int    $0x30
  801790:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	52                   	push   %edx
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	50                   	push   %eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	e8 b2 ff ff ff       	call   801773 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 02                	push   $0x2
  8017d6:	e8 98 ff ff ff       	call   801773 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 03                	push   $0x3
  8017ef:	e8 7f ff ff ff       	call   801773 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 04                	push   $0x4
  801809:	e8 65 ff ff ff       	call   801773 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	90                   	nop
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 08                	push   $0x8
  801827:	e8 47 ff ff ff       	call   801773 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	56                   	push   %esi
  801835:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801836:	8b 75 18             	mov    0x18(%ebp),%esi
  801839:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
  801847:	51                   	push   %ecx
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	6a 09                	push   $0x9
  80184c:	e8 22 ff ff ff       	call   801773 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    

0080185b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	52                   	push   %edx
  80186b:	50                   	push   %eax
  80186c:	6a 0a                	push   $0xa
  80186e:	e8 00 ff ff ff       	call   801773 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 0b                	push   $0xb
  801889:	e8 e5 fe ff ff       	call   801773 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 0c                	push   $0xc
  8018a2:	e8 cc fe ff ff       	call   801773 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 0d                	push   $0xd
  8018bb:	e8 b3 fe ff ff       	call   801773 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 0e                	push   $0xe
  8018d4:	e8 9a fe ff ff       	call   801773 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 0f                	push   $0xf
  8018ed:	e8 81 fe ff ff       	call   801773 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	6a 10                	push   $0x10
  801907:	e8 67 fe ff ff       	call   801773 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 11                	push   $0x11
  801920:	e8 4e fe ff ff       	call   801773 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_cputc>:

void
sys_cputc(const char c)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801937:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	50                   	push   %eax
  801944:	6a 01                	push   $0x1
  801946:	e8 28 fe ff ff       	call   801773 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	90                   	nop
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 14                	push   $0x14
  801960:	e8 0e fe ff ff       	call   801773 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	90                   	nop
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801977:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80197a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	51                   	push   %ecx
  801984:	52                   	push   %edx
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	50                   	push   %eax
  801989:	6a 15                	push   $0x15
  80198b:	e8 e3 fd ff ff       	call   801773 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	52                   	push   %edx
  8019a5:	50                   	push   %eax
  8019a6:	6a 16                	push   $0x16
  8019a8:	e8 c6 fd ff ff       	call   801773 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	51                   	push   %ecx
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 17                	push   $0x17
  8019c7:	e8 a7 fd ff ff       	call   801773 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 18                	push   $0x18
  8019e4:	e8 8a fd ff ff       	call   801773 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	ff 75 14             	pushl  0x14(%ebp)
  8019f9:	ff 75 10             	pushl  0x10(%ebp)
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	6a 19                	push   $0x19
  801a02:	e8 6c fd ff ff       	call   801773 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	50                   	push   %eax
  801a1b:	6a 1a                	push   $0x1a
  801a1d:	e8 51 fd ff ff       	call   801773 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	50                   	push   %eax
  801a37:	6a 1b                	push   $0x1b
  801a39:	e8 35 fd ff ff       	call   801773 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 05                	push   $0x5
  801a52:	e8 1c fd ff ff       	call   801773 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 06                	push   $0x6
  801a6b:	e8 03 fd ff ff       	call   801773 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 07                	push   $0x7
  801a84:	e8 ea fc ff ff       	call   801773 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_exit_env>:


void sys_exit_env(void)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 1c                	push   $0x1c
  801a9d:	e8 d1 fc ff ff       	call   801773 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	90                   	nop
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab1:	8d 50 04             	lea    0x4(%eax),%edx
  801ab4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	52                   	push   %edx
  801abe:	50                   	push   %eax
  801abf:	6a 1d                	push   $0x1d
  801ac1:	e8 ad fc ff ff       	call   801773 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801acc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801acf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad2:	89 01                	mov    %eax,(%ecx)
  801ad4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	c9                   	leave  
  801adb:	c2 04 00             	ret    $0x4

00801ade <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	6a 13                	push   $0x13
  801af0:	e8 7e fc ff ff       	call   801773 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return ;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_rcr2>:
uint32 sys_rcr2()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 1e                	push   $0x1e
  801b0a:	e8 64 fc ff ff       	call   801773 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b20:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	50                   	push   %eax
  801b2d:	6a 1f                	push   $0x1f
  801b2f:	e8 3f fc ff ff       	call   801773 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return ;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <rsttst>:
void rsttst()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 21                	push   $0x21
  801b49:	e8 25 fc ff ff       	call   801773 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b51:	90                   	nop
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b60:	8b 55 18             	mov    0x18(%ebp),%edx
  801b63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	ff 75 08             	pushl  0x8(%ebp)
  801b72:	6a 20                	push   $0x20
  801b74:	e8 fa fb ff ff       	call   801773 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7c:	90                   	nop
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <chktst>:
void chktst(uint32 n)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 08             	pushl  0x8(%ebp)
  801b8d:	6a 22                	push   $0x22
  801b8f:	e8 df fb ff ff       	call   801773 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
	return ;
  801b97:	90                   	nop
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <inctst>:

void inctst()
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 23                	push   $0x23
  801ba9:	e8 c5 fb ff ff       	call   801773 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb1:	90                   	nop
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <gettst>:
uint32 gettst()
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 24                	push   $0x24
  801bc3:	e8 ab fb ff ff       	call   801773 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 25                	push   $0x25
  801bdf:	e8 8f fb ff ff       	call   801773 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
  801be7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bee:	75 07                	jne    801bf7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bf0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf5:	eb 05                	jmp    801bfc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 25                	push   $0x25
  801c10:	e8 5e fb ff ff       	call   801773 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
  801c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c1b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c1f:	75 07                	jne    801c28 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c21:	b8 01 00 00 00       	mov    $0x1,%eax
  801c26:	eb 05                	jmp    801c2d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 25                	push   $0x25
  801c41:	e8 2d fb ff ff       	call   801773 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
  801c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c4c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c50:	75 07                	jne    801c59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	eb 05                	jmp    801c5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 25                	push   $0x25
  801c72:	e8 fc fa ff ff       	call   801773 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
  801c7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c81:	75 07                	jne    801c8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c83:	b8 01 00 00 00       	mov    $0x1,%eax
  801c88:	eb 05                	jmp    801c8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	6a 26                	push   $0x26
  801ca1:	e8 cd fa ff ff       	call   801773 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	53                   	push   %ebx
  801cbf:	51                   	push   %ecx
  801cc0:	52                   	push   %edx
  801cc1:	50                   	push   %eax
  801cc2:	6a 27                	push   $0x27
  801cc4:	e8 aa fa ff ff       	call   801773 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	6a 28                	push   $0x28
  801ce4:	e8 8a fa ff ff       	call   801773 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cf1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	51                   	push   %ecx
  801cfd:	ff 75 10             	pushl  0x10(%ebp)
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 29                	push   $0x29
  801d04:	e8 6a fa ff ff       	call   801773 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 10             	pushl  0x10(%ebp)
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 12                	push   $0x12
  801d20:	e8 4e fa ff ff       	call   801773 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	52                   	push   %edx
  801d3b:	50                   	push   %eax
  801d3c:	6a 2a                	push   $0x2a
  801d3e:	e8 30 fa ff ff       	call   801773 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
	return;
  801d46:	90                   	nop
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	50                   	push   %eax
  801d58:	6a 2b                	push   $0x2b
  801d5a:	e8 14 fa ff ff       	call   801773 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 2c                	push   $0x2c
  801d75:	e8 f9 f9 ff ff       	call   801773 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	ff 75 08             	pushl  0x8(%ebp)
  801d8f:	6a 2d                	push   $0x2d
  801d91:	e8 dd f9 ff ff       	call   801773 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
	return;
  801d99:	90                   	nop
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	83 e8 04             	sub    $0x4,%eax
  801da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	83 e8 04             	sub    $0x4,%eax
  801dc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc7:	8b 00                	mov    (%eax),%eax
  801dc9:	83 e0 01             	and    $0x1,%eax
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	0f 94 c0             	sete   %al
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801dd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	83 f8 02             	cmp    $0x2,%eax
  801de6:	74 2b                	je     801e13 <alloc_block+0x40>
  801de8:	83 f8 02             	cmp    $0x2,%eax
  801deb:	7f 07                	jg     801df4 <alloc_block+0x21>
  801ded:	83 f8 01             	cmp    $0x1,%eax
  801df0:	74 0e                	je     801e00 <alloc_block+0x2d>
  801df2:	eb 58                	jmp    801e4c <alloc_block+0x79>
  801df4:	83 f8 03             	cmp    $0x3,%eax
  801df7:	74 2d                	je     801e26 <alloc_block+0x53>
  801df9:	83 f8 04             	cmp    $0x4,%eax
  801dfc:	74 3b                	je     801e39 <alloc_block+0x66>
  801dfe:	eb 4c                	jmp    801e4c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	e8 11 03 00 00       	call   80211c <alloc_block_FF>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e11:	eb 4a                	jmp    801e5d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	e8 fa 19 00 00       	call   803818 <alloc_block_NF>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e24:	eb 37                	jmp    801e5d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	e8 a7 07 00 00       	call   8025d8 <alloc_block_BF>
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e37:	eb 24                	jmp    801e5d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	e8 b7 19 00 00       	call   8037fb <alloc_block_WF>
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e4a:	eb 11                	jmp    801e5d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	68 74 42 80 00       	push   $0x804274
  801e54:	e8 10 e7 ff ff       	call   800569 <cprintf>
  801e59:	83 c4 10             	add    $0x10,%esp
		break;
  801e5c:	90                   	nop
	}
	return va;
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	53                   	push   %ebx
  801e66:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	68 94 42 80 00       	push   $0x804294
  801e71:	e8 f3 e6 ff ff       	call   800569 <cprintf>
  801e76:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	68 bf 42 80 00       	push   $0x8042bf
  801e81:	e8 e3 e6 ff ff       	call   800569 <cprintf>
  801e86:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8f:	eb 37                	jmp    801ec8 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 f4             	pushl  -0xc(%ebp)
  801e97:	e8 19 ff ff ff       	call   801db5 <is_free_block>
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	0f be d8             	movsbl %al,%ebx
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea8:	e8 ef fe ff ff       	call   801d9c <get_block_size>
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	53                   	push   %ebx
  801eb4:	50                   	push   %eax
  801eb5:	68 d7 42 80 00       	push   $0x8042d7
  801eba:	e8 aa e6 ff ff       	call   800569 <cprintf>
  801ebf:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecc:	74 07                	je     801ed5 <print_blocks_list+0x73>
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 00                	mov    (%eax),%eax
  801ed3:	eb 05                	jmp    801eda <print_blocks_list+0x78>
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	89 45 10             	mov    %eax,0x10(%ebp)
  801edd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	75 ad                	jne    801e91 <print_blocks_list+0x2f>
  801ee4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee8:	75 a7                	jne    801e91 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	68 94 42 80 00       	push   $0x804294
  801ef2:	e8 72 e6 ff ff       	call   800569 <cprintf>
  801ef7:	83 c4 10             	add    $0x10,%esp

}
  801efa:	90                   	nop
  801efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f09:	83 e0 01             	and    $0x1,%eax
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	74 03                	je     801f13 <initialize_dynamic_allocator+0x13>
  801f10:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f17:	0f 84 c7 01 00 00    	je     8020e4 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f1d:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f24:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f27:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2d:	01 d0                	add    %edx,%eax
  801f2f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f34:	0f 87 ad 01 00 00    	ja     8020e7 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	0f 89 a5 01 00 00    	jns    8020ea <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f45:	8b 55 08             	mov    0x8(%ebp),%edx
  801f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4b:	01 d0                	add    %edx,%eax
  801f4d:	83 e8 04             	sub    $0x4,%eax
  801f50:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f5c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f64:	e9 87 00 00 00       	jmp    801ff0 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6d:	75 14                	jne    801f83 <initialize_dynamic_allocator+0x83>
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	68 ef 42 80 00       	push   $0x8042ef
  801f77:	6a 79                	push   $0x79
  801f79:	68 0d 43 80 00       	push   $0x80430d
  801f7e:	e8 b2 18 00 00       	call   803835 <_panic>
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 00                	mov    (%eax),%eax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	74 10                	je     801f9c <initialize_dynamic_allocator+0x9c>
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	8b 00                	mov    (%eax),%eax
  801f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f94:	8b 52 04             	mov    0x4(%edx),%edx
  801f97:	89 50 04             	mov    %edx,0x4(%eax)
  801f9a:	eb 0b                	jmp    801fa7 <initialize_dynamic_allocator+0xa7>
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 40 04             	mov    0x4(%eax),%eax
  801fa2:	a3 30 50 80 00       	mov    %eax,0x805030
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 40 04             	mov    0x4(%eax),%eax
  801fad:	85 c0                	test   %eax,%eax
  801faf:	74 0f                	je     801fc0 <initialize_dynamic_allocator+0xc0>
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 40 04             	mov    0x4(%eax),%eax
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	8b 12                	mov    (%edx),%edx
  801fbc:	89 10                	mov    %edx,(%eax)
  801fbe:	eb 0a                	jmp    801fca <initialize_dynamic_allocator+0xca>
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fdd:	a1 38 50 80 00       	mov    0x805038,%eax
  801fe2:	48                   	dec    %eax
  801fe3:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fe8:	a1 34 50 80 00       	mov    0x805034,%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff4:	74 07                	je     801ffd <initialize_dynamic_allocator+0xfd>
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	eb 05                	jmp    802002 <initialize_dynamic_allocator+0x102>
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	a3 34 50 80 00       	mov    %eax,0x805034
  802007:	a1 34 50 80 00       	mov    0x805034,%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	0f 85 55 ff ff ff    	jne    801f69 <initialize_dynamic_allocator+0x69>
  802014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802018:	0f 85 4b ff ff ff    	jne    801f69 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802027:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80202d:	a1 44 50 80 00       	mov    0x805044,%eax
  802032:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802037:	a1 40 50 80 00       	mov    0x805040,%eax
  80203c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	83 c0 08             	add    $0x8,%eax
  802048:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	83 c0 04             	add    $0x4,%eax
  802051:	8b 55 0c             	mov    0xc(%ebp),%edx
  802054:	83 ea 08             	sub    $0x8,%edx
  802057:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	01 d0                	add    %edx,%eax
  802061:	83 e8 08             	sub    $0x8,%eax
  802064:	8b 55 0c             	mov    0xc(%ebp),%edx
  802067:	83 ea 08             	sub    $0x8,%edx
  80206a:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80206c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802078:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80207f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802083:	75 17                	jne    80209c <initialize_dynamic_allocator+0x19c>
  802085:	83 ec 04             	sub    $0x4,%esp
  802088:	68 28 43 80 00       	push   $0x804328
  80208d:	68 90 00 00 00       	push   $0x90
  802092:	68 0d 43 80 00       	push   $0x80430d
  802097:	e8 99 17 00 00       	call   803835 <_panic>
  80209c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a5:	89 10                	mov    %edx,(%eax)
  8020a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020aa:	8b 00                	mov    (%eax),%eax
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	74 0d                	je     8020bd <initialize_dynamic_allocator+0x1bd>
  8020b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b8:	89 50 04             	mov    %edx,0x4(%eax)
  8020bb:	eb 08                	jmp    8020c5 <initialize_dynamic_allocator+0x1c5>
  8020bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8020c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8020dc:	40                   	inc    %eax
  8020dd:	a3 38 50 80 00       	mov    %eax,0x805038
  8020e2:	eb 07                	jmp    8020eb <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020e4:	90                   	nop
  8020e5:	eb 04                	jmp    8020eb <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020e7:	90                   	nop
  8020e8:	eb 01                	jmp    8020eb <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020ea:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f3:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ff:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	83 e8 04             	sub    $0x4,%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	83 e0 fe             	and    $0xfffffffe,%eax
  80210c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	01 c2                	add    %eax,%edx
  802114:	8b 45 0c             	mov    0xc(%ebp),%eax
  802117:	89 02                	mov    %eax,(%edx)
}
  802119:	90                   	nop
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    

0080211c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	83 e0 01             	and    $0x1,%eax
  802128:	85 c0                	test   %eax,%eax
  80212a:	74 03                	je     80212f <alloc_block_FF+0x13>
  80212c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80212f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802133:	77 07                	ja     80213c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802135:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80213c:	a1 24 50 80 00       	mov    0x805024,%eax
  802141:	85 c0                	test   %eax,%eax
  802143:	75 73                	jne    8021b8 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	83 c0 10             	add    $0x10,%eax
  80214b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80214e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215b:	01 d0                	add    %edx,%eax
  80215d:	48                   	dec    %eax
  80215e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802164:	ba 00 00 00 00       	mov    $0x0,%edx
  802169:	f7 75 ec             	divl   -0x14(%ebp)
  80216c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80216f:	29 d0                	sub    %edx,%eax
  802171:	c1 e8 0c             	shr    $0xc,%eax
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	50                   	push   %eax
  802178:	e8 86 f1 ff ff       	call   801303 <sbrk>
  80217d:	83 c4 10             	add    $0x10,%esp
  802180:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	6a 00                	push   $0x0
  802188:	e8 76 f1 ff ff       	call   801303 <sbrk>
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802193:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802196:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802199:	83 ec 08             	sub    $0x8,%esp
  80219c:	50                   	push   %eax
  80219d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021a0:	e8 5b fd ff ff       	call   801f00 <initialize_dynamic_allocator>
  8021a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	68 4b 43 80 00       	push   $0x80434b
  8021b0:	e8 b4 e3 ff ff       	call   800569 <cprintf>
  8021b5:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bc:	75 0a                	jne    8021c8 <alloc_block_FF+0xac>
	        return NULL;
  8021be:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c3:	e9 0e 04 00 00       	jmp    8025d6 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d7:	e9 f3 02 00 00       	jmp    8024cf <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	ff 75 bc             	pushl  -0x44(%ebp)
  8021e8:	e8 af fb ff ff       	call   801d9c <get_block_size>
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	83 c0 08             	add    $0x8,%eax
  8021f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021fc:	0f 87 c5 02 00 00    	ja     8024c7 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	83 c0 18             	add    $0x18,%eax
  802208:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80220b:	0f 87 19 02 00 00    	ja     80242a <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802211:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802214:	2b 45 08             	sub    0x8(%ebp),%eax
  802217:	83 e8 08             	sub    $0x8,%eax
  80221a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	8d 50 08             	lea    0x8(%eax),%edx
  802223:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	83 c0 08             	add    $0x8,%eax
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	6a 01                	push   $0x1
  802236:	50                   	push   %eax
  802237:	ff 75 bc             	pushl  -0x44(%ebp)
  80223a:	e8 ae fe ff ff       	call   8020ed <set_block_data>
  80223f:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	75 68                	jne    8022b4 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80224c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802250:	75 17                	jne    802269 <alloc_block_FF+0x14d>
  802252:	83 ec 04             	sub    $0x4,%esp
  802255:	68 28 43 80 00       	push   $0x804328
  80225a:	68 d7 00 00 00       	push   $0xd7
  80225f:	68 0d 43 80 00       	push   $0x80430d
  802264:	e8 cc 15 00 00       	call   803835 <_panic>
  802269:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80226f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802272:	89 10                	mov    %edx,(%eax)
  802274:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802277:	8b 00                	mov    (%eax),%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	74 0d                	je     80228a <alloc_block_FF+0x16e>
  80227d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802282:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802285:	89 50 04             	mov    %edx,0x4(%eax)
  802288:	eb 08                	jmp    802292 <alloc_block_FF+0x176>
  80228a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228d:	a3 30 50 80 00       	mov    %eax,0x805030
  802292:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802295:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80229a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80229d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a9:	40                   	inc    %eax
  8022aa:	a3 38 50 80 00       	mov    %eax,0x805038
  8022af:	e9 dc 00 00 00       	jmp    802390 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	75 65                	jne    802322 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022bd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022c1:	75 17                	jne    8022da <alloc_block_FF+0x1be>
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	68 5c 43 80 00       	push   $0x80435c
  8022cb:	68 db 00 00 00       	push   $0xdb
  8022d0:	68 0d 43 80 00       	push   $0x80430d
  8022d5:	e8 5b 15 00 00       	call   803835 <_panic>
  8022da:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e3:	89 50 04             	mov    %edx,0x4(%eax)
  8022e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	74 0c                	je     8022fc <alloc_block_FF+0x1e0>
  8022f0:	a1 30 50 80 00       	mov    0x805030,%eax
  8022f5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f8:	89 10                	mov    %edx,(%eax)
  8022fa:	eb 08                	jmp    802304 <alloc_block_FF+0x1e8>
  8022fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802304:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802307:	a3 30 50 80 00       	mov    %eax,0x805030
  80230c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802315:	a1 38 50 80 00       	mov    0x805038,%eax
  80231a:	40                   	inc    %eax
  80231b:	a3 38 50 80 00       	mov    %eax,0x805038
  802320:	eb 6e                	jmp    802390 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	74 06                	je     80232e <alloc_block_FF+0x212>
  802328:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80232c:	75 17                	jne    802345 <alloc_block_FF+0x229>
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 80 43 80 00       	push   $0x804380
  802336:	68 df 00 00 00       	push   $0xdf
  80233b:	68 0d 43 80 00       	push   $0x80430d
  802340:	e8 f0 14 00 00       	call   803835 <_panic>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 10                	mov    (%eax),%edx
  80234a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 0b                	je     802363 <alloc_block_FF+0x247>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802371:	89 50 04             	mov    %edx,0x4(%eax)
  802374:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	85 c0                	test   %eax,%eax
  80237b:	75 08                	jne    802385 <alloc_block_FF+0x269>
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	a3 30 50 80 00       	mov    %eax,0x805030
  802385:	a1 38 50 80 00       	mov    0x805038,%eax
  80238a:	40                   	inc    %eax
  80238b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802394:	75 17                	jne    8023ad <alloc_block_FF+0x291>
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 ef 42 80 00       	push   $0x8042ef
  80239e:	68 e1 00 00 00       	push   $0xe1
  8023a3:	68 0d 43 80 00       	push   $0x80430d
  8023a8:	e8 88 14 00 00       	call   803835 <_panic>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	74 10                	je     8023c6 <alloc_block_FF+0x2aa>
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023be:	8b 52 04             	mov    0x4(%edx),%edx
  8023c1:	89 50 04             	mov    %edx,0x4(%eax)
  8023c4:	eb 0b                	jmp    8023d1 <alloc_block_FF+0x2b5>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 40 04             	mov    0x4(%eax),%eax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	74 0f                	je     8023ea <alloc_block_FF+0x2ce>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 40 04             	mov    0x4(%eax),%eax
  8023e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e4:	8b 12                	mov    (%edx),%edx
  8023e6:	89 10                	mov    %edx,(%eax)
  8023e8:	eb 0a                	jmp    8023f4 <alloc_block_FF+0x2d8>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802407:	a1 38 50 80 00       	mov    0x805038,%eax
  80240c:	48                   	dec    %eax
  80240d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	6a 00                	push   $0x0
  802417:	ff 75 b4             	pushl  -0x4c(%ebp)
  80241a:	ff 75 b0             	pushl  -0x50(%ebp)
  80241d:	e8 cb fc ff ff       	call   8020ed <set_block_data>
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	e9 95 00 00 00       	jmp    8024bf <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	6a 01                	push   $0x1
  80242f:	ff 75 b8             	pushl  -0x48(%ebp)
  802432:	ff 75 bc             	pushl  -0x44(%ebp)
  802435:	e8 b3 fc ff ff       	call   8020ed <set_block_data>
  80243a:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80243d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802441:	75 17                	jne    80245a <alloc_block_FF+0x33e>
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	68 ef 42 80 00       	push   $0x8042ef
  80244b:	68 e8 00 00 00       	push   $0xe8
  802450:	68 0d 43 80 00       	push   $0x80430d
  802455:	e8 db 13 00 00       	call   803835 <_panic>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	74 10                	je     802473 <alloc_block_FF+0x357>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246b:	8b 52 04             	mov    0x4(%edx),%edx
  80246e:	89 50 04             	mov    %edx,0x4(%eax)
  802471:	eb 0b                	jmp    80247e <alloc_block_FF+0x362>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 04             	mov    0x4(%eax),%eax
  802479:	a3 30 50 80 00       	mov    %eax,0x805030
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 40 04             	mov    0x4(%eax),%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	74 0f                	je     802497 <alloc_block_FF+0x37b>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 04             	mov    0x4(%eax),%eax
  80248e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802491:	8b 12                	mov    (%edx),%edx
  802493:	89 10                	mov    %edx,(%eax)
  802495:	eb 0a                	jmp    8024a1 <alloc_block_FF+0x385>
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b9:	48                   	dec    %eax
  8024ba:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024c2:	e9 0f 01 00 00       	jmp    8025d6 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	74 07                	je     8024dc <alloc_block_FF+0x3c0>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	eb 05                	jmp    8024e1 <alloc_block_FF+0x3c5>
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8024e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	0f 85 e9 fc ff ff    	jne    8021dc <alloc_block_FF+0xc0>
  8024f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f7:	0f 85 df fc ff ff    	jne    8021dc <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	83 c0 08             	add    $0x8,%eax
  802503:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802506:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80250d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802510:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802513:	01 d0                	add    %edx,%eax
  802515:	48                   	dec    %eax
  802516:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802519:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80251c:	ba 00 00 00 00       	mov    $0x0,%edx
  802521:	f7 75 d8             	divl   -0x28(%ebp)
  802524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802527:	29 d0                	sub    %edx,%eax
  802529:	c1 e8 0c             	shr    $0xc,%eax
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	50                   	push   %eax
  802530:	e8 ce ed ff ff       	call   801303 <sbrk>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80253b:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80253f:	75 0a                	jne    80254b <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802541:	b8 00 00 00 00       	mov    $0x0,%eax
  802546:	e9 8b 00 00 00       	jmp    8025d6 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80254b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802552:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802558:	01 d0                	add    %edx,%eax
  80255a:	48                   	dec    %eax
  80255b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80255e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802561:	ba 00 00 00 00       	mov    $0x0,%edx
  802566:	f7 75 cc             	divl   -0x34(%ebp)
  802569:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80256c:	29 d0                	sub    %edx,%eax
  80256e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802571:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802574:	01 d0                	add    %edx,%eax
  802576:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80257b:	a1 40 50 80 00       	mov    0x805040,%eax
  802580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802586:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80258d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802590:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802593:	01 d0                	add    %edx,%eax
  802595:	48                   	dec    %eax
  802596:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802599:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80259c:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a1:	f7 75 c4             	divl   -0x3c(%ebp)
  8025a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025a7:	29 d0                	sub    %edx,%eax
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	6a 01                	push   $0x1
  8025ae:	50                   	push   %eax
  8025af:	ff 75 d0             	pushl  -0x30(%ebp)
  8025b2:	e8 36 fb ff ff       	call   8020ed <set_block_data>
  8025b7:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025ba:	83 ec 0c             	sub    $0xc,%esp
  8025bd:	ff 75 d0             	pushl  -0x30(%ebp)
  8025c0:	e8 1b 0a 00 00       	call   802fe0 <free_block>
  8025c5:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	ff 75 08             	pushl  0x8(%ebp)
  8025ce:	e8 49 fb ff ff       	call   80211c <alloc_block_FF>
  8025d3:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	83 e0 01             	and    $0x1,%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 03                	je     8025eb <alloc_block_BF+0x13>
  8025e8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025eb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025ef:	77 07                	ja     8025f8 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025f1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	75 73                	jne    802674 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	83 c0 10             	add    $0x10,%eax
  802607:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80260a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802611:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802617:	01 d0                	add    %edx,%eax
  802619:	48                   	dec    %eax
  80261a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80261d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802620:	ba 00 00 00 00       	mov    $0x0,%edx
  802625:	f7 75 e0             	divl   -0x20(%ebp)
  802628:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80262b:	29 d0                	sub    %edx,%eax
  80262d:	c1 e8 0c             	shr    $0xc,%eax
  802630:	83 ec 0c             	sub    $0xc,%esp
  802633:	50                   	push   %eax
  802634:	e8 ca ec ff ff       	call   801303 <sbrk>
  802639:	83 c4 10             	add    $0x10,%esp
  80263c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80263f:	83 ec 0c             	sub    $0xc,%esp
  802642:	6a 00                	push   $0x0
  802644:	e8 ba ec ff ff       	call   801303 <sbrk>
  802649:	83 c4 10             	add    $0x10,%esp
  80264c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80264f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802652:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802655:	83 ec 08             	sub    $0x8,%esp
  802658:	50                   	push   %eax
  802659:	ff 75 d8             	pushl  -0x28(%ebp)
  80265c:	e8 9f f8 ff ff       	call   801f00 <initialize_dynamic_allocator>
  802661:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802664:	83 ec 0c             	sub    $0xc,%esp
  802667:	68 4b 43 80 00       	push   $0x80434b
  80266c:	e8 f8 de ff ff       	call   800569 <cprintf>
  802671:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80267b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802682:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802689:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802690:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802695:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802698:	e9 1d 01 00 00       	jmp    8027ba <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	ff 75 a8             	pushl  -0x58(%ebp)
  8026a9:	e8 ee f6 ff ff       	call   801d9c <get_block_size>
  8026ae:	83 c4 10             	add    $0x10,%esp
  8026b1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	83 c0 08             	add    $0x8,%eax
  8026ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026bd:	0f 87 ef 00 00 00    	ja     8027b2 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	83 c0 18             	add    $0x18,%eax
  8026c9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026cc:	77 1d                	ja     8026eb <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026d4:	0f 86 d8 00 00 00    	jbe    8027b2 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026e0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026e6:	e9 c7 00 00 00       	jmp    8027b2 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	83 c0 08             	add    $0x8,%eax
  8026f1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026f4:	0f 85 9d 00 00 00    	jne    802797 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	6a 01                	push   $0x1
  8026ff:	ff 75 a4             	pushl  -0x5c(%ebp)
  802702:	ff 75 a8             	pushl  -0x58(%ebp)
  802705:	e8 e3 f9 ff ff       	call   8020ed <set_block_data>
  80270a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80270d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802711:	75 17                	jne    80272a <alloc_block_BF+0x152>
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	68 ef 42 80 00       	push   $0x8042ef
  80271b:	68 2c 01 00 00       	push   $0x12c
  802720:	68 0d 43 80 00       	push   $0x80430d
  802725:	e8 0b 11 00 00       	call   803835 <_panic>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 10                	je     802743 <alloc_block_BF+0x16b>
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273b:	8b 52 04             	mov    0x4(%edx),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	eb 0b                	jmp    80274e <alloc_block_BF+0x176>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	a3 30 50 80 00       	mov    %eax,0x805030
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 0f                	je     802767 <alloc_block_BF+0x18f>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802761:	8b 12                	mov    (%edx),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	eb 0a                	jmp    802771 <alloc_block_BF+0x199>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802784:	a1 38 50 80 00       	mov    0x805038,%eax
  802789:	48                   	dec    %eax
  80278a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80278f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802792:	e9 24 04 00 00       	jmp    802bbb <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80279d:	76 13                	jbe    8027b2 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80279f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027af:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8027b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027be:	74 07                	je     8027c7 <alloc_block_BF+0x1ef>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	eb 05                	jmp    8027cc <alloc_block_BF+0x1f4>
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	a3 34 50 80 00       	mov    %eax,0x805034
  8027d1:	a1 34 50 80 00       	mov    0x805034,%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	0f 85 bf fe ff ff    	jne    80269d <alloc_block_BF+0xc5>
  8027de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e2:	0f 85 b5 fe ff ff    	jne    80269d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ec:	0f 84 26 02 00 00    	je     802a18 <alloc_block_BF+0x440>
  8027f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027f6:	0f 85 1c 02 00 00    	jne    802a18 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	2b 45 08             	sub    0x8(%ebp),%eax
  802802:	83 e8 08             	sub    $0x8,%eax
  802805:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	8d 50 08             	lea    0x8(%eax),%edx
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	01 d0                	add    %edx,%eax
  802813:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	83 c0 08             	add    $0x8,%eax
  80281c:	83 ec 04             	sub    $0x4,%esp
  80281f:	6a 01                	push   $0x1
  802821:	50                   	push   %eax
  802822:	ff 75 f0             	pushl  -0x10(%ebp)
  802825:	e8 c3 f8 ff ff       	call   8020ed <set_block_data>
  80282a:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80282d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	75 68                	jne    80289f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802837:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80283b:	75 17                	jne    802854 <alloc_block_BF+0x27c>
  80283d:	83 ec 04             	sub    $0x4,%esp
  802840:	68 28 43 80 00       	push   $0x804328
  802845:	68 45 01 00 00       	push   $0x145
  80284a:	68 0d 43 80 00       	push   $0x80430d
  80284f:	e8 e1 0f 00 00       	call   803835 <_panic>
  802854:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80285a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285d:	89 10                	mov    %edx,(%eax)
  80285f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802862:	8b 00                	mov    (%eax),%eax
  802864:	85 c0                	test   %eax,%eax
  802866:	74 0d                	je     802875 <alloc_block_BF+0x29d>
  802868:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80286d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802870:	89 50 04             	mov    %edx,0x4(%eax)
  802873:	eb 08                	jmp    80287d <alloc_block_BF+0x2a5>
  802875:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802878:	a3 30 50 80 00       	mov    %eax,0x805030
  80287d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802880:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802885:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802888:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288f:	a1 38 50 80 00       	mov    0x805038,%eax
  802894:	40                   	inc    %eax
  802895:	a3 38 50 80 00       	mov    %eax,0x805038
  80289a:	e9 dc 00 00 00       	jmp    80297b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	75 65                	jne    80290d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ac:	75 17                	jne    8028c5 <alloc_block_BF+0x2ed>
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	68 5c 43 80 00       	push   $0x80435c
  8028b6:	68 4a 01 00 00       	push   $0x14a
  8028bb:	68 0d 43 80 00       	push   $0x80430d
  8028c0:	e8 70 0f 00 00       	call   803835 <_panic>
  8028c5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ce:	89 50 04             	mov    %edx,0x4(%eax)
  8028d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 0c                	je     8028e7 <alloc_block_BF+0x30f>
  8028db:	a1 30 50 80 00       	mov    0x805030,%eax
  8028e0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 08                	jmp    8028ef <alloc_block_BF+0x317>
  8028e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802900:	a1 38 50 80 00       	mov    0x805038,%eax
  802905:	40                   	inc    %eax
  802906:	a3 38 50 80 00       	mov    %eax,0x805038
  80290b:	eb 6e                	jmp    80297b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80290d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802911:	74 06                	je     802919 <alloc_block_BF+0x341>
  802913:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802917:	75 17                	jne    802930 <alloc_block_BF+0x358>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 80 43 80 00       	push   $0x804380
  802921:	68 4f 01 00 00       	push   $0x14f
  802926:	68 0d 43 80 00       	push   $0x80430d
  80292b:	e8 05 0f 00 00       	call   803835 <_panic>
  802930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802933:	8b 10                	mov    (%eax),%edx
  802935:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802938:	89 10                	mov    %edx,(%eax)
  80293a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0b                	je     80294e <alloc_block_BF+0x376>
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802954:	89 10                	mov    %edx,(%eax)
  802956:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802959:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295c:	89 50 04             	mov    %edx,0x4(%eax)
  80295f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	75 08                	jne    802970 <alloc_block_BF+0x398>
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	a3 30 50 80 00       	mov    %eax,0x805030
  802970:	a1 38 50 80 00       	mov    0x805038,%eax
  802975:	40                   	inc    %eax
  802976:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80297b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297f:	75 17                	jne    802998 <alloc_block_BF+0x3c0>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 ef 42 80 00       	push   $0x8042ef
  802989:	68 51 01 00 00       	push   $0x151
  80298e:	68 0d 43 80 00       	push   $0x80430d
  802993:	e8 9d 0e 00 00       	call   803835 <_panic>
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	74 10                	je     8029b1 <alloc_block_BF+0x3d9>
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a9:	8b 52 04             	mov    0x4(%edx),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%eax)
  8029af:	eb 0b                	jmp    8029bc <alloc_block_BF+0x3e4>
  8029b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8029bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 0f                	je     8029d5 <alloc_block_BF+0x3fd>
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029cf:	8b 12                	mov    (%edx),%edx
  8029d1:	89 10                	mov    %edx,(%eax)
  8029d3:	eb 0a                	jmp    8029df <alloc_block_BF+0x407>
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f7:	48                   	dec    %eax
  8029f8:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8029fd:	83 ec 04             	sub    $0x4,%esp
  802a00:	6a 00                	push   $0x0
  802a02:	ff 75 d0             	pushl  -0x30(%ebp)
  802a05:	ff 75 cc             	pushl  -0x34(%ebp)
  802a08:	e8 e0 f6 ff ff       	call   8020ed <set_block_data>
  802a0d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	e9 a3 01 00 00       	jmp    802bbb <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a18:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a1c:	0f 85 9d 00 00 00    	jne    802abf <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a22:	83 ec 04             	sub    $0x4,%esp
  802a25:	6a 01                	push   $0x1
  802a27:	ff 75 ec             	pushl  -0x14(%ebp)
  802a2a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a2d:	e8 bb f6 ff ff       	call   8020ed <set_block_data>
  802a32:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_BF+0x47a>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 ef 42 80 00       	push   $0x8042ef
  802a43:	68 58 01 00 00       	push   $0x158
  802a48:	68 0d 43 80 00       	push   $0x80430d
  802a4d:	e8 e3 0d 00 00       	call   803835 <_panic>
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_BF+0x493>
  802a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_BF+0x49e>
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 30 50 80 00       	mov    %eax,0x805030
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_BF+0x4b7>
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_BF+0x4c1>
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aba:	e9 fc 00 00 00       	jmp    802bbb <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	83 c0 08             	add    $0x8,%eax
  802ac5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ac8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802acf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ad2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ad5:	01 d0                	add    %edx,%eax
  802ad7:	48                   	dec    %eax
  802ad8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802adb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ade:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae3:	f7 75 c4             	divl   -0x3c(%ebp)
  802ae6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ae9:	29 d0                	sub    %edx,%eax
  802aeb:	c1 e8 0c             	shr    $0xc,%eax
  802aee:	83 ec 0c             	sub    $0xc,%esp
  802af1:	50                   	push   %eax
  802af2:	e8 0c e8 ff ff       	call   801303 <sbrk>
  802af7:	83 c4 10             	add    $0x10,%esp
  802afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802afd:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b01:	75 0a                	jne    802b0d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
  802b08:	e9 ae 00 00 00       	jmp    802bbb <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b0d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b14:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b17:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b1a:	01 d0                	add    %edx,%eax
  802b1c:	48                   	dec    %eax
  802b1d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b20:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b23:	ba 00 00 00 00       	mov    $0x0,%edx
  802b28:	f7 75 b8             	divl   -0x48(%ebp)
  802b2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b2e:	29 d0                	sub    %edx,%eax
  802b30:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b33:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b36:	01 d0                	add    %edx,%eax
  802b38:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b3d:	a1 40 50 80 00       	mov    0x805040,%eax
  802b42:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b48:	83 ec 0c             	sub    $0xc,%esp
  802b4b:	68 b4 43 80 00       	push   $0x8043b4
  802b50:	e8 14 da ff ff       	call   800569 <cprintf>
  802b55:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b58:	83 ec 08             	sub    $0x8,%esp
  802b5b:	ff 75 bc             	pushl  -0x44(%ebp)
  802b5e:	68 b9 43 80 00       	push   $0x8043b9
  802b63:	e8 01 da ff ff       	call   800569 <cprintf>
  802b68:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b6b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b78:	01 d0                	add    %edx,%eax
  802b7a:	48                   	dec    %eax
  802b7b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b7e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b81:	ba 00 00 00 00       	mov    $0x0,%edx
  802b86:	f7 75 b0             	divl   -0x50(%ebp)
  802b89:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b8c:	29 d0                	sub    %edx,%eax
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	6a 01                	push   $0x1
  802b93:	50                   	push   %eax
  802b94:	ff 75 bc             	pushl  -0x44(%ebp)
  802b97:	e8 51 f5 ff ff       	call   8020ed <set_block_data>
  802b9c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b9f:	83 ec 0c             	sub    $0xc,%esp
  802ba2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ba5:	e8 36 04 00 00       	call   802fe0 <free_block>
  802baa:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bad:	83 ec 0c             	sub    $0xc,%esp
  802bb0:	ff 75 08             	pushl  0x8(%ebp)
  802bb3:	e8 20 fa ff ff       	call   8025d8 <alloc_block_BF>
  802bb8:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802bbb:	c9                   	leave  
  802bbc:	c3                   	ret    

00802bbd <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802bbd:	55                   	push   %ebp
  802bbe:	89 e5                	mov    %esp,%ebp
  802bc0:	53                   	push   %ebx
  802bc1:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802bc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bcb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802bd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd6:	74 1e                	je     802bf6 <merging+0x39>
  802bd8:	ff 75 08             	pushl  0x8(%ebp)
  802bdb:	e8 bc f1 ff ff       	call   801d9c <get_block_size>
  802be0:	83 c4 04             	add    $0x4,%esp
  802be3:	89 c2                	mov    %eax,%edx
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	01 d0                	add    %edx,%eax
  802bea:	3b 45 10             	cmp    0x10(%ebp),%eax
  802bed:	75 07                	jne    802bf6 <merging+0x39>
		prev_is_free = 1;
  802bef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bfa:	74 1e                	je     802c1a <merging+0x5d>
  802bfc:	ff 75 10             	pushl  0x10(%ebp)
  802bff:	e8 98 f1 ff ff       	call   801d9c <get_block_size>
  802c04:	83 c4 04             	add    $0x4,%esp
  802c07:	89 c2                	mov    %eax,%edx
  802c09:	8b 45 10             	mov    0x10(%ebp),%eax
  802c0c:	01 d0                	add    %edx,%eax
  802c0e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c11:	75 07                	jne    802c1a <merging+0x5d>
		next_is_free = 1;
  802c13:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1e:	0f 84 cc 00 00 00    	je     802cf0 <merging+0x133>
  802c24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c28:	0f 84 c2 00 00 00    	je     802cf0 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c2e:	ff 75 08             	pushl  0x8(%ebp)
  802c31:	e8 66 f1 ff ff       	call   801d9c <get_block_size>
  802c36:	83 c4 04             	add    $0x4,%esp
  802c39:	89 c3                	mov    %eax,%ebx
  802c3b:	ff 75 10             	pushl  0x10(%ebp)
  802c3e:	e8 59 f1 ff ff       	call   801d9c <get_block_size>
  802c43:	83 c4 04             	add    $0x4,%esp
  802c46:	01 c3                	add    %eax,%ebx
  802c48:	ff 75 0c             	pushl  0xc(%ebp)
  802c4b:	e8 4c f1 ff ff       	call   801d9c <get_block_size>
  802c50:	83 c4 04             	add    $0x4,%esp
  802c53:	01 d8                	add    %ebx,%eax
  802c55:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c58:	6a 00                	push   $0x0
  802c5a:	ff 75 ec             	pushl  -0x14(%ebp)
  802c5d:	ff 75 08             	pushl  0x8(%ebp)
  802c60:	e8 88 f4 ff ff       	call   8020ed <set_block_data>
  802c65:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c6c:	75 17                	jne    802c85 <merging+0xc8>
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	68 ef 42 80 00       	push   $0x8042ef
  802c76:	68 7d 01 00 00       	push   $0x17d
  802c7b:	68 0d 43 80 00       	push   $0x80430d
  802c80:	e8 b0 0b 00 00       	call   803835 <_panic>
  802c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 10                	je     802c9e <merging+0xe1>
  802c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c96:	8b 52 04             	mov    0x4(%edx),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%eax)
  802c9c:	eb 0b                	jmp    802ca9 <merging+0xec>
  802c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 0f                	je     802cc2 <merging+0x105>
  802cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb6:	8b 40 04             	mov    0x4(%eax),%eax
  802cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cbc:	8b 12                	mov    (%edx),%edx
  802cbe:	89 10                	mov    %edx,(%eax)
  802cc0:	eb 0a                	jmp    802ccc <merging+0x10f>
  802cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ce4:	48                   	dec    %eax
  802ce5:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cea:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ceb:	e9 ea 02 00 00       	jmp    802fda <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf4:	74 3b                	je     802d31 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802cf6:	83 ec 0c             	sub    $0xc,%esp
  802cf9:	ff 75 08             	pushl  0x8(%ebp)
  802cfc:	e8 9b f0 ff ff       	call   801d9c <get_block_size>
  802d01:	83 c4 10             	add    $0x10,%esp
  802d04:	89 c3                	mov    %eax,%ebx
  802d06:	83 ec 0c             	sub    $0xc,%esp
  802d09:	ff 75 10             	pushl  0x10(%ebp)
  802d0c:	e8 8b f0 ff ff       	call   801d9c <get_block_size>
  802d11:	83 c4 10             	add    $0x10,%esp
  802d14:	01 d8                	add    %ebx,%eax
  802d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	6a 00                	push   $0x0
  802d1e:	ff 75 e8             	pushl  -0x18(%ebp)
  802d21:	ff 75 08             	pushl  0x8(%ebp)
  802d24:	e8 c4 f3 ff ff       	call   8020ed <set_block_data>
  802d29:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d2c:	e9 a9 02 00 00       	jmp    802fda <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d35:	0f 84 2d 01 00 00    	je     802e68 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d3b:	83 ec 0c             	sub    $0xc,%esp
  802d3e:	ff 75 10             	pushl  0x10(%ebp)
  802d41:	e8 56 f0 ff ff       	call   801d9c <get_block_size>
  802d46:	83 c4 10             	add    $0x10,%esp
  802d49:	89 c3                	mov    %eax,%ebx
  802d4b:	83 ec 0c             	sub    $0xc,%esp
  802d4e:	ff 75 0c             	pushl  0xc(%ebp)
  802d51:	e8 46 f0 ff ff       	call   801d9c <get_block_size>
  802d56:	83 c4 10             	add    $0x10,%esp
  802d59:	01 d8                	add    %ebx,%eax
  802d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d5e:	83 ec 04             	sub    $0x4,%esp
  802d61:	6a 00                	push   $0x0
  802d63:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d66:	ff 75 10             	pushl  0x10(%ebp)
  802d69:	e8 7f f3 ff ff       	call   8020ed <set_block_data>
  802d6e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d71:	8b 45 10             	mov    0x10(%ebp),%eax
  802d74:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d7b:	74 06                	je     802d83 <merging+0x1c6>
  802d7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d81:	75 17                	jne    802d9a <merging+0x1dd>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 c8 43 80 00       	push   $0x8043c8
  802d8b:	68 8d 01 00 00       	push   $0x18d
  802d90:	68 0d 43 80 00       	push   $0x80430d
  802d95:	e8 9b 0a 00 00       	call   803835 <_panic>
  802d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9d:	8b 50 04             	mov    0x4(%eax),%edx
  802da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da3:	89 50 04             	mov    %edx,0x4(%eax)
  802da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dac:	89 10                	mov    %edx,(%eax)
  802dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db1:	8b 40 04             	mov    0x4(%eax),%eax
  802db4:	85 c0                	test   %eax,%eax
  802db6:	74 0d                	je     802dc5 <merging+0x208>
  802db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc1:	89 10                	mov    %edx,(%eax)
  802dc3:	eb 08                	jmp    802dcd <merging+0x210>
  802dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dd3:	89 50 04             	mov    %edx,0x4(%eax)
  802dd6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ddb:	40                   	inc    %eax
  802ddc:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802de1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de5:	75 17                	jne    802dfe <merging+0x241>
  802de7:	83 ec 04             	sub    $0x4,%esp
  802dea:	68 ef 42 80 00       	push   $0x8042ef
  802def:	68 8e 01 00 00       	push   $0x18e
  802df4:	68 0d 43 80 00       	push   $0x80430d
  802df9:	e8 37 0a 00 00       	call   803835 <_panic>
  802dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 10                	je     802e17 <merging+0x25a>
  802e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0f:	8b 52 04             	mov    0x4(%edx),%edx
  802e12:	89 50 04             	mov    %edx,0x4(%eax)
  802e15:	eb 0b                	jmp    802e22 <merging+0x265>
  802e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e25:	8b 40 04             	mov    0x4(%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 0f                	je     802e3b <merging+0x27e>
  802e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2f:	8b 40 04             	mov    0x4(%eax),%eax
  802e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e35:	8b 12                	mov    (%edx),%edx
  802e37:	89 10                	mov    %edx,(%eax)
  802e39:	eb 0a                	jmp    802e45 <merging+0x288>
  802e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e58:	a1 38 50 80 00       	mov    0x805038,%eax
  802e5d:	48                   	dec    %eax
  802e5e:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e63:	e9 72 01 00 00       	jmp    802fda <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e68:	8b 45 10             	mov    0x10(%ebp),%eax
  802e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e72:	74 79                	je     802eed <merging+0x330>
  802e74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e78:	74 73                	je     802eed <merging+0x330>
  802e7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7e:	74 06                	je     802e86 <merging+0x2c9>
  802e80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e84:	75 17                	jne    802e9d <merging+0x2e0>
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	68 80 43 80 00       	push   $0x804380
  802e8e:	68 94 01 00 00       	push   $0x194
  802e93:	68 0d 43 80 00       	push   $0x80430d
  802e98:	e8 98 09 00 00       	call   803835 <_panic>
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 10                	mov    (%eax),%edx
  802ea2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	74 0b                	je     802ebb <merging+0x2fe>
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eb8:	89 50 04             	mov    %edx,0x4(%eax)
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec9:	89 50 04             	mov    %edx,0x4(%eax)
  802ecc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	75 08                	jne    802edd <merging+0x320>
  802ed5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed8:	a3 30 50 80 00       	mov    %eax,0x805030
  802edd:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee2:	40                   	inc    %eax
  802ee3:	a3 38 50 80 00       	mov    %eax,0x805038
  802ee8:	e9 ce 00 00 00       	jmp    802fbb <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802eed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef1:	74 65                	je     802f58 <merging+0x39b>
  802ef3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ef7:	75 17                	jne    802f10 <merging+0x353>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 5c 43 80 00       	push   $0x80435c
  802f01:	68 95 01 00 00       	push   $0x195
  802f06:	68 0d 43 80 00       	push   $0x80430d
  802f0b:	e8 25 09 00 00       	call   803835 <_panic>
  802f10:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f19:	89 50 04             	mov    %edx,0x4(%eax)
  802f1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1f:	8b 40 04             	mov    0x4(%eax),%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	74 0c                	je     802f32 <merging+0x375>
  802f26:	a1 30 50 80 00       	mov    0x805030,%eax
  802f2b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f2e:	89 10                	mov    %edx,(%eax)
  802f30:	eb 08                	jmp    802f3a <merging+0x37d>
  802f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f35:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f50:	40                   	inc    %eax
  802f51:	a3 38 50 80 00       	mov    %eax,0x805038
  802f56:	eb 63                	jmp    802fbb <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f58:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f5c:	75 17                	jne    802f75 <merging+0x3b8>
  802f5e:	83 ec 04             	sub    $0x4,%esp
  802f61:	68 28 43 80 00       	push   $0x804328
  802f66:	68 98 01 00 00       	push   $0x198
  802f6b:	68 0d 43 80 00       	push   $0x80430d
  802f70:	e8 c0 08 00 00       	call   803835 <_panic>
  802f75:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	74 0d                	je     802f96 <merging+0x3d9>
  802f89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 08                	jmp    802f9e <merging+0x3e1>
  802f96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f99:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb0:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb5:	40                   	inc    %eax
  802fb6:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fbb:	83 ec 0c             	sub    $0xc,%esp
  802fbe:	ff 75 10             	pushl  0x10(%ebp)
  802fc1:	e8 d6 ed ff ff       	call   801d9c <get_block_size>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	6a 00                	push   $0x0
  802fce:	50                   	push   %eax
  802fcf:	ff 75 10             	pushl  0x10(%ebp)
  802fd2:	e8 16 f1 ff ff       	call   8020ed <set_block_data>
  802fd7:	83 c4 10             	add    $0x10,%esp
	}
}
  802fda:	90                   	nop
  802fdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fde:	c9                   	leave  
  802fdf:	c3                   	ret    

00802fe0 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fe0:	55                   	push   %ebp
  802fe1:	89 e5                	mov    %esp,%ebp
  802fe3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fe6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802feb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fee:	a1 30 50 80 00       	mov    0x805030,%eax
  802ff3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff6:	73 1b                	jae    803013 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ff8:	a1 30 50 80 00       	mov    0x805030,%eax
  802ffd:	83 ec 04             	sub    $0x4,%esp
  803000:	ff 75 08             	pushl  0x8(%ebp)
  803003:	6a 00                	push   $0x0
  803005:	50                   	push   %eax
  803006:	e8 b2 fb ff ff       	call   802bbd <merging>
  80300b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80300e:	e9 8b 00 00 00       	jmp    80309e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803013:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803018:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301b:	76 18                	jbe    803035 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80301d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	ff 75 08             	pushl  0x8(%ebp)
  803028:	50                   	push   %eax
  803029:	6a 00                	push   $0x0
  80302b:	e8 8d fb ff ff       	call   802bbd <merging>
  803030:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803033:	eb 69                	jmp    80309e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803035:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80303a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303d:	eb 39                	jmp    803078 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	3b 45 08             	cmp    0x8(%ebp),%eax
  803045:	73 29                	jae    803070 <free_block+0x90>
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304f:	76 1f                	jbe    803070 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803059:	83 ec 04             	sub    $0x4,%esp
  80305c:	ff 75 08             	pushl  0x8(%ebp)
  80305f:	ff 75 f0             	pushl  -0x10(%ebp)
  803062:	ff 75 f4             	pushl  -0xc(%ebp)
  803065:	e8 53 fb ff ff       	call   802bbd <merging>
  80306a:	83 c4 10             	add    $0x10,%esp
			break;
  80306d:	90                   	nop
		}
	}
}
  80306e:	eb 2e                	jmp    80309e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803070:	a1 34 50 80 00       	mov    0x805034,%eax
  803075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307c:	74 07                	je     803085 <free_block+0xa5>
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	eb 05                	jmp    80308a <free_block+0xaa>
  803085:	b8 00 00 00 00       	mov    $0x0,%eax
  80308a:	a3 34 50 80 00       	mov    %eax,0x805034
  80308f:	a1 34 50 80 00       	mov    0x805034,%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	75 a7                	jne    80303f <free_block+0x5f>
  803098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309c:	75 a1                	jne    80303f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80309e:	90                   	nop
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
  8030a4:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030a7:	ff 75 08             	pushl  0x8(%ebp)
  8030aa:	e8 ed ec ff ff       	call   801d9c <get_block_size>
  8030af:	83 c4 04             	add    $0x4,%esp
  8030b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030bc:	eb 17                	jmp    8030d5 <copy_data+0x34>
  8030be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c4:	01 c2                	add    %eax,%edx
  8030c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	01 c8                	add    %ecx,%eax
  8030ce:	8a 00                	mov    (%eax),%al
  8030d0:	88 02                	mov    %al,(%edx)
  8030d2:	ff 45 fc             	incl   -0x4(%ebp)
  8030d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030db:	72 e1                	jb     8030be <copy_data+0x1d>
}
  8030dd:	90                   	nop
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ea:	75 23                	jne    80310f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030f0:	74 13                	je     803105 <realloc_block_FF+0x25>
  8030f2:	83 ec 0c             	sub    $0xc,%esp
  8030f5:	ff 75 0c             	pushl  0xc(%ebp)
  8030f8:	e8 1f f0 ff ff       	call   80211c <alloc_block_FF>
  8030fd:	83 c4 10             	add    $0x10,%esp
  803100:	e9 f4 06 00 00       	jmp    8037f9 <realloc_block_FF+0x719>
		return NULL;
  803105:	b8 00 00 00 00       	mov    $0x0,%eax
  80310a:	e9 ea 06 00 00       	jmp    8037f9 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80310f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803113:	75 18                	jne    80312d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803115:	83 ec 0c             	sub    $0xc,%esp
  803118:	ff 75 08             	pushl  0x8(%ebp)
  80311b:	e8 c0 fe ff ff       	call   802fe0 <free_block>
  803120:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803123:	b8 00 00 00 00       	mov    $0x0,%eax
  803128:	e9 cc 06 00 00       	jmp    8037f9 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80312d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803131:	77 07                	ja     80313a <realloc_block_FF+0x5a>
  803133:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313d:	83 e0 01             	and    $0x1,%eax
  803140:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803143:	8b 45 0c             	mov    0xc(%ebp),%eax
  803146:	83 c0 08             	add    $0x8,%eax
  803149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80314c:	83 ec 0c             	sub    $0xc,%esp
  80314f:	ff 75 08             	pushl  0x8(%ebp)
  803152:	e8 45 ec ff ff       	call   801d9c <get_block_size>
  803157:	83 c4 10             	add    $0x10,%esp
  80315a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80315d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803160:	83 e8 08             	sub    $0x8,%eax
  803163:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	83 e8 04             	sub    $0x4,%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	83 e0 fe             	and    $0xfffffffe,%eax
  803171:	89 c2                	mov    %eax,%edx
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	01 d0                	add    %edx,%eax
  803178:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80317b:	83 ec 0c             	sub    $0xc,%esp
  80317e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803181:	e8 16 ec ff ff       	call   801d9c <get_block_size>
  803186:	83 c4 10             	add    $0x10,%esp
  803189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80318c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318f:	83 e8 08             	sub    $0x8,%eax
  803192:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803195:	8b 45 0c             	mov    0xc(%ebp),%eax
  803198:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80319b:	75 08                	jne    8031a5 <realloc_block_FF+0xc5>
	{
		 return va;
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	e9 54 06 00 00       	jmp    8037f9 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031ab:	0f 83 e5 03 00 00    	jae    803596 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031ba:	83 ec 0c             	sub    $0xc,%esp
  8031bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031c0:	e8 f0 eb ff ff       	call   801db5 <is_free_block>
  8031c5:	83 c4 10             	add    $0x10,%esp
  8031c8:	84 c0                	test   %al,%al
  8031ca:	0f 84 3b 01 00 00    	je     80330b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031d6:	01 d0                	add    %edx,%eax
  8031d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	6a 01                	push   $0x1
  8031e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8031e3:	ff 75 08             	pushl  0x8(%ebp)
  8031e6:	e8 02 ef ff ff       	call   8020ed <set_block_data>
  8031eb:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	83 e8 04             	sub    $0x4,%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	83 e0 fe             	and    $0xfffffffe,%eax
  8031f9:	89 c2                	mov    %eax,%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	01 d0                	add    %edx,%eax
  803200:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	6a 00                	push   $0x0
  803208:	ff 75 cc             	pushl  -0x34(%ebp)
  80320b:	ff 75 c8             	pushl  -0x38(%ebp)
  80320e:	e8 da ee ff ff       	call   8020ed <set_block_data>
  803213:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803216:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80321a:	74 06                	je     803222 <realloc_block_FF+0x142>
  80321c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803220:	75 17                	jne    803239 <realloc_block_FF+0x159>
  803222:	83 ec 04             	sub    $0x4,%esp
  803225:	68 80 43 80 00       	push   $0x804380
  80322a:	68 f6 01 00 00       	push   $0x1f6
  80322f:	68 0d 43 80 00       	push   $0x80430d
  803234:	e8 fc 05 00 00       	call   803835 <_panic>
  803239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323c:	8b 10                	mov    (%eax),%edx
  80323e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803241:	89 10                	mov    %edx,(%eax)
  803243:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0b                	je     803257 <realloc_block_FF+0x177>
  80324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80325d:	89 10                	mov    %edx,(%eax)
  80325f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803265:	89 50 04             	mov    %edx,0x4(%eax)
  803268:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	75 08                	jne    803279 <realloc_block_FF+0x199>
  803271:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803274:	a3 30 50 80 00       	mov    %eax,0x805030
  803279:	a1 38 50 80 00       	mov    0x805038,%eax
  80327e:	40                   	inc    %eax
  80327f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803284:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803288:	75 17                	jne    8032a1 <realloc_block_FF+0x1c1>
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	68 ef 42 80 00       	push   $0x8042ef
  803292:	68 f7 01 00 00       	push   $0x1f7
  803297:	68 0d 43 80 00       	push   $0x80430d
  80329c:	e8 94 05 00 00       	call   803835 <_panic>
  8032a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a4:	8b 00                	mov    (%eax),%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 10                	je     8032ba <realloc_block_FF+0x1da>
  8032aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032b2:	8b 52 04             	mov    0x4(%edx),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%eax)
  8032b8:	eb 0b                	jmp    8032c5 <realloc_block_FF+0x1e5>
  8032ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c8:	8b 40 04             	mov    0x4(%eax),%eax
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	74 0f                	je     8032de <realloc_block_FF+0x1fe>
  8032cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d2:	8b 40 04             	mov    0x4(%eax),%eax
  8032d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032d8:	8b 12                	mov    (%edx),%edx
  8032da:	89 10                	mov    %edx,(%eax)
  8032dc:	eb 0a                	jmp    8032e8 <realloc_block_FF+0x208>
  8032de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803300:	48                   	dec    %eax
  803301:	a3 38 50 80 00       	mov    %eax,0x805038
  803306:	e9 83 02 00 00       	jmp    80358e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80330b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80330f:	0f 86 69 02 00 00    	jbe    80357e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	6a 01                	push   $0x1
  80331a:	ff 75 f0             	pushl  -0x10(%ebp)
  80331d:	ff 75 08             	pushl  0x8(%ebp)
  803320:	e8 c8 ed ff ff       	call   8020ed <set_block_data>
  803325:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	83 e8 04             	sub    $0x4,%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	83 e0 fe             	and    $0xfffffffe,%eax
  803333:	89 c2                	mov    %eax,%edx
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	01 d0                	add    %edx,%eax
  80333a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80333d:	a1 38 50 80 00       	mov    0x805038,%eax
  803342:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803345:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803349:	75 68                	jne    8033b3 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80334b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80334f:	75 17                	jne    803368 <realloc_block_FF+0x288>
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	68 28 43 80 00       	push   $0x804328
  803359:	68 06 02 00 00       	push   $0x206
  80335e:	68 0d 43 80 00       	push   $0x80430d
  803363:	e8 cd 04 00 00       	call   803835 <_panic>
  803368:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80336e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803371:	89 10                	mov    %edx,(%eax)
  803373:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	74 0d                	je     803389 <realloc_block_FF+0x2a9>
  80337c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803381:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	eb 08                	jmp    803391 <realloc_block_FF+0x2b1>
  803389:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338c:	a3 30 50 80 00       	mov    %eax,0x805030
  803391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803394:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803399:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a8:	40                   	inc    %eax
  8033a9:	a3 38 50 80 00       	mov    %eax,0x805038
  8033ae:	e9 b0 01 00 00       	jmp    803563 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033b3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033b8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033bb:	76 68                	jbe    803425 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c1:	75 17                	jne    8033da <realloc_block_FF+0x2fa>
  8033c3:	83 ec 04             	sub    $0x4,%esp
  8033c6:	68 28 43 80 00       	push   $0x804328
  8033cb:	68 0b 02 00 00       	push   $0x20b
  8033d0:	68 0d 43 80 00       	push   $0x80430d
  8033d5:	e8 5b 04 00 00       	call   803835 <_panic>
  8033da:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e3:	89 10                	mov    %edx,(%eax)
  8033e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 0d                	je     8033fb <realloc_block_FF+0x31b>
  8033ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033f6:	89 50 04             	mov    %edx,0x4(%eax)
  8033f9:	eb 08                	jmp    803403 <realloc_block_FF+0x323>
  8033fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80340b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803415:	a1 38 50 80 00       	mov    0x805038,%eax
  80341a:	40                   	inc    %eax
  80341b:	a3 38 50 80 00       	mov    %eax,0x805038
  803420:	e9 3e 01 00 00       	jmp    803563 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803425:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80342a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80342d:	73 68                	jae    803497 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80342f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803433:	75 17                	jne    80344c <realloc_block_FF+0x36c>
  803435:	83 ec 04             	sub    $0x4,%esp
  803438:	68 5c 43 80 00       	push   $0x80435c
  80343d:	68 10 02 00 00       	push   $0x210
  803442:	68 0d 43 80 00       	push   $0x80430d
  803447:	e8 e9 03 00 00       	call   803835 <_panic>
  80344c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803455:	89 50 04             	mov    %edx,0x4(%eax)
  803458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0c                	je     80346e <realloc_block_FF+0x38e>
  803462:	a1 30 50 80 00       	mov    0x805030,%eax
  803467:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80346a:	89 10                	mov    %edx,(%eax)
  80346c:	eb 08                	jmp    803476 <realloc_block_FF+0x396>
  80346e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803471:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803476:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803479:	a3 30 50 80 00       	mov    %eax,0x805030
  80347e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803487:	a1 38 50 80 00       	mov    0x805038,%eax
  80348c:	40                   	inc    %eax
  80348d:	a3 38 50 80 00       	mov    %eax,0x805038
  803492:	e9 cc 00 00 00       	jmp    803563 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80349e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a6:	e9 8a 00 00 00       	jmp    803535 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034b1:	73 7a                	jae    80352d <realloc_block_FF+0x44d>
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034bb:	73 70                	jae    80352d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c1:	74 06                	je     8034c9 <realloc_block_FF+0x3e9>
  8034c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c7:	75 17                	jne    8034e0 <realloc_block_FF+0x400>
  8034c9:	83 ec 04             	sub    $0x4,%esp
  8034cc:	68 80 43 80 00       	push   $0x804380
  8034d1:	68 1a 02 00 00       	push   $0x21a
  8034d6:	68 0d 43 80 00       	push   $0x80430d
  8034db:	e8 55 03 00 00       	call   803835 <_panic>
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 10                	mov    (%eax),%edx
  8034e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e8:	89 10                	mov    %edx,(%eax)
  8034ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ed:	8b 00                	mov    (%eax),%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	74 0b                	je     8034fe <realloc_block_FF+0x41e>
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034fb:	89 50 04             	mov    %edx,0x4(%eax)
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803504:	89 10                	mov    %edx,(%eax)
  803506:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350c:	89 50 04             	mov    %edx,0x4(%eax)
  80350f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	75 08                	jne    803520 <realloc_block_FF+0x440>
  803518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351b:	a3 30 50 80 00       	mov    %eax,0x805030
  803520:	a1 38 50 80 00       	mov    0x805038,%eax
  803525:	40                   	inc    %eax
  803526:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80352b:	eb 36                	jmp    803563 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80352d:	a1 34 50 80 00       	mov    0x805034,%eax
  803532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803539:	74 07                	je     803542 <realloc_block_FF+0x462>
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	eb 05                	jmp    803547 <realloc_block_FF+0x467>
  803542:	b8 00 00 00 00       	mov    $0x0,%eax
  803547:	a3 34 50 80 00       	mov    %eax,0x805034
  80354c:	a1 34 50 80 00       	mov    0x805034,%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	0f 85 52 ff ff ff    	jne    8034ab <realloc_block_FF+0x3cb>
  803559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355d:	0f 85 48 ff ff ff    	jne    8034ab <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803563:	83 ec 04             	sub    $0x4,%esp
  803566:	6a 00                	push   $0x0
  803568:	ff 75 d8             	pushl  -0x28(%ebp)
  80356b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80356e:	e8 7a eb ff ff       	call   8020ed <set_block_data>
  803573:	83 c4 10             	add    $0x10,%esp
				return va;
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	e9 7b 02 00 00       	jmp    8037f9 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80357e:	83 ec 0c             	sub    $0xc,%esp
  803581:	68 fd 43 80 00       	push   $0x8043fd
  803586:	e8 de cf ff ff       	call   800569 <cprintf>
  80358b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	e9 63 02 00 00       	jmp    8037f9 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803596:	8b 45 0c             	mov    0xc(%ebp),%eax
  803599:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80359c:	0f 86 4d 02 00 00    	jbe    8037ef <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035a2:	83 ec 0c             	sub    $0xc,%esp
  8035a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035a8:	e8 08 e8 ff ff       	call   801db5 <is_free_block>
  8035ad:	83 c4 10             	add    $0x10,%esp
  8035b0:	84 c0                	test   %al,%al
  8035b2:	0f 84 37 02 00 00    	je     8037ef <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035c1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035c4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035c7:	76 38                	jbe    803601 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035c9:	83 ec 0c             	sub    $0xc,%esp
  8035cc:	ff 75 08             	pushl  0x8(%ebp)
  8035cf:	e8 0c fa ff ff       	call   802fe0 <free_block>
  8035d4:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035d7:	83 ec 0c             	sub    $0xc,%esp
  8035da:	ff 75 0c             	pushl  0xc(%ebp)
  8035dd:	e8 3a eb ff ff       	call   80211c <alloc_block_FF>
  8035e2:	83 c4 10             	add    $0x10,%esp
  8035e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035e8:	83 ec 08             	sub    $0x8,%esp
  8035eb:	ff 75 c0             	pushl  -0x40(%ebp)
  8035ee:	ff 75 08             	pushl  0x8(%ebp)
  8035f1:	e8 ab fa ff ff       	call   8030a1 <copy_data>
  8035f6:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035f9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035fc:	e9 f8 01 00 00       	jmp    8037f9 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803604:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803607:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80360a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80360e:	0f 87 a0 00 00 00    	ja     8036b4 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803614:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803618:	75 17                	jne    803631 <realloc_block_FF+0x551>
  80361a:	83 ec 04             	sub    $0x4,%esp
  80361d:	68 ef 42 80 00       	push   $0x8042ef
  803622:	68 38 02 00 00       	push   $0x238
  803627:	68 0d 43 80 00       	push   $0x80430d
  80362c:	e8 04 02 00 00       	call   803835 <_panic>
  803631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 10                	je     80364a <realloc_block_FF+0x56a>
  80363a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803642:	8b 52 04             	mov    0x4(%edx),%edx
  803645:	89 50 04             	mov    %edx,0x4(%eax)
  803648:	eb 0b                	jmp    803655 <realloc_block_FF+0x575>
  80364a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364d:	8b 40 04             	mov    0x4(%eax),%eax
  803650:	a3 30 50 80 00       	mov    %eax,0x805030
  803655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	85 c0                	test   %eax,%eax
  80365d:	74 0f                	je     80366e <realloc_block_FF+0x58e>
  80365f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803662:	8b 40 04             	mov    0x4(%eax),%eax
  803665:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803668:	8b 12                	mov    (%edx),%edx
  80366a:	89 10                	mov    %edx,(%eax)
  80366c:	eb 0a                	jmp    803678 <realloc_block_FF+0x598>
  80366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803684:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368b:	a1 38 50 80 00       	mov    0x805038,%eax
  803690:	48                   	dec    %eax
  803691:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803696:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803699:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80369c:	01 d0                	add    %edx,%eax
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	6a 01                	push   $0x1
  8036a3:	50                   	push   %eax
  8036a4:	ff 75 08             	pushl  0x8(%ebp)
  8036a7:	e8 41 ea ff ff       	call   8020ed <set_block_data>
  8036ac:	83 c4 10             	add    $0x10,%esp
  8036af:	e9 36 01 00 00       	jmp    8037ea <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036ba:	01 d0                	add    %edx,%eax
  8036bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036bf:	83 ec 04             	sub    $0x4,%esp
  8036c2:	6a 01                	push   $0x1
  8036c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8036c7:	ff 75 08             	pushl  0x8(%ebp)
  8036ca:	e8 1e ea ff ff       	call   8020ed <set_block_data>
  8036cf:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	83 e8 04             	sub    $0x4,%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	83 e0 fe             	and    $0xfffffffe,%eax
  8036dd:	89 c2                	mov    %eax,%edx
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	01 d0                	add    %edx,%eax
  8036e4:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036eb:	74 06                	je     8036f3 <realloc_block_FF+0x613>
  8036ed:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036f1:	75 17                	jne    80370a <realloc_block_FF+0x62a>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 80 43 80 00       	push   $0x804380
  8036fb:	68 44 02 00 00       	push   $0x244
  803700:	68 0d 43 80 00       	push   $0x80430d
  803705:	e8 2b 01 00 00       	call   803835 <_panic>
  80370a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370d:	8b 10                	mov    (%eax),%edx
  80370f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803712:	89 10                	mov    %edx,(%eax)
  803714:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803717:	8b 00                	mov    (%eax),%eax
  803719:	85 c0                	test   %eax,%eax
  80371b:	74 0b                	je     803728 <realloc_block_FF+0x648>
  80371d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803725:	89 50 04             	mov    %edx,0x4(%eax)
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80372e:	89 10                	mov    %edx,(%eax)
  803730:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803733:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803736:	89 50 04             	mov    %edx,0x4(%eax)
  803739:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80373c:	8b 00                	mov    (%eax),%eax
  80373e:	85 c0                	test   %eax,%eax
  803740:	75 08                	jne    80374a <realloc_block_FF+0x66a>
  803742:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803745:	a3 30 50 80 00       	mov    %eax,0x805030
  80374a:	a1 38 50 80 00       	mov    0x805038,%eax
  80374f:	40                   	inc    %eax
  803750:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803755:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803759:	75 17                	jne    803772 <realloc_block_FF+0x692>
  80375b:	83 ec 04             	sub    $0x4,%esp
  80375e:	68 ef 42 80 00       	push   $0x8042ef
  803763:	68 45 02 00 00       	push   $0x245
  803768:	68 0d 43 80 00       	push   $0x80430d
  80376d:	e8 c3 00 00 00       	call   803835 <_panic>
  803772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803775:	8b 00                	mov    (%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	74 10                	je     80378b <realloc_block_FF+0x6ab>
  80377b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803783:	8b 52 04             	mov    0x4(%edx),%edx
  803786:	89 50 04             	mov    %edx,0x4(%eax)
  803789:	eb 0b                	jmp    803796 <realloc_block_FF+0x6b6>
  80378b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	a3 30 50 80 00       	mov    %eax,0x805030
  803796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803799:	8b 40 04             	mov    0x4(%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 0f                	je     8037af <realloc_block_FF+0x6cf>
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	8b 40 04             	mov    0x4(%eax),%eax
  8037a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a9:	8b 12                	mov    (%edx),%edx
  8037ab:	89 10                	mov    %edx,(%eax)
  8037ad:	eb 0a                	jmp    8037b9 <realloc_block_FF+0x6d9>
  8037af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d1:	48                   	dec    %eax
  8037d2:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8037d7:	83 ec 04             	sub    $0x4,%esp
  8037da:	6a 00                	push   $0x0
  8037dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8037df:	ff 75 b8             	pushl  -0x48(%ebp)
  8037e2:	e8 06 e9 ff ff       	call   8020ed <set_block_data>
  8037e7:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	eb 0a                	jmp    8037f9 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037ef:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037f9:	c9                   	leave  
  8037fa:	c3                   	ret    

008037fb <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037fb:	55                   	push   %ebp
  8037fc:	89 e5                	mov    %esp,%ebp
  8037fe:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803801:	83 ec 04             	sub    $0x4,%esp
  803804:	68 04 44 80 00       	push   $0x804404
  803809:	68 58 02 00 00       	push   $0x258
  80380e:	68 0d 43 80 00       	push   $0x80430d
  803813:	e8 1d 00 00 00       	call   803835 <_panic>

00803818 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803818:	55                   	push   %ebp
  803819:	89 e5                	mov    %esp,%ebp
  80381b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 2c 44 80 00       	push   $0x80442c
  803826:	68 61 02 00 00       	push   $0x261
  80382b:	68 0d 43 80 00       	push   $0x80430d
  803830:	e8 00 00 00 00       	call   803835 <_panic>

00803835 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803835:	55                   	push   %ebp
  803836:	89 e5                	mov    %esp,%ebp
  803838:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80383b:	8d 45 10             	lea    0x10(%ebp),%eax
  80383e:	83 c0 04             	add    $0x4,%eax
  803841:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803844:	a1 60 50 90 00       	mov    0x905060,%eax
  803849:	85 c0                	test   %eax,%eax
  80384b:	74 16                	je     803863 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80384d:	a1 60 50 90 00       	mov    0x905060,%eax
  803852:	83 ec 08             	sub    $0x8,%esp
  803855:	50                   	push   %eax
  803856:	68 54 44 80 00       	push   $0x804454
  80385b:	e8 09 cd ff ff       	call   800569 <cprintf>
  803860:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803863:	a1 00 50 80 00       	mov    0x805000,%eax
  803868:	ff 75 0c             	pushl  0xc(%ebp)
  80386b:	ff 75 08             	pushl  0x8(%ebp)
  80386e:	50                   	push   %eax
  80386f:	68 59 44 80 00       	push   $0x804459
  803874:	e8 f0 cc ff ff       	call   800569 <cprintf>
  803879:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80387c:	8b 45 10             	mov    0x10(%ebp),%eax
  80387f:	83 ec 08             	sub    $0x8,%esp
  803882:	ff 75 f4             	pushl  -0xc(%ebp)
  803885:	50                   	push   %eax
  803886:	e8 73 cc ff ff       	call   8004fe <vcprintf>
  80388b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80388e:	83 ec 08             	sub    $0x8,%esp
  803891:	6a 00                	push   $0x0
  803893:	68 75 44 80 00       	push   $0x804475
  803898:	e8 61 cc ff ff       	call   8004fe <vcprintf>
  80389d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8038a0:	e8 e2 cb ff ff       	call   800487 <exit>

	// should not return here
	while (1) ;
  8038a5:	eb fe                	jmp    8038a5 <_panic+0x70>

008038a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8038a7:	55                   	push   %ebp
  8038a8:	89 e5                	mov    %esp,%ebp
  8038aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8038ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8038b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bb:	39 c2                	cmp    %eax,%edx
  8038bd:	74 14                	je     8038d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8038bf:	83 ec 04             	sub    $0x4,%esp
  8038c2:	68 78 44 80 00       	push   $0x804478
  8038c7:	6a 26                	push   $0x26
  8038c9:	68 c4 44 80 00       	push   $0x8044c4
  8038ce:	e8 62 ff ff ff       	call   803835 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038e1:	e9 c5 00 00 00       	jmp    8039ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8038e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	01 d0                	add    %edx,%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	75 08                	jne    803903 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038fe:	e9 a5 00 00 00       	jmp    8039a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80390a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803911:	eb 69                	jmp    80397c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803913:	a1 20 50 80 00       	mov    0x805020,%eax
  803918:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80391e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803921:	89 d0                	mov    %edx,%eax
  803923:	01 c0                	add    %eax,%eax
  803925:	01 d0                	add    %edx,%eax
  803927:	c1 e0 03             	shl    $0x3,%eax
  80392a:	01 c8                	add    %ecx,%eax
  80392c:	8a 40 04             	mov    0x4(%eax),%al
  80392f:	84 c0                	test   %al,%al
  803931:	75 46                	jne    803979 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803933:	a1 20 50 80 00       	mov    0x805020,%eax
  803938:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80393e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803941:	89 d0                	mov    %edx,%eax
  803943:	01 c0                	add    %eax,%eax
  803945:	01 d0                	add    %edx,%eax
  803947:	c1 e0 03             	shl    $0x3,%eax
  80394a:	01 c8                	add    %ecx,%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803951:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803954:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803959:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	01 c8                	add    %ecx,%eax
  80396a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80396c:	39 c2                	cmp    %eax,%edx
  80396e:	75 09                	jne    803979 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803970:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803977:	eb 15                	jmp    80398e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803979:	ff 45 e8             	incl   -0x18(%ebp)
  80397c:	a1 20 50 80 00       	mov    0x805020,%eax
  803981:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398a:	39 c2                	cmp    %eax,%edx
  80398c:	77 85                	ja     803913 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80398e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803992:	75 14                	jne    8039a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	68 d0 44 80 00       	push   $0x8044d0
  80399c:	6a 3a                	push   $0x3a
  80399e:	68 c4 44 80 00       	push   $0x8044c4
  8039a3:	e8 8d fe ff ff       	call   803835 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8039a8:	ff 45 f0             	incl   -0x10(%ebp)
  8039ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039b1:	0f 8c 2f ff ff ff    	jl     8038e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8039b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039c5:	eb 26                	jmp    8039ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8039cc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039d5:	89 d0                	mov    %edx,%eax
  8039d7:	01 c0                	add    %eax,%eax
  8039d9:	01 d0                	add    %edx,%eax
  8039db:	c1 e0 03             	shl    $0x3,%eax
  8039de:	01 c8                	add    %ecx,%eax
  8039e0:	8a 40 04             	mov    0x4(%eax),%al
  8039e3:	3c 01                	cmp    $0x1,%al
  8039e5:	75 03                	jne    8039ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8039e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039ea:	ff 45 e0             	incl   -0x20(%ebp)
  8039ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8039f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039fb:	39 c2                	cmp    %eax,%edx
  8039fd:	77 c8                	ja     8039c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a05:	74 14                	je     803a1b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a07:	83 ec 04             	sub    $0x4,%esp
  803a0a:	68 24 45 80 00       	push   $0x804524
  803a0f:	6a 44                	push   $0x44
  803a11:	68 c4 44 80 00       	push   $0x8044c4
  803a16:	e8 1a fe ff ff       	call   803835 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a1b:	90                   	nop
  803a1c:	c9                   	leave  
  803a1d:	c3                   	ret    
  803a1e:	66 90                	xchg   %ax,%ax

00803a20 <__udivdi3>:
  803a20:	55                   	push   %ebp
  803a21:	57                   	push   %edi
  803a22:	56                   	push   %esi
  803a23:	53                   	push   %ebx
  803a24:	83 ec 1c             	sub    $0x1c,%esp
  803a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a37:	89 ca                	mov    %ecx,%edx
  803a39:	89 f8                	mov    %edi,%eax
  803a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a3f:	85 f6                	test   %esi,%esi
  803a41:	75 2d                	jne    803a70 <__udivdi3+0x50>
  803a43:	39 cf                	cmp    %ecx,%edi
  803a45:	77 65                	ja     803aac <__udivdi3+0x8c>
  803a47:	89 fd                	mov    %edi,%ebp
  803a49:	85 ff                	test   %edi,%edi
  803a4b:	75 0b                	jne    803a58 <__udivdi3+0x38>
  803a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a52:	31 d2                	xor    %edx,%edx
  803a54:	f7 f7                	div    %edi
  803a56:	89 c5                	mov    %eax,%ebp
  803a58:	31 d2                	xor    %edx,%edx
  803a5a:	89 c8                	mov    %ecx,%eax
  803a5c:	f7 f5                	div    %ebp
  803a5e:	89 c1                	mov    %eax,%ecx
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f5                	div    %ebp
  803a64:	89 cf                	mov    %ecx,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	39 ce                	cmp    %ecx,%esi
  803a72:	77 28                	ja     803a9c <__udivdi3+0x7c>
  803a74:	0f bd fe             	bsr    %esi,%edi
  803a77:	83 f7 1f             	xor    $0x1f,%edi
  803a7a:	75 40                	jne    803abc <__udivdi3+0x9c>
  803a7c:	39 ce                	cmp    %ecx,%esi
  803a7e:	72 0a                	jb     803a8a <__udivdi3+0x6a>
  803a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a84:	0f 87 9e 00 00 00    	ja     803b28 <__udivdi3+0x108>
  803a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8f:	89 fa                	mov    %edi,%edx
  803a91:	83 c4 1c             	add    $0x1c,%esp
  803a94:	5b                   	pop    %ebx
  803a95:	5e                   	pop    %esi
  803a96:	5f                   	pop    %edi
  803a97:	5d                   	pop    %ebp
  803a98:	c3                   	ret    
  803a99:	8d 76 00             	lea    0x0(%esi),%esi
  803a9c:	31 ff                	xor    %edi,%edi
  803a9e:	31 c0                	xor    %eax,%eax
  803aa0:	89 fa                	mov    %edi,%edx
  803aa2:	83 c4 1c             	add    $0x1c,%esp
  803aa5:	5b                   	pop    %ebx
  803aa6:	5e                   	pop    %esi
  803aa7:	5f                   	pop    %edi
  803aa8:	5d                   	pop    %ebp
  803aa9:	c3                   	ret    
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	89 d8                	mov    %ebx,%eax
  803aae:	f7 f7                	div    %edi
  803ab0:	31 ff                	xor    %edi,%edi
  803ab2:	89 fa                	mov    %edi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ac1:	89 eb                	mov    %ebp,%ebx
  803ac3:	29 fb                	sub    %edi,%ebx
  803ac5:	89 f9                	mov    %edi,%ecx
  803ac7:	d3 e6                	shl    %cl,%esi
  803ac9:	89 c5                	mov    %eax,%ebp
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 ed                	shr    %cl,%ebp
  803acf:	89 e9                	mov    %ebp,%ecx
  803ad1:	09 f1                	or     %esi,%ecx
  803ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ad7:	89 f9                	mov    %edi,%ecx
  803ad9:	d3 e0                	shl    %cl,%eax
  803adb:	89 c5                	mov    %eax,%ebp
  803add:	89 d6                	mov    %edx,%esi
  803adf:	88 d9                	mov    %bl,%cl
  803ae1:	d3 ee                	shr    %cl,%esi
  803ae3:	89 f9                	mov    %edi,%ecx
  803ae5:	d3 e2                	shl    %cl,%edx
  803ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aeb:	88 d9                	mov    %bl,%cl
  803aed:	d3 e8                	shr    %cl,%eax
  803aef:	09 c2                	or     %eax,%edx
  803af1:	89 d0                	mov    %edx,%eax
  803af3:	89 f2                	mov    %esi,%edx
  803af5:	f7 74 24 0c          	divl   0xc(%esp)
  803af9:	89 d6                	mov    %edx,%esi
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	f7 e5                	mul    %ebp
  803aff:	39 d6                	cmp    %edx,%esi
  803b01:	72 19                	jb     803b1c <__udivdi3+0xfc>
  803b03:	74 0b                	je     803b10 <__udivdi3+0xf0>
  803b05:	89 d8                	mov    %ebx,%eax
  803b07:	31 ff                	xor    %edi,%edi
  803b09:	e9 58 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b0e:	66 90                	xchg   %ax,%ax
  803b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b14:	89 f9                	mov    %edi,%ecx
  803b16:	d3 e2                	shl    %cl,%edx
  803b18:	39 c2                	cmp    %eax,%edx
  803b1a:	73 e9                	jae    803b05 <__udivdi3+0xe5>
  803b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b1f:	31 ff                	xor    %edi,%edi
  803b21:	e9 40 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b26:	66 90                	xchg   %ax,%ax
  803b28:	31 c0                	xor    %eax,%eax
  803b2a:	e9 37 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b2f:	90                   	nop

00803b30 <__umoddi3>:
  803b30:	55                   	push   %ebp
  803b31:	57                   	push   %edi
  803b32:	56                   	push   %esi
  803b33:	53                   	push   %ebx
  803b34:	83 ec 1c             	sub    $0x1c,%esp
  803b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b4f:	89 f3                	mov    %esi,%ebx
  803b51:	89 fa                	mov    %edi,%edx
  803b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b57:	89 34 24             	mov    %esi,(%esp)
  803b5a:	85 c0                	test   %eax,%eax
  803b5c:	75 1a                	jne    803b78 <__umoddi3+0x48>
  803b5e:	39 f7                	cmp    %esi,%edi
  803b60:	0f 86 a2 00 00 00    	jbe    803c08 <__umoddi3+0xd8>
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	89 f2                	mov    %esi,%edx
  803b6a:	f7 f7                	div    %edi
  803b6c:	89 d0                	mov    %edx,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	39 f0                	cmp    %esi,%eax
  803b7a:	0f 87 ac 00 00 00    	ja     803c2c <__umoddi3+0xfc>
  803b80:	0f bd e8             	bsr    %eax,%ebp
  803b83:	83 f5 1f             	xor    $0x1f,%ebp
  803b86:	0f 84 ac 00 00 00    	je     803c38 <__umoddi3+0x108>
  803b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b91:	29 ef                	sub    %ebp,%edi
  803b93:	89 fe                	mov    %edi,%esi
  803b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b99:	89 e9                	mov    %ebp,%ecx
  803b9b:	d3 e0                	shl    %cl,%eax
  803b9d:	89 d7                	mov    %edx,%edi
  803b9f:	89 f1                	mov    %esi,%ecx
  803ba1:	d3 ef                	shr    %cl,%edi
  803ba3:	09 c7                	or     %eax,%edi
  803ba5:	89 e9                	mov    %ebp,%ecx
  803ba7:	d3 e2                	shl    %cl,%edx
  803ba9:	89 14 24             	mov    %edx,(%esp)
  803bac:	89 d8                	mov    %ebx,%eax
  803bae:	d3 e0                	shl    %cl,%eax
  803bb0:	89 c2                	mov    %eax,%edx
  803bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb6:	d3 e0                	shl    %cl,%eax
  803bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc0:	89 f1                	mov    %esi,%ecx
  803bc2:	d3 e8                	shr    %cl,%eax
  803bc4:	09 d0                	or     %edx,%eax
  803bc6:	d3 eb                	shr    %cl,%ebx
  803bc8:	89 da                	mov    %ebx,%edx
  803bca:	f7 f7                	div    %edi
  803bcc:	89 d3                	mov    %edx,%ebx
  803bce:	f7 24 24             	mull   (%esp)
  803bd1:	89 c6                	mov    %eax,%esi
  803bd3:	89 d1                	mov    %edx,%ecx
  803bd5:	39 d3                	cmp    %edx,%ebx
  803bd7:	0f 82 87 00 00 00    	jb     803c64 <__umoddi3+0x134>
  803bdd:	0f 84 91 00 00 00    	je     803c74 <__umoddi3+0x144>
  803be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803be7:	29 f2                	sub    %esi,%edx
  803be9:	19 cb                	sbb    %ecx,%ebx
  803beb:	89 d8                	mov    %ebx,%eax
  803bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bf1:	d3 e0                	shl    %cl,%eax
  803bf3:	89 e9                	mov    %ebp,%ecx
  803bf5:	d3 ea                	shr    %cl,%edx
  803bf7:	09 d0                	or     %edx,%eax
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 eb                	shr    %cl,%ebx
  803bfd:	89 da                	mov    %ebx,%edx
  803bff:	83 c4 1c             	add    $0x1c,%esp
  803c02:	5b                   	pop    %ebx
  803c03:	5e                   	pop    %esi
  803c04:	5f                   	pop    %edi
  803c05:	5d                   	pop    %ebp
  803c06:	c3                   	ret    
  803c07:	90                   	nop
  803c08:	89 fd                	mov    %edi,%ebp
  803c0a:	85 ff                	test   %edi,%edi
  803c0c:	75 0b                	jne    803c19 <__umoddi3+0xe9>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f7                	div    %edi
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 f0                	mov    %esi,%eax
  803c1b:	31 d2                	xor    %edx,%edx
  803c1d:	f7 f5                	div    %ebp
  803c1f:	89 c8                	mov    %ecx,%eax
  803c21:	f7 f5                	div    %ebp
  803c23:	89 d0                	mov    %edx,%eax
  803c25:	e9 44 ff ff ff       	jmp    803b6e <__umoddi3+0x3e>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	89 c8                	mov    %ecx,%eax
  803c2e:	89 f2                	mov    %esi,%edx
  803c30:	83 c4 1c             	add    $0x1c,%esp
  803c33:	5b                   	pop    %ebx
  803c34:	5e                   	pop    %esi
  803c35:	5f                   	pop    %edi
  803c36:	5d                   	pop    %ebp
  803c37:	c3                   	ret    
  803c38:	3b 04 24             	cmp    (%esp),%eax
  803c3b:	72 06                	jb     803c43 <__umoddi3+0x113>
  803c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c41:	77 0f                	ja     803c52 <__umoddi3+0x122>
  803c43:	89 f2                	mov    %esi,%edx
  803c45:	29 f9                	sub    %edi,%ecx
  803c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c4b:	89 14 24             	mov    %edx,(%esp)
  803c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c56:	8b 14 24             	mov    (%esp),%edx
  803c59:	83 c4 1c             	add    $0x1c,%esp
  803c5c:	5b                   	pop    %ebx
  803c5d:	5e                   	pop    %esi
  803c5e:	5f                   	pop    %edi
  803c5f:	5d                   	pop    %ebp
  803c60:	c3                   	ret    
  803c61:	8d 76 00             	lea    0x0(%esi),%esi
  803c64:	2b 04 24             	sub    (%esp),%eax
  803c67:	19 fa                	sbb    %edi,%edx
  803c69:	89 d1                	mov    %edx,%ecx
  803c6b:	89 c6                	mov    %eax,%esi
  803c6d:	e9 71 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c78:	72 ea                	jb     803c64 <__umoddi3+0x134>
  803c7a:	89 d9                	mov    %ebx,%ecx
  803c7c:	e9 62 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
