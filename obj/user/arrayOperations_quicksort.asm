
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
  80003e:	e8 d5 1a 00 00       	call   801b18 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 ff 1a 00 00       	call   801b4a <sys_getparentenvid>
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
  80005f:	68 60 3d 80 00       	push   $0x803d60
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 82 16 00 00       	call   8016ee <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 64 3d 80 00       	push   $0x803d64
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 6c 16 00 00       	call   8016ee <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 6c 3d 80 00       	push   $0x803d6c
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
  8000b3:	68 7a 3d 80 00       	push   $0x803d7a
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
  800112:	68 89 3d 80 00       	push   $0x803d89
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
  800166:	e8 12 1a 00 00       	call   801b7d <sys_get_virtual_time>
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
  8002f6:	68 a5 3d 80 00       	push   $0x803da5
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
  800318:	68 a7 3d 80 00       	push   $0x803da7
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
  800346:	68 ac 3d 80 00       	push   $0x803dac
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
  80035c:	e8 d0 17 00 00       	call   801b31 <sys_getenvindex>
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
  8003ca:	e8 e6 14 00 00       	call   8018b5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	68 c8 3d 80 00       	push   $0x803dc8
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
  8003fa:	68 f0 3d 80 00       	push   $0x803df0
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
  80042b:	68 18 3e 80 00       	push   $0x803e18
  800430:	e8 34 01 00 00       	call   800569 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	50                   	push   %eax
  800447:	68 70 3e 80 00       	push   $0x803e70
  80044c:	e8 18 01 00 00       	call   800569 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	68 c8 3d 80 00       	push   $0x803dc8
  80045c:	e8 08 01 00 00       	call   800569 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800464:	e8 66 14 00 00       	call   8018cf <sys_unlock_cons>
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
  80047c:	e8 7c 16 00 00       	call   801afd <sys_destroy_env>
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
  80048d:	e8 d1 16 00 00       	call   801b63 <sys_exit_env>
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
  8004db:	e8 93 13 00 00       	call   801873 <sys_cputs>
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
  800552:	e8 1c 13 00 00       	call   801873 <sys_cputs>
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
  80059c:	e8 14 13 00 00       	call   8018b5 <sys_lock_cons>
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
  8005bc:	e8 0e 13 00 00       	call   8018cf <sys_unlock_cons>
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
  800606:	e8 e9 34 00 00       	call   803af4 <__udivdi3>
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
  800656:	e8 a9 35 00 00       	call   803c04 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  8007b1:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  800892:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 c5 40 80 00       	push   $0x8040c5
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
  8008b7:	68 ce 40 80 00       	push   $0x8040ce
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
  8008e4:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  8012ef:	68 48 42 80 00       	push   $0x804248
  8012f4:	68 3f 01 00 00       	push   $0x13f
  8012f9:	68 6a 42 80 00       	push   $0x80426a
  8012fe:	e8 07 26 00 00       	call   80390a <_panic>

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
  80130f:	e8 0a 0b 00 00       	call   801e1e <sys_sbrk>
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
  80138a:	e8 13 09 00 00       	call   801ca2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 16                	je     8013a9 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 53 0e 00 00       	call   8021f1 <alloc_block_FF>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a4:	e9 8a 01 00 00       	jmp    801533 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013a9:	e8 25 09 00 00       	call   801cd3 <sys_isUHeapPlacementStrategyBESTFIT>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	0f 84 7d 01 00 00    	je     801533 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 ec 12 00 00       	call   8026ad <alloc_block_BF>
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
  801522:	e8 2e 09 00 00       	call   801e55 <sys_allocate_user_mem>
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
  80156a:	e8 02 09 00 00       	call   801e71 <get_block_size>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 35 1b 00 00       	call   8030b5 <free_block>
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
  801612:	e8 22 08 00 00       	call   801e39 <sys_free_user_mem>
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
  801620:	68 78 42 80 00       	push   $0x804278
  801625:	68 85 00 00 00       	push   $0x85
  80162a:	68 a2 42 80 00       	push   $0x8042a2
  80162f:	e8 d6 22 00 00       	call   80390a <_panic>
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
  801695:	e8 a6 03 00 00       	call   801a40 <sys_createSharedObject>
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
  8016b9:	68 ae 42 80 00       	push   $0x8042ae
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
  8016fd:	e8 68 03 00 00       	call   801a6a <sys_getSizeOfSharedObject>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801708:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80170c:	75 07                	jne    801715 <sget+0x27>
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	eb 7f                	jmp    801794 <sget+0xa6>
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
  801748:	eb 4a                	jmp    801794 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	ff 75 e8             	pushl  -0x18(%ebp)
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 2c 03 00 00       	call   801a87 <sys_getSharedObject>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801761:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801764:	a1 20 50 80 00       	mov    0x805020,%eax
  801769:	8b 40 78             	mov    0x78(%eax),%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
  801770:	2d 00 10 00 00       	sub    $0x1000,%eax
  801775:	c1 e8 0c             	shr    $0xc,%eax
  801778:	89 c2                	mov    %eax,%edx
  80177a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80177d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801784:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801788:	75 07                	jne    801791 <sget+0xa3>
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
  80178f:	eb 03                	jmp    801794 <sget+0xa6>
	return ptr;
  801791:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80179c:	8b 55 08             	mov    0x8(%ebp),%edx
  80179f:	a1 20 50 80 00       	mov    0x805020,%eax
  8017a4:	8b 40 78             	mov    0x78(%eax),%eax
  8017a7:	29 c2                	sub    %eax,%edx
  8017a9:	89 d0                	mov    %edx,%eax
  8017ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b0:	c1 e8 0c             	shr    $0xc,%eax
  8017b3:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8017ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c6:	e8 db 02 00 00       	call   801aa6 <sys_freeSharedObject>
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017d1:	90                   	nop
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 c0 42 80 00       	push   $0x8042c0
  8017e2:	68 de 00 00 00       	push   $0xde
  8017e7:	68 a2 42 80 00       	push   $0x8042a2
  8017ec:	e8 19 21 00 00       	call   80390a <_panic>

008017f1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 e6 42 80 00       	push   $0x8042e6
  8017ff:	68 ea 00 00 00       	push   $0xea
  801804:	68 a2 42 80 00       	push   $0x8042a2
  801809:	e8 fc 20 00 00       	call   80390a <_panic>

0080180e <shrink>:

}
void shrink(uint32 newSize)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 e6 42 80 00       	push   $0x8042e6
  80181c:	68 ef 00 00 00       	push   $0xef
  801821:	68 a2 42 80 00       	push   $0x8042a2
  801826:	e8 df 20 00 00       	call   80390a <_panic>

0080182b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 e6 42 80 00       	push   $0x8042e6
  801839:	68 f4 00 00 00       	push   $0xf4
  80183e:	68 a2 42 80 00       	push   $0x8042a2
  801843:	e8 c2 20 00 00       	call   80390a <_panic>

00801848 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	57                   	push   %edi
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
  80184e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801860:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801863:	cd 30                	int    $0x30
  801865:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5f                   	pop    %edi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80187f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	52                   	push   %edx
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	50                   	push   %eax
  80188f:	6a 00                	push   $0x0
  801891:	e8 b2 ff ff ff       	call   801848 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_cgetc>:

int
sys_cgetc(void)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 02                	push   $0x2
  8018ab:	e8 98 ff ff ff       	call   801848 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 03                	push   $0x3
  8018c4:	e8 7f ff ff ff       	call   801848 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 04                	push   $0x4
  8018de:	e8 65 ff ff ff       	call   801848 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 08                	push   $0x8
  8018fc:	e8 47 ff ff ff       	call   801848 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80190b:	8b 75 18             	mov    0x18(%ebp),%esi
  80190e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801911:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	51                   	push   %ecx
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 09                	push   $0x9
  801921:	e8 22 ff ff ff       	call   801848 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192c:	5b                   	pop    %ebx
  80192d:	5e                   	pop    %esi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    

00801930 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	52                   	push   %edx
  801940:	50                   	push   %eax
  801941:	6a 0a                	push   $0xa
  801943:	e8 00 ff ff ff       	call   801848 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 0b                	push   $0xb
  80195e:	e8 e5 fe ff ff       	call   801848 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 0c                	push   $0xc
  801977:	e8 cc fe ff ff       	call   801848 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 0d                	push   $0xd
  801990:	e8 b3 fe ff ff       	call   801848 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0e                	push   $0xe
  8019a9:	e8 9a fe ff ff       	call   801848 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0f                	push   $0xf
  8019c2:	e8 81 fe ff ff       	call   801848 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 08             	pushl  0x8(%ebp)
  8019da:	6a 10                	push   $0x10
  8019dc:	e8 67 fe ff ff       	call   801848 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 11                	push   $0x11
  8019f5:	e8 4e fe ff ff       	call   801848 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	50                   	push   %eax
  801a19:	6a 01                	push   $0x1
  801a1b:	e8 28 fe ff ff       	call   801848 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 14                	push   $0x14
  801a35:	e8 0e fe ff ff       	call   801848 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	8b 45 10             	mov    0x10(%ebp),%eax
  801a49:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a4c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a4f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	51                   	push   %ecx
  801a59:	52                   	push   %edx
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	6a 15                	push   $0x15
  801a60:	e8 e3 fd ff ff       	call   801848 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	50                   	push   %eax
  801a7b:	6a 16                	push   $0x16
  801a7d:	e8 c6 fd ff ff       	call   801848 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	51                   	push   %ecx
  801a98:	52                   	push   %edx
  801a99:	50                   	push   %eax
  801a9a:	6a 17                	push   $0x17
  801a9c:	e8 a7 fd ff ff       	call   801848 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 18                	push   $0x18
  801ab9:	e8 8a fd ff ff       	call   801848 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 14             	pushl  0x14(%ebp)
  801ace:	ff 75 10             	pushl  0x10(%ebp)
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	50                   	push   %eax
  801ad5:	6a 19                	push   $0x19
  801ad7:	e8 6c fd ff ff       	call   801848 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	50                   	push   %eax
  801af0:	6a 1a                	push   $0x1a
  801af2:	e8 51 fd ff ff       	call   801848 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	90                   	nop
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	50                   	push   %eax
  801b0c:	6a 1b                	push   $0x1b
  801b0e:	e8 35 fd ff ff       	call   801848 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 05                	push   $0x5
  801b27:	e8 1c fd ff ff       	call   801848 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 06                	push   $0x6
  801b40:	e8 03 fd ff ff       	call   801848 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 07                	push   $0x7
  801b59:	e8 ea fc ff ff       	call   801848 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_exit_env>:


void sys_exit_env(void)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 1c                	push   $0x1c
  801b72:	e8 d1 fc ff ff       	call   801848 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b86:	8d 50 04             	lea    0x4(%eax),%edx
  801b89:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 1d                	push   $0x1d
  801b96:	e8 ad fc ff ff       	call   801848 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
	return result;
  801b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba7:	89 01                	mov    %eax,(%ecx)
  801ba9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	c9                   	leave  
  801bb0:	c2 04 00             	ret    $0x4

00801bb3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	ff 75 08             	pushl  0x8(%ebp)
  801bc3:	6a 13                	push   $0x13
  801bc5:	e8 7e fc ff ff       	call   801848 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcd:	90                   	nop
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 1e                	push   $0x1e
  801bdf:	e8 64 fc ff ff       	call   801848 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	50                   	push   %eax
  801c02:	6a 1f                	push   $0x1f
  801c04:	e8 3f fc ff ff       	call   801848 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <rsttst>:
void rsttst()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 21                	push   $0x21
  801c1e:	e8 25 fc ff ff       	call   801848 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return ;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c35:	8b 55 18             	mov    0x18(%ebp),%edx
  801c38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3c:	52                   	push   %edx
  801c3d:	50                   	push   %eax
  801c3e:	ff 75 10             	pushl  0x10(%ebp)
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	6a 20                	push   $0x20
  801c49:	e8 fa fb ff ff       	call   801848 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c51:	90                   	nop
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <chktst>:
void chktst(uint32 n)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	6a 22                	push   $0x22
  801c64:	e8 df fb ff ff       	call   801848 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <inctst>:

void inctst()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 23                	push   $0x23
  801c7e:	e8 c5 fb ff ff       	call   801848 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return ;
  801c86:	90                   	nop
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <gettst>:
uint32 gettst()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 24                	push   $0x24
  801c98:	e8 ab fb ff ff       	call   801848 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 25                	push   $0x25
  801cb4:	e8 8f fb ff ff       	call   801848 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
  801cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cbf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc3:	75 07                	jne    801ccc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cca:	eb 05                	jmp    801cd1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 25                	push   $0x25
  801ce5:	e8 5e fb ff ff       	call   801848 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
  801ced:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cf4:	75 07                	jne    801cfd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	eb 05                	jmp    801d02 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 25                	push   $0x25
  801d16:	e8 2d fb ff ff       	call   801848 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
  801d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d21:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d25:	75 07                	jne    801d2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d27:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2c:	eb 05                	jmp    801d33 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 25                	push   $0x25
  801d47:	e8 fc fa ff ff       	call   801848 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
  801d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d52:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d56:	75 07                	jne    801d5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d58:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5d:	eb 05                	jmp    801d64 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	ff 75 08             	pushl  0x8(%ebp)
  801d74:	6a 26                	push   $0x26
  801d76:	e8 cd fa ff ff       	call   801848 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7e:	90                   	nop
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d85:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	53                   	push   %ebx
  801d94:	51                   	push   %ecx
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	6a 27                	push   $0x27
  801d99:	e8 aa fa ff ff       	call   801848 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	6a 28                	push   $0x28
  801db9:	e8 8a fa ff ff       	call   801848 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801dc6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	51                   	push   %ecx
  801dd2:	ff 75 10             	pushl  0x10(%ebp)
  801dd5:	52                   	push   %edx
  801dd6:	50                   	push   %eax
  801dd7:	6a 29                	push   $0x29
  801dd9:	e8 6a fa ff ff       	call   801848 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	ff 75 10             	pushl  0x10(%ebp)
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 12                	push   $0x12
  801df5:	e8 4e fa ff ff       	call   801848 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 2a                	push   $0x2a
  801e13:	e8 30 fa ff ff       	call   801848 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return;
  801e1b:	90                   	nop
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	50                   	push   %eax
  801e2d:	6a 2b                	push   $0x2b
  801e2f:	e8 14 fa ff ff       	call   801848 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 2c                	push   $0x2c
  801e4a:	e8 f9 f9 ff ff       	call   801848 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	6a 2d                	push   $0x2d
  801e66:	e8 dd f9 ff ff       	call   801848 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
	return;
  801e6e:	90                   	nop
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	83 e8 04             	sub    $0x4,%eax
  801e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e83:	8b 00                	mov    (%eax),%eax
  801e85:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	83 e8 04             	sub    $0x4,%eax
  801e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9c:	8b 00                	mov    (%eax),%eax
  801e9e:	83 e0 01             	and    $0x1,%eax
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	0f 94 c0             	sete   %al
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb8:	83 f8 02             	cmp    $0x2,%eax
  801ebb:	74 2b                	je     801ee8 <alloc_block+0x40>
  801ebd:	83 f8 02             	cmp    $0x2,%eax
  801ec0:	7f 07                	jg     801ec9 <alloc_block+0x21>
  801ec2:	83 f8 01             	cmp    $0x1,%eax
  801ec5:	74 0e                	je     801ed5 <alloc_block+0x2d>
  801ec7:	eb 58                	jmp    801f21 <alloc_block+0x79>
  801ec9:	83 f8 03             	cmp    $0x3,%eax
  801ecc:	74 2d                	je     801efb <alloc_block+0x53>
  801ece:	83 f8 04             	cmp    $0x4,%eax
  801ed1:	74 3b                	je     801f0e <alloc_block+0x66>
  801ed3:	eb 4c                	jmp    801f21 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	e8 11 03 00 00       	call   8021f1 <alloc_block_FF>
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ee6:	eb 4a                	jmp    801f32 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	ff 75 08             	pushl  0x8(%ebp)
  801eee:	e8 fa 19 00 00       	call   8038ed <alloc_block_NF>
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ef9:	eb 37                	jmp    801f32 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801efb:	83 ec 0c             	sub    $0xc,%esp
  801efe:	ff 75 08             	pushl  0x8(%ebp)
  801f01:	e8 a7 07 00 00       	call   8026ad <alloc_block_BF>
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f0c:	eb 24                	jmp    801f32 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	e8 b7 19 00 00       	call   8038d0 <alloc_block_WF>
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f1f:	eb 11                	jmp    801f32 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	68 f8 42 80 00       	push   $0x8042f8
  801f29:	e8 3b e6 ff ff       	call   800569 <cprintf>
  801f2e:	83 c4 10             	add    $0x10,%esp
		break;
  801f31:	90                   	nop
	}
	return va;
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	53                   	push   %ebx
  801f3b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	68 18 43 80 00       	push   $0x804318
  801f46:	e8 1e e6 ff ff       	call   800569 <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 43 43 80 00       	push   $0x804343
  801f56:	e8 0e e6 ff ff       	call   800569 <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f64:	eb 37                	jmp    801f9d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6c:	e8 19 ff ff ff       	call   801e8a <is_free_block>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	0f be d8             	movsbl %al,%ebx
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7d:	e8 ef fe ff ff       	call   801e71 <get_block_size>
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	53                   	push   %ebx
  801f89:	50                   	push   %eax
  801f8a:	68 5b 43 80 00       	push   $0x80435b
  801f8f:	e8 d5 e5 ff ff       	call   800569 <cprintf>
  801f94:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f97:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa1:	74 07                	je     801faa <print_blocks_list+0x73>
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	eb 05                	jmp    801faf <print_blocks_list+0x78>
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	89 45 10             	mov    %eax,0x10(%ebp)
  801fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	75 ad                	jne    801f66 <print_blocks_list+0x2f>
  801fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbd:	75 a7                	jne    801f66 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	68 18 43 80 00       	push   $0x804318
  801fc7:	e8 9d e5 ff ff       	call   800569 <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp

}
  801fcf:	90                   	nop
  801fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fde:	83 e0 01             	and    $0x1,%eax
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	74 03                	je     801fe8 <initialize_dynamic_allocator+0x13>
  801fe5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fe8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fec:	0f 84 c7 01 00 00    	je     8021b9 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ff2:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801ff9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  801fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802002:	01 d0                	add    %edx,%eax
  802004:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802009:	0f 87 ad 01 00 00    	ja     8021bc <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 89 a5 01 00 00    	jns    8021bf <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80201a:	8b 55 08             	mov    0x8(%ebp),%edx
  80201d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802020:	01 d0                	add    %edx,%eax
  802022:	83 e8 04             	sub    $0x4,%eax
  802025:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80202a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802031:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802039:	e9 87 00 00 00       	jmp    8020c5 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80203e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802042:	75 14                	jne    802058 <initialize_dynamic_allocator+0x83>
  802044:	83 ec 04             	sub    $0x4,%esp
  802047:	68 73 43 80 00       	push   $0x804373
  80204c:	6a 79                	push   $0x79
  80204e:	68 91 43 80 00       	push   $0x804391
  802053:	e8 b2 18 00 00       	call   80390a <_panic>
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 10                	je     802071 <initialize_dynamic_allocator+0x9c>
  802061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802064:	8b 00                	mov    (%eax),%eax
  802066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802069:	8b 52 04             	mov    0x4(%edx),%edx
  80206c:	89 50 04             	mov    %edx,0x4(%eax)
  80206f:	eb 0b                	jmp    80207c <initialize_dynamic_allocator+0xa7>
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	8b 40 04             	mov    0x4(%eax),%eax
  802077:	a3 30 50 80 00       	mov    %eax,0x805030
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 40 04             	mov    0x4(%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 0f                	je     802095 <initialize_dynamic_allocator+0xc0>
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	8b 40 04             	mov    0x4(%eax),%eax
  80208c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208f:	8b 12                	mov    (%edx),%edx
  802091:	89 10                	mov    %edx,(%eax)
  802093:	eb 0a                	jmp    80209f <initialize_dynamic_allocator+0xca>
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	8b 00                	mov    (%eax),%eax
  80209a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8020b7:	48                   	dec    %eax
  8020b8:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8020c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c9:	74 07                	je     8020d2 <initialize_dynamic_allocator+0xfd>
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 00                	mov    (%eax),%eax
  8020d0:	eb 05                	jmp    8020d7 <initialize_dynamic_allocator+0x102>
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8020dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	0f 85 55 ff ff ff    	jne    80203e <initialize_dynamic_allocator+0x69>
  8020e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ed:	0f 85 4b ff ff ff    	jne    80203e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802102:	a1 44 50 80 00       	mov    0x805044,%eax
  802107:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80210c:	a1 40 50 80 00       	mov    0x805040,%eax
  802111:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	83 c0 08             	add    $0x8,%eax
  80211d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	83 c0 04             	add    $0x4,%eax
  802126:	8b 55 0c             	mov    0xc(%ebp),%edx
  802129:	83 ea 08             	sub    $0x8,%edx
  80212c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80212e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	01 d0                	add    %edx,%eax
  802136:	83 e8 08             	sub    $0x8,%eax
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	83 ea 08             	sub    $0x8,%edx
  80213f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802144:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80214a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802154:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802158:	75 17                	jne    802171 <initialize_dynamic_allocator+0x19c>
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	68 ac 43 80 00       	push   $0x8043ac
  802162:	68 90 00 00 00       	push   $0x90
  802167:	68 91 43 80 00       	push   $0x804391
  80216c:	e8 99 17 00 00       	call   80390a <_panic>
  802171:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217a:	89 10                	mov    %edx,(%eax)
  80217c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	85 c0                	test   %eax,%eax
  802183:	74 0d                	je     802192 <initialize_dynamic_allocator+0x1bd>
  802185:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80218a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80218d:	89 50 04             	mov    %edx,0x4(%eax)
  802190:	eb 08                	jmp    80219a <initialize_dynamic_allocator+0x1c5>
  802192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802195:	a3 30 50 80 00       	mov    %eax,0x805030
  80219a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b1:	40                   	inc    %eax
  8021b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8021b7:	eb 07                	jmp    8021c0 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021b9:	90                   	nop
  8021ba:	eb 04                	jmp    8021c0 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021bc:	90                   	nop
  8021bd:	eb 01                	jmp    8021c0 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021bf:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c8:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d4:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	83 e8 04             	sub    $0x4,%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	83 e0 fe             	and    $0xfffffffe,%eax
  8021e1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	01 c2                	add    %eax,%edx
  8021e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ec:	89 02                	mov    %eax,(%edx)
}
  8021ee:	90                   	nop
  8021ef:	5d                   	pop    %ebp
  8021f0:	c3                   	ret    

008021f1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	83 e0 01             	and    $0x1,%eax
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	74 03                	je     802204 <alloc_block_FF+0x13>
  802201:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802204:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802208:	77 07                	ja     802211 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80220a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802211:	a1 24 50 80 00       	mov    0x805024,%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	75 73                	jne    80228d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	83 c0 10             	add    $0x10,%eax
  802220:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802223:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80222a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80222d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	48                   	dec    %eax
  802233:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802239:	ba 00 00 00 00       	mov    $0x0,%edx
  80223e:	f7 75 ec             	divl   -0x14(%ebp)
  802241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802244:	29 d0                	sub    %edx,%eax
  802246:	c1 e8 0c             	shr    $0xc,%eax
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	50                   	push   %eax
  80224d:	e8 b1 f0 ff ff       	call   801303 <sbrk>
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802258:	83 ec 0c             	sub    $0xc,%esp
  80225b:	6a 00                	push   $0x0
  80225d:	e8 a1 f0 ff ff       	call   801303 <sbrk>
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80226b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80226e:	83 ec 08             	sub    $0x8,%esp
  802271:	50                   	push   %eax
  802272:	ff 75 e4             	pushl  -0x1c(%ebp)
  802275:	e8 5b fd ff ff       	call   801fd5 <initialize_dynamic_allocator>
  80227a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80227d:	83 ec 0c             	sub    $0xc,%esp
  802280:	68 cf 43 80 00       	push   $0x8043cf
  802285:	e8 df e2 ff ff       	call   800569 <cprintf>
  80228a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80228d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802291:	75 0a                	jne    80229d <alloc_block_FF+0xac>
	        return NULL;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	e9 0e 04 00 00       	jmp    8026ab <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80229d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ac:	e9 f3 02 00 00       	jmp    8025a4 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8022bd:	e8 af fb ff ff       	call   801e71 <get_block_size>
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	83 c0 08             	add    $0x8,%eax
  8022ce:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022d1:	0f 87 c5 02 00 00    	ja     80259c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	83 c0 18             	add    $0x18,%eax
  8022dd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022e0:	0f 87 19 02 00 00    	ja     8024ff <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022e9:	2b 45 08             	sub    0x8(%ebp),%eax
  8022ec:	83 e8 08             	sub    $0x8,%eax
  8022ef:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8d 50 08             	lea    0x8(%eax),%edx
  8022f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022fb:	01 d0                	add    %edx,%eax
  8022fd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	83 c0 08             	add    $0x8,%eax
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	6a 01                	push   $0x1
  80230b:	50                   	push   %eax
  80230c:	ff 75 bc             	pushl  -0x44(%ebp)
  80230f:	e8 ae fe ff ff       	call   8021c2 <set_block_data>
  802314:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 04             	mov    0x4(%eax),%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	75 68                	jne    802389 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802321:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802325:	75 17                	jne    80233e <alloc_block_FF+0x14d>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 ac 43 80 00       	push   $0x8043ac
  80232f:	68 d7 00 00 00       	push   $0xd7
  802334:	68 91 43 80 00       	push   $0x804391
  802339:	e8 cc 15 00 00       	call   80390a <_panic>
  80233e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802347:	89 10                	mov    %edx,(%eax)
  802349:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234c:	8b 00                	mov    (%eax),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 0d                	je     80235f <alloc_block_FF+0x16e>
  802352:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802357:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80235a:	89 50 04             	mov    %edx,0x4(%eax)
  80235d:	eb 08                	jmp    802367 <alloc_block_FF+0x176>
  80235f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802362:	a3 30 50 80 00       	mov    %eax,0x805030
  802367:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80236f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802372:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802379:	a1 38 50 80 00       	mov    0x805038,%eax
  80237e:	40                   	inc    %eax
  80237f:	a3 38 50 80 00       	mov    %eax,0x805038
  802384:	e9 dc 00 00 00       	jmp    802465 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	75 65                	jne    8023f7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802392:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802396:	75 17                	jne    8023af <alloc_block_FF+0x1be>
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	68 e0 43 80 00       	push   $0x8043e0
  8023a0:	68 db 00 00 00       	push   $0xdb
  8023a5:	68 91 43 80 00       	push   $0x804391
  8023aa:	e8 5b 15 00 00       	call   80390a <_panic>
  8023af:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b8:	89 50 04             	mov    %edx,0x4(%eax)
  8023bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023be:	8b 40 04             	mov    0x4(%eax),%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	74 0c                	je     8023d1 <alloc_block_FF+0x1e0>
  8023c5:	a1 30 50 80 00       	mov    0x805030,%eax
  8023ca:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023cd:	89 10                	mov    %edx,(%eax)
  8023cf:	eb 08                	jmp    8023d9 <alloc_block_FF+0x1e8>
  8023d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8023e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ef:	40                   	inc    %eax
  8023f0:	a3 38 50 80 00       	mov    %eax,0x805038
  8023f5:	eb 6e                	jmp    802465 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fb:	74 06                	je     802403 <alloc_block_FF+0x212>
  8023fd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802401:	75 17                	jne    80241a <alloc_block_FF+0x229>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 04 44 80 00       	push   $0x804404
  80240b:	68 df 00 00 00       	push   $0xdf
  802410:	68 91 43 80 00       	push   $0x804391
  802415:	e8 f0 14 00 00       	call   80390a <_panic>
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 10                	mov    (%eax),%edx
  80241f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802422:	89 10                	mov    %edx,(%eax)
  802424:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	74 0b                	je     802438 <alloc_block_FF+0x247>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802435:	89 50 04             	mov    %edx,0x4(%eax)
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80243e:	89 10                	mov    %edx,(%eax)
  802440:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	75 08                	jne    80245a <alloc_block_FF+0x269>
  802452:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802455:	a3 30 50 80 00       	mov    %eax,0x805030
  80245a:	a1 38 50 80 00       	mov    0x805038,%eax
  80245f:	40                   	inc    %eax
  802460:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	75 17                	jne    802482 <alloc_block_FF+0x291>
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	68 73 43 80 00       	push   $0x804373
  802473:	68 e1 00 00 00       	push   $0xe1
  802478:	68 91 43 80 00       	push   $0x804391
  80247d:	e8 88 14 00 00       	call   80390a <_panic>
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	74 10                	je     80249b <alloc_block_FF+0x2aa>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802493:	8b 52 04             	mov    0x4(%edx),%edx
  802496:	89 50 04             	mov    %edx,0x4(%eax)
  802499:	eb 0b                	jmp    8024a6 <alloc_block_FF+0x2b5>
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 40 04             	mov    0x4(%eax),%eax
  8024a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 0f                	je     8024bf <alloc_block_FF+0x2ce>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b9:	8b 12                	mov    (%edx),%edx
  8024bb:	89 10                	mov    %edx,(%eax)
  8024bd:	eb 0a                	jmp    8024c9 <alloc_block_FF+0x2d8>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e1:	48                   	dec    %eax
  8024e2:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024e7:	83 ec 04             	sub    $0x4,%esp
  8024ea:	6a 00                	push   $0x0
  8024ec:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024ef:	ff 75 b0             	pushl  -0x50(%ebp)
  8024f2:	e8 cb fc ff ff       	call   8021c2 <set_block_data>
  8024f7:	83 c4 10             	add    $0x10,%esp
  8024fa:	e9 95 00 00 00       	jmp    802594 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024ff:	83 ec 04             	sub    $0x4,%esp
  802502:	6a 01                	push   $0x1
  802504:	ff 75 b8             	pushl  -0x48(%ebp)
  802507:	ff 75 bc             	pushl  -0x44(%ebp)
  80250a:	e8 b3 fc ff ff       	call   8021c2 <set_block_data>
  80250f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802516:	75 17                	jne    80252f <alloc_block_FF+0x33e>
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	68 73 43 80 00       	push   $0x804373
  802520:	68 e8 00 00 00       	push   $0xe8
  802525:	68 91 43 80 00       	push   $0x804391
  80252a:	e8 db 13 00 00       	call   80390a <_panic>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	85 c0                	test   %eax,%eax
  802536:	74 10                	je     802548 <alloc_block_FF+0x357>
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 00                	mov    (%eax),%eax
  80253d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802540:	8b 52 04             	mov    0x4(%edx),%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	eb 0b                	jmp    802553 <alloc_block_FF+0x362>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	a3 30 50 80 00       	mov    %eax,0x805030
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	74 0f                	je     80256c <alloc_block_FF+0x37b>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	8b 12                	mov    (%edx),%edx
  802568:	89 10                	mov    %edx,(%eax)
  80256a:	eb 0a                	jmp    802576 <alloc_block_FF+0x385>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802589:	a1 38 50 80 00       	mov    0x805038,%eax
  80258e:	48                   	dec    %eax
  80258f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802594:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802597:	e9 0f 01 00 00       	jmp    8026ab <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80259c:	a1 34 50 80 00       	mov    0x805034,%eax
  8025a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a8:	74 07                	je     8025b1 <alloc_block_FF+0x3c0>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	eb 05                	jmp    8025b6 <alloc_block_FF+0x3c5>
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b6:	a3 34 50 80 00       	mov    %eax,0x805034
  8025bb:	a1 34 50 80 00       	mov    0x805034,%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	0f 85 e9 fc ff ff    	jne    8022b1 <alloc_block_FF+0xc0>
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	0f 85 df fc ff ff    	jne    8022b1 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	83 c0 08             	add    $0x8,%eax
  8025d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025db:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025e8:	01 d0                	add    %edx,%eax
  8025ea:	48                   	dec    %eax
  8025eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f6:	f7 75 d8             	divl   -0x28(%ebp)
  8025f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025fc:	29 d0                	sub    %edx,%eax
  8025fe:	c1 e8 0c             	shr    $0xc,%eax
  802601:	83 ec 0c             	sub    $0xc,%esp
  802604:	50                   	push   %eax
  802605:	e8 f9 ec ff ff       	call   801303 <sbrk>
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802610:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802614:	75 0a                	jne    802620 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	e9 8b 00 00 00       	jmp    8026ab <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802620:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802627:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80262a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80262d:	01 d0                	add    %edx,%eax
  80262f:	48                   	dec    %eax
  802630:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802633:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802636:	ba 00 00 00 00       	mov    $0x0,%edx
  80263b:	f7 75 cc             	divl   -0x34(%ebp)
  80263e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802641:	29 d0                	sub    %edx,%eax
  802643:	8d 50 fc             	lea    -0x4(%eax),%edx
  802646:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802649:	01 d0                	add    %edx,%eax
  80264b:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802650:	a1 40 50 80 00       	mov    0x805040,%eax
  802655:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80265b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802662:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802665:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802668:	01 d0                	add    %edx,%eax
  80266a:	48                   	dec    %eax
  80266b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80266e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802671:	ba 00 00 00 00       	mov    $0x0,%edx
  802676:	f7 75 c4             	divl   -0x3c(%ebp)
  802679:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80267c:	29 d0                	sub    %edx,%eax
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	6a 01                	push   $0x1
  802683:	50                   	push   %eax
  802684:	ff 75 d0             	pushl  -0x30(%ebp)
  802687:	e8 36 fb ff ff       	call   8021c2 <set_block_data>
  80268c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80268f:	83 ec 0c             	sub    $0xc,%esp
  802692:	ff 75 d0             	pushl  -0x30(%ebp)
  802695:	e8 1b 0a 00 00       	call   8030b5 <free_block>
  80269a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	ff 75 08             	pushl  0x8(%ebp)
  8026a3:	e8 49 fb ff ff       	call   8021f1 <alloc_block_FF>
  8026a8:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	83 e0 01             	and    $0x1,%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 03                	je     8026c0 <alloc_block_BF+0x13>
  8026bd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026c0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026c4:	77 07                	ja     8026cd <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026c6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	75 73                	jne    802749 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	83 c0 10             	add    $0x10,%eax
  8026dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026df:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ec:	01 d0                	add    %edx,%eax
  8026ee:	48                   	dec    %eax
  8026ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fa:	f7 75 e0             	divl   -0x20(%ebp)
  8026fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802700:	29 d0                	sub    %edx,%eax
  802702:	c1 e8 0c             	shr    $0xc,%eax
  802705:	83 ec 0c             	sub    $0xc,%esp
  802708:	50                   	push   %eax
  802709:	e8 f5 eb ff ff       	call   801303 <sbrk>
  80270e:	83 c4 10             	add    $0x10,%esp
  802711:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802714:	83 ec 0c             	sub    $0xc,%esp
  802717:	6a 00                	push   $0x0
  802719:	e8 e5 eb ff ff       	call   801303 <sbrk>
  80271e:	83 c4 10             	add    $0x10,%esp
  802721:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802724:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802727:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80272a:	83 ec 08             	sub    $0x8,%esp
  80272d:	50                   	push   %eax
  80272e:	ff 75 d8             	pushl  -0x28(%ebp)
  802731:	e8 9f f8 ff ff       	call   801fd5 <initialize_dynamic_allocator>
  802736:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802739:	83 ec 0c             	sub    $0xc,%esp
  80273c:	68 cf 43 80 00       	push   $0x8043cf
  802741:	e8 23 de ff ff       	call   800569 <cprintf>
  802746:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802750:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802757:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80275e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802765:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80276a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276d:	e9 1d 01 00 00       	jmp    80288f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802778:	83 ec 0c             	sub    $0xc,%esp
  80277b:	ff 75 a8             	pushl  -0x58(%ebp)
  80277e:	e8 ee f6 ff ff       	call   801e71 <get_block_size>
  802783:	83 c4 10             	add    $0x10,%esp
  802786:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	83 c0 08             	add    $0x8,%eax
  80278f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802792:	0f 87 ef 00 00 00    	ja     802887 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	83 c0 18             	add    $0x18,%eax
  80279e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a1:	77 1d                	ja     8027c0 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a9:	0f 86 d8 00 00 00    	jbe    802887 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027af:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027b5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027bb:	e9 c7 00 00 00       	jmp    802887 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	83 c0 08             	add    $0x8,%eax
  8027c6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c9:	0f 85 9d 00 00 00    	jne    80286c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	6a 01                	push   $0x1
  8027d4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027d7:	ff 75 a8             	pushl  -0x58(%ebp)
  8027da:	e8 e3 f9 ff ff       	call   8021c2 <set_block_data>
  8027df:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	75 17                	jne    8027ff <alloc_block_BF+0x152>
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	68 73 43 80 00       	push   $0x804373
  8027f0:	68 2c 01 00 00       	push   $0x12c
  8027f5:	68 91 43 80 00       	push   $0x804391
  8027fa:	e8 0b 11 00 00       	call   80390a <_panic>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	74 10                	je     802818 <alloc_block_BF+0x16b>
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 00                	mov    (%eax),%eax
  80280d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802810:	8b 52 04             	mov    0x4(%edx),%edx
  802813:	89 50 04             	mov    %edx,0x4(%eax)
  802816:	eb 0b                	jmp    802823 <alloc_block_BF+0x176>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	a3 30 50 80 00       	mov    %eax,0x805030
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 04             	mov    0x4(%eax),%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	74 0f                	je     80283c <alloc_block_BF+0x18f>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802836:	8b 12                	mov    (%edx),%edx
  802838:	89 10                	mov    %edx,(%eax)
  80283a:	eb 0a                	jmp    802846 <alloc_block_BF+0x199>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802859:	a1 38 50 80 00       	mov    0x805038,%eax
  80285e:	48                   	dec    %eax
  80285f:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802864:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802867:	e9 24 04 00 00       	jmp    802c90 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802872:	76 13                	jbe    802887 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802874:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80287b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80287e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802881:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802884:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802887:	a1 34 50 80 00       	mov    0x805034,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802893:	74 07                	je     80289c <alloc_block_BF+0x1ef>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	eb 05                	jmp    8028a1 <alloc_block_BF+0x1f4>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	a3 34 50 80 00       	mov    %eax,0x805034
  8028a6:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	0f 85 bf fe ff ff    	jne    802772 <alloc_block_BF+0xc5>
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	0f 85 b5 fe ff ff    	jne    802772 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c1:	0f 84 26 02 00 00    	je     802aed <alloc_block_BF+0x440>
  8028c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028cb:	0f 85 1c 02 00 00    	jne    802aed <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d7:	83 e8 08             	sub    $0x8,%eax
  8028da:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	8d 50 08             	lea    0x8(%eax),%edx
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	83 c0 08             	add    $0x8,%eax
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	6a 01                	push   $0x1
  8028f6:	50                   	push   %eax
  8028f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8028fa:	e8 c3 f8 ff ff       	call   8021c2 <set_block_data>
  8028ff:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	75 68                	jne    802974 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80290c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802910:	75 17                	jne    802929 <alloc_block_BF+0x27c>
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	68 ac 43 80 00       	push   $0x8043ac
  80291a:	68 45 01 00 00       	push   $0x145
  80291f:	68 91 43 80 00       	push   $0x804391
  802924:	e8 e1 0f 00 00       	call   80390a <_panic>
  802929:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80292f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802932:	89 10                	mov    %edx,(%eax)
  802934:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 0d                	je     80294a <alloc_block_BF+0x29d>
  80293d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802942:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802945:	89 50 04             	mov    %edx,0x4(%eax)
  802948:	eb 08                	jmp    802952 <alloc_block_BF+0x2a5>
  80294a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294d:	a3 30 50 80 00       	mov    %eax,0x805030
  802952:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802955:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80295a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802964:	a1 38 50 80 00       	mov    0x805038,%eax
  802969:	40                   	inc    %eax
  80296a:	a3 38 50 80 00       	mov    %eax,0x805038
  80296f:	e9 dc 00 00 00       	jmp    802a50 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	75 65                	jne    8029e2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80297d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802981:	75 17                	jne    80299a <alloc_block_BF+0x2ed>
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	68 e0 43 80 00       	push   $0x8043e0
  80298b:	68 4a 01 00 00       	push   $0x14a
  802990:	68 91 43 80 00       	push   $0x804391
  802995:	e8 70 0f 00 00       	call   80390a <_panic>
  80299a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	74 0c                	je     8029bc <alloc_block_BF+0x30f>
  8029b0:	a1 30 50 80 00       	mov    0x805030,%eax
  8029b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b8:	89 10                	mov    %edx,(%eax)
  8029ba:	eb 08                	jmp    8029c4 <alloc_block_BF+0x317>
  8029bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8029cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8029da:	40                   	inc    %eax
  8029db:	a3 38 50 80 00       	mov    %eax,0x805038
  8029e0:	eb 6e                	jmp    802a50 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e6:	74 06                	je     8029ee <alloc_block_BF+0x341>
  8029e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029ec:	75 17                	jne    802a05 <alloc_block_BF+0x358>
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	68 04 44 80 00       	push   $0x804404
  8029f6:	68 4f 01 00 00       	push   $0x14f
  8029fb:	68 91 43 80 00       	push   $0x804391
  802a00:	e8 05 0f 00 00       	call   80390a <_panic>
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 10                	mov    (%eax),%edx
  802a0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 0b                	je     802a23 <alloc_block_BF+0x376>
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a29:	89 10                	mov    %edx,(%eax)
  802a2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	75 08                	jne    802a45 <alloc_block_BF+0x398>
  802a3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a40:	a3 30 50 80 00       	mov    %eax,0x805030
  802a45:	a1 38 50 80 00       	mov    0x805038,%eax
  802a4a:	40                   	inc    %eax
  802a4b:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a54:	75 17                	jne    802a6d <alloc_block_BF+0x3c0>
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	68 73 43 80 00       	push   $0x804373
  802a5e:	68 51 01 00 00       	push   $0x151
  802a63:	68 91 43 80 00       	push   $0x804391
  802a68:	e8 9d 0e 00 00       	call   80390a <_panic>
  802a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	74 10                	je     802a86 <alloc_block_BF+0x3d9>
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a7e:	8b 52 04             	mov    0x4(%edx),%edx
  802a81:	89 50 04             	mov    %edx,0x4(%eax)
  802a84:	eb 0b                	jmp    802a91 <alloc_block_BF+0x3e4>
  802a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a89:	8b 40 04             	mov    0x4(%eax),%eax
  802a8c:	a3 30 50 80 00       	mov    %eax,0x805030
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 0f                	je     802aaa <alloc_block_BF+0x3fd>
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa4:	8b 12                	mov    (%edx),%edx
  802aa6:	89 10                	mov    %edx,(%eax)
  802aa8:	eb 0a                	jmp    802ab4 <alloc_block_BF+0x407>
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac7:	a1 38 50 80 00       	mov    0x805038,%eax
  802acc:	48                   	dec    %eax
  802acd:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ad2:	83 ec 04             	sub    $0x4,%esp
  802ad5:	6a 00                	push   $0x0
  802ad7:	ff 75 d0             	pushl  -0x30(%ebp)
  802ada:	ff 75 cc             	pushl  -0x34(%ebp)
  802add:	e8 e0 f6 ff ff       	call   8021c2 <set_block_data>
  802ae2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	e9 a3 01 00 00       	jmp    802c90 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802aed:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802af1:	0f 85 9d 00 00 00    	jne    802b94 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	6a 01                	push   $0x1
  802afc:	ff 75 ec             	pushl  -0x14(%ebp)
  802aff:	ff 75 f0             	pushl  -0x10(%ebp)
  802b02:	e8 bb f6 ff ff       	call   8021c2 <set_block_data>
  802b07:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b0e:	75 17                	jne    802b27 <alloc_block_BF+0x47a>
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	68 73 43 80 00       	push   $0x804373
  802b18:	68 58 01 00 00       	push   $0x158
  802b1d:	68 91 43 80 00       	push   $0x804391
  802b22:	e8 e3 0d 00 00       	call   80390a <_panic>
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 10                	je     802b40 <alloc_block_BF+0x493>
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b38:	8b 52 04             	mov    0x4(%edx),%edx
  802b3b:	89 50 04             	mov    %edx,0x4(%eax)
  802b3e:	eb 0b                	jmp    802b4b <alloc_block_BF+0x49e>
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	a3 30 50 80 00       	mov    %eax,0x805030
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	8b 40 04             	mov    0x4(%eax),%eax
  802b51:	85 c0                	test   %eax,%eax
  802b53:	74 0f                	je     802b64 <alloc_block_BF+0x4b7>
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b5e:	8b 12                	mov    (%edx),%edx
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	eb 0a                	jmp    802b6e <alloc_block_BF+0x4c1>
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b81:	a1 38 50 80 00       	mov    0x805038,%eax
  802b86:	48                   	dec    %eax
  802b87:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	e9 fc 00 00 00       	jmp    802c90 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	83 c0 08             	add    $0x8,%eax
  802b9a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b9d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ba4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ba7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802baa:	01 d0                	add    %edx,%eax
  802bac:	48                   	dec    %eax
  802bad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bb0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb8:	f7 75 c4             	divl   -0x3c(%ebp)
  802bbb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bbe:	29 d0                	sub    %edx,%eax
  802bc0:	c1 e8 0c             	shr    $0xc,%eax
  802bc3:	83 ec 0c             	sub    $0xc,%esp
  802bc6:	50                   	push   %eax
  802bc7:	e8 37 e7 ff ff       	call   801303 <sbrk>
  802bcc:	83 c4 10             	add    $0x10,%esp
  802bcf:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802bd2:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bd6:	75 0a                	jne    802be2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdd:	e9 ae 00 00 00       	jmp    802c90 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802be2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802be9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bef:	01 d0                	add    %edx,%eax
  802bf1:	48                   	dec    %eax
  802bf2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bf5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bfd:	f7 75 b8             	divl   -0x48(%ebp)
  802c00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c03:	29 d0                	sub    %edx,%eax
  802c05:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c0b:	01 d0                	add    %edx,%eax
  802c0d:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c12:	a1 40 50 80 00       	mov    0x805040,%eax
  802c17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c1d:	83 ec 0c             	sub    $0xc,%esp
  802c20:	68 38 44 80 00       	push   $0x804438
  802c25:	e8 3f d9 ff ff       	call   800569 <cprintf>
  802c2a:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c2d:	83 ec 08             	sub    $0x8,%esp
  802c30:	ff 75 bc             	pushl  -0x44(%ebp)
  802c33:	68 3d 44 80 00       	push   $0x80443d
  802c38:	e8 2c d9 ff ff       	call   800569 <cprintf>
  802c3d:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c40:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c47:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c4d:	01 d0                	add    %edx,%eax
  802c4f:	48                   	dec    %eax
  802c50:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c53:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c56:	ba 00 00 00 00       	mov    $0x0,%edx
  802c5b:	f7 75 b0             	divl   -0x50(%ebp)
  802c5e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c61:	29 d0                	sub    %edx,%eax
  802c63:	83 ec 04             	sub    $0x4,%esp
  802c66:	6a 01                	push   $0x1
  802c68:	50                   	push   %eax
  802c69:	ff 75 bc             	pushl  -0x44(%ebp)
  802c6c:	e8 51 f5 ff ff       	call   8021c2 <set_block_data>
  802c71:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c74:	83 ec 0c             	sub    $0xc,%esp
  802c77:	ff 75 bc             	pushl  -0x44(%ebp)
  802c7a:	e8 36 04 00 00       	call   8030b5 <free_block>
  802c7f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c82:	83 ec 0c             	sub    $0xc,%esp
  802c85:	ff 75 08             	pushl  0x8(%ebp)
  802c88:	e8 20 fa ff ff       	call   8026ad <alloc_block_BF>
  802c8d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c90:	c9                   	leave  
  802c91:	c3                   	ret    

00802c92 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c92:	55                   	push   %ebp
  802c93:	89 e5                	mov    %esp,%ebp
  802c95:	53                   	push   %ebx
  802c96:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ca0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ca7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cab:	74 1e                	je     802ccb <merging+0x39>
  802cad:	ff 75 08             	pushl  0x8(%ebp)
  802cb0:	e8 bc f1 ff ff       	call   801e71 <get_block_size>
  802cb5:	83 c4 04             	add    $0x4,%esp
  802cb8:	89 c2                	mov    %eax,%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cc2:	75 07                	jne    802ccb <merging+0x39>
		prev_is_free = 1;
  802cc4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ccf:	74 1e                	je     802cef <merging+0x5d>
  802cd1:	ff 75 10             	pushl  0x10(%ebp)
  802cd4:	e8 98 f1 ff ff       	call   801e71 <get_block_size>
  802cd9:	83 c4 04             	add    $0x4,%esp
  802cdc:	89 c2                	mov    %eax,%edx
  802cde:	8b 45 10             	mov    0x10(%ebp),%eax
  802ce1:	01 d0                	add    %edx,%eax
  802ce3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ce6:	75 07                	jne    802cef <merging+0x5d>
		next_is_free = 1;
  802ce8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf3:	0f 84 cc 00 00 00    	je     802dc5 <merging+0x133>
  802cf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cfd:	0f 84 c2 00 00 00    	je     802dc5 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d03:	ff 75 08             	pushl  0x8(%ebp)
  802d06:	e8 66 f1 ff ff       	call   801e71 <get_block_size>
  802d0b:	83 c4 04             	add    $0x4,%esp
  802d0e:	89 c3                	mov    %eax,%ebx
  802d10:	ff 75 10             	pushl  0x10(%ebp)
  802d13:	e8 59 f1 ff ff       	call   801e71 <get_block_size>
  802d18:	83 c4 04             	add    $0x4,%esp
  802d1b:	01 c3                	add    %eax,%ebx
  802d1d:	ff 75 0c             	pushl  0xc(%ebp)
  802d20:	e8 4c f1 ff ff       	call   801e71 <get_block_size>
  802d25:	83 c4 04             	add    $0x4,%esp
  802d28:	01 d8                	add    %ebx,%eax
  802d2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d2d:	6a 00                	push   $0x0
  802d2f:	ff 75 ec             	pushl  -0x14(%ebp)
  802d32:	ff 75 08             	pushl  0x8(%ebp)
  802d35:	e8 88 f4 ff ff       	call   8021c2 <set_block_data>
  802d3a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d41:	75 17                	jne    802d5a <merging+0xc8>
  802d43:	83 ec 04             	sub    $0x4,%esp
  802d46:	68 73 43 80 00       	push   $0x804373
  802d4b:	68 7d 01 00 00       	push   $0x17d
  802d50:	68 91 43 80 00       	push   $0x804391
  802d55:	e8 b0 0b 00 00       	call   80390a <_panic>
  802d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 10                	je     802d73 <merging+0xe1>
  802d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d66:	8b 00                	mov    (%eax),%eax
  802d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d6b:	8b 52 04             	mov    0x4(%edx),%edx
  802d6e:	89 50 04             	mov    %edx,0x4(%eax)
  802d71:	eb 0b                	jmp    802d7e <merging+0xec>
  802d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	a3 30 50 80 00       	mov    %eax,0x805030
  802d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 0f                	je     802d97 <merging+0x105>
  802d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8b:	8b 40 04             	mov    0x4(%eax),%eax
  802d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d91:	8b 12                	mov    (%edx),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 0a                	jmp    802da1 <merging+0x10f>
  802d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db4:	a1 38 50 80 00       	mov    0x805038,%eax
  802db9:	48                   	dec    %eax
  802dba:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802dbf:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dc0:	e9 ea 02 00 00       	jmp    8030af <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc9:	74 3b                	je     802e06 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802dcb:	83 ec 0c             	sub    $0xc,%esp
  802dce:	ff 75 08             	pushl  0x8(%ebp)
  802dd1:	e8 9b f0 ff ff       	call   801e71 <get_block_size>
  802dd6:	83 c4 10             	add    $0x10,%esp
  802dd9:	89 c3                	mov    %eax,%ebx
  802ddb:	83 ec 0c             	sub    $0xc,%esp
  802dde:	ff 75 10             	pushl  0x10(%ebp)
  802de1:	e8 8b f0 ff ff       	call   801e71 <get_block_size>
  802de6:	83 c4 10             	add    $0x10,%esp
  802de9:	01 d8                	add    %ebx,%eax
  802deb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	6a 00                	push   $0x0
  802df3:	ff 75 e8             	pushl  -0x18(%ebp)
  802df6:	ff 75 08             	pushl  0x8(%ebp)
  802df9:	e8 c4 f3 ff ff       	call   8021c2 <set_block_data>
  802dfe:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e01:	e9 a9 02 00 00       	jmp    8030af <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0a:	0f 84 2d 01 00 00    	je     802f3d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e10:	83 ec 0c             	sub    $0xc,%esp
  802e13:	ff 75 10             	pushl  0x10(%ebp)
  802e16:	e8 56 f0 ff ff       	call   801e71 <get_block_size>
  802e1b:	83 c4 10             	add    $0x10,%esp
  802e1e:	89 c3                	mov    %eax,%ebx
  802e20:	83 ec 0c             	sub    $0xc,%esp
  802e23:	ff 75 0c             	pushl  0xc(%ebp)
  802e26:	e8 46 f0 ff ff       	call   801e71 <get_block_size>
  802e2b:	83 c4 10             	add    $0x10,%esp
  802e2e:	01 d8                	add    %ebx,%eax
  802e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e33:	83 ec 04             	sub    $0x4,%esp
  802e36:	6a 00                	push   $0x0
  802e38:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e3b:	ff 75 10             	pushl  0x10(%ebp)
  802e3e:	e8 7f f3 ff ff       	call   8021c2 <set_block_data>
  802e43:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e46:	8b 45 10             	mov    0x10(%ebp),%eax
  802e49:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e50:	74 06                	je     802e58 <merging+0x1c6>
  802e52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e56:	75 17                	jne    802e6f <merging+0x1dd>
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	68 4c 44 80 00       	push   $0x80444c
  802e60:	68 8d 01 00 00       	push   $0x18d
  802e65:	68 91 43 80 00       	push   $0x804391
  802e6a:	e8 9b 0a 00 00       	call   80390a <_panic>
  802e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e72:	8b 50 04             	mov    0x4(%eax),%edx
  802e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e78:	89 50 04             	mov    %edx,0x4(%eax)
  802e7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e86:	8b 40 04             	mov    0x4(%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 0d                	je     802e9a <merging+0x208>
  802e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	eb 08                	jmp    802ea2 <merging+0x210>
  802e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea8:	89 50 04             	mov    %edx,0x4(%eax)
  802eab:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb0:	40                   	inc    %eax
  802eb1:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802eb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eba:	75 17                	jne    802ed3 <merging+0x241>
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	68 73 43 80 00       	push   $0x804373
  802ec4:	68 8e 01 00 00       	push   $0x18e
  802ec9:	68 91 43 80 00       	push   $0x804391
  802ece:	e8 37 0a 00 00       	call   80390a <_panic>
  802ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	74 10                	je     802eec <merging+0x25a>
  802edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee4:	8b 52 04             	mov    0x4(%edx),%edx
  802ee7:	89 50 04             	mov    %edx,0x4(%eax)
  802eea:	eb 0b                	jmp    802ef7 <merging+0x265>
  802eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eef:	8b 40 04             	mov    0x4(%eax),%eax
  802ef2:	a3 30 50 80 00       	mov    %eax,0x805030
  802ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 0f                	je     802f10 <merging+0x27e>
  802f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f0a:	8b 12                	mov    (%edx),%edx
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	eb 0a                	jmp    802f1a <merging+0x288>
  802f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2d:	a1 38 50 80 00       	mov    0x805038,%eax
  802f32:	48                   	dec    %eax
  802f33:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f38:	e9 72 01 00 00       	jmp    8030af <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  802f40:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f47:	74 79                	je     802fc2 <merging+0x330>
  802f49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4d:	74 73                	je     802fc2 <merging+0x330>
  802f4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f53:	74 06                	je     802f5b <merging+0x2c9>
  802f55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f59:	75 17                	jne    802f72 <merging+0x2e0>
  802f5b:	83 ec 04             	sub    $0x4,%esp
  802f5e:	68 04 44 80 00       	push   $0x804404
  802f63:	68 94 01 00 00       	push   $0x194
  802f68:	68 91 43 80 00       	push   $0x804391
  802f6d:	e8 98 09 00 00       	call   80390a <_panic>
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 10                	mov    (%eax),%edx
  802f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0b                	je     802f90 <merging+0x2fe>
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f96:	89 10                	mov    %edx,(%eax)
  802f98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	75 08                	jne    802fb2 <merging+0x320>
  802faa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fad:	a3 30 50 80 00       	mov    %eax,0x805030
  802fb2:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb7:	40                   	inc    %eax
  802fb8:	a3 38 50 80 00       	mov    %eax,0x805038
  802fbd:	e9 ce 00 00 00       	jmp    803090 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc6:	74 65                	je     80302d <merging+0x39b>
  802fc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fcc:	75 17                	jne    802fe5 <merging+0x353>
  802fce:	83 ec 04             	sub    $0x4,%esp
  802fd1:	68 e0 43 80 00       	push   $0x8043e0
  802fd6:	68 95 01 00 00       	push   $0x195
  802fdb:	68 91 43 80 00       	push   $0x804391
  802fe0:	e8 25 09 00 00       	call   80390a <_panic>
  802fe5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fee:	89 50 04             	mov    %edx,0x4(%eax)
  802ff1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 0c                	je     803007 <merging+0x375>
  802ffb:	a1 30 50 80 00       	mov    0x805030,%eax
  803000:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803003:	89 10                	mov    %edx,(%eax)
  803005:	eb 08                	jmp    80300f <merging+0x37d>
  803007:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80300f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803012:	a3 30 50 80 00       	mov    %eax,0x805030
  803017:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803020:	a1 38 50 80 00       	mov    0x805038,%eax
  803025:	40                   	inc    %eax
  803026:	a3 38 50 80 00       	mov    %eax,0x805038
  80302b:	eb 63                	jmp    803090 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80302d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803031:	75 17                	jne    80304a <merging+0x3b8>
  803033:	83 ec 04             	sub    $0x4,%esp
  803036:	68 ac 43 80 00       	push   $0x8043ac
  80303b:	68 98 01 00 00       	push   $0x198
  803040:	68 91 43 80 00       	push   $0x804391
  803045:	e8 c0 08 00 00       	call   80390a <_panic>
  80304a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803050:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803053:	89 10                	mov    %edx,(%eax)
  803055:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0d                	je     80306b <merging+0x3d9>
  80305e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803063:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	eb 08                	jmp    803073 <merging+0x3e1>
  80306b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306e:	a3 30 50 80 00       	mov    %eax,0x805030
  803073:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803076:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80307b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803085:	a1 38 50 80 00       	mov    0x805038,%eax
  80308a:	40                   	inc    %eax
  80308b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803090:	83 ec 0c             	sub    $0xc,%esp
  803093:	ff 75 10             	pushl  0x10(%ebp)
  803096:	e8 d6 ed ff ff       	call   801e71 <get_block_size>
  80309b:	83 c4 10             	add    $0x10,%esp
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	6a 00                	push   $0x0
  8030a3:	50                   	push   %eax
  8030a4:	ff 75 10             	pushl  0x10(%ebp)
  8030a7:	e8 16 f1 ff ff       	call   8021c2 <set_block_data>
  8030ac:	83 c4 10             	add    $0x10,%esp
	}
}
  8030af:	90                   	nop
  8030b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030b3:	c9                   	leave  
  8030b4:	c3                   	ret    

008030b5 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
  8030b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030c3:	a1 30 50 80 00       	mov    0x805030,%eax
  8030c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030cb:	73 1b                	jae    8030e8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030cd:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d2:	83 ec 04             	sub    $0x4,%esp
  8030d5:	ff 75 08             	pushl  0x8(%ebp)
  8030d8:	6a 00                	push   $0x0
  8030da:	50                   	push   %eax
  8030db:	e8 b2 fb ff ff       	call   802c92 <merging>
  8030e0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030e3:	e9 8b 00 00 00       	jmp    803173 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f0:	76 18                	jbe    80310a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	ff 75 08             	pushl  0x8(%ebp)
  8030fd:	50                   	push   %eax
  8030fe:	6a 00                	push   $0x0
  803100:	e8 8d fb ff ff       	call   802c92 <merging>
  803105:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803108:	eb 69                	jmp    803173 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80310a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80310f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803112:	eb 39                	jmp    80314d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311a:	73 29                	jae    803145 <free_block+0x90>
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	3b 45 08             	cmp    0x8(%ebp),%eax
  803124:	76 1f                	jbe    803145 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	ff 75 08             	pushl  0x8(%ebp)
  803134:	ff 75 f0             	pushl  -0x10(%ebp)
  803137:	ff 75 f4             	pushl  -0xc(%ebp)
  80313a:	e8 53 fb ff ff       	call   802c92 <merging>
  80313f:	83 c4 10             	add    $0x10,%esp
			break;
  803142:	90                   	nop
		}
	}
}
  803143:	eb 2e                	jmp    803173 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803145:	a1 34 50 80 00       	mov    0x805034,%eax
  80314a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803151:	74 07                	je     80315a <free_block+0xa5>
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	eb 05                	jmp    80315f <free_block+0xaa>
  80315a:	b8 00 00 00 00       	mov    $0x0,%eax
  80315f:	a3 34 50 80 00       	mov    %eax,0x805034
  803164:	a1 34 50 80 00       	mov    0x805034,%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	75 a7                	jne    803114 <free_block+0x5f>
  80316d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803171:	75 a1                	jne    803114 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803173:	90                   	nop
  803174:	c9                   	leave  
  803175:	c3                   	ret    

00803176 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803176:	55                   	push   %ebp
  803177:	89 e5                	mov    %esp,%ebp
  803179:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80317c:	ff 75 08             	pushl  0x8(%ebp)
  80317f:	e8 ed ec ff ff       	call   801e71 <get_block_size>
  803184:	83 c4 04             	add    $0x4,%esp
  803187:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80318a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803191:	eb 17                	jmp    8031aa <copy_data+0x34>
  803193:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803196:	8b 45 0c             	mov    0xc(%ebp),%eax
  803199:	01 c2                	add    %eax,%edx
  80319b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	01 c8                	add    %ecx,%eax
  8031a3:	8a 00                	mov    (%eax),%al
  8031a5:	88 02                	mov    %al,(%edx)
  8031a7:	ff 45 fc             	incl   -0x4(%ebp)
  8031aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031b0:	72 e1                	jb     803193 <copy_data+0x1d>
}
  8031b2:	90                   	nop
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    

008031b5 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
  8031b8:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bf:	75 23                	jne    8031e4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031c5:	74 13                	je     8031da <realloc_block_FF+0x25>
  8031c7:	83 ec 0c             	sub    $0xc,%esp
  8031ca:	ff 75 0c             	pushl  0xc(%ebp)
  8031cd:	e8 1f f0 ff ff       	call   8021f1 <alloc_block_FF>
  8031d2:	83 c4 10             	add    $0x10,%esp
  8031d5:	e9 f4 06 00 00       	jmp    8038ce <realloc_block_FF+0x719>
		return NULL;
  8031da:	b8 00 00 00 00       	mov    $0x0,%eax
  8031df:	e9 ea 06 00 00       	jmp    8038ce <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031e8:	75 18                	jne    803202 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031ea:	83 ec 0c             	sub    $0xc,%esp
  8031ed:	ff 75 08             	pushl  0x8(%ebp)
  8031f0:	e8 c0 fe ff ff       	call   8030b5 <free_block>
  8031f5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fd:	e9 cc 06 00 00       	jmp    8038ce <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803202:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803206:	77 07                	ja     80320f <realloc_block_FF+0x5a>
  803208:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80320f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803212:	83 e0 01             	and    $0x1,%eax
  803215:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321b:	83 c0 08             	add    $0x8,%eax
  80321e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803221:	83 ec 0c             	sub    $0xc,%esp
  803224:	ff 75 08             	pushl  0x8(%ebp)
  803227:	e8 45 ec ff ff       	call   801e71 <get_block_size>
  80322c:	83 c4 10             	add    $0x10,%esp
  80322f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803235:	83 e8 08             	sub    $0x8,%eax
  803238:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	83 e8 04             	sub    $0x4,%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	83 e0 fe             	and    $0xfffffffe,%eax
  803246:	89 c2                	mov    %eax,%edx
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	01 d0                	add    %edx,%eax
  80324d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803250:	83 ec 0c             	sub    $0xc,%esp
  803253:	ff 75 e4             	pushl  -0x1c(%ebp)
  803256:	e8 16 ec ff ff       	call   801e71 <get_block_size>
  80325b:	83 c4 10             	add    $0x10,%esp
  80325e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803261:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803264:	83 e8 08             	sub    $0x8,%eax
  803267:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80326a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803270:	75 08                	jne    80327a <realloc_block_FF+0xc5>
	{
		 return va;
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	e9 54 06 00 00       	jmp    8038ce <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80327a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803280:	0f 83 e5 03 00 00    	jae    80366b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	2b 45 0c             	sub    0xc(%ebp),%eax
  80328c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80328f:	83 ec 0c             	sub    $0xc,%esp
  803292:	ff 75 e4             	pushl  -0x1c(%ebp)
  803295:	e8 f0 eb ff ff       	call   801e8a <is_free_block>
  80329a:	83 c4 10             	add    $0x10,%esp
  80329d:	84 c0                	test   %al,%al
  80329f:	0f 84 3b 01 00 00    	je     8033e0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ab:	01 d0                	add    %edx,%eax
  8032ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032b0:	83 ec 04             	sub    $0x4,%esp
  8032b3:	6a 01                	push   $0x1
  8032b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b8:	ff 75 08             	pushl  0x8(%ebp)
  8032bb:	e8 02 ef ff ff       	call   8021c2 <set_block_data>
  8032c0:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	83 e8 04             	sub    $0x4,%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	83 e0 fe             	and    $0xfffffffe,%eax
  8032ce:	89 c2                	mov    %eax,%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	01 d0                	add    %edx,%eax
  8032d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	6a 00                	push   $0x0
  8032dd:	ff 75 cc             	pushl  -0x34(%ebp)
  8032e0:	ff 75 c8             	pushl  -0x38(%ebp)
  8032e3:	e8 da ee ff ff       	call   8021c2 <set_block_data>
  8032e8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032ef:	74 06                	je     8032f7 <realloc_block_FF+0x142>
  8032f1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032f5:	75 17                	jne    80330e <realloc_block_FF+0x159>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 04 44 80 00       	push   $0x804404
  8032ff:	68 f6 01 00 00       	push   $0x1f6
  803304:	68 91 43 80 00       	push   $0x804391
  803309:	e8 fc 05 00 00       	call   80390a <_panic>
  80330e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803311:	8b 10                	mov    (%eax),%edx
  803313:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803316:	89 10                	mov    %edx,(%eax)
  803318:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	85 c0                	test   %eax,%eax
  80331f:	74 0b                	je     80332c <realloc_block_FF+0x177>
  803321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333a:	89 50 04             	mov    %edx,0x4(%eax)
  80333d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	75 08                	jne    80334e <realloc_block_FF+0x199>
  803346:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803349:	a3 30 50 80 00       	mov    %eax,0x805030
  80334e:	a1 38 50 80 00       	mov    0x805038,%eax
  803353:	40                   	inc    %eax
  803354:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803359:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80335d:	75 17                	jne    803376 <realloc_block_FF+0x1c1>
  80335f:	83 ec 04             	sub    $0x4,%esp
  803362:	68 73 43 80 00       	push   $0x804373
  803367:	68 f7 01 00 00       	push   $0x1f7
  80336c:	68 91 43 80 00       	push   $0x804391
  803371:	e8 94 05 00 00       	call   80390a <_panic>
  803376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 10                	je     80338f <realloc_block_FF+0x1da>
  80337f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803387:	8b 52 04             	mov    0x4(%edx),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	eb 0b                	jmp    80339a <realloc_block_FF+0x1e5>
  80338f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803392:	8b 40 04             	mov    0x4(%eax),%eax
  803395:	a3 30 50 80 00       	mov    %eax,0x805030
  80339a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	74 0f                	je     8033b3 <realloc_block_FF+0x1fe>
  8033a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a7:	8b 40 04             	mov    0x4(%eax),%eax
  8033aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ad:	8b 12                	mov    (%edx),%edx
  8033af:	89 10                	mov    %edx,(%eax)
  8033b1:	eb 0a                	jmp    8033bd <realloc_block_FF+0x208>
  8033b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d5:	48                   	dec    %eax
  8033d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8033db:	e9 83 02 00 00       	jmp    803663 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033e0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033e4:	0f 86 69 02 00 00    	jbe    803653 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033ea:	83 ec 04             	sub    $0x4,%esp
  8033ed:	6a 01                	push   $0x1
  8033ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8033f2:	ff 75 08             	pushl  0x8(%ebp)
  8033f5:	e8 c8 ed ff ff       	call   8021c2 <set_block_data>
  8033fa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	83 e8 04             	sub    $0x4,%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	83 e0 fe             	and    $0xfffffffe,%eax
  803408:	89 c2                	mov    %eax,%edx
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	01 d0                	add    %edx,%eax
  80340f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803412:	a1 38 50 80 00       	mov    0x805038,%eax
  803417:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80341a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80341e:	75 68                	jne    803488 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803420:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803424:	75 17                	jne    80343d <realloc_block_FF+0x288>
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 ac 43 80 00       	push   $0x8043ac
  80342e:	68 06 02 00 00       	push   $0x206
  803433:	68 91 43 80 00       	push   $0x804391
  803438:	e8 cd 04 00 00       	call   80390a <_panic>
  80343d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803443:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803446:	89 10                	mov    %edx,(%eax)
  803448:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 0d                	je     80345e <realloc_block_FF+0x2a9>
  803451:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803456:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	eb 08                	jmp    803466 <realloc_block_FF+0x2b1>
  80345e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803461:	a3 30 50 80 00       	mov    %eax,0x805030
  803466:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803469:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80346e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803478:	a1 38 50 80 00       	mov    0x805038,%eax
  80347d:	40                   	inc    %eax
  80347e:	a3 38 50 80 00       	mov    %eax,0x805038
  803483:	e9 b0 01 00 00       	jmp    803638 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803488:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80348d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803490:	76 68                	jbe    8034fa <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803492:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803496:	75 17                	jne    8034af <realloc_block_FF+0x2fa>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 ac 43 80 00       	push   $0x8043ac
  8034a0:	68 0b 02 00 00       	push   $0x20b
  8034a5:	68 91 43 80 00       	push   $0x804391
  8034aa:	e8 5b 04 00 00       	call   80390a <_panic>
  8034af:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 0d                	je     8034d0 <realloc_block_FF+0x31b>
  8034c3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ce:	eb 08                	jmp    8034d8 <realloc_block_FF+0x323>
  8034d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ef:	40                   	inc    %eax
  8034f0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f5:	e9 3e 01 00 00       	jmp    803638 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034ff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803502:	73 68                	jae    80356c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803504:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803508:	75 17                	jne    803521 <realloc_block_FF+0x36c>
  80350a:	83 ec 04             	sub    $0x4,%esp
  80350d:	68 e0 43 80 00       	push   $0x8043e0
  803512:	68 10 02 00 00       	push   $0x210
  803517:	68 91 43 80 00       	push   $0x804391
  80351c:	e8 e9 03 00 00       	call   80390a <_panic>
  803521:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803527:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352a:	89 50 04             	mov    %edx,0x4(%eax)
  80352d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803530:	8b 40 04             	mov    0x4(%eax),%eax
  803533:	85 c0                	test   %eax,%eax
  803535:	74 0c                	je     803543 <realloc_block_FF+0x38e>
  803537:	a1 30 50 80 00       	mov    0x805030,%eax
  80353c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80353f:	89 10                	mov    %edx,(%eax)
  803541:	eb 08                	jmp    80354b <realloc_block_FF+0x396>
  803543:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803546:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80354b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354e:	a3 30 50 80 00       	mov    %eax,0x805030
  803553:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355c:	a1 38 50 80 00       	mov    0x805038,%eax
  803561:	40                   	inc    %eax
  803562:	a3 38 50 80 00       	mov    %eax,0x805038
  803567:	e9 cc 00 00 00       	jmp    803638 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80356c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803573:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80357b:	e9 8a 00 00 00       	jmp    80360a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803586:	73 7a                	jae    803602 <realloc_block_FF+0x44d>
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803590:	73 70                	jae    803602 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803596:	74 06                	je     80359e <realloc_block_FF+0x3e9>
  803598:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80359c:	75 17                	jne    8035b5 <realloc_block_FF+0x400>
  80359e:	83 ec 04             	sub    $0x4,%esp
  8035a1:	68 04 44 80 00       	push   $0x804404
  8035a6:	68 1a 02 00 00       	push   $0x21a
  8035ab:	68 91 43 80 00       	push   $0x804391
  8035b0:	e8 55 03 00 00       	call   80390a <_panic>
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 10                	mov    (%eax),%edx
  8035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bd:	89 10                	mov    %edx,(%eax)
  8035bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	74 0b                	je     8035d3 <realloc_block_FF+0x41e>
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d0:	89 50 04             	mov    %edx,0x4(%eax)
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e1:	89 50 04             	mov    %edx,0x4(%eax)
  8035e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	75 08                	jne    8035f5 <realloc_block_FF+0x440>
  8035ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fa:	40                   	inc    %eax
  8035fb:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803600:	eb 36                	jmp    803638 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803602:	a1 34 50 80 00       	mov    0x805034,%eax
  803607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360e:	74 07                	je     803617 <realloc_block_FF+0x462>
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	eb 05                	jmp    80361c <realloc_block_FF+0x467>
  803617:	b8 00 00 00 00       	mov    $0x0,%eax
  80361c:	a3 34 50 80 00       	mov    %eax,0x805034
  803621:	a1 34 50 80 00       	mov    0x805034,%eax
  803626:	85 c0                	test   %eax,%eax
  803628:	0f 85 52 ff ff ff    	jne    803580 <realloc_block_FF+0x3cb>
  80362e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803632:	0f 85 48 ff ff ff    	jne    803580 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803638:	83 ec 04             	sub    $0x4,%esp
  80363b:	6a 00                	push   $0x0
  80363d:	ff 75 d8             	pushl  -0x28(%ebp)
  803640:	ff 75 d4             	pushl  -0x2c(%ebp)
  803643:	e8 7a eb ff ff       	call   8021c2 <set_block_data>
  803648:	83 c4 10             	add    $0x10,%esp
				return va;
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	e9 7b 02 00 00       	jmp    8038ce <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803653:	83 ec 0c             	sub    $0xc,%esp
  803656:	68 81 44 80 00       	push   $0x804481
  80365b:	e8 09 cf ff ff       	call   800569 <cprintf>
  803660:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	e9 63 02 00 00       	jmp    8038ce <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80366b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803671:	0f 86 4d 02 00 00    	jbe    8038c4 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803677:	83 ec 0c             	sub    $0xc,%esp
  80367a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80367d:	e8 08 e8 ff ff       	call   801e8a <is_free_block>
  803682:	83 c4 10             	add    $0x10,%esp
  803685:	84 c0                	test   %al,%al
  803687:	0f 84 37 02 00 00    	je     8038c4 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80368d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803690:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803693:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803696:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803699:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80369c:	76 38                	jbe    8036d6 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80369e:	83 ec 0c             	sub    $0xc,%esp
  8036a1:	ff 75 08             	pushl  0x8(%ebp)
  8036a4:	e8 0c fa ff ff       	call   8030b5 <free_block>
  8036a9:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036ac:	83 ec 0c             	sub    $0xc,%esp
  8036af:	ff 75 0c             	pushl  0xc(%ebp)
  8036b2:	e8 3a eb ff ff       	call   8021f1 <alloc_block_FF>
  8036b7:	83 c4 10             	add    $0x10,%esp
  8036ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036bd:	83 ec 08             	sub    $0x8,%esp
  8036c0:	ff 75 c0             	pushl  -0x40(%ebp)
  8036c3:	ff 75 08             	pushl  0x8(%ebp)
  8036c6:	e8 ab fa ff ff       	call   803176 <copy_data>
  8036cb:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036d1:	e9 f8 01 00 00       	jmp    8038ce <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d9:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036df:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036e3:	0f 87 a0 00 00 00    	ja     803789 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ed:	75 17                	jne    803706 <realloc_block_FF+0x551>
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	68 73 43 80 00       	push   $0x804373
  8036f7:	68 38 02 00 00       	push   $0x238
  8036fc:	68 91 43 80 00       	push   $0x804391
  803701:	e8 04 02 00 00       	call   80390a <_panic>
  803706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	85 c0                	test   %eax,%eax
  80370d:	74 10                	je     80371f <realloc_block_FF+0x56a>
  80370f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803712:	8b 00                	mov    (%eax),%eax
  803714:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803717:	8b 52 04             	mov    0x4(%edx),%edx
  80371a:	89 50 04             	mov    %edx,0x4(%eax)
  80371d:	eb 0b                	jmp    80372a <realloc_block_FF+0x575>
  80371f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803722:	8b 40 04             	mov    0x4(%eax),%eax
  803725:	a3 30 50 80 00       	mov    %eax,0x805030
  80372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372d:	8b 40 04             	mov    0x4(%eax),%eax
  803730:	85 c0                	test   %eax,%eax
  803732:	74 0f                	je     803743 <realloc_block_FF+0x58e>
  803734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803737:	8b 40 04             	mov    0x4(%eax),%eax
  80373a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373d:	8b 12                	mov    (%edx),%edx
  80373f:	89 10                	mov    %edx,(%eax)
  803741:	eb 0a                	jmp    80374d <realloc_block_FF+0x598>
  803743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80374d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803759:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803760:	a1 38 50 80 00       	mov    0x805038,%eax
  803765:	48                   	dec    %eax
  803766:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80376b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80376e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803771:	01 d0                	add    %edx,%eax
  803773:	83 ec 04             	sub    $0x4,%esp
  803776:	6a 01                	push   $0x1
  803778:	50                   	push   %eax
  803779:	ff 75 08             	pushl  0x8(%ebp)
  80377c:	e8 41 ea ff ff       	call   8021c2 <set_block_data>
  803781:	83 c4 10             	add    $0x10,%esp
  803784:	e9 36 01 00 00       	jmp    8038bf <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803789:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80378c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80378f:	01 d0                	add    %edx,%eax
  803791:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803794:	83 ec 04             	sub    $0x4,%esp
  803797:	6a 01                	push   $0x1
  803799:	ff 75 f0             	pushl  -0x10(%ebp)
  80379c:	ff 75 08             	pushl  0x8(%ebp)
  80379f:	e8 1e ea ff ff       	call   8021c2 <set_block_data>
  8037a4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	83 e8 04             	sub    $0x4,%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	83 e0 fe             	and    $0xfffffffe,%eax
  8037b2:	89 c2                	mov    %eax,%edx
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	01 d0                	add    %edx,%eax
  8037b9:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c0:	74 06                	je     8037c8 <realloc_block_FF+0x613>
  8037c2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037c6:	75 17                	jne    8037df <realloc_block_FF+0x62a>
  8037c8:	83 ec 04             	sub    $0x4,%esp
  8037cb:	68 04 44 80 00       	push   $0x804404
  8037d0:	68 44 02 00 00       	push   $0x244
  8037d5:	68 91 43 80 00       	push   $0x804391
  8037da:	e8 2b 01 00 00       	call   80390a <_panic>
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	8b 10                	mov    (%eax),%edx
  8037e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e7:	89 10                	mov    %edx,(%eax)
  8037e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ec:	8b 00                	mov    (%eax),%eax
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	74 0b                	je     8037fd <realloc_block_FF+0x648>
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037fa:	89 50 04             	mov    %edx,0x4(%eax)
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803803:	89 10                	mov    %edx,(%eax)
  803805:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	85 c0                	test   %eax,%eax
  803815:	75 08                	jne    80381f <realloc_block_FF+0x66a>
  803817:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80381a:	a3 30 50 80 00       	mov    %eax,0x805030
  80381f:	a1 38 50 80 00       	mov    0x805038,%eax
  803824:	40                   	inc    %eax
  803825:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80382a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80382e:	75 17                	jne    803847 <realloc_block_FF+0x692>
  803830:	83 ec 04             	sub    $0x4,%esp
  803833:	68 73 43 80 00       	push   $0x804373
  803838:	68 45 02 00 00       	push   $0x245
  80383d:	68 91 43 80 00       	push   $0x804391
  803842:	e8 c3 00 00 00       	call   80390a <_panic>
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 10                	je     803860 <realloc_block_FF+0x6ab>
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	8b 00                	mov    (%eax),%eax
  803855:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803858:	8b 52 04             	mov    0x4(%edx),%edx
  80385b:	89 50 04             	mov    %edx,0x4(%eax)
  80385e:	eb 0b                	jmp    80386b <realloc_block_FF+0x6b6>
  803860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803863:	8b 40 04             	mov    0x4(%eax),%eax
  803866:	a3 30 50 80 00       	mov    %eax,0x805030
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	8b 40 04             	mov    0x4(%eax),%eax
  803871:	85 c0                	test   %eax,%eax
  803873:	74 0f                	je     803884 <realloc_block_FF+0x6cf>
  803875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803878:	8b 40 04             	mov    0x4(%eax),%eax
  80387b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387e:	8b 12                	mov    (%edx),%edx
  803880:	89 10                	mov    %edx,(%eax)
  803882:	eb 0a                	jmp    80388e <realloc_block_FF+0x6d9>
  803884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803887:	8b 00                	mov    (%eax),%eax
  803889:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80388e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803891:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a6:	48                   	dec    %eax
  8038a7:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038ac:	83 ec 04             	sub    $0x4,%esp
  8038af:	6a 00                	push   $0x0
  8038b1:	ff 75 bc             	pushl  -0x44(%ebp)
  8038b4:	ff 75 b8             	pushl  -0x48(%ebp)
  8038b7:	e8 06 e9 ff ff       	call   8021c2 <set_block_data>
  8038bc:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	eb 0a                	jmp    8038ce <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038c4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038ce:	c9                   	leave  
  8038cf:	c3                   	ret    

008038d0 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038d0:	55                   	push   %ebp
  8038d1:	89 e5                	mov    %esp,%ebp
  8038d3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038d6:	83 ec 04             	sub    $0x4,%esp
  8038d9:	68 88 44 80 00       	push   $0x804488
  8038de:	68 58 02 00 00       	push   $0x258
  8038e3:	68 91 43 80 00       	push   $0x804391
  8038e8:	e8 1d 00 00 00       	call   80390a <_panic>

008038ed <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038ed:	55                   	push   %ebp
  8038ee:	89 e5                	mov    %esp,%ebp
  8038f0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038f3:	83 ec 04             	sub    $0x4,%esp
  8038f6:	68 b0 44 80 00       	push   $0x8044b0
  8038fb:	68 61 02 00 00       	push   $0x261
  803900:	68 91 43 80 00       	push   $0x804391
  803905:	e8 00 00 00 00       	call   80390a <_panic>

0080390a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80390a:	55                   	push   %ebp
  80390b:	89 e5                	mov    %esp,%ebp
  80390d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803910:	8d 45 10             	lea    0x10(%ebp),%eax
  803913:	83 c0 04             	add    $0x4,%eax
  803916:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803919:	a1 60 50 98 00       	mov    0x985060,%eax
  80391e:	85 c0                	test   %eax,%eax
  803920:	74 16                	je     803938 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803922:	a1 60 50 98 00       	mov    0x985060,%eax
  803927:	83 ec 08             	sub    $0x8,%esp
  80392a:	50                   	push   %eax
  80392b:	68 d8 44 80 00       	push   $0x8044d8
  803930:	e8 34 cc ff ff       	call   800569 <cprintf>
  803935:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803938:	a1 00 50 80 00       	mov    0x805000,%eax
  80393d:	ff 75 0c             	pushl  0xc(%ebp)
  803940:	ff 75 08             	pushl  0x8(%ebp)
  803943:	50                   	push   %eax
  803944:	68 dd 44 80 00       	push   $0x8044dd
  803949:	e8 1b cc ff ff       	call   800569 <cprintf>
  80394e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803951:	8b 45 10             	mov    0x10(%ebp),%eax
  803954:	83 ec 08             	sub    $0x8,%esp
  803957:	ff 75 f4             	pushl  -0xc(%ebp)
  80395a:	50                   	push   %eax
  80395b:	e8 9e cb ff ff       	call   8004fe <vcprintf>
  803960:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803963:	83 ec 08             	sub    $0x8,%esp
  803966:	6a 00                	push   $0x0
  803968:	68 f9 44 80 00       	push   $0x8044f9
  80396d:	e8 8c cb ff ff       	call   8004fe <vcprintf>
  803972:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803975:	e8 0d cb ff ff       	call   800487 <exit>

	// should not return here
	while (1) ;
  80397a:	eb fe                	jmp    80397a <_panic+0x70>

0080397c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80397c:	55                   	push   %ebp
  80397d:	89 e5                	mov    %esp,%ebp
  80397f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803982:	a1 20 50 80 00       	mov    0x805020,%eax
  803987:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80398d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803990:	39 c2                	cmp    %eax,%edx
  803992:	74 14                	je     8039a8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	68 fc 44 80 00       	push   $0x8044fc
  80399c:	6a 26                	push   $0x26
  80399e:	68 48 45 80 00       	push   $0x804548
  8039a3:	e8 62 ff ff ff       	call   80390a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039b6:	e9 c5 00 00 00       	jmp    803a80 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c8:	01 d0                	add    %edx,%eax
  8039ca:	8b 00                	mov    (%eax),%eax
  8039cc:	85 c0                	test   %eax,%eax
  8039ce:	75 08                	jne    8039d8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039d0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039d3:	e9 a5 00 00 00       	jmp    803a7d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039e6:	eb 69                	jmp    803a51 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ed:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f6:	89 d0                	mov    %edx,%eax
  8039f8:	01 c0                	add    %eax,%eax
  8039fa:	01 d0                	add    %edx,%eax
  8039fc:	c1 e0 03             	shl    $0x3,%eax
  8039ff:	01 c8                	add    %ecx,%eax
  803a01:	8a 40 04             	mov    0x4(%eax),%al
  803a04:	84 c0                	test   %al,%al
  803a06:	75 46                	jne    803a4e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a08:	a1 20 50 80 00       	mov    0x805020,%eax
  803a0d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a16:	89 d0                	mov    %edx,%eax
  803a18:	01 c0                	add    %eax,%eax
  803a1a:	01 d0                	add    %edx,%eax
  803a1c:	c1 e0 03             	shl    $0x3,%eax
  803a1f:	01 c8                	add    %ecx,%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a2e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a33:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3d:	01 c8                	add    %ecx,%eax
  803a3f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a41:	39 c2                	cmp    %eax,%edx
  803a43:	75 09                	jne    803a4e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a45:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a4c:	eb 15                	jmp    803a63 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a4e:	ff 45 e8             	incl   -0x18(%ebp)
  803a51:	a1 20 50 80 00       	mov    0x805020,%eax
  803a56:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5f:	39 c2                	cmp    %eax,%edx
  803a61:	77 85                	ja     8039e8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a67:	75 14                	jne    803a7d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a69:	83 ec 04             	sub    $0x4,%esp
  803a6c:	68 54 45 80 00       	push   $0x804554
  803a71:	6a 3a                	push   $0x3a
  803a73:	68 48 45 80 00       	push   $0x804548
  803a78:	e8 8d fe ff ff       	call   80390a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a7d:	ff 45 f0             	incl   -0x10(%ebp)
  803a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a83:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a86:	0f 8c 2f ff ff ff    	jl     8039bb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a8c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a9a:	eb 26                	jmp    803ac2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a9c:	a1 20 50 80 00       	mov    0x805020,%eax
  803aa1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aaa:	89 d0                	mov    %edx,%eax
  803aac:	01 c0                	add    %eax,%eax
  803aae:	01 d0                	add    %edx,%eax
  803ab0:	c1 e0 03             	shl    $0x3,%eax
  803ab3:	01 c8                	add    %ecx,%eax
  803ab5:	8a 40 04             	mov    0x4(%eax),%al
  803ab8:	3c 01                	cmp    $0x1,%al
  803aba:	75 03                	jne    803abf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803abc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803abf:	ff 45 e0             	incl   -0x20(%ebp)
  803ac2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803acd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad0:	39 c2                	cmp    %eax,%edx
  803ad2:	77 c8                	ja     803a9c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ada:	74 14                	je     803af0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	68 a8 45 80 00       	push   $0x8045a8
  803ae4:	6a 44                	push   $0x44
  803ae6:	68 48 45 80 00       	push   $0x804548
  803aeb:	e8 1a fe ff ff       	call   80390a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803af0:	90                   	nop
  803af1:	c9                   	leave  
  803af2:	c3                   	ret    
  803af3:	90                   	nop

00803af4 <__udivdi3>:
  803af4:	55                   	push   %ebp
  803af5:	57                   	push   %edi
  803af6:	56                   	push   %esi
  803af7:	53                   	push   %ebx
  803af8:	83 ec 1c             	sub    $0x1c,%esp
  803afb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b0b:	89 ca                	mov    %ecx,%edx
  803b0d:	89 f8                	mov    %edi,%eax
  803b0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b13:	85 f6                	test   %esi,%esi
  803b15:	75 2d                	jne    803b44 <__udivdi3+0x50>
  803b17:	39 cf                	cmp    %ecx,%edi
  803b19:	77 65                	ja     803b80 <__udivdi3+0x8c>
  803b1b:	89 fd                	mov    %edi,%ebp
  803b1d:	85 ff                	test   %edi,%edi
  803b1f:	75 0b                	jne    803b2c <__udivdi3+0x38>
  803b21:	b8 01 00 00 00       	mov    $0x1,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	f7 f7                	div    %edi
  803b2a:	89 c5                	mov    %eax,%ebp
  803b2c:	31 d2                	xor    %edx,%edx
  803b2e:	89 c8                	mov    %ecx,%eax
  803b30:	f7 f5                	div    %ebp
  803b32:	89 c1                	mov    %eax,%ecx
  803b34:	89 d8                	mov    %ebx,%eax
  803b36:	f7 f5                	div    %ebp
  803b38:	89 cf                	mov    %ecx,%edi
  803b3a:	89 fa                	mov    %edi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	39 ce                	cmp    %ecx,%esi
  803b46:	77 28                	ja     803b70 <__udivdi3+0x7c>
  803b48:	0f bd fe             	bsr    %esi,%edi
  803b4b:	83 f7 1f             	xor    $0x1f,%edi
  803b4e:	75 40                	jne    803b90 <__udivdi3+0x9c>
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	72 0a                	jb     803b5e <__udivdi3+0x6a>
  803b54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b58:	0f 87 9e 00 00 00    	ja     803bfc <__udivdi3+0x108>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	89 fa                	mov    %edi,%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	31 c0                	xor    %eax,%eax
  803b74:	89 fa                	mov    %edi,%edx
  803b76:	83 c4 1c             	add    $0x1c,%esp
  803b79:	5b                   	pop    %ebx
  803b7a:	5e                   	pop    %esi
  803b7b:	5f                   	pop    %edi
  803b7c:	5d                   	pop    %ebp
  803b7d:	c3                   	ret    
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 d8                	mov    %ebx,%eax
  803b82:	f7 f7                	div    %edi
  803b84:	31 ff                	xor    %edi,%edi
  803b86:	89 fa                	mov    %edi,%edx
  803b88:	83 c4 1c             	add    $0x1c,%esp
  803b8b:	5b                   	pop    %ebx
  803b8c:	5e                   	pop    %esi
  803b8d:	5f                   	pop    %edi
  803b8e:	5d                   	pop    %ebp
  803b8f:	c3                   	ret    
  803b90:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b95:	89 eb                	mov    %ebp,%ebx
  803b97:	29 fb                	sub    %edi,%ebx
  803b99:	89 f9                	mov    %edi,%ecx
  803b9b:	d3 e6                	shl    %cl,%esi
  803b9d:	89 c5                	mov    %eax,%ebp
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 ed                	shr    %cl,%ebp
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	09 f1                	or     %esi,%ecx
  803ba7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bab:	89 f9                	mov    %edi,%ecx
  803bad:	d3 e0                	shl    %cl,%eax
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	88 d9                	mov    %bl,%cl
  803bb5:	d3 ee                	shr    %cl,%esi
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e2                	shl    %cl,%edx
  803bbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 e8                	shr    %cl,%eax
  803bc3:	09 c2                	or     %eax,%edx
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	89 f2                	mov    %esi,%edx
  803bc9:	f7 74 24 0c          	divl   0xc(%esp)
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	89 c3                	mov    %eax,%ebx
  803bd1:	f7 e5                	mul    %ebp
  803bd3:	39 d6                	cmp    %edx,%esi
  803bd5:	72 19                	jb     803bf0 <__udivdi3+0xfc>
  803bd7:	74 0b                	je     803be4 <__udivdi3+0xf0>
  803bd9:	89 d8                	mov    %ebx,%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 58 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be8:	89 f9                	mov    %edi,%ecx
  803bea:	d3 e2                	shl    %cl,%edx
  803bec:	39 c2                	cmp    %eax,%edx
  803bee:	73 e9                	jae    803bd9 <__udivdi3+0xe5>
  803bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bf3:	31 ff                	xor    %edi,%edi
  803bf5:	e9 40 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	31 c0                	xor    %eax,%eax
  803bfe:	e9 37 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803c03:	90                   	nop

00803c04 <__umoddi3>:
  803c04:	55                   	push   %ebp
  803c05:	57                   	push   %edi
  803c06:	56                   	push   %esi
  803c07:	53                   	push   %ebx
  803c08:	83 ec 1c             	sub    $0x1c,%esp
  803c0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c23:	89 f3                	mov    %esi,%ebx
  803c25:	89 fa                	mov    %edi,%edx
  803c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2b:	89 34 24             	mov    %esi,(%esp)
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	75 1a                	jne    803c4c <__umoddi3+0x48>
  803c32:	39 f7                	cmp    %esi,%edi
  803c34:	0f 86 a2 00 00 00    	jbe    803cdc <__umoddi3+0xd8>
  803c3a:	89 c8                	mov    %ecx,%eax
  803c3c:	89 f2                	mov    %esi,%edx
  803c3e:	f7 f7                	div    %edi
  803c40:	89 d0                	mov    %edx,%eax
  803c42:	31 d2                	xor    %edx,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	39 f0                	cmp    %esi,%eax
  803c4e:	0f 87 ac 00 00 00    	ja     803d00 <__umoddi3+0xfc>
  803c54:	0f bd e8             	bsr    %eax,%ebp
  803c57:	83 f5 1f             	xor    $0x1f,%ebp
  803c5a:	0f 84 ac 00 00 00    	je     803d0c <__umoddi3+0x108>
  803c60:	bf 20 00 00 00       	mov    $0x20,%edi
  803c65:	29 ef                	sub    %ebp,%edi
  803c67:	89 fe                	mov    %edi,%esi
  803c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c6d:	89 e9                	mov    %ebp,%ecx
  803c6f:	d3 e0                	shl    %cl,%eax
  803c71:	89 d7                	mov    %edx,%edi
  803c73:	89 f1                	mov    %esi,%ecx
  803c75:	d3 ef                	shr    %cl,%edi
  803c77:	09 c7                	or     %eax,%edi
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e2                	shl    %cl,%edx
  803c7d:	89 14 24             	mov    %edx,(%esp)
  803c80:	89 d8                	mov    %ebx,%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 c2                	mov    %eax,%edx
  803c86:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c90:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c94:	89 f1                	mov    %esi,%ecx
  803c96:	d3 e8                	shr    %cl,%eax
  803c98:	09 d0                	or     %edx,%eax
  803c9a:	d3 eb                	shr    %cl,%ebx
  803c9c:	89 da                	mov    %ebx,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d3                	mov    %edx,%ebx
  803ca2:	f7 24 24             	mull   (%esp)
  803ca5:	89 c6                	mov    %eax,%esi
  803ca7:	89 d1                	mov    %edx,%ecx
  803ca9:	39 d3                	cmp    %edx,%ebx
  803cab:	0f 82 87 00 00 00    	jb     803d38 <__umoddi3+0x134>
  803cb1:	0f 84 91 00 00 00    	je     803d48 <__umoddi3+0x144>
  803cb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cbb:	29 f2                	sub    %esi,%edx
  803cbd:	19 cb                	sbb    %ecx,%ebx
  803cbf:	89 d8                	mov    %ebx,%eax
  803cc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cc5:	d3 e0                	shl    %cl,%eax
  803cc7:	89 e9                	mov    %ebp,%ecx
  803cc9:	d3 ea                	shr    %cl,%edx
  803ccb:	09 d0                	or     %edx,%eax
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 eb                	shr    %cl,%ebx
  803cd1:	89 da                	mov    %ebx,%edx
  803cd3:	83 c4 1c             	add    $0x1c,%esp
  803cd6:	5b                   	pop    %ebx
  803cd7:	5e                   	pop    %esi
  803cd8:	5f                   	pop    %edi
  803cd9:	5d                   	pop    %ebp
  803cda:	c3                   	ret    
  803cdb:	90                   	nop
  803cdc:	89 fd                	mov    %edi,%ebp
  803cde:	85 ff                	test   %edi,%edi
  803ce0:	75 0b                	jne    803ced <__umoddi3+0xe9>
  803ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f7                	div    %edi
  803ceb:	89 c5                	mov    %eax,%ebp
  803ced:	89 f0                	mov    %esi,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f5                	div    %ebp
  803cf3:	89 c8                	mov    %ecx,%eax
  803cf5:	f7 f5                	div    %ebp
  803cf7:	89 d0                	mov    %edx,%eax
  803cf9:	e9 44 ff ff ff       	jmp    803c42 <__umoddi3+0x3e>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	89 c8                	mov    %ecx,%eax
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	3b 04 24             	cmp    (%esp),%eax
  803d0f:	72 06                	jb     803d17 <__umoddi3+0x113>
  803d11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d15:	77 0f                	ja     803d26 <__umoddi3+0x122>
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	29 f9                	sub    %edi,%ecx
  803d1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d1f:	89 14 24             	mov    %edx,(%esp)
  803d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d26:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d2a:	8b 14 24             	mov    (%esp),%edx
  803d2d:	83 c4 1c             	add    $0x1c,%esp
  803d30:	5b                   	pop    %ebx
  803d31:	5e                   	pop    %esi
  803d32:	5f                   	pop    %edi
  803d33:	5d                   	pop    %ebp
  803d34:	c3                   	ret    
  803d35:	8d 76 00             	lea    0x0(%esi),%esi
  803d38:	2b 04 24             	sub    (%esp),%eax
  803d3b:	19 fa                	sbb    %edi,%edx
  803d3d:	89 d1                	mov    %edx,%ecx
  803d3f:	89 c6                	mov    %eax,%esi
  803d41:	e9 71 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d4c:	72 ea                	jb     803d38 <__umoddi3+0x134>
  803d4e:	89 d9                	mov    %ebx,%ecx
  803d50:	e9 62 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
