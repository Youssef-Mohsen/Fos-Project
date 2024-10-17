
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
  80003e:	e8 c8 16 00 00       	call   80170b <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 f2 16 00 00       	call   80173d <sys_getparentenvid>
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
  80005f:	68 c0 1e 80 00       	push   $0x801ec0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 2d 13 00 00       	call   801399 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c4 1e 80 00       	push   $0x801ec4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 17 13 00 00       	call   801399 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 cc 1e 80 00       	push   $0x801ecc
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 fa 12 00 00       	call   801399 <sget>
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
  8000b3:	68 da 1e 80 00       	push   $0x801eda
  8000b8:	e8 ad 12 00 00       	call   80136a <smalloc>
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
  800112:	68 e9 1e 80 00       	push   $0x801ee9
  800117:	e8 5b 04 00 00       	call   800577 <cprintf>
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
  800166:	e8 05 16 00 00       	call   801770 <sys_get_virtual_time>
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
  8002f6:	68 05 1f 80 00       	push   $0x801f05
  8002fb:	e8 77 02 00 00       	call   800577 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 07 1f 80 00       	push   $0x801f07
  80031d:	e8 55 02 00 00       	call   800577 <cprintf>
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
  800346:	68 0c 1f 80 00       	push   $0x801f0c
  80034b:	e8 27 02 00 00       	call   800577 <cprintf>
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
  80035c:	e8 c3 13 00 00       	call   801724 <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 06             	shl    $0x6,%eax
  80036c:	29 d0                	sub    %edx,%eax
  80036e:	c1 e0 02             	shl    $0x2,%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80037a:	01 c8                	add    %ecx,%eax
  80037c:	c1 e0 03             	shl    $0x3,%eax
  80037f:	01 d0                	add    %edx,%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	29 c2                	sub    %eax,%edx
  80038a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800391:	89 c2                	mov    %eax,%edx
  800393:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800399:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039e:	a1 04 30 80 00       	mov    0x803004,%eax
  8003a3:	8a 40 20             	mov    0x20(%eax),%al
  8003a6:	84 c0                	test   %al,%al
  8003a8:	74 0d                	je     8003b7 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8003aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8003af:	83 c0 20             	add    $0x20,%eax
  8003b2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bb:	7e 0a                	jle    8003c7 <libmain+0x71>
		binaryname = argv[0];
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	ff 75 08             	pushl  0x8(%ebp)
  8003d0:	e8 63 fc ff ff       	call   800038 <_main>
  8003d5:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8003d8:	e8 cb 10 00 00       	call   8014a8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003dd:	83 ec 0c             	sub    $0xc,%esp
  8003e0:	68 28 1f 80 00       	push   $0x801f28
  8003e5:	e8 8d 01 00 00       	call   800577 <cprintf>
  8003ea:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8003f2:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8003fd:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800403:	83 ec 04             	sub    $0x4,%esp
  800406:	52                   	push   %edx
  800407:	50                   	push   %eax
  800408:	68 50 1f 80 00       	push   $0x801f50
  80040d:	e8 65 01 00 00       	call   800577 <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800415:	a1 04 30 80 00       	mov    0x803004,%eax
  80041a:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800420:	a1 04 30 80 00       	mov    0x803004,%eax
  800425:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80042b:	a1 04 30 80 00       	mov    0x803004,%eax
  800430:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800436:	51                   	push   %ecx
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	68 78 1f 80 00       	push   $0x801f78
  80043e:	e8 34 01 00 00       	call   800577 <cprintf>
  800443:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800446:	a1 04 30 80 00       	mov    0x803004,%eax
  80044b:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	50                   	push   %eax
  800455:	68 d0 1f 80 00       	push   $0x801fd0
  80045a:	e8 18 01 00 00       	call   800577 <cprintf>
  80045f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	68 28 1f 80 00       	push   $0x801f28
  80046a:	e8 08 01 00 00       	call   800577 <cprintf>
  80046f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800472:	e8 4b 10 00 00       	call   8014c2 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800477:	e8 19 00 00 00       	call   800495 <exit>
}
  80047c:	90                   	nop
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800485:	83 ec 0c             	sub    $0xc,%esp
  800488:	6a 00                	push   $0x0
  80048a:	e8 61 12 00 00       	call   8016f0 <sys_destroy_env>
  80048f:	83 c4 10             	add    $0x10,%esp
}
  800492:	90                   	nop
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <exit>:

void
exit(void)
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049b:	e8 b6 12 00 00       	call   801756 <sys_exit_env>
}
  8004a0:	90                   	nop
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8004b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b4:	89 0a                	mov    %ecx,(%edx)
  8004b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b9:	88 d1                	mov    %dl,%cl
  8004bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004be:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004cc:	75 2c                	jne    8004fa <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ce:	a0 08 30 80 00       	mov    0x803008,%al
  8004d3:	0f b6 c0             	movzbl %al,%eax
  8004d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d9:	8b 12                	mov    (%edx),%edx
  8004db:	89 d1                	mov    %edx,%ecx
  8004dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e0:	83 c2 08             	add    $0x8,%edx
  8004e3:	83 ec 04             	sub    $0x4,%esp
  8004e6:	50                   	push   %eax
  8004e7:	51                   	push   %ecx
  8004e8:	52                   	push   %edx
  8004e9:	e8 78 0f 00 00       	call   801466 <sys_cputs>
  8004ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	8b 40 04             	mov    0x4(%eax),%eax
  800500:	8d 50 01             	lea    0x1(%eax),%edx
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	89 50 04             	mov    %edx,0x4(%eax)
}
  800509:	90                   	nop
  80050a:	c9                   	leave  
  80050b:	c3                   	ret    

0080050c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800515:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80051c:	00 00 00 
	b.cnt = 0;
  80051f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800526:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800535:	50                   	push   %eax
  800536:	68 a3 04 80 00       	push   $0x8004a3
  80053b:	e8 11 02 00 00       	call   800751 <vprintfmt>
  800540:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800543:	a0 08 30 80 00       	mov    0x803008,%al
  800548:	0f b6 c0             	movzbl %al,%eax
  80054b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800551:	83 ec 04             	sub    $0x4,%esp
  800554:	50                   	push   %eax
  800555:	52                   	push   %edx
  800556:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055c:	83 c0 08             	add    $0x8,%eax
  80055f:	50                   	push   %eax
  800560:	e8 01 0f 00 00       	call   801466 <sys_cputs>
  800565:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800568:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80056f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80057d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800584:	8d 45 0c             	lea    0xc(%ebp),%eax
  800587:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 f4             	pushl  -0xc(%ebp)
  800593:	50                   	push   %eax
  800594:	e8 73 ff ff ff       	call   80050c <vcprintf>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80059f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005aa:	e8 f9 0e 00 00       	call   8014a8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	e8 48 ff ff ff       	call   80050c <vcprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005ca:	e8 f3 0e 00 00       	call   8014c2 <sys_unlock_cons>
	return cnt;
  8005cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	53                   	push   %ebx
  8005d8:	83 ec 14             	sub    $0x14,%esp
  8005db:	8b 45 10             	mov    0x10(%ebp),%eax
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f2:	77 55                	ja     800649 <printnum+0x75>
  8005f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f7:	72 05                	jb     8005fe <printnum+0x2a>
  8005f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005fc:	77 4b                	ja     800649 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005fe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800601:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800604:	8b 45 18             	mov    0x18(%ebp),%eax
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	52                   	push   %edx
  80060d:	50                   	push   %eax
  80060e:	ff 75 f4             	pushl  -0xc(%ebp)
  800611:	ff 75 f0             	pushl  -0x10(%ebp)
  800614:	e8 3b 16 00 00       	call   801c54 <__udivdi3>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	ff 75 20             	pushl  0x20(%ebp)
  800622:	53                   	push   %ebx
  800623:	ff 75 18             	pushl  0x18(%ebp)
  800626:	52                   	push   %edx
  800627:	50                   	push   %eax
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	ff 75 08             	pushl  0x8(%ebp)
  80062e:	e8 a1 ff ff ff       	call   8005d4 <printnum>
  800633:	83 c4 20             	add    $0x20,%esp
  800636:	eb 1a                	jmp    800652 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	ff 75 20             	pushl  0x20(%ebp)
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	ff d0                	call   *%eax
  800646:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800649:	ff 4d 1c             	decl   0x1c(%ebp)
  80064c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800650:	7f e6                	jg     800638 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800652:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800655:	bb 00 00 00 00       	mov    $0x0,%ebx
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800660:	53                   	push   %ebx
  800661:	51                   	push   %ecx
  800662:	52                   	push   %edx
  800663:	50                   	push   %eax
  800664:	e8 fb 16 00 00       	call   801d64 <__umoddi3>
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	05 14 22 80 00       	add    $0x802214,%eax
  800671:	8a 00                	mov    (%eax),%al
  800673:	0f be c0             	movsbl %al,%eax
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	50                   	push   %eax
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	ff d0                	call   *%eax
  800682:	83 c4 10             	add    $0x10,%esp
}
  800685:	90                   	nop
  800686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800692:	7e 1c                	jle    8006b0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 08             	lea    0x8(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 08             	sub    $0x8,%eax
  8006a9:	8b 50 04             	mov    0x4(%eax),%edx
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	eb 40                	jmp    8006f0 <getuint+0x65>
	else if (lflag)
  8006b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b4:	74 1e                	je     8006d4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	89 10                	mov    %edx,(%eax)
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	83 e8 04             	sub    $0x4,%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d2:	eb 1c                	jmp    8006f0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8d 50 04             	lea    0x4(%eax),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	89 10                	mov    %edx,(%eax)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	83 e8 04             	sub    $0x4,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006f0:	5d                   	pop    %ebp
  8006f1:	c3                   	ret    

008006f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f9:	7e 1c                	jle    800717 <getint+0x25>
		return va_arg(*ap, long long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 08             	lea    0x8(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 08             	sub    $0x8,%eax
  800710:	8b 50 04             	mov    0x4(%eax),%edx
  800713:	8b 00                	mov    (%eax),%eax
  800715:	eb 38                	jmp    80074f <getint+0x5d>
	else if (lflag)
  800717:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80071b:	74 1a                	je     800737 <getint+0x45>
		return va_arg(*ap, long);
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	8d 50 04             	lea    0x4(%eax),%edx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	89 10                	mov    %edx,(%eax)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	83 e8 04             	sub    $0x4,%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	99                   	cltd   
  800735:	eb 18                	jmp    80074f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	99                   	cltd   
}
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	56                   	push   %esi
  800755:	53                   	push   %ebx
  800756:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	eb 17                	jmp    800772 <vprintfmt+0x21>
			if (ch == '\0')
  80075b:	85 db                	test   %ebx,%ebx
  80075d:	0f 84 c1 03 00 00    	je     800b24 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	53                   	push   %ebx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	83 fb 25             	cmp    $0x25,%ebx
  800783:	75 d6                	jne    80075b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800785:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800789:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800790:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800797:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80079e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a8:	8d 50 01             	lea    0x1(%eax),%edx
  8007ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f b6 d8             	movzbl %al,%ebx
  8007b3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b6:	83 f8 5b             	cmp    $0x5b,%eax
  8007b9:	0f 87 3d 03 00 00    	ja     800afc <vprintfmt+0x3ab>
  8007bf:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  8007c6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d7                	jmp    8007a5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ce:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007d2:	eb d1                	jmp    8007a5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007de:	89 d0                	mov    %edx,%eax
  8007e0:	c1 e0 02             	shl    $0x2,%eax
  8007e3:	01 d0                	add    %edx,%eax
  8007e5:	01 c0                	add    %eax,%eax
  8007e7:	01 d8                	add    %ebx,%eax
  8007e9:	83 e8 30             	sub    $0x30,%eax
  8007ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f2:	8a 00                	mov    (%eax),%al
  8007f4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007fa:	7e 3e                	jle    80083a <vprintfmt+0xe9>
  8007fc:	83 fb 39             	cmp    $0x39,%ebx
  8007ff:	7f 39                	jg     80083a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800801:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800804:	eb d5                	jmp    8007db <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	83 c0 04             	add    $0x4,%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	83 e8 04             	sub    $0x4,%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80081a:	eb 1f                	jmp    80083b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80081c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800820:	79 83                	jns    8007a5 <vprintfmt+0x54>
				width = 0;
  800822:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800829:	e9 77 ff ff ff       	jmp    8007a5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80082e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800835:	e9 6b ff ff ff       	jmp    8007a5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80083a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80083b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083f:	0f 89 60 ff ff ff    	jns    8007a5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800852:	e9 4e ff ff ff       	jmp    8007a5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800857:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80085a:	e9 46 ff ff ff       	jmp    8007a5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	83 c0 04             	add    $0x4,%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	83 e8 04             	sub    $0x4,%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			break;
  80087f:	e9 9b 02 00 00       	jmp    800b1f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800895:	85 db                	test   %ebx,%ebx
  800897:	79 02                	jns    80089b <vprintfmt+0x14a>
				err = -err;
  800899:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80089b:	83 fb 64             	cmp    $0x64,%ebx
  80089e:	7f 0b                	jg     8008ab <vprintfmt+0x15a>
  8008a0:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  8008a7:	85 f6                	test   %esi,%esi
  8008a9:	75 19                	jne    8008c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008ab:	53                   	push   %ebx
  8008ac:	68 25 22 80 00       	push   $0x802225
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 70 02 00 00       	call   800b2c <printfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008bf:	e9 5b 02 00 00       	jmp    800b1f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008c4:	56                   	push   %esi
  8008c5:	68 2e 22 80 00       	push   $0x80222e
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	ff 75 08             	pushl  0x8(%ebp)
  8008d0:	e8 57 02 00 00       	call   800b2c <printfmt>
  8008d5:	83 c4 10             	add    $0x10,%esp
			break;
  8008d8:	e9 42 02 00 00       	jmp    800b1f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	83 e8 04             	sub    $0x4,%eax
  8008ec:	8b 30                	mov    (%eax),%esi
  8008ee:	85 f6                	test   %esi,%esi
  8008f0:	75 05                	jne    8008f7 <vprintfmt+0x1a6>
				p = "(null)";
  8008f2:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  8008f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fb:	7e 6d                	jle    80096a <vprintfmt+0x219>
  8008fd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800901:	74 67                	je     80096a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	50                   	push   %eax
  80090a:	56                   	push   %esi
  80090b:	e8 1e 03 00 00       	call   800c2e <strnlen>
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800916:	eb 16                	jmp    80092e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800918:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	50                   	push   %eax
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	ff d0                	call   *%eax
  800928:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80092b:	ff 4d e4             	decl   -0x1c(%ebp)
  80092e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800932:	7f e4                	jg     800918 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	eb 34                	jmp    80096a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800936:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80093a:	74 1c                	je     800958 <vprintfmt+0x207>
  80093c:	83 fb 1f             	cmp    $0x1f,%ebx
  80093f:	7e 05                	jle    800946 <vprintfmt+0x1f5>
  800941:	83 fb 7e             	cmp    $0x7e,%ebx
  800944:	7e 12                	jle    800958 <vprintfmt+0x207>
					putch('?', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	6a 3f                	push   $0x3f
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	eb 0f                	jmp    800967 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800967:	ff 4d e4             	decl   -0x1c(%ebp)
  80096a:	89 f0                	mov    %esi,%eax
  80096c:	8d 70 01             	lea    0x1(%eax),%esi
  80096f:	8a 00                	mov    (%eax),%al
  800971:	0f be d8             	movsbl %al,%ebx
  800974:	85 db                	test   %ebx,%ebx
  800976:	74 24                	je     80099c <vprintfmt+0x24b>
  800978:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097c:	78 b8                	js     800936 <vprintfmt+0x1e5>
  80097e:	ff 4d e0             	decl   -0x20(%ebp)
  800981:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800985:	79 af                	jns    800936 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800987:	eb 13                	jmp    80099c <vprintfmt+0x24b>
				putch(' ', putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	6a 20                	push   $0x20
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	ff d0                	call   *%eax
  800996:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800999:	ff 4d e4             	decl   -0x1c(%ebp)
  80099c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a0:	7f e7                	jg     800989 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009a2:	e9 78 01 00 00       	jmp    800b1f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b0:	50                   	push   %eax
  8009b1:	e8 3c fd ff ff       	call   8006f2 <getint>
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c5:	85 d2                	test   %edx,%edx
  8009c7:	79 23                	jns    8009ec <vprintfmt+0x29b>
				putch('-', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	6a 2d                	push   $0x2d
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009df:	f7 d8                	neg    %eax
  8009e1:	83 d2 00             	adc    $0x0,%edx
  8009e4:	f7 da                	neg    %edx
  8009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f3:	e9 bc 00 00 00       	jmp    800ab4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8009fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800a01:	50                   	push   %eax
  800a02:	e8 84 fc ff ff       	call   80068b <getuint>
  800a07:	83 c4 10             	add    $0x10,%esp
  800a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a17:	e9 98 00 00 00       	jmp    800ab4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 58                	push   $0x58
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 58                	push   $0x58
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	6a 58                	push   $0x58
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	ff d0                	call   *%eax
  800a49:	83 c4 10             	add    $0x10,%esp
			break;
  800a4c:	e9 ce 00 00 00       	jmp    800b1f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 30                	push   $0x30
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	6a 78                	push   $0x78
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 e8 04             	sub    $0x4,%eax
  800a80:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a93:	eb 1f                	jmp    800ab4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9e:	50                   	push   %eax
  800a9f:	e8 e7 fb ff ff       	call   80068b <getuint>
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	52                   	push   %edx
  800abf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 00 fb ff ff       	call   8005d4 <printnum>
  800ad4:	83 c4 20             	add    $0x20,%esp
			break;
  800ad7:	eb 46                	jmp    800b1f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
			break;
  800ae8:	eb 35                	jmp    800b1f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aea:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800af1:	eb 2c                	jmp    800b1f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800af3:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800afa:	eb 23                	jmp    800b1f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 25                	push   $0x25
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b0c:	ff 4d 10             	decl   0x10(%ebp)
  800b0f:	eb 03                	jmp    800b14 <vprintfmt+0x3c3>
  800b11:	ff 4d 10             	decl   0x10(%ebp)
  800b14:	8b 45 10             	mov    0x10(%ebp),%eax
  800b17:	48                   	dec    %eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	3c 25                	cmp    $0x25,%al
  800b1c:	75 f3                	jne    800b11 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b1e:	90                   	nop
		}
	}
  800b1f:	e9 35 fc ff ff       	jmp    800759 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b24:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b32:	8d 45 10             	lea    0x10(%ebp),%eax
  800b35:	83 c0 04             	add    $0x4,%eax
  800b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b41:	50                   	push   %eax
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	ff 75 08             	pushl  0x8(%ebp)
  800b48:	e8 04 fc ff ff       	call   800751 <vprintfmt>
  800b4d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b50:	90                   	nop
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 40 08             	mov    0x8(%eax),%eax
  800b5c:	8d 50 01             	lea    0x1(%eax),%edx
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 10                	mov    (%eax),%edx
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 04             	mov    0x4(%eax),%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	73 12                	jae    800b86 <sprintputch+0x33>
		*b->buf++ = ch;
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	8d 48 01             	lea    0x1(%eax),%ecx
  800b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7f:	89 0a                	mov    %ecx,(%edx)
  800b81:	8b 55 08             	mov    0x8(%ebp),%edx
  800b84:	88 10                	mov    %dl,(%eax)
}
  800b86:	90                   	nop
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
  800ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800baa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bae:	74 06                	je     800bb6 <vsnprintf+0x2d>
  800bb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb4:	7f 07                	jg     800bbd <vsnprintf+0x34>
		return -E_INVAL;
  800bb6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bbb:	eb 20                	jmp    800bdd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bbd:	ff 75 14             	pushl  0x14(%ebp)
  800bc0:	ff 75 10             	pushl  0x10(%ebp)
  800bc3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc6:	50                   	push   %eax
  800bc7:	68 53 0b 80 00       	push   $0x800b53
  800bcc:	e8 80 fb ff ff       	call   800751 <vprintfmt>
  800bd1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be5:	8d 45 10             	lea    0x10(%ebp),%eax
  800be8:	83 c0 04             	add    $0x4,%eax
  800beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bee:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf4:	50                   	push   %eax
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	ff 75 08             	pushl  0x8(%ebp)
  800bfb:	e8 89 ff ff ff       	call   800b89 <vsnprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
  800c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 06                	jmp    800c20 <strlen+0x15>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8a 00                	mov    (%eax),%al
  800c25:	84 c0                	test   %al,%al
  800c27:	75 f1                	jne    800c1a <strlen+0xf>
		n++;
	return n;
  800c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3b:	eb 09                	jmp    800c46 <strnlen+0x18>
		n++;
  800c3d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c40:	ff 45 08             	incl   0x8(%ebp)
  800c43:	ff 4d 0c             	decl   0xc(%ebp)
  800c46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4a:	74 09                	je     800c55 <strnlen+0x27>
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	84 c0                	test   %al,%al
  800c53:	75 e8                	jne    800c3d <strnlen+0xf>
		n++;
	return n;
  800c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c66:	90                   	nop
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8d 50 01             	lea    0x1(%eax),%edx
  800c6d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c73:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c76:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c79:	8a 12                	mov    (%edx),%dl
  800c7b:	88 10                	mov    %dl,(%eax)
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	75 e4                	jne    800c67 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 1f                	jmp    800cbc <strncpy+0x34>
		*dst++ = *src;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8d 50 01             	lea    0x1(%eax),%edx
  800ca3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca9:	8a 12                	mov    (%edx),%dl
  800cab:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	84 c0                	test   %al,%al
  800cb4:	74 03                	je     800cb9 <strncpy+0x31>
			src++;
  800cb6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb9:	ff 45 fc             	incl   -0x4(%ebp)
  800cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc2:	72 d9                	jb     800c9d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd9:	74 30                	je     800d0b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cdb:	eb 16                	jmp    800cf3 <strlcpy+0x2a>
			*dst++ = *src++;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cef:	8a 12                	mov    (%edx),%dl
  800cf1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf3:	ff 4d 10             	decl   0x10(%ebp)
  800cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfa:	74 09                	je     800d05 <strlcpy+0x3c>
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	84 c0                	test   %al,%al
  800d03:	75 d8                	jne    800cdd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d11:	29 c2                	sub    %eax,%edx
  800d13:	89 d0                	mov    %edx,%eax
}
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d1a:	eb 06                	jmp    800d22 <strcmp+0xb>
		p++, q++;
  800d1c:	ff 45 08             	incl   0x8(%ebp)
  800d1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	84 c0                	test   %al,%al
  800d29:	74 0e                	je     800d39 <strcmp+0x22>
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 10                	mov    (%eax),%dl
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	38 c2                	cmp    %al,%dl
  800d37:	74 e3                	je     800d1c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 c0             	movzbl %al,%eax
  800d49:	29 c2                	sub    %eax,%edx
  800d4b:	89 d0                	mov    %edx,%eax
}
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d52:	eb 09                	jmp    800d5d <strncmp+0xe>
		n--, p++, q++;
  800d54:	ff 4d 10             	decl   0x10(%ebp)
  800d57:	ff 45 08             	incl   0x8(%ebp)
  800d5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d61:	74 17                	je     800d7a <strncmp+0x2b>
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	74 0e                	je     800d7a <strncmp+0x2b>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 10                	mov    (%eax),%dl
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	38 c2                	cmp    %al,%dl
  800d78:	74 da                	je     800d54 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	75 07                	jne    800d87 <strncmp+0x38>
		return 0;
  800d80:	b8 00 00 00 00       	mov    $0x0,%eax
  800d85:	eb 14                	jmp    800d9b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	0f b6 d0             	movzbl %al,%edx
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	0f b6 c0             	movzbl %al,%eax
  800d97:	29 c2                	sub    %eax,%edx
  800d99:	89 d0                	mov    %edx,%eax
}
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 04             	sub    $0x4,%esp
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da9:	eb 12                	jmp    800dbd <strchr+0x20>
		if (*s == c)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db3:	75 05                	jne    800dba <strchr+0x1d>
			return (char *) s;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	eb 11                	jmp    800dcb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dba:	ff 45 08             	incl   0x8(%ebp)
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	84 c0                	test   %al,%al
  800dc4:	75 e5                	jne    800dab <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 04             	sub    $0x4,%esp
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd9:	eb 0d                	jmp    800de8 <strfind+0x1b>
		if (*s == c)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de3:	74 0e                	je     800df3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	84 c0                	test   %al,%al
  800def:	75 ea                	jne    800ddb <strfind+0xe>
  800df1:	eb 01                	jmp    800df4 <strfind+0x27>
		if (*s == c)
			break;
  800df3:	90                   	nop
	return (char *) s;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e05:	8b 45 10             	mov    0x10(%ebp),%eax
  800e08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e0b:	eb 0e                	jmp    800e1b <memset+0x22>
		*p++ = c;
  800e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e10:	8d 50 01             	lea    0x1(%eax),%edx
  800e13:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e19:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e1b:	ff 4d f8             	decl   -0x8(%ebp)
  800e1e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e22:	79 e9                	jns    800e0d <memset+0x14>
		*p++ = c;

	return v;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e3b:	eb 16                	jmp    800e53 <memcpy+0x2a>
		*d++ = *s++;
  800e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e40:	8d 50 01             	lea    0x1(%eax),%edx
  800e43:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4f:	8a 12                	mov    (%edx),%dl
  800e51:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e53:	8b 45 10             	mov    0x10(%ebp),%eax
  800e56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e59:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	75 dd                	jne    800e3d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e63:	c9                   	leave  
  800e64:	c3                   	ret    

00800e65 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e7d:	73 50                	jae    800ecf <memmove+0x6a>
  800e7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e82:	8b 45 10             	mov    0x10(%ebp),%eax
  800e85:	01 d0                	add    %edx,%eax
  800e87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e8a:	76 43                	jbe    800ecf <memmove+0x6a>
		s += n;
  800e8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e98:	eb 10                	jmp    800eaa <memmove+0x45>
			*--d = *--s;
  800e9a:	ff 4d f8             	decl   -0x8(%ebp)
  800e9d:	ff 4d fc             	decl   -0x4(%ebp)
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea3:	8a 10                	mov    (%eax),%dl
  800ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ead:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	75 e3                	jne    800e9a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb7:	eb 23                	jmp    800edc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ecb:	8a 12                	mov    (%edx),%dl
  800ecd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	75 dd                	jne    800eb9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ef3:	eb 2a                	jmp    800f1f <memcmp+0x3e>
		if (*s1 != *s2)
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef8:	8a 10                	mov    (%eax),%dl
  800efa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	38 c2                	cmp    %al,%dl
  800f01:	74 16                	je     800f19 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	0f b6 d0             	movzbl %al,%edx
  800f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 c0             	movzbl %al,%eax
  800f13:	29 c2                	sub    %eax,%edx
  800f15:	89 d0                	mov    %edx,%eax
  800f17:	eb 18                	jmp    800f31 <memcmp+0x50>
		s1++, s2++;
  800f19:	ff 45 fc             	incl   -0x4(%ebp)
  800f1c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f25:	89 55 10             	mov    %edx,0x10(%ebp)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	75 c9                	jne    800ef5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3f:	01 d0                	add    %edx,%eax
  800f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f44:	eb 15                	jmp    800f5b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f b6 d0             	movzbl %al,%edx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	0f b6 c0             	movzbl %al,%eax
  800f54:	39 c2                	cmp    %eax,%edx
  800f56:	74 0d                	je     800f65 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f61:	72 e3                	jb     800f46 <memfind+0x13>
  800f63:	eb 01                	jmp    800f66 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f65:	90                   	nop
	return (void *) s;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f78:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7f:	eb 03                	jmp    800f84 <strtol+0x19>
		s++;
  800f81:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 20                	cmp    $0x20,%al
  800f8b:	74 f4                	je     800f81 <strtol+0x16>
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 09                	cmp    $0x9,%al
  800f94:	74 eb                	je     800f81 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 2b                	cmp    $0x2b,%al
  800f9d:	75 05                	jne    800fa4 <strtol+0x39>
		s++;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	eb 13                	jmp    800fb7 <strtol+0x4c>
	else if (*s == '-')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 2d                	cmp    $0x2d,%al
  800fab:	75 0a                	jne    800fb7 <strtol+0x4c>
		s++, neg = 1;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbb:	74 06                	je     800fc3 <strtol+0x58>
  800fbd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fc1:	75 20                	jne    800fe3 <strtol+0x78>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3c 30                	cmp    $0x30,%al
  800fca:	75 17                	jne    800fe3 <strtol+0x78>
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	40                   	inc    %eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 78                	cmp    $0x78,%al
  800fd4:	75 0d                	jne    800fe3 <strtol+0x78>
		s += 2, base = 16;
  800fd6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fda:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fe1:	eb 28                	jmp    80100b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fe3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe7:	75 15                	jne    800ffe <strtol+0x93>
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 30                	cmp    $0x30,%al
  800ff0:	75 0c                	jne    800ffe <strtol+0x93>
		s++, base = 8;
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ffc:	eb 0d                	jmp    80100b <strtol+0xa0>
	else if (base == 0)
  800ffe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801002:	75 07                	jne    80100b <strtol+0xa0>
		base = 10;
  801004:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 2f                	cmp    $0x2f,%al
  801012:	7e 19                	jle    80102d <strtol+0xc2>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 39                	cmp    $0x39,%al
  80101b:	7f 10                	jg     80102d <strtol+0xc2>
			dig = *s - '0';
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f be c0             	movsbl %al,%eax
  801025:	83 e8 30             	sub    $0x30,%eax
  801028:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102b:	eb 42                	jmp    80106f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 60                	cmp    $0x60,%al
  801034:	7e 19                	jle    80104f <strtol+0xe4>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 7a                	cmp    $0x7a,%al
  80103d:	7f 10                	jg     80104f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f be c0             	movsbl %al,%eax
  801047:	83 e8 57             	sub    $0x57,%eax
  80104a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80104d:	eb 20                	jmp    80106f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 40                	cmp    $0x40,%al
  801056:	7e 39                	jle    801091 <strtol+0x126>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 5a                	cmp    $0x5a,%al
  80105f:	7f 30                	jg     801091 <strtol+0x126>
			dig = *s - 'A' + 10;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f be c0             	movsbl %al,%eax
  801069:	83 e8 37             	sub    $0x37,%eax
  80106c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801072:	3b 45 10             	cmp    0x10(%ebp),%eax
  801075:	7d 19                	jge    801090 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801081:	89 c2                	mov    %eax,%edx
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80108b:	e9 7b ff ff ff       	jmp    80100b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801090:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801091:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801095:	74 08                	je     80109f <strtol+0x134>
		*endptr = (char *) s;
  801097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109a:	8b 55 08             	mov    0x8(%ebp),%edx
  80109d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010a3:	74 07                	je     8010ac <strtol+0x141>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a8:	f7 d8                	neg    %eax
  8010aa:	eb 03                	jmp    8010af <strtol+0x144>
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    

008010b1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c9:	79 13                	jns    8010de <ltostr+0x2d>
	{
		neg = 1;
  8010cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010db:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e6:	99                   	cltd   
  8010e7:	f7 f9                	idiv   %ecx
  8010e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ef:	8d 50 01             	lea    0x1(%eax),%edx
  8010f2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f5:	89 c2                	mov    %eax,%edx
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ff:	83 c2 30             	add    $0x30,%edx
  801102:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801104:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801107:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110c:	f7 e9                	imul   %ecx
  80110e:	c1 fa 02             	sar    $0x2,%edx
  801111:	89 c8                	mov    %ecx,%eax
  801113:	c1 f8 1f             	sar    $0x1f,%eax
  801116:	29 c2                	sub    %eax,%edx
  801118:	89 d0                	mov    %edx,%eax
  80111a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80111d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801121:	75 bb                	jne    8010de <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xc3>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 73 fa ff ff       	call   800c0b <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 65 fa ff ff       	call   800c0b <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 32 fb ff ff       	call   800d9d <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 d4 fa ff ff       	call   800d9d <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	68 a8 23 80 00       	push   $0x8023a8
  801302:	68 3f 01 00 00       	push   $0x13f
  801307:	68 ca 23 80 00       	push   $0x8023ca
  80130c:	e8 57 07 00 00       	call   801a68 <_panic>

00801311 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	e8 ef 06 00 00       	call   801a11 <sys_sbrk>
  801322:	83 c4 10             	add    $0x10,%esp
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80132d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801331:	75 07                	jne    80133a <malloc+0x13>
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
  801338:	eb 14                	jmp    80134e <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80133a:	83 ec 04             	sub    $0x4,%esp
  80133d:	68 d8 23 80 00       	push   $0x8023d8
  801342:	6a 1b                	push   $0x1b
  801344:	68 fd 23 80 00       	push   $0x8023fd
  801349:	e8 1a 07 00 00       	call   801a68 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	68 0c 24 80 00       	push   $0x80240c
  80135e:	6a 29                	push   $0x29
  801360:	68 fd 23 80 00       	push   $0x8023fd
  801365:	e8 fe 06 00 00       	call   801a68 <_panic>

0080136a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 18             	sub    $0x18,%esp
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801376:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137a:	75 07                	jne    801383 <smalloc+0x19>
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	eb 14                	jmp    801397 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801383:	83 ec 04             	sub    $0x4,%esp
  801386:	68 30 24 80 00       	push   $0x802430
  80138b:	6a 38                	push   $0x38
  80138d:	68 fd 23 80 00       	push   $0x8023fd
  801392:	e8 d1 06 00 00       	call   801a68 <_panic>
	return NULL;
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	68 58 24 80 00       	push   $0x802458
  8013a7:	6a 43                	push   $0x43
  8013a9:	68 fd 23 80 00       	push   $0x8023fd
  8013ae:	e8 b5 06 00 00       	call   801a68 <_panic>

008013b3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	68 7c 24 80 00       	push   $0x80247c
  8013c1:	6a 5b                	push   $0x5b
  8013c3:	68 fd 23 80 00       	push   $0x8023fd
  8013c8:	e8 9b 06 00 00       	call   801a68 <_panic>

008013cd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 a0 24 80 00       	push   $0x8024a0
  8013db:	6a 72                	push   $0x72
  8013dd:	68 fd 23 80 00       	push   $0x8023fd
  8013e2:	e8 81 06 00 00       	call   801a68 <_panic>

008013e7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	68 c6 24 80 00       	push   $0x8024c6
  8013f5:	6a 7e                	push   $0x7e
  8013f7:	68 fd 23 80 00       	push   $0x8023fd
  8013fc:	e8 67 06 00 00       	call   801a68 <_panic>

00801401 <shrink>:

}
void shrink(uint32 newSize)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	68 c6 24 80 00       	push   $0x8024c6
  80140f:	68 83 00 00 00       	push   $0x83
  801414:	68 fd 23 80 00       	push   $0x8023fd
  801419:	e8 4a 06 00 00       	call   801a68 <_panic>

0080141e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	68 c6 24 80 00       	push   $0x8024c6
  80142c:	68 88 00 00 00       	push   $0x88
  801431:	68 fd 23 80 00       	push   $0x8023fd
  801436:	e8 2d 06 00 00       	call   801a68 <_panic>

0080143b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	57                   	push   %edi
  80143f:	56                   	push   %esi
  801440:	53                   	push   %ebx
  801441:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801450:	8b 7d 18             	mov    0x18(%ebp),%edi
  801453:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801456:	cd 30                	int    $0x30
  801458:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80145b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5f                   	pop    %edi
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    

00801466 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801472:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	ff 75 0c             	pushl  0xc(%ebp)
  801481:	50                   	push   %eax
  801482:	6a 00                	push   $0x0
  801484:	e8 b2 ff ff ff       	call   80143b <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
}
  80148c:	90                   	nop
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <sys_cgetc>:

int
sys_cgetc(void)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 02                	push   $0x2
  80149e:	e8 98 ff ff ff       	call   80143b <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 03                	push   $0x3
  8014b7:	e8 7f ff ff ff       	call   80143b <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 04                	push   $0x4
  8014d1:	e8 65 ff ff ff       	call   80143b <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	90                   	nop
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	52                   	push   %edx
  8014ec:	50                   	push   %eax
  8014ed:	6a 08                	push   $0x8
  8014ef:	e8 47 ff ff ff       	call   80143b <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	56                   	push   %esi
  8014fd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014fe:	8b 75 18             	mov    0x18(%ebp),%esi
  801501:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801504:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	56                   	push   %esi
  80150e:	53                   	push   %ebx
  80150f:	51                   	push   %ecx
  801510:	52                   	push   %edx
  801511:	50                   	push   %eax
  801512:	6a 09                	push   $0x9
  801514:	e8 22 ff ff ff       	call   80143b <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    

00801523 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801526:	8b 55 0c             	mov    0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	6a 0a                	push   $0xa
  801536:	e8 00 ff ff ff       	call   80143b <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	ff 75 0c             	pushl  0xc(%ebp)
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	6a 0b                	push   $0xb
  801551:	e8 e5 fe ff ff       	call   80143b <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 0c                	push   $0xc
  80156a:	e8 cc fe ff ff       	call   80143b <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 0d                	push   $0xd
  801583:	e8 b3 fe ff ff       	call   80143b <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 0e                	push   $0xe
  80159c:	e8 9a fe ff ff       	call   80143b <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 0f                	push   $0xf
  8015b5:	e8 81 fe ff ff       	call   80143b <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	ff 75 08             	pushl  0x8(%ebp)
  8015cd:	6a 10                	push   $0x10
  8015cf:	e8 67 fe ff ff       	call   80143b <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 11                	push   $0x11
  8015e8:	e8 4e fe ff ff       	call   80143b <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	90                   	nop
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	50                   	push   %eax
  80160c:	6a 01                	push   $0x1
  80160e:	e8 28 fe ff ff       	call   80143b <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 14                	push   $0x14
  801628:	e8 0e fe ff ff       	call   80143b <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	90                   	nop
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	8b 45 10             	mov    0x10(%ebp),%eax
  80163c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80163f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801642:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	6a 00                	push   $0x0
  80164b:	51                   	push   %ecx
  80164c:	52                   	push   %edx
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	50                   	push   %eax
  801651:	6a 15                	push   $0x15
  801653:	e8 e3 fd ff ff       	call   80143b <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	6a 16                	push   $0x16
  801670:	e8 c6 fd ff ff       	call   80143b <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80167d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801680:	8b 55 0c             	mov    0xc(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	51                   	push   %ecx
  80168b:	52                   	push   %edx
  80168c:	50                   	push   %eax
  80168d:	6a 17                	push   $0x17
  80168f:	e8 a7 fd ff ff       	call   80143b <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 18                	push   $0x18
  8016ac:	e8 8a fd ff ff       	call   80143b <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	6a 00                	push   $0x0
  8016be:	ff 75 14             	pushl  0x14(%ebp)
  8016c1:	ff 75 10             	pushl  0x10(%ebp)
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	50                   	push   %eax
  8016c8:	6a 19                	push   $0x19
  8016ca:	e8 6c fd ff ff       	call   80143b <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	50                   	push   %eax
  8016e3:	6a 1a                	push   $0x1a
  8016e5:	e8 51 fd ff ff       	call   80143b <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	50                   	push   %eax
  8016ff:	6a 1b                	push   $0x1b
  801701:	e8 35 fd ff ff       	call   80143b <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 05                	push   $0x5
  80171a:	e8 1c fd ff ff       	call   80143b <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 06                	push   $0x6
  801733:	e8 03 fd ff ff       	call   80143b <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 07                	push   $0x7
  80174c:	e8 ea fc ff ff       	call   80143b <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_exit_env>:


void sys_exit_env(void)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 1c                	push   $0x1c
  801765:	e8 d1 fc ff ff       	call   80143b <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	90                   	nop
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801776:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801779:	8d 50 04             	lea    0x4(%eax),%edx
  80177c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	52                   	push   %edx
  801786:	50                   	push   %eax
  801787:	6a 1d                	push   $0x1d
  801789:	e8 ad fc ff ff       	call   80143b <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
	return result;
  801791:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801794:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801797:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179a:	89 01                	mov    %eax,(%ecx)
  80179c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	c9                   	leave  
  8017a3:	c2 04 00             	ret    $0x4

008017a6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	6a 13                	push   $0x13
  8017b8:	e8 7e fc ff ff       	call   80143b <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c0:	90                   	nop
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 1e                	push   $0x1e
  8017d2:	e8 64 fc ff ff       	call   80143b <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017e8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	50                   	push   %eax
  8017f5:	6a 1f                	push   $0x1f
  8017f7:	e8 3f fc ff ff       	call   80143b <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ff:	90                   	nop
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <rsttst>:
void rsttst()
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 21                	push   $0x21
  801811:	e8 25 fc ff ff       	call   80143b <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
	return ;
  801819:	90                   	nop
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	8b 45 14             	mov    0x14(%ebp),%eax
  801825:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801828:	8b 55 18             	mov    0x18(%ebp),%edx
  80182b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80182f:	52                   	push   %edx
  801830:	50                   	push   %eax
  801831:	ff 75 10             	pushl  0x10(%ebp)
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	6a 20                	push   $0x20
  80183c:	e8 fa fb ff ff       	call   80143b <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
	return ;
  801844:	90                   	nop
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <chktst>:
void chktst(uint32 n)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	6a 22                	push   $0x22
  801857:	e8 df fb ff ff       	call   80143b <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
	return ;
  80185f:	90                   	nop
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <inctst>:

void inctst()
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 23                	push   $0x23
  801871:	e8 c5 fb ff ff       	call   80143b <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
	return ;
  801879:	90                   	nop
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <gettst>:
uint32 gettst()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 24                	push   $0x24
  80188b:	e8 ab fb ff ff       	call   80143b <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 25                	push   $0x25
  8018a7:	e8 8f fb ff ff       	call   80143b <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
  8018af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018b2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018b6:	75 07                	jne    8018bf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bd:	eb 05                	jmp    8018c4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 25                	push   $0x25
  8018d8:	e8 5e fb ff ff       	call   80143b <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
  8018e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018e3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018e7:	75 07                	jne    8018f0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ee:	eb 05                	jmp    8018f5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 25                	push   $0x25
  801909:	e8 2d fb ff ff       	call   80143b <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
  801911:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801914:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801918:	75 07                	jne    801921 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80191a:	b8 01 00 00 00       	mov    $0x1,%eax
  80191f:	eb 05                	jmp    801926 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801921:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 25                	push   $0x25
  80193a:	e8 fc fa ff ff       	call   80143b <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
  801942:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801945:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801949:	75 07                	jne    801952 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80194b:	b8 01 00 00 00       	mov    $0x1,%eax
  801950:	eb 05                	jmp    801957 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801952:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 26                	push   $0x26
  801969:	e8 cd fa ff ff       	call   80143b <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return ;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801978:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	53                   	push   %ebx
  801987:	51                   	push   %ecx
  801988:	52                   	push   %edx
  801989:	50                   	push   %eax
  80198a:	6a 27                	push   $0x27
  80198c:	e8 aa fa ff ff       	call   80143b <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80199c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	6a 28                	push   $0x28
  8019ac:	e8 8a fa ff ff       	call   80143b <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	6a 00                	push   $0x0
  8019c4:	51                   	push   %ecx
  8019c5:	ff 75 10             	pushl  0x10(%ebp)
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	6a 29                	push   $0x29
  8019cc:	e8 6a fa ff ff       	call   80143b <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	ff 75 10             	pushl  0x10(%ebp)
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	6a 12                	push   $0x12
  8019e8:	e8 4e fa ff ff       	call   80143b <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	52                   	push   %edx
  801a03:	50                   	push   %eax
  801a04:	6a 2a                	push   $0x2a
  801a06:	e8 30 fa ff ff       	call   80143b <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
	return;
  801a0e:	90                   	nop
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	68 d6 24 80 00       	push   $0x8024d6
  801a1f:	68 2e 01 00 00       	push   $0x12e
  801a24:	68 ea 24 80 00       	push   $0x8024ea
  801a29:	e8 3a 00 00 00       	call   801a68 <_panic>

00801a2e <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	68 d6 24 80 00       	push   $0x8024d6
  801a3c:	68 35 01 00 00       	push   $0x135
  801a41:	68 ea 24 80 00       	push   $0x8024ea
  801a46:	e8 1d 00 00 00       	call   801a68 <_panic>

00801a4b <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	68 d6 24 80 00       	push   $0x8024d6
  801a59:	68 3b 01 00 00       	push   $0x13b
  801a5e:	68 ea 24 80 00       	push   $0x8024ea
  801a63:	e8 00 00 00 00       	call   801a68 <_panic>

00801a68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a6e:	8d 45 10             	lea    0x10(%ebp),%eax
  801a71:	83 c0 04             	add    $0x4,%eax
  801a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a77:	a1 24 30 80 00       	mov    0x803024,%eax
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	74 16                	je     801a96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a80:	a1 24 30 80 00       	mov    0x803024,%eax
  801a85:	83 ec 08             	sub    $0x8,%esp
  801a88:	50                   	push   %eax
  801a89:	68 f8 24 80 00       	push   $0x8024f8
  801a8e:	e8 e4 ea ff ff       	call   800577 <cprintf>
  801a93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a96:	a1 00 30 80 00       	mov    0x803000,%eax
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	68 fd 24 80 00       	push   $0x8024fd
  801aa7:	e8 cb ea ff ff       	call   800577 <cprintf>
  801aac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab8:	50                   	push   %eax
  801ab9:	e8 4e ea ff ff       	call   80050c <vcprintf>
  801abe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801ac1:	83 ec 08             	sub    $0x8,%esp
  801ac4:	6a 00                	push   $0x0
  801ac6:	68 19 25 80 00       	push   $0x802519
  801acb:	e8 3c ea ff ff       	call   80050c <vcprintf>
  801ad0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ad3:	e8 bd e9 ff ff       	call   800495 <exit>

	// should not return here
	while (1) ;
  801ad8:	eb fe                	jmp    801ad8 <_panic+0x70>

00801ada <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801ae0:	a1 04 30 80 00       	mov    0x803004,%eax
  801ae5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aee:	39 c2                	cmp    %eax,%edx
  801af0:	74 14                	je     801b06 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	68 1c 25 80 00       	push   $0x80251c
  801afa:	6a 26                	push   $0x26
  801afc:	68 68 25 80 00       	push   $0x802568
  801b01:	e8 62 ff ff ff       	call   801a68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b14:	e9 c5 00 00 00       	jmp    801bde <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	01 d0                	add    %edx,%eax
  801b28:	8b 00                	mov    (%eax),%eax
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	75 08                	jne    801b36 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b2e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b31:	e9 a5 00 00 00       	jmp    801bdb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b44:	eb 69                	jmp    801baf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b46:	a1 04 30 80 00       	mov    0x803004,%eax
  801b4b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b54:	89 d0                	mov    %edx,%eax
  801b56:	01 c0                	add    %eax,%eax
  801b58:	01 d0                	add    %edx,%eax
  801b5a:	c1 e0 03             	shl    $0x3,%eax
  801b5d:	01 c8                	add    %ecx,%eax
  801b5f:	8a 40 04             	mov    0x4(%eax),%al
  801b62:	84 c0                	test   %al,%al
  801b64:	75 46                	jne    801bac <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b66:	a1 04 30 80 00       	mov    0x803004,%eax
  801b6b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b74:	89 d0                	mov    %edx,%eax
  801b76:	01 c0                	add    %eax,%eax
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	c1 e0 03             	shl    $0x3,%eax
  801b7d:	01 c8                	add    %ecx,%eax
  801b7f:	8b 00                	mov    (%eax),%eax
  801b81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b8c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b91:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b9f:	39 c2                	cmp    %eax,%edx
  801ba1:	75 09                	jne    801bac <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ba3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801baa:	eb 15                	jmp    801bc1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bac:	ff 45 e8             	incl   -0x18(%ebp)
  801baf:	a1 04 30 80 00       	mov    0x803004,%eax
  801bb4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bbd:	39 c2                	cmp    %eax,%edx
  801bbf:	77 85                	ja     801b46 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bc5:	75 14                	jne    801bdb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	68 74 25 80 00       	push   $0x802574
  801bcf:	6a 3a                	push   $0x3a
  801bd1:	68 68 25 80 00       	push   $0x802568
  801bd6:	e8 8d fe ff ff       	call   801a68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bdb:	ff 45 f0             	incl   -0x10(%ebp)
  801bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801be4:	0f 8c 2f ff ff ff    	jl     801b19 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bf1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bf8:	eb 26                	jmp    801c20 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bfa:	a1 04 30 80 00       	mov    0x803004,%eax
  801bff:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	01 c0                	add    %eax,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c1 e0 03             	shl    $0x3,%eax
  801c11:	01 c8                	add    %ecx,%eax
  801c13:	8a 40 04             	mov    0x4(%eax),%al
  801c16:	3c 01                	cmp    $0x1,%al
  801c18:	75 03                	jne    801c1d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c1a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c1d:	ff 45 e0             	incl   -0x20(%ebp)
  801c20:	a1 04 30 80 00       	mov    0x803004,%eax
  801c25:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2e:	39 c2                	cmp    %eax,%edx
  801c30:	77 c8                	ja     801bfa <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c38:	74 14                	je     801c4e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	68 c8 25 80 00       	push   $0x8025c8
  801c42:	6a 44                	push   $0x44
  801c44:	68 68 25 80 00       	push   $0x802568
  801c49:	e8 1a fe ff ff       	call   801a68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c4e:	90                   	nop
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    
  801c51:	66 90                	xchg   %ax,%ax
  801c53:	90                   	nop

00801c54 <__udivdi3>:
  801c54:	55                   	push   %ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6b:	89 ca                	mov    %ecx,%edx
  801c6d:	89 f8                	mov    %edi,%eax
  801c6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c73:	85 f6                	test   %esi,%esi
  801c75:	75 2d                	jne    801ca4 <__udivdi3+0x50>
  801c77:	39 cf                	cmp    %ecx,%edi
  801c79:	77 65                	ja     801ce0 <__udivdi3+0x8c>
  801c7b:	89 fd                	mov    %edi,%ebp
  801c7d:	85 ff                	test   %edi,%edi
  801c7f:	75 0b                	jne    801c8c <__udivdi3+0x38>
  801c81:	b8 01 00 00 00       	mov    $0x1,%eax
  801c86:	31 d2                	xor    %edx,%edx
  801c88:	f7 f7                	div    %edi
  801c8a:	89 c5                	mov    %eax,%ebp
  801c8c:	31 d2                	xor    %edx,%edx
  801c8e:	89 c8                	mov    %ecx,%eax
  801c90:	f7 f5                	div    %ebp
  801c92:	89 c1                	mov    %eax,%ecx
  801c94:	89 d8                	mov    %ebx,%eax
  801c96:	f7 f5                	div    %ebp
  801c98:	89 cf                	mov    %ecx,%edi
  801c9a:	89 fa                	mov    %edi,%edx
  801c9c:	83 c4 1c             	add    $0x1c,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
  801ca4:	39 ce                	cmp    %ecx,%esi
  801ca6:	77 28                	ja     801cd0 <__udivdi3+0x7c>
  801ca8:	0f bd fe             	bsr    %esi,%edi
  801cab:	83 f7 1f             	xor    $0x1f,%edi
  801cae:	75 40                	jne    801cf0 <__udivdi3+0x9c>
  801cb0:	39 ce                	cmp    %ecx,%esi
  801cb2:	72 0a                	jb     801cbe <__udivdi3+0x6a>
  801cb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cb8:	0f 87 9e 00 00 00    	ja     801d5c <__udivdi3+0x108>
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	89 fa                	mov    %edi,%edx
  801cc5:	83 c4 1c             	add    $0x1c,%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
  801ccd:	8d 76 00             	lea    0x0(%esi),%esi
  801cd0:	31 ff                	xor    %edi,%edi
  801cd2:	31 c0                	xor    %eax,%eax
  801cd4:	89 fa                	mov    %edi,%edx
  801cd6:	83 c4 1c             	add    $0x1c,%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5f                   	pop    %edi
  801cdc:	5d                   	pop    %ebp
  801cdd:	c3                   	ret    
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	f7 f7                	div    %edi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	89 fa                	mov    %edi,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cf5:	89 eb                	mov    %ebp,%ebx
  801cf7:	29 fb                	sub    %edi,%ebx
  801cf9:	89 f9                	mov    %edi,%ecx
  801cfb:	d3 e6                	shl    %cl,%esi
  801cfd:	89 c5                	mov    %eax,%ebp
  801cff:	88 d9                	mov    %bl,%cl
  801d01:	d3 ed                	shr    %cl,%ebp
  801d03:	89 e9                	mov    %ebp,%ecx
  801d05:	09 f1                	or     %esi,%ecx
  801d07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d0b:	89 f9                	mov    %edi,%ecx
  801d0d:	d3 e0                	shl    %cl,%eax
  801d0f:	89 c5                	mov    %eax,%ebp
  801d11:	89 d6                	mov    %edx,%esi
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ee                	shr    %cl,%esi
  801d17:	89 f9                	mov    %edi,%ecx
  801d19:	d3 e2                	shl    %cl,%edx
  801d1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1f:	88 d9                	mov    %bl,%cl
  801d21:	d3 e8                	shr    %cl,%eax
  801d23:	09 c2                	or     %eax,%edx
  801d25:	89 d0                	mov    %edx,%eax
  801d27:	89 f2                	mov    %esi,%edx
  801d29:	f7 74 24 0c          	divl   0xc(%esp)
  801d2d:	89 d6                	mov    %edx,%esi
  801d2f:	89 c3                	mov    %eax,%ebx
  801d31:	f7 e5                	mul    %ebp
  801d33:	39 d6                	cmp    %edx,%esi
  801d35:	72 19                	jb     801d50 <__udivdi3+0xfc>
  801d37:	74 0b                	je     801d44 <__udivdi3+0xf0>
  801d39:	89 d8                	mov    %ebx,%eax
  801d3b:	31 ff                	xor    %edi,%edi
  801d3d:	e9 58 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d42:	66 90                	xchg   %ax,%ax
  801d44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d48:	89 f9                	mov    %edi,%ecx
  801d4a:	d3 e2                	shl    %cl,%edx
  801d4c:	39 c2                	cmp    %eax,%edx
  801d4e:	73 e9                	jae    801d39 <__udivdi3+0xe5>
  801d50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d53:	31 ff                	xor    %edi,%edi
  801d55:	e9 40 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	31 c0                	xor    %eax,%eax
  801d5e:	e9 37 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d63:	90                   	nop

00801d64 <__umoddi3>:
  801d64:	55                   	push   %ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 1c             	sub    $0x1c,%esp
  801d6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d83:	89 f3                	mov    %esi,%ebx
  801d85:	89 fa                	mov    %edi,%edx
  801d87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d8b:	89 34 24             	mov    %esi,(%esp)
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	75 1a                	jne    801dac <__umoddi3+0x48>
  801d92:	39 f7                	cmp    %esi,%edi
  801d94:	0f 86 a2 00 00 00    	jbe    801e3c <__umoddi3+0xd8>
  801d9a:	89 c8                	mov    %ecx,%eax
  801d9c:	89 f2                	mov    %esi,%edx
  801d9e:	f7 f7                	div    %edi
  801da0:	89 d0                	mov    %edx,%eax
  801da2:	31 d2                	xor    %edx,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	39 f0                	cmp    %esi,%eax
  801dae:	0f 87 ac 00 00 00    	ja     801e60 <__umoddi3+0xfc>
  801db4:	0f bd e8             	bsr    %eax,%ebp
  801db7:	83 f5 1f             	xor    $0x1f,%ebp
  801dba:	0f 84 ac 00 00 00    	je     801e6c <__umoddi3+0x108>
  801dc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801dc5:	29 ef                	sub    %ebp,%edi
  801dc7:	89 fe                	mov    %edi,%esi
  801dc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	d3 e0                	shl    %cl,%eax
  801dd1:	89 d7                	mov    %edx,%edi
  801dd3:	89 f1                	mov    %esi,%ecx
  801dd5:	d3 ef                	shr    %cl,%edi
  801dd7:	09 c7                	or     %eax,%edi
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	d3 e2                	shl    %cl,%edx
  801ddd:	89 14 24             	mov    %edx,(%esp)
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	d3 e0                	shl    %cl,%eax
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df4:	89 f1                	mov    %esi,%ecx
  801df6:	d3 e8                	shr    %cl,%eax
  801df8:	09 d0                	or     %edx,%eax
  801dfa:	d3 eb                	shr    %cl,%ebx
  801dfc:	89 da                	mov    %ebx,%edx
  801dfe:	f7 f7                	div    %edi
  801e00:	89 d3                	mov    %edx,%ebx
  801e02:	f7 24 24             	mull   (%esp)
  801e05:	89 c6                	mov    %eax,%esi
  801e07:	89 d1                	mov    %edx,%ecx
  801e09:	39 d3                	cmp    %edx,%ebx
  801e0b:	0f 82 87 00 00 00    	jb     801e98 <__umoddi3+0x134>
  801e11:	0f 84 91 00 00 00    	je     801ea8 <__umoddi3+0x144>
  801e17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e1b:	29 f2                	sub    %esi,%edx
  801e1d:	19 cb                	sbb    %ecx,%ebx
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e25:	d3 e0                	shl    %cl,%eax
  801e27:	89 e9                	mov    %ebp,%ecx
  801e29:	d3 ea                	shr    %cl,%edx
  801e2b:	09 d0                	or     %edx,%eax
  801e2d:	89 e9                	mov    %ebp,%ecx
  801e2f:	d3 eb                	shr    %cl,%ebx
  801e31:	89 da                	mov    %ebx,%edx
  801e33:	83 c4 1c             	add    $0x1c,%esp
  801e36:	5b                   	pop    %ebx
  801e37:	5e                   	pop    %esi
  801e38:	5f                   	pop    %edi
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    
  801e3b:	90                   	nop
  801e3c:	89 fd                	mov    %edi,%ebp
  801e3e:	85 ff                	test   %edi,%edi
  801e40:	75 0b                	jne    801e4d <__umoddi3+0xe9>
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	31 d2                	xor    %edx,%edx
  801e49:	f7 f7                	div    %edi
  801e4b:	89 c5                	mov    %eax,%ebp
  801e4d:	89 f0                	mov    %esi,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f5                	div    %ebp
  801e53:	89 c8                	mov    %ecx,%eax
  801e55:	f7 f5                	div    %ebp
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	e9 44 ff ff ff       	jmp    801da2 <__umoddi3+0x3e>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	89 c8                	mov    %ecx,%eax
  801e62:	89 f2                	mov    %esi,%edx
  801e64:	83 c4 1c             	add    $0x1c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
  801e6c:	3b 04 24             	cmp    (%esp),%eax
  801e6f:	72 06                	jb     801e77 <__umoddi3+0x113>
  801e71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e75:	77 0f                	ja     801e86 <__umoddi3+0x122>
  801e77:	89 f2                	mov    %esi,%edx
  801e79:	29 f9                	sub    %edi,%ecx
  801e7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e7f:	89 14 24             	mov    %edx,(%esp)
  801e82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e8a:	8b 14 24             	mov    (%esp),%edx
  801e8d:	83 c4 1c             	add    $0x1c,%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    
  801e95:	8d 76 00             	lea    0x0(%esi),%esi
  801e98:	2b 04 24             	sub    (%esp),%eax
  801e9b:	19 fa                	sbb    %edi,%edx
  801e9d:	89 d1                	mov    %edx,%ecx
  801e9f:	89 c6                	mov    %eax,%esi
  801ea1:	e9 71 ff ff ff       	jmp    801e17 <__umoddi3+0xb3>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eac:	72 ea                	jb     801e98 <__umoddi3+0x134>
  801eae:	89 d9                	mov    %ebx,%ecx
  801eb0:	e9 62 ff ff ff       	jmp    801e17 <__umoddi3+0xb3>
