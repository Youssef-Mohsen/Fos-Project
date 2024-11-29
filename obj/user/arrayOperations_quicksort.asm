
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
  80003e:	e8 b0 1b 00 00       	call   801bf3 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 da 1b 00 00       	call   801c25 <sys_getparentenvid>
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
  80005f:	68 40 3e 80 00       	push   $0x803e40
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 d5 16 00 00       	call   801741 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 44 3e 80 00       	push   $0x803e44
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 bf 16 00 00       	call   801741 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 4c 3e 80 00       	push   $0x803e4c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 a2 16 00 00       	call   801741 <sget>
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
  8000b3:	68 5a 3e 80 00       	push   $0x803e5a
  8000b8:	e8 7a 15 00 00       	call   801637 <smalloc>
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
  800112:	68 69 3e 80 00       	push   $0x803e69
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
  800166:	e8 ed 1a 00 00       	call   801c58 <sys_get_virtual_time>
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
  8002f6:	68 85 3e 80 00       	push   $0x803e85
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
  800318:	68 87 3e 80 00       	push   $0x803e87
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
  800346:	68 8c 3e 80 00       	push   $0x803e8c
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
  80035c:	e8 ab 18 00 00       	call   801c0c <sys_getenvindex>
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
  8003ca:	e8 c1 15 00 00       	call   801990 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	68 a8 3e 80 00       	push   $0x803ea8
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
  8003fa:	68 d0 3e 80 00       	push   $0x803ed0
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
  80042b:	68 f8 3e 80 00       	push   $0x803ef8
  800430:	e8 34 01 00 00       	call   800569 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	50                   	push   %eax
  800447:	68 50 3f 80 00       	push   $0x803f50
  80044c:	e8 18 01 00 00       	call   800569 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	68 a8 3e 80 00       	push   $0x803ea8
  80045c:	e8 08 01 00 00       	call   800569 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800464:	e8 41 15 00 00       	call   8019aa <sys_unlock_cons>
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
  80047c:	e8 57 17 00 00       	call   801bd8 <sys_destroy_env>
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
  80048d:	e8 ac 17 00 00       	call   801c3e <sys_exit_env>
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
  8004c0:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8004db:	e8 6e 14 00 00       	call   80194e <sys_cputs>
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
  800535:	a0 2c 50 80 00       	mov    0x80502c,%al
  80053a:	0f b6 c0             	movzbl %al,%eax
  80053d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	50                   	push   %eax
  800547:	52                   	push   %edx
  800548:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054e:	83 c0 08             	add    $0x8,%eax
  800551:	50                   	push   %eax
  800552:	e8 f7 13 00 00       	call   80194e <sys_cputs>
  800557:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055a:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  80056f:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  80059c:	e8 ef 13 00 00       	call   801990 <sys_lock_cons>
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
  8005bc:	e8 e9 13 00 00       	call   8019aa <sys_unlock_cons>
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
  800606:	e8 c5 35 00 00       	call   803bd0 <__udivdi3>
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
  800656:	e8 85 36 00 00       	call   803ce0 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 94 41 80 00       	add    $0x804194,%eax
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
  8007b1:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
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
  800892:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 a5 41 80 00       	push   $0x8041a5
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
  8008b7:	68 ae 41 80 00       	push   $0x8041ae
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
  8008e4:	be b1 41 80 00       	mov    $0x8041b1,%esi
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
  800adc:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800ae3:	eb 2c                	jmp    800b11 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae5:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8012ef:	68 28 43 80 00       	push   $0x804328
  8012f4:	68 3f 01 00 00       	push   $0x13f
  8012f9:	68 4a 43 80 00       	push   $0x80434a
  8012fe:	e8 e2 26 00 00       	call   8039e5 <_panic>

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
  80130f:	e8 e5 0b 00 00       	call   801ef9 <sys_sbrk>
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
  80138a:	e8 ee 09 00 00       	call   801d7d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 16                	je     8013a9 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 2e 0f 00 00       	call   8022cc <alloc_block_FF>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a4:	e9 8a 01 00 00       	jmp    801533 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013a9:	e8 00 0a 00 00       	call   801dae <sys_isUHeapPlacementStrategyBESTFIT>
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	0f 84 7d 01 00 00    	je     801533 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 c7 13 00 00       	call   802788 <alloc_block_BF>
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
  80140c:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801459:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8014b0:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801512:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	ff 75 f0             	pushl  -0x10(%ebp)
  801522:	e8 09 0a 00 00       	call   801f30 <sys_allocate_user_mem>
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
  80156a:	e8 dd 09 00 00       	call   801f4c <get_block_size>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 10 1c 00 00       	call   803190 <free_block>
  801580:	83 c4 10             	add    $0x10,%esp
		}

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
  8015b5:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  8015bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	c1 e0 0c             	shl    $0xc,%eax
  8015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8015c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015cf:	eb 42                	jmp    801613 <free+0xdb>
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
  8015f2:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8015f9:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8015fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	52                   	push   %edx
  801607:	50                   	push   %eax
  801608:	e8 07 09 00 00       	call   801f14 <sys_free_user_mem>
  80160d:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801610:	ff 45 f4             	incl   -0xc(%ebp)
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801619:	72 b6                	jb     8015d1 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80161b:	eb 17                	jmp    801634 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	68 58 43 80 00       	push   $0x804358
  801625:	68 88 00 00 00       	push   $0x88
  80162a:	68 82 43 80 00       	push   $0x804382
  80162f:	e8 b1 23 00 00       	call   8039e5 <_panic>
	}
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 28             	sub    $0x28,%esp
  80163d:	8b 45 10             	mov    0x10(%ebp),%eax
  801640:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801643:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801647:	75 0a                	jne    801653 <smalloc+0x1c>
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
  80164e:	e9 ec 00 00 00       	jmp    80173f <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801659:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	39 d0                	cmp    %edx,%eax
  801668:	73 02                	jae    80166c <smalloc+0x35>
  80166a:	89 d0                	mov    %edx,%eax
  80166c:	83 ec 0c             	sub    $0xc,%esp
  80166f:	50                   	push   %eax
  801670:	e8 a4 fc ff ff       	call   801319 <malloc>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80167b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167f:	75 0a                	jne    80168b <smalloc+0x54>
  801681:	b8 00 00 00 00       	mov    $0x0,%eax
  801686:	e9 b4 00 00 00       	jmp    80173f <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80168b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80168f:	ff 75 ec             	pushl  -0x14(%ebp)
  801692:	50                   	push   %eax
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 7d 04 00 00       	call   801b1b <sys_createSharedObject>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016a4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016a8:	74 06                	je     8016b0 <smalloc+0x79>
  8016aa:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016ae:	75 0a                	jne    8016ba <smalloc+0x83>
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	e9 85 00 00 00       	jmp    80173f <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c0:	68 8e 43 80 00       	push   $0x80438e
  8016c5:	e8 9f ee ff ff       	call   800569 <cprintf>
  8016ca:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8016cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8016d5:	8b 40 78             	mov    0x78(%eax),%eax
  8016d8:	29 c2                	sub    %eax,%edx
  8016da:	89 d0                	mov    %edx,%eax
  8016dc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
  8016e4:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016ea:	42                   	inc    %edx
  8016eb:	89 15 24 50 80 00    	mov    %edx,0x805024
  8016f1:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016f7:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8016fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801701:	a1 20 50 80 00       	mov    0x805020,%eax
  801706:	8b 40 78             	mov    0x78(%eax),%eax
  801709:	29 c2                	sub    %eax,%edx
  80170b:	89 d0                	mov    %edx,%eax
  80170d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801712:	c1 e8 0c             	shr    $0xc,%eax
  801715:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80171c:	a1 20 50 80 00       	mov    0x805020,%eax
  801721:	8b 50 10             	mov    0x10(%eax),%edx
  801724:	89 c8                	mov    %ecx,%eax
  801726:	c1 e0 02             	shl    $0x2,%eax
  801729:	89 c1                	mov    %eax,%ecx
  80172b:	c1 e1 09             	shl    $0x9,%ecx
  80172e:	01 c8                	add    %ecx,%eax
  801730:	01 c2                	add    %eax,%edx
  801732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801735:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80173c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	ff 75 0c             	pushl  0xc(%ebp)
  80174d:	ff 75 08             	pushl  0x8(%ebp)
  801750:	e8 f0 03 00 00       	call   801b45 <sys_getSizeOfSharedObject>
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80175b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80175f:	75 0a                	jne    80176b <sget+0x2a>
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
  801766:	e9 e7 00 00 00       	jmp    801852 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801771:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801778:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177e:	39 d0                	cmp    %edx,%eax
  801780:	73 02                	jae    801784 <sget+0x43>
  801782:	89 d0                	mov    %edx,%eax
  801784:	83 ec 0c             	sub    $0xc,%esp
  801787:	50                   	push   %eax
  801788:	e8 8c fb ff ff       	call   801319 <malloc>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801793:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801797:	75 0a                	jne    8017a3 <sget+0x62>
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	e9 af 00 00 00       	jmp    801852 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	e8 ae 03 00 00       	call   801b62 <sys_getSharedObject>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8017ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8017c2:	8b 40 78             	mov    0x78(%eax),%eax
  8017c5:	29 c2                	sub    %eax,%edx
  8017c7:	89 d0                	mov    %edx,%eax
  8017c9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ce:	c1 e8 0c             	shr    $0xc,%eax
  8017d1:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017d7:	42                   	inc    %edx
  8017d8:	89 15 24 50 80 00    	mov    %edx,0x805024
  8017de:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017e4:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8017eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f3:	8b 40 78             	mov    0x78(%eax),%eax
  8017f6:	29 c2                	sub    %eax,%edx
  8017f8:	89 d0                	mov    %edx,%eax
  8017fa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ff:	c1 e8 0c             	shr    $0xc,%eax
  801802:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801809:	a1 20 50 80 00       	mov    0x805020,%eax
  80180e:	8b 50 10             	mov    0x10(%eax),%edx
  801811:	89 c8                	mov    %ecx,%eax
  801813:	c1 e0 02             	shl    $0x2,%eax
  801816:	89 c1                	mov    %eax,%ecx
  801818:	c1 e1 09             	shl    $0x9,%ecx
  80181b:	01 c8                	add    %ecx,%eax
  80181d:	01 c2                	add    %eax,%edx
  80181f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801822:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801829:	a1 20 50 80 00       	mov    0x805020,%eax
  80182e:	8b 40 10             	mov    0x10(%eax),%eax
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	50                   	push   %eax
  801835:	68 9d 43 80 00       	push   $0x80439d
  80183a:	e8 2a ed ff ff       	call   800569 <cprintf>
  80183f:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801842:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801846:	75 07                	jne    80184f <sget+0x10e>
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
  80184d:	eb 03                	jmp    801852 <sget+0x111>
	return ptr;
  80184f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80185a:	8b 55 08             	mov    0x8(%ebp),%edx
  80185d:	a1 20 50 80 00       	mov    0x805020,%eax
  801862:	8b 40 78             	mov    0x78(%eax),%eax
  801865:	29 c2                	sub    %eax,%edx
  801867:	89 d0                	mov    %edx,%eax
  801869:	2d 00 10 00 00       	sub    $0x1000,%eax
  80186e:	c1 e8 0c             	shr    $0xc,%eax
  801871:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801878:	a1 20 50 80 00       	mov    0x805020,%eax
  80187d:	8b 50 10             	mov    0x10(%eax),%edx
  801880:	89 c8                	mov    %ecx,%eax
  801882:	c1 e0 02             	shl    $0x2,%eax
  801885:	89 c1                	mov    %eax,%ecx
  801887:	c1 e1 09             	shl    $0x9,%ecx
  80188a:	01 c8                	add    %ecx,%eax
  80188c:	01 d0                	add    %edx,%eax
  80188e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801895:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a1:	e8 db 02 00 00       	call   801b81 <sys_freeSharedObject>
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018ac:	90                   	nop
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	68 ac 43 80 00       	push   $0x8043ac
  8018bd:	68 e5 00 00 00       	push   $0xe5
  8018c2:	68 82 43 80 00       	push   $0x804382
  8018c7:	e8 19 21 00 00       	call   8039e5 <_panic>

008018cc <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 d2 43 80 00       	push   $0x8043d2
  8018da:	68 f1 00 00 00       	push   $0xf1
  8018df:	68 82 43 80 00       	push   $0x804382
  8018e4:	e8 fc 20 00 00       	call   8039e5 <_panic>

008018e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 d2 43 80 00       	push   $0x8043d2
  8018f7:	68 f6 00 00 00       	push   $0xf6
  8018fc:	68 82 43 80 00       	push   $0x804382
  801901:	e8 df 20 00 00       	call   8039e5 <_panic>

00801906 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	68 d2 43 80 00       	push   $0x8043d2
  801914:	68 fb 00 00 00       	push   $0xfb
  801919:	68 82 43 80 00       	push   $0x804382
  80191e:	e8 c2 20 00 00       	call   8039e5 <_panic>

00801923 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	57                   	push   %edi
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801935:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801938:	8b 7d 18             	mov    0x18(%ebp),%edi
  80193b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193e:	cd 30                	int    $0x30
  801940:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	8b 45 10             	mov    0x10(%ebp),%eax
  801957:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80195a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	6a 00                	push   $0x0
  80196c:	e8 b2 ff ff ff       	call   801923 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_cgetc>:

int
sys_cgetc(void)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 02                	push   $0x2
  801986:	e8 98 ff ff ff       	call   801923 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 03                	push   $0x3
  80199f:	e8 7f ff ff ff       	call   801923 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	90                   	nop
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 04                	push   $0x4
  8019b9:	e8 65 ff ff ff       	call   801923 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	52                   	push   %edx
  8019d4:	50                   	push   %eax
  8019d5:	6a 08                	push   $0x8
  8019d7:	e8 47 ff ff ff       	call   801923 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	56                   	push   %esi
  8019e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
  8019f7:	51                   	push   %ecx
  8019f8:	52                   	push   %edx
  8019f9:	50                   	push   %eax
  8019fa:	6a 09                	push   $0x9
  8019fc:	e8 22 ff ff ff       	call   801923 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    

00801a0b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 0a                	push   $0xa
  801a1e:	e8 00 ff ff ff       	call   801923 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	ff 75 08             	pushl  0x8(%ebp)
  801a37:	6a 0b                	push   $0xb
  801a39:	e8 e5 fe ff ff       	call   801923 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 0c                	push   $0xc
  801a52:	e8 cc fe ff ff       	call   801923 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 0d                	push   $0xd
  801a6b:	e8 b3 fe ff ff       	call   801923 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 0e                	push   $0xe
  801a84:	e8 9a fe ff ff       	call   801923 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 0f                	push   $0xf
  801a9d:	e8 81 fe ff ff       	call   801923 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	6a 10                	push   $0x10
  801ab7:	e8 67 fe ff ff       	call   801923 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 11                	push   $0x11
  801ad0:	e8 4e fe ff ff       	call   801923 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_cputc>:

void
sys_cputc(const char c)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	50                   	push   %eax
  801af4:	6a 01                	push   $0x1
  801af6:	e8 28 fe ff ff       	call   801923 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 14                	push   $0x14
  801b10:	e8 0e fe ff ff       	call   801923 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	90                   	nop
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 04             	sub    $0x4,%esp
  801b21:	8b 45 10             	mov    0x10(%ebp),%eax
  801b24:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b27:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b2a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	51                   	push   %ecx
  801b34:	52                   	push   %edx
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	50                   	push   %eax
  801b39:	6a 15                	push   $0x15
  801b3b:	e8 e3 fd ff ff       	call   801923 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	52                   	push   %edx
  801b55:	50                   	push   %eax
  801b56:	6a 16                	push   $0x16
  801b58:	e8 c6 fd ff ff       	call   801923 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	51                   	push   %ecx
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 17                	push   $0x17
  801b77:	e8 a7 fd ff ff       	call   801923 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 18                	push   $0x18
  801b94:	e8 8a fd ff ff       	call   801923 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	ff 75 14             	pushl  0x14(%ebp)
  801ba9:	ff 75 10             	pushl  0x10(%ebp)
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	50                   	push   %eax
  801bb0:	6a 19                	push   $0x19
  801bb2:	e8 6c fd ff ff       	call   801923 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	50                   	push   %eax
  801bcb:	6a 1a                	push   $0x1a
  801bcd:	e8 51 fd ff ff       	call   801923 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	90                   	nop
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	50                   	push   %eax
  801be7:	6a 1b                	push   $0x1b
  801be9:	e8 35 fd ff ff       	call   801923 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 05                	push   $0x5
  801c02:	e8 1c fd ff ff       	call   801923 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 06                	push   $0x6
  801c1b:	e8 03 fd ff ff       	call   801923 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 07                	push   $0x7
  801c34:	e8 ea fc ff ff       	call   801923 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_exit_env>:


void sys_exit_env(void)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 1c                	push   $0x1c
  801c4d:	e8 d1 fc ff ff       	call   801923 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	90                   	nop
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c61:	8d 50 04             	lea    0x4(%eax),%edx
  801c64:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	52                   	push   %edx
  801c6e:	50                   	push   %eax
  801c6f:	6a 1d                	push   $0x1d
  801c71:	e8 ad fc ff ff       	call   801923 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
	return result;
  801c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c82:	89 01                	mov    %eax,(%ecx)
  801c84:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	c9                   	leave  
  801c8b:	c2 04 00             	ret    $0x4

00801c8e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 10             	pushl  0x10(%ebp)
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	6a 13                	push   $0x13
  801ca0:	e8 7e fc ff ff       	call   801923 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca8:	90                   	nop
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_rcr2>:
uint32 sys_rcr2()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 1e                	push   $0x1e
  801cba:	e8 64 fc ff ff       	call   801923 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	50                   	push   %eax
  801cdd:	6a 1f                	push   $0x1f
  801cdf:	e8 3f fc ff ff       	call   801923 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce7:	90                   	nop
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <rsttst>:
void rsttst()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 21                	push   $0x21
  801cf9:	e8 25 fc ff ff       	call   801923 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d10:	8b 55 18             	mov    0x18(%ebp),%edx
  801d13:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d17:	52                   	push   %edx
  801d18:	50                   	push   %eax
  801d19:	ff 75 10             	pushl  0x10(%ebp)
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	ff 75 08             	pushl  0x8(%ebp)
  801d22:	6a 20                	push   $0x20
  801d24:	e8 fa fb ff ff       	call   801923 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <chktst>:
void chktst(uint32 n)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	6a 22                	push   $0x22
  801d3f:	e8 df fb ff ff       	call   801923 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
	return ;
  801d47:	90                   	nop
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <inctst>:

void inctst()
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 23                	push   $0x23
  801d59:	e8 c5 fb ff ff       	call   801923 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d61:	90                   	nop
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <gettst>:
uint32 gettst()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 24                	push   $0x24
  801d73:	e8 ab fb ff ff       	call   801923 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 25                	push   $0x25
  801d8f:	e8 8f fb ff ff       	call   801923 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
  801d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d9a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9e:	75 07                	jne    801da7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801da0:	b8 01 00 00 00       	mov    $0x1,%eax
  801da5:	eb 05                	jmp    801dac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 25                	push   $0x25
  801dc0:	e8 5e fb ff ff       	call   801923 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
  801dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dcb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dcf:	75 07                	jne    801dd8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd6:	eb 05                	jmp    801ddd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 25                	push   $0x25
  801df1:	e8 2d fb ff ff       	call   801923 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
  801df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dfc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e00:	75 07                	jne    801e09 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	eb 05                	jmp    801e0e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 25                	push   $0x25
  801e22:	e8 fc fa ff ff       	call   801923 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e2d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	6a 26                	push   $0x26
  801e51:	e8 cd fa ff ff       	call   801923 <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
	return ;
  801e59:	90                   	nop
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	53                   	push   %ebx
  801e6f:	51                   	push   %ecx
  801e70:	52                   	push   %edx
  801e71:	50                   	push   %eax
  801e72:	6a 27                	push   $0x27
  801e74:	e8 aa fa ff ff       	call   801923 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
}
  801e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	52                   	push   %edx
  801e91:	50                   	push   %eax
  801e92:	6a 28                	push   $0x28
  801e94:	e8 8a fa ff ff       	call   801923 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ea1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	6a 00                	push   $0x0
  801eac:	51                   	push   %ecx
  801ead:	ff 75 10             	pushl  0x10(%ebp)
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	6a 29                	push   $0x29
  801eb4:	e8 6a fa ff ff       	call   801923 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	ff 75 10             	pushl  0x10(%ebp)
  801ec8:	ff 75 0c             	pushl  0xc(%ebp)
  801ecb:	ff 75 08             	pushl  0x8(%ebp)
  801ece:	6a 12                	push   $0x12
  801ed0:	e8 4e fa ff ff       	call   801923 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed8:	90                   	nop
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	6a 2a                	push   $0x2a
  801eee:	e8 30 fa ff ff       	call   801923 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
	return;
  801ef6:	90                   	nop
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	50                   	push   %eax
  801f08:	6a 2b                	push   $0x2b
  801f0a:	e8 14 fa ff ff       	call   801923 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	ff 75 0c             	pushl  0xc(%ebp)
  801f20:	ff 75 08             	pushl  0x8(%ebp)
  801f23:	6a 2c                	push   $0x2c
  801f25:	e8 f9 f9 ff ff       	call   801923 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
	return;
  801f2d:	90                   	nop
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	ff 75 08             	pushl  0x8(%ebp)
  801f3f:	6a 2d                	push   $0x2d
  801f41:	e8 dd f9 ff ff       	call   801923 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
	return;
  801f49:	90                   	nop
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	83 e8 04             	sub    $0x4,%eax
  801f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5e:	8b 00                	mov    (%eax),%eax
  801f60:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	83 e8 04             	sub    $0x4,%eax
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f77:	8b 00                	mov    (%eax),%eax
  801f79:	83 e0 01             	and    $0x1,%eax
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	0f 94 c0             	sete   %al
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	83 f8 02             	cmp    $0x2,%eax
  801f96:	74 2b                	je     801fc3 <alloc_block+0x40>
  801f98:	83 f8 02             	cmp    $0x2,%eax
  801f9b:	7f 07                	jg     801fa4 <alloc_block+0x21>
  801f9d:	83 f8 01             	cmp    $0x1,%eax
  801fa0:	74 0e                	je     801fb0 <alloc_block+0x2d>
  801fa2:	eb 58                	jmp    801ffc <alloc_block+0x79>
  801fa4:	83 f8 03             	cmp    $0x3,%eax
  801fa7:	74 2d                	je     801fd6 <alloc_block+0x53>
  801fa9:	83 f8 04             	cmp    $0x4,%eax
  801fac:	74 3b                	je     801fe9 <alloc_block+0x66>
  801fae:	eb 4c                	jmp    801ffc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	e8 11 03 00 00       	call   8022cc <alloc_block_FF>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc1:	eb 4a                	jmp    80200d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	ff 75 08             	pushl  0x8(%ebp)
  801fc9:	e8 fa 19 00 00       	call   8039c8 <alloc_block_NF>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd4:	eb 37                	jmp    80200d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	ff 75 08             	pushl  0x8(%ebp)
  801fdc:	e8 a7 07 00 00       	call   802788 <alloc_block_BF>
  801fe1:	83 c4 10             	add    $0x10,%esp
  801fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe7:	eb 24                	jmp    80200d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	e8 b7 19 00 00       	call   8039ab <alloc_block_WF>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ffa:	eb 11                	jmp    80200d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	68 e4 43 80 00       	push   $0x8043e4
  802004:	e8 60 e5 ff ff       	call   800569 <cprintf>
  802009:	83 c4 10             	add    $0x10,%esp
		break;
  80200c:	90                   	nop
	}
	return va;
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	53                   	push   %ebx
  802016:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	68 04 44 80 00       	push   $0x804404
  802021:	e8 43 e5 ff ff       	call   800569 <cprintf>
  802026:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	68 2f 44 80 00       	push   $0x80442f
  802031:	e8 33 e5 ff ff       	call   800569 <cprintf>
  802036:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203f:	eb 37                	jmp    802078 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	ff 75 f4             	pushl  -0xc(%ebp)
  802047:	e8 19 ff ff ff       	call   801f65 <is_free_block>
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	0f be d8             	movsbl %al,%ebx
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	ff 75 f4             	pushl  -0xc(%ebp)
  802058:	e8 ef fe ff ff       	call   801f4c <get_block_size>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	53                   	push   %ebx
  802064:	50                   	push   %eax
  802065:	68 47 44 80 00       	push   $0x804447
  80206a:	e8 fa e4 ff ff       	call   800569 <cprintf>
  80206f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207c:	74 07                	je     802085 <print_blocks_list+0x73>
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	eb 05                	jmp    80208a <print_blocks_list+0x78>
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	89 45 10             	mov    %eax,0x10(%ebp)
  80208d:	8b 45 10             	mov    0x10(%ebp),%eax
  802090:	85 c0                	test   %eax,%eax
  802092:	75 ad                	jne    802041 <print_blocks_list+0x2f>
  802094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802098:	75 a7                	jne    802041 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	68 04 44 80 00       	push   $0x804404
  8020a2:	e8 c2 e4 ff ff       	call   800569 <cprintf>
  8020a7:	83 c4 10             	add    $0x10,%esp

}
  8020aa:	90                   	nop
  8020ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b9:	83 e0 01             	and    $0x1,%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	74 03                	je     8020c3 <initialize_dynamic_allocator+0x13>
  8020c0:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020c7:	0f 84 c7 01 00 00    	je     802294 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020cd:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8020d4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020e4:	0f 87 ad 01 00 00    	ja     802297 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	0f 89 a5 01 00 00    	jns    80229a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fb:	01 d0                	add    %edx,%eax
  8020fd:	83 e8 04             	sub    $0x4,%eax
  802100:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802105:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80210c:	a1 30 50 80 00       	mov    0x805030,%eax
  802111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802114:	e9 87 00 00 00       	jmp    8021a0 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211d:	75 14                	jne    802133 <initialize_dynamic_allocator+0x83>
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	68 5f 44 80 00       	push   $0x80445f
  802127:	6a 79                	push   $0x79
  802129:	68 7d 44 80 00       	push   $0x80447d
  80212e:	e8 b2 18 00 00       	call   8039e5 <_panic>
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	74 10                	je     80214c <initialize_dynamic_allocator+0x9c>
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 52 04             	mov    0x4(%edx),%edx
  802147:	89 50 04             	mov    %edx,0x4(%eax)
  80214a:	eb 0b                	jmp    802157 <initialize_dynamic_allocator+0xa7>
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 04             	mov    0x4(%eax),%eax
  802152:	a3 34 50 80 00       	mov    %eax,0x805034
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 40 04             	mov    0x4(%eax),%eax
  80215d:	85 c0                	test   %eax,%eax
  80215f:	74 0f                	je     802170 <initialize_dynamic_allocator+0xc0>
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 40 04             	mov    0x4(%eax),%eax
  802167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216a:	8b 12                	mov    (%edx),%edx
  80216c:	89 10                	mov    %edx,(%eax)
  80216e:	eb 0a                	jmp    80217a <initialize_dynamic_allocator+0xca>
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	a3 30 50 80 00       	mov    %eax,0x805030
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802192:	48                   	dec    %eax
  802193:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802198:	a1 38 50 80 00       	mov    0x805038,%eax
  80219d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a4:	74 07                	je     8021ad <initialize_dynamic_allocator+0xfd>
  8021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	eb 05                	jmp    8021b2 <initialize_dynamic_allocator+0x102>
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8021b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	0f 85 55 ff ff ff    	jne    802119 <initialize_dynamic_allocator+0x69>
  8021c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c8:	0f 85 4b ff ff ff    	jne    802119 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8021e2:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8021e7:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	83 c0 08             	add    $0x8,%eax
  8021f8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	83 c0 04             	add    $0x4,%eax
  802201:	8b 55 0c             	mov    0xc(%ebp),%edx
  802204:	83 ea 08             	sub    $0x8,%edx
  802207:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802209:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	01 d0                	add    %edx,%eax
  802211:	83 e8 08             	sub    $0x8,%eax
  802214:	8b 55 0c             	mov    0xc(%ebp),%edx
  802217:	83 ea 08             	sub    $0x8,%edx
  80221a:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802228:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80222f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802233:	75 17                	jne    80224c <initialize_dynamic_allocator+0x19c>
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	68 98 44 80 00       	push   $0x804498
  80223d:	68 90 00 00 00       	push   $0x90
  802242:	68 7d 44 80 00       	push   $0x80447d
  802247:	e8 99 17 00 00       	call   8039e5 <_panic>
  80224c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	89 10                	mov    %edx,(%eax)
  802257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 0d                	je     80226d <initialize_dynamic_allocator+0x1bd>
  802260:	a1 30 50 80 00       	mov    0x805030,%eax
  802265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802268:	89 50 04             	mov    %edx,0x4(%eax)
  80226b:	eb 08                	jmp    802275 <initialize_dynamic_allocator+0x1c5>
  80226d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802270:	a3 34 50 80 00       	mov    %eax,0x805034
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	a3 30 50 80 00       	mov    %eax,0x805030
  80227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802287:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80228c:	40                   	inc    %eax
  80228d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802292:	eb 07                	jmp    80229b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802294:	90                   	nop
  802295:	eb 04                	jmp    80229b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802297:	90                   	nop
  802298:	eb 01                	jmp    80229b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80229a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a3:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022af:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	83 e8 04             	sub    $0x4,%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	83 e0 fe             	and    $0xfffffffe,%eax
  8022bc:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	01 c2                	add    %eax,%edx
  8022c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c7:	89 02                	mov    %eax,(%edx)
}
  8022c9:	90                   	nop
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    

008022cc <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	83 e0 01             	and    $0x1,%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	74 03                	je     8022df <alloc_block_FF+0x13>
  8022dc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022df:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022e3:	77 07                	ja     8022ec <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022e5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022ec:	a1 28 50 80 00       	mov    0x805028,%eax
  8022f1:	85 c0                	test   %eax,%eax
  8022f3:	75 73                	jne    802368 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	83 c0 10             	add    $0x10,%eax
  8022fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022fe:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802305:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230b:	01 d0                	add    %edx,%eax
  80230d:	48                   	dec    %eax
  80230e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802314:	ba 00 00 00 00       	mov    $0x0,%edx
  802319:	f7 75 ec             	divl   -0x14(%ebp)
  80231c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231f:	29 d0                	sub    %edx,%eax
  802321:	c1 e8 0c             	shr    $0xc,%eax
  802324:	83 ec 0c             	sub    $0xc,%esp
  802327:	50                   	push   %eax
  802328:	e8 d6 ef ff ff       	call   801303 <sbrk>
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	6a 00                	push   $0x0
  802338:	e8 c6 ef ff ff       	call   801303 <sbrk>
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802346:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802349:	83 ec 08             	sub    $0x8,%esp
  80234c:	50                   	push   %eax
  80234d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802350:	e8 5b fd ff ff       	call   8020b0 <initialize_dynamic_allocator>
  802355:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802358:	83 ec 0c             	sub    $0xc,%esp
  80235b:	68 bb 44 80 00       	push   $0x8044bb
  802360:	e8 04 e2 ff ff       	call   800569 <cprintf>
  802365:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802368:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236c:	75 0a                	jne    802378 <alloc_block_FF+0xac>
	        return NULL;
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	e9 0e 04 00 00       	jmp    802786 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802378:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80237f:	a1 30 50 80 00       	mov    0x805030,%eax
  802384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802387:	e9 f3 02 00 00       	jmp    80267f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802392:	83 ec 0c             	sub    $0xc,%esp
  802395:	ff 75 bc             	pushl  -0x44(%ebp)
  802398:	e8 af fb ff ff       	call   801f4c <get_block_size>
  80239d:	83 c4 10             	add    $0x10,%esp
  8023a0:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	83 c0 08             	add    $0x8,%eax
  8023a9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023ac:	0f 87 c5 02 00 00    	ja     802677 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	83 c0 18             	add    $0x18,%eax
  8023b8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023bb:	0f 87 19 02 00 00    	ja     8025da <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c7:	83 e8 08             	sub    $0x8,%eax
  8023ca:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8d 50 08             	lea    0x8(%eax),%edx
  8023d3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023d6:	01 d0                	add    %edx,%eax
  8023d8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	83 c0 08             	add    $0x8,%eax
  8023e1:	83 ec 04             	sub    $0x4,%esp
  8023e4:	6a 01                	push   $0x1
  8023e6:	50                   	push   %eax
  8023e7:	ff 75 bc             	pushl  -0x44(%ebp)
  8023ea:	e8 ae fe ff ff       	call   80229d <set_block_data>
  8023ef:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	75 68                	jne    802464 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023fc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802400:	75 17                	jne    802419 <alloc_block_FF+0x14d>
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 98 44 80 00       	push   $0x804498
  80240a:	68 d7 00 00 00       	push   $0xd7
  80240f:	68 7d 44 80 00       	push   $0x80447d
  802414:	e8 cc 15 00 00       	call   8039e5 <_panic>
  802419:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80241f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802422:	89 10                	mov    %edx,(%eax)
  802424:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	74 0d                	je     80243a <alloc_block_FF+0x16e>
  80242d:	a1 30 50 80 00       	mov    0x805030,%eax
  802432:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802435:	89 50 04             	mov    %edx,0x4(%eax)
  802438:	eb 08                	jmp    802442 <alloc_block_FF+0x176>
  80243a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243d:	a3 34 50 80 00       	mov    %eax,0x805034
  802442:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802445:	a3 30 50 80 00       	mov    %eax,0x805030
  80244a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802454:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802459:	40                   	inc    %eax
  80245a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80245f:	e9 dc 00 00 00       	jmp    802540 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 65                	jne    8024d2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80246d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802471:	75 17                	jne    80248a <alloc_block_FF+0x1be>
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	68 cc 44 80 00       	push   $0x8044cc
  80247b:	68 db 00 00 00       	push   $0xdb
  802480:	68 7d 44 80 00       	push   $0x80447d
  802485:	e8 5b 15 00 00       	call   8039e5 <_panic>
  80248a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802490:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802493:	89 50 04             	mov    %edx,0x4(%eax)
  802496:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 0c                	je     8024ac <alloc_block_FF+0x1e0>
  8024a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8024a5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a8:	89 10                	mov    %edx,(%eax)
  8024aa:	eb 08                	jmp    8024b4 <alloc_block_FF+0x1e8>
  8024ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024af:	a3 30 50 80 00       	mov    %eax,0x805030
  8024b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b7:	a3 34 50 80 00       	mov    %eax,0x805034
  8024bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8024ca:	40                   	inc    %eax
  8024cb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8024d0:	eb 6e                	jmp    802540 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d6:	74 06                	je     8024de <alloc_block_FF+0x212>
  8024d8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024dc:	75 17                	jne    8024f5 <alloc_block_FF+0x229>
  8024de:	83 ec 04             	sub    $0x4,%esp
  8024e1:	68 f0 44 80 00       	push   $0x8044f0
  8024e6:	68 df 00 00 00       	push   $0xdf
  8024eb:	68 7d 44 80 00       	push   $0x80447d
  8024f0:	e8 f0 14 00 00       	call   8039e5 <_panic>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 10                	mov    (%eax),%edx
  8024fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fd:	89 10                	mov    %edx,(%eax)
  8024ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	74 0b                	je     802513 <alloc_block_FF+0x247>
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 00                	mov    (%eax),%eax
  80250d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802510:	89 50 04             	mov    %edx,0x4(%eax)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802519:	89 10                	mov    %edx,(%eax)
  80251b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802521:	89 50 04             	mov    %edx,0x4(%eax)
  802524:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	75 08                	jne    802535 <alloc_block_FF+0x269>
  80252d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802530:	a3 34 50 80 00       	mov    %eax,0x805034
  802535:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80253a:	40                   	inc    %eax
  80253b:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802544:	75 17                	jne    80255d <alloc_block_FF+0x291>
  802546:	83 ec 04             	sub    $0x4,%esp
  802549:	68 5f 44 80 00       	push   $0x80445f
  80254e:	68 e1 00 00 00       	push   $0xe1
  802553:	68 7d 44 80 00       	push   $0x80447d
  802558:	e8 88 14 00 00       	call   8039e5 <_panic>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	85 c0                	test   %eax,%eax
  802564:	74 10                	je     802576 <alloc_block_FF+0x2aa>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	8b 52 04             	mov    0x4(%edx),%edx
  802571:	89 50 04             	mov    %edx,0x4(%eax)
  802574:	eb 0b                	jmp    802581 <alloc_block_FF+0x2b5>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	a3 34 50 80 00       	mov    %eax,0x805034
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 0f                	je     80259a <alloc_block_FF+0x2ce>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 04             	mov    0x4(%eax),%eax
  802591:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802594:	8b 12                	mov    (%edx),%edx
  802596:	89 10                	mov    %edx,(%eax)
  802598:	eb 0a                	jmp    8025a4 <alloc_block_FF+0x2d8>
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025bc:	48                   	dec    %eax
  8025bd:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	6a 00                	push   $0x0
  8025c7:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025ca:	ff 75 b0             	pushl  -0x50(%ebp)
  8025cd:	e8 cb fc ff ff       	call   80229d <set_block_data>
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	e9 95 00 00 00       	jmp    80266f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	6a 01                	push   $0x1
  8025df:	ff 75 b8             	pushl  -0x48(%ebp)
  8025e2:	ff 75 bc             	pushl  -0x44(%ebp)
  8025e5:	e8 b3 fc ff ff       	call   80229d <set_block_data>
  8025ea:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f1:	75 17                	jne    80260a <alloc_block_FF+0x33e>
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 5f 44 80 00       	push   $0x80445f
  8025fb:	68 e8 00 00 00       	push   $0xe8
  802600:	68 7d 44 80 00       	push   $0x80447d
  802605:	e8 db 13 00 00       	call   8039e5 <_panic>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 10                	je     802623 <alloc_block_FF+0x357>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261b:	8b 52 04             	mov    0x4(%edx),%edx
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
  802621:	eb 0b                	jmp    80262e <alloc_block_FF+0x362>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	a3 34 50 80 00       	mov    %eax,0x805034
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 0f                	je     802647 <alloc_block_FF+0x37b>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	8b 12                	mov    (%edx),%edx
  802643:	89 10                	mov    %edx,(%eax)
  802645:	eb 0a                	jmp    802651 <alloc_block_FF+0x385>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	a3 30 50 80 00       	mov    %eax,0x805030
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802664:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802669:	48                   	dec    %eax
  80266a:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  80266f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802672:	e9 0f 01 00 00       	jmp    802786 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802677:	a1 38 50 80 00       	mov    0x805038,%eax
  80267c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802683:	74 07                	je     80268c <alloc_block_FF+0x3c0>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	eb 05                	jmp    802691 <alloc_block_FF+0x3c5>
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
  802691:	a3 38 50 80 00       	mov    %eax,0x805038
  802696:	a1 38 50 80 00       	mov    0x805038,%eax
  80269b:	85 c0                	test   %eax,%eax
  80269d:	0f 85 e9 fc ff ff    	jne    80238c <alloc_block_FF+0xc0>
  8026a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a7:	0f 85 df fc ff ff    	jne    80238c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	83 c0 08             	add    $0x8,%eax
  8026b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026b6:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026c3:	01 d0                	add    %edx,%eax
  8026c5:	48                   	dec    %eax
  8026c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d1:	f7 75 d8             	divl   -0x28(%ebp)
  8026d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d7:	29 d0                	sub    %edx,%eax
  8026d9:	c1 e8 0c             	shr    $0xc,%eax
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	50                   	push   %eax
  8026e0:	e8 1e ec ff ff       	call   801303 <sbrk>
  8026e5:	83 c4 10             	add    $0x10,%esp
  8026e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026eb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026ef:	75 0a                	jne    8026fb <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f6:	e9 8b 00 00 00       	jmp    802786 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026fb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802705:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802708:	01 d0                	add    %edx,%eax
  80270a:	48                   	dec    %eax
  80270b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80270e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802711:	ba 00 00 00 00       	mov    $0x0,%edx
  802716:	f7 75 cc             	divl   -0x34(%ebp)
  802719:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80271c:	29 d0                	sub    %edx,%eax
  80271e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802721:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802724:	01 d0                	add    %edx,%eax
  802726:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  80272b:	a1 44 50 80 00       	mov    0x805044,%eax
  802730:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802736:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80273d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802740:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802743:	01 d0                	add    %edx,%eax
  802745:	48                   	dec    %eax
  802746:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802749:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80274c:	ba 00 00 00 00       	mov    $0x0,%edx
  802751:	f7 75 c4             	divl   -0x3c(%ebp)
  802754:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802757:	29 d0                	sub    %edx,%eax
  802759:	83 ec 04             	sub    $0x4,%esp
  80275c:	6a 01                	push   $0x1
  80275e:	50                   	push   %eax
  80275f:	ff 75 d0             	pushl  -0x30(%ebp)
  802762:	e8 36 fb ff ff       	call   80229d <set_block_data>
  802767:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80276a:	83 ec 0c             	sub    $0xc,%esp
  80276d:	ff 75 d0             	pushl  -0x30(%ebp)
  802770:	e8 1b 0a 00 00       	call   803190 <free_block>
  802775:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802778:	83 ec 0c             	sub    $0xc,%esp
  80277b:	ff 75 08             	pushl  0x8(%ebp)
  80277e:	e8 49 fb ff ff       	call   8022cc <alloc_block_FF>
  802783:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802788:	55                   	push   %ebp
  802789:	89 e5                	mov    %esp,%ebp
  80278b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	83 e0 01             	and    $0x1,%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	74 03                	je     80279b <alloc_block_BF+0x13>
  802798:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80279b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80279f:	77 07                	ja     8027a8 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027a1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027a8:	a1 28 50 80 00       	mov    0x805028,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	75 73                	jne    802824 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	83 c0 10             	add    $0x10,%eax
  8027b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027ba:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c7:	01 d0                	add    %edx,%eax
  8027c9:	48                   	dec    %eax
  8027ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d5:	f7 75 e0             	divl   -0x20(%ebp)
  8027d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027db:	29 d0                	sub    %edx,%eax
  8027dd:	c1 e8 0c             	shr    $0xc,%eax
  8027e0:	83 ec 0c             	sub    $0xc,%esp
  8027e3:	50                   	push   %eax
  8027e4:	e8 1a eb ff ff       	call   801303 <sbrk>
  8027e9:	83 c4 10             	add    $0x10,%esp
  8027ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027ef:	83 ec 0c             	sub    $0xc,%esp
  8027f2:	6a 00                	push   $0x0
  8027f4:	e8 0a eb ff ff       	call   801303 <sbrk>
  8027f9:	83 c4 10             	add    $0x10,%esp
  8027fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802802:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802805:	83 ec 08             	sub    $0x8,%esp
  802808:	50                   	push   %eax
  802809:	ff 75 d8             	pushl  -0x28(%ebp)
  80280c:	e8 9f f8 ff ff       	call   8020b0 <initialize_dynamic_allocator>
  802811:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	68 bb 44 80 00       	push   $0x8044bb
  80281c:	e8 48 dd ff ff       	call   800569 <cprintf>
  802821:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802824:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80282b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802832:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802839:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802840:	a1 30 50 80 00       	mov    0x805030,%eax
  802845:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802848:	e9 1d 01 00 00       	jmp    80296a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802853:	83 ec 0c             	sub    $0xc,%esp
  802856:	ff 75 a8             	pushl  -0x58(%ebp)
  802859:	e8 ee f6 ff ff       	call   801f4c <get_block_size>
  80285e:	83 c4 10             	add    $0x10,%esp
  802861:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	83 c0 08             	add    $0x8,%eax
  80286a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80286d:	0f 87 ef 00 00 00    	ja     802962 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	83 c0 18             	add    $0x18,%eax
  802879:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80287c:	77 1d                	ja     80289b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80287e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802881:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802884:	0f 86 d8 00 00 00    	jbe    802962 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80288a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80288d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802890:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802893:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802896:	e9 c7 00 00 00       	jmp    802962 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	83 c0 08             	add    $0x8,%eax
  8028a1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a4:	0f 85 9d 00 00 00    	jne    802947 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	6a 01                	push   $0x1
  8028af:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028b2:	ff 75 a8             	pushl  -0x58(%ebp)
  8028b5:	e8 e3 f9 ff ff       	call   80229d <set_block_data>
  8028ba:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c1:	75 17                	jne    8028da <alloc_block_BF+0x152>
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	68 5f 44 80 00       	push   $0x80445f
  8028cb:	68 2c 01 00 00       	push   $0x12c
  8028d0:	68 7d 44 80 00       	push   $0x80447d
  8028d5:	e8 0b 11 00 00       	call   8039e5 <_panic>
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	74 10                	je     8028f3 <alloc_block_BF+0x16b>
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028eb:	8b 52 04             	mov    0x4(%edx),%edx
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	eb 0b                	jmp    8028fe <alloc_block_BF+0x176>
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	a3 34 50 80 00       	mov    %eax,0x805034
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	74 0f                	je     802917 <alloc_block_BF+0x18f>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802911:	8b 12                	mov    (%edx),%edx
  802913:	89 10                	mov    %edx,(%eax)
  802915:	eb 0a                	jmp    802921 <alloc_block_BF+0x199>
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	a3 30 50 80 00       	mov    %eax,0x805030
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802934:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802939:	48                   	dec    %eax
  80293a:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  80293f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802942:	e9 24 04 00 00       	jmp    802d6b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80294d:	76 13                	jbe    802962 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80294f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802956:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802959:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80295c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80295f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802962:	a1 38 50 80 00       	mov    0x805038,%eax
  802967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	74 07                	je     802977 <alloc_block_BF+0x1ef>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	eb 05                	jmp    80297c <alloc_block_BF+0x1f4>
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	a3 38 50 80 00       	mov    %eax,0x805038
  802981:	a1 38 50 80 00       	mov    0x805038,%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	0f 85 bf fe ff ff    	jne    80284d <alloc_block_BF+0xc5>
  80298e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802992:	0f 85 b5 fe ff ff    	jne    80284d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802998:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80299c:	0f 84 26 02 00 00    	je     802bc8 <alloc_block_BF+0x440>
  8029a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a6:	0f 85 1c 02 00 00    	jne    802bc8 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029af:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b2:	83 e8 08             	sub    $0x8,%eax
  8029b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	8d 50 08             	lea    0x8(%eax),%edx
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	83 c0 08             	add    $0x8,%eax
  8029cc:	83 ec 04             	sub    $0x4,%esp
  8029cf:	6a 01                	push   $0x1
  8029d1:	50                   	push   %eax
  8029d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8029d5:	e8 c3 f8 ff ff       	call   80229d <set_block_data>
  8029da:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	75 68                	jne    802a4f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029eb:	75 17                	jne    802a04 <alloc_block_BF+0x27c>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 98 44 80 00       	push   $0x804498
  8029f5:	68 45 01 00 00       	push   $0x145
  8029fa:	68 7d 44 80 00       	push   $0x80447d
  8029ff:	e8 e1 0f 00 00       	call   8039e5 <_panic>
  802a04:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 0d                	je     802a25 <alloc_block_BF+0x29d>
  802a18:	a1 30 50 80 00       	mov    0x805030,%eax
  802a1d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 08                	jmp    802a2d <alloc_block_BF+0x2a5>
  802a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a28:	a3 34 50 80 00       	mov    %eax,0x805034
  802a2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a30:	a3 30 50 80 00       	mov    %eax,0x805030
  802a35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a44:	40                   	inc    %eax
  802a45:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a4a:	e9 dc 00 00 00       	jmp    802b2b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	75 65                	jne    802abd <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a58:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_BF+0x2ed>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 cc 44 80 00       	push   $0x8044cc
  802a66:	68 4a 01 00 00       	push   $0x14a
  802a6b:	68 7d 44 80 00       	push   $0x80447d
  802a70:	e8 70 0f 00 00       	call   8039e5 <_panic>
  802a75:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 0c                	je     802a97 <alloc_block_BF+0x30f>
  802a8b:	a1 34 50 80 00       	mov    0x805034,%eax
  802a90:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a93:	89 10                	mov    %edx,(%eax)
  802a95:	eb 08                	jmp    802a9f <alloc_block_BF+0x317>
  802a97:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa2:	a3 34 50 80 00       	mov    %eax,0x805034
  802aa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ab5:	40                   	inc    %eax
  802ab6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802abb:	eb 6e                	jmp    802b2b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac1:	74 06                	je     802ac9 <alloc_block_BF+0x341>
  802ac3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac7:	75 17                	jne    802ae0 <alloc_block_BF+0x358>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 f0 44 80 00       	push   $0x8044f0
  802ad1:	68 4f 01 00 00       	push   $0x14f
  802ad6:	68 7d 44 80 00       	push   $0x80447d
  802adb:	e8 05 0f 00 00       	call   8039e5 <_panic>
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 10                	mov    (%eax),%edx
  802ae5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae8:	89 10                	mov    %edx,(%eax)
  802aea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	74 0b                	je     802afe <alloc_block_BF+0x376>
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802afb:	89 50 04             	mov    %edx,0x4(%eax)
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b04:	89 10                	mov    %edx,(%eax)
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	75 08                	jne    802b20 <alloc_block_BF+0x398>
  802b18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1b:	a3 34 50 80 00       	mov    %eax,0x805034
  802b20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b25:	40                   	inc    %eax
  802b26:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2f:	75 17                	jne    802b48 <alloc_block_BF+0x3c0>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 5f 44 80 00       	push   $0x80445f
  802b39:	68 51 01 00 00       	push   $0x151
  802b3e:	68 7d 44 80 00       	push   $0x80447d
  802b43:	e8 9d 0e 00 00       	call   8039e5 <_panic>
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 10                	je     802b61 <alloc_block_BF+0x3d9>
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b59:	8b 52 04             	mov    0x4(%edx),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 0b                	jmp    802b6c <alloc_block_BF+0x3e4>
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	a3 34 50 80 00       	mov    %eax,0x805034
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0f                	je     802b85 <alloc_block_BF+0x3fd>
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7f:	8b 12                	mov    (%edx),%edx
  802b81:	89 10                	mov    %edx,(%eax)
  802b83:	eb 0a                	jmp    802b8f <alloc_block_BF+0x407>
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ba7:	48                   	dec    %eax
  802ba8:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	6a 00                	push   $0x0
  802bb2:	ff 75 d0             	pushl  -0x30(%ebp)
  802bb5:	ff 75 cc             	pushl  -0x34(%ebp)
  802bb8:	e8 e0 f6 ff ff       	call   80229d <set_block_data>
  802bbd:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	e9 a3 01 00 00       	jmp    802d6b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bc8:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bcc:	0f 85 9d 00 00 00    	jne    802c6f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	6a 01                	push   $0x1
  802bd7:	ff 75 ec             	pushl  -0x14(%ebp)
  802bda:	ff 75 f0             	pushl  -0x10(%ebp)
  802bdd:	e8 bb f6 ff ff       	call   80229d <set_block_data>
  802be2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be9:	75 17                	jne    802c02 <alloc_block_BF+0x47a>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 5f 44 80 00       	push   $0x80445f
  802bf3:	68 58 01 00 00       	push   $0x158
  802bf8:	68 7d 44 80 00       	push   $0x80447d
  802bfd:	e8 e3 0d 00 00       	call   8039e5 <_panic>
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 10                	je     802c1b <alloc_block_BF+0x493>
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c13:	8b 52 04             	mov    0x4(%edx),%edx
  802c16:	89 50 04             	mov    %edx,0x4(%eax)
  802c19:	eb 0b                	jmp    802c26 <alloc_block_BF+0x49e>
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	a3 34 50 80 00       	mov    %eax,0x805034
  802c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 0f                	je     802c3f <alloc_block_BF+0x4b7>
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c39:	8b 12                	mov    (%edx),%edx
  802c3b:	89 10                	mov    %edx,(%eax)
  802c3d:	eb 0a                	jmp    802c49 <alloc_block_BF+0x4c1>
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	a3 30 50 80 00       	mov    %eax,0x805030
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c61:	48                   	dec    %eax
  802c62:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6a:	e9 fc 00 00 00       	jmp    802d6b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	83 c0 08             	add    $0x8,%eax
  802c75:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c78:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c7f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c82:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c85:	01 d0                	add    %edx,%eax
  802c87:	48                   	dec    %eax
  802c88:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c93:	f7 75 c4             	divl   -0x3c(%ebp)
  802c96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c99:	29 d0                	sub    %edx,%eax
  802c9b:	c1 e8 0c             	shr    $0xc,%eax
  802c9e:	83 ec 0c             	sub    $0xc,%esp
  802ca1:	50                   	push   %eax
  802ca2:	e8 5c e6 ff ff       	call   801303 <sbrk>
  802ca7:	83 c4 10             	add    $0x10,%esp
  802caa:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cad:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cb1:	75 0a                	jne    802cbd <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb8:	e9 ae 00 00 00       	jmp    802d6b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cbd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cc4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cca:	01 d0                	add    %edx,%eax
  802ccc:	48                   	dec    %eax
  802ccd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cd0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cd3:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd8:	f7 75 b8             	divl   -0x48(%ebp)
  802cdb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cde:	29 d0                	sub    %edx,%eax
  802ce0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ce3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802ced:	a1 44 50 80 00       	mov    0x805044,%eax
  802cf2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cf8:	83 ec 0c             	sub    $0xc,%esp
  802cfb:	68 24 45 80 00       	push   $0x804524
  802d00:	e8 64 d8 ff ff       	call   800569 <cprintf>
  802d05:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d08:	83 ec 08             	sub    $0x8,%esp
  802d0b:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0e:	68 29 45 80 00       	push   $0x804529
  802d13:	e8 51 d8 ff ff       	call   800569 <cprintf>
  802d18:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d1b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d22:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d28:	01 d0                	add    %edx,%eax
  802d2a:	48                   	dec    %eax
  802d2b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d2e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d31:	ba 00 00 00 00       	mov    $0x0,%edx
  802d36:	f7 75 b0             	divl   -0x50(%ebp)
  802d39:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d3c:	29 d0                	sub    %edx,%eax
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	6a 01                	push   $0x1
  802d43:	50                   	push   %eax
  802d44:	ff 75 bc             	pushl  -0x44(%ebp)
  802d47:	e8 51 f5 ff ff       	call   80229d <set_block_data>
  802d4c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d4f:	83 ec 0c             	sub    $0xc,%esp
  802d52:	ff 75 bc             	pushl  -0x44(%ebp)
  802d55:	e8 36 04 00 00       	call   803190 <free_block>
  802d5a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d5d:	83 ec 0c             	sub    $0xc,%esp
  802d60:	ff 75 08             	pushl  0x8(%ebp)
  802d63:	e8 20 fa ff ff       	call   802788 <alloc_block_BF>
  802d68:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d6b:	c9                   	leave  
  802d6c:	c3                   	ret    

00802d6d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
  802d70:	53                   	push   %ebx
  802d71:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d7b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d86:	74 1e                	je     802da6 <merging+0x39>
  802d88:	ff 75 08             	pushl  0x8(%ebp)
  802d8b:	e8 bc f1 ff ff       	call   801f4c <get_block_size>
  802d90:	83 c4 04             	add    $0x4,%esp
  802d93:	89 c2                	mov    %eax,%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	01 d0                	add    %edx,%eax
  802d9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d9d:	75 07                	jne    802da6 <merging+0x39>
		prev_is_free = 1;
  802d9f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802da6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802daa:	74 1e                	je     802dca <merging+0x5d>
  802dac:	ff 75 10             	pushl  0x10(%ebp)
  802daf:	e8 98 f1 ff ff       	call   801f4c <get_block_size>
  802db4:	83 c4 04             	add    $0x4,%esp
  802db7:	89 c2                	mov    %eax,%edx
  802db9:	8b 45 10             	mov    0x10(%ebp),%eax
  802dbc:	01 d0                	add    %edx,%eax
  802dbe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dc1:	75 07                	jne    802dca <merging+0x5d>
		next_is_free = 1;
  802dc3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dce:	0f 84 cc 00 00 00    	je     802ea0 <merging+0x133>
  802dd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd8:	0f 84 c2 00 00 00    	je     802ea0 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dde:	ff 75 08             	pushl  0x8(%ebp)
  802de1:	e8 66 f1 ff ff       	call   801f4c <get_block_size>
  802de6:	83 c4 04             	add    $0x4,%esp
  802de9:	89 c3                	mov    %eax,%ebx
  802deb:	ff 75 10             	pushl  0x10(%ebp)
  802dee:	e8 59 f1 ff ff       	call   801f4c <get_block_size>
  802df3:	83 c4 04             	add    $0x4,%esp
  802df6:	01 c3                	add    %eax,%ebx
  802df8:	ff 75 0c             	pushl  0xc(%ebp)
  802dfb:	e8 4c f1 ff ff       	call   801f4c <get_block_size>
  802e00:	83 c4 04             	add    $0x4,%esp
  802e03:	01 d8                	add    %ebx,%eax
  802e05:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e08:	6a 00                	push   $0x0
  802e0a:	ff 75 ec             	pushl  -0x14(%ebp)
  802e0d:	ff 75 08             	pushl  0x8(%ebp)
  802e10:	e8 88 f4 ff ff       	call   80229d <set_block_data>
  802e15:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e1c:	75 17                	jne    802e35 <merging+0xc8>
  802e1e:	83 ec 04             	sub    $0x4,%esp
  802e21:	68 5f 44 80 00       	push   $0x80445f
  802e26:	68 7d 01 00 00       	push   $0x17d
  802e2b:	68 7d 44 80 00       	push   $0x80447d
  802e30:	e8 b0 0b 00 00       	call   8039e5 <_panic>
  802e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 10                	je     802e4e <merging+0xe1>
  802e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e46:	8b 52 04             	mov    0x4(%edx),%edx
  802e49:	89 50 04             	mov    %edx,0x4(%eax)
  802e4c:	eb 0b                	jmp    802e59 <merging+0xec>
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	a3 34 50 80 00       	mov    %eax,0x805034
  802e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	74 0f                	je     802e72 <merging+0x105>
  802e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e66:	8b 40 04             	mov    0x4(%eax),%eax
  802e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6c:	8b 12                	mov    (%edx),%edx
  802e6e:	89 10                	mov    %edx,(%eax)
  802e70:	eb 0a                	jmp    802e7c <merging+0x10f>
  802e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	a3 30 50 80 00       	mov    %eax,0x805030
  802e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e94:	48                   	dec    %eax
  802e95:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e9a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e9b:	e9 ea 02 00 00       	jmp    80318a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea4:	74 3b                	je     802ee1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ea6:	83 ec 0c             	sub    $0xc,%esp
  802ea9:	ff 75 08             	pushl  0x8(%ebp)
  802eac:	e8 9b f0 ff ff       	call   801f4c <get_block_size>
  802eb1:	83 c4 10             	add    $0x10,%esp
  802eb4:	89 c3                	mov    %eax,%ebx
  802eb6:	83 ec 0c             	sub    $0xc,%esp
  802eb9:	ff 75 10             	pushl  0x10(%ebp)
  802ebc:	e8 8b f0 ff ff       	call   801f4c <get_block_size>
  802ec1:	83 c4 10             	add    $0x10,%esp
  802ec4:	01 d8                	add    %ebx,%eax
  802ec6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	6a 00                	push   $0x0
  802ece:	ff 75 e8             	pushl  -0x18(%ebp)
  802ed1:	ff 75 08             	pushl  0x8(%ebp)
  802ed4:	e8 c4 f3 ff ff       	call   80229d <set_block_data>
  802ed9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802edc:	e9 a9 02 00 00       	jmp    80318a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee5:	0f 84 2d 01 00 00    	je     803018 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802eeb:	83 ec 0c             	sub    $0xc,%esp
  802eee:	ff 75 10             	pushl  0x10(%ebp)
  802ef1:	e8 56 f0 ff ff       	call   801f4c <get_block_size>
  802ef6:	83 c4 10             	add    $0x10,%esp
  802ef9:	89 c3                	mov    %eax,%ebx
  802efb:	83 ec 0c             	sub    $0xc,%esp
  802efe:	ff 75 0c             	pushl  0xc(%ebp)
  802f01:	e8 46 f0 ff ff       	call   801f4c <get_block_size>
  802f06:	83 c4 10             	add    $0x10,%esp
  802f09:	01 d8                	add    %ebx,%eax
  802f0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	6a 00                	push   $0x0
  802f13:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f16:	ff 75 10             	pushl  0x10(%ebp)
  802f19:	e8 7f f3 ff ff       	call   80229d <set_block_data>
  802f1e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f21:	8b 45 10             	mov    0x10(%ebp),%eax
  802f24:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2b:	74 06                	je     802f33 <merging+0x1c6>
  802f2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f31:	75 17                	jne    802f4a <merging+0x1dd>
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	68 38 45 80 00       	push   $0x804538
  802f3b:	68 8d 01 00 00       	push   $0x18d
  802f40:	68 7d 44 80 00       	push   $0x80447d
  802f45:	e8 9b 0a 00 00       	call   8039e5 <_panic>
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	8b 50 04             	mov    0x4(%eax),%edx
  802f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	85 c0                	test   %eax,%eax
  802f66:	74 0d                	je     802f75 <merging+0x208>
  802f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	eb 08                	jmp    802f7d <merging+0x210>
  802f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f78:	a3 30 50 80 00       	mov    %eax,0x805030
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f8b:	40                   	inc    %eax
  802f8c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802f91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f95:	75 17                	jne    802fae <merging+0x241>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 5f 44 80 00       	push   $0x80445f
  802f9f:	68 8e 01 00 00       	push   $0x18e
  802fa4:	68 7d 44 80 00       	push   $0x80447d
  802fa9:	e8 37 0a 00 00       	call   8039e5 <_panic>
  802fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 10                	je     802fc7 <merging+0x25a>
  802fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbf:	8b 52 04             	mov    0x4(%edx),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 0b                	jmp    802fd2 <merging+0x265>
  802fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	a3 34 50 80 00       	mov    %eax,0x805034
  802fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0f                	je     802feb <merging+0x27e>
  802fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe5:	8b 12                	mov    (%edx),%edx
  802fe7:	89 10                	mov    %edx,(%eax)
  802fe9:	eb 0a                	jmp    802ff5 <merging+0x288>
  802feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803001:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803008:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80300d:	48                   	dec    %eax
  80300e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803013:	e9 72 01 00 00       	jmp    80318a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803018:	8b 45 10             	mov    0x10(%ebp),%eax
  80301b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80301e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803022:	74 79                	je     80309d <merging+0x330>
  803024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803028:	74 73                	je     80309d <merging+0x330>
  80302a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302e:	74 06                	je     803036 <merging+0x2c9>
  803030:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803034:	75 17                	jne    80304d <merging+0x2e0>
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	68 f0 44 80 00       	push   $0x8044f0
  80303e:	68 94 01 00 00       	push   $0x194
  803043:	68 7d 44 80 00       	push   $0x80447d
  803048:	e8 98 09 00 00       	call   8039e5 <_panic>
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	8b 10                	mov    (%eax),%edx
  803052:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	74 0b                	je     80306b <merging+0x2fe>
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803071:	89 10                	mov    %edx,(%eax)
  803073:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803076:	8b 55 08             	mov    0x8(%ebp),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	75 08                	jne    80308d <merging+0x320>
  803085:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803088:	a3 34 50 80 00       	mov    %eax,0x805034
  80308d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803092:	40                   	inc    %eax
  803093:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803098:	e9 ce 00 00 00       	jmp    80316b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80309d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a1:	74 65                	je     803108 <merging+0x39b>
  8030a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a7:	75 17                	jne    8030c0 <merging+0x353>
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 cc 44 80 00       	push   $0x8044cc
  8030b1:	68 95 01 00 00       	push   $0x195
  8030b6:	68 7d 44 80 00       	push   $0x80447d
  8030bb:	e8 25 09 00 00       	call   8039e5 <_panic>
  8030c0:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	74 0c                	je     8030e2 <merging+0x375>
  8030d6:	a1 34 50 80 00       	mov    0x805034,%eax
  8030db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030de:	89 10                	mov    %edx,(%eax)
  8030e0:	eb 08                	jmp    8030ea <merging+0x37d>
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ed:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803100:	40                   	inc    %eax
  803101:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803106:	eb 63                	jmp    80316b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803108:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80310c:	75 17                	jne    803125 <merging+0x3b8>
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	68 98 44 80 00       	push   $0x804498
  803116:	68 98 01 00 00       	push   $0x198
  80311b:	68 7d 44 80 00       	push   $0x80447d
  803120:	e8 c0 08 00 00       	call   8039e5 <_panic>
  803125:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80312b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312e:	89 10                	mov    %edx,(%eax)
  803130:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	74 0d                	je     803146 <merging+0x3d9>
  803139:	a1 30 50 80 00       	mov    0x805030,%eax
  80313e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803141:	89 50 04             	mov    %edx,0x4(%eax)
  803144:	eb 08                	jmp    80314e <merging+0x3e1>
  803146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803149:	a3 34 50 80 00       	mov    %eax,0x805034
  80314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803151:	a3 30 50 80 00       	mov    %eax,0x805030
  803156:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803160:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803165:	40                   	inc    %eax
  803166:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80316b:	83 ec 0c             	sub    $0xc,%esp
  80316e:	ff 75 10             	pushl  0x10(%ebp)
  803171:	e8 d6 ed ff ff       	call   801f4c <get_block_size>
  803176:	83 c4 10             	add    $0x10,%esp
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	6a 00                	push   $0x0
  80317e:	50                   	push   %eax
  80317f:	ff 75 10             	pushl  0x10(%ebp)
  803182:	e8 16 f1 ff ff       	call   80229d <set_block_data>
  803187:	83 c4 10             	add    $0x10,%esp
	}
}
  80318a:	90                   	nop
  80318b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80318e:	c9                   	leave  
  80318f:	c3                   	ret    

00803190 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803190:	55                   	push   %ebp
  803191:	89 e5                	mov    %esp,%ebp
  803193:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803196:	a1 30 50 80 00       	mov    0x805030,%eax
  80319b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80319e:	a1 34 50 80 00       	mov    0x805034,%eax
  8031a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a6:	73 1b                	jae    8031c3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	ff 75 08             	pushl  0x8(%ebp)
  8031b3:	6a 00                	push   $0x0
  8031b5:	50                   	push   %eax
  8031b6:	e8 b2 fb ff ff       	call   802d6d <merging>
  8031bb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031be:	e9 8b 00 00 00       	jmp    80324e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031c3:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cb:	76 18                	jbe    8031e5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031cd:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d2:	83 ec 04             	sub    $0x4,%esp
  8031d5:	ff 75 08             	pushl  0x8(%ebp)
  8031d8:	50                   	push   %eax
  8031d9:	6a 00                	push   $0x0
  8031db:	e8 8d fb ff ff       	call   802d6d <merging>
  8031e0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e3:	eb 69                	jmp    80324e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031e5:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ed:	eb 39                	jmp    803228 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f5:	73 29                	jae    803220 <free_block+0x90>
  8031f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ff:	76 1f                	jbe    803220 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803209:	83 ec 04             	sub    $0x4,%esp
  80320c:	ff 75 08             	pushl  0x8(%ebp)
  80320f:	ff 75 f0             	pushl  -0x10(%ebp)
  803212:	ff 75 f4             	pushl  -0xc(%ebp)
  803215:	e8 53 fb ff ff       	call   802d6d <merging>
  80321a:	83 c4 10             	add    $0x10,%esp
			break;
  80321d:	90                   	nop
		}
	}
}
  80321e:	eb 2e                	jmp    80324e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803220:	a1 38 50 80 00       	mov    0x805038,%eax
  803225:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322c:	74 07                	je     803235 <free_block+0xa5>
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	eb 05                	jmp    80323a <free_block+0xaa>
  803235:	b8 00 00 00 00       	mov    $0x0,%eax
  80323a:	a3 38 50 80 00       	mov    %eax,0x805038
  80323f:	a1 38 50 80 00       	mov    0x805038,%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	75 a7                	jne    8031ef <free_block+0x5f>
  803248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324c:	75 a1                	jne    8031ef <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324e:	90                   	nop
  80324f:	c9                   	leave  
  803250:	c3                   	ret    

00803251 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803251:	55                   	push   %ebp
  803252:	89 e5                	mov    %esp,%ebp
  803254:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803257:	ff 75 08             	pushl  0x8(%ebp)
  80325a:	e8 ed ec ff ff       	call   801f4c <get_block_size>
  80325f:	83 c4 04             	add    $0x4,%esp
  803262:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803265:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80326c:	eb 17                	jmp    803285 <copy_data+0x34>
  80326e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803271:	8b 45 0c             	mov    0xc(%ebp),%eax
  803274:	01 c2                	add    %eax,%edx
  803276:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	01 c8                	add    %ecx,%eax
  80327e:	8a 00                	mov    (%eax),%al
  803280:	88 02                	mov    %al,(%edx)
  803282:	ff 45 fc             	incl   -0x4(%ebp)
  803285:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803288:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80328b:	72 e1                	jb     80326e <copy_data+0x1d>
}
  80328d:	90                   	nop
  80328e:	c9                   	leave  
  80328f:	c3                   	ret    

00803290 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803290:	55                   	push   %ebp
  803291:	89 e5                	mov    %esp,%ebp
  803293:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803296:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329a:	75 23                	jne    8032bf <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80329c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032a0:	74 13                	je     8032b5 <realloc_block_FF+0x25>
  8032a2:	83 ec 0c             	sub    $0xc,%esp
  8032a5:	ff 75 0c             	pushl  0xc(%ebp)
  8032a8:	e8 1f f0 ff ff       	call   8022cc <alloc_block_FF>
  8032ad:	83 c4 10             	add    $0x10,%esp
  8032b0:	e9 f4 06 00 00       	jmp    8039a9 <realloc_block_FF+0x719>
		return NULL;
  8032b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ba:	e9 ea 06 00 00       	jmp    8039a9 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c3:	75 18                	jne    8032dd <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032c5:	83 ec 0c             	sub    $0xc,%esp
  8032c8:	ff 75 08             	pushl  0x8(%ebp)
  8032cb:	e8 c0 fe ff ff       	call   803190 <free_block>
  8032d0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d8:	e9 cc 06 00 00       	jmp    8039a9 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032dd:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032e1:	77 07                	ja     8032ea <realloc_block_FF+0x5a>
  8032e3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ed:	83 e0 01             	and    $0x1,%eax
  8032f0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f6:	83 c0 08             	add    $0x8,%eax
  8032f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032fc:	83 ec 0c             	sub    $0xc,%esp
  8032ff:	ff 75 08             	pushl  0x8(%ebp)
  803302:	e8 45 ec ff ff       	call   801f4c <get_block_size>
  803307:	83 c4 10             	add    $0x10,%esp
  80330a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80330d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803310:	83 e8 08             	sub    $0x8,%eax
  803313:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	83 e8 04             	sub    $0x4,%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	83 e0 fe             	and    $0xfffffffe,%eax
  803321:	89 c2                	mov    %eax,%edx
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	01 d0                	add    %edx,%eax
  803328:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80332b:	83 ec 0c             	sub    $0xc,%esp
  80332e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803331:	e8 16 ec ff ff       	call   801f4c <get_block_size>
  803336:	83 c4 10             	add    $0x10,%esp
  803339:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80333c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333f:	83 e8 08             	sub    $0x8,%eax
  803342:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803345:	8b 45 0c             	mov    0xc(%ebp),%eax
  803348:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80334b:	75 08                	jne    803355 <realloc_block_FF+0xc5>
	{
		 return va;
  80334d:	8b 45 08             	mov    0x8(%ebp),%eax
  803350:	e9 54 06 00 00       	jmp    8039a9 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803355:	8b 45 0c             	mov    0xc(%ebp),%eax
  803358:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80335b:	0f 83 e5 03 00 00    	jae    803746 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	2b 45 0c             	sub    0xc(%ebp),%eax
  803367:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803370:	e8 f0 eb ff ff       	call   801f65 <is_free_block>
  803375:	83 c4 10             	add    $0x10,%esp
  803378:	84 c0                	test   %al,%al
  80337a:	0f 84 3b 01 00 00    	je     8034bb <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803380:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803383:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803386:	01 d0                	add    %edx,%eax
  803388:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80338b:	83 ec 04             	sub    $0x4,%esp
  80338e:	6a 01                	push   $0x1
  803390:	ff 75 f0             	pushl  -0x10(%ebp)
  803393:	ff 75 08             	pushl  0x8(%ebp)
  803396:	e8 02 ef ff ff       	call   80229d <set_block_data>
  80339b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	83 e8 04             	sub    $0x4,%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a9:	89 c2                	mov    %eax,%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	01 d0                	add    %edx,%eax
  8033b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033b3:	83 ec 04             	sub    $0x4,%esp
  8033b6:	6a 00                	push   $0x0
  8033b8:	ff 75 cc             	pushl  -0x34(%ebp)
  8033bb:	ff 75 c8             	pushl  -0x38(%ebp)
  8033be:	e8 da ee ff ff       	call   80229d <set_block_data>
  8033c3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033ca:	74 06                	je     8033d2 <realloc_block_FF+0x142>
  8033cc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033d0:	75 17                	jne    8033e9 <realloc_block_FF+0x159>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 f0 44 80 00       	push   $0x8044f0
  8033da:	68 f6 01 00 00       	push   $0x1f6
  8033df:	68 7d 44 80 00       	push   $0x80447d
  8033e4:	e8 fc 05 00 00       	call   8039e5 <_panic>
  8033e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ec:	8b 10                	mov    (%eax),%edx
  8033ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f1:	89 10                	mov    %edx,(%eax)
  8033f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	74 0b                	je     803407 <realloc_block_FF+0x177>
  8033fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80340d:	89 10                	mov    %edx,(%eax)
  80340f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803412:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803415:	89 50 04             	mov    %edx,0x4(%eax)
  803418:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	75 08                	jne    803429 <realloc_block_FF+0x199>
  803421:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803424:	a3 34 50 80 00       	mov    %eax,0x805034
  803429:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80342e:	40                   	inc    %eax
  80342f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803434:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803438:	75 17                	jne    803451 <realloc_block_FF+0x1c1>
  80343a:	83 ec 04             	sub    $0x4,%esp
  80343d:	68 5f 44 80 00       	push   $0x80445f
  803442:	68 f7 01 00 00       	push   $0x1f7
  803447:	68 7d 44 80 00       	push   $0x80447d
  80344c:	e8 94 05 00 00       	call   8039e5 <_panic>
  803451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 10                	je     80346a <realloc_block_FF+0x1da>
  80345a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803462:	8b 52 04             	mov    0x4(%edx),%edx
  803465:	89 50 04             	mov    %edx,0x4(%eax)
  803468:	eb 0b                	jmp    803475 <realloc_block_FF+0x1e5>
  80346a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346d:	8b 40 04             	mov    0x4(%eax),%eax
  803470:	a3 34 50 80 00       	mov    %eax,0x805034
  803475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803478:	8b 40 04             	mov    0x4(%eax),%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	74 0f                	je     80348e <realloc_block_FF+0x1fe>
  80347f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803488:	8b 12                	mov    (%edx),%edx
  80348a:	89 10                	mov    %edx,(%eax)
  80348c:	eb 0a                	jmp    803498 <realloc_block_FF+0x208>
  80348e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803491:	8b 00                	mov    (%eax),%eax
  803493:	a3 30 50 80 00       	mov    %eax,0x805030
  803498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034b0:	48                   	dec    %eax
  8034b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8034b6:	e9 83 02 00 00       	jmp    80373e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034bb:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034bf:	0f 86 69 02 00 00    	jbe    80372e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	6a 01                	push   $0x1
  8034ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8034cd:	ff 75 08             	pushl  0x8(%ebp)
  8034d0:	e8 c8 ed ff ff       	call   80229d <set_block_data>
  8034d5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	83 e8 04             	sub    $0x4,%eax
  8034de:	8b 00                	mov    (%eax),%eax
  8034e0:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e3:	89 c2                	mov    %eax,%edx
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	01 d0                	add    %edx,%eax
  8034ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034ed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034f9:	75 68                	jne    803563 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ff:	75 17                	jne    803518 <realloc_block_FF+0x288>
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 98 44 80 00       	push   $0x804498
  803509:	68 06 02 00 00       	push   $0x206
  80350e:	68 7d 44 80 00       	push   $0x80447d
  803513:	e8 cd 04 00 00       	call   8039e5 <_panic>
  803518:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80351e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803521:	89 10                	mov    %edx,(%eax)
  803523:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803526:	8b 00                	mov    (%eax),%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 0d                	je     803539 <realloc_block_FF+0x2a9>
  80352c:	a1 30 50 80 00       	mov    0x805030,%eax
  803531:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803534:	89 50 04             	mov    %edx,0x4(%eax)
  803537:	eb 08                	jmp    803541 <realloc_block_FF+0x2b1>
  803539:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353c:	a3 34 50 80 00       	mov    %eax,0x805034
  803541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803544:	a3 30 50 80 00       	mov    %eax,0x805030
  803549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803553:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803558:	40                   	inc    %eax
  803559:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80355e:	e9 b0 01 00 00       	jmp    803713 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803563:	a1 30 50 80 00       	mov    0x805030,%eax
  803568:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80356b:	76 68                	jbe    8035d5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80356d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803571:	75 17                	jne    80358a <realloc_block_FF+0x2fa>
  803573:	83 ec 04             	sub    $0x4,%esp
  803576:	68 98 44 80 00       	push   $0x804498
  80357b:	68 0b 02 00 00       	push   $0x20b
  803580:	68 7d 44 80 00       	push   $0x80447d
  803585:	e8 5b 04 00 00       	call   8039e5 <_panic>
  80358a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803593:	89 10                	mov    %edx,(%eax)
  803595:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803598:	8b 00                	mov    (%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0d                	je     8035ab <realloc_block_FF+0x31b>
  80359e:	a1 30 50 80 00       	mov    0x805030,%eax
  8035a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035a6:	89 50 04             	mov    %edx,0x4(%eax)
  8035a9:	eb 08                	jmp    8035b3 <realloc_block_FF+0x323>
  8035ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035ca:	40                   	inc    %eax
  8035cb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035d0:	e9 3e 01 00 00       	jmp    803713 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035d5:	a1 30 50 80 00       	mov    0x805030,%eax
  8035da:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035dd:	73 68                	jae    803647 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035df:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e3:	75 17                	jne    8035fc <realloc_block_FF+0x36c>
  8035e5:	83 ec 04             	sub    $0x4,%esp
  8035e8:	68 cc 44 80 00       	push   $0x8044cc
  8035ed:	68 10 02 00 00       	push   $0x210
  8035f2:	68 7d 44 80 00       	push   $0x80447d
  8035f7:	e8 e9 03 00 00       	call   8039e5 <_panic>
  8035fc:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803605:	89 50 04             	mov    %edx,0x4(%eax)
  803608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0c                	je     80361e <realloc_block_FF+0x38e>
  803612:	a1 34 50 80 00       	mov    0x805034,%eax
  803617:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	eb 08                	jmp    803626 <realloc_block_FF+0x396>
  80361e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803621:	a3 30 50 80 00       	mov    %eax,0x805030
  803626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803629:	a3 34 50 80 00       	mov    %eax,0x805034
  80362e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803637:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80363c:	40                   	inc    %eax
  80363d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803642:	e9 cc 00 00 00       	jmp    803713 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803647:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80364e:	a1 30 50 80 00       	mov    0x805030,%eax
  803653:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803656:	e9 8a 00 00 00       	jmp    8036e5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803661:	73 7a                	jae    8036dd <realloc_block_FF+0x44d>
  803663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803666:	8b 00                	mov    (%eax),%eax
  803668:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80366b:	73 70                	jae    8036dd <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80366d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803671:	74 06                	je     803679 <realloc_block_FF+0x3e9>
  803673:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803677:	75 17                	jne    803690 <realloc_block_FF+0x400>
  803679:	83 ec 04             	sub    $0x4,%esp
  80367c:	68 f0 44 80 00       	push   $0x8044f0
  803681:	68 1a 02 00 00       	push   $0x21a
  803686:	68 7d 44 80 00       	push   $0x80447d
  80368b:	e8 55 03 00 00       	call   8039e5 <_panic>
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 10                	mov    (%eax),%edx
  803695:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803698:	89 10                	mov    %edx,(%eax)
  80369a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369d:	8b 00                	mov    (%eax),%eax
  80369f:	85 c0                	test   %eax,%eax
  8036a1:	74 0b                	je     8036ae <realloc_block_FF+0x41e>
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ab:	89 50 04             	mov    %edx,0x4(%eax)
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b4:	89 10                	mov    %edx,(%eax)
  8036b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036bc:	89 50 04             	mov    %edx,0x4(%eax)
  8036bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	85 c0                	test   %eax,%eax
  8036c6:	75 08                	jne    8036d0 <realloc_block_FF+0x440>
  8036c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cb:	a3 34 50 80 00       	mov    %eax,0x805034
  8036d0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036d5:	40                   	inc    %eax
  8036d6:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8036db:	eb 36                	jmp    803713 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e9:	74 07                	je     8036f2 <realloc_block_FF+0x462>
  8036eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	eb 05                	jmp    8036f7 <realloc_block_FF+0x467>
  8036f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803701:	85 c0                	test   %eax,%eax
  803703:	0f 85 52 ff ff ff    	jne    80365b <realloc_block_FF+0x3cb>
  803709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370d:	0f 85 48 ff ff ff    	jne    80365b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803713:	83 ec 04             	sub    $0x4,%esp
  803716:	6a 00                	push   $0x0
  803718:	ff 75 d8             	pushl  -0x28(%ebp)
  80371b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80371e:	e8 7a eb ff ff       	call   80229d <set_block_data>
  803723:	83 c4 10             	add    $0x10,%esp
				return va;
  803726:	8b 45 08             	mov    0x8(%ebp),%eax
  803729:	e9 7b 02 00 00       	jmp    8039a9 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80372e:	83 ec 0c             	sub    $0xc,%esp
  803731:	68 6d 45 80 00       	push   $0x80456d
  803736:	e8 2e ce ff ff       	call   800569 <cprintf>
  80373b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	e9 63 02 00 00       	jmp    8039a9 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803746:	8b 45 0c             	mov    0xc(%ebp),%eax
  803749:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80374c:	0f 86 4d 02 00 00    	jbe    80399f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803752:	83 ec 0c             	sub    $0xc,%esp
  803755:	ff 75 e4             	pushl  -0x1c(%ebp)
  803758:	e8 08 e8 ff ff       	call   801f65 <is_free_block>
  80375d:	83 c4 10             	add    $0x10,%esp
  803760:	84 c0                	test   %al,%al
  803762:	0f 84 37 02 00 00    	je     80399f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80376e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803771:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803774:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803777:	76 38                	jbe    8037b1 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803779:	83 ec 0c             	sub    $0xc,%esp
  80377c:	ff 75 08             	pushl  0x8(%ebp)
  80377f:	e8 0c fa ff ff       	call   803190 <free_block>
  803784:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803787:	83 ec 0c             	sub    $0xc,%esp
  80378a:	ff 75 0c             	pushl  0xc(%ebp)
  80378d:	e8 3a eb ff ff       	call   8022cc <alloc_block_FF>
  803792:	83 c4 10             	add    $0x10,%esp
  803795:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803798:	83 ec 08             	sub    $0x8,%esp
  80379b:	ff 75 c0             	pushl  -0x40(%ebp)
  80379e:	ff 75 08             	pushl  0x8(%ebp)
  8037a1:	e8 ab fa ff ff       	call   803251 <copy_data>
  8037a6:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037ac:	e9 f8 01 00 00       	jmp    8039a9 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b4:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037ba:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037be:	0f 87 a0 00 00 00    	ja     803864 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c8:	75 17                	jne    8037e1 <realloc_block_FF+0x551>
  8037ca:	83 ec 04             	sub    $0x4,%esp
  8037cd:	68 5f 44 80 00       	push   $0x80445f
  8037d2:	68 38 02 00 00       	push   $0x238
  8037d7:	68 7d 44 80 00       	push   $0x80447d
  8037dc:	e8 04 02 00 00       	call   8039e5 <_panic>
  8037e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e4:	8b 00                	mov    (%eax),%eax
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	74 10                	je     8037fa <realloc_block_FF+0x56a>
  8037ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ed:	8b 00                	mov    (%eax),%eax
  8037ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f2:	8b 52 04             	mov    0x4(%edx),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	eb 0b                	jmp    803805 <realloc_block_FF+0x575>
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 40 04             	mov    0x4(%eax),%eax
  803800:	a3 34 50 80 00       	mov    %eax,0x805034
  803805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803808:	8b 40 04             	mov    0x4(%eax),%eax
  80380b:	85 c0                	test   %eax,%eax
  80380d:	74 0f                	je     80381e <realloc_block_FF+0x58e>
  80380f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803812:	8b 40 04             	mov    0x4(%eax),%eax
  803815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803818:	8b 12                	mov    (%edx),%edx
  80381a:	89 10                	mov    %edx,(%eax)
  80381c:	eb 0a                	jmp    803828 <realloc_block_FF+0x598>
  80381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803821:	8b 00                	mov    (%eax),%eax
  803823:	a3 30 50 80 00       	mov    %eax,0x805030
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803840:	48                   	dec    %eax
  803841:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803849:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80384c:	01 d0                	add    %edx,%eax
  80384e:	83 ec 04             	sub    $0x4,%esp
  803851:	6a 01                	push   $0x1
  803853:	50                   	push   %eax
  803854:	ff 75 08             	pushl  0x8(%ebp)
  803857:	e8 41 ea ff ff       	call   80229d <set_block_data>
  80385c:	83 c4 10             	add    $0x10,%esp
  80385f:	e9 36 01 00 00       	jmp    80399a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803864:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803867:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80386a:	01 d0                	add    %edx,%eax
  80386c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80386f:	83 ec 04             	sub    $0x4,%esp
  803872:	6a 01                	push   $0x1
  803874:	ff 75 f0             	pushl  -0x10(%ebp)
  803877:	ff 75 08             	pushl  0x8(%ebp)
  80387a:	e8 1e ea ff ff       	call   80229d <set_block_data>
  80387f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	83 e8 04             	sub    $0x4,%eax
  803888:	8b 00                	mov    (%eax),%eax
  80388a:	83 e0 fe             	and    $0xfffffffe,%eax
  80388d:	89 c2                	mov    %eax,%edx
  80388f:	8b 45 08             	mov    0x8(%ebp),%eax
  803892:	01 d0                	add    %edx,%eax
  803894:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80389b:	74 06                	je     8038a3 <realloc_block_FF+0x613>
  80389d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038a1:	75 17                	jne    8038ba <realloc_block_FF+0x62a>
  8038a3:	83 ec 04             	sub    $0x4,%esp
  8038a6:	68 f0 44 80 00       	push   $0x8044f0
  8038ab:	68 44 02 00 00       	push   $0x244
  8038b0:	68 7d 44 80 00       	push   $0x80447d
  8038b5:	e8 2b 01 00 00       	call   8039e5 <_panic>
  8038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bd:	8b 10                	mov    (%eax),%edx
  8038bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c2:	89 10                	mov    %edx,(%eax)
  8038c4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c7:	8b 00                	mov    (%eax),%eax
  8038c9:	85 c0                	test   %eax,%eax
  8038cb:	74 0b                	je     8038d8 <realloc_block_FF+0x648>
  8038cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038d5:	89 50 04             	mov    %edx,0x4(%eax)
  8038d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038db:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038de:	89 10                	mov    %edx,(%eax)
  8038e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e6:	89 50 04             	mov    %edx,0x4(%eax)
  8038e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	85 c0                	test   %eax,%eax
  8038f0:	75 08                	jne    8038fa <realloc_block_FF+0x66a>
  8038f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f5:	a3 34 50 80 00       	mov    %eax,0x805034
  8038fa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038ff:	40                   	inc    %eax
  803900:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803909:	75 17                	jne    803922 <realloc_block_FF+0x692>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 5f 44 80 00       	push   $0x80445f
  803913:	68 45 02 00 00       	push   $0x245
  803918:	68 7d 44 80 00       	push   $0x80447d
  80391d:	e8 c3 00 00 00       	call   8039e5 <_panic>
  803922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803925:	8b 00                	mov    (%eax),%eax
  803927:	85 c0                	test   %eax,%eax
  803929:	74 10                	je     80393b <realloc_block_FF+0x6ab>
  80392b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803933:	8b 52 04             	mov    0x4(%edx),%edx
  803936:	89 50 04             	mov    %edx,0x4(%eax)
  803939:	eb 0b                	jmp    803946 <realloc_block_FF+0x6b6>
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 40 04             	mov    0x4(%eax),%eax
  803941:	a3 34 50 80 00       	mov    %eax,0x805034
  803946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803949:	8b 40 04             	mov    0x4(%eax),%eax
  80394c:	85 c0                	test   %eax,%eax
  80394e:	74 0f                	je     80395f <realloc_block_FF+0x6cf>
  803950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803953:	8b 40 04             	mov    0x4(%eax),%eax
  803956:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803959:	8b 12                	mov    (%edx),%edx
  80395b:	89 10                	mov    %edx,(%eax)
  80395d:	eb 0a                	jmp    803969 <realloc_block_FF+0x6d9>
  80395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	a3 30 50 80 00       	mov    %eax,0x805030
  803969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803981:	48                   	dec    %eax
  803982:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803987:	83 ec 04             	sub    $0x4,%esp
  80398a:	6a 00                	push   $0x0
  80398c:	ff 75 bc             	pushl  -0x44(%ebp)
  80398f:	ff 75 b8             	pushl  -0x48(%ebp)
  803992:	e8 06 e9 ff ff       	call   80229d <set_block_data>
  803997:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80399a:	8b 45 08             	mov    0x8(%ebp),%eax
  80399d:	eb 0a                	jmp    8039a9 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80399f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039a9:	c9                   	leave  
  8039aa:	c3                   	ret    

008039ab <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039ab:	55                   	push   %ebp
  8039ac:	89 e5                	mov    %esp,%ebp
  8039ae:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 74 45 80 00       	push   $0x804574
  8039b9:	68 58 02 00 00       	push   $0x258
  8039be:	68 7d 44 80 00       	push   $0x80447d
  8039c3:	e8 1d 00 00 00       	call   8039e5 <_panic>

008039c8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039c8:	55                   	push   %ebp
  8039c9:	89 e5                	mov    %esp,%ebp
  8039cb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039ce:	83 ec 04             	sub    $0x4,%esp
  8039d1:	68 9c 45 80 00       	push   $0x80459c
  8039d6:	68 61 02 00 00       	push   $0x261
  8039db:	68 7d 44 80 00       	push   $0x80447d
  8039e0:	e8 00 00 00 00       	call   8039e5 <_panic>

008039e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039e5:	55                   	push   %ebp
  8039e6:	89 e5                	mov    %esp,%ebp
  8039e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039eb:	8d 45 10             	lea    0x10(%ebp),%eax
  8039ee:	83 c0 04             	add    $0x4,%eax
  8039f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039f4:	a1 60 90 18 01       	mov    0x1189060,%eax
  8039f9:	85 c0                	test   %eax,%eax
  8039fb:	74 16                	je     803a13 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039fd:	a1 60 90 18 01       	mov    0x1189060,%eax
  803a02:	83 ec 08             	sub    $0x8,%esp
  803a05:	50                   	push   %eax
  803a06:	68 c4 45 80 00       	push   $0x8045c4
  803a0b:	e8 59 cb ff ff       	call   800569 <cprintf>
  803a10:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a13:	a1 00 50 80 00       	mov    0x805000,%eax
  803a18:	ff 75 0c             	pushl  0xc(%ebp)
  803a1b:	ff 75 08             	pushl  0x8(%ebp)
  803a1e:	50                   	push   %eax
  803a1f:	68 c9 45 80 00       	push   $0x8045c9
  803a24:	e8 40 cb ff ff       	call   800569 <cprintf>
  803a29:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  803a2f:	83 ec 08             	sub    $0x8,%esp
  803a32:	ff 75 f4             	pushl  -0xc(%ebp)
  803a35:	50                   	push   %eax
  803a36:	e8 c3 ca ff ff       	call   8004fe <vcprintf>
  803a3b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a3e:	83 ec 08             	sub    $0x8,%esp
  803a41:	6a 00                	push   $0x0
  803a43:	68 e5 45 80 00       	push   $0x8045e5
  803a48:	e8 b1 ca ff ff       	call   8004fe <vcprintf>
  803a4d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a50:	e8 32 ca ff ff       	call   800487 <exit>

	// should not return here
	while (1) ;
  803a55:	eb fe                	jmp    803a55 <_panic+0x70>

00803a57 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a57:	55                   	push   %ebp
  803a58:	89 e5                	mov    %esp,%ebp
  803a5a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a5d:	a1 20 50 80 00       	mov    0x805020,%eax
  803a62:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6b:	39 c2                	cmp    %eax,%edx
  803a6d:	74 14                	je     803a83 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a6f:	83 ec 04             	sub    $0x4,%esp
  803a72:	68 e8 45 80 00       	push   $0x8045e8
  803a77:	6a 26                	push   $0x26
  803a79:	68 34 46 80 00       	push   $0x804634
  803a7e:	e8 62 ff ff ff       	call   8039e5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a91:	e9 c5 00 00 00       	jmp    803b5b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa3:	01 d0                	add    %edx,%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	75 08                	jne    803ab3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803aab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803aae:	e9 a5 00 00 00       	jmp    803b58 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ab3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803aba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ac1:	eb 69                	jmp    803b2c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803ac3:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ace:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad1:	89 d0                	mov    %edx,%eax
  803ad3:	01 c0                	add    %eax,%eax
  803ad5:	01 d0                	add    %edx,%eax
  803ad7:	c1 e0 03             	shl    $0x3,%eax
  803ada:	01 c8                	add    %ecx,%eax
  803adc:	8a 40 04             	mov    0x4(%eax),%al
  803adf:	84 c0                	test   %al,%al
  803ae1:	75 46                	jne    803b29 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ae3:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af1:	89 d0                	mov    %edx,%eax
  803af3:	01 c0                	add    %eax,%eax
  803af5:	01 d0                	add    %edx,%eax
  803af7:	c1 e0 03             	shl    $0x3,%eax
  803afa:	01 c8                	add    %ecx,%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b09:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b0e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b15:	8b 45 08             	mov    0x8(%ebp),%eax
  803b18:	01 c8                	add    %ecx,%eax
  803b1a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b1c:	39 c2                	cmp    %eax,%edx
  803b1e:	75 09                	jne    803b29 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b20:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b27:	eb 15                	jmp    803b3e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b29:	ff 45 e8             	incl   -0x18(%ebp)
  803b2c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b31:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3a:	39 c2                	cmp    %eax,%edx
  803b3c:	77 85                	ja     803ac3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b42:	75 14                	jne    803b58 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b44:	83 ec 04             	sub    $0x4,%esp
  803b47:	68 40 46 80 00       	push   $0x804640
  803b4c:	6a 3a                	push   $0x3a
  803b4e:	68 34 46 80 00       	push   $0x804634
  803b53:	e8 8d fe ff ff       	call   8039e5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b58:	ff 45 f0             	incl   -0x10(%ebp)
  803b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b61:	0f 8c 2f ff ff ff    	jl     803a96 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b6e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b75:	eb 26                	jmp    803b9d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b77:	a1 20 50 80 00       	mov    0x805020,%eax
  803b7c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b85:	89 d0                	mov    %edx,%eax
  803b87:	01 c0                	add    %eax,%eax
  803b89:	01 d0                	add    %edx,%eax
  803b8b:	c1 e0 03             	shl    $0x3,%eax
  803b8e:	01 c8                	add    %ecx,%eax
  803b90:	8a 40 04             	mov    0x4(%eax),%al
  803b93:	3c 01                	cmp    $0x1,%al
  803b95:	75 03                	jne    803b9a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b97:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b9a:	ff 45 e0             	incl   -0x20(%ebp)
  803b9d:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bab:	39 c2                	cmp    %eax,%edx
  803bad:	77 c8                	ja     803b77 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bb5:	74 14                	je     803bcb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bb7:	83 ec 04             	sub    $0x4,%esp
  803bba:	68 94 46 80 00       	push   $0x804694
  803bbf:	6a 44                	push   $0x44
  803bc1:	68 34 46 80 00       	push   $0x804634
  803bc6:	e8 1a fe ff ff       	call   8039e5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803bcb:	90                   	nop
  803bcc:	c9                   	leave  
  803bcd:	c3                   	ret    
  803bce:	66 90                	xchg   %ax,%ax

00803bd0 <__udivdi3>:
  803bd0:	55                   	push   %ebp
  803bd1:	57                   	push   %edi
  803bd2:	56                   	push   %esi
  803bd3:	53                   	push   %ebx
  803bd4:	83 ec 1c             	sub    $0x1c,%esp
  803bd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803be3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803be7:	89 ca                	mov    %ecx,%edx
  803be9:	89 f8                	mov    %edi,%eax
  803beb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bef:	85 f6                	test   %esi,%esi
  803bf1:	75 2d                	jne    803c20 <__udivdi3+0x50>
  803bf3:	39 cf                	cmp    %ecx,%edi
  803bf5:	77 65                	ja     803c5c <__udivdi3+0x8c>
  803bf7:	89 fd                	mov    %edi,%ebp
  803bf9:	85 ff                	test   %edi,%edi
  803bfb:	75 0b                	jne    803c08 <__udivdi3+0x38>
  803bfd:	b8 01 00 00 00       	mov    $0x1,%eax
  803c02:	31 d2                	xor    %edx,%edx
  803c04:	f7 f7                	div    %edi
  803c06:	89 c5                	mov    %eax,%ebp
  803c08:	31 d2                	xor    %edx,%edx
  803c0a:	89 c8                	mov    %ecx,%eax
  803c0c:	f7 f5                	div    %ebp
  803c0e:	89 c1                	mov    %eax,%ecx
  803c10:	89 d8                	mov    %ebx,%eax
  803c12:	f7 f5                	div    %ebp
  803c14:	89 cf                	mov    %ecx,%edi
  803c16:	89 fa                	mov    %edi,%edx
  803c18:	83 c4 1c             	add    $0x1c,%esp
  803c1b:	5b                   	pop    %ebx
  803c1c:	5e                   	pop    %esi
  803c1d:	5f                   	pop    %edi
  803c1e:	5d                   	pop    %ebp
  803c1f:	c3                   	ret    
  803c20:	39 ce                	cmp    %ecx,%esi
  803c22:	77 28                	ja     803c4c <__udivdi3+0x7c>
  803c24:	0f bd fe             	bsr    %esi,%edi
  803c27:	83 f7 1f             	xor    $0x1f,%edi
  803c2a:	75 40                	jne    803c6c <__udivdi3+0x9c>
  803c2c:	39 ce                	cmp    %ecx,%esi
  803c2e:	72 0a                	jb     803c3a <__udivdi3+0x6a>
  803c30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c34:	0f 87 9e 00 00 00    	ja     803cd8 <__udivdi3+0x108>
  803c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3f:	89 fa                	mov    %edi,%edx
  803c41:	83 c4 1c             	add    $0x1c,%esp
  803c44:	5b                   	pop    %ebx
  803c45:	5e                   	pop    %esi
  803c46:	5f                   	pop    %edi
  803c47:	5d                   	pop    %ebp
  803c48:	c3                   	ret    
  803c49:	8d 76 00             	lea    0x0(%esi),%esi
  803c4c:	31 ff                	xor    %edi,%edi
  803c4e:	31 c0                	xor    %eax,%eax
  803c50:	89 fa                	mov    %edi,%edx
  803c52:	83 c4 1c             	add    $0x1c,%esp
  803c55:	5b                   	pop    %ebx
  803c56:	5e                   	pop    %esi
  803c57:	5f                   	pop    %edi
  803c58:	5d                   	pop    %ebp
  803c59:	c3                   	ret    
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	89 d8                	mov    %ebx,%eax
  803c5e:	f7 f7                	div    %edi
  803c60:	31 ff                	xor    %edi,%edi
  803c62:	89 fa                	mov    %edi,%edx
  803c64:	83 c4 1c             	add    $0x1c,%esp
  803c67:	5b                   	pop    %ebx
  803c68:	5e                   	pop    %esi
  803c69:	5f                   	pop    %edi
  803c6a:	5d                   	pop    %ebp
  803c6b:	c3                   	ret    
  803c6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c71:	89 eb                	mov    %ebp,%ebx
  803c73:	29 fb                	sub    %edi,%ebx
  803c75:	89 f9                	mov    %edi,%ecx
  803c77:	d3 e6                	shl    %cl,%esi
  803c79:	89 c5                	mov    %eax,%ebp
  803c7b:	88 d9                	mov    %bl,%cl
  803c7d:	d3 ed                	shr    %cl,%ebp
  803c7f:	89 e9                	mov    %ebp,%ecx
  803c81:	09 f1                	or     %esi,%ecx
  803c83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c87:	89 f9                	mov    %edi,%ecx
  803c89:	d3 e0                	shl    %cl,%eax
  803c8b:	89 c5                	mov    %eax,%ebp
  803c8d:	89 d6                	mov    %edx,%esi
  803c8f:	88 d9                	mov    %bl,%cl
  803c91:	d3 ee                	shr    %cl,%esi
  803c93:	89 f9                	mov    %edi,%ecx
  803c95:	d3 e2                	shl    %cl,%edx
  803c97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 e8                	shr    %cl,%eax
  803c9f:	09 c2                	or     %eax,%edx
  803ca1:	89 d0                	mov    %edx,%eax
  803ca3:	89 f2                	mov    %esi,%edx
  803ca5:	f7 74 24 0c          	divl   0xc(%esp)
  803ca9:	89 d6                	mov    %edx,%esi
  803cab:	89 c3                	mov    %eax,%ebx
  803cad:	f7 e5                	mul    %ebp
  803caf:	39 d6                	cmp    %edx,%esi
  803cb1:	72 19                	jb     803ccc <__udivdi3+0xfc>
  803cb3:	74 0b                	je     803cc0 <__udivdi3+0xf0>
  803cb5:	89 d8                	mov    %ebx,%eax
  803cb7:	31 ff                	xor    %edi,%edi
  803cb9:	e9 58 ff ff ff       	jmp    803c16 <__udivdi3+0x46>
  803cbe:	66 90                	xchg   %ax,%ax
  803cc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cc4:	89 f9                	mov    %edi,%ecx
  803cc6:	d3 e2                	shl    %cl,%edx
  803cc8:	39 c2                	cmp    %eax,%edx
  803cca:	73 e9                	jae    803cb5 <__udivdi3+0xe5>
  803ccc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ccf:	31 ff                	xor    %edi,%edi
  803cd1:	e9 40 ff ff ff       	jmp    803c16 <__udivdi3+0x46>
  803cd6:	66 90                	xchg   %ax,%ax
  803cd8:	31 c0                	xor    %eax,%eax
  803cda:	e9 37 ff ff ff       	jmp    803c16 <__udivdi3+0x46>
  803cdf:	90                   	nop

00803ce0 <__umoddi3>:
  803ce0:	55                   	push   %ebp
  803ce1:	57                   	push   %edi
  803ce2:	56                   	push   %esi
  803ce3:	53                   	push   %ebx
  803ce4:	83 ec 1c             	sub    $0x1c,%esp
  803ce7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ceb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cff:	89 f3                	mov    %esi,%ebx
  803d01:	89 fa                	mov    %edi,%edx
  803d03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d07:	89 34 24             	mov    %esi,(%esp)
  803d0a:	85 c0                	test   %eax,%eax
  803d0c:	75 1a                	jne    803d28 <__umoddi3+0x48>
  803d0e:	39 f7                	cmp    %esi,%edi
  803d10:	0f 86 a2 00 00 00    	jbe    803db8 <__umoddi3+0xd8>
  803d16:	89 c8                	mov    %ecx,%eax
  803d18:	89 f2                	mov    %esi,%edx
  803d1a:	f7 f7                	div    %edi
  803d1c:	89 d0                	mov    %edx,%eax
  803d1e:	31 d2                	xor    %edx,%edx
  803d20:	83 c4 1c             	add    $0x1c,%esp
  803d23:	5b                   	pop    %ebx
  803d24:	5e                   	pop    %esi
  803d25:	5f                   	pop    %edi
  803d26:	5d                   	pop    %ebp
  803d27:	c3                   	ret    
  803d28:	39 f0                	cmp    %esi,%eax
  803d2a:	0f 87 ac 00 00 00    	ja     803ddc <__umoddi3+0xfc>
  803d30:	0f bd e8             	bsr    %eax,%ebp
  803d33:	83 f5 1f             	xor    $0x1f,%ebp
  803d36:	0f 84 ac 00 00 00    	je     803de8 <__umoddi3+0x108>
  803d3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d41:	29 ef                	sub    %ebp,%edi
  803d43:	89 fe                	mov    %edi,%esi
  803d45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d49:	89 e9                	mov    %ebp,%ecx
  803d4b:	d3 e0                	shl    %cl,%eax
  803d4d:	89 d7                	mov    %edx,%edi
  803d4f:	89 f1                	mov    %esi,%ecx
  803d51:	d3 ef                	shr    %cl,%edi
  803d53:	09 c7                	or     %eax,%edi
  803d55:	89 e9                	mov    %ebp,%ecx
  803d57:	d3 e2                	shl    %cl,%edx
  803d59:	89 14 24             	mov    %edx,(%esp)
  803d5c:	89 d8                	mov    %ebx,%eax
  803d5e:	d3 e0                	shl    %cl,%eax
  803d60:	89 c2                	mov    %eax,%edx
  803d62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d66:	d3 e0                	shl    %cl,%eax
  803d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d70:	89 f1                	mov    %esi,%ecx
  803d72:	d3 e8                	shr    %cl,%eax
  803d74:	09 d0                	or     %edx,%eax
  803d76:	d3 eb                	shr    %cl,%ebx
  803d78:	89 da                	mov    %ebx,%edx
  803d7a:	f7 f7                	div    %edi
  803d7c:	89 d3                	mov    %edx,%ebx
  803d7e:	f7 24 24             	mull   (%esp)
  803d81:	89 c6                	mov    %eax,%esi
  803d83:	89 d1                	mov    %edx,%ecx
  803d85:	39 d3                	cmp    %edx,%ebx
  803d87:	0f 82 87 00 00 00    	jb     803e14 <__umoddi3+0x134>
  803d8d:	0f 84 91 00 00 00    	je     803e24 <__umoddi3+0x144>
  803d93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d97:	29 f2                	sub    %esi,%edx
  803d99:	19 cb                	sbb    %ecx,%ebx
  803d9b:	89 d8                	mov    %ebx,%eax
  803d9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803da1:	d3 e0                	shl    %cl,%eax
  803da3:	89 e9                	mov    %ebp,%ecx
  803da5:	d3 ea                	shr    %cl,%edx
  803da7:	09 d0                	or     %edx,%eax
  803da9:	89 e9                	mov    %ebp,%ecx
  803dab:	d3 eb                	shr    %cl,%ebx
  803dad:	89 da                	mov    %ebx,%edx
  803daf:	83 c4 1c             	add    $0x1c,%esp
  803db2:	5b                   	pop    %ebx
  803db3:	5e                   	pop    %esi
  803db4:	5f                   	pop    %edi
  803db5:	5d                   	pop    %ebp
  803db6:	c3                   	ret    
  803db7:	90                   	nop
  803db8:	89 fd                	mov    %edi,%ebp
  803dba:	85 ff                	test   %edi,%edi
  803dbc:	75 0b                	jne    803dc9 <__umoddi3+0xe9>
  803dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803dc3:	31 d2                	xor    %edx,%edx
  803dc5:	f7 f7                	div    %edi
  803dc7:	89 c5                	mov    %eax,%ebp
  803dc9:	89 f0                	mov    %esi,%eax
  803dcb:	31 d2                	xor    %edx,%edx
  803dcd:	f7 f5                	div    %ebp
  803dcf:	89 c8                	mov    %ecx,%eax
  803dd1:	f7 f5                	div    %ebp
  803dd3:	89 d0                	mov    %edx,%eax
  803dd5:	e9 44 ff ff ff       	jmp    803d1e <__umoddi3+0x3e>
  803dda:	66 90                	xchg   %ax,%ax
  803ddc:	89 c8                	mov    %ecx,%eax
  803dde:	89 f2                	mov    %esi,%edx
  803de0:	83 c4 1c             	add    $0x1c,%esp
  803de3:	5b                   	pop    %ebx
  803de4:	5e                   	pop    %esi
  803de5:	5f                   	pop    %edi
  803de6:	5d                   	pop    %ebp
  803de7:	c3                   	ret    
  803de8:	3b 04 24             	cmp    (%esp),%eax
  803deb:	72 06                	jb     803df3 <__umoddi3+0x113>
  803ded:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803df1:	77 0f                	ja     803e02 <__umoddi3+0x122>
  803df3:	89 f2                	mov    %esi,%edx
  803df5:	29 f9                	sub    %edi,%ecx
  803df7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dfb:	89 14 24             	mov    %edx,(%esp)
  803dfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e06:	8b 14 24             	mov    (%esp),%edx
  803e09:	83 c4 1c             	add    $0x1c,%esp
  803e0c:	5b                   	pop    %ebx
  803e0d:	5e                   	pop    %esi
  803e0e:	5f                   	pop    %edi
  803e0f:	5d                   	pop    %ebp
  803e10:	c3                   	ret    
  803e11:	8d 76 00             	lea    0x0(%esi),%esi
  803e14:	2b 04 24             	sub    (%esp),%eax
  803e17:	19 fa                	sbb    %edi,%edx
  803e19:	89 d1                	mov    %edx,%ecx
  803e1b:	89 c6                	mov    %eax,%esi
  803e1d:	e9 71 ff ff ff       	jmp    803d93 <__umoddi3+0xb3>
  803e22:	66 90                	xchg   %ax,%ax
  803e24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e28:	72 ea                	jb     803e14 <__umoddi3+0x134>
  803e2a:	89 d9                	mov    %ebx,%ecx
  803e2c:	e9 62 ff ff ff       	jmp    803d93 <__umoddi3+0xb3>
