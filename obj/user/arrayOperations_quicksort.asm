
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
  80003e:	e8 b2 16 00 00       	call   8016f5 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 dc 16 00 00       	call   801727 <sys_getparentenvid>
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
  80005f:	68 a0 1e 80 00       	push   $0x801ea0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 17 13 00 00       	call   801383 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a4 1e 80 00       	push   $0x801ea4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 01 13 00 00       	call   801383 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ac 1e 80 00       	push   $0x801eac
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 e4 12 00 00       	call   801383 <sget>
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
  8000b3:	68 ba 1e 80 00       	push   $0x801eba
  8000b8:	e8 97 12 00 00       	call   801354 <smalloc>
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
  800112:	68 c9 1e 80 00       	push   $0x801ec9
  800117:	e8 45 04 00 00       	call   800561 <cprintf>
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
  800166:	e8 ef 15 00 00       	call   80175a <sys_get_virtual_time>
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
  8002f6:	68 e5 1e 80 00       	push   $0x801ee5
  8002fb:	e8 61 02 00 00       	call   800561 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 e7 1e 80 00       	push   $0x801ee7
  80031d:	e8 3f 02 00 00       	call   800561 <cprintf>
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
  800346:	68 ec 1e 80 00       	push   $0x801eec
  80034b:	e8 11 02 00 00       	call   800561 <cprintf>
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
  80035c:	e8 ad 13 00 00       	call   80170e <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 02             	shl    $0x2,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	c1 e0 02             	shl    $0x2,%eax
  800375:	01 d0                	add    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 04 30 80 00       	mov    0x803004,%eax
  80038d:	8a 40 20             	mov    0x20(%eax),%al
  800390:	84 c0                	test   %al,%al
  800392:	74 0d                	je     8003a1 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800394:	a1 04 30 80 00       	mov    0x803004,%eax
  800399:	83 c0 20             	add    $0x20,%eax
  80039c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003a5:	7e 0a                	jle    8003b1 <libmain+0x5b>
		binaryname = argv[0];
  8003a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	ff 75 0c             	pushl  0xc(%ebp)
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	e8 79 fc ff ff       	call   800038 <_main>
  8003bf:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8003c2:	e8 cb 10 00 00       	call   801492 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003c7:	83 ec 0c             	sub    $0xc,%esp
  8003ca:	68 08 1f 80 00       	push   $0x801f08
  8003cf:	e8 8d 01 00 00       	call   800561 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8003dc:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8003e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8003e7:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	68 30 1f 80 00       	push   $0x801f30
  8003f7:	e8 65 01 00 00       	call   800561 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ff:	a1 04 30 80 00       	mov    0x803004,%eax
  800404:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80040a:	a1 04 30 80 00       	mov    0x803004,%eax
  80040f:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800415:	a1 04 30 80 00       	mov    0x803004,%eax
  80041a:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800420:	51                   	push   %ecx
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	68 58 1f 80 00       	push   $0x801f58
  800428:	e8 34 01 00 00       	call   800561 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800430:	a1 04 30 80 00       	mov    0x803004,%eax
  800435:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	50                   	push   %eax
  80043f:	68 b0 1f 80 00       	push   $0x801fb0
  800444:	e8 18 01 00 00       	call   800561 <cprintf>
  800449:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	68 08 1f 80 00       	push   $0x801f08
  800454:	e8 08 01 00 00       	call   800561 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80045c:	e8 4b 10 00 00       	call   8014ac <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800461:	e8 19 00 00 00       	call   80047f <exit>
}
  800466:	90                   	nop
  800467:	c9                   	leave  
  800468:	c3                   	ret    

00800469 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	6a 00                	push   $0x0
  800474:	e8 61 12 00 00       	call   8016da <sys_destroy_env>
  800479:	83 c4 10             	add    $0x10,%esp
}
  80047c:	90                   	nop
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <exit>:

void
exit(void)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800485:	e8 b6 12 00 00       	call   801740 <sys_exit_env>
}
  80048a:	90                   	nop
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	8d 48 01             	lea    0x1(%eax),%ecx
  80049b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049e:	89 0a                	mov    %ecx,(%edx)
  8004a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a3:	88 d1                	mov    %dl,%cl
  8004a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004b6:	75 2c                	jne    8004e4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004b8:	a0 08 30 80 00       	mov    0x803008,%al
  8004bd:	0f b6 c0             	movzbl %al,%eax
  8004c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c3:	8b 12                	mov    (%edx),%edx
  8004c5:	89 d1                	mov    %edx,%ecx
  8004c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ca:	83 c2 08             	add    $0x8,%edx
  8004cd:	83 ec 04             	sub    $0x4,%esp
  8004d0:	50                   	push   %eax
  8004d1:	51                   	push   %ecx
  8004d2:	52                   	push   %edx
  8004d3:	e8 78 0f 00 00       	call   801450 <sys_cputs>
  8004d8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	8b 40 04             	mov    0x4(%eax),%eax
  8004ea:	8d 50 01             	lea    0x1(%eax),%edx
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f3:	90                   	nop
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    

008004f6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800506:	00 00 00 
	b.cnt = 0;
  800509:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800510:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800513:	ff 75 0c             	pushl  0xc(%ebp)
  800516:	ff 75 08             	pushl  0x8(%ebp)
  800519:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051f:	50                   	push   %eax
  800520:	68 8d 04 80 00       	push   $0x80048d
  800525:	e8 11 02 00 00       	call   80073b <vprintfmt>
  80052a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80052d:	a0 08 30 80 00       	mov    0x803008,%al
  800532:	0f b6 c0             	movzbl %al,%eax
  800535:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	50                   	push   %eax
  80053f:	52                   	push   %edx
  800540:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800546:	83 c0 08             	add    $0x8,%eax
  800549:	50                   	push   %eax
  80054a:	e8 01 0f 00 00       	call   801450 <sys_cputs>
  80054f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800552:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800559:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800567:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 73 ff ff ff       	call   8004f6 <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800589:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800594:	e8 f9 0e 00 00       	call   801492 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800599:	8d 45 0c             	lea    0xc(%ebp),%eax
  80059c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a8:	50                   	push   %eax
  8005a9:	e8 48 ff ff ff       	call   8004f6 <vcprintf>
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005b4:	e8 f3 0e 00 00       	call   8014ac <sys_unlock_cons>
	return cnt;
  8005b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005bc:	c9                   	leave  
  8005bd:	c3                   	ret    

008005be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005be:	55                   	push   %ebp
  8005bf:	89 e5                	mov    %esp,%ebp
  8005c1:	53                   	push   %ebx
  8005c2:	83 ec 14             	sub    $0x14,%esp
  8005c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005dc:	77 55                	ja     800633 <printnum+0x75>
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	72 05                	jb     8005e8 <printnum+0x2a>
  8005e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005e6:	77 4b                	ja     800633 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005eb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f6:	52                   	push   %edx
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8005fe:	e8 35 16 00 00       	call   801c38 <__udivdi3>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	ff 75 20             	pushl  0x20(%ebp)
  80060c:	53                   	push   %ebx
  80060d:	ff 75 18             	pushl  0x18(%ebp)
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	ff 75 08             	pushl  0x8(%ebp)
  800618:	e8 a1 ff ff ff       	call   8005be <printnum>
  80061d:	83 c4 20             	add    $0x20,%esp
  800620:	eb 1a                	jmp    80063c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	ff 75 20             	pushl  0x20(%ebp)
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800633:	ff 4d 1c             	decl   0x1c(%ebp)
  800636:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063a:	7f e6                	jg     800622 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80063f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064a:	53                   	push   %ebx
  80064b:	51                   	push   %ecx
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	e8 f5 16 00 00       	call   801d48 <__umoddi3>
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	05 f4 21 80 00       	add    $0x8021f4,%eax
  80065b:	8a 00                	mov    (%eax),%al
  80065d:	0f be c0             	movsbl %al,%eax
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	ff 75 0c             	pushl  0xc(%ebp)
  800666:	50                   	push   %eax
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
}
  80066f:	90                   	nop
  800670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800678:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80067c:	7e 1c                	jle    80069a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 50 08             	lea    0x8(%eax),%edx
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	89 10                	mov    %edx,(%eax)
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	83 e8 08             	sub    $0x8,%eax
  800693:	8b 50 04             	mov    0x4(%eax),%edx
  800696:	8b 00                	mov    (%eax),%eax
  800698:	eb 40                	jmp    8006da <getuint+0x65>
	else if (lflag)
  80069a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80069e:	74 1e                	je     8006be <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	8d 50 04             	lea    0x4(%eax),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	89 10                	mov    %edx,(%eax)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 e8 04             	sub    $0x4,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	eb 1c                	jmp    8006da <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	8d 50 04             	lea    0x4(%eax),%edx
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	89 10                	mov    %edx,(%eax)
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	83 e8 04             	sub    $0x4,%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006da:	5d                   	pop    %ebp
  8006db:	c3                   	ret    

008006dc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e3:	7e 1c                	jle    800701 <getint+0x25>
		return va_arg(*ap, long long);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 08             	lea    0x8(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 08             	sub    $0x8,%eax
  8006fa:	8b 50 04             	mov    0x4(%eax),%edx
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	eb 38                	jmp    800739 <getint+0x5d>
	else if (lflag)
  800701:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800705:	74 1a                	je     800721 <getint+0x45>
		return va_arg(*ap, long);
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	8d 50 04             	lea    0x4(%eax),%edx
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	89 10                	mov    %edx,(%eax)
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	83 e8 04             	sub    $0x4,%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	99                   	cltd   
  80071f:	eb 18                	jmp    800739 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 04             	lea    0x4(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 04             	sub    $0x4,%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	99                   	cltd   
}
  800739:	5d                   	pop    %ebp
  80073a:	c3                   	ret    

0080073b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	56                   	push   %esi
  80073f:	53                   	push   %ebx
  800740:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800743:	eb 17                	jmp    80075c <vprintfmt+0x21>
			if (ch == '\0')
  800745:	85 db                	test   %ebx,%ebx
  800747:	0f 84 c1 03 00 00    	je     800b0e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	53                   	push   %ebx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075c:	8b 45 10             	mov    0x10(%ebp),%eax
  80075f:	8d 50 01             	lea    0x1(%eax),%edx
  800762:	89 55 10             	mov    %edx,0x10(%ebp)
  800765:	8a 00                	mov    (%eax),%al
  800767:	0f b6 d8             	movzbl %al,%ebx
  80076a:	83 fb 25             	cmp    $0x25,%ebx
  80076d:	75 d6                	jne    800745 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80076f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800773:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800781:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800788:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078f:	8b 45 10             	mov    0x10(%ebp),%eax
  800792:	8d 50 01             	lea    0x1(%eax),%edx
  800795:	89 55 10             	mov    %edx,0x10(%ebp)
  800798:	8a 00                	mov    (%eax),%al
  80079a:	0f b6 d8             	movzbl %al,%ebx
  80079d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a0:	83 f8 5b             	cmp    $0x5b,%eax
  8007a3:	0f 87 3d 03 00 00    	ja     800ae6 <vprintfmt+0x3ab>
  8007a9:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  8007b0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007b6:	eb d7                	jmp    80078f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007bc:	eb d1                	jmp    80078f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 02             	shl    $0x2,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d8                	add    %ebx,%eax
  8007d3:	83 e8 30             	sub    $0x30,%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	8a 00                	mov    (%eax),%al
  8007de:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e4:	7e 3e                	jle    800824 <vprintfmt+0xe9>
  8007e6:	83 fb 39             	cmp    $0x39,%ebx
  8007e9:	7f 39                	jg     800824 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007eb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ee:	eb d5                	jmp    8007c5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	83 c0 04             	add    $0x4,%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800804:	eb 1f                	jmp    800825 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080a:	79 83                	jns    80078f <vprintfmt+0x54>
				width = 0;
  80080c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800813:	e9 77 ff ff ff       	jmp    80078f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800818:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80081f:	e9 6b ff ff ff       	jmp    80078f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800824:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800825:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800829:	0f 89 60 ff ff ff    	jns    80078f <vprintfmt+0x54>
				width = precision, precision = -1;
  80082f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800835:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80083c:	e9 4e ff ff ff       	jmp    80078f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800841:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800844:	e9 46 ff ff ff       	jmp    80078f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 c0 04             	add    $0x4,%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
			break;
  800869:	e9 9b 02 00 00       	jmp    800b09 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	83 c0 04             	add    $0x4,%eax
  800874:	89 45 14             	mov    %eax,0x14(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80087f:	85 db                	test   %ebx,%ebx
  800881:	79 02                	jns    800885 <vprintfmt+0x14a>
				err = -err;
  800883:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800885:	83 fb 64             	cmp    $0x64,%ebx
  800888:	7f 0b                	jg     800895 <vprintfmt+0x15a>
  80088a:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  800891:	85 f6                	test   %esi,%esi
  800893:	75 19                	jne    8008ae <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800895:	53                   	push   %ebx
  800896:	68 05 22 80 00       	push   $0x802205
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 08             	pushl  0x8(%ebp)
  8008a1:	e8 70 02 00 00       	call   800b16 <printfmt>
  8008a6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a9:	e9 5b 02 00 00       	jmp    800b09 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ae:	56                   	push   %esi
  8008af:	68 0e 22 80 00       	push   $0x80220e
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	ff 75 08             	pushl  0x8(%ebp)
  8008ba:	e8 57 02 00 00       	call   800b16 <printfmt>
  8008bf:	83 c4 10             	add    $0x10,%esp
			break;
  8008c2:	e9 42 02 00 00       	jmp    800b09 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	83 c0 04             	add    $0x4,%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 e8 04             	sub    $0x4,%eax
  8008d6:	8b 30                	mov    (%eax),%esi
  8008d8:	85 f6                	test   %esi,%esi
  8008da:	75 05                	jne    8008e1 <vprintfmt+0x1a6>
				p = "(null)";
  8008dc:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  8008e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e5:	7e 6d                	jle    800954 <vprintfmt+0x219>
  8008e7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008eb:	74 67                	je     800954 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	50                   	push   %eax
  8008f4:	56                   	push   %esi
  8008f5:	e8 1e 03 00 00       	call   800c18 <strnlen>
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800900:	eb 16                	jmp    800918 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800902:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	50                   	push   %eax
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091c:	7f e4                	jg     800902 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091e:	eb 34                	jmp    800954 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800920:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800924:	74 1c                	je     800942 <vprintfmt+0x207>
  800926:	83 fb 1f             	cmp    $0x1f,%ebx
  800929:	7e 05                	jle    800930 <vprintfmt+0x1f5>
  80092b:	83 fb 7e             	cmp    $0x7e,%ebx
  80092e:	7e 12                	jle    800942 <vprintfmt+0x207>
					putch('?', putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	6a 3f                	push   $0x3f
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	ff d0                	call   *%eax
  80093d:	83 c4 10             	add    $0x10,%esp
  800940:	eb 0f                	jmp    800951 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	53                   	push   %ebx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	89 f0                	mov    %esi,%eax
  800956:	8d 70 01             	lea    0x1(%eax),%esi
  800959:	8a 00                	mov    (%eax),%al
  80095b:	0f be d8             	movsbl %al,%ebx
  80095e:	85 db                	test   %ebx,%ebx
  800960:	74 24                	je     800986 <vprintfmt+0x24b>
  800962:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800966:	78 b8                	js     800920 <vprintfmt+0x1e5>
  800968:	ff 4d e0             	decl   -0x20(%ebp)
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	79 af                	jns    800920 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800971:	eb 13                	jmp    800986 <vprintfmt+0x24b>
				putch(' ', putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	6a 20                	push   $0x20
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800983:	ff 4d e4             	decl   -0x1c(%ebp)
  800986:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098a:	7f e7                	jg     800973 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80098c:	e9 78 01 00 00       	jmp    800b09 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 e8             	pushl  -0x18(%ebp)
  800997:	8d 45 14             	lea    0x14(%ebp),%eax
  80099a:	50                   	push   %eax
  80099b:	e8 3c fd ff ff       	call   8006dc <getint>
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009af:	85 d2                	test   %edx,%edx
  8009b1:	79 23                	jns    8009d6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 0c             	pushl  0xc(%ebp)
  8009b9:	6a 2d                	push   $0x2d
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	ff d0                	call   *%eax
  8009c0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c9:	f7 d8                	neg    %eax
  8009cb:	83 d2 00             	adc    $0x0,%edx
  8009ce:	f7 da                	neg    %edx
  8009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009dd:	e9 bc 00 00 00       	jmp    800a9e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009eb:	50                   	push   %eax
  8009ec:	e8 84 fc ff ff       	call   800675 <getuint>
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 98 00 00 00       	jmp    800a9e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	6a 58                	push   $0x58
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			break;
  800a36:	e9 ce 00 00 00       	jmp    800b09 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 30                	push   $0x30
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 78                	push   $0x78
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	83 c0 04             	add    $0x4,%eax
  800a61:	89 45 14             	mov    %eax,0x14(%ebp)
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 e8 04             	sub    $0x4,%eax
  800a6a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a76:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a7d:	eb 1f                	jmp    800a9e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 e8             	pushl  -0x18(%ebp)
  800a85:	8d 45 14             	lea    0x14(%ebp),%eax
  800a88:	50                   	push   %eax
  800a89:	e8 e7 fb ff ff       	call   800675 <getuint>
  800a8e:	83 c4 10             	add    $0x10,%esp
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a9e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	52                   	push   %edx
  800aa9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aac:	50                   	push   %eax
  800aad:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	ff 75 08             	pushl  0x8(%ebp)
  800ab9:	e8 00 fb ff ff       	call   8005be <printnum>
  800abe:	83 c4 20             	add    $0x20,%esp
			break;
  800ac1:	eb 46                	jmp    800b09 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	53                   	push   %ebx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			break;
  800ad2:	eb 35                	jmp    800b09 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ad4:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800adb:	eb 2c                	jmp    800b09 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800add:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800ae4:	eb 23                	jmp    800b09 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	6a 25                	push   $0x25
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af6:	ff 4d 10             	decl   0x10(%ebp)
  800af9:	eb 03                	jmp    800afe <vprintfmt+0x3c3>
  800afb:	ff 4d 10             	decl   0x10(%ebp)
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	48                   	dec    %eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	3c 25                	cmp    $0x25,%al
  800b06:	75 f3                	jne    800afb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b08:	90                   	nop
		}
	}
  800b09:	e9 35 fc ff ff       	jmp    800743 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b25:	8b 45 10             	mov    0x10(%ebp),%eax
  800b28:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2b:	50                   	push   %eax
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 04 fc ff ff       	call   80073b <vprintfmt>
  800b37:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b3a:	90                   	nop
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 40 08             	mov    0x8(%eax),%eax
  800b46:	8d 50 01             	lea    0x1(%eax),%edx
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 10                	mov    (%eax),%edx
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	8b 40 04             	mov    0x4(%eax),%eax
  800b5a:	39 c2                	cmp    %eax,%edx
  800b5c:	73 12                	jae    800b70 <sprintputch+0x33>
		*b->buf++ = ch;
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 48 01             	lea    0x1(%eax),%ecx
  800b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b69:	89 0a                	mov    %ecx,(%edx)
  800b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6e:	88 10                	mov    %dl,(%eax)
}
  800b70:	90                   	nop
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b98:	74 06                	je     800ba0 <vsnprintf+0x2d>
  800b9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9e:	7f 07                	jg     800ba7 <vsnprintf+0x34>
		return -E_INVAL;
  800ba0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba5:	eb 20                	jmp    800bc7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba7:	ff 75 14             	pushl  0x14(%ebp)
  800baa:	ff 75 10             	pushl  0x10(%ebp)
  800bad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb0:	50                   	push   %eax
  800bb1:	68 3d 0b 80 00       	push   $0x800b3d
  800bb6:	e8 80 fb ff ff       	call   80073b <vprintfmt>
  800bbb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcf:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd2:	83 c0 04             	add    $0x4,%eax
  800bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bde:	50                   	push   %eax
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	ff 75 08             	pushl  0x8(%ebp)
  800be5:	e8 89 ff ff ff       	call   800b73 <vsnprintf>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c02:	eb 06                	jmp    800c0a <strlen+0x15>
		n++;
  800c04:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c07:	ff 45 08             	incl   0x8(%ebp)
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	84 c0                	test   %al,%al
  800c11:	75 f1                	jne    800c04 <strlen+0xf>
		n++;
	return n;
  800c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c25:	eb 09                	jmp    800c30 <strnlen+0x18>
		n++;
  800c27:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2a:	ff 45 08             	incl   0x8(%ebp)
  800c2d:	ff 4d 0c             	decl   0xc(%ebp)
  800c30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c34:	74 09                	je     800c3f <strnlen+0x27>
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	84 c0                	test   %al,%al
  800c3d:	75 e8                	jne    800c27 <strnlen+0xf>
		n++;
	return n;
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c50:	90                   	nop
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8d 50 01             	lea    0x1(%eax),%edx
  800c57:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c60:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c63:	8a 12                	mov    (%edx),%dl
  800c65:	88 10                	mov    %dl,(%eax)
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	84 c0                	test   %al,%al
  800c6b:	75 e4                	jne    800c51 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c85:	eb 1f                	jmp    800ca6 <strncpy+0x34>
		*dst++ = *src;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8a 12                	mov    (%edx),%dl
  800c95:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	84 c0                	test   %al,%al
  800c9e:	74 03                	je     800ca3 <strncpy+0x31>
			src++;
  800ca0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca3:	ff 45 fc             	incl   -0x4(%ebp)
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cac:	72 d9                	jb     800c87 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc3:	74 30                	je     800cf5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc5:	eb 16                	jmp    800cdd <strlcpy+0x2a>
			*dst++ = *src++;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdd:	ff 4d 10             	decl   0x10(%ebp)
  800ce0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce4:	74 09                	je     800cef <strlcpy+0x3c>
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	84 c0                	test   %al,%al
  800ced:	75 d8                	jne    800cc7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfb:	29 c2                	sub    %eax,%edx
  800cfd:	89 d0                	mov    %edx,%eax
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d04:	eb 06                	jmp    800d0c <strcmp+0xb>
		p++, q++;
  800d06:	ff 45 08             	incl   0x8(%ebp)
  800d09:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	84 c0                	test   %al,%al
  800d13:	74 0e                	je     800d23 <strcmp+0x22>
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 10                	mov    (%eax),%dl
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	38 c2                	cmp    %al,%dl
  800d21:	74 e3                	je     800d06 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3c:	eb 09                	jmp    800d47 <strncmp+0xe>
		n--, p++, q++;
  800d3e:	ff 4d 10             	decl   0x10(%ebp)
  800d41:	ff 45 08             	incl   0x8(%ebp)
  800d44:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 17                	je     800d64 <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	74 0e                	je     800d64 <strncmp+0x2b>
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 10                	mov    (%eax),%dl
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	38 c2                	cmp    %al,%dl
  800d62:	74 da                	je     800d3e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d68:	75 07                	jne    800d71 <strncmp+0x38>
		return 0;
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6f:	eb 14                	jmp    800d85 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	0f b6 d0             	movzbl %al,%edx
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 c0             	movzbl %al,%eax
  800d81:	29 c2                	sub    %eax,%edx
  800d83:	89 d0                	mov    %edx,%eax
}
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d93:	eb 12                	jmp    800da7 <strchr+0x20>
		if (*s == c)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9d:	75 05                	jne    800da4 <strchr+0x1d>
			return (char *) s;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	eb 11                	jmp    800db5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da4:	ff 45 08             	incl   0x8(%ebp)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	75 e5                	jne    800d95 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 04             	sub    $0x4,%esp
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc3:	eb 0d                	jmp    800dd2 <strfind+0x1b>
		if (*s == c)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcd:	74 0e                	je     800ddd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcf:	ff 45 08             	incl   0x8(%ebp)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	84 c0                	test   %al,%al
  800dd9:	75 ea                	jne    800dc5 <strfind+0xe>
  800ddb:	eb 01                	jmp    800dde <strfind+0x27>
		if (*s == c)
			break;
  800ddd:	90                   	nop
	return (char *) s;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df5:	eb 0e                	jmp    800e05 <memset+0x22>
		*p++ = c;
  800df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfa:	8d 50 01             	lea    0x1(%eax),%edx
  800dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e03:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e05:	ff 4d f8             	decl   -0x8(%ebp)
  800e08:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0c:	79 e9                	jns    800df7 <memset+0x14>
		*p++ = c;

	return v;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e25:	eb 16                	jmp    800e3d <memcpy+0x2a>
		*d++ = *s++;
  800e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2a:	8d 50 01             	lea    0x1(%eax),%edx
  800e2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e36:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e39:	8a 12                	mov    (%edx),%dl
  800e3b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e43:	89 55 10             	mov    %edx,0x10(%ebp)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	75 dd                	jne    800e27 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	73 50                	jae    800eb9 <memmove+0x6a>
  800e69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	01 d0                	add    %edx,%eax
  800e71:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e74:	76 43                	jbe    800eb9 <memmove+0x6a>
		s += n;
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e82:	eb 10                	jmp    800e94 <memmove+0x45>
			*--d = *--s;
  800e84:	ff 4d f8             	decl   -0x8(%ebp)
  800e87:	ff 4d fc             	decl   -0x4(%ebp)
  800e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8d:	8a 10                	mov    (%eax),%dl
  800e8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e92:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	75 e3                	jne    800e84 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ea1:	eb 23                	jmp    800ec6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea6:	8d 50 01             	lea    0x1(%eax),%edx
  800ea9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eaf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb5:	8a 12                	mov    (%edx),%dl
  800eb7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	75 dd                	jne    800ea3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edd:	eb 2a                	jmp    800f09 <memcmp+0x3e>
		if (*s1 != *s2)
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 16                	je     800f03 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
  800f01:	eb 18                	jmp    800f1b <memcmp+0x50>
		s1++, s2++;
  800f03:	ff 45 fc             	incl   -0x4(%ebp)
  800f06:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	75 c9                	jne    800edf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1b:	c9                   	leave  
  800f1c:	c3                   	ret    

00800f1d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	8b 45 10             	mov    0x10(%ebp),%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2e:	eb 15                	jmp    800f45 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f b6 d0             	movzbl %al,%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	0f b6 c0             	movzbl %al,%eax
  800f3e:	39 c2                	cmp    %eax,%edx
  800f40:	74 0d                	je     800f4f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f42:	ff 45 08             	incl   0x8(%ebp)
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f4b:	72 e3                	jb     800f30 <memfind+0x13>
  800f4d:	eb 01                	jmp    800f50 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4f:	90                   	nop
	return (void *) s;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f69:	eb 03                	jmp    800f6e <strtol+0x19>
		s++;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 20                	cmp    $0x20,%al
  800f75:	74 f4                	je     800f6b <strtol+0x16>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 09                	cmp    $0x9,%al
  800f7e:	74 eb                	je     800f6b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 2b                	cmp    $0x2b,%al
  800f87:	75 05                	jne    800f8e <strtol+0x39>
		s++;
  800f89:	ff 45 08             	incl   0x8(%ebp)
  800f8c:	eb 13                	jmp    800fa1 <strtol+0x4c>
	else if (*s == '-')
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	3c 2d                	cmp    $0x2d,%al
  800f95:	75 0a                	jne    800fa1 <strtol+0x4c>
		s++, neg = 1;
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa5:	74 06                	je     800fad <strtol+0x58>
  800fa7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fab:	75 20                	jne    800fcd <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 30                	cmp    $0x30,%al
  800fb4:	75 17                	jne    800fcd <strtol+0x78>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	40                   	inc    %eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 78                	cmp    $0x78,%al
  800fbe:	75 0d                	jne    800fcd <strtol+0x78>
		s += 2, base = 16;
  800fc0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fcb:	eb 28                	jmp    800ff5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd1:	75 15                	jne    800fe8 <strtol+0x93>
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 30                	cmp    $0x30,%al
  800fda:	75 0c                	jne    800fe8 <strtol+0x93>
		s++, base = 8;
  800fdc:	ff 45 08             	incl   0x8(%ebp)
  800fdf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe6:	eb 0d                	jmp    800ff5 <strtol+0xa0>
	else if (base == 0)
  800fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fec:	75 07                	jne    800ff5 <strtol+0xa0>
		base = 10;
  800fee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2f                	cmp    $0x2f,%al
  800ffc:	7e 19                	jle    801017 <strtol+0xc2>
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	3c 39                	cmp    $0x39,%al
  801005:	7f 10                	jg     801017 <strtol+0xc2>
			dig = *s - '0';
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	0f be c0             	movsbl %al,%eax
  80100f:	83 e8 30             	sub    $0x30,%eax
  801012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801015:	eb 42                	jmp    801059 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 60                	cmp    $0x60,%al
  80101e:	7e 19                	jle    801039 <strtol+0xe4>
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3c 7a                	cmp    $0x7a,%al
  801027:	7f 10                	jg     801039 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	0f be c0             	movsbl %al,%eax
  801031:	83 e8 57             	sub    $0x57,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 20                	jmp    801059 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 40                	cmp    $0x40,%al
  801040:	7e 39                	jle    80107b <strtol+0x126>
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 5a                	cmp    $0x5a,%al
  801049:	7f 30                	jg     80107b <strtol+0x126>
			dig = *s - 'A' + 10;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be c0             	movsbl %al,%eax
  801053:	83 e8 37             	sub    $0x37,%eax
  801056:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105f:	7d 19                	jge    80107a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801061:	ff 45 08             	incl   0x8(%ebp)
  801064:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801067:	0f af 45 10          	imul   0x10(%ebp),%eax
  80106b:	89 c2                	mov    %eax,%edx
  80106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801070:	01 d0                	add    %edx,%eax
  801072:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801075:	e9 7b ff ff ff       	jmp    800ff5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80107a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80107b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107f:	74 08                	je     801089 <strtol+0x134>
		*endptr = (char *) s;
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801089:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108d:	74 07                	je     801096 <strtol+0x141>
  80108f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801092:	f7 d8                	neg    %eax
  801094:	eb 03                	jmp    801099 <strtol+0x144>
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <ltostr>:

void
ltostr(long value, char *str)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b3:	79 13                	jns    8010c8 <ltostr+0x2d>
	{
		neg = 1;
  8010b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010d0:	99                   	cltd   
  8010d1:	f7 f9                	idiv   %ecx
  8010d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	89 c2                	mov    %eax,%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 d0                	add    %edx,%eax
  8010e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e9:	83 c2 30             	add    $0x30,%edx
  8010ec:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f6:	f7 e9                	imul   %ecx
  8010f8:	c1 fa 02             	sar    $0x2,%edx
  8010fb:	89 c8                	mov    %ecx,%eax
  8010fd:	c1 f8 1f             	sar    $0x1f,%eax
  801100:	29 c2                	sub    %eax,%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110b:	75 bb                	jne    8010c8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80110d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801114:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801117:	48                   	dec    %eax
  801118:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80111b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80111f:	74 3d                	je     80115e <ltostr+0xc3>
		start = 1 ;
  801121:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801128:	eb 34                	jmp    80115e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80112a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 d0                	add    %edx,%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 c2                	add    %eax,%edx
  80113f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	01 c8                	add    %ecx,%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80114b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	01 c2                	add    %eax,%edx
  801153:	8a 45 eb             	mov    -0x15(%ebp),%al
  801156:	88 02                	mov    %al,(%edx)
		start++ ;
  801158:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80115b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801161:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801164:	7c c4                	jl     80112a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801166:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	01 d0                	add    %edx,%eax
  80116e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801171:	90                   	nop
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80117a:	ff 75 08             	pushl  0x8(%ebp)
  80117d:	e8 73 fa ff ff       	call   800bf5 <strlen>
  801182:	83 c4 04             	add    $0x4,%esp
  801185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801188:	ff 75 0c             	pushl  0xc(%ebp)
  80118b:	e8 65 fa ff ff       	call   800bf5 <strlen>
  801190:	83 c4 04             	add    $0x4,%esp
  801193:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80119d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a4:	eb 17                	jmp    8011bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	01 c2                	add    %eax,%edx
  8011ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	01 c8                	add    %ecx,%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011ba:	ff 45 fc             	incl   -0x4(%ebp)
  8011bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011c3:	7c e1                	jl     8011a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011d3:	eb 1f                	jmp    8011f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d8:	8d 50 01             	lea    0x1(%eax),%edx
  8011db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011de:	89 c2                	mov    %eax,%edx
  8011e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e3:	01 c2                	add    %eax,%edx
  8011e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	01 c8                	add    %ecx,%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011f1:	ff 45 f8             	incl   -0x8(%ebp)
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fa:	7c d9                	jl     8011d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	01 d0                	add    %edx,%eax
  801204:	c6 00 00             	movb   $0x0,(%eax)
}
  801207:	90                   	nop
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80120d:	8b 45 14             	mov    0x14(%ebp),%eax
  801210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801216:	8b 45 14             	mov    0x14(%ebp),%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	01 d0                	add    %edx,%eax
  801227:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122d:	eb 0c                	jmp    80123b <strsplit+0x31>
			*string++ = 0;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8d 50 01             	lea    0x1(%eax),%edx
  801235:	89 55 08             	mov    %edx,0x8(%ebp)
  801238:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 18                	je     80125c <strsplit+0x52>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	0f be c0             	movsbl %al,%eax
  80124c:	50                   	push   %eax
  80124d:	ff 75 0c             	pushl  0xc(%ebp)
  801250:	e8 32 fb ff ff       	call   800d87 <strchr>
  801255:	83 c4 08             	add    $0x8,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	75 d3                	jne    80122f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	84 c0                	test   %al,%al
  801263:	74 5a                	je     8012bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801265:	8b 45 14             	mov    0x14(%ebp),%eax
  801268:	8b 00                	mov    (%eax),%eax
  80126a:	83 f8 0f             	cmp    $0xf,%eax
  80126d:	75 07                	jne    801276 <strsplit+0x6c>
		{
			return 0;
  80126f:	b8 00 00 00 00       	mov    $0x0,%eax
  801274:	eb 66                	jmp    8012dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801276:	8b 45 14             	mov    0x14(%ebp),%eax
  801279:	8b 00                	mov    (%eax),%eax
  80127b:	8d 48 01             	lea    0x1(%eax),%ecx
  80127e:	8b 55 14             	mov    0x14(%ebp),%edx
  801281:	89 0a                	mov    %ecx,(%edx)
  801283:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 c2                	add    %eax,%edx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801294:	eb 03                	jmp    801299 <strsplit+0x8f>
			string++;
  801296:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	84 c0                	test   %al,%al
  8012a0:	74 8b                	je     80122d <strsplit+0x23>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	0f be c0             	movsbl %al,%eax
  8012aa:	50                   	push   %eax
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	e8 d4 fa ff ff       	call   800d87 <strchr>
  8012b3:	83 c4 08             	add    $0x8,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	74 dc                	je     801296 <strsplit+0x8c>
			string++;
	}
  8012ba:	e9 6e ff ff ff       	jmp    80122d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c3:	8b 00                	mov    (%eax),%eax
  8012c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	01 d0                	add    %edx,%eax
  8012d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 88 23 80 00       	push   $0x802388
  8012ec:	68 3f 01 00 00       	push   $0x13f
  8012f1:	68 aa 23 80 00       	push   $0x8023aa
  8012f6:	e8 53 07 00 00       	call   801a4e <_panic>

008012fb <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801301:	83 ec 0c             	sub    $0xc,%esp
  801304:	ff 75 08             	pushl  0x8(%ebp)
  801307:	e8 ef 06 00 00       	call   8019fb <sys_sbrk>
  80130c:	83 c4 10             	add    $0x10,%esp
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801317:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131b:	75 07                	jne    801324 <malloc+0x13>
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
  801322:	eb 14                	jmp    801338 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801324:	83 ec 04             	sub    $0x4,%esp
  801327:	68 b8 23 80 00       	push   $0x8023b8
  80132c:	6a 1b                	push   $0x1b
  80132e:	68 dd 23 80 00       	push   $0x8023dd
  801333:	e8 16 07 00 00       	call   801a4e <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801340:	83 ec 04             	sub    $0x4,%esp
  801343:	68 ec 23 80 00       	push   $0x8023ec
  801348:	6a 29                	push   $0x29
  80134a:	68 dd 23 80 00       	push   $0x8023dd
  80134f:	e8 fa 06 00 00       	call   801a4e <_panic>

00801354 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 18             	sub    $0x18,%esp
  80135a:	8b 45 10             	mov    0x10(%ebp),%eax
  80135d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801360:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801364:	75 07                	jne    80136d <smalloc+0x19>
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	eb 14                	jmp    801381 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 10 24 80 00       	push   $0x802410
  801375:	6a 38                	push   $0x38
  801377:	68 dd 23 80 00       	push   $0x8023dd
  80137c:	e8 cd 06 00 00       	call   801a4e <_panic>
	return NULL;
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	68 38 24 80 00       	push   $0x802438
  801391:	6a 43                	push   $0x43
  801393:	68 dd 23 80 00       	push   $0x8023dd
  801398:	e8 b1 06 00 00       	call   801a4e <_panic>

0080139d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 5c 24 80 00       	push   $0x80245c
  8013ab:	6a 5b                	push   $0x5b
  8013ad:	68 dd 23 80 00       	push   $0x8023dd
  8013b2:	e8 97 06 00 00       	call   801a4e <_panic>

008013b7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	68 80 24 80 00       	push   $0x802480
  8013c5:	6a 72                	push   $0x72
  8013c7:	68 dd 23 80 00       	push   $0x8023dd
  8013cc:	e8 7d 06 00 00       	call   801a4e <_panic>

008013d1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	68 a6 24 80 00       	push   $0x8024a6
  8013df:	6a 7e                	push   $0x7e
  8013e1:	68 dd 23 80 00       	push   $0x8023dd
  8013e6:	e8 63 06 00 00       	call   801a4e <_panic>

008013eb <shrink>:

}
void shrink(uint32 newSize)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	68 a6 24 80 00       	push   $0x8024a6
  8013f9:	68 83 00 00 00       	push   $0x83
  8013fe:	68 dd 23 80 00       	push   $0x8023dd
  801403:	e8 46 06 00 00       	call   801a4e <_panic>

00801408 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	68 a6 24 80 00       	push   $0x8024a6
  801416:	68 88 00 00 00       	push   $0x88
  80141b:	68 dd 23 80 00       	push   $0x8023dd
  801420:	e8 29 06 00 00       	call   801a4e <_panic>

00801425 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	57                   	push   %edi
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8b 55 0c             	mov    0xc(%ebp),%edx
  801434:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801437:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80143a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80143d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801440:	cd 30                	int    $0x30
  801442:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801445:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	5b                   	pop    %ebx
  80144c:	5e                   	pop    %esi
  80144d:	5f                   	pop    %edi
  80144e:	5d                   	pop    %ebp
  80144f:	c3                   	ret    

00801450 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80145c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	52                   	push   %edx
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	50                   	push   %eax
  80146c:	6a 00                	push   $0x0
  80146e:	e8 b2 ff ff ff       	call   801425 <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	90                   	nop
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_cgetc>:

int
sys_cgetc(void)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 02                	push   $0x2
  801488:	e8 98 ff ff ff       	call   801425 <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 03                	push   $0x3
  8014a1:	e8 7f ff ff ff       	call   801425 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	90                   	nop
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 04                	push   $0x4
  8014bb:	e8 65 ff ff ff       	call   801425 <syscall>
  8014c0:	83 c4 18             	add    $0x18,%esp
}
  8014c3:	90                   	nop
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	52                   	push   %edx
  8014d6:	50                   	push   %eax
  8014d7:	6a 08                	push   $0x8
  8014d9:	e8 47 ff ff ff       	call   801425 <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	56                   	push   %esi
  8014e7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8014eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
  8014f9:	51                   	push   %ecx
  8014fa:	52                   	push   %edx
  8014fb:	50                   	push   %eax
  8014fc:	6a 09                	push   $0x9
  8014fe:	e8 22 ff ff ff       	call   801425 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5d                   	pop    %ebp
  80150c:	c3                   	ret    

0080150d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	6a 0a                	push   $0xa
  801520:	e8 00 ff ff ff       	call   801425 <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	6a 0b                	push   $0xb
  80153b:	e8 e5 fe ff ff       	call   801425 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 0c                	push   $0xc
  801554:	e8 cc fe ff ff       	call   801425 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 0d                	push   $0xd
  80156d:	e8 b3 fe ff ff       	call   801425 <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 0e                	push   $0xe
  801586:	e8 9a fe ff ff       	call   801425 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 0f                	push   $0xf
  80159f:	e8 81 fe ff ff       	call   801425 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	6a 10                	push   $0x10
  8015b9:	e8 67 fe ff ff       	call   801425 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 11                	push   $0x11
  8015d2:	e8 4e fe ff ff       	call   801425 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_cputc>:

void
sys_cputc(const char c)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	50                   	push   %eax
  8015f6:	6a 01                	push   $0x1
  8015f8:	e8 28 fe ff ff       	call   801425 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	90                   	nop
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 14                	push   $0x14
  801612:	e8 0e fe ff ff       	call   801425 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801629:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80162c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	6a 00                	push   $0x0
  801635:	51                   	push   %ecx
  801636:	52                   	push   %edx
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	50                   	push   %eax
  80163b:	6a 15                	push   $0x15
  80163d:	e8 e3 fd ff ff       	call   801425 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	6a 16                	push   $0x16
  80165a:	e8 c6 fd ff ff       	call   801425 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801667:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	51                   	push   %ecx
  801675:	52                   	push   %edx
  801676:	50                   	push   %eax
  801677:	6a 17                	push   $0x17
  801679:	e8 a7 fd ff ff       	call   801425 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 18                	push   $0x18
  801696:	e8 8a fd ff ff       	call   801425 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	ff 75 14             	pushl  0x14(%ebp)
  8016ab:	ff 75 10             	pushl  0x10(%ebp)
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	50                   	push   %eax
  8016b2:	6a 19                	push   $0x19
  8016b4:	e8 6c fd ff ff       	call   801425 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	50                   	push   %eax
  8016cd:	6a 1a                	push   $0x1a
  8016cf:	e8 51 fd ff ff       	call   801425 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	90                   	nop
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	50                   	push   %eax
  8016e9:	6a 1b                	push   $0x1b
  8016eb:	e8 35 fd ff ff       	call   801425 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 05                	push   $0x5
  801704:	e8 1c fd ff ff       	call   801425 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 06                	push   $0x6
  80171d:	e8 03 fd ff ff       	call   801425 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 07                	push   $0x7
  801736:	e8 ea fc ff ff       	call   801425 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_exit_env>:


void sys_exit_env(void)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 1c                	push   $0x1c
  80174f:	e8 d1 fc ff ff       	call   801425 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	90                   	nop
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801760:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801763:	8d 50 04             	lea    0x4(%eax),%edx
  801766:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 1d                	push   $0x1d
  801773:	e8 ad fc ff ff       	call   801425 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
	return result;
  80177b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801781:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801784:	89 01                	mov    %eax,(%ecx)
  801786:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	c9                   	leave  
  80178d:	c2 04 00             	ret    $0x4

00801790 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	ff 75 10             	pushl  0x10(%ebp)
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	6a 13                	push   $0x13
  8017a2:	e8 7e fc ff ff       	call   801425 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017aa:	90                   	nop
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_rcr2>:
uint32 sys_rcr2()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 1e                	push   $0x1e
  8017bc:	e8 64 fc ff ff       	call   801425 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017d2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	50                   	push   %eax
  8017df:	6a 1f                	push   $0x1f
  8017e1:	e8 3f fc ff ff       	call   801425 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e9:	90                   	nop
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <rsttst>:
void rsttst()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 21                	push   $0x21
  8017fb:	e8 25 fc ff ff       	call   801425 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
	return ;
  801803:	90                   	nop
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 14             	mov    0x14(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801812:	8b 55 18             	mov    0x18(%ebp),%edx
  801815:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	ff 75 10             	pushl  0x10(%ebp)
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	6a 20                	push   $0x20
  801826:	e8 fa fb ff ff       	call   801425 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
	return ;
  80182e:	90                   	nop
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <chktst>:
void chktst(uint32 n)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	6a 22                	push   $0x22
  801841:	e8 df fb ff ff       	call   801425 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
	return ;
  801849:	90                   	nop
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <inctst>:

void inctst()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 23                	push   $0x23
  80185b:	e8 c5 fb ff ff       	call   801425 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return ;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <gettst>:
uint32 gettst()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 24                	push   $0x24
  801875:	e8 ab fb ff ff       	call   801425 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 25                	push   $0x25
  801891:	e8 8f fb ff ff       	call   801425 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
  801899:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80189c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018a0:	75 07                	jne    8018a9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a7:	eb 05                	jmp    8018ae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 25                	push   $0x25
  8018c2:	e8 5e fb ff ff       	call   801425 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
  8018ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018cd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018d1:	75 07                	jne    8018da <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d8:	eb 05                	jmp    8018df <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 25                	push   $0x25
  8018f3:	e8 2d fb ff ff       	call   801425 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
  8018fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018fe:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801902:	75 07                	jne    80190b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801904:	b8 01 00 00 00       	mov    $0x1,%eax
  801909:	eb 05                	jmp    801910 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 25                	push   $0x25
  801924:	e8 fc fa ff ff       	call   801425 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
  80192c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80192f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801933:	75 07                	jne    80193c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801935:	b8 01 00 00 00       	mov    $0x1,%eax
  80193a:	eb 05                	jmp    801941 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 26                	push   $0x26
  801953:	e8 cd fa ff ff       	call   801425 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
	return ;
  80195b:	90                   	nop
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801962:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801965:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	53                   	push   %ebx
  801971:	51                   	push   %ecx
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 27                	push   $0x27
  801976:	e8 aa fa ff ff       	call   801425 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	52                   	push   %edx
  801993:	50                   	push   %eax
  801994:	6a 28                	push   $0x28
  801996:	e8 8a fa ff ff       	call   801425 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	51                   	push   %ecx
  8019af:	ff 75 10             	pushl  0x10(%ebp)
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	6a 29                	push   $0x29
  8019b6:	e8 6a fa ff ff       	call   801425 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	ff 75 10             	pushl  0x10(%ebp)
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	6a 12                	push   $0x12
  8019d2:	e8 4e fa ff ff       	call   801425 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019da:	90                   	nop
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 2a                	push   $0x2a
  8019f0:	e8 30 fa ff ff       	call   801425 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	50                   	push   %eax
  801a0a:	6a 2b                	push   $0x2b
  801a0c:	e8 14 fa ff ff       	call   801425 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 2c                	push   $0x2c
  801a27:	e8 f9 f9 ff ff       	call   801425 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 2d                	push   $0x2d
  801a43:	e8 dd f9 ff ff       	call   801425 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a54:	8d 45 10             	lea    0x10(%ebp),%eax
  801a57:	83 c0 04             	add    $0x4,%eax
  801a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a5d:	a1 24 30 80 00       	mov    0x803024,%eax
  801a62:	85 c0                	test   %eax,%eax
  801a64:	74 16                	je     801a7c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a66:	a1 24 30 80 00       	mov    0x803024,%eax
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	50                   	push   %eax
  801a6f:	68 b8 24 80 00       	push   $0x8024b8
  801a74:	e8 e8 ea ff ff       	call   800561 <cprintf>
  801a79:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a7c:	a1 00 30 80 00       	mov    0x803000,%eax
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	50                   	push   %eax
  801a88:	68 bd 24 80 00       	push   $0x8024bd
  801a8d:	e8 cf ea ff ff       	call   800561 <cprintf>
  801a92:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a95:	8b 45 10             	mov    0x10(%ebp),%eax
  801a98:	83 ec 08             	sub    $0x8,%esp
  801a9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9e:	50                   	push   %eax
  801a9f:	e8 52 ea ff ff       	call   8004f6 <vcprintf>
  801aa4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801aa7:	83 ec 08             	sub    $0x8,%esp
  801aaa:	6a 00                	push   $0x0
  801aac:	68 d9 24 80 00       	push   $0x8024d9
  801ab1:	e8 40 ea ff ff       	call   8004f6 <vcprintf>
  801ab6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ab9:	e8 c1 e9 ff ff       	call   80047f <exit>

	// should not return here
	while (1) ;
  801abe:	eb fe                	jmp    801abe <_panic+0x70>

00801ac0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801ac6:	a1 04 30 80 00       	mov    0x803004,%eax
  801acb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	39 c2                	cmp    %eax,%edx
  801ad6:	74 14                	je     801aec <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	68 dc 24 80 00       	push   $0x8024dc
  801ae0:	6a 26                	push   $0x26
  801ae2:	68 28 25 80 00       	push   $0x802528
  801ae7:	e8 62 ff ff ff       	call   801a4e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801aec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801af3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801afa:	e9 c5 00 00 00       	jmp    801bc4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	8b 00                	mov    (%eax),%eax
  801b10:	85 c0                	test   %eax,%eax
  801b12:	75 08                	jne    801b1c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b14:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b17:	e9 a5 00 00 00       	jmp    801bc1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b2a:	eb 69                	jmp    801b95 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b2c:	a1 04 30 80 00       	mov    0x803004,%eax
  801b31:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801b37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b3a:	89 d0                	mov    %edx,%eax
  801b3c:	01 c0                	add    %eax,%eax
  801b3e:	01 d0                	add    %edx,%eax
  801b40:	c1 e0 03             	shl    $0x3,%eax
  801b43:	01 c8                	add    %ecx,%eax
  801b45:	8a 40 04             	mov    0x4(%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	75 46                	jne    801b92 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b4c:	a1 04 30 80 00       	mov    0x803004,%eax
  801b51:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801b57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b5a:	89 d0                	mov    %edx,%eax
  801b5c:	01 c0                	add    %eax,%eax
  801b5e:	01 d0                	add    %edx,%eax
  801b60:	c1 e0 03             	shl    $0x3,%eax
  801b63:	01 c8                	add    %ecx,%eax
  801b65:	8b 00                	mov    (%eax),%eax
  801b67:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b72:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b77:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	01 c8                	add    %ecx,%eax
  801b83:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b85:	39 c2                	cmp    %eax,%edx
  801b87:	75 09                	jne    801b92 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b89:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b90:	eb 15                	jmp    801ba7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b92:	ff 45 e8             	incl   -0x18(%ebp)
  801b95:	a1 04 30 80 00       	mov    0x803004,%eax
  801b9a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ba3:	39 c2                	cmp    %eax,%edx
  801ba5:	77 85                	ja     801b2c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ba7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bab:	75 14                	jne    801bc1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	68 34 25 80 00       	push   $0x802534
  801bb5:	6a 3a                	push   $0x3a
  801bb7:	68 28 25 80 00       	push   $0x802528
  801bbc:	e8 8d fe ff ff       	call   801a4e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bc1:	ff 45 f0             	incl   -0x10(%ebp)
  801bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bca:	0f 8c 2f ff ff ff    	jl     801aff <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bd7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bde:	eb 26                	jmp    801c06 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801be0:	a1 04 30 80 00       	mov    0x803004,%eax
  801be5:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801beb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bee:	89 d0                	mov    %edx,%eax
  801bf0:	01 c0                	add    %eax,%eax
  801bf2:	01 d0                	add    %edx,%eax
  801bf4:	c1 e0 03             	shl    $0x3,%eax
  801bf7:	01 c8                	add    %ecx,%eax
  801bf9:	8a 40 04             	mov    0x4(%eax),%al
  801bfc:	3c 01                	cmp    $0x1,%al
  801bfe:	75 03                	jne    801c03 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c00:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c03:	ff 45 e0             	incl   -0x20(%ebp)
  801c06:	a1 04 30 80 00       	mov    0x803004,%eax
  801c0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c14:	39 c2                	cmp    %eax,%edx
  801c16:	77 c8                	ja     801be0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c1e:	74 14                	je     801c34 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	68 88 25 80 00       	push   $0x802588
  801c28:	6a 44                	push   $0x44
  801c2a:	68 28 25 80 00       	push   $0x802528
  801c2f:	e8 1a fe ff ff       	call   801a4e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c34:	90                   	nop
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    
  801c37:	90                   	nop

00801c38 <__udivdi3>:
  801c38:	55                   	push   %ebp
  801c39:	57                   	push   %edi
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	83 ec 1c             	sub    $0x1c,%esp
  801c3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c4f:	89 ca                	mov    %ecx,%edx
  801c51:	89 f8                	mov    %edi,%eax
  801c53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c57:	85 f6                	test   %esi,%esi
  801c59:	75 2d                	jne    801c88 <__udivdi3+0x50>
  801c5b:	39 cf                	cmp    %ecx,%edi
  801c5d:	77 65                	ja     801cc4 <__udivdi3+0x8c>
  801c5f:	89 fd                	mov    %edi,%ebp
  801c61:	85 ff                	test   %edi,%edi
  801c63:	75 0b                	jne    801c70 <__udivdi3+0x38>
  801c65:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6a:	31 d2                	xor    %edx,%edx
  801c6c:	f7 f7                	div    %edi
  801c6e:	89 c5                	mov    %eax,%ebp
  801c70:	31 d2                	xor    %edx,%edx
  801c72:	89 c8                	mov    %ecx,%eax
  801c74:	f7 f5                	div    %ebp
  801c76:	89 c1                	mov    %eax,%ecx
  801c78:	89 d8                	mov    %ebx,%eax
  801c7a:	f7 f5                	div    %ebp
  801c7c:	89 cf                	mov    %ecx,%edi
  801c7e:	89 fa                	mov    %edi,%edx
  801c80:	83 c4 1c             	add    $0x1c,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    
  801c88:	39 ce                	cmp    %ecx,%esi
  801c8a:	77 28                	ja     801cb4 <__udivdi3+0x7c>
  801c8c:	0f bd fe             	bsr    %esi,%edi
  801c8f:	83 f7 1f             	xor    $0x1f,%edi
  801c92:	75 40                	jne    801cd4 <__udivdi3+0x9c>
  801c94:	39 ce                	cmp    %ecx,%esi
  801c96:	72 0a                	jb     801ca2 <__udivdi3+0x6a>
  801c98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c9c:	0f 87 9e 00 00 00    	ja     801d40 <__udivdi3+0x108>
  801ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca7:	89 fa                	mov    %edi,%edx
  801ca9:	83 c4 1c             	add    $0x1c,%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5f                   	pop    %edi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    
  801cb1:	8d 76 00             	lea    0x0(%esi),%esi
  801cb4:	31 ff                	xor    %edi,%edi
  801cb6:	31 c0                	xor    %eax,%eax
  801cb8:	89 fa                	mov    %edi,%edx
  801cba:	83 c4 1c             	add    $0x1c,%esp
  801cbd:	5b                   	pop    %ebx
  801cbe:	5e                   	pop    %esi
  801cbf:	5f                   	pop    %edi
  801cc0:	5d                   	pop    %ebp
  801cc1:	c3                   	ret    
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	f7 f7                	div    %edi
  801cc8:	31 ff                	xor    %edi,%edi
  801cca:	89 fa                	mov    %edi,%edx
  801ccc:	83 c4 1c             	add    $0x1c,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    
  801cd4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cd9:	89 eb                	mov    %ebp,%ebx
  801cdb:	29 fb                	sub    %edi,%ebx
  801cdd:	89 f9                	mov    %edi,%ecx
  801cdf:	d3 e6                	shl    %cl,%esi
  801ce1:	89 c5                	mov    %eax,%ebp
  801ce3:	88 d9                	mov    %bl,%cl
  801ce5:	d3 ed                	shr    %cl,%ebp
  801ce7:	89 e9                	mov    %ebp,%ecx
  801ce9:	09 f1                	or     %esi,%ecx
  801ceb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cef:	89 f9                	mov    %edi,%ecx
  801cf1:	d3 e0                	shl    %cl,%eax
  801cf3:	89 c5                	mov    %eax,%ebp
  801cf5:	89 d6                	mov    %edx,%esi
  801cf7:	88 d9                	mov    %bl,%cl
  801cf9:	d3 ee                	shr    %cl,%esi
  801cfb:	89 f9                	mov    %edi,%ecx
  801cfd:	d3 e2                	shl    %cl,%edx
  801cff:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d03:	88 d9                	mov    %bl,%cl
  801d05:	d3 e8                	shr    %cl,%eax
  801d07:	09 c2                	or     %eax,%edx
  801d09:	89 d0                	mov    %edx,%eax
  801d0b:	89 f2                	mov    %esi,%edx
  801d0d:	f7 74 24 0c          	divl   0xc(%esp)
  801d11:	89 d6                	mov    %edx,%esi
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	f7 e5                	mul    %ebp
  801d17:	39 d6                	cmp    %edx,%esi
  801d19:	72 19                	jb     801d34 <__udivdi3+0xfc>
  801d1b:	74 0b                	je     801d28 <__udivdi3+0xf0>
  801d1d:	89 d8                	mov    %ebx,%eax
  801d1f:	31 ff                	xor    %edi,%edi
  801d21:	e9 58 ff ff ff       	jmp    801c7e <__udivdi3+0x46>
  801d26:	66 90                	xchg   %ax,%ax
  801d28:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d2c:	89 f9                	mov    %edi,%ecx
  801d2e:	d3 e2                	shl    %cl,%edx
  801d30:	39 c2                	cmp    %eax,%edx
  801d32:	73 e9                	jae    801d1d <__udivdi3+0xe5>
  801d34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d37:	31 ff                	xor    %edi,%edi
  801d39:	e9 40 ff ff ff       	jmp    801c7e <__udivdi3+0x46>
  801d3e:	66 90                	xchg   %ax,%ax
  801d40:	31 c0                	xor    %eax,%eax
  801d42:	e9 37 ff ff ff       	jmp    801c7e <__udivdi3+0x46>
  801d47:	90                   	nop

00801d48 <__umoddi3>:
  801d48:	55                   	push   %ebp
  801d49:	57                   	push   %edi
  801d4a:	56                   	push   %esi
  801d4b:	53                   	push   %ebx
  801d4c:	83 ec 1c             	sub    $0x1c,%esp
  801d4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d67:	89 f3                	mov    %esi,%ebx
  801d69:	89 fa                	mov    %edi,%edx
  801d6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d6f:	89 34 24             	mov    %esi,(%esp)
  801d72:	85 c0                	test   %eax,%eax
  801d74:	75 1a                	jne    801d90 <__umoddi3+0x48>
  801d76:	39 f7                	cmp    %esi,%edi
  801d78:	0f 86 a2 00 00 00    	jbe    801e20 <__umoddi3+0xd8>
  801d7e:	89 c8                	mov    %ecx,%eax
  801d80:	89 f2                	mov    %esi,%edx
  801d82:	f7 f7                	div    %edi
  801d84:	89 d0                	mov    %edx,%eax
  801d86:	31 d2                	xor    %edx,%edx
  801d88:	83 c4 1c             	add    $0x1c,%esp
  801d8b:	5b                   	pop    %ebx
  801d8c:	5e                   	pop    %esi
  801d8d:	5f                   	pop    %edi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    
  801d90:	39 f0                	cmp    %esi,%eax
  801d92:	0f 87 ac 00 00 00    	ja     801e44 <__umoddi3+0xfc>
  801d98:	0f bd e8             	bsr    %eax,%ebp
  801d9b:	83 f5 1f             	xor    $0x1f,%ebp
  801d9e:	0f 84 ac 00 00 00    	je     801e50 <__umoddi3+0x108>
  801da4:	bf 20 00 00 00       	mov    $0x20,%edi
  801da9:	29 ef                	sub    %ebp,%edi
  801dab:	89 fe                	mov    %edi,%esi
  801dad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801db1:	89 e9                	mov    %ebp,%ecx
  801db3:	d3 e0                	shl    %cl,%eax
  801db5:	89 d7                	mov    %edx,%edi
  801db7:	89 f1                	mov    %esi,%ecx
  801db9:	d3 ef                	shr    %cl,%edi
  801dbb:	09 c7                	or     %eax,%edi
  801dbd:	89 e9                	mov    %ebp,%ecx
  801dbf:	d3 e2                	shl    %cl,%edx
  801dc1:	89 14 24             	mov    %edx,(%esp)
  801dc4:	89 d8                	mov    %ebx,%eax
  801dc6:	d3 e0                	shl    %cl,%eax
  801dc8:	89 c2                	mov    %eax,%edx
  801dca:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dce:	d3 e0                	shl    %cl,%eax
  801dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd8:	89 f1                	mov    %esi,%ecx
  801dda:	d3 e8                	shr    %cl,%eax
  801ddc:	09 d0                	or     %edx,%eax
  801dde:	d3 eb                	shr    %cl,%ebx
  801de0:	89 da                	mov    %ebx,%edx
  801de2:	f7 f7                	div    %edi
  801de4:	89 d3                	mov    %edx,%ebx
  801de6:	f7 24 24             	mull   (%esp)
  801de9:	89 c6                	mov    %eax,%esi
  801deb:	89 d1                	mov    %edx,%ecx
  801ded:	39 d3                	cmp    %edx,%ebx
  801def:	0f 82 87 00 00 00    	jb     801e7c <__umoddi3+0x134>
  801df5:	0f 84 91 00 00 00    	je     801e8c <__umoddi3+0x144>
  801dfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dff:	29 f2                	sub    %esi,%edx
  801e01:	19 cb                	sbb    %ecx,%ebx
  801e03:	89 d8                	mov    %ebx,%eax
  801e05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e09:	d3 e0                	shl    %cl,%eax
  801e0b:	89 e9                	mov    %ebp,%ecx
  801e0d:	d3 ea                	shr    %cl,%edx
  801e0f:	09 d0                	or     %edx,%eax
  801e11:	89 e9                	mov    %ebp,%ecx
  801e13:	d3 eb                	shr    %cl,%ebx
  801e15:	89 da                	mov    %ebx,%edx
  801e17:	83 c4 1c             	add    $0x1c,%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    
  801e1f:	90                   	nop
  801e20:	89 fd                	mov    %edi,%ebp
  801e22:	85 ff                	test   %edi,%edi
  801e24:	75 0b                	jne    801e31 <__umoddi3+0xe9>
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f7                	div    %edi
  801e2f:	89 c5                	mov    %eax,%ebp
  801e31:	89 f0                	mov    %esi,%eax
  801e33:	31 d2                	xor    %edx,%edx
  801e35:	f7 f5                	div    %ebp
  801e37:	89 c8                	mov    %ecx,%eax
  801e39:	f7 f5                	div    %ebp
  801e3b:	89 d0                	mov    %edx,%eax
  801e3d:	e9 44 ff ff ff       	jmp    801d86 <__umoddi3+0x3e>
  801e42:	66 90                	xchg   %ax,%ax
  801e44:	89 c8                	mov    %ecx,%eax
  801e46:	89 f2                	mov    %esi,%edx
  801e48:	83 c4 1c             	add    $0x1c,%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5e                   	pop    %esi
  801e4d:	5f                   	pop    %edi
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    
  801e50:	3b 04 24             	cmp    (%esp),%eax
  801e53:	72 06                	jb     801e5b <__umoddi3+0x113>
  801e55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e59:	77 0f                	ja     801e6a <__umoddi3+0x122>
  801e5b:	89 f2                	mov    %esi,%edx
  801e5d:	29 f9                	sub    %edi,%ecx
  801e5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e63:	89 14 24             	mov    %edx,(%esp)
  801e66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e6e:	8b 14 24             	mov    (%esp),%edx
  801e71:	83 c4 1c             	add    $0x1c,%esp
  801e74:	5b                   	pop    %ebx
  801e75:	5e                   	pop    %esi
  801e76:	5f                   	pop    %edi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    
  801e79:	8d 76 00             	lea    0x0(%esi),%esi
  801e7c:	2b 04 24             	sub    (%esp),%eax
  801e7f:	19 fa                	sbb    %edi,%edx
  801e81:	89 d1                	mov    %edx,%ecx
  801e83:	89 c6                	mov    %eax,%esi
  801e85:	e9 71 ff ff ff       	jmp    801dfb <__umoddi3+0xb3>
  801e8a:	66 90                	xchg   %ax,%ax
  801e8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e90:	72 ea                	jb     801e7c <__umoddi3+0x134>
  801e92:	89 d9                	mov    %ebx,%ecx
  801e94:	e9 62 ff ff ff       	jmp    801dfb <__umoddi3+0xb3>
