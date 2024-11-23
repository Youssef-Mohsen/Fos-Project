
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
  80003e:	e8 b2 1a 00 00       	call   801af5 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 dc 1a 00 00       	call   801b27 <sys_getparentenvid>
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
  80005f:	68 40 3d 80 00       	push   $0x803d40
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 82 16 00 00       	call   8016ee <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 44 3d 80 00       	push   $0x803d44
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 6c 16 00 00       	call   8016ee <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 4c 3d 80 00       	push   $0x803d4c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 4f 16 00 00       	call   8016ee <sget>
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
  8000b3:	68 5a 3d 80 00       	push   $0x803d5a
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
  800112:	68 69 3d 80 00       	push   $0x803d69
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
  800166:	e8 ef 19 00 00       	call   801b5a <sys_get_virtual_time>
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
  8002f6:	68 85 3d 80 00       	push   $0x803d85
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
  800318:	68 87 3d 80 00       	push   $0x803d87
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
  800346:	68 8c 3d 80 00       	push   $0x803d8c
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
  80035c:	e8 ad 17 00 00       	call   801b0e <sys_getenvindex>
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
  8003ca:	e8 c3 14 00 00       	call   801892 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	68 a8 3d 80 00       	push   $0x803da8
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
  8003fa:	68 d0 3d 80 00       	push   $0x803dd0
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
  80042b:	68 f8 3d 80 00       	push   $0x803df8
  800430:	e8 34 01 00 00       	call   800569 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	50                   	push   %eax
  800447:	68 50 3e 80 00       	push   $0x803e50
  80044c:	e8 18 01 00 00       	call   800569 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	68 a8 3d 80 00       	push   $0x803da8
  80045c:	e8 08 01 00 00       	call   800569 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800464:	e8 43 14 00 00       	call   8018ac <sys_unlock_cons>
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
  80047c:	e8 59 16 00 00       	call   801ada <sys_destroy_env>
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
  80048d:	e8 ae 16 00 00       	call   801b40 <sys_exit_env>
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
  8004db:	e8 70 13 00 00       	call   801850 <sys_cputs>
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
  800552:	e8 f9 12 00 00       	call   801850 <sys_cputs>
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
  80059c:	e8 f1 12 00 00       	call   801892 <sys_lock_cons>
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
  8005bc:	e8 eb 12 00 00       	call   8018ac <sys_unlock_cons>
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
  800606:	e8 c5 34 00 00       	call   803ad0 <__udivdi3>
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
  800656:	e8 85 35 00 00       	call   803be0 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 94 40 80 00       	add    $0x804094,%eax
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
  8007b1:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  800892:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 a5 40 80 00       	push   $0x8040a5
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
  8008b7:	68 ae 40 80 00       	push   $0x8040ae
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
  8008e4:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  8012ef:	68 28 42 80 00       	push   $0x804228
  8012f4:	68 3f 01 00 00       	push   $0x13f
  8012f9:	68 4a 42 80 00       	push   $0x80424a
  8012fe:	e8 e4 25 00 00       	call   8038e7 <_panic>

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
  80130f:	e8 e7 0a 00 00       	call   801dfb <sys_sbrk>
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
  80138a:	e8 f0 08 00 00       	call   801c7f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 16                	je     8013a9 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 30 0e 00 00       	call   8021ce <alloc_block_FF>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a4:	e9 8a 01 00 00       	jmp    801533 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013a9:	e8 02 09 00 00       	call   801cb0 <sys_isUHeapPlacementStrategyBESTFIT>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	0f 84 7d 01 00 00    	je     801533 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 c9 12 00 00       	call   80268a <alloc_block_BF>
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
  80140c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801459:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8014b0:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  801512:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	ff 75 f0             	pushl  -0x10(%ebp)
  801522:	e8 0b 09 00 00       	call   801e32 <sys_allocate_user_mem>
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
  80156a:	e8 df 08 00 00       	call   801e4e <get_block_size>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 12 1b 00 00       	call   803092 <free_block>
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
  8015b5:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  8015f2:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801612:	e8 ff 07 00 00       	call   801e16 <sys_free_user_mem>
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
  801620:	68 58 42 80 00       	push   $0x804258
  801625:	68 85 00 00 00       	push   $0x85
  80162a:	68 82 42 80 00       	push   $0x804282
  80162f:	e8 b3 22 00 00       	call   8038e7 <_panic>
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
  801646:	75 0a                	jne    801652 <smalloc+0x1c>
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
  80164d:	e9 9a 00 00 00       	jmp    8016ec <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801658:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80165f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801665:	39 d0                	cmp    %edx,%eax
  801667:	73 02                	jae    80166b <smalloc+0x35>
  801669:	89 d0                	mov    %edx,%eax
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	50                   	push   %eax
  80166f:	e8 a5 fc ff ff       	call   801319 <malloc>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80167a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167e:	75 07                	jne    801687 <smalloc+0x51>
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
  801685:	eb 65                	jmp    8016ec <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801687:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80168b:	ff 75 ec             	pushl  -0x14(%ebp)
  80168e:	50                   	push   %eax
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	e8 83 03 00 00       	call   801a1d <sys_createSharedObject>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016a0:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016a4:	74 06                	je     8016ac <smalloc+0x76>
  8016a6:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016aa:	75 07                	jne    8016b3 <smalloc+0x7d>
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b1:	eb 39                	jmp    8016ec <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8016b3:	83 ec 08             	sub    $0x8,%esp
  8016b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b9:	68 8e 42 80 00       	push   $0x80428e
  8016be:	e8 a6 ee ff ff       	call   800569 <cprintf>
  8016c3:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8016c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ce:	8b 40 78             	mov    0x78(%eax),%eax
  8016d1:	29 c2                	sub    %eax,%edx
  8016d3:	89 d0                	mov    %edx,%eax
  8016d5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016da:	c1 e8 0c             	shr    $0xc,%eax
  8016dd:	89 c2                	mov    %eax,%edx
  8016df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	ff 75 08             	pushl  0x8(%ebp)
  8016fd:	e8 45 03 00 00       	call   801a47 <sys_getSizeOfSharedObject>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801708:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80170c:	75 07                	jne    801715 <sget+0x27>
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	eb 5c                	jmp    801771 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80171b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801722:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801728:	39 d0                	cmp    %edx,%eax
  80172a:	7d 02                	jge    80172e <sget+0x40>
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	83 ec 0c             	sub    $0xc,%esp
  801731:	50                   	push   %eax
  801732:	e8 e2 fb ff ff       	call   801319 <malloc>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80173d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801741:	75 07                	jne    80174a <sget+0x5c>
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	eb 27                	jmp    801771 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	ff 75 e8             	pushl  -0x18(%ebp)
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 09 03 00 00       	call   801a64 <sys_getSharedObject>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801761:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801765:	75 07                	jne    80176e <sget+0x80>
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	eb 03                	jmp    801771 <sget+0x83>
	return ptr;
  80176e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801779:	8b 55 08             	mov    0x8(%ebp),%edx
  80177c:	a1 20 50 80 00       	mov    0x805020,%eax
  801781:	8b 40 78             	mov    0x78(%eax),%eax
  801784:	29 c2                	sub    %eax,%edx
  801786:	89 d0                	mov    %edx,%eax
  801788:	2d 00 10 00 00       	sub    $0x1000,%eax
  80178d:	c1 e8 0c             	shr    $0xc,%eax
  801790:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801797:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80179a:	83 ec 08             	sub    $0x8,%esp
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a3:	e8 db 02 00 00       	call   801a83 <sys_freeSharedObject>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	68 a0 42 80 00       	push   $0x8042a0
  8017bf:	68 dd 00 00 00       	push   $0xdd
  8017c4:	68 82 42 80 00       	push   $0x804282
  8017c9:	e8 19 21 00 00       	call   8038e7 <_panic>

008017ce <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 c6 42 80 00       	push   $0x8042c6
  8017dc:	68 e9 00 00 00       	push   $0xe9
  8017e1:	68 82 42 80 00       	push   $0x804282
  8017e6:	e8 fc 20 00 00       	call   8038e7 <_panic>

008017eb <shrink>:

}
void shrink(uint32 newSize)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 c6 42 80 00       	push   $0x8042c6
  8017f9:	68 ee 00 00 00       	push   $0xee
  8017fe:	68 82 42 80 00       	push   $0x804282
  801803:	e8 df 20 00 00       	call   8038e7 <_panic>

00801808 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 c6 42 80 00       	push   $0x8042c6
  801816:	68 f3 00 00 00       	push   $0xf3
  80181b:	68 82 42 80 00       	push   $0x804282
  801820:	e8 c2 20 00 00       	call   8038e7 <_panic>

00801825 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	57                   	push   %edi
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801837:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801840:	cd 30                	int    $0x30
  801842:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	5b                   	pop    %ebx
  80184c:	5e                   	pop    %esi
  80184d:	5f                   	pop    %edi
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	8b 45 10             	mov    0x10(%ebp),%eax
  801859:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80185c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	52                   	push   %edx
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	50                   	push   %eax
  80186c:	6a 00                	push   $0x0
  80186e:	e8 b2 ff ff ff       	call   801825 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_cgetc>:

int
sys_cgetc(void)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 02                	push   $0x2
  801888:	e8 98 ff ff ff       	call   801825 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 03                	push   $0x3
  8018a1:	e8 7f ff ff ff       	call   801825 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	90                   	nop
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 04                	push   $0x4
  8018bb:	e8 65 ff ff ff       	call   801825 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	90                   	nop
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 08                	push   $0x8
  8018d9:	e8 47 ff ff ff       	call   801825 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8018eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
  8018f9:	51                   	push   %ecx
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 09                	push   $0x9
  8018fe:	e8 22 ff ff ff       	call   801825 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    

0080190d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 0a                	push   $0xa
  801920:	e8 00 ff ff ff       	call   801825 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 0b                	push   $0xb
  80193b:	e8 e5 fe ff ff       	call   801825 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 0c                	push   $0xc
  801954:	e8 cc fe ff ff       	call   801825 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 0d                	push   $0xd
  80196d:	e8 b3 fe ff ff       	call   801825 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 0e                	push   $0xe
  801986:	e8 9a fe ff ff       	call   801825 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 0f                	push   $0xf
  80199f:	e8 81 fe ff ff       	call   801825 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	ff 75 08             	pushl  0x8(%ebp)
  8019b7:	6a 10                	push   $0x10
  8019b9:	e8 67 fe ff ff       	call   801825 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 11                	push   $0x11
  8019d2:	e8 4e fe ff ff       	call   801825 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_cputc>:

void
sys_cputc(const char c)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	50                   	push   %eax
  8019f6:	6a 01                	push   $0x1
  8019f8:	e8 28 fe ff ff       	call   801825 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 14                	push   $0x14
  801a12:	e8 0e fe ff ff       	call   801825 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	8b 45 10             	mov    0x10(%ebp),%eax
  801a26:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a29:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a2c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	51                   	push   %ecx
  801a36:	52                   	push   %edx
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	50                   	push   %eax
  801a3b:	6a 15                	push   $0x15
  801a3d:	e8 e3 fd ff ff       	call   801825 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	6a 16                	push   $0x16
  801a5a:	e8 c6 fd ff ff       	call   801825 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	51                   	push   %ecx
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 17                	push   $0x17
  801a79:	e8 a7 fd ff ff       	call   801825 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 18                	push   $0x18
  801a96:	e8 8a fd ff ff       	call   801825 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 14             	pushl  0x14(%ebp)
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	6a 19                	push   $0x19
  801ab4:	e8 6c fd ff ff       	call   801825 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_run_env>:

void sys_run_env(int32 envId)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	50                   	push   %eax
  801acd:	6a 1a                	push   $0x1a
  801acf:	e8 51 fd ff ff       	call   801825 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	90                   	nop
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	50                   	push   %eax
  801ae9:	6a 1b                	push   $0x1b
  801aeb:	e8 35 fd ff ff       	call   801825 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 05                	push   $0x5
  801b04:	e8 1c fd ff ff       	call   801825 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 06                	push   $0x6
  801b1d:	e8 03 fd ff ff       	call   801825 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 07                	push   $0x7
  801b36:	e8 ea fc ff ff       	call   801825 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_exit_env>:


void sys_exit_env(void)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 1c                	push   $0x1c
  801b4f:	e8 d1 fc ff ff       	call   801825 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	90                   	nop
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b63:	8d 50 04             	lea    0x4(%eax),%edx
  801b66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	6a 1d                	push   $0x1d
  801b73:	e8 ad fc ff ff       	call   801825 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return result;
  801b7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b84:	89 01                	mov    %eax,(%ecx)
  801b86:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	c9                   	leave  
  801b8d:	c2 04 00             	ret    $0x4

00801b90 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 13                	push   $0x13
  801ba2:	e8 7e fc ff ff       	call   801825 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_rcr2>:
uint32 sys_rcr2()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 1e                	push   $0x1e
  801bbc:	e8 64 fc ff ff       	call   801825 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	50                   	push   %eax
  801bdf:	6a 1f                	push   $0x1f
  801be1:	e8 3f fc ff ff       	call   801825 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return ;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <rsttst>:
void rsttst()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 21                	push   $0x21
  801bfb:	e8 25 fc ff ff       	call   801825 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return ;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c12:	8b 55 18             	mov    0x18(%ebp),%edx
  801c15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	ff 75 10             	pushl  0x10(%ebp)
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 20                	push   $0x20
  801c26:	e8 fa fb ff ff       	call   801825 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <chktst>:
void chktst(uint32 n)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 08             	pushl  0x8(%ebp)
  801c3f:	6a 22                	push   $0x22
  801c41:	e8 df fb ff ff       	call   801825 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return ;
  801c49:	90                   	nop
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <inctst>:

void inctst()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 23                	push   $0x23
  801c5b:	e8 c5 fb ff ff       	call   801825 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return ;
  801c63:	90                   	nop
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <gettst>:
uint32 gettst()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 24                	push   $0x24
  801c75:	e8 ab fb ff ff       	call   801825 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 25                	push   $0x25
  801c91:	e8 8f fb ff ff       	call   801825 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
  801c99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c9c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ca0:	75 07                	jne    801ca9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca7:	eb 05                	jmp    801cae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 25                	push   $0x25
  801cc2:	e8 5e fb ff ff       	call   801825 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
  801cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ccd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cd1:	75 07                	jne    801cda <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd8:	eb 05                	jmp    801cdf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 25                	push   $0x25
  801cf3:	e8 2d fb ff ff       	call   801825 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
  801cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cfe:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d02:	75 07                	jne    801d0b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d04:	b8 01 00 00 00       	mov    $0x1,%eax
  801d09:	eb 05                	jmp    801d10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 25                	push   $0x25
  801d24:	e8 fc fa ff ff       	call   801825 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
  801d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d2f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d33:	75 07                	jne    801d3c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	eb 05                	jmp    801d41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	6a 26                	push   $0x26
  801d53:	e8 cd fa ff ff       	call   801825 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5b:	90                   	nop
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	6a 00                	push   $0x0
  801d70:	53                   	push   %ebx
  801d71:	51                   	push   %ecx
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 27                	push   $0x27
  801d76:	e8 aa fa ff ff       	call   801825 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	52                   	push   %edx
  801d93:	50                   	push   %eax
  801d94:	6a 28                	push   $0x28
  801d96:	e8 8a fa ff ff       	call   801825 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801da3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	6a 00                	push   $0x0
  801dae:	51                   	push   %ecx
  801daf:	ff 75 10             	pushl  0x10(%ebp)
  801db2:	52                   	push   %edx
  801db3:	50                   	push   %eax
  801db4:	6a 29                	push   $0x29
  801db6:	e8 6a fa ff ff       	call   801825 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 10             	pushl  0x10(%ebp)
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 12                	push   $0x12
  801dd2:	e8 4e fa ff ff       	call   801825 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	52                   	push   %edx
  801ded:	50                   	push   %eax
  801dee:	6a 2a                	push   $0x2a
  801df0:	e8 30 fa ff ff       	call   801825 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
	return;
  801df8:	90                   	nop
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	50                   	push   %eax
  801e0a:	6a 2b                	push   $0x2b
  801e0c:	e8 14 fa ff ff       	call   801825 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	6a 2c                	push   $0x2c
  801e27:	e8 f9 f9 ff ff       	call   801825 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
	return;
  801e2f:	90                   	nop
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	ff 75 0c             	pushl  0xc(%ebp)
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	6a 2d                	push   $0x2d
  801e43:	e8 dd f9 ff ff       	call   801825 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
	return;
  801e4b:	90                   	nop
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	83 e8 04             	sub    $0x4,%eax
  801e5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	83 e8 04             	sub    $0x4,%eax
  801e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e79:	8b 00                	mov    (%eax),%eax
  801e7b:	83 e0 01             	and    $0x1,%eax
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 94 c0             	sete   %al
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e95:	83 f8 02             	cmp    $0x2,%eax
  801e98:	74 2b                	je     801ec5 <alloc_block+0x40>
  801e9a:	83 f8 02             	cmp    $0x2,%eax
  801e9d:	7f 07                	jg     801ea6 <alloc_block+0x21>
  801e9f:	83 f8 01             	cmp    $0x1,%eax
  801ea2:	74 0e                	je     801eb2 <alloc_block+0x2d>
  801ea4:	eb 58                	jmp    801efe <alloc_block+0x79>
  801ea6:	83 f8 03             	cmp    $0x3,%eax
  801ea9:	74 2d                	je     801ed8 <alloc_block+0x53>
  801eab:	83 f8 04             	cmp    $0x4,%eax
  801eae:	74 3b                	je     801eeb <alloc_block+0x66>
  801eb0:	eb 4c                	jmp    801efe <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 11 03 00 00       	call   8021ce <alloc_block_FF>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec3:	eb 4a                	jmp    801f0f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	e8 fa 19 00 00       	call   8038ca <alloc_block_NF>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ed6:	eb 37                	jmp    801f0f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ed8:	83 ec 0c             	sub    $0xc,%esp
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	e8 a7 07 00 00       	call   80268a <alloc_block_BF>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ee9:	eb 24                	jmp    801f0f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	ff 75 08             	pushl  0x8(%ebp)
  801ef1:	e8 b7 19 00 00       	call   8038ad <alloc_block_WF>
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801efc:	eb 11                	jmp    801f0f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	68 d8 42 80 00       	push   $0x8042d8
  801f06:	e8 5e e6 ff ff       	call   800569 <cprintf>
  801f0b:	83 c4 10             	add    $0x10,%esp
		break;
  801f0e:	90                   	nop
	}
	return va;
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	53                   	push   %ebx
  801f18:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	68 f8 42 80 00       	push   $0x8042f8
  801f23:	e8 41 e6 ff ff       	call   800569 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	68 23 43 80 00       	push   $0x804323
  801f33:	e8 31 e6 ff ff       	call   800569 <cprintf>
  801f38:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f41:	eb 37                	jmp    801f7a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	ff 75 f4             	pushl  -0xc(%ebp)
  801f49:	e8 19 ff ff ff       	call   801e67 <is_free_block>
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	0f be d8             	movsbl %al,%ebx
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5a:	e8 ef fe ff ff       	call   801e4e <get_block_size>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	53                   	push   %ebx
  801f66:	50                   	push   %eax
  801f67:	68 3b 43 80 00       	push   $0x80433b
  801f6c:	e8 f8 e5 ff ff       	call   800569 <cprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f74:	8b 45 10             	mov    0x10(%ebp),%eax
  801f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7e:	74 07                	je     801f87 <print_blocks_list+0x73>
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 00                	mov    (%eax),%eax
  801f85:	eb 05                	jmp    801f8c <print_blocks_list+0x78>
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	89 45 10             	mov    %eax,0x10(%ebp)
  801f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	75 ad                	jne    801f43 <print_blocks_list+0x2f>
  801f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9a:	75 a7                	jne    801f43 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	68 f8 42 80 00       	push   $0x8042f8
  801fa4:	e8 c0 e5 ff ff       	call   800569 <cprintf>
  801fa9:	83 c4 10             	add    $0x10,%esp

}
  801fac:	90                   	nop
  801fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbb:	83 e0 01             	and    $0x1,%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	74 03                	je     801fc5 <initialize_dynamic_allocator+0x13>
  801fc2:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc9:	0f 84 c7 01 00 00    	je     802196 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fcf:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fd6:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdf:	01 d0                	add    %edx,%eax
  801fe1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fe6:	0f 87 ad 01 00 00    	ja     802199 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	0f 89 a5 01 00 00    	jns    80219c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffd:	01 d0                	add    %edx,%eax
  801fff:	83 e8 04             	sub    $0x4,%eax
  802002:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80200e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802013:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802016:	e9 87 00 00 00       	jmp    8020a2 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80201b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201f:	75 14                	jne    802035 <initialize_dynamic_allocator+0x83>
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	68 53 43 80 00       	push   $0x804353
  802029:	6a 79                	push   $0x79
  80202b:	68 71 43 80 00       	push   $0x804371
  802030:	e8 b2 18 00 00       	call   8038e7 <_panic>
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	8b 00                	mov    (%eax),%eax
  80203a:	85 c0                	test   %eax,%eax
  80203c:	74 10                	je     80204e <initialize_dynamic_allocator+0x9c>
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	8b 00                	mov    (%eax),%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	8b 52 04             	mov    0x4(%edx),%edx
  802049:	89 50 04             	mov    %edx,0x4(%eax)
  80204c:	eb 0b                	jmp    802059 <initialize_dynamic_allocator+0xa7>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 40 04             	mov    0x4(%eax),%eax
  802054:	a3 30 50 80 00       	mov    %eax,0x805030
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	8b 40 04             	mov    0x4(%eax),%eax
  80205f:	85 c0                	test   %eax,%eax
  802061:	74 0f                	je     802072 <initialize_dynamic_allocator+0xc0>
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 40 04             	mov    0x4(%eax),%eax
  802069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206c:	8b 12                	mov    (%edx),%edx
  80206e:	89 10                	mov    %edx,(%eax)
  802070:	eb 0a                	jmp    80207c <initialize_dynamic_allocator+0xca>
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	8b 00                	mov    (%eax),%eax
  802077:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80208f:	a1 38 50 80 00       	mov    0x805038,%eax
  802094:	48                   	dec    %eax
  802095:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80209a:	a1 34 50 80 00       	mov    0x805034,%eax
  80209f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a6:	74 07                	je     8020af <initialize_dynamic_allocator+0xfd>
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	8b 00                	mov    (%eax),%eax
  8020ad:	eb 05                	jmp    8020b4 <initialize_dynamic_allocator+0x102>
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	a3 34 50 80 00       	mov    %eax,0x805034
  8020b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	0f 85 55 ff ff ff    	jne    80201b <initialize_dynamic_allocator+0x69>
  8020c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ca:	0f 85 4b ff ff ff    	jne    80201b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020df:	a1 44 50 80 00       	mov    0x805044,%eax
  8020e4:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020e9:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	83 c0 08             	add    $0x8,%eax
  8020fa:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	83 c0 04             	add    $0x4,%eax
  802103:	8b 55 0c             	mov    0xc(%ebp),%edx
  802106:	83 ea 08             	sub    $0x8,%edx
  802109:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80210b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	01 d0                	add    %edx,%eax
  802113:	83 e8 08             	sub    $0x8,%eax
  802116:	8b 55 0c             	mov    0xc(%ebp),%edx
  802119:	83 ea 08             	sub    $0x8,%edx
  80211c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80211e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802131:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802135:	75 17                	jne    80214e <initialize_dynamic_allocator+0x19c>
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	68 8c 43 80 00       	push   $0x80438c
  80213f:	68 90 00 00 00       	push   $0x90
  802144:	68 71 43 80 00       	push   $0x804371
  802149:	e8 99 17 00 00       	call   8038e7 <_panic>
  80214e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802157:	89 10                	mov    %edx,(%eax)
  802159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	74 0d                	je     80216f <initialize_dynamic_allocator+0x1bd>
  802162:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802167:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80216a:	89 50 04             	mov    %edx,0x4(%eax)
  80216d:	eb 08                	jmp    802177 <initialize_dynamic_allocator+0x1c5>
  80216f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802172:	a3 30 50 80 00       	mov    %eax,0x805030
  802177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80217f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802189:	a1 38 50 80 00       	mov    0x805038,%eax
  80218e:	40                   	inc    %eax
  80218f:	a3 38 50 80 00       	mov    %eax,0x805038
  802194:	eb 07                	jmp    80219d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802196:	90                   	nop
  802197:	eb 04                	jmp    80219d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802199:	90                   	nop
  80219a:	eb 01                	jmp    80219d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80219c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a5:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	83 e8 04             	sub    $0x4,%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	83 e0 fe             	and    $0xfffffffe,%eax
  8021be:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	01 c2                	add    %eax,%edx
  8021c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c9:	89 02                	mov    %eax,(%edx)
}
  8021cb:	90                   	nop
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	83 e0 01             	and    $0x1,%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	74 03                	je     8021e1 <alloc_block_FF+0x13>
  8021de:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021e1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021e5:	77 07                	ja     8021ee <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021e7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	75 73                	jne    80226a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	83 c0 10             	add    $0x10,%eax
  8021fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802200:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802207:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220d:	01 d0                	add    %edx,%eax
  80220f:	48                   	dec    %eax
  802210:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802216:	ba 00 00 00 00       	mov    $0x0,%edx
  80221b:	f7 75 ec             	divl   -0x14(%ebp)
  80221e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802221:	29 d0                	sub    %edx,%eax
  802223:	c1 e8 0c             	shr    $0xc,%eax
  802226:	83 ec 0c             	sub    $0xc,%esp
  802229:	50                   	push   %eax
  80222a:	e8 d4 f0 ff ff       	call   801303 <sbrk>
  80222f:	83 c4 10             	add    $0x10,%esp
  802232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	6a 00                	push   $0x0
  80223a:	e8 c4 f0 ff ff       	call   801303 <sbrk>
  80223f:	83 c4 10             	add    $0x10,%esp
  802242:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802248:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80224b:	83 ec 08             	sub    $0x8,%esp
  80224e:	50                   	push   %eax
  80224f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802252:	e8 5b fd ff ff       	call   801fb2 <initialize_dynamic_allocator>
  802257:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	68 af 43 80 00       	push   $0x8043af
  802262:	e8 02 e3 ff ff       	call   800569 <cprintf>
  802267:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80226a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226e:	75 0a                	jne    80227a <alloc_block_FF+0xac>
	        return NULL;
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
  802275:	e9 0e 04 00 00       	jmp    802688 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80227a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802281:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802289:	e9 f3 02 00 00       	jmp    802581 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	ff 75 bc             	pushl  -0x44(%ebp)
  80229a:	e8 af fb ff ff       	call   801e4e <get_block_size>
  80229f:	83 c4 10             	add    $0x10,%esp
  8022a2:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	83 c0 08             	add    $0x8,%eax
  8022ab:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022ae:	0f 87 c5 02 00 00    	ja     802579 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	83 c0 18             	add    $0x18,%eax
  8022ba:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022bd:	0f 87 19 02 00 00    	ja     8024dc <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8022c9:	83 e8 08             	sub    $0x8,%eax
  8022cc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8d 50 08             	lea    0x8(%eax),%edx
  8022d5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022d8:	01 d0                	add    %edx,%eax
  8022da:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	83 c0 08             	add    $0x8,%eax
  8022e3:	83 ec 04             	sub    $0x4,%esp
  8022e6:	6a 01                	push   $0x1
  8022e8:	50                   	push   %eax
  8022e9:	ff 75 bc             	pushl  -0x44(%ebp)
  8022ec:	e8 ae fe ff ff       	call   80219f <set_block_data>
  8022f1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	75 68                	jne    802366 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022fe:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802302:	75 17                	jne    80231b <alloc_block_FF+0x14d>
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	68 8c 43 80 00       	push   $0x80438c
  80230c:	68 d7 00 00 00       	push   $0xd7
  802311:	68 71 43 80 00       	push   $0x804371
  802316:	e8 cc 15 00 00       	call   8038e7 <_panic>
  80231b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802321:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802324:	89 10                	mov    %edx,(%eax)
  802326:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802329:	8b 00                	mov    (%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	74 0d                	je     80233c <alloc_block_FF+0x16e>
  80232f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802334:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802337:	89 50 04             	mov    %edx,0x4(%eax)
  80233a:	eb 08                	jmp    802344 <alloc_block_FF+0x176>
  80233c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80233f:	a3 30 50 80 00       	mov    %eax,0x805030
  802344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802347:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80234c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802356:	a1 38 50 80 00       	mov    0x805038,%eax
  80235b:	40                   	inc    %eax
  80235c:	a3 38 50 80 00       	mov    %eax,0x805038
  802361:	e9 dc 00 00 00       	jmp    802442 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	85 c0                	test   %eax,%eax
  80236d:	75 65                	jne    8023d4 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80236f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802373:	75 17                	jne    80238c <alloc_block_FF+0x1be>
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	68 c0 43 80 00       	push   $0x8043c0
  80237d:	68 db 00 00 00       	push   $0xdb
  802382:	68 71 43 80 00       	push   $0x804371
  802387:	e8 5b 15 00 00       	call   8038e7 <_panic>
  80238c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802392:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802395:	89 50 04             	mov    %edx,0x4(%eax)
  802398:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239b:	8b 40 04             	mov    0x4(%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	74 0c                	je     8023ae <alloc_block_FF+0x1e0>
  8023a2:	a1 30 50 80 00       	mov    0x805030,%eax
  8023a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023aa:	89 10                	mov    %edx,(%eax)
  8023ac:	eb 08                	jmp    8023b6 <alloc_block_FF+0x1e8>
  8023ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8023be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8023cc:	40                   	inc    %eax
  8023cd:	a3 38 50 80 00       	mov    %eax,0x805038
  8023d2:	eb 6e                	jmp    802442 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d8:	74 06                	je     8023e0 <alloc_block_FF+0x212>
  8023da:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023de:	75 17                	jne    8023f7 <alloc_block_FF+0x229>
  8023e0:	83 ec 04             	sub    $0x4,%esp
  8023e3:	68 e4 43 80 00       	push   $0x8043e4
  8023e8:	68 df 00 00 00       	push   $0xdf
  8023ed:	68 71 43 80 00       	push   $0x804371
  8023f2:	e8 f0 14 00 00       	call   8038e7 <_panic>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 10                	mov    (%eax),%edx
  8023fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ff:	89 10                	mov    %edx,(%eax)
  802401:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	85 c0                	test   %eax,%eax
  802408:	74 0b                	je     802415 <alloc_block_FF+0x247>
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80241b:	89 10                	mov    %edx,(%eax)
  80241d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802423:	89 50 04             	mov    %edx,0x4(%eax)
  802426:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	75 08                	jne    802437 <alloc_block_FF+0x269>
  80242f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802432:	a3 30 50 80 00       	mov    %eax,0x805030
  802437:	a1 38 50 80 00       	mov    0x805038,%eax
  80243c:	40                   	inc    %eax
  80243d:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802446:	75 17                	jne    80245f <alloc_block_FF+0x291>
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	68 53 43 80 00       	push   $0x804353
  802450:	68 e1 00 00 00       	push   $0xe1
  802455:	68 71 43 80 00       	push   $0x804371
  80245a:	e8 88 14 00 00       	call   8038e7 <_panic>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	74 10                	je     802478 <alloc_block_FF+0x2aa>
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802470:	8b 52 04             	mov    0x4(%edx),%edx
  802473:	89 50 04             	mov    %edx,0x4(%eax)
  802476:	eb 0b                	jmp    802483 <alloc_block_FF+0x2b5>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	a3 30 50 80 00       	mov    %eax,0x805030
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 0f                	je     80249c <alloc_block_FF+0x2ce>
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 40 04             	mov    0x4(%eax),%eax
  802493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802496:	8b 12                	mov    (%edx),%edx
  802498:	89 10                	mov    %edx,(%eax)
  80249a:	eb 0a                	jmp    8024a6 <alloc_block_FF+0x2d8>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8024be:	48                   	dec    %eax
  8024bf:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	6a 00                	push   $0x0
  8024c9:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024cc:	ff 75 b0             	pushl  -0x50(%ebp)
  8024cf:	e8 cb fc ff ff       	call   80219f <set_block_data>
  8024d4:	83 c4 10             	add    $0x10,%esp
  8024d7:	e9 95 00 00 00       	jmp    802571 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024dc:	83 ec 04             	sub    $0x4,%esp
  8024df:	6a 01                	push   $0x1
  8024e1:	ff 75 b8             	pushl  -0x48(%ebp)
  8024e4:	ff 75 bc             	pushl  -0x44(%ebp)
  8024e7:	e8 b3 fc ff ff       	call   80219f <set_block_data>
  8024ec:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f3:	75 17                	jne    80250c <alloc_block_FF+0x33e>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 53 43 80 00       	push   $0x804353
  8024fd:	68 e8 00 00 00       	push   $0xe8
  802502:	68 71 43 80 00       	push   $0x804371
  802507:	e8 db 13 00 00       	call   8038e7 <_panic>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 10                	je     802525 <alloc_block_FF+0x357>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	8b 52 04             	mov    0x4(%edx),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	eb 0b                	jmp    802530 <alloc_block_FF+0x362>
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	a3 30 50 80 00       	mov    %eax,0x805030
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	74 0f                	je     802549 <alloc_block_FF+0x37b>
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802543:	8b 12                	mov    (%edx),%edx
  802545:	89 10                	mov    %edx,(%eax)
  802547:	eb 0a                	jmp    802553 <alloc_block_FF+0x385>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802566:	a1 38 50 80 00       	mov    0x805038,%eax
  80256b:	48                   	dec    %eax
  80256c:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802571:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802574:	e9 0f 01 00 00       	jmp    802688 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802579:	a1 34 50 80 00       	mov    0x805034,%eax
  80257e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	74 07                	je     80258e <alloc_block_FF+0x3c0>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	eb 05                	jmp    802593 <alloc_block_FF+0x3c5>
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	a3 34 50 80 00       	mov    %eax,0x805034
  802598:	a1 34 50 80 00       	mov    0x805034,%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	0f 85 e9 fc ff ff    	jne    80228e <alloc_block_FF+0xc0>
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	0f 85 df fc ff ff    	jne    80228e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	83 c0 08             	add    $0x8,%eax
  8025b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025b8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025c5:	01 d0                	add    %edx,%eax
  8025c7:	48                   	dec    %eax
  8025c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d3:	f7 75 d8             	divl   -0x28(%ebp)
  8025d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d9:	29 d0                	sub    %edx,%eax
  8025db:	c1 e8 0c             	shr    $0xc,%eax
  8025de:	83 ec 0c             	sub    $0xc,%esp
  8025e1:	50                   	push   %eax
  8025e2:	e8 1c ed ff ff       	call   801303 <sbrk>
  8025e7:	83 c4 10             	add    $0x10,%esp
  8025ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025ed:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025f1:	75 0a                	jne    8025fd <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	e9 8b 00 00 00       	jmp    802688 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025fd:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802604:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802607:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80260a:	01 d0                	add    %edx,%eax
  80260c:	48                   	dec    %eax
  80260d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802610:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802613:	ba 00 00 00 00       	mov    $0x0,%edx
  802618:	f7 75 cc             	divl   -0x34(%ebp)
  80261b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80261e:	29 d0                	sub    %edx,%eax
  802620:	8d 50 fc             	lea    -0x4(%eax),%edx
  802623:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80262d:	a1 40 50 80 00       	mov    0x805040,%eax
  802632:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802638:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80263f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802642:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802645:	01 d0                	add    %edx,%eax
  802647:	48                   	dec    %eax
  802648:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80264b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80264e:	ba 00 00 00 00       	mov    $0x0,%edx
  802653:	f7 75 c4             	divl   -0x3c(%ebp)
  802656:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802659:	29 d0                	sub    %edx,%eax
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	6a 01                	push   $0x1
  802660:	50                   	push   %eax
  802661:	ff 75 d0             	pushl  -0x30(%ebp)
  802664:	e8 36 fb ff ff       	call   80219f <set_block_data>
  802669:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80266c:	83 ec 0c             	sub    $0xc,%esp
  80266f:	ff 75 d0             	pushl  -0x30(%ebp)
  802672:	e8 1b 0a 00 00       	call   803092 <free_block>
  802677:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	ff 75 08             	pushl  0x8(%ebp)
  802680:	e8 49 fb ff ff       	call   8021ce <alloc_block_FF>
  802685:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	83 e0 01             	and    $0x1,%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 03                	je     80269d <alloc_block_BF+0x13>
  80269a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80269d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026a1:	77 07                	ja     8026aa <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026a3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026aa:	a1 24 50 80 00       	mov    0x805024,%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	75 73                	jne    802726 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	83 c0 10             	add    $0x10,%eax
  8026b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026bc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c9:	01 d0                	add    %edx,%eax
  8026cb:	48                   	dec    %eax
  8026cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d7:	f7 75 e0             	divl   -0x20(%ebp)
  8026da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026dd:	29 d0                	sub    %edx,%eax
  8026df:	c1 e8 0c             	shr    $0xc,%eax
  8026e2:	83 ec 0c             	sub    $0xc,%esp
  8026e5:	50                   	push   %eax
  8026e6:	e8 18 ec ff ff       	call   801303 <sbrk>
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026f1:	83 ec 0c             	sub    $0xc,%esp
  8026f4:	6a 00                	push   $0x0
  8026f6:	e8 08 ec ff ff       	call   801303 <sbrk>
  8026fb:	83 c4 10             	add    $0x10,%esp
  8026fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802704:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802707:	83 ec 08             	sub    $0x8,%esp
  80270a:	50                   	push   %eax
  80270b:	ff 75 d8             	pushl  -0x28(%ebp)
  80270e:	e8 9f f8 ff ff       	call   801fb2 <initialize_dynamic_allocator>
  802713:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802716:	83 ec 0c             	sub    $0xc,%esp
  802719:	68 af 43 80 00       	push   $0x8043af
  80271e:	e8 46 de ff ff       	call   800569 <cprintf>
  802723:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80272d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802734:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80273b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802742:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274a:	e9 1d 01 00 00       	jmp    80286c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802755:	83 ec 0c             	sub    $0xc,%esp
  802758:	ff 75 a8             	pushl  -0x58(%ebp)
  80275b:	e8 ee f6 ff ff       	call   801e4e <get_block_size>
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	83 c0 08             	add    $0x8,%eax
  80276c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80276f:	0f 87 ef 00 00 00    	ja     802864 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802775:	8b 45 08             	mov    0x8(%ebp),%eax
  802778:	83 c0 18             	add    $0x18,%eax
  80277b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80277e:	77 1d                	ja     80279d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802786:	0f 86 d8 00 00 00    	jbe    802864 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80278c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80278f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802792:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802798:	e9 c7 00 00 00       	jmp    802864 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	83 c0 08             	add    $0x8,%eax
  8027a3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a6:	0f 85 9d 00 00 00    	jne    802849 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	6a 01                	push   $0x1
  8027b1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027b4:	ff 75 a8             	pushl  -0x58(%ebp)
  8027b7:	e8 e3 f9 ff ff       	call   80219f <set_block_data>
  8027bc:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c3:	75 17                	jne    8027dc <alloc_block_BF+0x152>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 53 43 80 00       	push   $0x804353
  8027cd:	68 2c 01 00 00       	push   $0x12c
  8027d2:	68 71 43 80 00       	push   $0x804371
  8027d7:	e8 0b 11 00 00       	call   8038e7 <_panic>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 10                	je     8027f5 <alloc_block_BF+0x16b>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ed:	8b 52 04             	mov    0x4(%edx),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 0b                	jmp    802800 <alloc_block_BF+0x176>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	a3 30 50 80 00       	mov    %eax,0x805030
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0f                	je     802819 <alloc_block_BF+0x18f>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802813:	8b 12                	mov    (%edx),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	eb 0a                	jmp    802823 <alloc_block_BF+0x199>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802836:	a1 38 50 80 00       	mov    0x805038,%eax
  80283b:	48                   	dec    %eax
  80283c:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802841:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802844:	e9 24 04 00 00       	jmp    802c6d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80284f:	76 13                	jbe    802864 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802851:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802858:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80285b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80285e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802861:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802864:	a1 34 50 80 00       	mov    0x805034,%eax
  802869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802870:	74 07                	je     802879 <alloc_block_BF+0x1ef>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	eb 05                	jmp    80287e <alloc_block_BF+0x1f4>
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
  80287e:	a3 34 50 80 00       	mov    %eax,0x805034
  802883:	a1 34 50 80 00       	mov    0x805034,%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	0f 85 bf fe ff ff    	jne    80274f <alloc_block_BF+0xc5>
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	0f 85 b5 fe ff ff    	jne    80274f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80289a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80289e:	0f 84 26 02 00 00    	je     802aca <alloc_block_BF+0x440>
  8028a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a8:	0f 85 1c 02 00 00    	jne    802aca <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b4:	83 e8 08             	sub    $0x8,%eax
  8028b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	8d 50 08             	lea    0x8(%eax),%edx
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	83 c0 08             	add    $0x8,%eax
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	6a 01                	push   $0x1
  8028d3:	50                   	push   %eax
  8028d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8028d7:	e8 c3 f8 ff ff       	call   80219f <set_block_data>
  8028dc:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 40 04             	mov    0x4(%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	75 68                	jne    802951 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ed:	75 17                	jne    802906 <alloc_block_BF+0x27c>
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	68 8c 43 80 00       	push   $0x80438c
  8028f7:	68 45 01 00 00       	push   $0x145
  8028fc:	68 71 43 80 00       	push   $0x804371
  802901:	e8 e1 0f 00 00       	call   8038e7 <_panic>
  802906:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80290c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	74 0d                	je     802927 <alloc_block_BF+0x29d>
  80291a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80291f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802922:	89 50 04             	mov    %edx,0x4(%eax)
  802925:	eb 08                	jmp    80292f <alloc_block_BF+0x2a5>
  802927:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292a:	a3 30 50 80 00       	mov    %eax,0x805030
  80292f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802932:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802937:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802941:	a1 38 50 80 00       	mov    0x805038,%eax
  802946:	40                   	inc    %eax
  802947:	a3 38 50 80 00       	mov    %eax,0x805038
  80294c:	e9 dc 00 00 00       	jmp    802a2d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	75 65                	jne    8029bf <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80295a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80295e:	75 17                	jne    802977 <alloc_block_BF+0x2ed>
  802960:	83 ec 04             	sub    $0x4,%esp
  802963:	68 c0 43 80 00       	push   $0x8043c0
  802968:	68 4a 01 00 00       	push   $0x14a
  80296d:	68 71 43 80 00       	push   $0x804371
  802972:	e8 70 0f 00 00       	call   8038e7 <_panic>
  802977:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80297d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802980:	89 50 04             	mov    %edx,0x4(%eax)
  802983:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0c                	je     802999 <alloc_block_BF+0x30f>
  80298d:	a1 30 50 80 00       	mov    0x805030,%eax
  802992:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	eb 08                	jmp    8029a1 <alloc_block_BF+0x317>
  802999:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b7:	40                   	inc    %eax
  8029b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8029bd:	eb 6e                	jmp    802a2d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c3:	74 06                	je     8029cb <alloc_block_BF+0x341>
  8029c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c9:	75 17                	jne    8029e2 <alloc_block_BF+0x358>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 e4 43 80 00       	push   $0x8043e4
  8029d3:	68 4f 01 00 00       	push   $0x14f
  8029d8:	68 71 43 80 00       	push   $0x804371
  8029dd:	e8 05 0f 00 00       	call   8038e7 <_panic>
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8b 10                	mov    (%eax),%edx
  8029e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ea:	89 10                	mov    %edx,(%eax)
  8029ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	74 0b                	je     802a00 <alloc_block_BF+0x376>
  8029f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f8:	8b 00                	mov    (%eax),%eax
  8029fa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029fd:	89 50 04             	mov    %edx,0x4(%eax)
  802a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a03:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	75 08                	jne    802a22 <alloc_block_BF+0x398>
  802a1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802a22:	a1 38 50 80 00       	mov    0x805038,%eax
  802a27:	40                   	inc    %eax
  802a28:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a31:	75 17                	jne    802a4a <alloc_block_BF+0x3c0>
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 53 43 80 00       	push   $0x804353
  802a3b:	68 51 01 00 00       	push   $0x151
  802a40:	68 71 43 80 00       	push   $0x804371
  802a45:	e8 9d 0e 00 00       	call   8038e7 <_panic>
  802a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	74 10                	je     802a63 <alloc_block_BF+0x3d9>
  802a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5b:	8b 52 04             	mov    0x4(%edx),%edx
  802a5e:	89 50 04             	mov    %edx,0x4(%eax)
  802a61:	eb 0b                	jmp    802a6e <alloc_block_BF+0x3e4>
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a71:	8b 40 04             	mov    0x4(%eax),%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	74 0f                	je     802a87 <alloc_block_BF+0x3fd>
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a81:	8b 12                	mov    (%edx),%edx
  802a83:	89 10                	mov    %edx,(%eax)
  802a85:	eb 0a                	jmp    802a91 <alloc_block_BF+0x407>
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa4:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa9:	48                   	dec    %eax
  802aaa:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802aaf:	83 ec 04             	sub    $0x4,%esp
  802ab2:	6a 00                	push   $0x0
  802ab4:	ff 75 d0             	pushl  -0x30(%ebp)
  802ab7:	ff 75 cc             	pushl  -0x34(%ebp)
  802aba:	e8 e0 f6 ff ff       	call   80219f <set_block_data>
  802abf:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	e9 a3 01 00 00       	jmp    802c6d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802aca:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ace:	0f 85 9d 00 00 00    	jne    802b71 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	6a 01                	push   $0x1
  802ad9:	ff 75 ec             	pushl  -0x14(%ebp)
  802adc:	ff 75 f0             	pushl  -0x10(%ebp)
  802adf:	e8 bb f6 ff ff       	call   80219f <set_block_data>
  802ae4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ae7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aeb:	75 17                	jne    802b04 <alloc_block_BF+0x47a>
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	68 53 43 80 00       	push   $0x804353
  802af5:	68 58 01 00 00       	push   $0x158
  802afa:	68 71 43 80 00       	push   $0x804371
  802aff:	e8 e3 0d 00 00       	call   8038e7 <_panic>
  802b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 10                	je     802b1d <alloc_block_BF+0x493>
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b15:	8b 52 04             	mov    0x4(%edx),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 0b                	jmp    802b28 <alloc_block_BF+0x49e>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 40 04             	mov    0x4(%eax),%eax
  802b23:	a3 30 50 80 00       	mov    %eax,0x805030
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 0f                	je     802b41 <alloc_block_BF+0x4b7>
  802b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3b:	8b 12                	mov    (%edx),%edx
  802b3d:	89 10                	mov    %edx,(%eax)
  802b3f:	eb 0a                	jmp    802b4b <alloc_block_BF+0x4c1>
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b63:	48                   	dec    %eax
  802b64:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	e9 fc 00 00 00       	jmp    802c6d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	83 c0 08             	add    $0x8,%eax
  802b77:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b7a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b81:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b84:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b87:	01 d0                	add    %edx,%eax
  802b89:	48                   	dec    %eax
  802b8a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b90:	ba 00 00 00 00       	mov    $0x0,%edx
  802b95:	f7 75 c4             	divl   -0x3c(%ebp)
  802b98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b9b:	29 d0                	sub    %edx,%eax
  802b9d:	c1 e8 0c             	shr    $0xc,%eax
  802ba0:	83 ec 0c             	sub    $0xc,%esp
  802ba3:	50                   	push   %eax
  802ba4:	e8 5a e7 ff ff       	call   801303 <sbrk>
  802ba9:	83 c4 10             	add    $0x10,%esp
  802bac:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802baf:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bb3:	75 0a                	jne    802bbf <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bba:	e9 ae 00 00 00       	jmp    802c6d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bbf:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bc6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bc9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bcc:	01 d0                	add    %edx,%eax
  802bce:	48                   	dec    %eax
  802bcf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bd2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802bda:	f7 75 b8             	divl   -0x48(%ebp)
  802bdd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802be0:	29 d0                	sub    %edx,%eax
  802be2:	8d 50 fc             	lea    -0x4(%eax),%edx
  802be5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802be8:	01 d0                	add    %edx,%eax
  802bea:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bef:	a1 40 50 80 00       	mov    0x805040,%eax
  802bf4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bfa:	83 ec 0c             	sub    $0xc,%esp
  802bfd:	68 18 44 80 00       	push   $0x804418
  802c02:	e8 62 d9 ff ff       	call   800569 <cprintf>
  802c07:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c0a:	83 ec 08             	sub    $0x8,%esp
  802c0d:	ff 75 bc             	pushl  -0x44(%ebp)
  802c10:	68 1d 44 80 00       	push   $0x80441d
  802c15:	e8 4f d9 ff ff       	call   800569 <cprintf>
  802c1a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c1d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c24:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2a:	01 d0                	add    %edx,%eax
  802c2c:	48                   	dec    %eax
  802c2d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c30:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c33:	ba 00 00 00 00       	mov    $0x0,%edx
  802c38:	f7 75 b0             	divl   -0x50(%ebp)
  802c3b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c3e:	29 d0                	sub    %edx,%eax
  802c40:	83 ec 04             	sub    $0x4,%esp
  802c43:	6a 01                	push   $0x1
  802c45:	50                   	push   %eax
  802c46:	ff 75 bc             	pushl  -0x44(%ebp)
  802c49:	e8 51 f5 ff ff       	call   80219f <set_block_data>
  802c4e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c51:	83 ec 0c             	sub    $0xc,%esp
  802c54:	ff 75 bc             	pushl  -0x44(%ebp)
  802c57:	e8 36 04 00 00       	call   803092 <free_block>
  802c5c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c5f:	83 ec 0c             	sub    $0xc,%esp
  802c62:	ff 75 08             	pushl  0x8(%ebp)
  802c65:	e8 20 fa ff ff       	call   80268a <alloc_block_BF>
  802c6a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
  802c72:	53                   	push   %ebx
  802c73:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c88:	74 1e                	je     802ca8 <merging+0x39>
  802c8a:	ff 75 08             	pushl  0x8(%ebp)
  802c8d:	e8 bc f1 ff ff       	call   801e4e <get_block_size>
  802c92:	83 c4 04             	add    $0x4,%esp
  802c95:	89 c2                	mov    %eax,%edx
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	01 d0                	add    %edx,%eax
  802c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c9f:	75 07                	jne    802ca8 <merging+0x39>
		prev_is_free = 1;
  802ca1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ca8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cac:	74 1e                	je     802ccc <merging+0x5d>
  802cae:	ff 75 10             	pushl  0x10(%ebp)
  802cb1:	e8 98 f1 ff ff       	call   801e4e <get_block_size>
  802cb6:	83 c4 04             	add    $0x4,%esp
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  802cbe:	01 d0                	add    %edx,%eax
  802cc0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cc3:	75 07                	jne    802ccc <merging+0x5d>
		next_is_free = 1;
  802cc5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd0:	0f 84 cc 00 00 00    	je     802da2 <merging+0x133>
  802cd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cda:	0f 84 c2 00 00 00    	je     802da2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ce0:	ff 75 08             	pushl  0x8(%ebp)
  802ce3:	e8 66 f1 ff ff       	call   801e4e <get_block_size>
  802ce8:	83 c4 04             	add    $0x4,%esp
  802ceb:	89 c3                	mov    %eax,%ebx
  802ced:	ff 75 10             	pushl  0x10(%ebp)
  802cf0:	e8 59 f1 ff ff       	call   801e4e <get_block_size>
  802cf5:	83 c4 04             	add    $0x4,%esp
  802cf8:	01 c3                	add    %eax,%ebx
  802cfa:	ff 75 0c             	pushl  0xc(%ebp)
  802cfd:	e8 4c f1 ff ff       	call   801e4e <get_block_size>
  802d02:	83 c4 04             	add    $0x4,%esp
  802d05:	01 d8                	add    %ebx,%eax
  802d07:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d0a:	6a 00                	push   $0x0
  802d0c:	ff 75 ec             	pushl  -0x14(%ebp)
  802d0f:	ff 75 08             	pushl  0x8(%ebp)
  802d12:	e8 88 f4 ff ff       	call   80219f <set_block_data>
  802d17:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d1e:	75 17                	jne    802d37 <merging+0xc8>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 53 43 80 00       	push   $0x804353
  802d28:	68 7d 01 00 00       	push   $0x17d
  802d2d:	68 71 43 80 00       	push   $0x804371
  802d32:	e8 b0 0b 00 00       	call   8038e7 <_panic>
  802d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	74 10                	je     802d50 <merging+0xe1>
  802d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d48:	8b 52 04             	mov    0x4(%edx),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	eb 0b                	jmp    802d5b <merging+0xec>
  802d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d53:	8b 40 04             	mov    0x4(%eax),%eax
  802d56:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 0f                	je     802d74 <merging+0x105>
  802d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d6e:	8b 12                	mov    (%edx),%edx
  802d70:	89 10                	mov    %edx,(%eax)
  802d72:	eb 0a                	jmp    802d7e <merging+0x10f>
  802d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d91:	a1 38 50 80 00       	mov    0x805038,%eax
  802d96:	48                   	dec    %eax
  802d97:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d9c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d9d:	e9 ea 02 00 00       	jmp    80308c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da6:	74 3b                	je     802de3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802da8:	83 ec 0c             	sub    $0xc,%esp
  802dab:	ff 75 08             	pushl  0x8(%ebp)
  802dae:	e8 9b f0 ff ff       	call   801e4e <get_block_size>
  802db3:	83 c4 10             	add    $0x10,%esp
  802db6:	89 c3                	mov    %eax,%ebx
  802db8:	83 ec 0c             	sub    $0xc,%esp
  802dbb:	ff 75 10             	pushl  0x10(%ebp)
  802dbe:	e8 8b f0 ff ff       	call   801e4e <get_block_size>
  802dc3:	83 c4 10             	add    $0x10,%esp
  802dc6:	01 d8                	add    %ebx,%eax
  802dc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	6a 00                	push   $0x0
  802dd0:	ff 75 e8             	pushl  -0x18(%ebp)
  802dd3:	ff 75 08             	pushl  0x8(%ebp)
  802dd6:	e8 c4 f3 ff ff       	call   80219f <set_block_data>
  802ddb:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dde:	e9 a9 02 00 00       	jmp    80308c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802de3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de7:	0f 84 2d 01 00 00    	je     802f1a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ded:	83 ec 0c             	sub    $0xc,%esp
  802df0:	ff 75 10             	pushl  0x10(%ebp)
  802df3:	e8 56 f0 ff ff       	call   801e4e <get_block_size>
  802df8:	83 c4 10             	add    $0x10,%esp
  802dfb:	89 c3                	mov    %eax,%ebx
  802dfd:	83 ec 0c             	sub    $0xc,%esp
  802e00:	ff 75 0c             	pushl  0xc(%ebp)
  802e03:	e8 46 f0 ff ff       	call   801e4e <get_block_size>
  802e08:	83 c4 10             	add    $0x10,%esp
  802e0b:	01 d8                	add    %ebx,%eax
  802e0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e10:	83 ec 04             	sub    $0x4,%esp
  802e13:	6a 00                	push   $0x0
  802e15:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e18:	ff 75 10             	pushl  0x10(%ebp)
  802e1b:	e8 7f f3 ff ff       	call   80219f <set_block_data>
  802e20:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e23:	8b 45 10             	mov    0x10(%ebp),%eax
  802e26:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e2d:	74 06                	je     802e35 <merging+0x1c6>
  802e2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e33:	75 17                	jne    802e4c <merging+0x1dd>
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	68 2c 44 80 00       	push   $0x80442c
  802e3d:	68 8d 01 00 00       	push   $0x18d
  802e42:	68 71 43 80 00       	push   $0x804371
  802e47:	e8 9b 0a 00 00       	call   8038e7 <_panic>
  802e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4f:	8b 50 04             	mov    0x4(%eax),%edx
  802e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e55:	89 50 04             	mov    %edx,0x4(%eax)
  802e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5e:	89 10                	mov    %edx,(%eax)
  802e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e63:	8b 40 04             	mov    0x4(%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 0d                	je     802e77 <merging+0x208>
  802e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e73:	89 10                	mov    %edx,(%eax)
  802e75:	eb 08                	jmp    802e7f <merging+0x210>
  802e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e85:	89 50 04             	mov    %edx,0x4(%eax)
  802e88:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8d:	40                   	inc    %eax
  802e8e:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e97:	75 17                	jne    802eb0 <merging+0x241>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 53 43 80 00       	push   $0x804353
  802ea1:	68 8e 01 00 00       	push   $0x18e
  802ea6:	68 71 43 80 00       	push   $0x804371
  802eab:	e8 37 0a 00 00       	call   8038e7 <_panic>
  802eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 10                	je     802ec9 <merging+0x25a>
  802eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec1:	8b 52 04             	mov    0x4(%edx),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 0b                	jmp    802ed4 <merging+0x265>
  802ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0f                	je     802eed <merging+0x27e>
  802ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee1:	8b 40 04             	mov    0x4(%eax),%eax
  802ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee7:	8b 12                	mov    (%edx),%edx
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	eb 0a                	jmp    802ef7 <merging+0x288>
  802eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f0f:	48                   	dec    %eax
  802f10:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f15:	e9 72 01 00 00       	jmp    80308c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f24:	74 79                	je     802f9f <merging+0x330>
  802f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2a:	74 73                	je     802f9f <merging+0x330>
  802f2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f30:	74 06                	je     802f38 <merging+0x2c9>
  802f32:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f36:	75 17                	jne    802f4f <merging+0x2e0>
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	68 e4 43 80 00       	push   $0x8043e4
  802f40:	68 94 01 00 00       	push   $0x194
  802f45:	68 71 43 80 00       	push   $0x804371
  802f4a:	e8 98 09 00 00       	call   8038e7 <_panic>
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 10                	mov    (%eax),%edx
  802f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0b                	je     802f6d <merging+0x2fe>
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f6a:	89 50 04             	mov    %edx,0x4(%eax)
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f73:	89 10                	mov    %edx,(%eax)
  802f75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f78:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7b:	89 50 04             	mov    %edx,0x4(%eax)
  802f7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	75 08                	jne    802f8f <merging+0x320>
  802f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802f8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f94:	40                   	inc    %eax
  802f95:	a3 38 50 80 00       	mov    %eax,0x805038
  802f9a:	e9 ce 00 00 00       	jmp    80306d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa3:	74 65                	je     80300a <merging+0x39b>
  802fa5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fa9:	75 17                	jne    802fc2 <merging+0x353>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 c0 43 80 00       	push   $0x8043c0
  802fb3:	68 95 01 00 00       	push   $0x195
  802fb8:	68 71 43 80 00       	push   $0x804371
  802fbd:	e8 25 09 00 00       	call   8038e7 <_panic>
  802fc2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcb:	89 50 04             	mov    %edx,0x4(%eax)
  802fce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0c                	je     802fe4 <merging+0x375>
  802fd8:	a1 30 50 80 00       	mov    0x805030,%eax
  802fdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fe0:	89 10                	mov    %edx,(%eax)
  802fe2:	eb 08                	jmp    802fec <merging+0x37d>
  802fe4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fef:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffd:	a1 38 50 80 00       	mov    0x805038,%eax
  803002:	40                   	inc    %eax
  803003:	a3 38 50 80 00       	mov    %eax,0x805038
  803008:	eb 63                	jmp    80306d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80300a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80300e:	75 17                	jne    803027 <merging+0x3b8>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 8c 43 80 00       	push   $0x80438c
  803018:	68 98 01 00 00       	push   $0x198
  80301d:	68 71 43 80 00       	push   $0x804371
  803022:	e8 c0 08 00 00       	call   8038e7 <_panic>
  803027:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80302d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803030:	89 10                	mov    %edx,(%eax)
  803032:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	74 0d                	je     803048 <merging+0x3d9>
  80303b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803040:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803043:	89 50 04             	mov    %edx,0x4(%eax)
  803046:	eb 08                	jmp    803050 <merging+0x3e1>
  803048:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304b:	a3 30 50 80 00       	mov    %eax,0x805030
  803050:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803053:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803058:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803062:	a1 38 50 80 00       	mov    0x805038,%eax
  803067:	40                   	inc    %eax
  803068:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	ff 75 10             	pushl  0x10(%ebp)
  803073:	e8 d6 ed ff ff       	call   801e4e <get_block_size>
  803078:	83 c4 10             	add    $0x10,%esp
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	6a 00                	push   $0x0
  803080:	50                   	push   %eax
  803081:	ff 75 10             	pushl  0x10(%ebp)
  803084:	e8 16 f1 ff ff       	call   80219f <set_block_data>
  803089:	83 c4 10             	add    $0x10,%esp
	}
}
  80308c:	90                   	nop
  80308d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803098:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80309d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030a0:	a1 30 50 80 00       	mov    0x805030,%eax
  8030a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a8:	73 1b                	jae    8030c5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030aa:	a1 30 50 80 00       	mov    0x805030,%eax
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	ff 75 08             	pushl  0x8(%ebp)
  8030b5:	6a 00                	push   $0x0
  8030b7:	50                   	push   %eax
  8030b8:	e8 b2 fb ff ff       	call   802c6f <merging>
  8030bd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030c0:	e9 8b 00 00 00       	jmp    803150 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030cd:	76 18                	jbe    8030e7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	ff 75 08             	pushl  0x8(%ebp)
  8030da:	50                   	push   %eax
  8030db:	6a 00                	push   $0x0
  8030dd:	e8 8d fb ff ff       	call   802c6f <merging>
  8030e2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030e5:	eb 69                	jmp    803150 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ef:	eb 39                	jmp    80312a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f7:	73 29                	jae    803122 <free_block+0x90>
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803101:	76 1f                	jbe    803122 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	ff 75 08             	pushl  0x8(%ebp)
  803111:	ff 75 f0             	pushl  -0x10(%ebp)
  803114:	ff 75 f4             	pushl  -0xc(%ebp)
  803117:	e8 53 fb ff ff       	call   802c6f <merging>
  80311c:	83 c4 10             	add    $0x10,%esp
			break;
  80311f:	90                   	nop
		}
	}
}
  803120:	eb 2e                	jmp    803150 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803122:	a1 34 50 80 00       	mov    0x805034,%eax
  803127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312e:	74 07                	je     803137 <free_block+0xa5>
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	eb 05                	jmp    80313c <free_block+0xaa>
  803137:	b8 00 00 00 00       	mov    $0x0,%eax
  80313c:	a3 34 50 80 00       	mov    %eax,0x805034
  803141:	a1 34 50 80 00       	mov    0x805034,%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	75 a7                	jne    8030f1 <free_block+0x5f>
  80314a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314e:	75 a1                	jne    8030f1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803150:	90                   	nop
  803151:	c9                   	leave  
  803152:	c3                   	ret    

00803153 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803153:	55                   	push   %ebp
  803154:	89 e5                	mov    %esp,%ebp
  803156:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803159:	ff 75 08             	pushl  0x8(%ebp)
  80315c:	e8 ed ec ff ff       	call   801e4e <get_block_size>
  803161:	83 c4 04             	add    $0x4,%esp
  803164:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80316e:	eb 17                	jmp    803187 <copy_data+0x34>
  803170:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803173:	8b 45 0c             	mov    0xc(%ebp),%eax
  803176:	01 c2                	add    %eax,%edx
  803178:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	01 c8                	add    %ecx,%eax
  803180:	8a 00                	mov    (%eax),%al
  803182:	88 02                	mov    %al,(%edx)
  803184:	ff 45 fc             	incl   -0x4(%ebp)
  803187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80318a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80318d:	72 e1                	jb     803170 <copy_data+0x1d>
}
  80318f:	90                   	nop
  803190:	c9                   	leave  
  803191:	c3                   	ret    

00803192 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803192:	55                   	push   %ebp
  803193:	89 e5                	mov    %esp,%ebp
  803195:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319c:	75 23                	jne    8031c1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80319e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a2:	74 13                	je     8031b7 <realloc_block_FF+0x25>
  8031a4:	83 ec 0c             	sub    $0xc,%esp
  8031a7:	ff 75 0c             	pushl  0xc(%ebp)
  8031aa:	e8 1f f0 ff ff       	call   8021ce <alloc_block_FF>
  8031af:	83 c4 10             	add    $0x10,%esp
  8031b2:	e9 f4 06 00 00       	jmp    8038ab <realloc_block_FF+0x719>
		return NULL;
  8031b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bc:	e9 ea 06 00 00       	jmp    8038ab <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031c5:	75 18                	jne    8031df <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031c7:	83 ec 0c             	sub    $0xc,%esp
  8031ca:	ff 75 08             	pushl  0x8(%ebp)
  8031cd:	e8 c0 fe ff ff       	call   803092 <free_block>
  8031d2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031da:	e9 cc 06 00 00       	jmp    8038ab <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031df:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031e3:	77 07                	ja     8031ec <realloc_block_FF+0x5a>
  8031e5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ef:	83 e0 01             	and    $0x1,%eax
  8031f2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f8:	83 c0 08             	add    $0x8,%eax
  8031fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031fe:	83 ec 0c             	sub    $0xc,%esp
  803201:	ff 75 08             	pushl  0x8(%ebp)
  803204:	e8 45 ec ff ff       	call   801e4e <get_block_size>
  803209:	83 c4 10             	add    $0x10,%esp
  80320c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80320f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803212:	83 e8 08             	sub    $0x8,%eax
  803215:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	83 e8 04             	sub    $0x4,%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	83 e0 fe             	and    $0xfffffffe,%eax
  803223:	89 c2                	mov    %eax,%edx
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	01 d0                	add    %edx,%eax
  80322a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80322d:	83 ec 0c             	sub    $0xc,%esp
  803230:	ff 75 e4             	pushl  -0x1c(%ebp)
  803233:	e8 16 ec ff ff       	call   801e4e <get_block_size>
  803238:	83 c4 10             	add    $0x10,%esp
  80323b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80323e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803241:	83 e8 08             	sub    $0x8,%eax
  803244:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80324d:	75 08                	jne    803257 <realloc_block_FF+0xc5>
	{
		 return va;
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	e9 54 06 00 00       	jmp    8038ab <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80325d:	0f 83 e5 03 00 00    	jae    803648 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	2b 45 0c             	sub    0xc(%ebp),%eax
  803269:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80326c:	83 ec 0c             	sub    $0xc,%esp
  80326f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803272:	e8 f0 eb ff ff       	call   801e67 <is_free_block>
  803277:	83 c4 10             	add    $0x10,%esp
  80327a:	84 c0                	test   %al,%al
  80327c:	0f 84 3b 01 00 00    	je     8033bd <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803282:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803285:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803288:	01 d0                	add    %edx,%eax
  80328a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	6a 01                	push   $0x1
  803292:	ff 75 f0             	pushl  -0x10(%ebp)
  803295:	ff 75 08             	pushl  0x8(%ebp)
  803298:	e8 02 ef ff ff       	call   80219f <set_block_data>
  80329d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	83 e8 04             	sub    $0x4,%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8032ab:	89 c2                	mov    %eax,%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	01 d0                	add    %edx,%eax
  8032b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	6a 00                	push   $0x0
  8032ba:	ff 75 cc             	pushl  -0x34(%ebp)
  8032bd:	ff 75 c8             	pushl  -0x38(%ebp)
  8032c0:	e8 da ee ff ff       	call   80219f <set_block_data>
  8032c5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032cc:	74 06                	je     8032d4 <realloc_block_FF+0x142>
  8032ce:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032d2:	75 17                	jne    8032eb <realloc_block_FF+0x159>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 e4 43 80 00       	push   $0x8043e4
  8032dc:	68 f6 01 00 00       	push   $0x1f6
  8032e1:	68 71 43 80 00       	push   $0x804371
  8032e6:	e8 fc 05 00 00       	call   8038e7 <_panic>
  8032eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ee:	8b 10                	mov    (%eax),%edx
  8032f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f3:	89 10                	mov    %edx,(%eax)
  8032f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	74 0b                	je     803309 <realloc_block_FF+0x177>
  8032fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803314:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803317:	89 50 04             	mov    %edx,0x4(%eax)
  80331a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	75 08                	jne    80332b <realloc_block_FF+0x199>
  803323:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803326:	a3 30 50 80 00       	mov    %eax,0x805030
  80332b:	a1 38 50 80 00       	mov    0x805038,%eax
  803330:	40                   	inc    %eax
  803331:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803336:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80333a:	75 17                	jne    803353 <realloc_block_FF+0x1c1>
  80333c:	83 ec 04             	sub    $0x4,%esp
  80333f:	68 53 43 80 00       	push   $0x804353
  803344:	68 f7 01 00 00       	push   $0x1f7
  803349:	68 71 43 80 00       	push   $0x804371
  80334e:	e8 94 05 00 00       	call   8038e7 <_panic>
  803353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	85 c0                	test   %eax,%eax
  80335a:	74 10                	je     80336c <realloc_block_FF+0x1da>
  80335c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803364:	8b 52 04             	mov    0x4(%edx),%edx
  803367:	89 50 04             	mov    %edx,0x4(%eax)
  80336a:	eb 0b                	jmp    803377 <realloc_block_FF+0x1e5>
  80336c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336f:	8b 40 04             	mov    0x4(%eax),%eax
  803372:	a3 30 50 80 00       	mov    %eax,0x805030
  803377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337a:	8b 40 04             	mov    0x4(%eax),%eax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	74 0f                	je     803390 <realloc_block_FF+0x1fe>
  803381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803384:	8b 40 04             	mov    0x4(%eax),%eax
  803387:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80338a:	8b 12                	mov    (%edx),%edx
  80338c:	89 10                	mov    %edx,(%eax)
  80338e:	eb 0a                	jmp    80339a <realloc_block_FF+0x208>
  803390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803393:	8b 00                	mov    (%eax),%eax
  803395:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80339a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8033b2:	48                   	dec    %eax
  8033b3:	a3 38 50 80 00       	mov    %eax,0x805038
  8033b8:	e9 83 02 00 00       	jmp    803640 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033bd:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033c1:	0f 86 69 02 00 00    	jbe    803630 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	6a 01                	push   $0x1
  8033cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8033cf:	ff 75 08             	pushl  0x8(%ebp)
  8033d2:	e8 c8 ed ff ff       	call   80219f <set_block_data>
  8033d7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	83 e8 04             	sub    $0x4,%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	83 e0 fe             	and    $0xfffffffe,%eax
  8033e5:	89 c2                	mov    %eax,%edx
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	01 d0                	add    %edx,%eax
  8033ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033f7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033fb:	75 68                	jne    803465 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803401:	75 17                	jne    80341a <realloc_block_FF+0x288>
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	68 8c 43 80 00       	push   $0x80438c
  80340b:	68 06 02 00 00       	push   $0x206
  803410:	68 71 43 80 00       	push   $0x804371
  803415:	e8 cd 04 00 00       	call   8038e7 <_panic>
  80341a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803420:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803423:	89 10                	mov    %edx,(%eax)
  803425:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	74 0d                	je     80343b <realloc_block_FF+0x2a9>
  80342e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803433:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803436:	89 50 04             	mov    %edx,0x4(%eax)
  803439:	eb 08                	jmp    803443 <realloc_block_FF+0x2b1>
  80343b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343e:	a3 30 50 80 00       	mov    %eax,0x805030
  803443:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803446:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803455:	a1 38 50 80 00       	mov    0x805038,%eax
  80345a:	40                   	inc    %eax
  80345b:	a3 38 50 80 00       	mov    %eax,0x805038
  803460:	e9 b0 01 00 00       	jmp    803615 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803465:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80346a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80346d:	76 68                	jbe    8034d7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80346f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803473:	75 17                	jne    80348c <realloc_block_FF+0x2fa>
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 8c 43 80 00       	push   $0x80438c
  80347d:	68 0b 02 00 00       	push   $0x20b
  803482:	68 71 43 80 00       	push   $0x804371
  803487:	e8 5b 04 00 00       	call   8038e7 <_panic>
  80348c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803492:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803495:	89 10                	mov    %edx,(%eax)
  803497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 0d                	je     8034ad <realloc_block_FF+0x31b>
  8034a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034a8:	89 50 04             	mov    %edx,0x4(%eax)
  8034ab:	eb 08                	jmp    8034b5 <realloc_block_FF+0x323>
  8034ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 38 50 80 00       	mov    %eax,0x805038
  8034d2:	e9 3e 01 00 00       	jmp    803615 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034df:	73 68                	jae    803549 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034e5:	75 17                	jne    8034fe <realloc_block_FF+0x36c>
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	68 c0 43 80 00       	push   $0x8043c0
  8034ef:	68 10 02 00 00       	push   $0x210
  8034f4:	68 71 43 80 00       	push   $0x804371
  8034f9:	e8 e9 03 00 00       	call   8038e7 <_panic>
  8034fe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803504:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803507:	89 50 04             	mov    %edx,0x4(%eax)
  80350a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350d:	8b 40 04             	mov    0x4(%eax),%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	74 0c                	je     803520 <realloc_block_FF+0x38e>
  803514:	a1 30 50 80 00       	mov    0x805030,%eax
  803519:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80351c:	89 10                	mov    %edx,(%eax)
  80351e:	eb 08                	jmp    803528 <realloc_block_FF+0x396>
  803520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803523:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352b:	a3 30 50 80 00       	mov    %eax,0x805030
  803530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803539:	a1 38 50 80 00       	mov    0x805038,%eax
  80353e:	40                   	inc    %eax
  80353f:	a3 38 50 80 00       	mov    %eax,0x805038
  803544:	e9 cc 00 00 00       	jmp    803615 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803550:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803558:	e9 8a 00 00 00       	jmp    8035e7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803563:	73 7a                	jae    8035df <realloc_block_FF+0x44d>
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	8b 00                	mov    (%eax),%eax
  80356a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80356d:	73 70                	jae    8035df <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80356f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803573:	74 06                	je     80357b <realloc_block_FF+0x3e9>
  803575:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803579:	75 17                	jne    803592 <realloc_block_FF+0x400>
  80357b:	83 ec 04             	sub    $0x4,%esp
  80357e:	68 e4 43 80 00       	push   $0x8043e4
  803583:	68 1a 02 00 00       	push   $0x21a
  803588:	68 71 43 80 00       	push   $0x804371
  80358d:	e8 55 03 00 00       	call   8038e7 <_panic>
  803592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803595:	8b 10                	mov    (%eax),%edx
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	89 10                	mov    %edx,(%eax)
  80359c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359f:	8b 00                	mov    (%eax),%eax
  8035a1:	85 c0                	test   %eax,%eax
  8035a3:	74 0b                	je     8035b0 <realloc_block_FF+0x41e>
  8035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a8:	8b 00                	mov    (%eax),%eax
  8035aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ad:	89 50 04             	mov    %edx,0x4(%eax)
  8035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035b6:	89 10                	mov    %edx,(%eax)
  8035b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035be:	89 50 04             	mov    %edx,0x4(%eax)
  8035c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	75 08                	jne    8035d2 <realloc_block_FF+0x440>
  8035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d7:	40                   	inc    %eax
  8035d8:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035dd:	eb 36                	jmp    803615 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035df:	a1 34 50 80 00       	mov    0x805034,%eax
  8035e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035eb:	74 07                	je     8035f4 <realloc_block_FF+0x462>
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	eb 05                	jmp    8035f9 <realloc_block_FF+0x467>
  8035f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f9:	a3 34 50 80 00       	mov    %eax,0x805034
  8035fe:	a1 34 50 80 00       	mov    0x805034,%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	0f 85 52 ff ff ff    	jne    80355d <realloc_block_FF+0x3cb>
  80360b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360f:	0f 85 48 ff ff ff    	jne    80355d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803615:	83 ec 04             	sub    $0x4,%esp
  803618:	6a 00                	push   $0x0
  80361a:	ff 75 d8             	pushl  -0x28(%ebp)
  80361d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803620:	e8 7a eb ff ff       	call   80219f <set_block_data>
  803625:	83 c4 10             	add    $0x10,%esp
				return va;
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	e9 7b 02 00 00       	jmp    8038ab <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803630:	83 ec 0c             	sub    $0xc,%esp
  803633:	68 61 44 80 00       	push   $0x804461
  803638:	e8 2c cf ff ff       	call   800569 <cprintf>
  80363d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	e9 63 02 00 00       	jmp    8038ab <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80364e:	0f 86 4d 02 00 00    	jbe    8038a1 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803654:	83 ec 0c             	sub    $0xc,%esp
  803657:	ff 75 e4             	pushl  -0x1c(%ebp)
  80365a:	e8 08 e8 ff ff       	call   801e67 <is_free_block>
  80365f:	83 c4 10             	add    $0x10,%esp
  803662:	84 c0                	test   %al,%al
  803664:	0f 84 37 02 00 00    	je     8038a1 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803670:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803673:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803676:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803679:	76 38                	jbe    8036b3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80367b:	83 ec 0c             	sub    $0xc,%esp
  80367e:	ff 75 08             	pushl  0x8(%ebp)
  803681:	e8 0c fa ff ff       	call   803092 <free_block>
  803686:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803689:	83 ec 0c             	sub    $0xc,%esp
  80368c:	ff 75 0c             	pushl  0xc(%ebp)
  80368f:	e8 3a eb ff ff       	call   8021ce <alloc_block_FF>
  803694:	83 c4 10             	add    $0x10,%esp
  803697:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80369a:	83 ec 08             	sub    $0x8,%esp
  80369d:	ff 75 c0             	pushl  -0x40(%ebp)
  8036a0:	ff 75 08             	pushl  0x8(%ebp)
  8036a3:	e8 ab fa ff ff       	call   803153 <copy_data>
  8036a8:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036ae:	e9 f8 01 00 00       	jmp    8038ab <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036bc:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036c0:	0f 87 a0 00 00 00    	ja     803766 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ca:	75 17                	jne    8036e3 <realloc_block_FF+0x551>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 53 43 80 00       	push   $0x804353
  8036d4:	68 38 02 00 00       	push   $0x238
  8036d9:	68 71 43 80 00       	push   $0x804371
  8036de:	e8 04 02 00 00       	call   8038e7 <_panic>
  8036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 10                	je     8036fc <realloc_block_FF+0x56a>
  8036ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ef:	8b 00                	mov    (%eax),%eax
  8036f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f4:	8b 52 04             	mov    0x4(%edx),%edx
  8036f7:	89 50 04             	mov    %edx,0x4(%eax)
  8036fa:	eb 0b                	jmp    803707 <realloc_block_FF+0x575>
  8036fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ff:	8b 40 04             	mov    0x4(%eax),%eax
  803702:	a3 30 50 80 00       	mov    %eax,0x805030
  803707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370a:	8b 40 04             	mov    0x4(%eax),%eax
  80370d:	85 c0                	test   %eax,%eax
  80370f:	74 0f                	je     803720 <realloc_block_FF+0x58e>
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	8b 40 04             	mov    0x4(%eax),%eax
  803717:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80371a:	8b 12                	mov    (%edx),%edx
  80371c:	89 10                	mov    %edx,(%eax)
  80371e:	eb 0a                	jmp    80372a <realloc_block_FF+0x598>
  803720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803723:	8b 00                	mov    (%eax),%eax
  803725:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373d:	a1 38 50 80 00       	mov    0x805038,%eax
  803742:	48                   	dec    %eax
  803743:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803748:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374e:	01 d0                	add    %edx,%eax
  803750:	83 ec 04             	sub    $0x4,%esp
  803753:	6a 01                	push   $0x1
  803755:	50                   	push   %eax
  803756:	ff 75 08             	pushl  0x8(%ebp)
  803759:	e8 41 ea ff ff       	call   80219f <set_block_data>
  80375e:	83 c4 10             	add    $0x10,%esp
  803761:	e9 36 01 00 00       	jmp    80389c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803766:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803769:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80376c:	01 d0                	add    %edx,%eax
  80376e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	6a 01                	push   $0x1
  803776:	ff 75 f0             	pushl  -0x10(%ebp)
  803779:	ff 75 08             	pushl  0x8(%ebp)
  80377c:	e8 1e ea ff ff       	call   80219f <set_block_data>
  803781:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	83 e8 04             	sub    $0x4,%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	83 e0 fe             	and    $0xfffffffe,%eax
  80378f:	89 c2                	mov    %eax,%edx
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	01 d0                	add    %edx,%eax
  803796:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803799:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80379d:	74 06                	je     8037a5 <realloc_block_FF+0x613>
  80379f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037a3:	75 17                	jne    8037bc <realloc_block_FF+0x62a>
  8037a5:	83 ec 04             	sub    $0x4,%esp
  8037a8:	68 e4 43 80 00       	push   $0x8043e4
  8037ad:	68 44 02 00 00       	push   $0x244
  8037b2:	68 71 43 80 00       	push   $0x804371
  8037b7:	e8 2b 01 00 00       	call   8038e7 <_panic>
  8037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bf:	8b 10                	mov    (%eax),%edx
  8037c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c4:	89 10                	mov    %edx,(%eax)
  8037c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c9:	8b 00                	mov    (%eax),%eax
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	74 0b                	je     8037da <realloc_block_FF+0x648>
  8037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037d7:	89 50 04             	mov    %edx,0x4(%eax)
  8037da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037e0:	89 10                	mov    %edx,(%eax)
  8037e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e8:	89 50 04             	mov    %edx,0x4(%eax)
  8037eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	75 08                	jne    8037fc <realloc_block_FF+0x66a>
  8037f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803801:	40                   	inc    %eax
  803802:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80380b:	75 17                	jne    803824 <realloc_block_FF+0x692>
  80380d:	83 ec 04             	sub    $0x4,%esp
  803810:	68 53 43 80 00       	push   $0x804353
  803815:	68 45 02 00 00       	push   $0x245
  80381a:	68 71 43 80 00       	push   $0x804371
  80381f:	e8 c3 00 00 00       	call   8038e7 <_panic>
  803824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803827:	8b 00                	mov    (%eax),%eax
  803829:	85 c0                	test   %eax,%eax
  80382b:	74 10                	je     80383d <realloc_block_FF+0x6ab>
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 00                	mov    (%eax),%eax
  803832:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803835:	8b 52 04             	mov    0x4(%edx),%edx
  803838:	89 50 04             	mov    %edx,0x4(%eax)
  80383b:	eb 0b                	jmp    803848 <realloc_block_FF+0x6b6>
  80383d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803840:	8b 40 04             	mov    0x4(%eax),%eax
  803843:	a3 30 50 80 00       	mov    %eax,0x805030
  803848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	85 c0                	test   %eax,%eax
  803850:	74 0f                	je     803861 <realloc_block_FF+0x6cf>
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	8b 40 04             	mov    0x4(%eax),%eax
  803858:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385b:	8b 12                	mov    (%edx),%edx
  80385d:	89 10                	mov    %edx,(%eax)
  80385f:	eb 0a                	jmp    80386b <realloc_block_FF+0x6d9>
  803861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803877:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387e:	a1 38 50 80 00       	mov    0x805038,%eax
  803883:	48                   	dec    %eax
  803884:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	6a 00                	push   $0x0
  80388e:	ff 75 bc             	pushl  -0x44(%ebp)
  803891:	ff 75 b8             	pushl  -0x48(%ebp)
  803894:	e8 06 e9 ff ff       	call   80219f <set_block_data>
  803899:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	eb 0a                	jmp    8038ab <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038a1:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038ab:	c9                   	leave  
  8038ac:	c3                   	ret    

008038ad <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038ad:	55                   	push   %ebp
  8038ae:	89 e5                	mov    %esp,%ebp
  8038b0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038b3:	83 ec 04             	sub    $0x4,%esp
  8038b6:	68 68 44 80 00       	push   $0x804468
  8038bb:	68 58 02 00 00       	push   $0x258
  8038c0:	68 71 43 80 00       	push   $0x804371
  8038c5:	e8 1d 00 00 00       	call   8038e7 <_panic>

008038ca <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038ca:	55                   	push   %ebp
  8038cb:	89 e5                	mov    %esp,%ebp
  8038cd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 90 44 80 00       	push   $0x804490
  8038d8:	68 61 02 00 00       	push   $0x261
  8038dd:	68 71 43 80 00       	push   $0x804371
  8038e2:	e8 00 00 00 00       	call   8038e7 <_panic>

008038e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8038e7:	55                   	push   %ebp
  8038e8:	89 e5                	mov    %esp,%ebp
  8038ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8038f0:	83 c0 04             	add    $0x4,%eax
  8038f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8038f6:	a1 60 50 98 00       	mov    0x985060,%eax
  8038fb:	85 c0                	test   %eax,%eax
  8038fd:	74 16                	je     803915 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8038ff:	a1 60 50 98 00       	mov    0x985060,%eax
  803904:	83 ec 08             	sub    $0x8,%esp
  803907:	50                   	push   %eax
  803908:	68 b8 44 80 00       	push   $0x8044b8
  80390d:	e8 57 cc ff ff       	call   800569 <cprintf>
  803912:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803915:	a1 00 50 80 00       	mov    0x805000,%eax
  80391a:	ff 75 0c             	pushl  0xc(%ebp)
  80391d:	ff 75 08             	pushl  0x8(%ebp)
  803920:	50                   	push   %eax
  803921:	68 bd 44 80 00       	push   $0x8044bd
  803926:	e8 3e cc ff ff       	call   800569 <cprintf>
  80392b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80392e:	8b 45 10             	mov    0x10(%ebp),%eax
  803931:	83 ec 08             	sub    $0x8,%esp
  803934:	ff 75 f4             	pushl  -0xc(%ebp)
  803937:	50                   	push   %eax
  803938:	e8 c1 cb ff ff       	call   8004fe <vcprintf>
  80393d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803940:	83 ec 08             	sub    $0x8,%esp
  803943:	6a 00                	push   $0x0
  803945:	68 d9 44 80 00       	push   $0x8044d9
  80394a:	e8 af cb ff ff       	call   8004fe <vcprintf>
  80394f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803952:	e8 30 cb ff ff       	call   800487 <exit>

	// should not return here
	while (1) ;
  803957:	eb fe                	jmp    803957 <_panic+0x70>

00803959 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803959:	55                   	push   %ebp
  80395a:	89 e5                	mov    %esp,%ebp
  80395c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80395f:	a1 20 50 80 00       	mov    0x805020,%eax
  803964:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80396a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396d:	39 c2                	cmp    %eax,%edx
  80396f:	74 14                	je     803985 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803971:	83 ec 04             	sub    $0x4,%esp
  803974:	68 dc 44 80 00       	push   $0x8044dc
  803979:	6a 26                	push   $0x26
  80397b:	68 28 45 80 00       	push   $0x804528
  803980:	e8 62 ff ff ff       	call   8038e7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80398c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803993:	e9 c5 00 00 00       	jmp    803a5d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a5:	01 d0                	add    %edx,%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	75 08                	jne    8039b5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039ad:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039b0:	e9 a5 00 00 00       	jmp    803a5a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039c3:	eb 69                	jmp    803a2e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ca:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d3:	89 d0                	mov    %edx,%eax
  8039d5:	01 c0                	add    %eax,%eax
  8039d7:	01 d0                	add    %edx,%eax
  8039d9:	c1 e0 03             	shl    $0x3,%eax
  8039dc:	01 c8                	add    %ecx,%eax
  8039de:	8a 40 04             	mov    0x4(%eax),%al
  8039e1:	84 c0                	test   %al,%al
  8039e3:	75 46                	jne    803a2b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ea:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f3:	89 d0                	mov    %edx,%eax
  8039f5:	01 c0                	add    %eax,%eax
  8039f7:	01 d0                	add    %edx,%eax
  8039f9:	c1 e0 03             	shl    $0x3,%eax
  8039fc:	01 c8                	add    %ecx,%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a0b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a10:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a17:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1a:	01 c8                	add    %ecx,%eax
  803a1c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a1e:	39 c2                	cmp    %eax,%edx
  803a20:	75 09                	jne    803a2b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a22:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a29:	eb 15                	jmp    803a40 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a2b:	ff 45 e8             	incl   -0x18(%ebp)
  803a2e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a33:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3c:	39 c2                	cmp    %eax,%edx
  803a3e:	77 85                	ja     8039c5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a44:	75 14                	jne    803a5a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	68 34 45 80 00       	push   $0x804534
  803a4e:	6a 3a                	push   $0x3a
  803a50:	68 28 45 80 00       	push   $0x804528
  803a55:	e8 8d fe ff ff       	call   8038e7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a5a:	ff 45 f0             	incl   -0x10(%ebp)
  803a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a60:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a63:	0f 8c 2f ff ff ff    	jl     803998 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a70:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a77:	eb 26                	jmp    803a9f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a79:	a1 20 50 80 00       	mov    0x805020,%eax
  803a7e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a87:	89 d0                	mov    %edx,%eax
  803a89:	01 c0                	add    %eax,%eax
  803a8b:	01 d0                	add    %edx,%eax
  803a8d:	c1 e0 03             	shl    $0x3,%eax
  803a90:	01 c8                	add    %ecx,%eax
  803a92:	8a 40 04             	mov    0x4(%eax),%al
  803a95:	3c 01                	cmp    $0x1,%al
  803a97:	75 03                	jne    803a9c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a99:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a9c:	ff 45 e0             	incl   -0x20(%ebp)
  803a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  803aa4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aad:	39 c2                	cmp    %eax,%edx
  803aaf:	77 c8                	ja     803a79 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ab7:	74 14                	je     803acd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803ab9:	83 ec 04             	sub    $0x4,%esp
  803abc:	68 88 45 80 00       	push   $0x804588
  803ac1:	6a 44                	push   $0x44
  803ac3:	68 28 45 80 00       	push   $0x804528
  803ac8:	e8 1a fe ff ff       	call   8038e7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803acd:	90                   	nop
  803ace:	c9                   	leave  
  803acf:	c3                   	ret    

00803ad0 <__udivdi3>:
  803ad0:	55                   	push   %ebp
  803ad1:	57                   	push   %edi
  803ad2:	56                   	push   %esi
  803ad3:	53                   	push   %ebx
  803ad4:	83 ec 1c             	sub    $0x1c,%esp
  803ad7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803adb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803adf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ae3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ae7:	89 ca                	mov    %ecx,%edx
  803ae9:	89 f8                	mov    %edi,%eax
  803aeb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803aef:	85 f6                	test   %esi,%esi
  803af1:	75 2d                	jne    803b20 <__udivdi3+0x50>
  803af3:	39 cf                	cmp    %ecx,%edi
  803af5:	77 65                	ja     803b5c <__udivdi3+0x8c>
  803af7:	89 fd                	mov    %edi,%ebp
  803af9:	85 ff                	test   %edi,%edi
  803afb:	75 0b                	jne    803b08 <__udivdi3+0x38>
  803afd:	b8 01 00 00 00       	mov    $0x1,%eax
  803b02:	31 d2                	xor    %edx,%edx
  803b04:	f7 f7                	div    %edi
  803b06:	89 c5                	mov    %eax,%ebp
  803b08:	31 d2                	xor    %edx,%edx
  803b0a:	89 c8                	mov    %ecx,%eax
  803b0c:	f7 f5                	div    %ebp
  803b0e:	89 c1                	mov    %eax,%ecx
  803b10:	89 d8                	mov    %ebx,%eax
  803b12:	f7 f5                	div    %ebp
  803b14:	89 cf                	mov    %ecx,%edi
  803b16:	89 fa                	mov    %edi,%edx
  803b18:	83 c4 1c             	add    $0x1c,%esp
  803b1b:	5b                   	pop    %ebx
  803b1c:	5e                   	pop    %esi
  803b1d:	5f                   	pop    %edi
  803b1e:	5d                   	pop    %ebp
  803b1f:	c3                   	ret    
  803b20:	39 ce                	cmp    %ecx,%esi
  803b22:	77 28                	ja     803b4c <__udivdi3+0x7c>
  803b24:	0f bd fe             	bsr    %esi,%edi
  803b27:	83 f7 1f             	xor    $0x1f,%edi
  803b2a:	75 40                	jne    803b6c <__udivdi3+0x9c>
  803b2c:	39 ce                	cmp    %ecx,%esi
  803b2e:	72 0a                	jb     803b3a <__udivdi3+0x6a>
  803b30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b34:	0f 87 9e 00 00 00    	ja     803bd8 <__udivdi3+0x108>
  803b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b3f:	89 fa                	mov    %edi,%edx
  803b41:	83 c4 1c             	add    $0x1c,%esp
  803b44:	5b                   	pop    %ebx
  803b45:	5e                   	pop    %esi
  803b46:	5f                   	pop    %edi
  803b47:	5d                   	pop    %ebp
  803b48:	c3                   	ret    
  803b49:	8d 76 00             	lea    0x0(%esi),%esi
  803b4c:	31 ff                	xor    %edi,%edi
  803b4e:	31 c0                	xor    %eax,%eax
  803b50:	89 fa                	mov    %edi,%edx
  803b52:	83 c4 1c             	add    $0x1c,%esp
  803b55:	5b                   	pop    %ebx
  803b56:	5e                   	pop    %esi
  803b57:	5f                   	pop    %edi
  803b58:	5d                   	pop    %ebp
  803b59:	c3                   	ret    
  803b5a:	66 90                	xchg   %ax,%ax
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	f7 f7                	div    %edi
  803b60:	31 ff                	xor    %edi,%edi
  803b62:	89 fa                	mov    %edi,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b71:	89 eb                	mov    %ebp,%ebx
  803b73:	29 fb                	sub    %edi,%ebx
  803b75:	89 f9                	mov    %edi,%ecx
  803b77:	d3 e6                	shl    %cl,%esi
  803b79:	89 c5                	mov    %eax,%ebp
  803b7b:	88 d9                	mov    %bl,%cl
  803b7d:	d3 ed                	shr    %cl,%ebp
  803b7f:	89 e9                	mov    %ebp,%ecx
  803b81:	09 f1                	or     %esi,%ecx
  803b83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b87:	89 f9                	mov    %edi,%ecx
  803b89:	d3 e0                	shl    %cl,%eax
  803b8b:	89 c5                	mov    %eax,%ebp
  803b8d:	89 d6                	mov    %edx,%esi
  803b8f:	88 d9                	mov    %bl,%cl
  803b91:	d3 ee                	shr    %cl,%esi
  803b93:	89 f9                	mov    %edi,%ecx
  803b95:	d3 e2                	shl    %cl,%edx
  803b97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9b:	88 d9                	mov    %bl,%cl
  803b9d:	d3 e8                	shr    %cl,%eax
  803b9f:	09 c2                	or     %eax,%edx
  803ba1:	89 d0                	mov    %edx,%eax
  803ba3:	89 f2                	mov    %esi,%edx
  803ba5:	f7 74 24 0c          	divl   0xc(%esp)
  803ba9:	89 d6                	mov    %edx,%esi
  803bab:	89 c3                	mov    %eax,%ebx
  803bad:	f7 e5                	mul    %ebp
  803baf:	39 d6                	cmp    %edx,%esi
  803bb1:	72 19                	jb     803bcc <__udivdi3+0xfc>
  803bb3:	74 0b                	je     803bc0 <__udivdi3+0xf0>
  803bb5:	89 d8                	mov    %ebx,%eax
  803bb7:	31 ff                	xor    %edi,%edi
  803bb9:	e9 58 ff ff ff       	jmp    803b16 <__udivdi3+0x46>
  803bbe:	66 90                	xchg   %ax,%ax
  803bc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bc4:	89 f9                	mov    %edi,%ecx
  803bc6:	d3 e2                	shl    %cl,%edx
  803bc8:	39 c2                	cmp    %eax,%edx
  803bca:	73 e9                	jae    803bb5 <__udivdi3+0xe5>
  803bcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bcf:	31 ff                	xor    %edi,%edi
  803bd1:	e9 40 ff ff ff       	jmp    803b16 <__udivdi3+0x46>
  803bd6:	66 90                	xchg   %ax,%ax
  803bd8:	31 c0                	xor    %eax,%eax
  803bda:	e9 37 ff ff ff       	jmp    803b16 <__udivdi3+0x46>
  803bdf:	90                   	nop

00803be0 <__umoddi3>:
  803be0:	55                   	push   %ebp
  803be1:	57                   	push   %edi
  803be2:	56                   	push   %esi
  803be3:	53                   	push   %ebx
  803be4:	83 ec 1c             	sub    $0x1c,%esp
  803be7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803beb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bff:	89 f3                	mov    %esi,%ebx
  803c01:	89 fa                	mov    %edi,%edx
  803c03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c07:	89 34 24             	mov    %esi,(%esp)
  803c0a:	85 c0                	test   %eax,%eax
  803c0c:	75 1a                	jne    803c28 <__umoddi3+0x48>
  803c0e:	39 f7                	cmp    %esi,%edi
  803c10:	0f 86 a2 00 00 00    	jbe    803cb8 <__umoddi3+0xd8>
  803c16:	89 c8                	mov    %ecx,%eax
  803c18:	89 f2                	mov    %esi,%edx
  803c1a:	f7 f7                	div    %edi
  803c1c:	89 d0                	mov    %edx,%eax
  803c1e:	31 d2                	xor    %edx,%edx
  803c20:	83 c4 1c             	add    $0x1c,%esp
  803c23:	5b                   	pop    %ebx
  803c24:	5e                   	pop    %esi
  803c25:	5f                   	pop    %edi
  803c26:	5d                   	pop    %ebp
  803c27:	c3                   	ret    
  803c28:	39 f0                	cmp    %esi,%eax
  803c2a:	0f 87 ac 00 00 00    	ja     803cdc <__umoddi3+0xfc>
  803c30:	0f bd e8             	bsr    %eax,%ebp
  803c33:	83 f5 1f             	xor    $0x1f,%ebp
  803c36:	0f 84 ac 00 00 00    	je     803ce8 <__umoddi3+0x108>
  803c3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c41:	29 ef                	sub    %ebp,%edi
  803c43:	89 fe                	mov    %edi,%esi
  803c45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c49:	89 e9                	mov    %ebp,%ecx
  803c4b:	d3 e0                	shl    %cl,%eax
  803c4d:	89 d7                	mov    %edx,%edi
  803c4f:	89 f1                	mov    %esi,%ecx
  803c51:	d3 ef                	shr    %cl,%edi
  803c53:	09 c7                	or     %eax,%edi
  803c55:	89 e9                	mov    %ebp,%ecx
  803c57:	d3 e2                	shl    %cl,%edx
  803c59:	89 14 24             	mov    %edx,(%esp)
  803c5c:	89 d8                	mov    %ebx,%eax
  803c5e:	d3 e0                	shl    %cl,%eax
  803c60:	89 c2                	mov    %eax,%edx
  803c62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c66:	d3 e0                	shl    %cl,%eax
  803c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c70:	89 f1                	mov    %esi,%ecx
  803c72:	d3 e8                	shr    %cl,%eax
  803c74:	09 d0                	or     %edx,%eax
  803c76:	d3 eb                	shr    %cl,%ebx
  803c78:	89 da                	mov    %ebx,%edx
  803c7a:	f7 f7                	div    %edi
  803c7c:	89 d3                	mov    %edx,%ebx
  803c7e:	f7 24 24             	mull   (%esp)
  803c81:	89 c6                	mov    %eax,%esi
  803c83:	89 d1                	mov    %edx,%ecx
  803c85:	39 d3                	cmp    %edx,%ebx
  803c87:	0f 82 87 00 00 00    	jb     803d14 <__umoddi3+0x134>
  803c8d:	0f 84 91 00 00 00    	je     803d24 <__umoddi3+0x144>
  803c93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c97:	29 f2                	sub    %esi,%edx
  803c99:	19 cb                	sbb    %ecx,%ebx
  803c9b:	89 d8                	mov    %ebx,%eax
  803c9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca1:	d3 e0                	shl    %cl,%eax
  803ca3:	89 e9                	mov    %ebp,%ecx
  803ca5:	d3 ea                	shr    %cl,%edx
  803ca7:	09 d0                	or     %edx,%eax
  803ca9:	89 e9                	mov    %ebp,%ecx
  803cab:	d3 eb                	shr    %cl,%ebx
  803cad:	89 da                	mov    %ebx,%edx
  803caf:	83 c4 1c             	add    $0x1c,%esp
  803cb2:	5b                   	pop    %ebx
  803cb3:	5e                   	pop    %esi
  803cb4:	5f                   	pop    %edi
  803cb5:	5d                   	pop    %ebp
  803cb6:	c3                   	ret    
  803cb7:	90                   	nop
  803cb8:	89 fd                	mov    %edi,%ebp
  803cba:	85 ff                	test   %edi,%edi
  803cbc:	75 0b                	jne    803cc9 <__umoddi3+0xe9>
  803cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803cc3:	31 d2                	xor    %edx,%edx
  803cc5:	f7 f7                	div    %edi
  803cc7:	89 c5                	mov    %eax,%ebp
  803cc9:	89 f0                	mov    %esi,%eax
  803ccb:	31 d2                	xor    %edx,%edx
  803ccd:	f7 f5                	div    %ebp
  803ccf:	89 c8                	mov    %ecx,%eax
  803cd1:	f7 f5                	div    %ebp
  803cd3:	89 d0                	mov    %edx,%eax
  803cd5:	e9 44 ff ff ff       	jmp    803c1e <__umoddi3+0x3e>
  803cda:	66 90                	xchg   %ax,%ax
  803cdc:	89 c8                	mov    %ecx,%eax
  803cde:	89 f2                	mov    %esi,%edx
  803ce0:	83 c4 1c             	add    $0x1c,%esp
  803ce3:	5b                   	pop    %ebx
  803ce4:	5e                   	pop    %esi
  803ce5:	5f                   	pop    %edi
  803ce6:	5d                   	pop    %ebp
  803ce7:	c3                   	ret    
  803ce8:	3b 04 24             	cmp    (%esp),%eax
  803ceb:	72 06                	jb     803cf3 <__umoddi3+0x113>
  803ced:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf1:	77 0f                	ja     803d02 <__umoddi3+0x122>
  803cf3:	89 f2                	mov    %esi,%edx
  803cf5:	29 f9                	sub    %edi,%ecx
  803cf7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cfb:	89 14 24             	mov    %edx,(%esp)
  803cfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d06:	8b 14 24             	mov    (%esp),%edx
  803d09:	83 c4 1c             	add    $0x1c,%esp
  803d0c:	5b                   	pop    %ebx
  803d0d:	5e                   	pop    %esi
  803d0e:	5f                   	pop    %edi
  803d0f:	5d                   	pop    %ebp
  803d10:	c3                   	ret    
  803d11:	8d 76 00             	lea    0x0(%esi),%esi
  803d14:	2b 04 24             	sub    (%esp),%eax
  803d17:	19 fa                	sbb    %edi,%edx
  803d19:	89 d1                	mov    %edx,%ecx
  803d1b:	89 c6                	mov    %eax,%esi
  803d1d:	e9 71 ff ff ff       	jmp    803c93 <__umoddi3+0xb3>
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d28:	72 ea                	jb     803d14 <__umoddi3+0x134>
  803d2a:	89 d9                	mov    %ebx,%ecx
  803d2c:	e9 62 ff ff ff       	jmp    803c93 <__umoddi3+0xb3>
