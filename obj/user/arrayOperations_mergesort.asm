
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 17 18 00 00       	call   80185a <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 e0 1f 80 00       	push   $0x801fe0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 52 14 00 00       	call   8014b6 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 e4 1f 80 00       	push   $0x801fe4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 3c 14 00 00       	call   8014b6 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 ec 1f 80 00       	push   $0x801fec
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 1f 14 00 00       	call   8014b6 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 fa 1f 80 00       	push   $0x801ffa
  8000b0:	e8 d2 13 00 00       	call   801487 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 09 20 80 00       	push   $0x802009
  800111:	e8 7e 05 00 00       	call   800694 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 25 20 80 00       	push   $0x802025
  8001a7:	e8 e8 04 00 00       	call   800694 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 27 20 80 00       	push   $0x802027
  8001c9:	e8 c6 04 00 00       	call   800694 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 2c 20 80 00       	push   $0x80202c
  8001f7:	e8 98 04 00 00       	call   800694 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 a7 11 00 00       	call   801444 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 92 11 00 00       	call   801444 <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 0e 10 00 00       	call   80146d <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 00 10 00 00       	call   80146d <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 c3 13 00 00       	call   801841 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 06             	shl    $0x6,%eax
  800489:	29 d0                	sub    %edx,%eax
  80048b:	c1 e0 02             	shl    $0x2,%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	01 c8                	add    %ecx,%eax
  800499:	c1 e0 03             	shl    $0x3,%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	29 c2                	sub    %eax,%edx
  8004a7:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8004ae:	89 c2                	mov    %eax,%edx
  8004b0:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8004b6:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c0:	8a 40 20             	mov    0x20(%eax),%al
  8004c3:	84 c0                	test   %al,%al
  8004c5:	74 0d                	je     8004d4 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8004c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004cc:	83 c0 20             	add    $0x20,%eax
  8004cf:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004d8:	7e 0a                	jle    8004e4 <libmain+0x71>
		binaryname = argv[0];
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ea:	ff 75 08             	pushl  0x8(%ebp)
  8004ed:	e8 46 fb ff ff       	call   800038 <_main>
  8004f2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004f5:	e8 cb 10 00 00       	call   8015c5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004fa:	83 ec 0c             	sub    $0xc,%esp
  8004fd:	68 48 20 80 00       	push   $0x802048
  800502:	e8 8d 01 00 00       	call   800694 <cprintf>
  800507:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80050a:	a1 04 30 80 00       	mov    0x803004,%eax
  80050f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800515:	a1 04 30 80 00       	mov    0x803004,%eax
  80051a:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	52                   	push   %edx
  800524:	50                   	push   %eax
  800525:	68 70 20 80 00       	push   $0x802070
  80052a:	e8 65 01 00 00       	call   800694 <cprintf>
  80052f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800532:	a1 04 30 80 00       	mov    0x803004,%eax
  800537:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80053d:	a1 04 30 80 00       	mov    0x803004,%eax
  800542:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800548:	a1 04 30 80 00       	mov    0x803004,%eax
  80054d:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800553:	51                   	push   %ecx
  800554:	52                   	push   %edx
  800555:	50                   	push   %eax
  800556:	68 98 20 80 00       	push   $0x802098
  80055b:	e8 34 01 00 00       	call   800694 <cprintf>
  800560:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800563:	a1 04 30 80 00       	mov    0x803004,%eax
  800568:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	50                   	push   %eax
  800572:	68 f0 20 80 00       	push   $0x8020f0
  800577:	e8 18 01 00 00       	call   800694 <cprintf>
  80057c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	68 48 20 80 00       	push   $0x802048
  800587:	e8 08 01 00 00       	call   800694 <cprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80058f:	e8 4b 10 00 00       	call   8015df <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800594:	e8 19 00 00 00       	call   8005b2 <exit>
}
  800599:	90                   	nop
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005a2:	83 ec 0c             	sub    $0xc,%esp
  8005a5:	6a 00                	push   $0x0
  8005a7:	e8 61 12 00 00       	call   80180d <sys_destroy_env>
  8005ac:	83 c4 10             	add    $0x10,%esp
}
  8005af:	90                   	nop
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <exit>:

void
exit(void)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005b8:	e8 b6 12 00 00       	call   801873 <sys_exit_env>
}
  8005bd:	90                   	nop
  8005be:	c9                   	leave  
  8005bf:	c3                   	ret    

008005c0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d1:	89 0a                	mov    %ecx,(%edx)
  8005d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005d6:	88 d1                	mov    %dl,%cl
  8005d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005db:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e9:	75 2c                	jne    800617 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005eb:	a0 08 30 80 00       	mov    0x803008,%al
  8005f0:	0f b6 c0             	movzbl %al,%eax
  8005f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f6:	8b 12                	mov    (%edx),%edx
  8005f8:	89 d1                	mov    %edx,%ecx
  8005fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fd:	83 c2 08             	add    $0x8,%edx
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	50                   	push   %eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	e8 78 0f 00 00       	call   801583 <sys_cputs>
  80060b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061a:	8b 40 04             	mov    0x4(%eax),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	89 50 04             	mov    %edx,0x4(%eax)
}
  800626:	90                   	nop
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800632:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800639:	00 00 00 
	b.cnt = 0;
  80063c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800643:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 08             	pushl  0x8(%ebp)
  80064c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800652:	50                   	push   %eax
  800653:	68 c0 05 80 00       	push   $0x8005c0
  800658:	e8 11 02 00 00       	call   80086e <vprintfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800660:	a0 08 30 80 00       	mov    0x803008,%al
  800665:	0f b6 c0             	movzbl %al,%eax
  800668:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	50                   	push   %eax
  800672:	52                   	push   %edx
  800673:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800679:	83 c0 08             	add    $0x8,%eax
  80067c:	50                   	push   %eax
  80067d:	e8 01 0f 00 00       	call   801583 <sys_cputs>
  800682:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800685:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80068c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800692:	c9                   	leave  
  800693:	c3                   	ret    

00800694 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80069a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b0:	50                   	push   %eax
  8006b1:	e8 73 ff ff ff       	call   800629 <vcprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006c7:	e8 f9 0e 00 00       	call   8015c5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006db:	50                   	push   %eax
  8006dc:	e8 48 ff ff ff       	call   800629 <vcprintf>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006e7:	e8 f3 0e 00 00       	call   8015df <sys_unlock_cons>
	return cnt;
  8006ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	53                   	push   %ebx
  8006f5:	83 ec 14             	sub    $0x14,%esp
  8006f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800704:	8b 45 18             	mov    0x18(%ebp),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80070f:	77 55                	ja     800766 <printnum+0x75>
  800711:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800714:	72 05                	jb     80071b <printnum+0x2a>
  800716:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800719:	77 4b                	ja     800766 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80071e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800721:	8b 45 18             	mov    0x18(%ebp),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	52                   	push   %edx
  80072a:	50                   	push   %eax
  80072b:	ff 75 f4             	pushl  -0xc(%ebp)
  80072e:	ff 75 f0             	pushl  -0x10(%ebp)
  800731:	e8 3a 16 00 00       	call   801d70 <__udivdi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	83 ec 04             	sub    $0x4,%esp
  80073c:	ff 75 20             	pushl  0x20(%ebp)
  80073f:	53                   	push   %ebx
  800740:	ff 75 18             	pushl  0x18(%ebp)
  800743:	52                   	push   %edx
  800744:	50                   	push   %eax
  800745:	ff 75 0c             	pushl  0xc(%ebp)
  800748:	ff 75 08             	pushl  0x8(%ebp)
  80074b:	e8 a1 ff ff ff       	call   8006f1 <printnum>
  800750:	83 c4 20             	add    $0x20,%esp
  800753:	eb 1a                	jmp    80076f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 20             	pushl  0x20(%ebp)
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800766:	ff 4d 1c             	decl   0x1c(%ebp)
  800769:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80076d:	7f e6                	jg     800755 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800772:	bb 00 00 00 00       	mov    $0x0,%ebx
  800777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077d:	53                   	push   %ebx
  80077e:	51                   	push   %ecx
  80077f:	52                   	push   %edx
  800780:	50                   	push   %eax
  800781:	e8 fa 16 00 00       	call   801e80 <__umoddi3>
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	05 34 23 80 00       	add    $0x802334,%eax
  80078e:	8a 00                	mov    (%eax),%al
  800790:	0f be c0             	movsbl %al,%eax
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	50                   	push   %eax
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	ff d0                	call   *%eax
  80079f:	83 c4 10             	add    $0x10,%esp
}
  8007a2:	90                   	nop
  8007a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    

008007a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007af:	7e 1c                	jle    8007cd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	8d 50 08             	lea    0x8(%eax),%edx
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	89 10                	mov    %edx,(%eax)
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	83 e8 08             	sub    $0x8,%eax
  8007c6:	8b 50 04             	mov    0x4(%eax),%edx
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	eb 40                	jmp    80080d <getuint+0x65>
	else if (lflag)
  8007cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d1:	74 1e                	je     8007f1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	8d 50 04             	lea    0x4(%eax),%edx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	89 10                	mov    %edx,(%eax)
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	83 e8 04             	sub    $0x4,%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ef:	eb 1c                	jmp    80080d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	8d 50 04             	lea    0x4(%eax),%edx
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	89 10                	mov    %edx,(%eax)
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800812:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800816:	7e 1c                	jle    800834 <getint+0x25>
		return va_arg(*ap, long long);
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	8d 50 08             	lea    0x8(%eax),%edx
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	89 10                	mov    %edx,(%eax)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	83 e8 08             	sub    $0x8,%eax
  80082d:	8b 50 04             	mov    0x4(%eax),%edx
  800830:	8b 00                	mov    (%eax),%eax
  800832:	eb 38                	jmp    80086c <getint+0x5d>
	else if (lflag)
  800834:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800838:	74 1a                	je     800854 <getint+0x45>
		return va_arg(*ap, long);
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	8d 50 04             	lea    0x4(%eax),%edx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	89 10                	mov    %edx,(%eax)
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	99                   	cltd   
  800852:	eb 18                	jmp    80086c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	8d 50 04             	lea    0x4(%eax),%edx
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	89 10                	mov    %edx,(%eax)
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	83 e8 04             	sub    $0x4,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	99                   	cltd   
}
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	56                   	push   %esi
  800872:	53                   	push   %ebx
  800873:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800876:	eb 17                	jmp    80088f <vprintfmt+0x21>
			if (ch == '\0')
  800878:	85 db                	test   %ebx,%ebx
  80087a:	0f 84 c1 03 00 00    	je     800c41 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	53                   	push   %ebx
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	ff d0                	call   *%eax
  80088c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088f:	8b 45 10             	mov    0x10(%ebp),%eax
  800892:	8d 50 01             	lea    0x1(%eax),%edx
  800895:	89 55 10             	mov    %edx,0x10(%ebp)
  800898:	8a 00                	mov    (%eax),%al
  80089a:	0f b6 d8             	movzbl %al,%ebx
  80089d:	83 fb 25             	cmp    $0x25,%ebx
  8008a0:	75 d6                	jne    800878 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c5:	8d 50 01             	lea    0x1(%eax),%edx
  8008c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008cb:	8a 00                	mov    (%eax),%al
  8008cd:	0f b6 d8             	movzbl %al,%ebx
  8008d0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008d3:	83 f8 5b             	cmp    $0x5b,%eax
  8008d6:	0f 87 3d 03 00 00    	ja     800c19 <vprintfmt+0x3ab>
  8008dc:	8b 04 85 58 23 80 00 	mov    0x802358(,%eax,4),%eax
  8008e3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008e5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008e9:	eb d7                	jmp    8008c2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008eb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ef:	eb d1                	jmp    8008c2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fb:	89 d0                	mov    %edx,%eax
  8008fd:	c1 e0 02             	shl    $0x2,%eax
  800900:	01 d0                	add    %edx,%eax
  800902:	01 c0                	add    %eax,%eax
  800904:	01 d8                	add    %ebx,%eax
  800906:	83 e8 30             	sub    $0x30,%eax
  800909:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80090c:	8b 45 10             	mov    0x10(%ebp),%eax
  80090f:	8a 00                	mov    (%eax),%al
  800911:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800914:	83 fb 2f             	cmp    $0x2f,%ebx
  800917:	7e 3e                	jle    800957 <vprintfmt+0xe9>
  800919:	83 fb 39             	cmp    $0x39,%ebx
  80091c:	7f 39                	jg     800957 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800921:	eb d5                	jmp    8008f8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 c0 04             	add    $0x4,%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 e8 04             	sub    $0x4,%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800937:	eb 1f                	jmp    800958 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	79 83                	jns    8008c2 <vprintfmt+0x54>
				width = 0;
  80093f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800946:	e9 77 ff ff ff       	jmp    8008c2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80094b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800952:	e9 6b ff ff ff       	jmp    8008c2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800957:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	0f 89 60 ff ff ff    	jns    8008c2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800968:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80096f:	e9 4e ff ff ff       	jmp    8008c2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800974:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800977:	e9 46 ff ff ff       	jmp    8008c2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	50                   	push   %eax
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	ff d0                	call   *%eax
  800999:	83 c4 10             	add    $0x10,%esp
			break;
  80099c:	e9 9b 02 00 00       	jmp    800c3c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 c0 04             	add    $0x4,%eax
  8009a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 e8 04             	sub    $0x4,%eax
  8009b0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009b2:	85 db                	test   %ebx,%ebx
  8009b4:	79 02                	jns    8009b8 <vprintfmt+0x14a>
				err = -err;
  8009b6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009b8:	83 fb 64             	cmp    $0x64,%ebx
  8009bb:	7f 0b                	jg     8009c8 <vprintfmt+0x15a>
  8009bd:	8b 34 9d a0 21 80 00 	mov    0x8021a0(,%ebx,4),%esi
  8009c4:	85 f6                	test   %esi,%esi
  8009c6:	75 19                	jne    8009e1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009c8:	53                   	push   %ebx
  8009c9:	68 45 23 80 00       	push   $0x802345
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	ff 75 08             	pushl  0x8(%ebp)
  8009d4:	e8 70 02 00 00       	call   800c49 <printfmt>
  8009d9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009dc:	e9 5b 02 00 00       	jmp    800c3c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009e1:	56                   	push   %esi
  8009e2:	68 4e 23 80 00       	push   $0x80234e
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 57 02 00 00       	call   800c49 <printfmt>
  8009f2:	83 c4 10             	add    $0x10,%esp
			break;
  8009f5:	e9 42 02 00 00       	jmp    800c3c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	83 c0 04             	add    $0x4,%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 e8 04             	sub    $0x4,%eax
  800a09:	8b 30                	mov    (%eax),%esi
  800a0b:	85 f6                	test   %esi,%esi
  800a0d:	75 05                	jne    800a14 <vprintfmt+0x1a6>
				p = "(null)";
  800a0f:	be 51 23 80 00       	mov    $0x802351,%esi
			if (width > 0 && padc != '-')
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	7e 6d                	jle    800a87 <vprintfmt+0x219>
  800a1a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a1e:	74 67                	je     800a87 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	50                   	push   %eax
  800a27:	56                   	push   %esi
  800a28:	e8 1e 03 00 00       	call   800d4b <strnlen>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a33:	eb 16                	jmp    800a4b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a35:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	50                   	push   %eax
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	ff d0                	call   *%eax
  800a45:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a48:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	7f e4                	jg     800a35 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a51:	eb 34                	jmp    800a87 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a53:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a57:	74 1c                	je     800a75 <vprintfmt+0x207>
  800a59:	83 fb 1f             	cmp    $0x1f,%ebx
  800a5c:	7e 05                	jle    800a63 <vprintfmt+0x1f5>
  800a5e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a61:	7e 12                	jle    800a75 <vprintfmt+0x207>
					putch('?', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 3f                	push   $0x3f
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	eb 0f                	jmp    800a84 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	53                   	push   %ebx
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a84:	ff 4d e4             	decl   -0x1c(%ebp)
  800a87:	89 f0                	mov    %esi,%eax
  800a89:	8d 70 01             	lea    0x1(%eax),%esi
  800a8c:	8a 00                	mov    (%eax),%al
  800a8e:	0f be d8             	movsbl %al,%ebx
  800a91:	85 db                	test   %ebx,%ebx
  800a93:	74 24                	je     800ab9 <vprintfmt+0x24b>
  800a95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a99:	78 b8                	js     800a53 <vprintfmt+0x1e5>
  800a9b:	ff 4d e0             	decl   -0x20(%ebp)
  800a9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa2:	79 af                	jns    800a53 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa4:	eb 13                	jmp    800ab9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 20                	push   $0x20
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abd:	7f e7                	jg     800aa6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800abf:	e9 78 01 00 00       	jmp    800c3c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 e8             	pushl  -0x18(%ebp)
  800aca:	8d 45 14             	lea    0x14(%ebp),%eax
  800acd:	50                   	push   %eax
  800ace:	e8 3c fd ff ff       	call   80080f <getint>
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae2:	85 d2                	test   %edx,%edx
  800ae4:	79 23                	jns    800b09 <vprintfmt+0x29b>
				putch('-', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	6a 2d                	push   $0x2d
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afc:	f7 d8                	neg    %eax
  800afe:	83 d2 00             	adc    $0x0,%edx
  800b01:	f7 da                	neg    %edx
  800b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b10:	e9 bc 00 00 00       	jmp    800bd1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1e:	50                   	push   %eax
  800b1f:	e8 84 fc ff ff       	call   8007a8 <getuint>
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b2d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b34:	e9 98 00 00 00       	jmp    800bd1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 0c             	pushl  0xc(%ebp)
  800b3f:	6a 58                	push   $0x58
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ff d0                	call   *%eax
  800b46:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	6a 58                	push   $0x58
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 58                	push   $0x58
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
			break;
  800b69:	e9 ce 00 00 00       	jmp    800c3c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	6a 30                	push   $0x30
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	6a 78                	push   $0x78
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	83 e8 04             	sub    $0x4,%eax
  800b9d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ba9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bb0:	eb 1f                	jmp    800bd1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbb:	50                   	push   %eax
  800bbc:	e8 e7 fb ff ff       	call   8007a8 <getuint>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd8:	83 ec 04             	sub    $0x4,%esp
  800bdb:	52                   	push   %edx
  800bdc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bdf:	50                   	push   %eax
  800be0:	ff 75 f4             	pushl  -0xc(%ebp)
  800be3:	ff 75 f0             	pushl  -0x10(%ebp)
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 00 fb ff ff       	call   8006f1 <printnum>
  800bf1:	83 c4 20             	add    $0x20,%esp
			break;
  800bf4:	eb 46                	jmp    800c3c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
			break;
  800c05:	eb 35                	jmp    800c3c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c07:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c0e:	eb 2c                	jmp    800c3c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c10:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c17:	eb 23                	jmp    800c3c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	6a 25                	push   $0x25
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c29:	ff 4d 10             	decl   0x10(%ebp)
  800c2c:	eb 03                	jmp    800c31 <vprintfmt+0x3c3>
  800c2e:	ff 4d 10             	decl   0x10(%ebp)
  800c31:	8b 45 10             	mov    0x10(%ebp),%eax
  800c34:	48                   	dec    %eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	3c 25                	cmp    $0x25,%al
  800c39:	75 f3                	jne    800c2e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c3b:	90                   	nop
		}
	}
  800c3c:	e9 35 fc ff ff       	jmp    800876 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5e:	50                   	push   %eax
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	ff 75 08             	pushl  0x8(%ebp)
  800c65:	e8 04 fc ff ff       	call   80086e <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8b 40 08             	mov    0x8(%eax),%eax
  800c79:	8d 50 01             	lea    0x1(%eax),%edx
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8b 10                	mov    (%eax),%edx
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	8b 40 04             	mov    0x4(%eax),%eax
  800c8d:	39 c2                	cmp    %eax,%edx
  800c8f:	73 12                	jae    800ca3 <sprintputch+0x33>
		*b->buf++ = ch;
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	8d 48 01             	lea    0x1(%eax),%ecx
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	89 0a                	mov    %ecx,(%edx)
  800c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca1:	88 10                	mov    %dl,(%eax)
}
  800ca3:	90                   	nop
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccb:	74 06                	je     800cd3 <vsnprintf+0x2d>
  800ccd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd1:	7f 07                	jg     800cda <vsnprintf+0x34>
		return -E_INVAL;
  800cd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd8:	eb 20                	jmp    800cfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cda:	ff 75 14             	pushl  0x14(%ebp)
  800cdd:	ff 75 10             	pushl  0x10(%ebp)
  800ce0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce3:	50                   	push   %eax
  800ce4:	68 70 0c 80 00       	push   $0x800c70
  800ce9:	e8 80 fb ff ff       	call   80086e <vprintfmt>
  800cee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d02:	8d 45 10             	lea    0x10(%ebp),%eax
  800d05:	83 c0 04             	add    $0x4,%eax
  800d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d11:	50                   	push   %eax
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	ff 75 08             	pushl  0x8(%ebp)
  800d18:	e8 89 ff ff ff       	call   800ca6 <vsnprintf>
  800d1d:	83 c4 10             	add    $0x10,%esp
  800d20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 06                	jmp    800d3d <strlen+0x15>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	84 c0                	test   %al,%al
  800d44:	75 f1                	jne    800d37 <strlen+0xf>
		n++;
	return n;
  800d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d58:	eb 09                	jmp    800d63 <strnlen+0x18>
		n++;
  800d5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5d:	ff 45 08             	incl   0x8(%ebp)
  800d60:	ff 4d 0c             	decl   0xc(%ebp)
  800d63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d67:	74 09                	je     800d72 <strnlen+0x27>
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	75 e8                	jne    800d5a <strnlen+0xf>
		n++;
	return n;
  800d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d83:	90                   	nop
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d96:	8a 12                	mov    (%edx),%dl
  800d98:	88 10                	mov    %dl,(%eax)
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	84 c0                	test   %al,%al
  800d9e:	75 e4                	jne    800d84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db8:	eb 1f                	jmp    800dd9 <strncpy+0x34>
		*dst++ = *src;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	8a 12                	mov    (%edx),%dl
  800dc8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	84 c0                	test   %al,%al
  800dd1:	74 03                	je     800dd6 <strncpy+0x31>
			src++;
  800dd3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd6:	ff 45 fc             	incl   -0x4(%ebp)
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ddf:	72 d9                	jb     800dba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 30                	je     800e28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df8:	eb 16                	jmp    800e10 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8d 50 01             	lea    0x1(%eax),%edx
  800e00:	89 55 08             	mov    %edx,0x8(%ebp)
  800e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0c:	8a 12                	mov    (%edx),%dl
  800e0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e10:	ff 4d 10             	decl   0x10(%ebp)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	74 09                	je     800e22 <strlcpy+0x3c>
  800e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	84 c0                	test   %al,%al
  800e20:	75 d8                	jne    800dfa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2e:	29 c2                	sub    %eax,%edx
  800e30:	89 d0                	mov    %edx,%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e37:	eb 06                	jmp    800e3f <strcmp+0xb>
		p++, q++;
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	84 c0                	test   %al,%al
  800e46:	74 0e                	je     800e56 <strcmp+0x22>
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 10                	mov    (%eax),%dl
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	38 c2                	cmp    %al,%dl
  800e54:	74 e3                	je     800e39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	0f b6 d0             	movzbl %al,%edx
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	0f b6 c0             	movzbl %al,%eax
  800e66:	29 c2                	sub    %eax,%edx
  800e68:	89 d0                	mov    %edx,%eax
}
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e6f:	eb 09                	jmp    800e7a <strncmp+0xe>
		n--, p++, q++;
  800e71:	ff 4d 10             	decl   0x10(%ebp)
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7e:	74 17                	je     800e97 <strncmp+0x2b>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	84 c0                	test   %al,%al
  800e87:	74 0e                	je     800e97 <strncmp+0x2b>
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 10                	mov    (%eax),%dl
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	38 c2                	cmp    %al,%dl
  800e95:	74 da                	je     800e71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9b:	75 07                	jne    800ea4 <strncmp+0x38>
		return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea2:	eb 14                	jmp    800eb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	0f b6 d0             	movzbl %al,%edx
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	0f b6 c0             	movzbl %al,%eax
  800eb4:	29 c2                	sub    %eax,%edx
  800eb6:	89 d0                	mov    %edx,%eax
}
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 04             	sub    $0x4,%esp
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec6:	eb 12                	jmp    800eda <strchr+0x20>
		if (*s == c)
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed0:	75 05                	jne    800ed7 <strchr+0x1d>
			return (char *) s;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	eb 11                	jmp    800ee8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed7:	ff 45 08             	incl   0x8(%ebp)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 e5                	jne    800ec8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 04             	sub    $0x4,%esp
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef6:	eb 0d                	jmp    800f05 <strfind+0x1b>
		if (*s == c)
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f00:	74 0e                	je     800f10 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	84 c0                	test   %al,%al
  800f0c:	75 ea                	jne    800ef8 <strfind+0xe>
  800f0e:	eb 01                	jmp    800f11 <strfind+0x27>
		if (*s == c)
			break;
  800f10:	90                   	nop
	return (char *) s;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f28:	eb 0e                	jmp    800f38 <memset+0x22>
		*p++ = c;
  800f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f36:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f38:	ff 4d f8             	decl   -0x8(%ebp)
  800f3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f3f:	79 e9                	jns    800f2a <memset+0x14>
		*p++ = c;

	return v;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f58:	eb 16                	jmp    800f70 <memcpy+0x2a>
		*d++ = *s++;
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8d 50 01             	lea    0x1(%eax),%edx
  800f60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6c:	8a 12                	mov    (%edx),%dl
  800f6e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 dd                	jne    800f5a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f97:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9a:	73 50                	jae    800fec <memmove+0x6a>
  800f9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	01 d0                	add    %edx,%eax
  800fa4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa7:	76 43                	jbe    800fec <memmove+0x6a>
		s += n;
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb5:	eb 10                	jmp    800fc7 <memmove+0x45>
			*--d = *--s;
  800fb7:	ff 4d f8             	decl   -0x8(%ebp)
  800fba:	ff 4d fc             	decl   -0x4(%ebp)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	75 e3                	jne    800fb7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd4:	eb 23                	jmp    800ff9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd9:	8d 50 01             	lea    0x1(%eax),%edx
  800fdc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe8:	8a 12                	mov    (%edx),%dl
  800fea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
  800fef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	75 dd                	jne    800fd6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801010:	eb 2a                	jmp    80103c <memcmp+0x3e>
		if (*s1 != *s2)
  801012:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801015:	8a 10                	mov    (%eax),%dl
  801017:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	38 c2                	cmp    %al,%dl
  80101e:	74 16                	je     801036 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801020:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f b6 d0             	movzbl %al,%edx
  801028:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	0f b6 c0             	movzbl %al,%eax
  801030:	29 c2                	sub    %eax,%edx
  801032:	89 d0                	mov    %edx,%eax
  801034:	eb 18                	jmp    80104e <memcmp+0x50>
		s1++, s2++;
  801036:	ff 45 fc             	incl   -0x4(%ebp)
  801039:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103c:	8b 45 10             	mov    0x10(%ebp),%eax
  80103f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801042:	89 55 10             	mov    %edx,0x10(%ebp)
  801045:	85 c0                	test   %eax,%eax
  801047:	75 c9                	jne    801012 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801049:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801061:	eb 15                	jmp    801078 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	0f b6 d0             	movzbl %al,%edx
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	39 c2                	cmp    %eax,%edx
  801073:	74 0d                	je     801082 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80107e:	72 e3                	jb     801063 <memfind+0x13>
  801080:	eb 01                	jmp    801083 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801082:	90                   	nop
	return (void *) s;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801095:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109c:	eb 03                	jmp    8010a1 <strtol+0x19>
		s++;
  80109e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 20                	cmp    $0x20,%al
  8010a8:	74 f4                	je     80109e <strtol+0x16>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 09                	cmp    $0x9,%al
  8010b1:	74 eb                	je     80109e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 2b                	cmp    $0x2b,%al
  8010ba:	75 05                	jne    8010c1 <strtol+0x39>
		s++;
  8010bc:	ff 45 08             	incl   0x8(%ebp)
  8010bf:	eb 13                	jmp    8010d4 <strtol+0x4c>
	else if (*s == '-')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 2d                	cmp    $0x2d,%al
  8010c8:	75 0a                	jne    8010d4 <strtol+0x4c>
		s++, neg = 1;
  8010ca:	ff 45 08             	incl   0x8(%ebp)
  8010cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 06                	je     8010e0 <strtol+0x58>
  8010da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010de:	75 20                	jne    801100 <strtol+0x78>
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 30                	cmp    $0x30,%al
  8010e7:	75 17                	jne    801100 <strtol+0x78>
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	40                   	inc    %eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 78                	cmp    $0x78,%al
  8010f1:	75 0d                	jne    801100 <strtol+0x78>
		s += 2, base = 16;
  8010f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010fe:	eb 28                	jmp    801128 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801104:	75 15                	jne    80111b <strtol+0x93>
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	3c 30                	cmp    $0x30,%al
  80110d:	75 0c                	jne    80111b <strtol+0x93>
		s++, base = 8;
  80110f:	ff 45 08             	incl   0x8(%ebp)
  801112:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801119:	eb 0d                	jmp    801128 <strtol+0xa0>
	else if (base == 0)
  80111b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111f:	75 07                	jne    801128 <strtol+0xa0>
		base = 10;
  801121:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3c 2f                	cmp    $0x2f,%al
  80112f:	7e 19                	jle    80114a <strtol+0xc2>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 39                	cmp    $0x39,%al
  801138:	7f 10                	jg     80114a <strtol+0xc2>
			dig = *s - '0';
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f be c0             	movsbl %al,%eax
  801142:	83 e8 30             	sub    $0x30,%eax
  801145:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801148:	eb 42                	jmp    80118c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 60                	cmp    $0x60,%al
  801151:	7e 19                	jle    80116c <strtol+0xe4>
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 7a                	cmp    $0x7a,%al
  80115a:	7f 10                	jg     80116c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	0f be c0             	movsbl %al,%eax
  801164:	83 e8 57             	sub    $0x57,%eax
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116a:	eb 20                	jmp    80118c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 40                	cmp    $0x40,%al
  801173:	7e 39                	jle    8011ae <strtol+0x126>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 5a                	cmp    $0x5a,%al
  80117c:	7f 30                	jg     8011ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	0f be c0             	movsbl %al,%eax
  801186:	83 e8 37             	sub    $0x37,%eax
  801189:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801192:	7d 19                	jge    8011ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801194:	ff 45 08             	incl   0x8(%ebp)
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011a8:	e9 7b ff ff ff       	jmp    801128 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b2:	74 08                	je     8011bc <strtol+0x134>
		*endptr = (char *) s;
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c0:	74 07                	je     8011c9 <strtol+0x141>
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	f7 d8                	neg    %eax
  8011c7:	eb 03                	jmp    8011cc <strtol+0x144>
  8011c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <ltostr>:

void
ltostr(long value, char *str)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e6:	79 13                	jns    8011fb <ltostr+0x2d>
	{
		neg = 1;
  8011e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801203:	99                   	cltd   
  801204:	f7 f9                	idiv   %ecx
  801206:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801209:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120c:	8d 50 01             	lea    0x1(%eax),%edx
  80120f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801212:	89 c2                	mov    %eax,%edx
  801214:	8b 45 0c             	mov    0xc(%ebp),%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121c:	83 c2 30             	add    $0x30,%edx
  80121f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801221:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801224:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801229:	f7 e9                	imul   %ecx
  80122b:	c1 fa 02             	sar    $0x2,%edx
  80122e:	89 c8                	mov    %ecx,%eax
  801230:	c1 f8 1f             	sar    $0x1f,%eax
  801233:	29 c2                	sub    %eax,%edx
  801235:	89 d0                	mov    %edx,%eax
  801237:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80123a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123e:	75 bb                	jne    8011fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801247:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124a:	48                   	dec    %eax
  80124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801252:	74 3d                	je     801291 <ltostr+0xc3>
		start = 1 ;
  801254:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80125b:	eb 34                	jmp    801291 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80125d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801270:	01 c2                	add    %eax,%edx
  801272:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	01 c8                	add    %ecx,%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 c2                	add    %eax,%edx
  801286:	8a 45 eb             	mov    -0x15(%ebp),%al
  801289:	88 02                	mov    %al,(%edx)
		start++ ;
  80128b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801294:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801297:	7c c4                	jl     80125d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801299:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a4:	90                   	nop
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ad:	ff 75 08             	pushl  0x8(%ebp)
  8012b0:	e8 73 fa ff ff       	call   800d28 <strlen>
  8012b5:	83 c4 04             	add    $0x4,%esp
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	e8 65 fa ff ff       	call   800d28 <strlen>
  8012c3:	83 c4 04             	add    $0x4,%esp
  8012c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d7:	eb 17                	jmp    8012f0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	01 c2                	add    %eax,%edx
  8012e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	01 c8                	add    %ecx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ed:	ff 45 fc             	incl   -0x4(%ebp)
  8012f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f6:	7c e1                	jl     8012d9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801306:	eb 1f                	jmp    801327 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801308:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130b:	8d 50 01             	lea    0x1(%eax),%edx
  80130e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801311:	89 c2                	mov    %eax,%edx
  801313:	8b 45 10             	mov    0x10(%ebp),%eax
  801316:	01 c2                	add    %eax,%edx
  801318:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	01 c8                	add    %ecx,%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801324:	ff 45 f8             	incl   -0x8(%ebp)
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132d:	7c d9                	jl     801308 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	c6 00 00             	movb   $0x0,(%eax)
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801349:	8b 45 14             	mov    0x14(%ebp),%eax
  80134c:	8b 00                	mov    (%eax),%eax
  80134e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801355:	8b 45 10             	mov    0x10(%ebp),%eax
  801358:	01 d0                	add    %edx,%eax
  80135a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801360:	eb 0c                	jmp    80136e <strsplit+0x31>
			*string++ = 0;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8d 50 01             	lea    0x1(%eax),%edx
  801368:	89 55 08             	mov    %edx,0x8(%ebp)
  80136b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	84 c0                	test   %al,%al
  801375:	74 18                	je     80138f <strsplit+0x52>
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f be c0             	movsbl %al,%eax
  80137f:	50                   	push   %eax
  801380:	ff 75 0c             	pushl  0xc(%ebp)
  801383:	e8 32 fb ff ff       	call   800eba <strchr>
  801388:	83 c4 08             	add    $0x8,%esp
  80138b:	85 c0                	test   %eax,%eax
  80138d:	75 d3                	jne    801362 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 5a                	je     8013f2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	8b 00                	mov    (%eax),%eax
  80139d:	83 f8 0f             	cmp    $0xf,%eax
  8013a0:	75 07                	jne    8013a9 <strsplit+0x6c>
		{
			return 0;
  8013a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a7:	eb 66                	jmp    80140f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ac:	8b 00                	mov    (%eax),%eax
  8013ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b4:	89 0a                	mov    %ecx,(%edx)
  8013b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c0:	01 c2                	add    %eax,%edx
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c7:	eb 03                	jmp    8013cc <strsplit+0x8f>
			string++;
  8013c9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	74 8b                	je     801360 <strsplit+0x23>
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	0f be c0             	movsbl %al,%eax
  8013dd:	50                   	push   %eax
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	e8 d4 fa ff ff       	call   800eba <strchr>
  8013e6:	83 c4 08             	add    $0x8,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	74 dc                	je     8013c9 <strsplit+0x8c>
			string++;
	}
  8013ed:	e9 6e ff ff ff       	jmp    801360 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801402:	01 d0                	add    %edx,%eax
  801404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	68 c8 24 80 00       	push   $0x8024c8
  80141f:	68 3f 01 00 00       	push   $0x13f
  801424:	68 ea 24 80 00       	push   $0x8024ea
  801429:	e8 57 07 00 00       	call   801b85 <_panic>

0080142e <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	ff 75 08             	pushl  0x8(%ebp)
  80143a:	e8 ef 06 00 00       	call   801b2e <sys_sbrk>
  80143f:	83 c4 10             	add    $0x10,%esp
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80144a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144e:	75 07                	jne    801457 <malloc+0x13>
  801450:	b8 00 00 00 00       	mov    $0x0,%eax
  801455:	eb 14                	jmp    80146b <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	68 f8 24 80 00       	push   $0x8024f8
  80145f:	6a 1b                	push   $0x1b
  801461:	68 1d 25 80 00       	push   $0x80251d
  801466:	e8 1a 07 00 00       	call   801b85 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 2c 25 80 00       	push   $0x80252c
  80147b:	6a 29                	push   $0x29
  80147d:	68 1d 25 80 00       	push   $0x80251d
  801482:	e8 fe 06 00 00       	call   801b85 <_panic>

00801487 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 18             	sub    $0x18,%esp
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801493:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801497:	75 07                	jne    8014a0 <smalloc+0x19>
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
  80149e:	eb 14                	jmp    8014b4 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	68 50 25 80 00       	push   $0x802550
  8014a8:	6a 38                	push   $0x38
  8014aa:	68 1d 25 80 00       	push   $0x80251d
  8014af:	e8 d1 06 00 00       	call   801b85 <_panic>
	return NULL;
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014bc:	83 ec 04             	sub    $0x4,%esp
  8014bf:	68 78 25 80 00       	push   $0x802578
  8014c4:	6a 43                	push   $0x43
  8014c6:	68 1d 25 80 00       	push   $0x80251d
  8014cb:	e8 b5 06 00 00       	call   801b85 <_panic>

008014d0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	68 9c 25 80 00       	push   $0x80259c
  8014de:	6a 5b                	push   $0x5b
  8014e0:	68 1d 25 80 00       	push   $0x80251d
  8014e5:	e8 9b 06 00 00       	call   801b85 <_panic>

008014ea <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	68 c0 25 80 00       	push   $0x8025c0
  8014f8:	6a 72                	push   $0x72
  8014fa:	68 1d 25 80 00       	push   $0x80251d
  8014ff:	e8 81 06 00 00       	call   801b85 <_panic>

00801504 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	68 e6 25 80 00       	push   $0x8025e6
  801512:	6a 7e                	push   $0x7e
  801514:	68 1d 25 80 00       	push   $0x80251d
  801519:	e8 67 06 00 00       	call   801b85 <_panic>

0080151e <shrink>:

}
void shrink(uint32 newSize)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 e6 25 80 00       	push   $0x8025e6
  80152c:	68 83 00 00 00       	push   $0x83
  801531:	68 1d 25 80 00       	push   $0x80251d
  801536:	e8 4a 06 00 00       	call   801b85 <_panic>

0080153b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	68 e6 25 80 00       	push   $0x8025e6
  801549:	68 88 00 00 00       	push   $0x88
  80154e:	68 1d 25 80 00       	push   $0x80251d
  801553:	e8 2d 06 00 00       	call   801b85 <_panic>

00801558 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	57                   	push   %edi
  80155c:	56                   	push   %esi
  80155d:	53                   	push   %ebx
  80155e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8b 55 0c             	mov    0xc(%ebp),%edx
  801567:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80156d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801570:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801573:	cd 30                	int    $0x30
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	5b                   	pop    %ebx
  80157f:	5e                   	pop    %esi
  801580:	5f                   	pop    %edi
  801581:	5d                   	pop    %ebp
  801582:	c3                   	ret    

00801583 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	8b 45 10             	mov    0x10(%ebp),%eax
  80158c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80158f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	52                   	push   %edx
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	50                   	push   %eax
  80159f:	6a 00                	push   $0x0
  8015a1:	e8 b2 ff ff ff       	call   801558 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 02                	push   $0x2
  8015bb:	e8 98 ff ff ff       	call   801558 <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 03                	push   $0x3
  8015d4:	e8 7f ff ff ff       	call   801558 <syscall>
  8015d9:	83 c4 18             	add    $0x18,%esp
}
  8015dc:	90                   	nop
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 04                	push   $0x4
  8015ee:	e8 65 ff ff ff       	call   801558 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	52                   	push   %edx
  801609:	50                   	push   %eax
  80160a:	6a 08                	push   $0x8
  80160c:	e8 47 ff ff ff       	call   801558 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80161b:	8b 75 18             	mov    0x18(%ebp),%esi
  80161e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801621:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801624:	8b 55 0c             	mov    0xc(%ebp),%edx
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	56                   	push   %esi
  80162b:	53                   	push   %ebx
  80162c:	51                   	push   %ecx
  80162d:	52                   	push   %edx
  80162e:	50                   	push   %eax
  80162f:	6a 09                	push   $0x9
  801631:	e8 22 ff ff ff       	call   801558 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	52                   	push   %edx
  801650:	50                   	push   %eax
  801651:	6a 0a                	push   $0xa
  801653:	e8 00 ff ff ff       	call   801558 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	6a 0b                	push   $0xb
  80166e:	e8 e5 fe ff ff       	call   801558 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 0c                	push   $0xc
  801687:	e8 cc fe ff ff       	call   801558 <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 0d                	push   $0xd
  8016a0:	e8 b3 fe ff ff       	call   801558 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 0e                	push   $0xe
  8016b9:	e8 9a fe ff ff       	call   801558 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 0f                	push   $0xf
  8016d2:	e8 81 fe ff ff       	call   801558 <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	ff 75 08             	pushl  0x8(%ebp)
  8016ea:	6a 10                	push   $0x10
  8016ec:	e8 67 fe ff ff       	call   801558 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 11                	push   $0x11
  801705:	e8 4e fe ff ff       	call   801558 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	90                   	nop
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_cputc>:

void
sys_cputc(const char c)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80171c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	50                   	push   %eax
  801729:	6a 01                	push   $0x1
  80172b:	e8 28 fe ff ff       	call   801558 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	90                   	nop
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 14                	push   $0x14
  801745:	e8 0e fe ff ff       	call   801558 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	8b 45 10             	mov    0x10(%ebp),%eax
  801759:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80175c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80175f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	51                   	push   %ecx
  801769:	52                   	push   %edx
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	50                   	push   %eax
  80176e:	6a 15                	push   $0x15
  801770:	e8 e3 fd ff ff       	call   801558 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	6a 16                	push   $0x16
  80178d:	e8 c6 fd ff ff       	call   801558 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80179a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	51                   	push   %ecx
  8017a8:	52                   	push   %edx
  8017a9:	50                   	push   %eax
  8017aa:	6a 17                	push   $0x17
  8017ac:	e8 a7 fd ff ff       	call   801558 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	52                   	push   %edx
  8017c6:	50                   	push   %eax
  8017c7:	6a 18                	push   $0x18
  8017c9:	e8 8a fd ff ff       	call   801558 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 14             	pushl  0x14(%ebp)
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	50                   	push   %eax
  8017e5:	6a 19                	push   $0x19
  8017e7:	e8 6c fd ff ff       	call   801558 <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	50                   	push   %eax
  801800:	6a 1a                	push   $0x1a
  801802:	e8 51 fd ff ff       	call   801558 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	50                   	push   %eax
  80181c:	6a 1b                	push   $0x1b
  80181e:	e8 35 fd ff ff       	call   801558 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 05                	push   $0x5
  801837:	e8 1c fd ff ff       	call   801558 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 06                	push   $0x6
  801850:	e8 03 fd ff ff       	call   801558 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 07                	push   $0x7
  801869:	e8 ea fc ff ff       	call   801558 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_exit_env>:


void sys_exit_env(void)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 1c                	push   $0x1c
  801882:	e8 d1 fc ff ff       	call   801558 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801893:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801896:	8d 50 04             	lea    0x4(%eax),%edx
  801899:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 1d                	push   $0x1d
  8018a6:	e8 ad fc ff ff       	call   801558 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b7:	89 01                	mov    %eax,(%ecx)
  8018b9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	c9                   	leave  
  8018c0:	c2 04 00             	ret    $0x4

008018c3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	ff 75 10             	pushl  0x10(%ebp)
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	6a 13                	push   $0x13
  8018d5:	e8 7e fc ff ff       	call   801558 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
	return ;
  8018dd:	90                   	nop
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 1e                	push   $0x1e
  8018ef:	e8 64 fc ff ff       	call   801558 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801905:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	50                   	push   %eax
  801912:	6a 1f                	push   $0x1f
  801914:	e8 3f fc ff ff       	call   801558 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
	return ;
  80191c:	90                   	nop
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <rsttst>:
void rsttst()
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 21                	push   $0x21
  80192e:	e8 25 fc ff ff       	call   801558 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
	return ;
  801936:	90                   	nop
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	8b 45 14             	mov    0x14(%ebp),%eax
  801942:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801945:	8b 55 18             	mov    0x18(%ebp),%edx
  801948:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	ff 75 10             	pushl  0x10(%ebp)
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	6a 20                	push   $0x20
  801959:	e8 fa fb ff ff       	call   801558 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <chktst>:
void chktst(uint32 n)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 22                	push   $0x22
  801974:	e8 df fb ff ff       	call   801558 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return ;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <inctst>:

void inctst()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 23                	push   $0x23
  80198e:	e8 c5 fb ff ff       	call   801558 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
	return ;
  801996:	90                   	nop
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <gettst>:
uint32 gettst()
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 24                	push   $0x24
  8019a8:	e8 ab fb ff ff       	call   801558 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 25                	push   $0x25
  8019c4:	e8 8f fb ff ff       	call   801558 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
  8019cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019cf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019d3:	75 07                	jne    8019dc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019da:	eb 05                	jmp    8019e1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 25                	push   $0x25
  8019f5:	e8 5e fb ff ff       	call   801558 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
  8019fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a00:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a04:	75 07                	jne    801a0d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a06:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0b:	eb 05                	jmp    801a12 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 25                	push   $0x25
  801a26:	e8 2d fb ff ff       	call   801558 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
  801a2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a31:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a35:	75 07                	jne    801a3e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a37:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3c:	eb 05                	jmp    801a43 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 25                	push   $0x25
  801a57:	e8 fc fa ff ff       	call   801558 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a62:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a66:	75 07                	jne    801a6f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a68:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6d:	eb 05                	jmp    801a74 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	6a 26                	push   $0x26
  801a86:	e8 cd fa ff ff       	call   801558 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8e:	90                   	nop
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	53                   	push   %ebx
  801aa4:	51                   	push   %ecx
  801aa5:	52                   	push   %edx
  801aa6:	50                   	push   %eax
  801aa7:	6a 27                	push   $0x27
  801aa9:	e8 aa fa ff ff       	call   801558 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	52                   	push   %edx
  801ac6:	50                   	push   %eax
  801ac7:	6a 28                	push   $0x28
  801ac9:	e8 8a fa ff ff       	call   801558 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ad6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	51                   	push   %ecx
  801ae2:	ff 75 10             	pushl  0x10(%ebp)
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	6a 29                	push   $0x29
  801ae9:	e8 6a fa ff ff       	call   801558 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 10             	pushl  0x10(%ebp)
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 12                	push   $0x12
  801b05:	e8 4e fa ff ff       	call   801558 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	6a 2a                	push   $0x2a
  801b23:	e8 30 fa ff ff       	call   801558 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
	return;
  801b2b:	90                   	nop
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	68 f6 25 80 00       	push   $0x8025f6
  801b3c:	68 2e 01 00 00       	push   $0x12e
  801b41:	68 0a 26 80 00       	push   $0x80260a
  801b46:	e8 3a 00 00 00       	call   801b85 <_panic>

00801b4b <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	68 f6 25 80 00       	push   $0x8025f6
  801b59:	68 35 01 00 00       	push   $0x135
  801b5e:	68 0a 26 80 00       	push   $0x80260a
  801b63:	e8 1d 00 00 00       	call   801b85 <_panic>

00801b68 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	68 f6 25 80 00       	push   $0x8025f6
  801b76:	68 3b 01 00 00       	push   $0x13b
  801b7b:	68 0a 26 80 00       	push   $0x80260a
  801b80:	e8 00 00 00 00       	call   801b85 <_panic>

00801b85 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801b8b:	8d 45 10             	lea    0x10(%ebp),%eax
  801b8e:	83 c0 04             	add    $0x4,%eax
  801b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801b94:	a1 24 30 80 00       	mov    0x803024,%eax
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	74 16                	je     801bb3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801b9d:	a1 24 30 80 00       	mov    0x803024,%eax
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	50                   	push   %eax
  801ba6:	68 18 26 80 00       	push   $0x802618
  801bab:	e8 e4 ea ff ff       	call   800694 <cprintf>
  801bb0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801bb3:	a1 00 30 80 00       	mov    0x803000,%eax
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	68 1d 26 80 00       	push   $0x80261d
  801bc4:	e8 cb ea ff ff       	call   800694 <cprintf>
  801bc9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bcf:	83 ec 08             	sub    $0x8,%esp
  801bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd5:	50                   	push   %eax
  801bd6:	e8 4e ea ff ff       	call   800629 <vcprintf>
  801bdb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801bde:	83 ec 08             	sub    $0x8,%esp
  801be1:	6a 00                	push   $0x0
  801be3:	68 39 26 80 00       	push   $0x802639
  801be8:	e8 3c ea ff ff       	call   800629 <vcprintf>
  801bed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801bf0:	e8 bd e9 ff ff       	call   8005b2 <exit>

	// should not return here
	while (1) ;
  801bf5:	eb fe                	jmp    801bf5 <_panic+0x70>

00801bf7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801bfd:	a1 04 30 80 00       	mov    0x803004,%eax
  801c02:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0b:	39 c2                	cmp    %eax,%edx
  801c0d:	74 14                	je     801c23 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 3c 26 80 00       	push   $0x80263c
  801c17:	6a 26                	push   $0x26
  801c19:	68 88 26 80 00       	push   $0x802688
  801c1e:	e8 62 ff ff ff       	call   801b85 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801c2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801c31:	e9 c5 00 00 00       	jmp    801cfb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	01 d0                	add    %edx,%eax
  801c45:	8b 00                	mov    (%eax),%eax
  801c47:	85 c0                	test   %eax,%eax
  801c49:	75 08                	jne    801c53 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801c4b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801c4e:	e9 a5 00 00 00       	jmp    801cf8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801c53:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c5a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c61:	eb 69                	jmp    801ccc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801c63:	a1 04 30 80 00       	mov    0x803004,%eax
  801c68:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	01 c0                	add    %eax,%eax
  801c75:	01 d0                	add    %edx,%eax
  801c77:	c1 e0 03             	shl    $0x3,%eax
  801c7a:	01 c8                	add    %ecx,%eax
  801c7c:	8a 40 04             	mov    0x4(%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	75 46                	jne    801cc9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c83:	a1 04 30 80 00       	mov    0x803004,%eax
  801c88:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c91:	89 d0                	mov    %edx,%eax
  801c93:	01 c0                	add    %eax,%eax
  801c95:	01 d0                	add    %edx,%eax
  801c97:	c1 e0 03             	shl    $0x3,%eax
  801c9a:	01 c8                	add    %ecx,%eax
  801c9c:	8b 00                	mov    (%eax),%eax
  801c9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ca1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ca4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ca9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	01 c8                	add    %ecx,%eax
  801cba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801cbc:	39 c2                	cmp    %eax,%edx
  801cbe:	75 09                	jne    801cc9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801cc0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801cc7:	eb 15                	jmp    801cde <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cc9:	ff 45 e8             	incl   -0x18(%ebp)
  801ccc:	a1 04 30 80 00       	mov    0x803004,%eax
  801cd1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cda:	39 c2                	cmp    %eax,%edx
  801cdc:	77 85                	ja     801c63 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801cde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ce2:	75 14                	jne    801cf8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	68 94 26 80 00       	push   $0x802694
  801cec:	6a 3a                	push   $0x3a
  801cee:	68 88 26 80 00       	push   $0x802688
  801cf3:	e8 8d fe ff ff       	call   801b85 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801cf8:	ff 45 f0             	incl   -0x10(%ebp)
  801cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d01:	0f 8c 2f ff ff ff    	jl     801c36 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801d07:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d15:	eb 26                	jmp    801d3d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801d17:	a1 04 30 80 00       	mov    0x803004,%eax
  801d1c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801d22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d25:	89 d0                	mov    %edx,%eax
  801d27:	01 c0                	add    %eax,%eax
  801d29:	01 d0                	add    %edx,%eax
  801d2b:	c1 e0 03             	shl    $0x3,%eax
  801d2e:	01 c8                	add    %ecx,%eax
  801d30:	8a 40 04             	mov    0x4(%eax),%al
  801d33:	3c 01                	cmp    $0x1,%al
  801d35:	75 03                	jne    801d3a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801d37:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d3a:	ff 45 e0             	incl   -0x20(%ebp)
  801d3d:	a1 04 30 80 00       	mov    0x803004,%eax
  801d42:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4b:	39 c2                	cmp    %eax,%edx
  801d4d:	77 c8                	ja     801d17 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d55:	74 14                	je     801d6b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	68 e8 26 80 00       	push   $0x8026e8
  801d5f:	6a 44                	push   $0x44
  801d61:	68 88 26 80 00       	push   $0x802688
  801d66:	e8 1a fe ff ff       	call   801b85 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801d6b:	90                   	nop
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    
  801d6e:	66 90                	xchg   %ax,%ax

00801d70 <__udivdi3>:
  801d70:	55                   	push   %ebp
  801d71:	57                   	push   %edi
  801d72:	56                   	push   %esi
  801d73:	53                   	push   %ebx
  801d74:	83 ec 1c             	sub    $0x1c,%esp
  801d77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d87:	89 ca                	mov    %ecx,%edx
  801d89:	89 f8                	mov    %edi,%eax
  801d8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d8f:	85 f6                	test   %esi,%esi
  801d91:	75 2d                	jne    801dc0 <__udivdi3+0x50>
  801d93:	39 cf                	cmp    %ecx,%edi
  801d95:	77 65                	ja     801dfc <__udivdi3+0x8c>
  801d97:	89 fd                	mov    %edi,%ebp
  801d99:	85 ff                	test   %edi,%edi
  801d9b:	75 0b                	jne    801da8 <__udivdi3+0x38>
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	31 d2                	xor    %edx,%edx
  801da4:	f7 f7                	div    %edi
  801da6:	89 c5                	mov    %eax,%ebp
  801da8:	31 d2                	xor    %edx,%edx
  801daa:	89 c8                	mov    %ecx,%eax
  801dac:	f7 f5                	div    %ebp
  801dae:	89 c1                	mov    %eax,%ecx
  801db0:	89 d8                	mov    %ebx,%eax
  801db2:	f7 f5                	div    %ebp
  801db4:	89 cf                	mov    %ecx,%edi
  801db6:	89 fa                	mov    %edi,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	39 ce                	cmp    %ecx,%esi
  801dc2:	77 28                	ja     801dec <__udivdi3+0x7c>
  801dc4:	0f bd fe             	bsr    %esi,%edi
  801dc7:	83 f7 1f             	xor    $0x1f,%edi
  801dca:	75 40                	jne    801e0c <__udivdi3+0x9c>
  801dcc:	39 ce                	cmp    %ecx,%esi
  801dce:	72 0a                	jb     801dda <__udivdi3+0x6a>
  801dd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801dd4:	0f 87 9e 00 00 00    	ja     801e78 <__udivdi3+0x108>
  801dda:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddf:	89 fa                	mov    %edi,%edx
  801de1:	83 c4 1c             	add    $0x1c,%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    
  801de9:	8d 76 00             	lea    0x0(%esi),%esi
  801dec:	31 ff                	xor    %edi,%edi
  801dee:	31 c0                	xor    %eax,%eax
  801df0:	89 fa                	mov    %edi,%edx
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	89 d8                	mov    %ebx,%eax
  801dfe:	f7 f7                	div    %edi
  801e00:	31 ff                	xor    %edi,%edi
  801e02:	89 fa                	mov    %edi,%edx
  801e04:	83 c4 1c             	add    $0x1c,%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5f                   	pop    %edi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    
  801e0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e11:	89 eb                	mov    %ebp,%ebx
  801e13:	29 fb                	sub    %edi,%ebx
  801e15:	89 f9                	mov    %edi,%ecx
  801e17:	d3 e6                	shl    %cl,%esi
  801e19:	89 c5                	mov    %eax,%ebp
  801e1b:	88 d9                	mov    %bl,%cl
  801e1d:	d3 ed                	shr    %cl,%ebp
  801e1f:	89 e9                	mov    %ebp,%ecx
  801e21:	09 f1                	or     %esi,%ecx
  801e23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e27:	89 f9                	mov    %edi,%ecx
  801e29:	d3 e0                	shl    %cl,%eax
  801e2b:	89 c5                	mov    %eax,%ebp
  801e2d:	89 d6                	mov    %edx,%esi
  801e2f:	88 d9                	mov    %bl,%cl
  801e31:	d3 ee                	shr    %cl,%esi
  801e33:	89 f9                	mov    %edi,%ecx
  801e35:	d3 e2                	shl    %cl,%edx
  801e37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e3b:	88 d9                	mov    %bl,%cl
  801e3d:	d3 e8                	shr    %cl,%eax
  801e3f:	09 c2                	or     %eax,%edx
  801e41:	89 d0                	mov    %edx,%eax
  801e43:	89 f2                	mov    %esi,%edx
  801e45:	f7 74 24 0c          	divl   0xc(%esp)
  801e49:	89 d6                	mov    %edx,%esi
  801e4b:	89 c3                	mov    %eax,%ebx
  801e4d:	f7 e5                	mul    %ebp
  801e4f:	39 d6                	cmp    %edx,%esi
  801e51:	72 19                	jb     801e6c <__udivdi3+0xfc>
  801e53:	74 0b                	je     801e60 <__udivdi3+0xf0>
  801e55:	89 d8                	mov    %ebx,%eax
  801e57:	31 ff                	xor    %edi,%edi
  801e59:	e9 58 ff ff ff       	jmp    801db6 <__udivdi3+0x46>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e64:	89 f9                	mov    %edi,%ecx
  801e66:	d3 e2                	shl    %cl,%edx
  801e68:	39 c2                	cmp    %eax,%edx
  801e6a:	73 e9                	jae    801e55 <__udivdi3+0xe5>
  801e6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e6f:	31 ff                	xor    %edi,%edi
  801e71:	e9 40 ff ff ff       	jmp    801db6 <__udivdi3+0x46>
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	31 c0                	xor    %eax,%eax
  801e7a:	e9 37 ff ff ff       	jmp    801db6 <__udivdi3+0x46>
  801e7f:	90                   	nop

00801e80 <__umoddi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 1c             	sub    $0x1c,%esp
  801e87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e9f:	89 f3                	mov    %esi,%ebx
  801ea1:	89 fa                	mov    %edi,%edx
  801ea3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ea7:	89 34 24             	mov    %esi,(%esp)
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	75 1a                	jne    801ec8 <__umoddi3+0x48>
  801eae:	39 f7                	cmp    %esi,%edi
  801eb0:	0f 86 a2 00 00 00    	jbe    801f58 <__umoddi3+0xd8>
  801eb6:	89 c8                	mov    %ecx,%eax
  801eb8:	89 f2                	mov    %esi,%edx
  801eba:	f7 f7                	div    %edi
  801ebc:	89 d0                	mov    %edx,%eax
  801ebe:	31 d2                	xor    %edx,%edx
  801ec0:	83 c4 1c             	add    $0x1c,%esp
  801ec3:	5b                   	pop    %ebx
  801ec4:	5e                   	pop    %esi
  801ec5:	5f                   	pop    %edi
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    
  801ec8:	39 f0                	cmp    %esi,%eax
  801eca:	0f 87 ac 00 00 00    	ja     801f7c <__umoddi3+0xfc>
  801ed0:	0f bd e8             	bsr    %eax,%ebp
  801ed3:	83 f5 1f             	xor    $0x1f,%ebp
  801ed6:	0f 84 ac 00 00 00    	je     801f88 <__umoddi3+0x108>
  801edc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ee1:	29 ef                	sub    %ebp,%edi
  801ee3:	89 fe                	mov    %edi,%esi
  801ee5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ee9:	89 e9                	mov    %ebp,%ecx
  801eeb:	d3 e0                	shl    %cl,%eax
  801eed:	89 d7                	mov    %edx,%edi
  801eef:	89 f1                	mov    %esi,%ecx
  801ef1:	d3 ef                	shr    %cl,%edi
  801ef3:	09 c7                	or     %eax,%edi
  801ef5:	89 e9                	mov    %ebp,%ecx
  801ef7:	d3 e2                	shl    %cl,%edx
  801ef9:	89 14 24             	mov    %edx,(%esp)
  801efc:	89 d8                	mov    %ebx,%eax
  801efe:	d3 e0                	shl    %cl,%eax
  801f00:	89 c2                	mov    %eax,%edx
  801f02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f06:	d3 e0                	shl    %cl,%eax
  801f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f10:	89 f1                	mov    %esi,%ecx
  801f12:	d3 e8                	shr    %cl,%eax
  801f14:	09 d0                	or     %edx,%eax
  801f16:	d3 eb                	shr    %cl,%ebx
  801f18:	89 da                	mov    %ebx,%edx
  801f1a:	f7 f7                	div    %edi
  801f1c:	89 d3                	mov    %edx,%ebx
  801f1e:	f7 24 24             	mull   (%esp)
  801f21:	89 c6                	mov    %eax,%esi
  801f23:	89 d1                	mov    %edx,%ecx
  801f25:	39 d3                	cmp    %edx,%ebx
  801f27:	0f 82 87 00 00 00    	jb     801fb4 <__umoddi3+0x134>
  801f2d:	0f 84 91 00 00 00    	je     801fc4 <__umoddi3+0x144>
  801f33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f37:	29 f2                	sub    %esi,%edx
  801f39:	19 cb                	sbb    %ecx,%ebx
  801f3b:	89 d8                	mov    %ebx,%eax
  801f3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f41:	d3 e0                	shl    %cl,%eax
  801f43:	89 e9                	mov    %ebp,%ecx
  801f45:	d3 ea                	shr    %cl,%edx
  801f47:	09 d0                	or     %edx,%eax
  801f49:	89 e9                	mov    %ebp,%ecx
  801f4b:	d3 eb                	shr    %cl,%ebx
  801f4d:	89 da                	mov    %ebx,%edx
  801f4f:	83 c4 1c             	add    $0x1c,%esp
  801f52:	5b                   	pop    %ebx
  801f53:	5e                   	pop    %esi
  801f54:	5f                   	pop    %edi
  801f55:	5d                   	pop    %ebp
  801f56:	c3                   	ret    
  801f57:	90                   	nop
  801f58:	89 fd                	mov    %edi,%ebp
  801f5a:	85 ff                	test   %edi,%edi
  801f5c:	75 0b                	jne    801f69 <__umoddi3+0xe9>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	31 d2                	xor    %edx,%edx
  801f65:	f7 f7                	div    %edi
  801f67:	89 c5                	mov    %eax,%ebp
  801f69:	89 f0                	mov    %esi,%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	f7 f5                	div    %ebp
  801f6f:	89 c8                	mov    %ecx,%eax
  801f71:	f7 f5                	div    %ebp
  801f73:	89 d0                	mov    %edx,%eax
  801f75:	e9 44 ff ff ff       	jmp    801ebe <__umoddi3+0x3e>
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	89 c8                	mov    %ecx,%eax
  801f7e:	89 f2                	mov    %esi,%edx
  801f80:	83 c4 1c             	add    $0x1c,%esp
  801f83:	5b                   	pop    %ebx
  801f84:	5e                   	pop    %esi
  801f85:	5f                   	pop    %edi
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    
  801f88:	3b 04 24             	cmp    (%esp),%eax
  801f8b:	72 06                	jb     801f93 <__umoddi3+0x113>
  801f8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f91:	77 0f                	ja     801fa2 <__umoddi3+0x122>
  801f93:	89 f2                	mov    %esi,%edx
  801f95:	29 f9                	sub    %edi,%ecx
  801f97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f9b:	89 14 24             	mov    %edx,(%esp)
  801f9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fa2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fa6:	8b 14 24             	mov    (%esp),%edx
  801fa9:	83 c4 1c             	add    $0x1c,%esp
  801fac:	5b                   	pop    %ebx
  801fad:	5e                   	pop    %esi
  801fae:	5f                   	pop    %edi
  801faf:	5d                   	pop    %ebp
  801fb0:	c3                   	ret    
  801fb1:	8d 76 00             	lea    0x0(%esi),%esi
  801fb4:	2b 04 24             	sub    (%esp),%eax
  801fb7:	19 fa                	sbb    %edi,%edx
  801fb9:	89 d1                	mov    %edx,%ecx
  801fbb:	89 c6                	mov    %eax,%esi
  801fbd:	e9 71 ff ff ff       	jmp    801f33 <__umoddi3+0xb3>
  801fc2:	66 90                	xchg   %ax,%ax
  801fc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fc8:	72 ea                	jb     801fb4 <__umoddi3+0x134>
  801fca:	89 d9                	mov    %ebx,%ecx
  801fcc:	e9 62 ff ff ff       	jmp    801f33 <__umoddi3+0xb3>
