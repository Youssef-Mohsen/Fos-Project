
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
  80003e:	e8 4f 1b 00 00       	call   801b92 <sys_getparentenvid>
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
  800057:	68 a0 3d 80 00       	push   $0x803da0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 7e 17 00 00       	call   8017e2 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 a4 3d 80 00       	push   $0x803da4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 68 17 00 00       	call   8017e2 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 ac 3d 80 00       	push   $0x803dac
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 4b 17 00 00       	call   8017e2 <sget>
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
  8000ab:	68 ba 3d 80 00       	push   $0x803dba
  8000b0:	e8 9e 16 00 00       	call   801753 <smalloc>
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
  80010c:	68 c9 3d 80 00       	push   $0x803dc9
  800111:	e8 70 05 00 00       	call   800686 <cprintf>
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
  8001a2:	68 e5 3d 80 00       	push   $0x803de5
  8001a7:	e8 da 04 00 00       	call   800686 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 e7 3d 80 00       	push   $0x803de7
  8001c9:	e8 b8 04 00 00       	call   800686 <cprintf>
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
  8001f2:	68 ec 3d 80 00       	push   $0x803dec
  8001f7:	e8 8a 04 00 00       	call   800686 <cprintf>
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
  800298:	e8 99 11 00 00       	call   801436 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 84 11 00 00       	call   801436 <malloc>
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
  80045a:	e8 f6 11 00 00       	call   801655 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 e8 11 00 00       	call   801655 <free>
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
  800479:	e8 fb 16 00 00       	call   801b79 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800492:	01 c8                	add    %ecx,%eax
  800494:	01 c0                	add    %eax,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80049f:	01 c8                	add    %ecx,%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b2:	8a 40 20             	mov    0x20(%eax),%al
  8004b5:	84 c0                	test   %al,%al
  8004b7:	74 0d                	je     8004c6 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8004b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004be:	83 c0 20             	add    $0x20,%eax
  8004c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004ca:	7e 0a                	jle    8004d6 <libmain+0x63>
		binaryname = argv[0];
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	ff 75 0c             	pushl  0xc(%ebp)
  8004dc:	ff 75 08             	pushl  0x8(%ebp)
  8004df:	e8 54 fb ff ff       	call   800038 <_main>
  8004e4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004e7:	e8 11 14 00 00       	call   8018fd <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 08 3e 80 00       	push   $0x803e08
  8004f4:	e8 8d 01 00 00       	call   800686 <cprintf>
  8004f9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800501:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800507:	a1 20 50 80 00       	mov    0x805020,%eax
  80050c:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	52                   	push   %edx
  800516:	50                   	push   %eax
  800517:	68 30 3e 80 00       	push   $0x803e30
  80051c:	e8 65 01 00 00       	call   800686 <cprintf>
  800521:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800524:	a1 20 50 80 00       	mov    0x805020,%eax
  800529:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80052f:	a1 20 50 80 00       	mov    0x805020,%eax
  800534:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80053a:	a1 20 50 80 00       	mov    0x805020,%eax
  80053f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800545:	51                   	push   %ecx
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	68 58 3e 80 00       	push   $0x803e58
  80054d:	e8 34 01 00 00       	call   800686 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 b0 3e 80 00       	push   $0x803eb0
  800569:	e8 18 01 00 00       	call   800686 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 08 3e 80 00       	push   $0x803e08
  800579:	e8 08 01 00 00       	call   800686 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800581:	e8 91 13 00 00       	call   801917 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800586:	e8 19 00 00 00       	call   8005a4 <exit>
}
  80058b:	90                   	nop
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	6a 00                	push   $0x0
  800599:	e8 a7 15 00 00       	call   801b45 <sys_destroy_env>
  80059e:	83 c4 10             	add    $0x10,%esp
}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <exit>:

void
exit(void)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005aa:	e8 fc 15 00 00       	call   801bab <sys_exit_env>
}
  8005af:	90                   	nop
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8005c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c3:	89 0a                	mov    %ecx,(%edx)
  8005c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c8:	88 d1                	mov    %dl,%cl
  8005ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005cd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005db:	75 2c                	jne    800609 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005dd:	a0 28 50 80 00       	mov    0x805028,%al
  8005e2:	0f b6 c0             	movzbl %al,%eax
  8005e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e8:	8b 12                	mov    (%edx),%edx
  8005ea:	89 d1                	mov    %edx,%ecx
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	83 c2 08             	add    $0x8,%edx
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	50                   	push   %eax
  8005f6:	51                   	push   %ecx
  8005f7:	52                   	push   %edx
  8005f8:	e8 be 12 00 00       	call   8018bb <sys_cputs>
  8005fd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800600:	8b 45 0c             	mov    0xc(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060c:	8b 40 04             	mov    0x4(%eax),%eax
  80060f:	8d 50 01             	lea    0x1(%eax),%edx
  800612:	8b 45 0c             	mov    0xc(%ebp),%eax
  800615:	89 50 04             	mov    %edx,0x4(%eax)
}
  800618:	90                   	nop
  800619:	c9                   	leave  
  80061a:	c3                   	ret    

0080061b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80061b:	55                   	push   %ebp
  80061c:	89 e5                	mov    %esp,%ebp
  80061e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800624:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80062b:	00 00 00 
	b.cnt = 0;
  80062e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800635:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	ff 75 08             	pushl  0x8(%ebp)
  80063e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800644:	50                   	push   %eax
  800645:	68 b2 05 80 00       	push   $0x8005b2
  80064a:	e8 11 02 00 00       	call   800860 <vprintfmt>
  80064f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800652:	a0 28 50 80 00       	mov    0x805028,%al
  800657:	0f b6 c0             	movzbl %al,%eax
  80065a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	50                   	push   %eax
  800664:	52                   	push   %edx
  800665:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066b:	83 c0 08             	add    $0x8,%eax
  80066e:	50                   	push   %eax
  80066f:	e8 47 12 00 00       	call   8018bb <sys_cputs>
  800674:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800677:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  80067e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800684:	c9                   	leave  
  800685:	c3                   	ret    

00800686 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80068c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800693:	8d 45 0c             	lea    0xc(%ebp),%eax
  800696:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	e8 73 ff ff ff       	call   80061b <vcprintf>
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006b9:	e8 3f 12 00 00       	call   8018fd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cd:	50                   	push   %eax
  8006ce:	e8 48 ff ff ff       	call   80061b <vcprintf>
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006d9:	e8 39 12 00 00       	call   801917 <sys_unlock_cons>
	return cnt;
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e1:	c9                   	leave  
  8006e2:	c3                   	ret    

008006e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	53                   	push   %ebx
  8006e7:	83 ec 14             	sub    $0x14,%esp
  8006ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800701:	77 55                	ja     800758 <printnum+0x75>
  800703:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800706:	72 05                	jb     80070d <printnum+0x2a>
  800708:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80070b:	77 4b                	ja     800758 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800710:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800713:	8b 45 18             	mov    0x18(%ebp),%eax
  800716:	ba 00 00 00 00       	mov    $0x0,%edx
  80071b:	52                   	push   %edx
  80071c:	50                   	push   %eax
  80071d:	ff 75 f4             	pushl  -0xc(%ebp)
  800720:	ff 75 f0             	pushl  -0x10(%ebp)
  800723:	e8 14 34 00 00       	call   803b3c <__udivdi3>
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	ff 75 20             	pushl  0x20(%ebp)
  800731:	53                   	push   %ebx
  800732:	ff 75 18             	pushl  0x18(%ebp)
  800735:	52                   	push   %edx
  800736:	50                   	push   %eax
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	ff 75 08             	pushl  0x8(%ebp)
  80073d:	e8 a1 ff ff ff       	call   8006e3 <printnum>
  800742:	83 c4 20             	add    $0x20,%esp
  800745:	eb 1a                	jmp    800761 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	ff 75 20             	pushl  0x20(%ebp)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	ff d0                	call   *%eax
  800755:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800758:	ff 4d 1c             	decl   0x1c(%ebp)
  80075b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075f:	7f e6                	jg     800747 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800761:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800764:	bb 00 00 00 00       	mov    $0x0,%ebx
  800769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076f:	53                   	push   %ebx
  800770:	51                   	push   %ecx
  800771:	52                   	push   %edx
  800772:	50                   	push   %eax
  800773:	e8 d4 34 00 00       	call   803c4c <__umoddi3>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	05 f4 40 80 00       	add    $0x8040f4,%eax
  800780:	8a 00                	mov    (%eax),%al
  800782:	0f be c0             	movsbl %al,%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	ff d0                	call   *%eax
  800791:	83 c4 10             	add    $0x10,%esp
}
  800794:	90                   	nop
  800795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a1:	7e 1c                	jle    8007bf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	8d 50 08             	lea    0x8(%eax),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	89 10                	mov    %edx,(%eax)
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	83 e8 08             	sub    $0x8,%eax
  8007b8:	8b 50 04             	mov    0x4(%eax),%edx
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	eb 40                	jmp    8007ff <getuint+0x65>
	else if (lflag)
  8007bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c3:	74 1e                	je     8007e3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 04             	lea    0x4(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 04             	sub    $0x4,%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e1:	eb 1c                	jmp    8007ff <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	8d 50 04             	lea    0x4(%eax),%edx
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	89 10                	mov    %edx,(%eax)
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	83 e8 04             	sub    $0x4,%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800804:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800808:	7e 1c                	jle    800826 <getint+0x25>
		return va_arg(*ap, long long);
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	8d 50 08             	lea    0x8(%eax),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	89 10                	mov    %edx,(%eax)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 e8 08             	sub    $0x8,%eax
  80081f:	8b 50 04             	mov    0x4(%eax),%edx
  800822:	8b 00                	mov    (%eax),%eax
  800824:	eb 38                	jmp    80085e <getint+0x5d>
	else if (lflag)
  800826:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80082a:	74 1a                	je     800846 <getint+0x45>
		return va_arg(*ap, long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 04             	lea    0x4(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	99                   	cltd   
  800844:	eb 18                	jmp    80085e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	8d 50 04             	lea    0x4(%eax),%edx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	89 10                	mov    %edx,(%eax)
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	99                   	cltd   
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	56                   	push   %esi
  800864:	53                   	push   %ebx
  800865:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800868:	eb 17                	jmp    800881 <vprintfmt+0x21>
			if (ch == '\0')
  80086a:	85 db                	test   %ebx,%ebx
  80086c:	0f 84 c1 03 00 00    	je     800c33 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	53                   	push   %ebx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800881:	8b 45 10             	mov    0x10(%ebp),%eax
  800884:	8d 50 01             	lea    0x1(%eax),%edx
  800887:	89 55 10             	mov    %edx,0x10(%ebp)
  80088a:	8a 00                	mov    (%eax),%al
  80088c:	0f b6 d8             	movzbl %al,%ebx
  80088f:	83 fb 25             	cmp    $0x25,%ebx
  800892:	75 d6                	jne    80086a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800894:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800898:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b7:	8d 50 01             	lea    0x1(%eax),%edx
  8008ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8008bd:	8a 00                	mov    (%eax),%al
  8008bf:	0f b6 d8             	movzbl %al,%ebx
  8008c2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c5:	83 f8 5b             	cmp    $0x5b,%eax
  8008c8:	0f 87 3d 03 00 00    	ja     800c0b <vprintfmt+0x3ab>
  8008ce:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
  8008d5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008db:	eb d7                	jmp    8008b4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008dd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008e1:	eb d1                	jmp    8008b4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ed:	89 d0                	mov    %edx,%eax
  8008ef:	c1 e0 02             	shl    $0x2,%eax
  8008f2:	01 d0                	add    %edx,%eax
  8008f4:	01 c0                	add    %eax,%eax
  8008f6:	01 d8                	add    %ebx,%eax
  8008f8:	83 e8 30             	sub    $0x30,%eax
  8008fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800901:	8a 00                	mov    (%eax),%al
  800903:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800906:	83 fb 2f             	cmp    $0x2f,%ebx
  800909:	7e 3e                	jle    800949 <vprintfmt+0xe9>
  80090b:	83 fb 39             	cmp    $0x39,%ebx
  80090e:	7f 39                	jg     800949 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800910:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800913:	eb d5                	jmp    8008ea <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 c0 04             	add    $0x4,%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	83 e8 04             	sub    $0x4,%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800929:	eb 1f                	jmp    80094a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80092b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092f:	79 83                	jns    8008b4 <vprintfmt+0x54>
				width = 0;
  800931:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800938:	e9 77 ff ff ff       	jmp    8008b4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800944:	e9 6b ff ff ff       	jmp    8008b4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800949:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	0f 89 60 ff ff ff    	jns    8008b4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800954:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80095a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800961:	e9 4e ff ff ff       	jmp    8008b4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800966:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800969:	e9 46 ff ff ff       	jmp    8008b4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 c0 04             	add    $0x4,%eax
  800974:	89 45 14             	mov    %eax,0x14(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	83 e8 04             	sub    $0x4,%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
			break;
  80098e:	e9 9b 02 00 00       	jmp    800c2e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	83 c0 04             	add    $0x4,%eax
  800999:	89 45 14             	mov    %eax,0x14(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 e8 04             	sub    $0x4,%eax
  8009a2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a4:	85 db                	test   %ebx,%ebx
  8009a6:	79 02                	jns    8009aa <vprintfmt+0x14a>
				err = -err;
  8009a8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009aa:	83 fb 64             	cmp    $0x64,%ebx
  8009ad:	7f 0b                	jg     8009ba <vprintfmt+0x15a>
  8009af:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 19                	jne    8009d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	53                   	push   %ebx
  8009bb:	68 05 41 80 00       	push   $0x804105
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 70 02 00 00       	call   800c3b <printfmt>
  8009cb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ce:	e9 5b 02 00 00       	jmp    800c2e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d3:	56                   	push   %esi
  8009d4:	68 0e 41 80 00       	push   $0x80410e
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	ff 75 08             	pushl  0x8(%ebp)
  8009df:	e8 57 02 00 00       	call   800c3b <printfmt>
  8009e4:	83 c4 10             	add    $0x10,%esp
			break;
  8009e7:	e9 42 02 00 00       	jmp    800c2e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	83 c0 04             	add    $0x4,%eax
  8009f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	83 e8 04             	sub    $0x4,%eax
  8009fb:	8b 30                	mov    (%eax),%esi
  8009fd:	85 f6                	test   %esi,%esi
  8009ff:	75 05                	jne    800a06 <vprintfmt+0x1a6>
				p = "(null)";
  800a01:	be 11 41 80 00       	mov    $0x804111,%esi
			if (width > 0 && padc != '-')
  800a06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0a:	7e 6d                	jle    800a79 <vprintfmt+0x219>
  800a0c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a10:	74 67                	je     800a79 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	50                   	push   %eax
  800a19:	56                   	push   %esi
  800a1a:	e8 1e 03 00 00       	call   800d3d <strnlen>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a25:	eb 16                	jmp    800a3d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a27:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	50                   	push   %eax
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a41:	7f e4                	jg     800a27 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a43:	eb 34                	jmp    800a79 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a49:	74 1c                	je     800a67 <vprintfmt+0x207>
  800a4b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4e:	7e 05                	jle    800a55 <vprintfmt+0x1f5>
  800a50:	83 fb 7e             	cmp    $0x7e,%ebx
  800a53:	7e 12                	jle    800a67 <vprintfmt+0x207>
					putch('?', putdat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	6a 3f                	push   $0x3f
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	ff d0                	call   *%eax
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	eb 0f                	jmp    800a76 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	53                   	push   %ebx
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	ff d0                	call   *%eax
  800a73:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a76:	ff 4d e4             	decl   -0x1c(%ebp)
  800a79:	89 f0                	mov    %esi,%eax
  800a7b:	8d 70 01             	lea    0x1(%eax),%esi
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	0f be d8             	movsbl %al,%ebx
  800a83:	85 db                	test   %ebx,%ebx
  800a85:	74 24                	je     800aab <vprintfmt+0x24b>
  800a87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a8b:	78 b8                	js     800a45 <vprintfmt+0x1e5>
  800a8d:	ff 4d e0             	decl   -0x20(%ebp)
  800a90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a94:	79 af                	jns    800a45 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a96:	eb 13                	jmp    800aab <vprintfmt+0x24b>
				putch(' ', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 20                	push   $0x20
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa8:	ff 4d e4             	decl   -0x1c(%ebp)
  800aab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aaf:	7f e7                	jg     800a98 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ab1:	e9 78 01 00 00       	jmp    800c2e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 e8             	pushl  -0x18(%ebp)
  800abc:	8d 45 14             	lea    0x14(%ebp),%eax
  800abf:	50                   	push   %eax
  800ac0:	e8 3c fd ff ff       	call   800801 <getint>
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad4:	85 d2                	test   %edx,%edx
  800ad6:	79 23                	jns    800afb <vprintfmt+0x29b>
				putch('-', putdat);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	6a 2d                	push   $0x2d
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aee:	f7 d8                	neg    %eax
  800af0:	83 d2 00             	adc    $0x0,%edx
  800af3:	f7 da                	neg    %edx
  800af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800afb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b02:	e9 bc 00 00 00       	jmp    800bc3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 84 fc ff ff       	call   80079a <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b26:	e9 98 00 00 00       	jmp    800bc3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 58                	push   $0x58
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 58                	push   $0x58
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	6a 58                	push   $0x58
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	ff d0                	call   *%eax
  800b58:	83 c4 10             	add    $0x10,%esp
			break;
  800b5b:	e9 ce 00 00 00       	jmp    800c2e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	6a 30                	push   $0x30
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	6a 78                	push   $0x78
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	ff d0                	call   *%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	83 c0 04             	add    $0x4,%eax
  800b86:	89 45 14             	mov    %eax,0x14(%ebp)
  800b89:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8c:	83 e8 04             	sub    $0x4,%eax
  800b8f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b9b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ba2:	eb 1f                	jmp    800bc3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 e8             	pushl  -0x18(%ebp)
  800baa:	8d 45 14             	lea    0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	e8 e7 fb ff ff       	call   80079a <getuint>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bbc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bca:	83 ec 04             	sub    $0x4,%esp
  800bcd:	52                   	push   %edx
  800bce:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	ff 75 08             	pushl  0x8(%ebp)
  800bde:	e8 00 fb ff ff       	call   8006e3 <printnum>
  800be3:	83 c4 20             	add    $0x20,%esp
			break;
  800be6:	eb 46                	jmp    800c2e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	53                   	push   %ebx
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	ff d0                	call   *%eax
  800bf4:	83 c4 10             	add    $0x10,%esp
			break;
  800bf7:	eb 35                	jmp    800c2e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bf9:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800c00:	eb 2c                	jmp    800c2e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c02:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800c09:	eb 23                	jmp    800c2e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 25                	push   $0x25
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c1b:	ff 4d 10             	decl   0x10(%ebp)
  800c1e:	eb 03                	jmp    800c23 <vprintfmt+0x3c3>
  800c20:	ff 4d 10             	decl   0x10(%ebp)
  800c23:	8b 45 10             	mov    0x10(%ebp),%eax
  800c26:	48                   	dec    %eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	3c 25                	cmp    $0x25,%al
  800c2b:	75 f3                	jne    800c20 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c2d:	90                   	nop
		}
	}
  800c2e:	e9 35 fc ff ff       	jmp    800868 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c33:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c41:	8d 45 10             	lea    0x10(%ebp),%eax
  800c44:	83 c0 04             	add    $0x4,%eax
  800c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c50:	50                   	push   %eax
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	ff 75 08             	pushl  0x8(%ebp)
  800c57:	e8 04 fc ff ff       	call   800860 <vprintfmt>
  800c5c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c5f:	90                   	nop
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8b 40 08             	mov    0x8(%eax),%eax
  800c6b:	8d 50 01             	lea    0x1(%eax),%edx
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	8b 10                	mov    (%eax),%edx
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8b 40 04             	mov    0x4(%eax),%eax
  800c7f:	39 c2                	cmp    %eax,%edx
  800c81:	73 12                	jae    800c95 <sprintputch+0x33>
		*b->buf++ = ch;
  800c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	8d 48 01             	lea    0x1(%eax),%ecx
  800c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8e:	89 0a                	mov    %ecx,(%edx)
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	88 10                	mov    %dl,(%eax)
}
  800c95:	90                   	nop
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	01 d0                	add    %edx,%eax
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cbd:	74 06                	je     800cc5 <vsnprintf+0x2d>
  800cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc3:	7f 07                	jg     800ccc <vsnprintf+0x34>
		return -E_INVAL;
  800cc5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cca:	eb 20                	jmp    800cec <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ccc:	ff 75 14             	pushl  0x14(%ebp)
  800ccf:	ff 75 10             	pushl  0x10(%ebp)
  800cd2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cd5:	50                   	push   %eax
  800cd6:	68 62 0c 80 00       	push   $0x800c62
  800cdb:	e8 80 fb ff ff       	call   800860 <vprintfmt>
  800ce0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cf4:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf7:	83 c0 04             	add    $0x4,%eax
  800cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	ff 75 f4             	pushl  -0xc(%ebp)
  800d03:	50                   	push   %eax
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	ff 75 08             	pushl  0x8(%ebp)
  800d0a:	e8 89 ff ff ff       	call   800c98 <vsnprintf>
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d27:	eb 06                	jmp    800d2f <strlen+0x15>
		n++;
  800d29:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2c:	ff 45 08             	incl   0x8(%ebp)
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	75 f1                	jne    800d29 <strlen+0xf>
		n++;
	return n;
  800d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4a:	eb 09                	jmp    800d55 <strnlen+0x18>
		n++;
  800d4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4f:	ff 45 08             	incl   0x8(%ebp)
  800d52:	ff 4d 0c             	decl   0xc(%ebp)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 09                	je     800d64 <strnlen+0x27>
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	84 c0                	test   %al,%al
  800d62:	75 e8                	jne    800d4c <strnlen+0xf>
		n++;
	return n;
  800d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d75:	90                   	nop
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e4                	jne    800d76 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800da3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800daa:	eb 1f                	jmp    800dcb <strncpy+0x34>
		*dst++ = *src;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8d 50 01             	lea    0x1(%eax),%edx
  800db2:	89 55 08             	mov    %edx,0x8(%ebp)
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	8a 12                	mov    (%edx),%dl
  800dba:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	84 c0                	test   %al,%al
  800dc3:	74 03                	je     800dc8 <strncpy+0x31>
			src++;
  800dc5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dc8:	ff 45 fc             	incl   -0x4(%ebp)
  800dcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dce:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd1:	72 d9                	jb     800dac <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800de4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de8:	74 30                	je     800e1a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dea:	eb 16                	jmp    800e02 <strlcpy+0x2a>
			*dst++ = *src++;
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8d 50 01             	lea    0x1(%eax),%edx
  800df2:	89 55 08             	mov    %edx,0x8(%ebp)
  800df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dfb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dfe:	8a 12                	mov    (%edx),%dl
  800e00:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e02:	ff 4d 10             	decl   0x10(%ebp)
  800e05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e09:	74 09                	je     800e14 <strlcpy+0x3c>
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	84 c0                	test   %al,%al
  800e12:	75 d8                	jne    800dec <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e20:	29 c2                	sub    %eax,%edx
  800e22:	89 d0                	mov    %edx,%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e29:	eb 06                	jmp    800e31 <strcmp+0xb>
		p++, q++;
  800e2b:	ff 45 08             	incl   0x8(%ebp)
  800e2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	84 c0                	test   %al,%al
  800e38:	74 0e                	je     800e48 <strcmp+0x22>
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 10                	mov    (%eax),%dl
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	38 c2                	cmp    %al,%dl
  800e46:	74 e3                	je     800e2b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 d0             	movzbl %al,%edx
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	29 c2                	sub    %eax,%edx
  800e5a:	89 d0                	mov    %edx,%eax
}
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e61:	eb 09                	jmp    800e6c <strncmp+0xe>
		n--, p++, q++;
  800e63:	ff 4d 10             	decl   0x10(%ebp)
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e70:	74 17                	je     800e89 <strncmp+0x2b>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	84 c0                	test   %al,%al
  800e79:	74 0e                	je     800e89 <strncmp+0x2b>
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 da                	je     800e63 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	75 07                	jne    800e96 <strncmp+0x38>
		return 0;
  800e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e94:	eb 14                	jmp    800eaa <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	0f b6 d0             	movzbl %al,%edx
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	0f b6 c0             	movzbl %al,%eax
  800ea6:	29 c2                	sub    %eax,%edx
  800ea8:	89 d0                	mov    %edx,%eax
}
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 04             	sub    $0x4,%esp
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb8:	eb 12                	jmp    800ecc <strchr+0x20>
		if (*s == c)
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec2:	75 05                	jne    800ec9 <strchr+0x1d>
			return (char *) s;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	eb 11                	jmp    800eda <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	84 c0                	test   %al,%al
  800ed3:	75 e5                	jne    800eba <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 04             	sub    $0x4,%esp
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee8:	eb 0d                	jmp    800ef7 <strfind+0x1b>
		if (*s == c)
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef2:	74 0e                	je     800f02 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	84 c0                	test   %al,%al
  800efe:	75 ea                	jne    800eea <strfind+0xe>
  800f00:	eb 01                	jmp    800f03 <strfind+0x27>
		if (*s == c)
			break;
  800f02:	90                   	nop
	return (char *) s;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f1a:	eb 0e                	jmp    800f2a <memset+0x22>
		*p++ = c;
  800f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1f:	8d 50 01             	lea    0x1(%eax),%edx
  800f22:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f28:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f2a:	ff 4d f8             	decl   -0x8(%ebp)
  800f2d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f31:	79 e9                	jns    800f1c <memset+0x14>
		*p++ = c;

	return v;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f4a:	eb 16                	jmp    800f62 <memcpy+0x2a>
		*d++ = *s++;
  800f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4f:	8d 50 01             	lea    0x1(%eax),%edx
  800f52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f5e:	8a 12                	mov    (%edx),%dl
  800f60:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f62:	8b 45 10             	mov    0x10(%ebp),%eax
  800f65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f68:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	75 dd                	jne    800f4c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f72:	c9                   	leave  
  800f73:	c3                   	ret    

00800f74 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8c:	73 50                	jae    800fde <memmove+0x6a>
  800f8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f91:	8b 45 10             	mov    0x10(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f99:	76 43                	jbe    800fde <memmove+0x6a>
		s += n;
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa7:	eb 10                	jmp    800fb9 <memmove+0x45>
			*--d = *--s;
  800fa9:	ff 4d f8             	decl   -0x8(%ebp)
  800fac:	ff 4d fc             	decl   -0x4(%ebp)
  800faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb2:	8a 10                	mov    (%eax),%dl
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	75 e3                	jne    800fa9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc6:	eb 23                	jmp    800feb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcb:	8d 50 01             	lea    0x1(%eax),%edx
  800fce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fda:	8a 12                	mov    (%edx),%dl
  800fdc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	75 dd                	jne    800fc8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fee:	c9                   	leave  
  800fef:	c3                   	ret    

00800ff0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801002:	eb 2a                	jmp    80102e <memcmp+0x3e>
		if (*s1 != *s2)
  801004:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801007:	8a 10                	mov    (%eax),%dl
  801009:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	38 c2                	cmp    %al,%dl
  801010:	74 16                	je     801028 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801012:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	0f b6 d0             	movzbl %al,%edx
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	0f b6 c0             	movzbl %al,%eax
  801022:	29 c2                	sub    %eax,%edx
  801024:	89 d0                	mov    %edx,%eax
  801026:	eb 18                	jmp    801040 <memcmp+0x50>
		s1++, s2++;
  801028:	ff 45 fc             	incl   -0x4(%ebp)
  80102b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	8d 50 ff             	lea    -0x1(%eax),%edx
  801034:	89 55 10             	mov    %edx,0x10(%ebp)
  801037:	85 c0                	test   %eax,%eax
  801039:	75 c9                	jne    801004 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801048:	8b 55 08             	mov    0x8(%ebp),%edx
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	01 d0                	add    %edx,%eax
  801050:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801053:	eb 15                	jmp    80106a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f b6 d0             	movzbl %al,%edx
  80105d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801060:	0f b6 c0             	movzbl %al,%eax
  801063:	39 c2                	cmp    %eax,%edx
  801065:	74 0d                	je     801074 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801070:	72 e3                	jb     801055 <memfind+0x13>
  801072:	eb 01                	jmp    801075 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801074:	90                   	nop
	return (void *) s;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801080:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801087:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108e:	eb 03                	jmp    801093 <strtol+0x19>
		s++;
  801090:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	3c 20                	cmp    $0x20,%al
  80109a:	74 f4                	je     801090 <strtol+0x16>
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 09                	cmp    $0x9,%al
  8010a3:	74 eb                	je     801090 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	3c 2b                	cmp    $0x2b,%al
  8010ac:	75 05                	jne    8010b3 <strtol+0x39>
		s++;
  8010ae:	ff 45 08             	incl   0x8(%ebp)
  8010b1:	eb 13                	jmp    8010c6 <strtol+0x4c>
	else if (*s == '-')
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 2d                	cmp    $0x2d,%al
  8010ba:	75 0a                	jne    8010c6 <strtol+0x4c>
		s++, neg = 1;
  8010bc:	ff 45 08             	incl   0x8(%ebp)
  8010bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	74 06                	je     8010d2 <strtol+0x58>
  8010cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d0:	75 20                	jne    8010f2 <strtol+0x78>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 30                	cmp    $0x30,%al
  8010d9:	75 17                	jne    8010f2 <strtol+0x78>
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	40                   	inc    %eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 78                	cmp    $0x78,%al
  8010e3:	75 0d                	jne    8010f2 <strtol+0x78>
		s += 2, base = 16;
  8010e5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f0:	eb 28                	jmp    80111a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f6:	75 15                	jne    80110d <strtol+0x93>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 30                	cmp    $0x30,%al
  8010ff:	75 0c                	jne    80110d <strtol+0x93>
		s++, base = 8;
  801101:	ff 45 08             	incl   0x8(%ebp)
  801104:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80110b:	eb 0d                	jmp    80111a <strtol+0xa0>
	else if (base == 0)
  80110d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801111:	75 07                	jne    80111a <strtol+0xa0>
		base = 10;
  801113:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	3c 2f                	cmp    $0x2f,%al
  801121:	7e 19                	jle    80113c <strtol+0xc2>
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	3c 39                	cmp    $0x39,%al
  80112a:	7f 10                	jg     80113c <strtol+0xc2>
			dig = *s - '0';
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f be c0             	movsbl %al,%eax
  801134:	83 e8 30             	sub    $0x30,%eax
  801137:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113a:	eb 42                	jmp    80117e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 60                	cmp    $0x60,%al
  801143:	7e 19                	jle    80115e <strtol+0xe4>
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 7a                	cmp    $0x7a,%al
  80114c:	7f 10                	jg     80115e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f be c0             	movsbl %al,%eax
  801156:	83 e8 57             	sub    $0x57,%eax
  801159:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115c:	eb 20                	jmp    80117e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 40                	cmp    $0x40,%al
  801165:	7e 39                	jle    8011a0 <strtol+0x126>
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	3c 5a                	cmp    $0x5a,%al
  80116e:	7f 30                	jg     8011a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be c0             	movsbl %al,%eax
  801178:	83 e8 37             	sub    $0x37,%eax
  80117b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80117e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801181:	3b 45 10             	cmp    0x10(%ebp),%eax
  801184:	7d 19                	jge    80119f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801186:	ff 45 08             	incl   0x8(%ebp)
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801190:	89 c2                	mov    %eax,%edx
  801192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801195:	01 d0                	add    %edx,%eax
  801197:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80119a:	e9 7b ff ff ff       	jmp    80111a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80119f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a4:	74 08                	je     8011ae <strtol+0x134>
		*endptr = (char *) s;
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b2:	74 07                	je     8011bb <strtol+0x141>
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	f7 d8                	neg    %eax
  8011b9:	eb 03                	jmp    8011be <strtol+0x144>
  8011bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d8:	79 13                	jns    8011ed <ltostr+0x2d>
	{
		neg = 1;
  8011da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011f5:	99                   	cltd   
  8011f6:	f7 f9                	idiv   %ecx
  8011f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fe:	8d 50 01             	lea    0x1(%eax),%edx
  801201:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801204:	89 c2                	mov    %eax,%edx
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	01 d0                	add    %edx,%eax
  80120b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80120e:	83 c2 30             	add    $0x30,%edx
  801211:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801213:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801216:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121b:	f7 e9                	imul   %ecx
  80121d:	c1 fa 02             	sar    $0x2,%edx
  801220:	89 c8                	mov    %ecx,%eax
  801222:	c1 f8 1f             	sar    $0x1f,%eax
  801225:	29 c2                	sub    %eax,%edx
  801227:	89 d0                	mov    %edx,%eax
  801229:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80122c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801230:	75 bb                	jne    8011ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801239:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123c:	48                   	dec    %eax
  80123d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801240:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801244:	74 3d                	je     801283 <ltostr+0xc3>
		start = 1 ;
  801246:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80124d:	eb 34                	jmp    801283 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80124f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 c8                	add    %ecx,%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801270:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8a 45 eb             	mov    -0x15(%ebp),%al
  80127b:	88 02                	mov    %al,(%edx)
		start++ ;
  80127d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801280:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801286:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801289:	7c c4                	jl     80124f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80128b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801296:	90                   	nop
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80129f:	ff 75 08             	pushl  0x8(%ebp)
  8012a2:	e8 73 fa ff ff       	call   800d1a <strlen>
  8012a7:	83 c4 04             	add    $0x4,%esp
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ad:	ff 75 0c             	pushl  0xc(%ebp)
  8012b0:	e8 65 fa ff ff       	call   800d1a <strlen>
  8012b5:	83 c4 04             	add    $0x4,%esp
  8012b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 17                	jmp    8012e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	01 c2                	add    %eax,%edx
  8012d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	01 c8                	add    %ecx,%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012df:	ff 45 fc             	incl   -0x4(%ebp)
  8012e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012e8:	7c e1                	jl     8012cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012f8:	eb 1f                	jmp    801319 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fd:	8d 50 01             	lea    0x1(%eax),%edx
  801300:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801303:	89 c2                	mov    %eax,%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
  801319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80131f:	7c d9                	jl     8012fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801321:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	01 d0                	add    %edx,%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)
}
  80132c:	90                   	nop
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801332:	8b 45 14             	mov    0x14(%ebp),%eax
  801335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80133b:	8b 45 14             	mov    0x14(%ebp),%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801347:	8b 45 10             	mov    0x10(%ebp),%eax
  80134a:	01 d0                	add    %edx,%eax
  80134c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801352:	eb 0c                	jmp    801360 <strsplit+0x31>
			*string++ = 0;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	8d 50 01             	lea    0x1(%eax),%edx
  80135a:	89 55 08             	mov    %edx,0x8(%ebp)
  80135d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8a 00                	mov    (%eax),%al
  801365:	84 c0                	test   %al,%al
  801367:	74 18                	je     801381 <strsplit+0x52>
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	8a 00                	mov    (%eax),%al
  80136e:	0f be c0             	movsbl %al,%eax
  801371:	50                   	push   %eax
  801372:	ff 75 0c             	pushl  0xc(%ebp)
  801375:	e8 32 fb ff ff       	call   800eac <strchr>
  80137a:	83 c4 08             	add    $0x8,%esp
  80137d:	85 c0                	test   %eax,%eax
  80137f:	75 d3                	jne    801354 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 5a                	je     8013e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	83 f8 0f             	cmp    $0xf,%eax
  801392:	75 07                	jne    80139b <strsplit+0x6c>
		{
			return 0;
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
  801399:	eb 66                	jmp    801401 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80139b:	8b 45 14             	mov    0x14(%ebp),%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a6:	89 0a                	mov    %ecx,(%edx)
  8013a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013af:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b2:	01 c2                	add    %eax,%edx
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b9:	eb 03                	jmp    8013be <strsplit+0x8f>
			string++;
  8013bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	74 8b                	je     801352 <strsplit+0x23>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	0f be c0             	movsbl %al,%eax
  8013cf:	50                   	push   %eax
  8013d0:	ff 75 0c             	pushl  0xc(%ebp)
  8013d3:	e8 d4 fa ff ff       	call   800eac <strchr>
  8013d8:	83 c4 08             	add    $0x8,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	74 dc                	je     8013bb <strsplit+0x8c>
			string++;
	}
  8013df:	e9 6e ff ff ff       	jmp    801352 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e8:	8b 00                	mov    (%eax),%eax
  8013ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	68 88 42 80 00       	push   $0x804288
  801411:	68 3f 01 00 00       	push   $0x13f
  801416:	68 aa 42 80 00       	push   $0x8042aa
  80141b:	e8 32 25 00 00       	call   803952 <_panic>

00801420 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	ff 75 08             	pushl  0x8(%ebp)
  80142c:	e8 35 0a 00 00       	call   801e66 <sys_sbrk>
  801431:	83 c4 10             	add    $0x10,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80143c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801440:	75 0a                	jne    80144c <malloc+0x16>
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	e9 07 02 00 00       	jmp    801653 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  80144c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801453:	8b 55 08             	mov    0x8(%ebp),%edx
  801456:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	48                   	dec    %eax
  80145c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80145f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801462:	ba 00 00 00 00       	mov    $0x0,%edx
  801467:	f7 75 dc             	divl   -0x24(%ebp)
  80146a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146d:	29 d0                	sub    %edx,%eax
  80146f:	c1 e8 0c             	shr    $0xc,%eax
  801472:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801475:	a1 20 50 80 00       	mov    0x805020,%eax
  80147a:	8b 40 78             	mov    0x78(%eax),%eax
  80147d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
  801486:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801489:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80148c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801491:	c1 e8 0c             	shr    $0xc,%eax
  801494:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80149e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014a5:	77 42                	ja     8014e9 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8014a7:	e8 3e 08 00 00       	call   801cea <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 16                	je     8014c6 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 7e 0d 00 00       	call   802239 <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	e9 8a 01 00 00       	jmp    801650 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014c6:	e8 50 08 00 00       	call   801d1b <sys_isUHeapPlacementStrategyBESTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 84 7d 01 00 00    	je     801650 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 17 12 00 00       	call   8026f5 <alloc_block_BF>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e4:	e9 67 01 00 00       	jmp    801650 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8014e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014f0:	0f 86 53 01 00 00    	jbe    801649 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8014f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8014fb:	8b 40 78             	mov    0x78(%eax),%eax
  8014fe:	05 00 10 00 00       	add    $0x1000,%eax
  801503:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801506:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  80150d:	e9 de 00 00 00       	jmp    8015f0 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801512:	a1 20 50 80 00       	mov    0x805020,%eax
  801517:	8b 40 78             	mov    0x78(%eax),%eax
  80151a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80151d:	29 c2                	sub    %eax,%edx
  80151f:	89 d0                	mov    %edx,%eax
  801521:	2d 00 10 00 00       	sub    $0x1000,%eax
  801526:	c1 e8 0c             	shr    $0xc,%eax
  801529:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801530:	85 c0                	test   %eax,%eax
  801532:	0f 85 ab 00 00 00    	jne    8015e3 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	05 00 10 00 00       	add    $0x1000,%eax
  801540:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801543:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80154a:	eb 47                	jmp    801593 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80154c:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801553:	76 0a                	jbe    80155f <malloc+0x129>
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	e9 f4 00 00 00       	jmp    801653 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80155f:	a1 20 50 80 00       	mov    0x805020,%eax
  801564:	8b 40 78             	mov    0x78(%eax),%eax
  801567:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801573:	c1 e8 0c             	shr    $0xc,%eax
  801576:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80157d:	85 c0                	test   %eax,%eax
  80157f:	74 08                	je     801589 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801584:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801587:	eb 5a                	jmp    8015e3 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801589:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801590:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801593:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801596:	48                   	dec    %eax
  801597:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80159a:	77 b0                	ja     80154c <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80159c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8015a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015aa:	eb 2f                	jmp    8015db <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8015ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015af:	c1 e0 0c             	shl    $0xc,%eax
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b7:	01 c2                	add    %eax,%edx
  8015b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8015be:	8b 40 78             	mov    0x78(%eax),%eax
  8015c1:	29 c2                	sub    %eax,%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ca:	c1 e8 0c             	shr    $0xc,%eax
  8015cd:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8015d4:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015de:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015e1:	72 c9                	jb     8015ac <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8015e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015e7:	75 16                	jne    8015ff <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8015e9:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8015f0:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8015f7:	0f 86 15 ff ff ff    	jbe    801512 <malloc+0xdc>
  8015fd:	eb 01                	jmp    801600 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8015ff:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801600:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801604:	75 07                	jne    80160d <malloc+0x1d7>
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 46                	jmp    801653 <malloc+0x21d>
		ptr = (void*)i;
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801613:	a1 20 50 80 00       	mov    0x805020,%eax
  801618:	8b 40 78             	mov    0x78(%eax),%eax
  80161b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161e:	29 c2                	sub    %eax,%edx
  801620:	89 d0                	mov    %edx,%eax
  801622:	2d 00 10 00 00       	sub    $0x1000,%eax
  801627:	c1 e8 0c             	shr    $0xc,%eax
  80162a:	89 c2                	mov    %eax,%edx
  80162c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80162f:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	ff 75 f0             	pushl  -0x10(%ebp)
  80163f:	e8 59 08 00 00       	call   801e9d <sys_allocate_user_mem>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	eb 07                	jmp    801650 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
  80164e:	eb 03                	jmp    801653 <malloc+0x21d>
	}
	return ptr;
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80165b:	a1 20 50 80 00       	mov    0x805020,%eax
  801660:	8b 40 78             	mov    0x78(%eax),%eax
  801663:	05 00 10 00 00       	add    $0x1000,%eax
  801668:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80166b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801672:	a1 20 50 80 00       	mov    0x805020,%eax
  801677:	8b 50 78             	mov    0x78(%eax),%edx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	39 c2                	cmp    %eax,%edx
  80167f:	76 24                	jbe    8016a5 <free+0x50>
		size = get_block_size(va);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	e8 2d 08 00 00       	call   801eb9 <get_block_size>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 60 1a 00 00       	call   8030fd <free_block>
  80169d:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8016a0:	e9 ac 00 00 00       	jmp    801751 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ab:	0f 82 89 00 00 00    	jb     80173a <free+0xe5>
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8016b9:	77 7f                	ja     80173a <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8016bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016be:	a1 20 50 80 00       	mov    0x805020,%eax
  8016c3:	8b 40 78             	mov    0x78(%eax),%eax
  8016c6:	29 c2                	sub    %eax,%edx
  8016c8:	89 d0                	mov    %edx,%eax
  8016ca:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016cf:	c1 e8 0c             	shr    $0xc,%eax
  8016d2:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8016d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8016dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016df:	c1 e0 0c             	shl    $0xc,%eax
  8016e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8016e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016ec:	eb 2f                	jmp    80171d <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8016ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f1:	c1 e0 0c             	shl    $0xc,%eax
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	01 c2                	add    %eax,%edx
  8016fb:	a1 20 50 80 00       	mov    0x805020,%eax
  801700:	8b 40 78             	mov    0x78(%eax),%eax
  801703:	29 c2                	sub    %eax,%edx
  801705:	89 d0                	mov    %edx,%eax
  801707:	2d 00 10 00 00       	sub    $0x1000,%eax
  80170c:	c1 e8 0c             	shr    $0xc,%eax
  80170f:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801716:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80171a:	ff 45 f4             	incl   -0xc(%ebp)
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801723:	72 c9                	jb     8016ee <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	ff 75 ec             	pushl  -0x14(%ebp)
  80172e:	50                   	push   %eax
  80172f:	e8 4d 07 00 00       	call   801e81 <sys_free_user_mem>
  801734:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801737:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801738:	eb 17                	jmp    801751 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	68 b8 42 80 00       	push   $0x8042b8
  801742:	68 84 00 00 00       	push   $0x84
  801747:	68 e2 42 80 00       	push   $0x8042e2
  80174c:	e8 01 22 00 00       	call   803952 <_panic>
	}
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 28             	sub    $0x28,%esp
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80175f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801763:	75 07                	jne    80176c <smalloc+0x19>
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 74                	jmp    8017e0 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801772:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801779:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	39 d0                	cmp    %edx,%eax
  801781:	73 02                	jae    801785 <smalloc+0x32>
  801783:	89 d0                	mov    %edx,%eax
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	50                   	push   %eax
  801789:	e8 a8 fc ff ff       	call   801436 <malloc>
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801794:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801798:	75 07                	jne    8017a1 <smalloc+0x4e>
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	eb 3f                	jmp    8017e0 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017a1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a8:	50                   	push   %eax
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	e8 d4 02 00 00       	call   801a88 <sys_createSharedObject>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017ba:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017be:	74 06                	je     8017c6 <smalloc+0x73>
  8017c0:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017c4:	75 07                	jne    8017cd <smalloc+0x7a>
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	eb 13                	jmp    8017e0 <smalloc+0x8d>
	 cprintf("153\n");
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	68 ee 42 80 00       	push   $0x8042ee
  8017d5:	e8 ac ee ff ff       	call   800686 <cprintf>
  8017da:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8017dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 f4 42 80 00       	push   $0x8042f4
  8017f0:	68 a4 00 00 00       	push   $0xa4
  8017f5:	68 e2 42 80 00       	push   $0x8042e2
  8017fa:	e8 53 21 00 00       	call   803952 <_panic>

008017ff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 18 43 80 00       	push   $0x804318
  80180d:	68 bc 00 00 00       	push   $0xbc
  801812:	68 e2 42 80 00       	push   $0x8042e2
  801817:	e8 36 21 00 00       	call   803952 <_panic>

0080181c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 3c 43 80 00       	push   $0x80433c
  80182a:	68 d3 00 00 00       	push   $0xd3
  80182f:	68 e2 42 80 00       	push   $0x8042e2
  801834:	e8 19 21 00 00       	call   803952 <_panic>

00801839 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	68 62 43 80 00       	push   $0x804362
  801847:	68 df 00 00 00       	push   $0xdf
  80184c:	68 e2 42 80 00       	push   $0x8042e2
  801851:	e8 fc 20 00 00       	call   803952 <_panic>

00801856 <shrink>:

}
void shrink(uint32 newSize)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	68 62 43 80 00       	push   $0x804362
  801864:	68 e4 00 00 00       	push   $0xe4
  801869:	68 e2 42 80 00       	push   $0x8042e2
  80186e:	e8 df 20 00 00       	call   803952 <_panic>

00801873 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801879:	83 ec 04             	sub    $0x4,%esp
  80187c:	68 62 43 80 00       	push   $0x804362
  801881:	68 e9 00 00 00       	push   $0xe9
  801886:	68 e2 42 80 00       	push   $0x8042e2
  80188b:	e8 c2 20 00 00       	call   803952 <_panic>

00801890 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ab:	cd 30                	int    $0x30
  8018ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5f                   	pop    %edi
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	50                   	push   %eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	e8 b2 ff ff ff       	call   801890 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	90                   	nop
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 02                	push   $0x2
  8018f3:	e8 98 ff ff ff       	call   801890 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 03                	push   $0x3
  80190c:	e8 7f ff ff ff       	call   801890 <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	90                   	nop
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 04                	push   $0x4
  801926:	e8 65 ff ff ff       	call   801890 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 08                	push   $0x8
  801944:	e8 47 ff ff ff       	call   801890 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	56                   	push   %esi
  801952:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801953:	8b 75 18             	mov    0x18(%ebp),%esi
  801956:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	51                   	push   %ecx
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 09                	push   $0x9
  801969:	e8 22 ff ff ff       	call   801890 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    

00801978 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80197b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	52                   	push   %edx
  801988:	50                   	push   %eax
  801989:	6a 0a                	push   $0xa
  80198b:	e8 00 ff ff ff       	call   801890 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 0b                	push   $0xb
  8019a6:	e8 e5 fe ff ff       	call   801890 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 0c                	push   $0xc
  8019bf:	e8 cc fe ff ff       	call   801890 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 0d                	push   $0xd
  8019d8:	e8 b3 fe ff ff       	call   801890 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 0e                	push   $0xe
  8019f1:	e8 9a fe ff ff       	call   801890 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 0f                	push   $0xf
  801a0a:	e8 81 fe ff ff       	call   801890 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	ff 75 08             	pushl  0x8(%ebp)
  801a22:	6a 10                	push   $0x10
  801a24:	e8 67 fe ff ff       	call   801890 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 11                	push   $0x11
  801a3d:	e8 4e fe ff ff       	call   801890 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	90                   	nop
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a54:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	50                   	push   %eax
  801a61:	6a 01                	push   $0x1
  801a63:	e8 28 fe ff ff       	call   801890 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 14                	push   $0x14
  801a7d:	e8 0e fe ff ff       	call   801890 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a91:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	51                   	push   %ecx
  801aa1:	52                   	push   %edx
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	50                   	push   %eax
  801aa6:	6a 15                	push   $0x15
  801aa8:	e8 e3 fd ff ff       	call   801890 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	52                   	push   %edx
  801ac2:	50                   	push   %eax
  801ac3:	6a 16                	push   $0x16
  801ac5:	e8 c6 fd ff ff       	call   801890 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	51                   	push   %ecx
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 17                	push   $0x17
  801ae4:	e8 a7 fd ff ff       	call   801890 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 18                	push   $0x18
  801b01:	e8 8a fd ff ff       	call   801890 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	ff 75 14             	pushl  0x14(%ebp)
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	50                   	push   %eax
  801b1d:	6a 19                	push   $0x19
  801b1f:	e8 6c fd ff ff       	call   801890 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	50                   	push   %eax
  801b38:	6a 1a                	push   $0x1a
  801b3a:	e8 51 fd ff ff       	call   801890 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	50                   	push   %eax
  801b54:	6a 1b                	push   $0x1b
  801b56:	e8 35 fd ff ff       	call   801890 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 05                	push   $0x5
  801b6f:	e8 1c fd ff ff       	call   801890 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 06                	push   $0x6
  801b88:	e8 03 fd ff ff       	call   801890 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 07                	push   $0x7
  801ba1:	e8 ea fc ff ff       	call   801890 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_exit_env>:


void sys_exit_env(void)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 1c                	push   $0x1c
  801bba:	e8 d1 fc ff ff       	call   801890 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	90                   	nop
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bcb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bce:	8d 50 04             	lea    0x4(%eax),%edx
  801bd1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 1d                	push   $0x1d
  801bde:	e8 ad fc ff ff       	call   801890 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
	return result;
  801be6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bef:	89 01                	mov    %eax,(%ecx)
  801bf1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	c9                   	leave  
  801bf8:	c2 04 00             	ret    $0x4

00801bfb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	ff 75 10             	pushl  0x10(%ebp)
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	6a 13                	push   $0x13
  801c0d:	e8 7e fc ff ff       	call   801890 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
	return ;
  801c15:	90                   	nop
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 1e                	push   $0x1e
  801c27:	e8 64 fc ff ff       	call   801890 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c3d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	50                   	push   %eax
  801c4a:	6a 1f                	push   $0x1f
  801c4c:	e8 3f fc ff ff       	call   801890 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
	return ;
  801c54:	90                   	nop
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <rsttst>:
void rsttst()
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 21                	push   $0x21
  801c66:	e8 25 fc ff ff       	call   801890 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6e:	90                   	nop
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c7d:	8b 55 18             	mov    0x18(%ebp),%edx
  801c80:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c84:	52                   	push   %edx
  801c85:	50                   	push   %eax
  801c86:	ff 75 10             	pushl  0x10(%ebp)
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	6a 20                	push   $0x20
  801c91:	e8 fa fb ff ff       	call   801890 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return ;
  801c99:	90                   	nop
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <chktst>:
void chktst(uint32 n)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 22                	push   $0x22
  801cac:	e8 df fb ff ff       	call   801890 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <inctst>:

void inctst()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 23                	push   $0x23
  801cc6:	e8 c5 fb ff ff       	call   801890 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cce:	90                   	nop
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <gettst>:
uint32 gettst()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 24                	push   $0x24
  801ce0:	e8 ab fb ff ff       	call   801890 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 25                	push   $0x25
  801cfc:	e8 8f fb ff ff       	call   801890 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
  801d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d07:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d0b:	75 07                	jne    801d14 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d12:	eb 05                	jmp    801d19 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 25                	push   $0x25
  801d2d:	e8 5e fb ff ff       	call   801890 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
  801d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d38:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d3c:	75 07                	jne    801d45 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	eb 05                	jmp    801d4a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 25                	push   $0x25
  801d5e:	e8 2d fb ff ff       	call   801890 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
  801d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d69:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d6d:	75 07                	jne    801d76 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d74:	eb 05                	jmp    801d7b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801d8f:	e8 fc fa ff ff       	call   801890 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
  801d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d9a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d9e:	75 07                	jne    801da7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801da0:	b8 01 00 00 00       	mov    $0x1,%eax
  801da5:	eb 05                	jmp    801dac <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	6a 26                	push   $0x26
  801dbe:	e8 cd fa ff ff       	call   801890 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc6:	90                   	nop
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dcd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	53                   	push   %ebx
  801ddc:	51                   	push   %ecx
  801ddd:	52                   	push   %edx
  801dde:	50                   	push   %eax
  801ddf:	6a 27                	push   $0x27
  801de1:	e8 aa fa ff ff       	call   801890 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	52                   	push   %edx
  801dfe:	50                   	push   %eax
  801dff:	6a 28                	push   $0x28
  801e01:	e8 8a fa ff ff       	call   801890 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	6a 00                	push   $0x0
  801e19:	51                   	push   %ecx
  801e1a:	ff 75 10             	pushl  0x10(%ebp)
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	6a 29                	push   $0x29
  801e21:	e8 6a fa ff ff       	call   801890 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 12                	push   $0x12
  801e3d:	e8 4e fa ff ff       	call   801890 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
	return ;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	52                   	push   %edx
  801e58:	50                   	push   %eax
  801e59:	6a 2a                	push   $0x2a
  801e5b:	e8 30 fa ff ff       	call   801890 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
	return;
  801e63:	90                   	nop
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	50                   	push   %eax
  801e75:	6a 2b                	push   $0x2b
  801e77:	e8 14 fa ff ff       	call   801890 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	ff 75 0c             	pushl  0xc(%ebp)
  801e8d:	ff 75 08             	pushl  0x8(%ebp)
  801e90:	6a 2c                	push   $0x2c
  801e92:	e8 f9 f9 ff ff       	call   801890 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
	return;
  801e9a:	90                   	nop
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	ff 75 0c             	pushl  0xc(%ebp)
  801ea9:	ff 75 08             	pushl  0x8(%ebp)
  801eac:	6a 2d                	push   $0x2d
  801eae:	e8 dd f9 ff ff       	call   801890 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
	return;
  801eb6:	90                   	nop
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	83 e8 04             	sub    $0x4,%eax
  801ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecb:	8b 00                	mov    (%eax),%eax
  801ecd:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	83 e8 04             	sub    $0x4,%eax
  801ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	83 e0 01             	and    $0x1,%eax
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	0f 94 c0             	sete   %al
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f00:	83 f8 02             	cmp    $0x2,%eax
  801f03:	74 2b                	je     801f30 <alloc_block+0x40>
  801f05:	83 f8 02             	cmp    $0x2,%eax
  801f08:	7f 07                	jg     801f11 <alloc_block+0x21>
  801f0a:	83 f8 01             	cmp    $0x1,%eax
  801f0d:	74 0e                	je     801f1d <alloc_block+0x2d>
  801f0f:	eb 58                	jmp    801f69 <alloc_block+0x79>
  801f11:	83 f8 03             	cmp    $0x3,%eax
  801f14:	74 2d                	je     801f43 <alloc_block+0x53>
  801f16:	83 f8 04             	cmp    $0x4,%eax
  801f19:	74 3b                	je     801f56 <alloc_block+0x66>
  801f1b:	eb 4c                	jmp    801f69 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	ff 75 08             	pushl  0x8(%ebp)
  801f23:	e8 11 03 00 00       	call   802239 <alloc_block_FF>
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f2e:	eb 4a                	jmp    801f7a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	ff 75 08             	pushl  0x8(%ebp)
  801f36:	e8 fa 19 00 00       	call   803935 <alloc_block_NF>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f41:	eb 37                	jmp    801f7a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	e8 a7 07 00 00       	call   8026f5 <alloc_block_BF>
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f54:	eb 24                	jmp    801f7a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	ff 75 08             	pushl  0x8(%ebp)
  801f5c:	e8 b7 19 00 00       	call   803918 <alloc_block_WF>
  801f61:	83 c4 10             	add    $0x10,%esp
  801f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f67:	eb 11                	jmp    801f7a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	68 74 43 80 00       	push   $0x804374
  801f71:	e8 10 e7 ff ff       	call   800686 <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp
		break;
  801f79:	90                   	nop
	}
	return va;
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	53                   	push   %ebx
  801f83:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	68 94 43 80 00       	push   $0x804394
  801f8e:	e8 f3 e6 ff ff       	call   800686 <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	68 bf 43 80 00       	push   $0x8043bf
  801f9e:	e8 e3 e6 ff ff       	call   800686 <cprintf>
  801fa3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fac:	eb 37                	jmp    801fe5 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	e8 19 ff ff ff       	call   801ed2 <is_free_block>
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	0f be d8             	movsbl %al,%ebx
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc5:	e8 ef fe ff ff       	call   801eb9 <get_block_size>
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	53                   	push   %ebx
  801fd1:	50                   	push   %eax
  801fd2:	68 d7 43 80 00       	push   $0x8043d7
  801fd7:	e8 aa e6 ff ff       	call   800686 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe9:	74 07                	je     801ff2 <print_blocks_list+0x73>
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 00                	mov    (%eax),%eax
  801ff0:	eb 05                	jmp    801ff7 <print_blocks_list+0x78>
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff7:	89 45 10             	mov    %eax,0x10(%ebp)
  801ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	75 ad                	jne    801fae <print_blocks_list+0x2f>
  802001:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802005:	75 a7                	jne    801fae <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	68 94 43 80 00       	push   $0x804394
  80200f:	e8 72 e6 ff ff       	call   800686 <cprintf>
  802014:	83 c4 10             	add    $0x10,%esp

}
  802017:	90                   	nop
  802018:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802023:	8b 45 0c             	mov    0xc(%ebp),%eax
  802026:	83 e0 01             	and    $0x1,%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	74 03                	je     802030 <initialize_dynamic_allocator+0x13>
  80202d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802030:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802034:	0f 84 c7 01 00 00    	je     802201 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80203a:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802041:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802044:	8b 55 08             	mov    0x8(%ebp),%edx
  802047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204a:	01 d0                	add    %edx,%eax
  80204c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802051:	0f 87 ad 01 00 00    	ja     802204 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	85 c0                	test   %eax,%eax
  80205c:	0f 89 a5 01 00 00    	jns    802207 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802062:	8b 55 08             	mov    0x8(%ebp),%edx
  802065:	8b 45 0c             	mov    0xc(%ebp),%eax
  802068:	01 d0                	add    %edx,%eax
  80206a:	83 e8 04             	sub    $0x4,%eax
  80206d:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802079:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802081:	e9 87 00 00 00       	jmp    80210d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208a:	75 14                	jne    8020a0 <initialize_dynamic_allocator+0x83>
  80208c:	83 ec 04             	sub    $0x4,%esp
  80208f:	68 ef 43 80 00       	push   $0x8043ef
  802094:	6a 79                	push   $0x79
  802096:	68 0d 44 80 00       	push   $0x80440d
  80209b:	e8 b2 18 00 00       	call   803952 <_panic>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	74 10                	je     8020b9 <initialize_dynamic_allocator+0x9c>
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b1:	8b 52 04             	mov    0x4(%edx),%edx
  8020b4:	89 50 04             	mov    %edx,0x4(%eax)
  8020b7:	eb 0b                	jmp    8020c4 <initialize_dynamic_allocator+0xa7>
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	8b 40 04             	mov    0x4(%eax),%eax
  8020bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	74 0f                	je     8020dd <initialize_dynamic_allocator+0xc0>
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 40 04             	mov    0x4(%eax),%eax
  8020d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d7:	8b 12                	mov    (%edx),%edx
  8020d9:	89 10                	mov    %edx,(%eax)
  8020db:	eb 0a                	jmp    8020e7 <initialize_dynamic_allocator+0xca>
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	8b 00                	mov    (%eax),%eax
  8020e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8020ff:	48                   	dec    %eax
  802100:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802105:	a1 34 50 80 00       	mov    0x805034,%eax
  80210a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80210d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802111:	74 07                	je     80211a <initialize_dynamic_allocator+0xfd>
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 00                	mov    (%eax),%eax
  802118:	eb 05                	jmp    80211f <initialize_dynamic_allocator+0x102>
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
  80211f:	a3 34 50 80 00       	mov    %eax,0x805034
  802124:	a1 34 50 80 00       	mov    0x805034,%eax
  802129:	85 c0                	test   %eax,%eax
  80212b:	0f 85 55 ff ff ff    	jne    802086 <initialize_dynamic_allocator+0x69>
  802131:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802135:	0f 85 4b ff ff ff    	jne    802086 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802144:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80214a:	a1 44 50 80 00       	mov    0x805044,%eax
  80214f:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802154:	a1 40 50 80 00       	mov    0x805040,%eax
  802159:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	83 c0 08             	add    $0x8,%eax
  802165:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	83 c0 04             	add    $0x4,%eax
  80216e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802171:	83 ea 08             	sub    $0x8,%edx
  802174:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802176:	8b 55 0c             	mov    0xc(%ebp),%edx
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	01 d0                	add    %edx,%eax
  80217e:	83 e8 08             	sub    $0x8,%eax
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	83 ea 08             	sub    $0x8,%edx
  802187:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802195:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80219c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a0:	75 17                	jne    8021b9 <initialize_dynamic_allocator+0x19c>
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 28 44 80 00       	push   $0x804428
  8021aa:	68 90 00 00 00       	push   $0x90
  8021af:	68 0d 44 80 00       	push   $0x80440d
  8021b4:	e8 99 17 00 00       	call   803952 <_panic>
  8021b9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c2:	89 10                	mov    %edx,(%eax)
  8021c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	74 0d                	je     8021da <initialize_dynamic_allocator+0x1bd>
  8021cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021d5:	89 50 04             	mov    %edx,0x4(%eax)
  8021d8:	eb 08                	jmp    8021e2 <initialize_dynamic_allocator+0x1c5>
  8021da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8021e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8021f9:	40                   	inc    %eax
  8021fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ff:	eb 07                	jmp    802208 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802201:	90                   	nop
  802202:	eb 04                	jmp    802208 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802204:	90                   	nop
  802205:	eb 01                	jmp    802208 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802207:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80220d:	8b 45 10             	mov    0x10(%ebp),%eax
  802210:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	8d 50 fc             	lea    -0x4(%eax),%edx
  802219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	83 e8 04             	sub    $0x4,%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	83 e0 fe             	and    $0xfffffffe,%eax
  802229:	8d 50 f8             	lea    -0x8(%eax),%edx
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	01 c2                	add    %eax,%edx
  802231:	8b 45 0c             	mov    0xc(%ebp),%eax
  802234:	89 02                	mov    %eax,(%edx)
}
  802236:	90                   	nop
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	83 e0 01             	and    $0x1,%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	74 03                	je     80224c <alloc_block_FF+0x13>
  802249:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80224c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802250:	77 07                	ja     802259 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802252:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802259:	a1 24 50 80 00       	mov    0x805024,%eax
  80225e:	85 c0                	test   %eax,%eax
  802260:	75 73                	jne    8022d5 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	83 c0 10             	add    $0x10,%eax
  802268:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80226b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802272:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	01 d0                	add    %edx,%eax
  80227a:	48                   	dec    %eax
  80227b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80227e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802281:	ba 00 00 00 00       	mov    $0x0,%edx
  802286:	f7 75 ec             	divl   -0x14(%ebp)
  802289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228c:	29 d0                	sub    %edx,%eax
  80228e:	c1 e8 0c             	shr    $0xc,%eax
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	50                   	push   %eax
  802295:	e8 86 f1 ff ff       	call   801420 <sbrk>
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	6a 00                	push   $0x0
  8022a5:	e8 76 f1 ff ff       	call   801420 <sbrk>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022b6:	83 ec 08             	sub    $0x8,%esp
  8022b9:	50                   	push   %eax
  8022ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022bd:	e8 5b fd ff ff       	call   80201d <initialize_dynamic_allocator>
  8022c2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022c5:	83 ec 0c             	sub    $0xc,%esp
  8022c8:	68 4b 44 80 00       	push   $0x80444b
  8022cd:	e8 b4 e3 ff ff       	call   800686 <cprintf>
  8022d2:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d9:	75 0a                	jne    8022e5 <alloc_block_FF+0xac>
	        return NULL;
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e0:	e9 0e 04 00 00       	jmp    8026f3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f4:	e9 f3 02 00 00       	jmp    8025ec <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	ff 75 bc             	pushl  -0x44(%ebp)
  802305:	e8 af fb ff ff       	call   801eb9 <get_block_size>
  80230a:	83 c4 10             	add    $0x10,%esp
  80230d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	83 c0 08             	add    $0x8,%eax
  802316:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802319:	0f 87 c5 02 00 00    	ja     8025e4 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	83 c0 18             	add    $0x18,%eax
  802325:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802328:	0f 87 19 02 00 00    	ja     802547 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80232e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802331:	2b 45 08             	sub    0x8(%ebp),%eax
  802334:	83 e8 08             	sub    $0x8,%eax
  802337:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8d 50 08             	lea    0x8(%eax),%edx
  802340:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802343:	01 d0                	add    %edx,%eax
  802345:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	83 c0 08             	add    $0x8,%eax
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	6a 01                	push   $0x1
  802353:	50                   	push   %eax
  802354:	ff 75 bc             	pushl  -0x44(%ebp)
  802357:	e8 ae fe ff ff       	call   80220a <set_block_data>
  80235c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	75 68                	jne    8023d1 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802369:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80236d:	75 17                	jne    802386 <alloc_block_FF+0x14d>
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 28 44 80 00       	push   $0x804428
  802377:	68 d7 00 00 00       	push   $0xd7
  80237c:	68 0d 44 80 00       	push   $0x80440d
  802381:	e8 cc 15 00 00       	call   803952 <_panic>
  802386:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80238c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238f:	89 10                	mov    %edx,(%eax)
  802391:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802394:	8b 00                	mov    (%eax),%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	74 0d                	je     8023a7 <alloc_block_FF+0x16e>
  80239a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80239f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023a2:	89 50 04             	mov    %edx,0x4(%eax)
  8023a5:	eb 08                	jmp    8023af <alloc_block_FF+0x176>
  8023a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8023af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8023c6:	40                   	inc    %eax
  8023c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8023cc:	e9 dc 00 00 00       	jmp    8024ad <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	75 65                	jne    80243f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023da:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023de:	75 17                	jne    8023f7 <alloc_block_FF+0x1be>
  8023e0:	83 ec 04             	sub    $0x4,%esp
  8023e3:	68 5c 44 80 00       	push   $0x80445c
  8023e8:	68 db 00 00 00       	push   $0xdb
  8023ed:	68 0d 44 80 00       	push   $0x80440d
  8023f2:	e8 5b 15 00 00       	call   803952 <_panic>
  8023f7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802400:	89 50 04             	mov    %edx,0x4(%eax)
  802403:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802406:	8b 40 04             	mov    0x4(%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 0c                	je     802419 <alloc_block_FF+0x1e0>
  80240d:	a1 30 50 80 00       	mov    0x805030,%eax
  802412:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802415:	89 10                	mov    %edx,(%eax)
  802417:	eb 08                	jmp    802421 <alloc_block_FF+0x1e8>
  802419:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802421:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802424:	a3 30 50 80 00       	mov    %eax,0x805030
  802429:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802432:	a1 38 50 80 00       	mov    0x805038,%eax
  802437:	40                   	inc    %eax
  802438:	a3 38 50 80 00       	mov    %eax,0x805038
  80243d:	eb 6e                	jmp    8024ad <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80243f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802443:	74 06                	je     80244b <alloc_block_FF+0x212>
  802445:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802449:	75 17                	jne    802462 <alloc_block_FF+0x229>
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	68 80 44 80 00       	push   $0x804480
  802453:	68 df 00 00 00       	push   $0xdf
  802458:	68 0d 44 80 00       	push   $0x80440d
  80245d:	e8 f0 14 00 00       	call   803952 <_panic>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 10                	mov    (%eax),%edx
  802467:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246a:	89 10                	mov    %edx,(%eax)
  80246c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 0b                	je     802480 <alloc_block_FF+0x247>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80247d:	89 50 04             	mov    %edx,0x4(%eax)
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802486:	89 10                	mov    %edx,(%eax)
  802488:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	89 50 04             	mov    %edx,0x4(%eax)
  802491:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	75 08                	jne    8024a2 <alloc_block_FF+0x269>
  80249a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249d:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a7:	40                   	inc    %eax
  8024a8:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	75 17                	jne    8024ca <alloc_block_FF+0x291>
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 ef 43 80 00       	push   $0x8043ef
  8024bb:	68 e1 00 00 00       	push   $0xe1
  8024c0:	68 0d 44 80 00       	push   $0x80440d
  8024c5:	e8 88 14 00 00       	call   803952 <_panic>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	74 10                	je     8024e3 <alloc_block_FF+0x2aa>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024db:	8b 52 04             	mov    0x4(%edx),%edx
  8024de:	89 50 04             	mov    %edx,0x4(%eax)
  8024e1:	eb 0b                	jmp    8024ee <alloc_block_FF+0x2b5>
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	74 0f                	je     802507 <alloc_block_FF+0x2ce>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	8b 12                	mov    (%edx),%edx
  802503:	89 10                	mov    %edx,(%eax)
  802505:	eb 0a                	jmp    802511 <alloc_block_FF+0x2d8>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802524:	a1 38 50 80 00       	mov    0x805038,%eax
  802529:	48                   	dec    %eax
  80252a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	6a 00                	push   $0x0
  802534:	ff 75 b4             	pushl  -0x4c(%ebp)
  802537:	ff 75 b0             	pushl  -0x50(%ebp)
  80253a:	e8 cb fc ff ff       	call   80220a <set_block_data>
  80253f:	83 c4 10             	add    $0x10,%esp
  802542:	e9 95 00 00 00       	jmp    8025dc <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	6a 01                	push   $0x1
  80254c:	ff 75 b8             	pushl  -0x48(%ebp)
  80254f:	ff 75 bc             	pushl  -0x44(%ebp)
  802552:	e8 b3 fc ff ff       	call   80220a <set_block_data>
  802557:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	75 17                	jne    802577 <alloc_block_FF+0x33e>
  802560:	83 ec 04             	sub    $0x4,%esp
  802563:	68 ef 43 80 00       	push   $0x8043ef
  802568:	68 e8 00 00 00       	push   $0xe8
  80256d:	68 0d 44 80 00       	push   $0x80440d
  802572:	e8 db 13 00 00       	call   803952 <_panic>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 10                	je     802590 <alloc_block_FF+0x357>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802588:	8b 52 04             	mov    0x4(%edx),%edx
  80258b:	89 50 04             	mov    %edx,0x4(%eax)
  80258e:	eb 0b                	jmp    80259b <alloc_block_FF+0x362>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	a3 30 50 80 00       	mov    %eax,0x805030
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	74 0f                	je     8025b4 <alloc_block_FF+0x37b>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ae:	8b 12                	mov    (%edx),%edx
  8025b0:	89 10                	mov    %edx,(%eax)
  8025b2:	eb 0a                	jmp    8025be <alloc_block_FF+0x385>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8025d6:	48                   	dec    %eax
  8025d7:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025dc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025df:	e9 0f 01 00 00       	jmp    8026f3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8025e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	74 07                	je     8025f9 <alloc_block_FF+0x3c0>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 00                	mov    (%eax),%eax
  8025f7:	eb 05                	jmp    8025fe <alloc_block_FF+0x3c5>
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fe:	a3 34 50 80 00       	mov    %eax,0x805034
  802603:	a1 34 50 80 00       	mov    0x805034,%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	0f 85 e9 fc ff ff    	jne    8022f9 <alloc_block_FF+0xc0>
  802610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802614:	0f 85 df fc ff ff    	jne    8022f9 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	83 c0 08             	add    $0x8,%eax
  802620:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802623:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80262a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80262d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802630:	01 d0                	add    %edx,%eax
  802632:	48                   	dec    %eax
  802633:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802636:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802639:	ba 00 00 00 00       	mov    $0x0,%edx
  80263e:	f7 75 d8             	divl   -0x28(%ebp)
  802641:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802644:	29 d0                	sub    %edx,%eax
  802646:	c1 e8 0c             	shr    $0xc,%eax
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	50                   	push   %eax
  80264d:	e8 ce ed ff ff       	call   801420 <sbrk>
  802652:	83 c4 10             	add    $0x10,%esp
  802655:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802658:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80265c:	75 0a                	jne    802668 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
  802663:	e9 8b 00 00 00       	jmp    8026f3 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802668:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80266f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802672:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802675:	01 d0                	add    %edx,%eax
  802677:	48                   	dec    %eax
  802678:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80267b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80267e:	ba 00 00 00 00       	mov    $0x0,%edx
  802683:	f7 75 cc             	divl   -0x34(%ebp)
  802686:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802689:	29 d0                	sub    %edx,%eax
  80268b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80268e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802691:	01 d0                	add    %edx,%eax
  802693:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802698:	a1 40 50 80 00       	mov    0x805040,%eax
  80269d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026a3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	48                   	dec    %eax
  8026b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026be:	f7 75 c4             	divl   -0x3c(%ebp)
  8026c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026c4:	29 d0                	sub    %edx,%eax
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	6a 01                	push   $0x1
  8026cb:	50                   	push   %eax
  8026cc:	ff 75 d0             	pushl  -0x30(%ebp)
  8026cf:	e8 36 fb ff ff       	call   80220a <set_block_data>
  8026d4:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026d7:	83 ec 0c             	sub    $0xc,%esp
  8026da:	ff 75 d0             	pushl  -0x30(%ebp)
  8026dd:	e8 1b 0a 00 00       	call   8030fd <free_block>
  8026e2:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	ff 75 08             	pushl  0x8(%ebp)
  8026eb:	e8 49 fb ff ff       	call   802239 <alloc_block_FF>
  8026f0:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
  8026f8:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	83 e0 01             	and    $0x1,%eax
  802701:	85 c0                	test   %eax,%eax
  802703:	74 03                	je     802708 <alloc_block_BF+0x13>
  802705:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802708:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80270c:	77 07                	ja     802715 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80270e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802715:	a1 24 50 80 00       	mov    0x805024,%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	75 73                	jne    802791 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	83 c0 10             	add    $0x10,%eax
  802724:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802727:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80272e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802734:	01 d0                	add    %edx,%eax
  802736:	48                   	dec    %eax
  802737:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80273a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80273d:	ba 00 00 00 00       	mov    $0x0,%edx
  802742:	f7 75 e0             	divl   -0x20(%ebp)
  802745:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802748:	29 d0                	sub    %edx,%eax
  80274a:	c1 e8 0c             	shr    $0xc,%eax
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	50                   	push   %eax
  802751:	e8 ca ec ff ff       	call   801420 <sbrk>
  802756:	83 c4 10             	add    $0x10,%esp
  802759:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	6a 00                	push   $0x0
  802761:	e8 ba ec ff ff       	call   801420 <sbrk>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80276c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802772:	83 ec 08             	sub    $0x8,%esp
  802775:	50                   	push   %eax
  802776:	ff 75 d8             	pushl  -0x28(%ebp)
  802779:	e8 9f f8 ff ff       	call   80201d <initialize_dynamic_allocator>
  80277e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802781:	83 ec 0c             	sub    $0xc,%esp
  802784:	68 4b 44 80 00       	push   $0x80444b
  802789:	e8 f8 de ff ff       	call   800686 <cprintf>
  80278e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802798:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80279f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b5:	e9 1d 01 00 00       	jmp    8028d7 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027c0:	83 ec 0c             	sub    $0xc,%esp
  8027c3:	ff 75 a8             	pushl  -0x58(%ebp)
  8027c6:	e8 ee f6 ff ff       	call   801eb9 <get_block_size>
  8027cb:	83 c4 10             	add    $0x10,%esp
  8027ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	83 c0 08             	add    $0x8,%eax
  8027d7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027da:	0f 87 ef 00 00 00    	ja     8028cf <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	83 c0 18             	add    $0x18,%eax
  8027e6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e9:	77 1d                	ja     802808 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ee:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027f1:	0f 86 d8 00 00 00    	jbe    8028cf <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802800:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802803:	e9 c7 00 00 00       	jmp    8028cf <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 c0 08             	add    $0x8,%eax
  80280e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802811:	0f 85 9d 00 00 00    	jne    8028b4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	6a 01                	push   $0x1
  80281c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80281f:	ff 75 a8             	pushl  -0x58(%ebp)
  802822:	e8 e3 f9 ff ff       	call   80220a <set_block_data>
  802827:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	75 17                	jne    802847 <alloc_block_BF+0x152>
  802830:	83 ec 04             	sub    $0x4,%esp
  802833:	68 ef 43 80 00       	push   $0x8043ef
  802838:	68 2c 01 00 00       	push   $0x12c
  80283d:	68 0d 44 80 00       	push   $0x80440d
  802842:	e8 0b 11 00 00       	call   803952 <_panic>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	74 10                	je     802860 <alloc_block_BF+0x16b>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802858:	8b 52 04             	mov    0x4(%edx),%edx
  80285b:	89 50 04             	mov    %edx,0x4(%eax)
  80285e:	eb 0b                	jmp    80286b <alloc_block_BF+0x176>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 40 04             	mov    0x4(%eax),%eax
  802866:	a3 30 50 80 00       	mov    %eax,0x805030
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	74 0f                	je     802884 <alloc_block_BF+0x18f>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 40 04             	mov    0x4(%eax),%eax
  80287b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287e:	8b 12                	mov    (%edx),%edx
  802880:	89 10                	mov    %edx,(%eax)
  802882:	eb 0a                	jmp    80288e <alloc_block_BF+0x199>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a6:	48                   	dec    %eax
  8028a7:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028af:	e9 24 04 00 00       	jmp    802cd8 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ba:	76 13                	jbe    8028cf <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028bc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028c9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028cc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028cf:	a1 34 50 80 00       	mov    0x805034,%eax
  8028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028db:	74 07                	je     8028e4 <alloc_block_BF+0x1ef>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	eb 05                	jmp    8028e9 <alloc_block_BF+0x1f4>
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e9:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ee:	a1 34 50 80 00       	mov    0x805034,%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	0f 85 bf fe ff ff    	jne    8027ba <alloc_block_BF+0xc5>
  8028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ff:	0f 85 b5 fe ff ff    	jne    8027ba <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802905:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802909:	0f 84 26 02 00 00    	je     802b35 <alloc_block_BF+0x440>
  80290f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802913:	0f 85 1c 02 00 00    	jne    802b35 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291c:	2b 45 08             	sub    0x8(%ebp),%eax
  80291f:	83 e8 08             	sub    $0x8,%eax
  802922:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	8d 50 08             	lea    0x8(%eax),%edx
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	01 d0                	add    %edx,%eax
  802930:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	83 c0 08             	add    $0x8,%eax
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	6a 01                	push   $0x1
  80293e:	50                   	push   %eax
  80293f:	ff 75 f0             	pushl  -0x10(%ebp)
  802942:	e8 c3 f8 ff ff       	call   80220a <set_block_data>
  802947:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 68                	jne    8029bc <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802954:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802958:	75 17                	jne    802971 <alloc_block_BF+0x27c>
  80295a:	83 ec 04             	sub    $0x4,%esp
  80295d:	68 28 44 80 00       	push   $0x804428
  802962:	68 45 01 00 00       	push   $0x145
  802967:	68 0d 44 80 00       	push   $0x80440d
  80296c:	e8 e1 0f 00 00       	call   803952 <_panic>
  802971:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802977:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0d                	je     802992 <alloc_block_BF+0x29d>
  802985:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80298a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	eb 08                	jmp    80299a <alloc_block_BF+0x2a5>
  802992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802995:	a3 30 50 80 00       	mov    %eax,0x805030
  80299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b1:	40                   	inc    %eax
  8029b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8029b7:	e9 dc 00 00 00       	jmp    802a98 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	75 65                	jne    802a2a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c9:	75 17                	jne    8029e2 <alloc_block_BF+0x2ed>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 5c 44 80 00       	push   $0x80445c
  8029d3:	68 4a 01 00 00       	push   $0x14a
  8029d8:	68 0d 44 80 00       	push   $0x80440d
  8029dd:	e8 70 0f 00 00       	call   803952 <_panic>
  8029e2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029eb:	89 50 04             	mov    %edx,0x4(%eax)
  8029ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 0c                	je     802a04 <alloc_block_BF+0x30f>
  8029f8:	a1 30 50 80 00       	mov    0x805030,%eax
  8029fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a00:	89 10                	mov    %edx,(%eax)
  802a02:	eb 08                	jmp    802a0c <alloc_block_BF+0x317>
  802a04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a07:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a22:	40                   	inc    %eax
  802a23:	a3 38 50 80 00       	mov    %eax,0x805038
  802a28:	eb 6e                	jmp    802a98 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a2e:	74 06                	je     802a36 <alloc_block_BF+0x341>
  802a30:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a34:	75 17                	jne    802a4d <alloc_block_BF+0x358>
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	68 80 44 80 00       	push   $0x804480
  802a3e:	68 4f 01 00 00       	push   $0x14f
  802a43:	68 0d 44 80 00       	push   $0x80440d
  802a48:	e8 05 0f 00 00       	call   803952 <_panic>
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	8b 10                	mov    (%eax),%edx
  802a52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a55:	89 10                	mov    %edx,(%eax)
  802a57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 0b                	je     802a6b <alloc_block_BF+0x376>
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a68:	89 50 04             	mov    %edx,0x4(%eax)
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a71:	89 10                	mov    %edx,(%eax)
  802a73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	75 08                	jne    802a8d <alloc_block_BF+0x398>
  802a85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a88:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a92:	40                   	inc    %eax
  802a93:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9c:	75 17                	jne    802ab5 <alloc_block_BF+0x3c0>
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	68 ef 43 80 00       	push   $0x8043ef
  802aa6:	68 51 01 00 00       	push   $0x151
  802aab:	68 0d 44 80 00       	push   $0x80440d
  802ab0:	e8 9d 0e 00 00       	call   803952 <_panic>
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 10                	je     802ace <alloc_block_BF+0x3d9>
  802abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac6:	8b 52 04             	mov    0x4(%edx),%edx
  802ac9:	89 50 04             	mov    %edx,0x4(%eax)
  802acc:	eb 0b                	jmp    802ad9 <alloc_block_BF+0x3e4>
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 40 04             	mov    0x4(%eax),%eax
  802ad4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 0f                	je     802af2 <alloc_block_BF+0x3fd>
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aec:	8b 12                	mov    (%edx),%edx
  802aee:	89 10                	mov    %edx,(%eax)
  802af0:	eb 0a                	jmp    802afc <alloc_block_BF+0x407>
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b14:	48                   	dec    %eax
  802b15:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	6a 00                	push   $0x0
  802b1f:	ff 75 d0             	pushl  -0x30(%ebp)
  802b22:	ff 75 cc             	pushl  -0x34(%ebp)
  802b25:	e8 e0 f6 ff ff       	call   80220a <set_block_data>
  802b2a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	e9 a3 01 00 00       	jmp    802cd8 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b35:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b39:	0f 85 9d 00 00 00    	jne    802bdc <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	6a 01                	push   $0x1
  802b44:	ff 75 ec             	pushl  -0x14(%ebp)
  802b47:	ff 75 f0             	pushl  -0x10(%ebp)
  802b4a:	e8 bb f6 ff ff       	call   80220a <set_block_data>
  802b4f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b56:	75 17                	jne    802b6f <alloc_block_BF+0x47a>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 ef 43 80 00       	push   $0x8043ef
  802b60:	68 58 01 00 00       	push   $0x158
  802b65:	68 0d 44 80 00       	push   $0x80440d
  802b6a:	e8 e3 0d 00 00       	call   803952 <_panic>
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 10                	je     802b88 <alloc_block_BF+0x493>
  802b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b80:	8b 52 04             	mov    0x4(%edx),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 0b                	jmp    802b93 <alloc_block_BF+0x49e>
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0f                	je     802bac <alloc_block_BF+0x4b7>
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba6:	8b 12                	mov    (%edx),%edx
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	eb 0a                	jmp    802bb6 <alloc_block_BF+0x4c1>
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bce:	48                   	dec    %eax
  802bcf:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd7:	e9 fc 00 00 00       	jmp    802cd8 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	83 c0 08             	add    $0x8,%eax
  802be2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802be5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bf8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  802c00:	f7 75 c4             	divl   -0x3c(%ebp)
  802c03:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c06:	29 d0                	sub    %edx,%eax
  802c08:	c1 e8 0c             	shr    $0xc,%eax
  802c0b:	83 ec 0c             	sub    $0xc,%esp
  802c0e:	50                   	push   %eax
  802c0f:	e8 0c e8 ff ff       	call   801420 <sbrk>
  802c14:	83 c4 10             	add    $0x10,%esp
  802c17:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c1a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c1e:	75 0a                	jne    802c2a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c20:	b8 00 00 00 00       	mov    $0x0,%eax
  802c25:	e9 ae 00 00 00       	jmp    802cd8 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c2a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c31:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c34:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c37:	01 d0                	add    %edx,%eax
  802c39:	48                   	dec    %eax
  802c3a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c3d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c40:	ba 00 00 00 00       	mov    $0x0,%edx
  802c45:	f7 75 b8             	divl   -0x48(%ebp)
  802c48:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c4b:	29 d0                	sub    %edx,%eax
  802c4d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c50:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c53:	01 d0                	add    %edx,%eax
  802c55:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c5a:	a1 40 50 80 00       	mov    0x805040,%eax
  802c5f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c65:	83 ec 0c             	sub    $0xc,%esp
  802c68:	68 b4 44 80 00       	push   $0x8044b4
  802c6d:	e8 14 da ff ff       	call   800686 <cprintf>
  802c72:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c75:	83 ec 08             	sub    $0x8,%esp
  802c78:	ff 75 bc             	pushl  -0x44(%ebp)
  802c7b:	68 b9 44 80 00       	push   $0x8044b9
  802c80:	e8 01 da ff ff       	call   800686 <cprintf>
  802c85:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c88:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c8f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c92:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c95:	01 d0                	add    %edx,%eax
  802c97:	48                   	dec    %eax
  802c98:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c9b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca3:	f7 75 b0             	divl   -0x50(%ebp)
  802ca6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ca9:	29 d0                	sub    %edx,%eax
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	6a 01                	push   $0x1
  802cb0:	50                   	push   %eax
  802cb1:	ff 75 bc             	pushl  -0x44(%ebp)
  802cb4:	e8 51 f5 ff ff       	call   80220a <set_block_data>
  802cb9:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cbc:	83 ec 0c             	sub    $0xc,%esp
  802cbf:	ff 75 bc             	pushl  -0x44(%ebp)
  802cc2:	e8 36 04 00 00       	call   8030fd <free_block>
  802cc7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cca:	83 ec 0c             	sub    $0xc,%esp
  802ccd:	ff 75 08             	pushl  0x8(%ebp)
  802cd0:	e8 20 fa ff ff       	call   8026f5 <alloc_block_BF>
  802cd5:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cd8:	c9                   	leave  
  802cd9:	c3                   	ret    

00802cda <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802cda:	55                   	push   %ebp
  802cdb:	89 e5                	mov    %esp,%ebp
  802cdd:	53                   	push   %ebx
  802cde:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ce1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ce8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802cef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf3:	74 1e                	je     802d13 <merging+0x39>
  802cf5:	ff 75 08             	pushl  0x8(%ebp)
  802cf8:	e8 bc f1 ff ff       	call   801eb9 <get_block_size>
  802cfd:	83 c4 04             	add    $0x4,%esp
  802d00:	89 c2                	mov    %eax,%edx
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	01 d0                	add    %edx,%eax
  802d07:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d0a:	75 07                	jne    802d13 <merging+0x39>
		prev_is_free = 1;
  802d0c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d17:	74 1e                	je     802d37 <merging+0x5d>
  802d19:	ff 75 10             	pushl  0x10(%ebp)
  802d1c:	e8 98 f1 ff ff       	call   801eb9 <get_block_size>
  802d21:	83 c4 04             	add    $0x4,%esp
  802d24:	89 c2                	mov    %eax,%edx
  802d26:	8b 45 10             	mov    0x10(%ebp),%eax
  802d29:	01 d0                	add    %edx,%eax
  802d2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d2e:	75 07                	jne    802d37 <merging+0x5d>
		next_is_free = 1;
  802d30:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3b:	0f 84 cc 00 00 00    	je     802e0d <merging+0x133>
  802d41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d45:	0f 84 c2 00 00 00    	je     802e0d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d4b:	ff 75 08             	pushl  0x8(%ebp)
  802d4e:	e8 66 f1 ff ff       	call   801eb9 <get_block_size>
  802d53:	83 c4 04             	add    $0x4,%esp
  802d56:	89 c3                	mov    %eax,%ebx
  802d58:	ff 75 10             	pushl  0x10(%ebp)
  802d5b:	e8 59 f1 ff ff       	call   801eb9 <get_block_size>
  802d60:	83 c4 04             	add    $0x4,%esp
  802d63:	01 c3                	add    %eax,%ebx
  802d65:	ff 75 0c             	pushl  0xc(%ebp)
  802d68:	e8 4c f1 ff ff       	call   801eb9 <get_block_size>
  802d6d:	83 c4 04             	add    $0x4,%esp
  802d70:	01 d8                	add    %ebx,%eax
  802d72:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d75:	6a 00                	push   $0x0
  802d77:	ff 75 ec             	pushl  -0x14(%ebp)
  802d7a:	ff 75 08             	pushl  0x8(%ebp)
  802d7d:	e8 88 f4 ff ff       	call   80220a <set_block_data>
  802d82:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d89:	75 17                	jne    802da2 <merging+0xc8>
  802d8b:	83 ec 04             	sub    $0x4,%esp
  802d8e:	68 ef 43 80 00       	push   $0x8043ef
  802d93:	68 7d 01 00 00       	push   $0x17d
  802d98:	68 0d 44 80 00       	push   $0x80440d
  802d9d:	e8 b0 0b 00 00       	call   803952 <_panic>
  802da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 10                	je     802dbb <merging+0xe1>
  802dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db3:	8b 52 04             	mov    0x4(%edx),%edx
  802db6:	89 50 04             	mov    %edx,0x4(%eax)
  802db9:	eb 0b                	jmp    802dc6 <merging+0xec>
  802dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 0f                	je     802ddf <merging+0x105>
  802dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd3:	8b 40 04             	mov    0x4(%eax),%eax
  802dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd9:	8b 12                	mov    (%edx),%edx
  802ddb:	89 10                	mov    %edx,(%eax)
  802ddd:	eb 0a                	jmp    802de9 <merging+0x10f>
  802ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfc:	a1 38 50 80 00       	mov    0x805038,%eax
  802e01:	48                   	dec    %eax
  802e02:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e07:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e08:	e9 ea 02 00 00       	jmp    8030f7 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e11:	74 3b                	je     802e4e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e13:	83 ec 0c             	sub    $0xc,%esp
  802e16:	ff 75 08             	pushl  0x8(%ebp)
  802e19:	e8 9b f0 ff ff       	call   801eb9 <get_block_size>
  802e1e:	83 c4 10             	add    $0x10,%esp
  802e21:	89 c3                	mov    %eax,%ebx
  802e23:	83 ec 0c             	sub    $0xc,%esp
  802e26:	ff 75 10             	pushl  0x10(%ebp)
  802e29:	e8 8b f0 ff ff       	call   801eb9 <get_block_size>
  802e2e:	83 c4 10             	add    $0x10,%esp
  802e31:	01 d8                	add    %ebx,%eax
  802e33:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	6a 00                	push   $0x0
  802e3b:	ff 75 e8             	pushl  -0x18(%ebp)
  802e3e:	ff 75 08             	pushl  0x8(%ebp)
  802e41:	e8 c4 f3 ff ff       	call   80220a <set_block_data>
  802e46:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e49:	e9 a9 02 00 00       	jmp    8030f7 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e52:	0f 84 2d 01 00 00    	je     802f85 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e58:	83 ec 0c             	sub    $0xc,%esp
  802e5b:	ff 75 10             	pushl  0x10(%ebp)
  802e5e:	e8 56 f0 ff ff       	call   801eb9 <get_block_size>
  802e63:	83 c4 10             	add    $0x10,%esp
  802e66:	89 c3                	mov    %eax,%ebx
  802e68:	83 ec 0c             	sub    $0xc,%esp
  802e6b:	ff 75 0c             	pushl  0xc(%ebp)
  802e6e:	e8 46 f0 ff ff       	call   801eb9 <get_block_size>
  802e73:	83 c4 10             	add    $0x10,%esp
  802e76:	01 d8                	add    %ebx,%eax
  802e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e7b:	83 ec 04             	sub    $0x4,%esp
  802e7e:	6a 00                	push   $0x0
  802e80:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e83:	ff 75 10             	pushl  0x10(%ebp)
  802e86:	e8 7f f3 ff ff       	call   80220a <set_block_data>
  802e8b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e91:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e98:	74 06                	je     802ea0 <merging+0x1c6>
  802e9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e9e:	75 17                	jne    802eb7 <merging+0x1dd>
  802ea0:	83 ec 04             	sub    $0x4,%esp
  802ea3:	68 c8 44 80 00       	push   $0x8044c8
  802ea8:	68 8d 01 00 00       	push   $0x18d
  802ead:	68 0d 44 80 00       	push   $0x80440d
  802eb2:	e8 9b 0a 00 00       	call   803952 <_panic>
  802eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eba:	8b 50 04             	mov    0x4(%eax),%edx
  802ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec9:	89 10                	mov    %edx,(%eax)
  802ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0d                	je     802ee2 <merging+0x208>
  802ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ede:	89 10                	mov    %edx,(%eax)
  802ee0:	eb 08                	jmp    802eea <merging+0x210>
  802ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ef8:	40                   	inc    %eax
  802ef9:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802efe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f02:	75 17                	jne    802f1b <merging+0x241>
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 ef 43 80 00       	push   $0x8043ef
  802f0c:	68 8e 01 00 00       	push   $0x18e
  802f11:	68 0d 44 80 00       	push   $0x80440d
  802f16:	e8 37 0a 00 00       	call   803952 <_panic>
  802f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	74 10                	je     802f34 <merging+0x25a>
  802f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2c:	8b 52 04             	mov    0x4(%edx),%edx
  802f2f:	89 50 04             	mov    %edx,0x4(%eax)
  802f32:	eb 0b                	jmp    802f3f <merging+0x265>
  802f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f37:	8b 40 04             	mov    0x4(%eax),%eax
  802f3a:	a3 30 50 80 00       	mov    %eax,0x805030
  802f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f42:	8b 40 04             	mov    0x4(%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 0f                	je     802f58 <merging+0x27e>
  802f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f52:	8b 12                	mov    (%edx),%edx
  802f54:	89 10                	mov    %edx,(%eax)
  802f56:	eb 0a                	jmp    802f62 <merging+0x288>
  802f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f75:	a1 38 50 80 00       	mov    0x805038,%eax
  802f7a:	48                   	dec    %eax
  802f7b:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f80:	e9 72 01 00 00       	jmp    8030f7 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f85:	8b 45 10             	mov    0x10(%ebp),%eax
  802f88:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8f:	74 79                	je     80300a <merging+0x330>
  802f91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f95:	74 73                	je     80300a <merging+0x330>
  802f97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9b:	74 06                	je     802fa3 <merging+0x2c9>
  802f9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fa1:	75 17                	jne    802fba <merging+0x2e0>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 80 44 80 00       	push   $0x804480
  802fab:	68 94 01 00 00       	push   $0x194
  802fb0:	68 0d 44 80 00       	push   $0x80440d
  802fb5:	e8 98 09 00 00       	call   803952 <_panic>
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 10                	mov    (%eax),%edx
  802fbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc2:	89 10                	mov    %edx,(%eax)
  802fc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	74 0b                	je     802fd8 <merging+0x2fe>
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd5:	89 50 04             	mov    %edx,0x4(%eax)
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fde:	89 10                	mov    %edx,(%eax)
  802fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	85 c0                	test   %eax,%eax
  802ff0:	75 08                	jne    802ffa <merging+0x320>
  802ff2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff5:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffa:	a1 38 50 80 00       	mov    0x805038,%eax
  802fff:	40                   	inc    %eax
  803000:	a3 38 50 80 00       	mov    %eax,0x805038
  803005:	e9 ce 00 00 00       	jmp    8030d8 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80300a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300e:	74 65                	je     803075 <merging+0x39b>
  803010:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803014:	75 17                	jne    80302d <merging+0x353>
  803016:	83 ec 04             	sub    $0x4,%esp
  803019:	68 5c 44 80 00       	push   $0x80445c
  80301e:	68 95 01 00 00       	push   $0x195
  803023:	68 0d 44 80 00       	push   $0x80440d
  803028:	e8 25 09 00 00       	call   803952 <_panic>
  80302d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803033:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803036:	89 50 04             	mov    %edx,0x4(%eax)
  803039:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	74 0c                	je     80304f <merging+0x375>
  803043:	a1 30 50 80 00       	mov    0x805030,%eax
  803048:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80304b:	89 10                	mov    %edx,(%eax)
  80304d:	eb 08                	jmp    803057 <merging+0x37d>
  80304f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803052:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803057:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305a:	a3 30 50 80 00       	mov    %eax,0x805030
  80305f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803068:	a1 38 50 80 00       	mov    0x805038,%eax
  80306d:	40                   	inc    %eax
  80306e:	a3 38 50 80 00       	mov    %eax,0x805038
  803073:	eb 63                	jmp    8030d8 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803075:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803079:	75 17                	jne    803092 <merging+0x3b8>
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 28 44 80 00       	push   $0x804428
  803083:	68 98 01 00 00       	push   $0x198
  803088:	68 0d 44 80 00       	push   $0x80440d
  80308d:	e8 c0 08 00 00       	call   803952 <_panic>
  803092:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803098:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	74 0d                	je     8030b3 <merging+0x3d9>
  8030a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%eax)
  8030b1:	eb 08                	jmp    8030bb <merging+0x3e1>
  8030b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8030bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d2:	40                   	inc    %eax
  8030d3:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030d8:	83 ec 0c             	sub    $0xc,%esp
  8030db:	ff 75 10             	pushl  0x10(%ebp)
  8030de:	e8 d6 ed ff ff       	call   801eb9 <get_block_size>
  8030e3:	83 c4 10             	add    $0x10,%esp
  8030e6:	83 ec 04             	sub    $0x4,%esp
  8030e9:	6a 00                	push   $0x0
  8030eb:	50                   	push   %eax
  8030ec:	ff 75 10             	pushl  0x10(%ebp)
  8030ef:	e8 16 f1 ff ff       	call   80220a <set_block_data>
  8030f4:	83 c4 10             	add    $0x10,%esp
	}
}
  8030f7:	90                   	nop
  8030f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030fb:	c9                   	leave  
  8030fc:	c3                   	ret    

008030fd <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030fd:	55                   	push   %ebp
  8030fe:	89 e5                	mov    %esp,%ebp
  803100:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803103:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803108:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80310b:	a1 30 50 80 00       	mov    0x805030,%eax
  803110:	3b 45 08             	cmp    0x8(%ebp),%eax
  803113:	73 1b                	jae    803130 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803115:	a1 30 50 80 00       	mov    0x805030,%eax
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	ff 75 08             	pushl  0x8(%ebp)
  803120:	6a 00                	push   $0x0
  803122:	50                   	push   %eax
  803123:	e8 b2 fb ff ff       	call   802cda <merging>
  803128:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80312b:	e9 8b 00 00 00       	jmp    8031bb <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803130:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803135:	3b 45 08             	cmp    0x8(%ebp),%eax
  803138:	76 18                	jbe    803152 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80313a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	ff 75 08             	pushl  0x8(%ebp)
  803145:	50                   	push   %eax
  803146:	6a 00                	push   $0x0
  803148:	e8 8d fb ff ff       	call   802cda <merging>
  80314d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803150:	eb 69                	jmp    8031bb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803152:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315a:	eb 39                	jmp    803195 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803162:	73 29                	jae    80318d <free_block+0x90>
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316c:	76 1f                	jbe    80318d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	ff 75 08             	pushl  0x8(%ebp)
  80317c:	ff 75 f0             	pushl  -0x10(%ebp)
  80317f:	ff 75 f4             	pushl  -0xc(%ebp)
  803182:	e8 53 fb ff ff       	call   802cda <merging>
  803187:	83 c4 10             	add    $0x10,%esp
			break;
  80318a:	90                   	nop
		}
	}
}
  80318b:	eb 2e                	jmp    8031bb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80318d:	a1 34 50 80 00       	mov    0x805034,%eax
  803192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803195:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803199:	74 07                	je     8031a2 <free_block+0xa5>
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	eb 05                	jmp    8031a7 <free_block+0xaa>
  8031a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a7:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	75 a7                	jne    80315c <free_block+0x5f>
  8031b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b9:	75 a1                	jne    80315c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031bb:	90                   	nop
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
  8031c1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031c4:	ff 75 08             	pushl  0x8(%ebp)
  8031c7:	e8 ed ec ff ff       	call   801eb9 <get_block_size>
  8031cc:	83 c4 04             	add    $0x4,%esp
  8031cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031d9:	eb 17                	jmp    8031f2 <copy_data+0x34>
  8031db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e1:	01 c2                	add    %eax,%edx
  8031e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	01 c8                	add    %ecx,%eax
  8031eb:	8a 00                	mov    (%eax),%al
  8031ed:	88 02                	mov    %al,(%edx)
  8031ef:	ff 45 fc             	incl   -0x4(%ebp)
  8031f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031f8:	72 e1                	jb     8031db <copy_data+0x1d>
}
  8031fa:	90                   	nop
  8031fb:	c9                   	leave  
  8031fc:	c3                   	ret    

008031fd <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031fd:	55                   	push   %ebp
  8031fe:	89 e5                	mov    %esp,%ebp
  803200:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803203:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803207:	75 23                	jne    80322c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803209:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80320d:	74 13                	je     803222 <realloc_block_FF+0x25>
  80320f:	83 ec 0c             	sub    $0xc,%esp
  803212:	ff 75 0c             	pushl  0xc(%ebp)
  803215:	e8 1f f0 ff ff       	call   802239 <alloc_block_FF>
  80321a:	83 c4 10             	add    $0x10,%esp
  80321d:	e9 f4 06 00 00       	jmp    803916 <realloc_block_FF+0x719>
		return NULL;
  803222:	b8 00 00 00 00       	mov    $0x0,%eax
  803227:	e9 ea 06 00 00       	jmp    803916 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80322c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803230:	75 18                	jne    80324a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803232:	83 ec 0c             	sub    $0xc,%esp
  803235:	ff 75 08             	pushl  0x8(%ebp)
  803238:	e8 c0 fe ff ff       	call   8030fd <free_block>
  80323d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803240:	b8 00 00 00 00       	mov    $0x0,%eax
  803245:	e9 cc 06 00 00       	jmp    803916 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80324a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80324e:	77 07                	ja     803257 <realloc_block_FF+0x5a>
  803250:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325a:	83 e0 01             	and    $0x1,%eax
  80325d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803260:	8b 45 0c             	mov    0xc(%ebp),%eax
  803263:	83 c0 08             	add    $0x8,%eax
  803266:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803269:	83 ec 0c             	sub    $0xc,%esp
  80326c:	ff 75 08             	pushl  0x8(%ebp)
  80326f:	e8 45 ec ff ff       	call   801eb9 <get_block_size>
  803274:	83 c4 10             	add    $0x10,%esp
  803277:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80327a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327d:	83 e8 08             	sub    $0x8,%eax
  803280:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	83 e8 04             	sub    $0x4,%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	83 e0 fe             	and    $0xfffffffe,%eax
  80328e:	89 c2                	mov    %eax,%edx
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	01 d0                	add    %edx,%eax
  803295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803298:	83 ec 0c             	sub    $0xc,%esp
  80329b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80329e:	e8 16 ec ff ff       	call   801eb9 <get_block_size>
  8032a3:	83 c4 10             	add    $0x10,%esp
  8032a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ac:	83 e8 08             	sub    $0x8,%eax
  8032af:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032b8:	75 08                	jne    8032c2 <realloc_block_FF+0xc5>
	{
		 return va;
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	e9 54 06 00 00       	jmp    803916 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032c8:	0f 83 e5 03 00 00    	jae    8036b3 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032d7:	83 ec 0c             	sub    $0xc,%esp
  8032da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032dd:	e8 f0 eb ff ff       	call   801ed2 <is_free_block>
  8032e2:	83 c4 10             	add    $0x10,%esp
  8032e5:	84 c0                	test   %al,%al
  8032e7:	0f 84 3b 01 00 00    	je     803428 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032f3:	01 d0                	add    %edx,%eax
  8032f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032f8:	83 ec 04             	sub    $0x4,%esp
  8032fb:	6a 01                	push   $0x1
  8032fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803300:	ff 75 08             	pushl  0x8(%ebp)
  803303:	e8 02 ef ff ff       	call   80220a <set_block_data>
  803308:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	83 e8 04             	sub    $0x4,%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	83 e0 fe             	and    $0xfffffffe,%eax
  803316:	89 c2                	mov    %eax,%edx
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	01 d0                	add    %edx,%eax
  80331d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	6a 00                	push   $0x0
  803325:	ff 75 cc             	pushl  -0x34(%ebp)
  803328:	ff 75 c8             	pushl  -0x38(%ebp)
  80332b:	e8 da ee ff ff       	call   80220a <set_block_data>
  803330:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803333:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803337:	74 06                	je     80333f <realloc_block_FF+0x142>
  803339:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80333d:	75 17                	jne    803356 <realloc_block_FF+0x159>
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	68 80 44 80 00       	push   $0x804480
  803347:	68 f6 01 00 00       	push   $0x1f6
  80334c:	68 0d 44 80 00       	push   $0x80440d
  803351:	e8 fc 05 00 00       	call   803952 <_panic>
  803356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803359:	8b 10                	mov    (%eax),%edx
  80335b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80335e:	89 10                	mov    %edx,(%eax)
  803360:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0b                	je     803374 <realloc_block_FF+0x177>
  803369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803371:	89 50 04             	mov    %edx,0x4(%eax)
  803374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803377:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80337a:	89 10                	mov    %edx,(%eax)
  80337c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80337f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803382:	89 50 04             	mov    %edx,0x4(%eax)
  803385:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	75 08                	jne    803396 <realloc_block_FF+0x199>
  80338e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803391:	a3 30 50 80 00       	mov    %eax,0x805030
  803396:	a1 38 50 80 00       	mov    0x805038,%eax
  80339b:	40                   	inc    %eax
  80339c:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033a5:	75 17                	jne    8033be <realloc_block_FF+0x1c1>
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	68 ef 43 80 00       	push   $0x8043ef
  8033af:	68 f7 01 00 00       	push   $0x1f7
  8033b4:	68 0d 44 80 00       	push   $0x80440d
  8033b9:	e8 94 05 00 00       	call   803952 <_panic>
  8033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	74 10                	je     8033d7 <realloc_block_FF+0x1da>
  8033c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033cf:	8b 52 04             	mov    0x4(%edx),%edx
  8033d2:	89 50 04             	mov    %edx,0x4(%eax)
  8033d5:	eb 0b                	jmp    8033e2 <realloc_block_FF+0x1e5>
  8033d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033da:	8b 40 04             	mov    0x4(%eax),%eax
  8033dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e5:	8b 40 04             	mov    0x4(%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	74 0f                	je     8033fb <realloc_block_FF+0x1fe>
  8033ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ef:	8b 40 04             	mov    0x4(%eax),%eax
  8033f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f5:	8b 12                	mov    (%edx),%edx
  8033f7:	89 10                	mov    %edx,(%eax)
  8033f9:	eb 0a                	jmp    803405 <realloc_block_FF+0x208>
  8033fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803408:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803411:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803418:	a1 38 50 80 00       	mov    0x805038,%eax
  80341d:	48                   	dec    %eax
  80341e:	a3 38 50 80 00       	mov    %eax,0x805038
  803423:	e9 83 02 00 00       	jmp    8036ab <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803428:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80342c:	0f 86 69 02 00 00    	jbe    80369b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803432:	83 ec 04             	sub    $0x4,%esp
  803435:	6a 01                	push   $0x1
  803437:	ff 75 f0             	pushl  -0x10(%ebp)
  80343a:	ff 75 08             	pushl  0x8(%ebp)
  80343d:	e8 c8 ed ff ff       	call   80220a <set_block_data>
  803442:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	83 e8 04             	sub    $0x4,%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	83 e0 fe             	and    $0xfffffffe,%eax
  803450:	89 c2                	mov    %eax,%edx
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	01 d0                	add    %edx,%eax
  803457:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80345a:	a1 38 50 80 00       	mov    0x805038,%eax
  80345f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803462:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803466:	75 68                	jne    8034d0 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803468:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80346c:	75 17                	jne    803485 <realloc_block_FF+0x288>
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 28 44 80 00       	push   $0x804428
  803476:	68 06 02 00 00       	push   $0x206
  80347b:	68 0d 44 80 00       	push   $0x80440d
  803480:	e8 cd 04 00 00       	call   803952 <_panic>
  803485:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80348b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0d                	je     8034a6 <realloc_block_FF+0x2a9>
  803499:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80349e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%eax)
  8034a4:	eb 08                	jmp    8034ae <realloc_block_FF+0x2b1>
  8034a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c5:	40                   	inc    %eax
  8034c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8034cb:	e9 b0 01 00 00       	jmp    803680 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034d8:	76 68                	jbe    803542 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034de:	75 17                	jne    8034f7 <realloc_block_FF+0x2fa>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 28 44 80 00       	push   $0x804428
  8034e8:	68 0b 02 00 00       	push   $0x20b
  8034ed:	68 0d 44 80 00       	push   $0x80440d
  8034f2:	e8 5b 04 00 00       	call   803952 <_panic>
  8034f7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803500:	89 10                	mov    %edx,(%eax)
  803502:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 0d                	je     803518 <realloc_block_FF+0x31b>
  80350b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803513:	89 50 04             	mov    %edx,0x4(%eax)
  803516:	eb 08                	jmp    803520 <realloc_block_FF+0x323>
  803518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351b:	a3 30 50 80 00       	mov    %eax,0x805030
  803520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803523:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 38 50 80 00       	mov    0x805038,%eax
  803537:	40                   	inc    %eax
  803538:	a3 38 50 80 00       	mov    %eax,0x805038
  80353d:	e9 3e 01 00 00       	jmp    803680 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803542:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803547:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80354a:	73 68                	jae    8035b4 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80354c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803550:	75 17                	jne    803569 <realloc_block_FF+0x36c>
  803552:	83 ec 04             	sub    $0x4,%esp
  803555:	68 5c 44 80 00       	push   $0x80445c
  80355a:	68 10 02 00 00       	push   $0x210
  80355f:	68 0d 44 80 00       	push   $0x80440d
  803564:	e8 e9 03 00 00       	call   803952 <_panic>
  803569:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80356f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803572:	89 50 04             	mov    %edx,0x4(%eax)
  803575:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803578:	8b 40 04             	mov    0x4(%eax),%eax
  80357b:	85 c0                	test   %eax,%eax
  80357d:	74 0c                	je     80358b <realloc_block_FF+0x38e>
  80357f:	a1 30 50 80 00       	mov    0x805030,%eax
  803584:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803587:	89 10                	mov    %edx,(%eax)
  803589:	eb 08                	jmp    803593 <realloc_block_FF+0x396>
  80358b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803593:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803596:	a3 30 50 80 00       	mov    %eax,0x805030
  80359b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a9:	40                   	inc    %eax
  8035aa:	a3 38 50 80 00       	mov    %eax,0x805038
  8035af:	e9 cc 00 00 00       	jmp    803680 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c3:	e9 8a 00 00 00       	jmp    803652 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ce:	73 7a                	jae    80364a <realloc_block_FF+0x44d>
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d8:	73 70                	jae    80364a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035de:	74 06                	je     8035e6 <realloc_block_FF+0x3e9>
  8035e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e4:	75 17                	jne    8035fd <realloc_block_FF+0x400>
  8035e6:	83 ec 04             	sub    $0x4,%esp
  8035e9:	68 80 44 80 00       	push   $0x804480
  8035ee:	68 1a 02 00 00       	push   $0x21a
  8035f3:	68 0d 44 80 00       	push   $0x80440d
  8035f8:	e8 55 03 00 00       	call   803952 <_panic>
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 10                	mov    (%eax),%edx
  803602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803605:	89 10                	mov    %edx,(%eax)
  803607:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 0b                	je     80361b <realloc_block_FF+0x41e>
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803618:	89 50 04             	mov    %edx,0x4(%eax)
  80361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803621:	89 10                	mov    %edx,(%eax)
  803623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803626:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803629:	89 50 04             	mov    %edx,0x4(%eax)
  80362c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	75 08                	jne    80363d <realloc_block_FF+0x440>
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	a3 30 50 80 00       	mov    %eax,0x805030
  80363d:	a1 38 50 80 00       	mov    0x805038,%eax
  803642:	40                   	inc    %eax
  803643:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803648:	eb 36                	jmp    803680 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80364a:	a1 34 50 80 00       	mov    0x805034,%eax
  80364f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803656:	74 07                	je     80365f <realloc_block_FF+0x462>
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	eb 05                	jmp    803664 <realloc_block_FF+0x467>
  80365f:	b8 00 00 00 00       	mov    $0x0,%eax
  803664:	a3 34 50 80 00       	mov    %eax,0x805034
  803669:	a1 34 50 80 00       	mov    0x805034,%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	0f 85 52 ff ff ff    	jne    8035c8 <realloc_block_FF+0x3cb>
  803676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367a:	0f 85 48 ff ff ff    	jne    8035c8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803680:	83 ec 04             	sub    $0x4,%esp
  803683:	6a 00                	push   $0x0
  803685:	ff 75 d8             	pushl  -0x28(%ebp)
  803688:	ff 75 d4             	pushl  -0x2c(%ebp)
  80368b:	e8 7a eb ff ff       	call   80220a <set_block_data>
  803690:	83 c4 10             	add    $0x10,%esp
				return va;
  803693:	8b 45 08             	mov    0x8(%ebp),%eax
  803696:	e9 7b 02 00 00       	jmp    803916 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80369b:	83 ec 0c             	sub    $0xc,%esp
  80369e:	68 fd 44 80 00       	push   $0x8044fd
  8036a3:	e8 de cf ff ff       	call   800686 <cprintf>
  8036a8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ae:	e9 63 02 00 00       	jmp    803916 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036b9:	0f 86 4d 02 00 00    	jbe    80390c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036bf:	83 ec 0c             	sub    $0xc,%esp
  8036c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036c5:	e8 08 e8 ff ff       	call   801ed2 <is_free_block>
  8036ca:	83 c4 10             	add    $0x10,%esp
  8036cd:	84 c0                	test   %al,%al
  8036cf:	0f 84 37 02 00 00    	je     80390c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036e4:	76 38                	jbe    80371e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8036e6:	83 ec 0c             	sub    $0xc,%esp
  8036e9:	ff 75 08             	pushl  0x8(%ebp)
  8036ec:	e8 0c fa ff ff       	call   8030fd <free_block>
  8036f1:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036f4:	83 ec 0c             	sub    $0xc,%esp
  8036f7:	ff 75 0c             	pushl  0xc(%ebp)
  8036fa:	e8 3a eb ff ff       	call   802239 <alloc_block_FF>
  8036ff:	83 c4 10             	add    $0x10,%esp
  803702:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803705:	83 ec 08             	sub    $0x8,%esp
  803708:	ff 75 c0             	pushl  -0x40(%ebp)
  80370b:	ff 75 08             	pushl  0x8(%ebp)
  80370e:	e8 ab fa ff ff       	call   8031be <copy_data>
  803713:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803716:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803719:	e9 f8 01 00 00       	jmp    803916 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80371e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803721:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803724:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803727:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80372b:	0f 87 a0 00 00 00    	ja     8037d1 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803731:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803735:	75 17                	jne    80374e <realloc_block_FF+0x551>
  803737:	83 ec 04             	sub    $0x4,%esp
  80373a:	68 ef 43 80 00       	push   $0x8043ef
  80373f:	68 38 02 00 00       	push   $0x238
  803744:	68 0d 44 80 00       	push   $0x80440d
  803749:	e8 04 02 00 00       	call   803952 <_panic>
  80374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803751:	8b 00                	mov    (%eax),%eax
  803753:	85 c0                	test   %eax,%eax
  803755:	74 10                	je     803767 <realloc_block_FF+0x56a>
  803757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375f:	8b 52 04             	mov    0x4(%edx),%edx
  803762:	89 50 04             	mov    %edx,0x4(%eax)
  803765:	eb 0b                	jmp    803772 <realloc_block_FF+0x575>
  803767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376a:	8b 40 04             	mov    0x4(%eax),%eax
  80376d:	a3 30 50 80 00       	mov    %eax,0x805030
  803772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803775:	8b 40 04             	mov    0x4(%eax),%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	74 0f                	je     80378b <realloc_block_FF+0x58e>
  80377c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377f:	8b 40 04             	mov    0x4(%eax),%eax
  803782:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803785:	8b 12                	mov    (%edx),%edx
  803787:	89 10                	mov    %edx,(%eax)
  803789:	eb 0a                	jmp    803795 <realloc_block_FF+0x598>
  80378b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378e:	8b 00                	mov    (%eax),%eax
  803790:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ad:	48                   	dec    %eax
  8037ae:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b9:	01 d0                	add    %edx,%eax
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	6a 01                	push   $0x1
  8037c0:	50                   	push   %eax
  8037c1:	ff 75 08             	pushl  0x8(%ebp)
  8037c4:	e8 41 ea ff ff       	call   80220a <set_block_data>
  8037c9:	83 c4 10             	add    $0x10,%esp
  8037cc:	e9 36 01 00 00       	jmp    803907 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037d7:	01 d0                	add    %edx,%eax
  8037d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	6a 01                	push   $0x1
  8037e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8037e4:	ff 75 08             	pushl  0x8(%ebp)
  8037e7:	e8 1e ea ff ff       	call   80220a <set_block_data>
  8037ec:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	83 e8 04             	sub    $0x4,%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	83 e0 fe             	and    $0xfffffffe,%eax
  8037fa:	89 c2                	mov    %eax,%edx
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	01 d0                	add    %edx,%eax
  803801:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803804:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803808:	74 06                	je     803810 <realloc_block_FF+0x613>
  80380a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80380e:	75 17                	jne    803827 <realloc_block_FF+0x62a>
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	68 80 44 80 00       	push   $0x804480
  803818:	68 44 02 00 00       	push   $0x244
  80381d:	68 0d 44 80 00       	push   $0x80440d
  803822:	e8 2b 01 00 00       	call   803952 <_panic>
  803827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382a:	8b 10                	mov    (%eax),%edx
  80382c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80382f:	89 10                	mov    %edx,(%eax)
  803831:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803834:	8b 00                	mov    (%eax),%eax
  803836:	85 c0                	test   %eax,%eax
  803838:	74 0b                	je     803845 <realloc_block_FF+0x648>
  80383a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383d:	8b 00                	mov    (%eax),%eax
  80383f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803842:	89 50 04             	mov    %edx,0x4(%eax)
  803845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803848:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80384b:	89 10                	mov    %edx,(%eax)
  80384d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803853:	89 50 04             	mov    %edx,0x4(%eax)
  803856:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803859:	8b 00                	mov    (%eax),%eax
  80385b:	85 c0                	test   %eax,%eax
  80385d:	75 08                	jne    803867 <realloc_block_FF+0x66a>
  80385f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803862:	a3 30 50 80 00       	mov    %eax,0x805030
  803867:	a1 38 50 80 00       	mov    0x805038,%eax
  80386c:	40                   	inc    %eax
  80386d:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803872:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803876:	75 17                	jne    80388f <realloc_block_FF+0x692>
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	68 ef 43 80 00       	push   $0x8043ef
  803880:	68 45 02 00 00       	push   $0x245
  803885:	68 0d 44 80 00       	push   $0x80440d
  80388a:	e8 c3 00 00 00       	call   803952 <_panic>
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	85 c0                	test   %eax,%eax
  803896:	74 10                	je     8038a8 <realloc_block_FF+0x6ab>
  803898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a0:	8b 52 04             	mov    0x4(%edx),%edx
  8038a3:	89 50 04             	mov    %edx,0x4(%eax)
  8038a6:	eb 0b                	jmp    8038b3 <realloc_block_FF+0x6b6>
  8038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ab:	8b 40 04             	mov    0x4(%eax),%eax
  8038ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b6:	8b 40 04             	mov    0x4(%eax),%eax
  8038b9:	85 c0                	test   %eax,%eax
  8038bb:	74 0f                	je     8038cc <realloc_block_FF+0x6cf>
  8038bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c0:	8b 40 04             	mov    0x4(%eax),%eax
  8038c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c6:	8b 12                	mov    (%edx),%edx
  8038c8:	89 10                	mov    %edx,(%eax)
  8038ca:	eb 0a                	jmp    8038d6 <realloc_block_FF+0x6d9>
  8038cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ee:	48                   	dec    %eax
  8038ef:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038f4:	83 ec 04             	sub    $0x4,%esp
  8038f7:	6a 00                	push   $0x0
  8038f9:	ff 75 bc             	pushl  -0x44(%ebp)
  8038fc:	ff 75 b8             	pushl  -0x48(%ebp)
  8038ff:	e8 06 e9 ff ff       	call   80220a <set_block_data>
  803904:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	eb 0a                	jmp    803916 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80390c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803916:	c9                   	leave  
  803917:	c3                   	ret    

00803918 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803918:	55                   	push   %ebp
  803919:	89 e5                	mov    %esp,%ebp
  80391b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80391e:	83 ec 04             	sub    $0x4,%esp
  803921:	68 04 45 80 00       	push   $0x804504
  803926:	68 58 02 00 00       	push   $0x258
  80392b:	68 0d 44 80 00       	push   $0x80440d
  803930:	e8 1d 00 00 00       	call   803952 <_panic>

00803935 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803935:	55                   	push   %ebp
  803936:	89 e5                	mov    %esp,%ebp
  803938:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80393b:	83 ec 04             	sub    $0x4,%esp
  80393e:	68 2c 45 80 00       	push   $0x80452c
  803943:	68 61 02 00 00       	push   $0x261
  803948:	68 0d 44 80 00       	push   $0x80440d
  80394d:	e8 00 00 00 00       	call   803952 <_panic>

00803952 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803958:	8d 45 10             	lea    0x10(%ebp),%eax
  80395b:	83 c0 04             	add    $0x4,%eax
  80395e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803961:	a1 60 50 90 00       	mov    0x905060,%eax
  803966:	85 c0                	test   %eax,%eax
  803968:	74 16                	je     803980 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80396a:	a1 60 50 90 00       	mov    0x905060,%eax
  80396f:	83 ec 08             	sub    $0x8,%esp
  803972:	50                   	push   %eax
  803973:	68 54 45 80 00       	push   $0x804554
  803978:	e8 09 cd ff ff       	call   800686 <cprintf>
  80397d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803980:	a1 00 50 80 00       	mov    0x805000,%eax
  803985:	ff 75 0c             	pushl  0xc(%ebp)
  803988:	ff 75 08             	pushl  0x8(%ebp)
  80398b:	50                   	push   %eax
  80398c:	68 59 45 80 00       	push   $0x804559
  803991:	e8 f0 cc ff ff       	call   800686 <cprintf>
  803996:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803999:	8b 45 10             	mov    0x10(%ebp),%eax
  80399c:	83 ec 08             	sub    $0x8,%esp
  80399f:	ff 75 f4             	pushl  -0xc(%ebp)
  8039a2:	50                   	push   %eax
  8039a3:	e8 73 cc ff ff       	call   80061b <vcprintf>
  8039a8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8039ab:	83 ec 08             	sub    $0x8,%esp
  8039ae:	6a 00                	push   $0x0
  8039b0:	68 75 45 80 00       	push   $0x804575
  8039b5:	e8 61 cc ff ff       	call   80061b <vcprintf>
  8039ba:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039bd:	e8 e2 cb ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  8039c2:	eb fe                	jmp    8039c2 <_panic+0x70>

008039c4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039c4:	55                   	push   %ebp
  8039c5:	89 e5                	mov    %esp,%ebp
  8039c7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8039cf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d8:	39 c2                	cmp    %eax,%edx
  8039da:	74 14                	je     8039f0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039dc:	83 ec 04             	sub    $0x4,%esp
  8039df:	68 78 45 80 00       	push   $0x804578
  8039e4:	6a 26                	push   $0x26
  8039e6:	68 c4 45 80 00       	push   $0x8045c4
  8039eb:	e8 62 ff ff ff       	call   803952 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039fe:	e9 c5 00 00 00       	jmp    803ac8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	01 d0                	add    %edx,%eax
  803a12:	8b 00                	mov    (%eax),%eax
  803a14:	85 c0                	test   %eax,%eax
  803a16:	75 08                	jne    803a20 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a18:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a1b:	e9 a5 00 00 00       	jmp    803ac5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a27:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a2e:	eb 69                	jmp    803a99 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a30:	a1 20 50 80 00       	mov    0x805020,%eax
  803a35:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a3e:	89 d0                	mov    %edx,%eax
  803a40:	01 c0                	add    %eax,%eax
  803a42:	01 d0                	add    %edx,%eax
  803a44:	c1 e0 03             	shl    $0x3,%eax
  803a47:	01 c8                	add    %ecx,%eax
  803a49:	8a 40 04             	mov    0x4(%eax),%al
  803a4c:	84 c0                	test   %al,%al
  803a4e:	75 46                	jne    803a96 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a50:	a1 20 50 80 00       	mov    0x805020,%eax
  803a55:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5e:	89 d0                	mov    %edx,%eax
  803a60:	01 c0                	add    %eax,%eax
  803a62:	01 d0                	add    %edx,%eax
  803a64:	c1 e0 03             	shl    $0x3,%eax
  803a67:	01 c8                	add    %ecx,%eax
  803a69:	8b 00                	mov    (%eax),%eax
  803a6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a76:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	01 c8                	add    %ecx,%eax
  803a87:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a89:	39 c2                	cmp    %eax,%edx
  803a8b:	75 09                	jne    803a96 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a8d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a94:	eb 15                	jmp    803aab <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a96:	ff 45 e8             	incl   -0x18(%ebp)
  803a99:	a1 20 50 80 00       	mov    0x805020,%eax
  803a9e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa7:	39 c2                	cmp    %eax,%edx
  803aa9:	77 85                	ja     803a30 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803aab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803aaf:	75 14                	jne    803ac5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ab1:	83 ec 04             	sub    $0x4,%esp
  803ab4:	68 d0 45 80 00       	push   $0x8045d0
  803ab9:	6a 3a                	push   $0x3a
  803abb:	68 c4 45 80 00       	push   $0x8045c4
  803ac0:	e8 8d fe ff ff       	call   803952 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803ac5:	ff 45 f0             	incl   -0x10(%ebp)
  803ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803acb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ace:	0f 8c 2f ff ff ff    	jl     803a03 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ad4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803adb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ae2:	eb 26                	jmp    803b0a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ae4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803af2:	89 d0                	mov    %edx,%eax
  803af4:	01 c0                	add    %eax,%eax
  803af6:	01 d0                	add    %edx,%eax
  803af8:	c1 e0 03             	shl    $0x3,%eax
  803afb:	01 c8                	add    %ecx,%eax
  803afd:	8a 40 04             	mov    0x4(%eax),%al
  803b00:	3c 01                	cmp    $0x1,%al
  803b02:	75 03                	jne    803b07 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b04:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b07:	ff 45 e0             	incl   -0x20(%ebp)
  803b0a:	a1 20 50 80 00       	mov    0x805020,%eax
  803b0f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b18:	39 c2                	cmp    %eax,%edx
  803b1a:	77 c8                	ja     803ae4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b22:	74 14                	je     803b38 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b24:	83 ec 04             	sub    $0x4,%esp
  803b27:	68 24 46 80 00       	push   $0x804624
  803b2c:	6a 44                	push   $0x44
  803b2e:	68 c4 45 80 00       	push   $0x8045c4
  803b33:	e8 1a fe ff ff       	call   803952 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b38:	90                   	nop
  803b39:	c9                   	leave  
  803b3a:	c3                   	ret    
  803b3b:	90                   	nop

00803b3c <__udivdi3>:
  803b3c:	55                   	push   %ebp
  803b3d:	57                   	push   %edi
  803b3e:	56                   	push   %esi
  803b3f:	53                   	push   %ebx
  803b40:	83 ec 1c             	sub    $0x1c,%esp
  803b43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b53:	89 ca                	mov    %ecx,%edx
  803b55:	89 f8                	mov    %edi,%eax
  803b57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b5b:	85 f6                	test   %esi,%esi
  803b5d:	75 2d                	jne    803b8c <__udivdi3+0x50>
  803b5f:	39 cf                	cmp    %ecx,%edi
  803b61:	77 65                	ja     803bc8 <__udivdi3+0x8c>
  803b63:	89 fd                	mov    %edi,%ebp
  803b65:	85 ff                	test   %edi,%edi
  803b67:	75 0b                	jne    803b74 <__udivdi3+0x38>
  803b69:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	f7 f7                	div    %edi
  803b72:	89 c5                	mov    %eax,%ebp
  803b74:	31 d2                	xor    %edx,%edx
  803b76:	89 c8                	mov    %ecx,%eax
  803b78:	f7 f5                	div    %ebp
  803b7a:	89 c1                	mov    %eax,%ecx
  803b7c:	89 d8                	mov    %ebx,%eax
  803b7e:	f7 f5                	div    %ebp
  803b80:	89 cf                	mov    %ecx,%edi
  803b82:	89 fa                	mov    %edi,%edx
  803b84:	83 c4 1c             	add    $0x1c,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5e                   	pop    %esi
  803b89:	5f                   	pop    %edi
  803b8a:	5d                   	pop    %ebp
  803b8b:	c3                   	ret    
  803b8c:	39 ce                	cmp    %ecx,%esi
  803b8e:	77 28                	ja     803bb8 <__udivdi3+0x7c>
  803b90:	0f bd fe             	bsr    %esi,%edi
  803b93:	83 f7 1f             	xor    $0x1f,%edi
  803b96:	75 40                	jne    803bd8 <__udivdi3+0x9c>
  803b98:	39 ce                	cmp    %ecx,%esi
  803b9a:	72 0a                	jb     803ba6 <__udivdi3+0x6a>
  803b9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ba0:	0f 87 9e 00 00 00    	ja     803c44 <__udivdi3+0x108>
  803ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bab:	89 fa                	mov    %edi,%edx
  803bad:	83 c4 1c             	add    $0x1c,%esp
  803bb0:	5b                   	pop    %ebx
  803bb1:	5e                   	pop    %esi
  803bb2:	5f                   	pop    %edi
  803bb3:	5d                   	pop    %ebp
  803bb4:	c3                   	ret    
  803bb5:	8d 76 00             	lea    0x0(%esi),%esi
  803bb8:	31 ff                	xor    %edi,%edi
  803bba:	31 c0                	xor    %eax,%eax
  803bbc:	89 fa                	mov    %edi,%edx
  803bbe:	83 c4 1c             	add    $0x1c,%esp
  803bc1:	5b                   	pop    %ebx
  803bc2:	5e                   	pop    %esi
  803bc3:	5f                   	pop    %edi
  803bc4:	5d                   	pop    %ebp
  803bc5:	c3                   	ret    
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	89 d8                	mov    %ebx,%eax
  803bca:	f7 f7                	div    %edi
  803bcc:	31 ff                	xor    %edi,%edi
  803bce:	89 fa                	mov    %edi,%edx
  803bd0:	83 c4 1c             	add    $0x1c,%esp
  803bd3:	5b                   	pop    %ebx
  803bd4:	5e                   	pop    %esi
  803bd5:	5f                   	pop    %edi
  803bd6:	5d                   	pop    %ebp
  803bd7:	c3                   	ret    
  803bd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bdd:	89 eb                	mov    %ebp,%ebx
  803bdf:	29 fb                	sub    %edi,%ebx
  803be1:	89 f9                	mov    %edi,%ecx
  803be3:	d3 e6                	shl    %cl,%esi
  803be5:	89 c5                	mov    %eax,%ebp
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 ed                	shr    %cl,%ebp
  803beb:	89 e9                	mov    %ebp,%ecx
  803bed:	09 f1                	or     %esi,%ecx
  803bef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bf3:	89 f9                	mov    %edi,%ecx
  803bf5:	d3 e0                	shl    %cl,%eax
  803bf7:	89 c5                	mov    %eax,%ebp
  803bf9:	89 d6                	mov    %edx,%esi
  803bfb:	88 d9                	mov    %bl,%cl
  803bfd:	d3 ee                	shr    %cl,%esi
  803bff:	89 f9                	mov    %edi,%ecx
  803c01:	d3 e2                	shl    %cl,%edx
  803c03:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c07:	88 d9                	mov    %bl,%cl
  803c09:	d3 e8                	shr    %cl,%eax
  803c0b:	09 c2                	or     %eax,%edx
  803c0d:	89 d0                	mov    %edx,%eax
  803c0f:	89 f2                	mov    %esi,%edx
  803c11:	f7 74 24 0c          	divl   0xc(%esp)
  803c15:	89 d6                	mov    %edx,%esi
  803c17:	89 c3                	mov    %eax,%ebx
  803c19:	f7 e5                	mul    %ebp
  803c1b:	39 d6                	cmp    %edx,%esi
  803c1d:	72 19                	jb     803c38 <__udivdi3+0xfc>
  803c1f:	74 0b                	je     803c2c <__udivdi3+0xf0>
  803c21:	89 d8                	mov    %ebx,%eax
  803c23:	31 ff                	xor    %edi,%edi
  803c25:	e9 58 ff ff ff       	jmp    803b82 <__udivdi3+0x46>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c30:	89 f9                	mov    %edi,%ecx
  803c32:	d3 e2                	shl    %cl,%edx
  803c34:	39 c2                	cmp    %eax,%edx
  803c36:	73 e9                	jae    803c21 <__udivdi3+0xe5>
  803c38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c3b:	31 ff                	xor    %edi,%edi
  803c3d:	e9 40 ff ff ff       	jmp    803b82 <__udivdi3+0x46>
  803c42:	66 90                	xchg   %ax,%ax
  803c44:	31 c0                	xor    %eax,%eax
  803c46:	e9 37 ff ff ff       	jmp    803b82 <__udivdi3+0x46>
  803c4b:	90                   	nop

00803c4c <__umoddi3>:
  803c4c:	55                   	push   %ebp
  803c4d:	57                   	push   %edi
  803c4e:	56                   	push   %esi
  803c4f:	53                   	push   %ebx
  803c50:	83 ec 1c             	sub    $0x1c,%esp
  803c53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c57:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c6b:	89 f3                	mov    %esi,%ebx
  803c6d:	89 fa                	mov    %edi,%edx
  803c6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c73:	89 34 24             	mov    %esi,(%esp)
  803c76:	85 c0                	test   %eax,%eax
  803c78:	75 1a                	jne    803c94 <__umoddi3+0x48>
  803c7a:	39 f7                	cmp    %esi,%edi
  803c7c:	0f 86 a2 00 00 00    	jbe    803d24 <__umoddi3+0xd8>
  803c82:	89 c8                	mov    %ecx,%eax
  803c84:	89 f2                	mov    %esi,%edx
  803c86:	f7 f7                	div    %edi
  803c88:	89 d0                	mov    %edx,%eax
  803c8a:	31 d2                	xor    %edx,%edx
  803c8c:	83 c4 1c             	add    $0x1c,%esp
  803c8f:	5b                   	pop    %ebx
  803c90:	5e                   	pop    %esi
  803c91:	5f                   	pop    %edi
  803c92:	5d                   	pop    %ebp
  803c93:	c3                   	ret    
  803c94:	39 f0                	cmp    %esi,%eax
  803c96:	0f 87 ac 00 00 00    	ja     803d48 <__umoddi3+0xfc>
  803c9c:	0f bd e8             	bsr    %eax,%ebp
  803c9f:	83 f5 1f             	xor    $0x1f,%ebp
  803ca2:	0f 84 ac 00 00 00    	je     803d54 <__umoddi3+0x108>
  803ca8:	bf 20 00 00 00       	mov    $0x20,%edi
  803cad:	29 ef                	sub    %ebp,%edi
  803caf:	89 fe                	mov    %edi,%esi
  803cb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cb5:	89 e9                	mov    %ebp,%ecx
  803cb7:	d3 e0                	shl    %cl,%eax
  803cb9:	89 d7                	mov    %edx,%edi
  803cbb:	89 f1                	mov    %esi,%ecx
  803cbd:	d3 ef                	shr    %cl,%edi
  803cbf:	09 c7                	or     %eax,%edi
  803cc1:	89 e9                	mov    %ebp,%ecx
  803cc3:	d3 e2                	shl    %cl,%edx
  803cc5:	89 14 24             	mov    %edx,(%esp)
  803cc8:	89 d8                	mov    %ebx,%eax
  803cca:	d3 e0                	shl    %cl,%eax
  803ccc:	89 c2                	mov    %eax,%edx
  803cce:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cd2:	d3 e0                	shl    %cl,%eax
  803cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cdc:	89 f1                	mov    %esi,%ecx
  803cde:	d3 e8                	shr    %cl,%eax
  803ce0:	09 d0                	or     %edx,%eax
  803ce2:	d3 eb                	shr    %cl,%ebx
  803ce4:	89 da                	mov    %ebx,%edx
  803ce6:	f7 f7                	div    %edi
  803ce8:	89 d3                	mov    %edx,%ebx
  803cea:	f7 24 24             	mull   (%esp)
  803ced:	89 c6                	mov    %eax,%esi
  803cef:	89 d1                	mov    %edx,%ecx
  803cf1:	39 d3                	cmp    %edx,%ebx
  803cf3:	0f 82 87 00 00 00    	jb     803d80 <__umoddi3+0x134>
  803cf9:	0f 84 91 00 00 00    	je     803d90 <__umoddi3+0x144>
  803cff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d03:	29 f2                	sub    %esi,%edx
  803d05:	19 cb                	sbb    %ecx,%ebx
  803d07:	89 d8                	mov    %ebx,%eax
  803d09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d0d:	d3 e0                	shl    %cl,%eax
  803d0f:	89 e9                	mov    %ebp,%ecx
  803d11:	d3 ea                	shr    %cl,%edx
  803d13:	09 d0                	or     %edx,%eax
  803d15:	89 e9                	mov    %ebp,%ecx
  803d17:	d3 eb                	shr    %cl,%ebx
  803d19:	89 da                	mov    %ebx,%edx
  803d1b:	83 c4 1c             	add    $0x1c,%esp
  803d1e:	5b                   	pop    %ebx
  803d1f:	5e                   	pop    %esi
  803d20:	5f                   	pop    %edi
  803d21:	5d                   	pop    %ebp
  803d22:	c3                   	ret    
  803d23:	90                   	nop
  803d24:	89 fd                	mov    %edi,%ebp
  803d26:	85 ff                	test   %edi,%edi
  803d28:	75 0b                	jne    803d35 <__umoddi3+0xe9>
  803d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d2f:	31 d2                	xor    %edx,%edx
  803d31:	f7 f7                	div    %edi
  803d33:	89 c5                	mov    %eax,%ebp
  803d35:	89 f0                	mov    %esi,%eax
  803d37:	31 d2                	xor    %edx,%edx
  803d39:	f7 f5                	div    %ebp
  803d3b:	89 c8                	mov    %ecx,%eax
  803d3d:	f7 f5                	div    %ebp
  803d3f:	89 d0                	mov    %edx,%eax
  803d41:	e9 44 ff ff ff       	jmp    803c8a <__umoddi3+0x3e>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	89 c8                	mov    %ecx,%eax
  803d4a:	89 f2                	mov    %esi,%edx
  803d4c:	83 c4 1c             	add    $0x1c,%esp
  803d4f:	5b                   	pop    %ebx
  803d50:	5e                   	pop    %esi
  803d51:	5f                   	pop    %edi
  803d52:	5d                   	pop    %ebp
  803d53:	c3                   	ret    
  803d54:	3b 04 24             	cmp    (%esp),%eax
  803d57:	72 06                	jb     803d5f <__umoddi3+0x113>
  803d59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d5d:	77 0f                	ja     803d6e <__umoddi3+0x122>
  803d5f:	89 f2                	mov    %esi,%edx
  803d61:	29 f9                	sub    %edi,%ecx
  803d63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d67:	89 14 24             	mov    %edx,(%esp)
  803d6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d72:	8b 14 24             	mov    (%esp),%edx
  803d75:	83 c4 1c             	add    $0x1c,%esp
  803d78:	5b                   	pop    %ebx
  803d79:	5e                   	pop    %esi
  803d7a:	5f                   	pop    %edi
  803d7b:	5d                   	pop    %ebp
  803d7c:	c3                   	ret    
  803d7d:	8d 76 00             	lea    0x0(%esi),%esi
  803d80:	2b 04 24             	sub    (%esp),%eax
  803d83:	19 fa                	sbb    %edi,%edx
  803d85:	89 d1                	mov    %edx,%ecx
  803d87:	89 c6                	mov    %eax,%esi
  803d89:	e9 71 ff ff ff       	jmp    803cff <__umoddi3+0xb3>
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d94:	72 ea                	jb     803d80 <__umoddi3+0x134>
  803d96:	89 d9                	mov    %ebx,%ecx
  803d98:	e9 62 ff ff ff       	jmp    803cff <__umoddi3+0xb3>
