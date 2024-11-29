
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
  80003e:	e8 24 1c 00 00       	call   801c67 <sys_getparentenvid>
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
  800057:	68 80 3e 80 00       	push   $0x803e80
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 a7 17 00 00       	call   80180b <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 84 3e 80 00       	push   $0x803e84
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 91 17 00 00       	call   80180b <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 8c 3e 80 00       	push   $0x803e8c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 74 17 00 00       	call   80180b <sget>
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
  8000ab:	68 9a 3e 80 00       	push   $0x803e9a
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
  80010c:	68 a9 3e 80 00       	push   $0x803ea9
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
  8001a2:	68 c5 3e 80 00       	push   $0x803ec5
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
  8001c4:	68 c7 3e 80 00       	push   $0x803ec7
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
  8001f2:	68 cc 3e 80 00       	push   $0x803ecc
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
  800479:	e8 d0 17 00 00       	call   801c4e <sys_getenvindex>
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
  8004e7:	e8 e6 14 00 00       	call   8019d2 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 e8 3e 80 00       	push   $0x803ee8
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
  800517:	68 10 3f 80 00       	push   $0x803f10
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
  800548:	68 38 3f 80 00       	push   $0x803f38
  80054d:	e8 34 01 00 00       	call   800686 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 90 3f 80 00       	push   $0x803f90
  800569:	e8 18 01 00 00       	call   800686 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 e8 3e 80 00       	push   $0x803ee8
  800579:	e8 08 01 00 00       	call   800686 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800581:	e8 66 14 00 00       	call   8019ec <sys_unlock_cons>
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
  800599:	e8 7c 16 00 00       	call   801c1a <sys_destroy_env>
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
  8005aa:	e8 d1 16 00 00       	call   801c80 <sys_exit_env>
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
  8005f8:	e8 93 13 00 00       	call   801990 <sys_cputs>
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
  80066f:	e8 1c 13 00 00       	call   801990 <sys_cputs>
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
  8006b9:	e8 14 13 00 00       	call   8019d2 <sys_lock_cons>
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
  8006d9:	e8 0e 13 00 00       	call   8019ec <sys_unlock_cons>
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
  800723:	e8 e8 34 00 00       	call   803c10 <__udivdi3>
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
  800773:	e8 a8 35 00 00       	call   803d20 <__umoddi3>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  8008ce:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  8009af:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 19                	jne    8009d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	53                   	push   %ebx
  8009bb:	68 e5 41 80 00       	push   $0x8041e5
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
  8009d4:	68 ee 41 80 00       	push   $0x8041ee
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
  800a01:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  80140c:	68 68 43 80 00       	push   $0x804368
  801411:	68 3f 01 00 00       	push   $0x13f
  801416:	68 8a 43 80 00       	push   $0x80438a
  80141b:	e8 07 26 00 00       	call   803a27 <_panic>

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
  80142c:	e8 0a 0b 00 00       	call   801f3b <sys_sbrk>
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
  8014a7:	e8 13 09 00 00       	call   801dbf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 16                	je     8014c6 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 53 0e 00 00       	call   80230e <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	e9 8a 01 00 00       	jmp    801650 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014c6:	e8 25 09 00 00       	call   801df0 <sys_isUHeapPlacementStrategyBESTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 84 7d 01 00 00    	je     801650 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 ec 12 00 00       	call   8027ca <alloc_block_BF>
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
  801529:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801576:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8015cd:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  80162f:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	ff 75 f0             	pushl  -0x10(%ebp)
  80163f:	e8 2e 09 00 00       	call   801f72 <sys_allocate_user_mem>
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
  801687:	e8 02 09 00 00       	call   801f8e <get_block_size>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 35 1b 00 00       	call   8031d2 <free_block>
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
  8016d2:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  80170f:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  80172f:	e8 22 08 00 00       	call   801f56 <sys_free_user_mem>
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
  80173d:	68 98 43 80 00       	push   $0x804398
  801742:	68 85 00 00 00       	push   $0x85
  801747:	68 c2 43 80 00       	push   $0x8043c2
  80174c:	e8 d6 22 00 00       	call   803a27 <_panic>
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
  801763:	75 0a                	jne    80176f <smalloc+0x1c>
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	e9 9a 00 00 00       	jmp    801809 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801775:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80177c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801782:	39 d0                	cmp    %edx,%eax
  801784:	73 02                	jae    801788 <smalloc+0x35>
  801786:	89 d0                	mov    %edx,%eax
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	50                   	push   %eax
  80178c:	e8 a5 fc ff ff       	call   801436 <malloc>
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801797:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80179b:	75 07                	jne    8017a4 <smalloc+0x51>
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a2:	eb 65                	jmp    801809 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017a4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8017ab:	50                   	push   %eax
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	e8 a6 03 00 00       	call   801b5d <sys_createSharedObject>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017bd:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017c1:	74 06                	je     8017c9 <smalloc+0x76>
  8017c3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017c7:	75 07                	jne    8017d0 <smalloc+0x7d>
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	eb 39                	jmp    801809 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d6:	68 ce 43 80 00       	push   $0x8043ce
  8017db:	e8 a6 ee ff ff       	call   800686 <cprintf>
  8017e0:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8017e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8017eb:	8b 40 78             	mov    0x78(%eax),%eax
  8017ee:	29 c2                	sub    %eax,%edx
  8017f0:	89 d0                	mov    %edx,%eax
  8017f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f7:	c1 e8 0c             	shr    $0xc,%eax
  8017fa:	89 c2                	mov    %eax,%edx
  8017fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ff:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801806:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	ff 75 08             	pushl  0x8(%ebp)
  80181a:	e8 68 03 00 00       	call   801b87 <sys_getSizeOfSharedObject>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801825:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801829:	75 07                	jne    801832 <sget+0x27>
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
  801830:	eb 7f                	jmp    8018b1 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801838:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80183f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	39 d0                	cmp    %edx,%eax
  801847:	7d 02                	jge    80184b <sget+0x40>
  801849:	89 d0                	mov    %edx,%eax
  80184b:	83 ec 0c             	sub    $0xc,%esp
  80184e:	50                   	push   %eax
  80184f:	e8 e2 fb ff ff       	call   801436 <malloc>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80185a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80185e:	75 07                	jne    801867 <sget+0x5c>
  801860:	b8 00 00 00 00       	mov    $0x0,%eax
  801865:	eb 4a                	jmp    8018b1 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	ff 75 e8             	pushl  -0x18(%ebp)
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	e8 2c 03 00 00       	call   801ba4 <sys_getSharedObject>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80187e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801881:	a1 20 50 80 00       	mov    0x805020,%eax
  801886:	8b 40 78             	mov    0x78(%eax),%eax
  801889:	29 c2                	sub    %eax,%edx
  80188b:	89 d0                	mov    %edx,%eax
  80188d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801892:	c1 e8 0c             	shr    $0xc,%eax
  801895:	89 c2                	mov    %eax,%edx
  801897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189a:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018a1:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018a5:	75 07                	jne    8018ae <sget+0xa3>
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	eb 03                	jmp    8018b1 <sget+0xa6>
	return ptr;
  8018ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c1:	8b 40 78             	mov    0x78(%eax),%eax
  8018c4:	29 c2                	sub    %eax,%edx
  8018c6:	89 d0                	mov    %edx,%eax
  8018c8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018cd:	c1 e8 0c             	shr    $0xc,%eax
  8018d0:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e3:	e8 db 02 00 00       	call   801bc3 <sys_freeSharedObject>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	68 e0 43 80 00       	push   $0x8043e0
  8018ff:	68 de 00 00 00       	push   $0xde
  801904:	68 c2 43 80 00       	push   $0x8043c2
  801909:	e8 19 21 00 00       	call   803a27 <_panic>

0080190e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 06 44 80 00       	push   $0x804406
  80191c:	68 ea 00 00 00       	push   $0xea
  801921:	68 c2 43 80 00       	push   $0x8043c2
  801926:	e8 fc 20 00 00       	call   803a27 <_panic>

0080192b <shrink>:

}
void shrink(uint32 newSize)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	68 06 44 80 00       	push   $0x804406
  801939:	68 ef 00 00 00       	push   $0xef
  80193e:	68 c2 43 80 00       	push   $0x8043c2
  801943:	e8 df 20 00 00       	call   803a27 <_panic>

00801948 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	68 06 44 80 00       	push   $0x804406
  801956:	68 f4 00 00 00       	push   $0xf4
  80195b:	68 c2 43 80 00       	push   $0x8043c2
  801960:	e8 c2 20 00 00       	call   803a27 <_panic>

00801965 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	57                   	push   %edi
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801977:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80197d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801980:	cd 30                	int    $0x30
  801982:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801985:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	8b 45 10             	mov    0x10(%ebp),%eax
  801999:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80199c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	50                   	push   %eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	e8 b2 ff ff ff       	call   801965 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 02                	push   $0x2
  8019c8:	e8 98 ff ff ff       	call   801965 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 03                	push   $0x3
  8019e1:	e8 7f ff ff ff       	call   801965 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 04                	push   $0x4
  8019fb:	e8 65 ff ff ff       	call   801965 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	52                   	push   %edx
  801a16:	50                   	push   %eax
  801a17:	6a 08                	push   $0x8
  801a19:	e8 47 ff ff ff       	call   801965 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a28:	8b 75 18             	mov    0x18(%ebp),%esi
  801a2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	51                   	push   %ecx
  801a3a:	52                   	push   %edx
  801a3b:	50                   	push   %eax
  801a3c:	6a 09                	push   $0x9
  801a3e:	e8 22 ff ff ff       	call   801965 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5e                   	pop    %esi
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 0a                	push   $0xa
  801a60:	e8 00 ff ff ff       	call   801965 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	ff 75 08             	pushl  0x8(%ebp)
  801a79:	6a 0b                	push   $0xb
  801a7b:	e8 e5 fe ff ff       	call   801965 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 0c                	push   $0xc
  801a94:	e8 cc fe ff ff       	call   801965 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 0d                	push   $0xd
  801aad:	e8 b3 fe ff ff       	call   801965 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 0e                	push   $0xe
  801ac6:	e8 9a fe ff ff       	call   801965 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 0f                	push   $0xf
  801adf:	e8 81 fe ff ff       	call   801965 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	6a 10                	push   $0x10
  801af9:	e8 67 fe ff ff       	call   801965 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 11                	push   $0x11
  801b12:	e8 4e fe ff ff       	call   801965 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_cputc>:

void
sys_cputc(const char c)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	50                   	push   %eax
  801b36:	6a 01                	push   $0x1
  801b38:	e8 28 fe ff ff       	call   801965 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 14                	push   $0x14
  801b52:	e8 0e fe ff ff       	call   801965 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8b 45 10             	mov    0x10(%ebp),%eax
  801b66:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b69:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b6c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	51                   	push   %ecx
  801b76:	52                   	push   %edx
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	50                   	push   %eax
  801b7b:	6a 15                	push   $0x15
  801b7d:	e8 e3 fd ff ff       	call   801965 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 16                	push   $0x16
  801b9a:	e8 c6 fd ff ff       	call   801965 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	51                   	push   %ecx
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	6a 17                	push   $0x17
  801bb9:	e8 a7 fd ff ff       	call   801965 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 18                	push   $0x18
  801bd6:	e8 8a fd ff ff       	call   801965 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 14             	pushl  0x14(%ebp)
  801beb:	ff 75 10             	pushl  0x10(%ebp)
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	50                   	push   %eax
  801bf2:	6a 19                	push   $0x19
  801bf4:	e8 6c fd ff ff       	call   801965 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	50                   	push   %eax
  801c0d:	6a 1a                	push   $0x1a
  801c0f:	e8 51 fd ff ff       	call   801965 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	50                   	push   %eax
  801c29:	6a 1b                	push   $0x1b
  801c2b:	e8 35 fd ff ff       	call   801965 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 05                	push   $0x5
  801c44:	e8 1c fd ff ff       	call   801965 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 06                	push   $0x6
  801c5d:	e8 03 fd ff ff       	call   801965 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 07                	push   $0x7
  801c76:	e8 ea fc ff ff       	call   801965 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_exit_env>:


void sys_exit_env(void)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 1c                	push   $0x1c
  801c8f:	e8 d1 fc ff ff       	call   801965 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca3:	8d 50 04             	lea    0x4(%eax),%edx
  801ca6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 1d                	push   $0x1d
  801cb3:	e8 ad fc ff ff       	call   801965 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
	return result;
  801cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc4:	89 01                	mov    %eax,(%ecx)
  801cc6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	c9                   	leave  
  801ccd:	c2 04 00             	ret    $0x4

00801cd0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	ff 75 10             	pushl  0x10(%ebp)
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	6a 13                	push   $0x13
  801ce2:	e8 7e fc ff ff       	call   801965 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_rcr2>:
uint32 sys_rcr2()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 1e                	push   $0x1e
  801cfc:	e8 64 fc ff ff       	call   801965 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	50                   	push   %eax
  801d1f:	6a 1f                	push   $0x1f
  801d21:	e8 3f fc ff ff       	call   801965 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
	return ;
  801d29:	90                   	nop
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <rsttst>:
void rsttst()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 21                	push   $0x21
  801d3b:	e8 25 fc ff ff       	call   801965 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d52:	8b 55 18             	mov    0x18(%ebp),%edx
  801d55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	ff 75 10             	pushl  0x10(%ebp)
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	6a 20                	push   $0x20
  801d66:	e8 fa fb ff ff       	call   801965 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <chktst>:
void chktst(uint32 n)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	ff 75 08             	pushl  0x8(%ebp)
  801d7f:	6a 22                	push   $0x22
  801d81:	e8 df fb ff ff       	call   801965 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return ;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <inctst>:

void inctst()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 23                	push   $0x23
  801d9b:	e8 c5 fb ff ff       	call   801965 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
	return ;
  801da3:	90                   	nop
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <gettst>:
uint32 gettst()
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 24                	push   $0x24
  801db5:	e8 ab fb ff ff       	call   801965 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 25                	push   $0x25
  801dd1:	e8 8f fb ff ff       	call   801965 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
  801dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ddc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de0:	75 07                	jne    801de9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de2:	b8 01 00 00 00       	mov    $0x1,%eax
  801de7:	eb 05                	jmp    801dee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 25                	push   $0x25
  801e02:	e8 5e fb ff ff       	call   801965 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
  801e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e0d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e11:	75 07                	jne    801e1a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	eb 05                	jmp    801e1f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 25                	push   $0x25
  801e33:	e8 2d fb ff ff       	call   801965 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e3e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 25                	push   $0x25
  801e64:	e8 fc fa ff ff       	call   801965 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
  801e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e73:	75 07                	jne    801e7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb 05                	jmp    801e81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 08             	pushl  0x8(%ebp)
  801e91:	6a 26                	push   $0x26
  801e93:	e8 cd fa ff ff       	call   801965 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9b:	90                   	nop
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	53                   	push   %ebx
  801eb1:	51                   	push   %ecx
  801eb2:	52                   	push   %edx
  801eb3:	50                   	push   %eax
  801eb4:	6a 27                	push   $0x27
  801eb6:	e8 aa fa ff ff       	call   801965 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	52                   	push   %edx
  801ed3:	50                   	push   %eax
  801ed4:	6a 28                	push   $0x28
  801ed6:	e8 8a fa ff ff       	call   801965 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ee3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	51                   	push   %ecx
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	6a 29                	push   $0x29
  801ef6:	e8 6a fa ff ff       	call   801965 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	ff 75 10             	pushl  0x10(%ebp)
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	ff 75 08             	pushl  0x8(%ebp)
  801f10:	6a 12                	push   $0x12
  801f12:	e8 4e fa ff ff       	call   801965 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1a:	90                   	nop
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	6a 2a                	push   $0x2a
  801f30:	e8 30 fa ff ff       	call   801965 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
	return;
  801f38:	90                   	nop
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	50                   	push   %eax
  801f4a:	6a 2b                	push   $0x2b
  801f4c:	e8 14 fa ff ff       	call   801965 <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	ff 75 08             	pushl  0x8(%ebp)
  801f65:	6a 2c                	push   $0x2c
  801f67:	e8 f9 f9 ff ff       	call   801965 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
	return;
  801f6f:	90                   	nop
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	6a 2d                	push   $0x2d
  801f83:	e8 dd f9 ff ff       	call   801965 <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
	return;
  801f8b:	90                   	nop
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	83 e8 04             	sub    $0x4,%eax
  801f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa0:	8b 00                	mov    (%eax),%eax
  801fa2:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	83 e8 04             	sub    $0x4,%eax
  801fb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb9:	8b 00                	mov    (%eax),%eax
  801fbb:	83 e0 01             	and    $0x1,%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	0f 94 c0             	sete   %al
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	83 f8 02             	cmp    $0x2,%eax
  801fd8:	74 2b                	je     802005 <alloc_block+0x40>
  801fda:	83 f8 02             	cmp    $0x2,%eax
  801fdd:	7f 07                	jg     801fe6 <alloc_block+0x21>
  801fdf:	83 f8 01             	cmp    $0x1,%eax
  801fe2:	74 0e                	je     801ff2 <alloc_block+0x2d>
  801fe4:	eb 58                	jmp    80203e <alloc_block+0x79>
  801fe6:	83 f8 03             	cmp    $0x3,%eax
  801fe9:	74 2d                	je     802018 <alloc_block+0x53>
  801feb:	83 f8 04             	cmp    $0x4,%eax
  801fee:	74 3b                	je     80202b <alloc_block+0x66>
  801ff0:	eb 4c                	jmp    80203e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	ff 75 08             	pushl  0x8(%ebp)
  801ff8:	e8 11 03 00 00       	call   80230e <alloc_block_FF>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802003:	eb 4a                	jmp    80204f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	e8 fa 19 00 00       	call   803a0a <alloc_block_NF>
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802016:	eb 37                	jmp    80204f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	ff 75 08             	pushl  0x8(%ebp)
  80201e:	e8 a7 07 00 00       	call   8027ca <alloc_block_BF>
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802029:	eb 24                	jmp    80204f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	e8 b7 19 00 00       	call   8039ed <alloc_block_WF>
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80203c:	eb 11                	jmp    80204f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	68 18 44 80 00       	push   $0x804418
  802046:	e8 3b e6 ff ff       	call   800686 <cprintf>
  80204b:	83 c4 10             	add    $0x10,%esp
		break;
  80204e:	90                   	nop
	}
	return va;
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	53                   	push   %ebx
  802058:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80205b:	83 ec 0c             	sub    $0xc,%esp
  80205e:	68 38 44 80 00       	push   $0x804438
  802063:	e8 1e e6 ff ff       	call   800686 <cprintf>
  802068:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	68 63 44 80 00       	push   $0x804463
  802073:	e8 0e e6 ff ff       	call   800686 <cprintf>
  802078:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802081:	eb 37                	jmp    8020ba <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	ff 75 f4             	pushl  -0xc(%ebp)
  802089:	e8 19 ff ff ff       	call   801fa7 <is_free_block>
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	0f be d8             	movsbl %al,%ebx
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	ff 75 f4             	pushl  -0xc(%ebp)
  80209a:	e8 ef fe ff ff       	call   801f8e <get_block_size>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	53                   	push   %ebx
  8020a6:	50                   	push   %eax
  8020a7:	68 7b 44 80 00       	push   $0x80447b
  8020ac:	e8 d5 e5 ff ff       	call   800686 <cprintf>
  8020b1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020be:	74 07                	je     8020c7 <print_blocks_list+0x73>
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	eb 05                	jmp    8020cc <print_blocks_list+0x78>
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cc:	89 45 10             	mov    %eax,0x10(%ebp)
  8020cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	75 ad                	jne    802083 <print_blocks_list+0x2f>
  8020d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020da:	75 a7                	jne    802083 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	68 38 44 80 00       	push   $0x804438
  8020e4:	e8 9d e5 ff ff       	call   800686 <cprintf>
  8020e9:	83 c4 10             	add    $0x10,%esp

}
  8020ec:	90                   	nop
  8020ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fb:	83 e0 01             	and    $0x1,%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 03                	je     802105 <initialize_dynamic_allocator+0x13>
  802102:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802105:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802109:	0f 84 c7 01 00 00    	je     8022d6 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80210f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802116:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802119:	8b 55 08             	mov    0x8(%ebp),%edx
  80211c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211f:	01 d0                	add    %edx,%eax
  802121:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802126:	0f 87 ad 01 00 00    	ja     8022d9 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	0f 89 a5 01 00 00    	jns    8022dc <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802137:	8b 55 08             	mov    0x8(%ebp),%edx
  80213a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213d:	01 d0                	add    %edx,%eax
  80213f:	83 e8 04             	sub    $0x4,%eax
  802142:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80214e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802156:	e9 87 00 00 00       	jmp    8021e2 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80215b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215f:	75 14                	jne    802175 <initialize_dynamic_allocator+0x83>
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 93 44 80 00       	push   $0x804493
  802169:	6a 79                	push   $0x79
  80216b:	68 b1 44 80 00       	push   $0x8044b1
  802170:	e8 b2 18 00 00       	call   803a27 <_panic>
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 00                	mov    (%eax),%eax
  80217a:	85 c0                	test   %eax,%eax
  80217c:	74 10                	je     80218e <initialize_dynamic_allocator+0x9c>
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 00                	mov    (%eax),%eax
  802183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802186:	8b 52 04             	mov    0x4(%edx),%edx
  802189:	89 50 04             	mov    %edx,0x4(%eax)
  80218c:	eb 0b                	jmp    802199 <initialize_dynamic_allocator+0xa7>
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 40 04             	mov    0x4(%eax),%eax
  802194:	a3 30 50 80 00       	mov    %eax,0x805030
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 04             	mov    0x4(%eax),%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	74 0f                	je     8021b2 <initialize_dynamic_allocator+0xc0>
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 40 04             	mov    0x4(%eax),%eax
  8021a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ac:	8b 12                	mov    (%edx),%edx
  8021ae:	89 10                	mov    %edx,(%eax)
  8021b0:	eb 0a                	jmp    8021bc <initialize_dynamic_allocator+0xca>
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 00                	mov    (%eax),%eax
  8021b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8021d4:	48                   	dec    %eax
  8021d5:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021da:	a1 34 50 80 00       	mov    0x805034,%eax
  8021df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e6:	74 07                	je     8021ef <initialize_dynamic_allocator+0xfd>
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	eb 05                	jmp    8021f4 <initialize_dynamic_allocator+0x102>
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8021f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	0f 85 55 ff ff ff    	jne    80215b <initialize_dynamic_allocator+0x69>
  802206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220a:	0f 85 4b ff ff ff    	jne    80215b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802219:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80221f:	a1 44 50 80 00       	mov    0x805044,%eax
  802224:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802229:	a1 40 50 80 00       	mov    0x805040,%eax
  80222e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	83 c0 08             	add    $0x8,%eax
  80223a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	83 c0 04             	add    $0x4,%eax
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	83 ea 08             	sub    $0x8,%edx
  802249:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80224b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	01 d0                	add    %edx,%eax
  802253:	83 e8 08             	sub    $0x8,%eax
  802256:	8b 55 0c             	mov    0xc(%ebp),%edx
  802259:	83 ea 08             	sub    $0x8,%edx
  80225c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80225e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802271:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802275:	75 17                	jne    80228e <initialize_dynamic_allocator+0x19c>
  802277:	83 ec 04             	sub    $0x4,%esp
  80227a:	68 cc 44 80 00       	push   $0x8044cc
  80227f:	68 90 00 00 00       	push   $0x90
  802284:	68 b1 44 80 00       	push   $0x8044b1
  802289:	e8 99 17 00 00       	call   803a27 <_panic>
  80228e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	89 10                	mov    %edx,(%eax)
  802299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	74 0d                	je     8022af <initialize_dynamic_allocator+0x1bd>
  8022a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022aa:	89 50 04             	mov    %edx,0x4(%eax)
  8022ad:	eb 08                	jmp    8022b7 <initialize_dynamic_allocator+0x1c5>
  8022af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8022b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ce:	40                   	inc    %eax
  8022cf:	a3 38 50 80 00       	mov    %eax,0x805038
  8022d4:	eb 07                	jmp    8022dd <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022d6:	90                   	nop
  8022d7:	eb 04                	jmp    8022dd <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022d9:	90                   	nop
  8022da:	eb 01                	jmp    8022dd <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022dc:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e5:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	83 e8 04             	sub    $0x4,%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	83 e0 fe             	and    $0xfffffffe,%eax
  8022fe:	8d 50 f8             	lea    -0x8(%eax),%edx
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	01 c2                	add    %eax,%edx
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	89 02                	mov    %eax,(%edx)
}
  80230b:	90                   	nop
  80230c:	5d                   	pop    %ebp
  80230d:	c3                   	ret    

0080230e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	83 e0 01             	and    $0x1,%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 03                	je     802321 <alloc_block_FF+0x13>
  80231e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802321:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802325:	77 07                	ja     80232e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802327:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80232e:	a1 24 50 80 00       	mov    0x805024,%eax
  802333:	85 c0                	test   %eax,%eax
  802335:	75 73                	jne    8023aa <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	83 c0 10             	add    $0x10,%eax
  80233d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802340:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802347:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234d:	01 d0                	add    %edx,%eax
  80234f:	48                   	dec    %eax
  802350:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802356:	ba 00 00 00 00       	mov    $0x0,%edx
  80235b:	f7 75 ec             	divl   -0x14(%ebp)
  80235e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802361:	29 d0                	sub    %edx,%eax
  802363:	c1 e8 0c             	shr    $0xc,%eax
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	50                   	push   %eax
  80236a:	e8 b1 f0 ff ff       	call   801420 <sbrk>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	6a 00                	push   $0x0
  80237a:	e8 a1 f0 ff ff       	call   801420 <sbrk>
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802385:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802388:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80238b:	83 ec 08             	sub    $0x8,%esp
  80238e:	50                   	push   %eax
  80238f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802392:	e8 5b fd ff ff       	call   8020f2 <initialize_dynamic_allocator>
  802397:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80239a:	83 ec 0c             	sub    $0xc,%esp
  80239d:	68 ef 44 80 00       	push   $0x8044ef
  8023a2:	e8 df e2 ff ff       	call   800686 <cprintf>
  8023a7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ae:	75 0a                	jne    8023ba <alloc_block_FF+0xac>
	        return NULL;
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	e9 0e 04 00 00       	jmp    8027c8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c9:	e9 f3 02 00 00       	jmp    8026c1 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023d4:	83 ec 0c             	sub    $0xc,%esp
  8023d7:	ff 75 bc             	pushl  -0x44(%ebp)
  8023da:	e8 af fb ff ff       	call   801f8e <get_block_size>
  8023df:	83 c4 10             	add    $0x10,%esp
  8023e2:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	83 c0 08             	add    $0x8,%eax
  8023eb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023ee:	0f 87 c5 02 00 00    	ja     8026b9 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	83 c0 18             	add    $0x18,%eax
  8023fa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023fd:	0f 87 19 02 00 00    	ja     80261c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802403:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802406:	2b 45 08             	sub    0x8(%ebp),%eax
  802409:	83 e8 08             	sub    $0x8,%eax
  80240c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8d 50 08             	lea    0x8(%eax),%edx
  802415:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802418:	01 d0                	add    %edx,%eax
  80241a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	83 c0 08             	add    $0x8,%eax
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	6a 01                	push   $0x1
  802428:	50                   	push   %eax
  802429:	ff 75 bc             	pushl  -0x44(%ebp)
  80242c:	e8 ae fe ff ff       	call   8022df <set_block_data>
  802431:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 04             	mov    0x4(%eax),%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	75 68                	jne    8024a6 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80243e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802442:	75 17                	jne    80245b <alloc_block_FF+0x14d>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 cc 44 80 00       	push   $0x8044cc
  80244c:	68 d7 00 00 00       	push   $0xd7
  802451:	68 b1 44 80 00       	push   $0x8044b1
  802456:	e8 cc 15 00 00       	call   803a27 <_panic>
  80245b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802461:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802464:	89 10                	mov    %edx,(%eax)
  802466:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802469:	8b 00                	mov    (%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 0d                	je     80247c <alloc_block_FF+0x16e>
  80246f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802474:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802477:	89 50 04             	mov    %edx,0x4(%eax)
  80247a:	eb 08                	jmp    802484 <alloc_block_FF+0x176>
  80247c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247f:	a3 30 50 80 00       	mov    %eax,0x805030
  802484:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802487:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80248c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802496:	a1 38 50 80 00       	mov    0x805038,%eax
  80249b:	40                   	inc    %eax
  80249c:	a3 38 50 80 00       	mov    %eax,0x805038
  8024a1:	e9 dc 00 00 00       	jmp    802582 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	75 65                	jne    802514 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024af:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024b3:	75 17                	jne    8024cc <alloc_block_FF+0x1be>
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 00 45 80 00       	push   $0x804500
  8024bd:	68 db 00 00 00       	push   $0xdb
  8024c2:	68 b1 44 80 00       	push   $0x8044b1
  8024c7:	e8 5b 15 00 00       	call   803a27 <_panic>
  8024cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d5:	89 50 04             	mov    %edx,0x4(%eax)
  8024d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 0c                	je     8024ee <alloc_block_FF+0x1e0>
  8024e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8024e7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ea:	89 10                	mov    %edx,(%eax)
  8024ec:	eb 08                	jmp    8024f6 <alloc_block_FF+0x1e8>
  8024ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8024fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802507:	a1 38 50 80 00       	mov    0x805038,%eax
  80250c:	40                   	inc    %eax
  80250d:	a3 38 50 80 00       	mov    %eax,0x805038
  802512:	eb 6e                	jmp    802582 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802518:	74 06                	je     802520 <alloc_block_FF+0x212>
  80251a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80251e:	75 17                	jne    802537 <alloc_block_FF+0x229>
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 24 45 80 00       	push   $0x804524
  802528:	68 df 00 00 00       	push   $0xdf
  80252d:	68 b1 44 80 00       	push   $0x8044b1
  802532:	e8 f0 14 00 00       	call   803a27 <_panic>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 10                	mov    (%eax),%edx
  80253c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253f:	89 10                	mov    %edx,(%eax)
  802541:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 0b                	je     802555 <alloc_block_FF+0x247>
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 00                	mov    (%eax),%eax
  80254f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802552:	89 50 04             	mov    %edx,0x4(%eax)
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80255b:	89 10                	mov    %edx,(%eax)
  80255d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	89 50 04             	mov    %edx,0x4(%eax)
  802566:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	75 08                	jne    802577 <alloc_block_FF+0x269>
  80256f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802572:	a3 30 50 80 00       	mov    %eax,0x805030
  802577:	a1 38 50 80 00       	mov    0x805038,%eax
  80257c:	40                   	inc    %eax
  80257d:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802586:	75 17                	jne    80259f <alloc_block_FF+0x291>
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	68 93 44 80 00       	push   $0x804493
  802590:	68 e1 00 00 00       	push   $0xe1
  802595:	68 b1 44 80 00       	push   $0x8044b1
  80259a:	e8 88 14 00 00       	call   803a27 <_panic>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 10                	je     8025b8 <alloc_block_FF+0x2aa>
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	8b 52 04             	mov    0x4(%edx),%edx
  8025b3:	89 50 04             	mov    %edx,0x4(%eax)
  8025b6:	eb 0b                	jmp    8025c3 <alloc_block_FF+0x2b5>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 0f                	je     8025dc <alloc_block_FF+0x2ce>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d6:	8b 12                	mov    (%edx),%edx
  8025d8:	89 10                	mov    %edx,(%eax)
  8025da:	eb 0a                	jmp    8025e6 <alloc_block_FF+0x2d8>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8025fe:	48                   	dec    %eax
  8025ff:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	6a 00                	push   $0x0
  802609:	ff 75 b4             	pushl  -0x4c(%ebp)
  80260c:	ff 75 b0             	pushl  -0x50(%ebp)
  80260f:	e8 cb fc ff ff       	call   8022df <set_block_data>
  802614:	83 c4 10             	add    $0x10,%esp
  802617:	e9 95 00 00 00       	jmp    8026b1 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	6a 01                	push   $0x1
  802621:	ff 75 b8             	pushl  -0x48(%ebp)
  802624:	ff 75 bc             	pushl  -0x44(%ebp)
  802627:	e8 b3 fc ff ff       	call   8022df <set_block_data>
  80262c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	75 17                	jne    80264c <alloc_block_FF+0x33e>
  802635:	83 ec 04             	sub    $0x4,%esp
  802638:	68 93 44 80 00       	push   $0x804493
  80263d:	68 e8 00 00 00       	push   $0xe8
  802642:	68 b1 44 80 00       	push   $0x8044b1
  802647:	e8 db 13 00 00       	call   803a27 <_panic>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	74 10                	je     802665 <alloc_block_FF+0x357>
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265d:	8b 52 04             	mov    0x4(%edx),%edx
  802660:	89 50 04             	mov    %edx,0x4(%eax)
  802663:	eb 0b                	jmp    802670 <alloc_block_FF+0x362>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 04             	mov    0x4(%eax),%eax
  80266b:	a3 30 50 80 00       	mov    %eax,0x805030
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	74 0f                	je     802689 <alloc_block_FF+0x37b>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802683:	8b 12                	mov    (%edx),%edx
  802685:	89 10                	mov    %edx,(%eax)
  802687:	eb 0a                	jmp    802693 <alloc_block_FF+0x385>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ab:	48                   	dec    %eax
  8026ac:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026b1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026b4:	e9 0f 01 00 00       	jmp    8027c8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8026be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	74 07                	je     8026ce <alloc_block_FF+0x3c0>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	eb 05                	jmp    8026d3 <alloc_block_FF+0x3c5>
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8026d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	0f 85 e9 fc ff ff    	jne    8023ce <alloc_block_FF+0xc0>
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	0f 85 df fc ff ff    	jne    8023ce <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	83 c0 08             	add    $0x8,%eax
  8026f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026f8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802702:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802705:	01 d0                	add    %edx,%eax
  802707:	48                   	dec    %eax
  802708:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80270b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270e:	ba 00 00 00 00       	mov    $0x0,%edx
  802713:	f7 75 d8             	divl   -0x28(%ebp)
  802716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802719:	29 d0                	sub    %edx,%eax
  80271b:	c1 e8 0c             	shr    $0xc,%eax
  80271e:	83 ec 0c             	sub    $0xc,%esp
  802721:	50                   	push   %eax
  802722:	e8 f9 ec ff ff       	call   801420 <sbrk>
  802727:	83 c4 10             	add    $0x10,%esp
  80272a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80272d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802731:	75 0a                	jne    80273d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	e9 8b 00 00 00       	jmp    8027c8 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80273d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802744:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802747:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274a:	01 d0                	add    %edx,%eax
  80274c:	48                   	dec    %eax
  80274d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802750:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802753:	ba 00 00 00 00       	mov    $0x0,%edx
  802758:	f7 75 cc             	divl   -0x34(%ebp)
  80275b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80275e:	29 d0                	sub    %edx,%eax
  802760:	8d 50 fc             	lea    -0x4(%eax),%edx
  802763:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802766:	01 d0                	add    %edx,%eax
  802768:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80276d:	a1 40 50 80 00       	mov    0x805040,%eax
  802772:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802778:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80277f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802782:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802785:	01 d0                	add    %edx,%eax
  802787:	48                   	dec    %eax
  802788:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80278b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80278e:	ba 00 00 00 00       	mov    $0x0,%edx
  802793:	f7 75 c4             	divl   -0x3c(%ebp)
  802796:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802799:	29 d0                	sub    %edx,%eax
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	6a 01                	push   $0x1
  8027a0:	50                   	push   %eax
  8027a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8027a4:	e8 36 fb ff ff       	call   8022df <set_block_data>
  8027a9:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027ac:	83 ec 0c             	sub    $0xc,%esp
  8027af:	ff 75 d0             	pushl  -0x30(%ebp)
  8027b2:	e8 1b 0a 00 00       	call   8031d2 <free_block>
  8027b7:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	ff 75 08             	pushl  0x8(%ebp)
  8027c0:	e8 49 fb ff ff       	call   80230e <alloc_block_FF>
  8027c5:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	83 e0 01             	and    $0x1,%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 03                	je     8027dd <alloc_block_BF+0x13>
  8027da:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027dd:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027e1:	77 07                	ja     8027ea <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027e3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027ea:	a1 24 50 80 00       	mov    0x805024,%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	75 73                	jne    802866 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	83 c0 10             	add    $0x10,%eax
  8027f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027fc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802806:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802809:	01 d0                	add    %edx,%eax
  80280b:	48                   	dec    %eax
  80280c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80280f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802812:	ba 00 00 00 00       	mov    $0x0,%edx
  802817:	f7 75 e0             	divl   -0x20(%ebp)
  80281a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80281d:	29 d0                	sub    %edx,%eax
  80281f:	c1 e8 0c             	shr    $0xc,%eax
  802822:	83 ec 0c             	sub    $0xc,%esp
  802825:	50                   	push   %eax
  802826:	e8 f5 eb ff ff       	call   801420 <sbrk>
  80282b:	83 c4 10             	add    $0x10,%esp
  80282e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802831:	83 ec 0c             	sub    $0xc,%esp
  802834:	6a 00                	push   $0x0
  802836:	e8 e5 eb ff ff       	call   801420 <sbrk>
  80283b:	83 c4 10             	add    $0x10,%esp
  80283e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802844:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802847:	83 ec 08             	sub    $0x8,%esp
  80284a:	50                   	push   %eax
  80284b:	ff 75 d8             	pushl  -0x28(%ebp)
  80284e:	e8 9f f8 ff ff       	call   8020f2 <initialize_dynamic_allocator>
  802853:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	68 ef 44 80 00       	push   $0x8044ef
  80285e:	e8 23 de ff ff       	call   800686 <cprintf>
  802863:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80286d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802874:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80287b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802882:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802887:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288a:	e9 1d 01 00 00       	jmp    8029ac <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802895:	83 ec 0c             	sub    $0xc,%esp
  802898:	ff 75 a8             	pushl  -0x58(%ebp)
  80289b:	e8 ee f6 ff ff       	call   801f8e <get_block_size>
  8028a0:	83 c4 10             	add    $0x10,%esp
  8028a3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	83 c0 08             	add    $0x8,%eax
  8028ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028af:	0f 87 ef 00 00 00    	ja     8029a4 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	83 c0 18             	add    $0x18,%eax
  8028bb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028be:	77 1d                	ja     8028dd <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c6:	0f 86 d8 00 00 00    	jbe    8029a4 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028cc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028d2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028d8:	e9 c7 00 00 00       	jmp    8029a4 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	83 c0 08             	add    $0x8,%eax
  8028e3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e6:	0f 85 9d 00 00 00    	jne    802989 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	6a 01                	push   $0x1
  8028f1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028f4:	ff 75 a8             	pushl  -0x58(%ebp)
  8028f7:	e8 e3 f9 ff ff       	call   8022df <set_block_data>
  8028fc:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802903:	75 17                	jne    80291c <alloc_block_BF+0x152>
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 93 44 80 00       	push   $0x804493
  80290d:	68 2c 01 00 00       	push   $0x12c
  802912:	68 b1 44 80 00       	push   $0x8044b1
  802917:	e8 0b 11 00 00       	call   803a27 <_panic>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 10                	je     802935 <alloc_block_BF+0x16b>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292d:	8b 52 04             	mov    0x4(%edx),%edx
  802930:	89 50 04             	mov    %edx,0x4(%eax)
  802933:	eb 0b                	jmp    802940 <alloc_block_BF+0x176>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 04             	mov    0x4(%eax),%eax
  80293b:	a3 30 50 80 00       	mov    %eax,0x805030
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	74 0f                	je     802959 <alloc_block_BF+0x18f>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802953:	8b 12                	mov    (%edx),%edx
  802955:	89 10                	mov    %edx,(%eax)
  802957:	eb 0a                	jmp    802963 <alloc_block_BF+0x199>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802976:	a1 38 50 80 00       	mov    0x805038,%eax
  80297b:	48                   	dec    %eax
  80297c:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802981:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802984:	e9 24 04 00 00       	jmp    802dad <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80298f:	76 13                	jbe    8029a4 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802991:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802998:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80299b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80299e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8029a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b0:	74 07                	je     8029b9 <alloc_block_BF+0x1ef>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	eb 05                	jmp    8029be <alloc_block_BF+0x1f4>
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029be:	a3 34 50 80 00       	mov    %eax,0x805034
  8029c3:	a1 34 50 80 00       	mov    0x805034,%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	0f 85 bf fe ff ff    	jne    80288f <alloc_block_BF+0xc5>
  8029d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d4:	0f 85 b5 fe ff ff    	jne    80288f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029de:	0f 84 26 02 00 00    	je     802c0a <alloc_block_BF+0x440>
  8029e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029e8:	0f 85 1c 02 00 00    	jne    802c0a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f4:	83 e8 08             	sub    $0x8,%eax
  8029f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	8d 50 08             	lea    0x8(%eax),%edx
  802a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a03:	01 d0                	add    %edx,%eax
  802a05:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	83 c0 08             	add    $0x8,%eax
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	6a 01                	push   $0x1
  802a13:	50                   	push   %eax
  802a14:	ff 75 f0             	pushl  -0x10(%ebp)
  802a17:	e8 c3 f8 ff ff       	call   8022df <set_block_data>
  802a1c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	75 68                	jne    802a91 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a29:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a2d:	75 17                	jne    802a46 <alloc_block_BF+0x27c>
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 cc 44 80 00       	push   $0x8044cc
  802a37:	68 45 01 00 00       	push   $0x145
  802a3c:	68 b1 44 80 00       	push   $0x8044b1
  802a41:	e8 e1 0f 00 00       	call   803a27 <_panic>
  802a46:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0d                	je     802a67 <alloc_block_BF+0x29d>
  802a5a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	eb 08                	jmp    802a6f <alloc_block_BF+0x2a5>
  802a67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 38 50 80 00       	mov    0x805038,%eax
  802a86:	40                   	inc    %eax
  802a87:	a3 38 50 80 00       	mov    %eax,0x805038
  802a8c:	e9 dc 00 00 00       	jmp    802b6d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	75 65                	jne    802aff <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a9e:	75 17                	jne    802ab7 <alloc_block_BF+0x2ed>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 00 45 80 00       	push   $0x804500
  802aa8:	68 4a 01 00 00       	push   $0x14a
  802aad:	68 b1 44 80 00       	push   $0x8044b1
  802ab2:	e8 70 0f 00 00       	call   803a27 <_panic>
  802ab7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802abd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0c                	je     802ad9 <alloc_block_BF+0x30f>
  802acd:	a1 30 50 80 00       	mov    0x805030,%eax
  802ad2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	eb 08                	jmp    802ae1 <alloc_block_BF+0x317>
  802ad9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802adc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af2:	a1 38 50 80 00       	mov    0x805038,%eax
  802af7:	40                   	inc    %eax
  802af8:	a3 38 50 80 00       	mov    %eax,0x805038
  802afd:	eb 6e                	jmp    802b6d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802aff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b03:	74 06                	je     802b0b <alloc_block_BF+0x341>
  802b05:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b09:	75 17                	jne    802b22 <alloc_block_BF+0x358>
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	68 24 45 80 00       	push   $0x804524
  802b13:	68 4f 01 00 00       	push   $0x14f
  802b18:	68 b1 44 80 00       	push   $0x8044b1
  802b1d:	e8 05 0f 00 00       	call   803a27 <_panic>
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 10                	mov    (%eax),%edx
  802b27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2a:	89 10                	mov    %edx,(%eax)
  802b2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0b                	je     802b40 <alloc_block_BF+0x376>
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	75 08                	jne    802b62 <alloc_block_BF+0x398>
  802b5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b62:	a1 38 50 80 00       	mov    0x805038,%eax
  802b67:	40                   	inc    %eax
  802b68:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b71:	75 17                	jne    802b8a <alloc_block_BF+0x3c0>
  802b73:	83 ec 04             	sub    $0x4,%esp
  802b76:	68 93 44 80 00       	push   $0x804493
  802b7b:	68 51 01 00 00       	push   $0x151
  802b80:	68 b1 44 80 00       	push   $0x8044b1
  802b85:	e8 9d 0e 00 00       	call   803a27 <_panic>
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 10                	je     802ba3 <alloc_block_BF+0x3d9>
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9b:	8b 52 04             	mov    0x4(%edx),%edx
  802b9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ba1:	eb 0b                	jmp    802bae <alloc_block_BF+0x3e4>
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 40 04             	mov    0x4(%eax),%eax
  802ba9:	a3 30 50 80 00       	mov    %eax,0x805030
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 0f                	je     802bc7 <alloc_block_BF+0x3fd>
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc1:	8b 12                	mov    (%edx),%edx
  802bc3:	89 10                	mov    %edx,(%eax)
  802bc5:	eb 0a                	jmp    802bd1 <alloc_block_BF+0x407>
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be4:	a1 38 50 80 00       	mov    0x805038,%eax
  802be9:	48                   	dec    %eax
  802bea:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bef:	83 ec 04             	sub    $0x4,%esp
  802bf2:	6a 00                	push   $0x0
  802bf4:	ff 75 d0             	pushl  -0x30(%ebp)
  802bf7:	ff 75 cc             	pushl  -0x34(%ebp)
  802bfa:	e8 e0 f6 ff ff       	call   8022df <set_block_data>
  802bff:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	e9 a3 01 00 00       	jmp    802dad <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c0a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c0e:	0f 85 9d 00 00 00    	jne    802cb1 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	6a 01                	push   $0x1
  802c19:	ff 75 ec             	pushl  -0x14(%ebp)
  802c1c:	ff 75 f0             	pushl  -0x10(%ebp)
  802c1f:	e8 bb f6 ff ff       	call   8022df <set_block_data>
  802c24:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2b:	75 17                	jne    802c44 <alloc_block_BF+0x47a>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 93 44 80 00       	push   $0x804493
  802c35:	68 58 01 00 00       	push   $0x158
  802c3a:	68 b1 44 80 00       	push   $0x8044b1
  802c3f:	e8 e3 0d 00 00       	call   803a27 <_panic>
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 10                	je     802c5d <alloc_block_BF+0x493>
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c55:	8b 52 04             	mov    0x4(%edx),%edx
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	eb 0b                	jmp    802c68 <alloc_block_BF+0x49e>
  802c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	a3 30 50 80 00       	mov    %eax,0x805030
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0f                	je     802c81 <alloc_block_BF+0x4b7>
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7b:	8b 12                	mov    (%edx),%edx
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	eb 0a                	jmp    802c8b <alloc_block_BF+0x4c1>
  802c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca3:	48                   	dec    %eax
  802ca4:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	e9 fc 00 00 00       	jmp    802dad <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	83 c0 08             	add    $0x8,%eax
  802cb7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cba:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cc1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cc7:	01 d0                	add    %edx,%eax
  802cc9:	48                   	dec    %eax
  802cca:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ccd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd5:	f7 75 c4             	divl   -0x3c(%ebp)
  802cd8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cdb:	29 d0                	sub    %edx,%eax
  802cdd:	c1 e8 0c             	shr    $0xc,%eax
  802ce0:	83 ec 0c             	sub    $0xc,%esp
  802ce3:	50                   	push   %eax
  802ce4:	e8 37 e7 ff ff       	call   801420 <sbrk>
  802ce9:	83 c4 10             	add    $0x10,%esp
  802cec:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cef:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cf3:	75 0a                	jne    802cff <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfa:	e9 ae 00 00 00       	jmp    802dad <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cff:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d06:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d09:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d0c:	01 d0                	add    %edx,%eax
  802d0e:	48                   	dec    %eax
  802d0f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d12:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d15:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1a:	f7 75 b8             	divl   -0x48(%ebp)
  802d1d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d20:	29 d0                	sub    %edx,%eax
  802d22:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d25:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d28:	01 d0                	add    %edx,%eax
  802d2a:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d2f:	a1 40 50 80 00       	mov    0x805040,%eax
  802d34:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d3a:	83 ec 0c             	sub    $0xc,%esp
  802d3d:	68 58 45 80 00       	push   $0x804558
  802d42:	e8 3f d9 ff ff       	call   800686 <cprintf>
  802d47:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d4a:	83 ec 08             	sub    $0x8,%esp
  802d4d:	ff 75 bc             	pushl  -0x44(%ebp)
  802d50:	68 5d 45 80 00       	push   $0x80455d
  802d55:	e8 2c d9 ff ff       	call   800686 <cprintf>
  802d5a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d5d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d64:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d6a:	01 d0                	add    %edx,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d70:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d73:	ba 00 00 00 00       	mov    $0x0,%edx
  802d78:	f7 75 b0             	divl   -0x50(%ebp)
  802d7b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d7e:	29 d0                	sub    %edx,%eax
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	6a 01                	push   $0x1
  802d85:	50                   	push   %eax
  802d86:	ff 75 bc             	pushl  -0x44(%ebp)
  802d89:	e8 51 f5 ff ff       	call   8022df <set_block_data>
  802d8e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d91:	83 ec 0c             	sub    $0xc,%esp
  802d94:	ff 75 bc             	pushl  -0x44(%ebp)
  802d97:	e8 36 04 00 00       	call   8031d2 <free_block>
  802d9c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d9f:	83 ec 0c             	sub    $0xc,%esp
  802da2:	ff 75 08             	pushl  0x8(%ebp)
  802da5:	e8 20 fa ff ff       	call   8027ca <alloc_block_BF>
  802daa:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802dad:	c9                   	leave  
  802dae:	c3                   	ret    

00802daf <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802daf:	55                   	push   %ebp
  802db0:	89 e5                	mov    %esp,%ebp
  802db2:	53                   	push   %ebx
  802db3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dbd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc8:	74 1e                	je     802de8 <merging+0x39>
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	e8 bc f1 ff ff       	call   801f8e <get_block_size>
  802dd2:	83 c4 04             	add    $0x4,%esp
  802dd5:	89 c2                	mov    %eax,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	01 d0                	add    %edx,%eax
  802ddc:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ddf:	75 07                	jne    802de8 <merging+0x39>
		prev_is_free = 1;
  802de1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dec:	74 1e                	je     802e0c <merging+0x5d>
  802dee:	ff 75 10             	pushl  0x10(%ebp)
  802df1:	e8 98 f1 ff ff       	call   801f8e <get_block_size>
  802df6:	83 c4 04             	add    $0x4,%esp
  802df9:	89 c2                	mov    %eax,%edx
  802dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  802dfe:	01 d0                	add    %edx,%eax
  802e00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e03:	75 07                	jne    802e0c <merging+0x5d>
		next_is_free = 1;
  802e05:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e10:	0f 84 cc 00 00 00    	je     802ee2 <merging+0x133>
  802e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1a:	0f 84 c2 00 00 00    	je     802ee2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e20:	ff 75 08             	pushl  0x8(%ebp)
  802e23:	e8 66 f1 ff ff       	call   801f8e <get_block_size>
  802e28:	83 c4 04             	add    $0x4,%esp
  802e2b:	89 c3                	mov    %eax,%ebx
  802e2d:	ff 75 10             	pushl  0x10(%ebp)
  802e30:	e8 59 f1 ff ff       	call   801f8e <get_block_size>
  802e35:	83 c4 04             	add    $0x4,%esp
  802e38:	01 c3                	add    %eax,%ebx
  802e3a:	ff 75 0c             	pushl  0xc(%ebp)
  802e3d:	e8 4c f1 ff ff       	call   801f8e <get_block_size>
  802e42:	83 c4 04             	add    $0x4,%esp
  802e45:	01 d8                	add    %ebx,%eax
  802e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e4a:	6a 00                	push   $0x0
  802e4c:	ff 75 ec             	pushl  -0x14(%ebp)
  802e4f:	ff 75 08             	pushl  0x8(%ebp)
  802e52:	e8 88 f4 ff ff       	call   8022df <set_block_data>
  802e57:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e5e:	75 17                	jne    802e77 <merging+0xc8>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 93 44 80 00       	push   $0x804493
  802e68:	68 7d 01 00 00       	push   $0x17d
  802e6d:	68 b1 44 80 00       	push   $0x8044b1
  802e72:	e8 b0 0b 00 00       	call   803a27 <_panic>
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 10                	je     802e90 <merging+0xe1>
  802e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e88:	8b 52 04             	mov    0x4(%edx),%edx
  802e8b:	89 50 04             	mov    %edx,0x4(%eax)
  802e8e:	eb 0b                	jmp    802e9b <merging+0xec>
  802e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	a3 30 50 80 00       	mov    %eax,0x805030
  802e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 0f                	je     802eb4 <merging+0x105>
  802ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea8:	8b 40 04             	mov    0x4(%eax),%eax
  802eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eae:	8b 12                	mov    (%edx),%edx
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	eb 0a                	jmp    802ebe <merging+0x10f>
  802eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed6:	48                   	dec    %eax
  802ed7:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802edc:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802edd:	e9 ea 02 00 00       	jmp    8031cc <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee6:	74 3b                	je     802f23 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	ff 75 08             	pushl  0x8(%ebp)
  802eee:	e8 9b f0 ff ff       	call   801f8e <get_block_size>
  802ef3:	83 c4 10             	add    $0x10,%esp
  802ef6:	89 c3                	mov    %eax,%ebx
  802ef8:	83 ec 0c             	sub    $0xc,%esp
  802efb:	ff 75 10             	pushl  0x10(%ebp)
  802efe:	e8 8b f0 ff ff       	call   801f8e <get_block_size>
  802f03:	83 c4 10             	add    $0x10,%esp
  802f06:	01 d8                	add    %ebx,%eax
  802f08:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	6a 00                	push   $0x0
  802f10:	ff 75 e8             	pushl  -0x18(%ebp)
  802f13:	ff 75 08             	pushl  0x8(%ebp)
  802f16:	e8 c4 f3 ff ff       	call   8022df <set_block_data>
  802f1b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f1e:	e9 a9 02 00 00       	jmp    8031cc <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f27:	0f 84 2d 01 00 00    	je     80305a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f2d:	83 ec 0c             	sub    $0xc,%esp
  802f30:	ff 75 10             	pushl  0x10(%ebp)
  802f33:	e8 56 f0 ff ff       	call   801f8e <get_block_size>
  802f38:	83 c4 10             	add    $0x10,%esp
  802f3b:	89 c3                	mov    %eax,%ebx
  802f3d:	83 ec 0c             	sub    $0xc,%esp
  802f40:	ff 75 0c             	pushl  0xc(%ebp)
  802f43:	e8 46 f0 ff ff       	call   801f8e <get_block_size>
  802f48:	83 c4 10             	add    $0x10,%esp
  802f4b:	01 d8                	add    %ebx,%eax
  802f4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	6a 00                	push   $0x0
  802f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f58:	ff 75 10             	pushl  0x10(%ebp)
  802f5b:	e8 7f f3 ff ff       	call   8022df <set_block_data>
  802f60:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f63:	8b 45 10             	mov    0x10(%ebp),%eax
  802f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6d:	74 06                	je     802f75 <merging+0x1c6>
  802f6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f73:	75 17                	jne    802f8c <merging+0x1dd>
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	68 6c 45 80 00       	push   $0x80456c
  802f7d:	68 8d 01 00 00       	push   $0x18d
  802f82:	68 b1 44 80 00       	push   $0x8044b1
  802f87:	e8 9b 0a 00 00       	call   803a27 <_panic>
  802f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8f:	8b 50 04             	mov    0x4(%eax),%edx
  802f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa3:	8b 40 04             	mov    0x4(%eax),%eax
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	74 0d                	je     802fb7 <merging+0x208>
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	8b 40 04             	mov    0x4(%eax),%eax
  802fb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	eb 08                	jmp    802fbf <merging+0x210>
  802fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fc5:	89 50 04             	mov    %edx,0x4(%eax)
  802fc8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fcd:	40                   	inc    %eax
  802fce:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd7:	75 17                	jne    802ff0 <merging+0x241>
  802fd9:	83 ec 04             	sub    $0x4,%esp
  802fdc:	68 93 44 80 00       	push   $0x804493
  802fe1:	68 8e 01 00 00       	push   $0x18e
  802fe6:	68 b1 44 80 00       	push   $0x8044b1
  802feb:	e8 37 0a 00 00       	call   803a27 <_panic>
  802ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 10                	je     803009 <merging+0x25a>
  802ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803001:	8b 52 04             	mov    0x4(%edx),%edx
  803004:	89 50 04             	mov    %edx,0x4(%eax)
  803007:	eb 0b                	jmp    803014 <merging+0x265>
  803009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300c:	8b 40 04             	mov    0x4(%eax),%eax
  80300f:	a3 30 50 80 00       	mov    %eax,0x805030
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	85 c0                	test   %eax,%eax
  80301c:	74 0f                	je     80302d <merging+0x27e>
  80301e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803021:	8b 40 04             	mov    0x4(%eax),%eax
  803024:	8b 55 0c             	mov    0xc(%ebp),%edx
  803027:	8b 12                	mov    (%edx),%edx
  803029:	89 10                	mov    %edx,(%eax)
  80302b:	eb 0a                	jmp    803037 <merging+0x288>
  80302d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803040:	8b 45 0c             	mov    0xc(%ebp),%eax
  803043:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304a:	a1 38 50 80 00       	mov    0x805038,%eax
  80304f:	48                   	dec    %eax
  803050:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803055:	e9 72 01 00 00       	jmp    8031cc <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80305a:	8b 45 10             	mov    0x10(%ebp),%eax
  80305d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803064:	74 79                	je     8030df <merging+0x330>
  803066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80306a:	74 73                	je     8030df <merging+0x330>
  80306c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803070:	74 06                	je     803078 <merging+0x2c9>
  803072:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803076:	75 17                	jne    80308f <merging+0x2e0>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 24 45 80 00       	push   $0x804524
  803080:	68 94 01 00 00       	push   $0x194
  803085:	68 b1 44 80 00       	push   $0x8044b1
  80308a:	e8 98 09 00 00       	call   803a27 <_panic>
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 10                	mov    (%eax),%edx
  803094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803097:	89 10                	mov    %edx,(%eax)
  803099:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0b                	je     8030ad <merging+0x2fe>
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030b3:	89 10                	mov    %edx,(%eax)
  8030b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	75 08                	jne    8030cf <merging+0x320>
  8030c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8030cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d4:	40                   	inc    %eax
  8030d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8030da:	e9 ce 00 00 00       	jmp    8031ad <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e3:	74 65                	je     80314a <merging+0x39b>
  8030e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030e9:	75 17                	jne    803102 <merging+0x353>
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	68 00 45 80 00       	push   $0x804500
  8030f3:	68 95 01 00 00       	push   $0x195
  8030f8:	68 b1 44 80 00       	push   $0x8044b1
  8030fd:	e8 25 09 00 00       	call   803a27 <_panic>
  803102:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803108:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	74 0c                	je     803124 <merging+0x375>
  803118:	a1 30 50 80 00       	mov    0x805030,%eax
  80311d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803120:	89 10                	mov    %edx,(%eax)
  803122:	eb 08                	jmp    80312c <merging+0x37d>
  803124:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803127:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80312c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312f:	a3 30 50 80 00       	mov    %eax,0x805030
  803134:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803137:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313d:	a1 38 50 80 00       	mov    0x805038,%eax
  803142:	40                   	inc    %eax
  803143:	a3 38 50 80 00       	mov    %eax,0x805038
  803148:	eb 63                	jmp    8031ad <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80314a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80314e:	75 17                	jne    803167 <merging+0x3b8>
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	68 cc 44 80 00       	push   $0x8044cc
  803158:	68 98 01 00 00       	push   $0x198
  80315d:	68 b1 44 80 00       	push   $0x8044b1
  803162:	e8 c0 08 00 00       	call   803a27 <_panic>
  803167:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80316d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803170:	89 10                	mov    %edx,(%eax)
  803172:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	85 c0                	test   %eax,%eax
  803179:	74 0d                	je     803188 <merging+0x3d9>
  80317b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803180:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	eb 08                	jmp    803190 <merging+0x3e1>
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	a3 30 50 80 00       	mov    %eax,0x805030
  803190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803193:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803198:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8031a7:	40                   	inc    %eax
  8031a8:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031ad:	83 ec 0c             	sub    $0xc,%esp
  8031b0:	ff 75 10             	pushl  0x10(%ebp)
  8031b3:	e8 d6 ed ff ff       	call   801f8e <get_block_size>
  8031b8:	83 c4 10             	add    $0x10,%esp
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	6a 00                	push   $0x0
  8031c0:	50                   	push   %eax
  8031c1:	ff 75 10             	pushl  0x10(%ebp)
  8031c4:	e8 16 f1 ff ff       	call   8022df <set_block_data>
  8031c9:	83 c4 10             	add    $0x10,%esp
	}
}
  8031cc:	90                   	nop
  8031cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d0:	c9                   	leave  
  8031d1:	c3                   	ret    

008031d2 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031d2:	55                   	push   %ebp
  8031d3:	89 e5                	mov    %esp,%ebp
  8031d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031dd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031e0:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e8:	73 1b                	jae    803205 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031ea:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	ff 75 08             	pushl  0x8(%ebp)
  8031f5:	6a 00                	push   $0x0
  8031f7:	50                   	push   %eax
  8031f8:	e8 b2 fb ff ff       	call   802daf <merging>
  8031fd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803200:	e9 8b 00 00 00       	jmp    803290 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803205:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80320a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320d:	76 18                	jbe    803227 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80320f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803214:	83 ec 04             	sub    $0x4,%esp
  803217:	ff 75 08             	pushl  0x8(%ebp)
  80321a:	50                   	push   %eax
  80321b:	6a 00                	push   $0x0
  80321d:	e8 8d fb ff ff       	call   802daf <merging>
  803222:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803225:	eb 69                	jmp    803290 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803227:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80322c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322f:	eb 39                	jmp    80326a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	3b 45 08             	cmp    0x8(%ebp),%eax
  803237:	73 29                	jae    803262 <free_block+0x90>
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803241:	76 1f                	jbe    803262 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	ff 75 08             	pushl  0x8(%ebp)
  803251:	ff 75 f0             	pushl  -0x10(%ebp)
  803254:	ff 75 f4             	pushl  -0xc(%ebp)
  803257:	e8 53 fb ff ff       	call   802daf <merging>
  80325c:	83 c4 10             	add    $0x10,%esp
			break;
  80325f:	90                   	nop
		}
	}
}
  803260:	eb 2e                	jmp    803290 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803262:	a1 34 50 80 00       	mov    0x805034,%eax
  803267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326e:	74 07                	je     803277 <free_block+0xa5>
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	eb 05                	jmp    80327c <free_block+0xaa>
  803277:	b8 00 00 00 00       	mov    $0x0,%eax
  80327c:	a3 34 50 80 00       	mov    %eax,0x805034
  803281:	a1 34 50 80 00       	mov    0x805034,%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	75 a7                	jne    803231 <free_block+0x5f>
  80328a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328e:	75 a1                	jne    803231 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803290:	90                   	nop
  803291:	c9                   	leave  
  803292:	c3                   	ret    

00803293 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803293:	55                   	push   %ebp
  803294:	89 e5                	mov    %esp,%ebp
  803296:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803299:	ff 75 08             	pushl  0x8(%ebp)
  80329c:	e8 ed ec ff ff       	call   801f8e <get_block_size>
  8032a1:	83 c4 04             	add    $0x4,%esp
  8032a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032ae:	eb 17                	jmp    8032c7 <copy_data+0x34>
  8032b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b6:	01 c2                	add    %eax,%edx
  8032b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	01 c8                	add    %ecx,%eax
  8032c0:	8a 00                	mov    (%eax),%al
  8032c2:	88 02                	mov    %al,(%edx)
  8032c4:	ff 45 fc             	incl   -0x4(%ebp)
  8032c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032cd:	72 e1                	jb     8032b0 <copy_data+0x1d>
}
  8032cf:	90                   	nop
  8032d0:	c9                   	leave  
  8032d1:	c3                   	ret    

008032d2 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032d2:	55                   	push   %ebp
  8032d3:	89 e5                	mov    %esp,%ebp
  8032d5:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032dc:	75 23                	jne    803301 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032e2:	74 13                	je     8032f7 <realloc_block_FF+0x25>
  8032e4:	83 ec 0c             	sub    $0xc,%esp
  8032e7:	ff 75 0c             	pushl  0xc(%ebp)
  8032ea:	e8 1f f0 ff ff       	call   80230e <alloc_block_FF>
  8032ef:	83 c4 10             	add    $0x10,%esp
  8032f2:	e9 f4 06 00 00       	jmp    8039eb <realloc_block_FF+0x719>
		return NULL;
  8032f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fc:	e9 ea 06 00 00       	jmp    8039eb <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803301:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803305:	75 18                	jne    80331f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	ff 75 08             	pushl  0x8(%ebp)
  80330d:	e8 c0 fe ff ff       	call   8031d2 <free_block>
  803312:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
  80331a:	e9 cc 06 00 00       	jmp    8039eb <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80331f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803323:	77 07                	ja     80332c <realloc_block_FF+0x5a>
  803325:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80332c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332f:	83 e0 01             	and    $0x1,%eax
  803332:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803335:	8b 45 0c             	mov    0xc(%ebp),%eax
  803338:	83 c0 08             	add    $0x8,%eax
  80333b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80333e:	83 ec 0c             	sub    $0xc,%esp
  803341:	ff 75 08             	pushl  0x8(%ebp)
  803344:	e8 45 ec ff ff       	call   801f8e <get_block_size>
  803349:	83 c4 10             	add    $0x10,%esp
  80334c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80334f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803352:	83 e8 08             	sub    $0x8,%eax
  803355:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	83 e8 04             	sub    $0x4,%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	83 e0 fe             	and    $0xfffffffe,%eax
  803363:	89 c2                	mov    %eax,%edx
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	01 d0                	add    %edx,%eax
  80336a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80336d:	83 ec 0c             	sub    $0xc,%esp
  803370:	ff 75 e4             	pushl  -0x1c(%ebp)
  803373:	e8 16 ec ff ff       	call   801f8e <get_block_size>
  803378:	83 c4 10             	add    $0x10,%esp
  80337b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80337e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803381:	83 e8 08             	sub    $0x8,%eax
  803384:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80338d:	75 08                	jne    803397 <realloc_block_FF+0xc5>
	{
		 return va;
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	e9 54 06 00 00       	jmp    8039eb <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80339d:	0f 83 e5 03 00 00    	jae    803788 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033ac:	83 ec 0c             	sub    $0xc,%esp
  8033af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033b2:	e8 f0 eb ff ff       	call   801fa7 <is_free_block>
  8033b7:	83 c4 10             	add    $0x10,%esp
  8033ba:	84 c0                	test   %al,%al
  8033bc:	0f 84 3b 01 00 00    	je     8034fd <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033c8:	01 d0                	add    %edx,%eax
  8033ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033cd:	83 ec 04             	sub    $0x4,%esp
  8033d0:	6a 01                	push   $0x1
  8033d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8033d5:	ff 75 08             	pushl  0x8(%ebp)
  8033d8:	e8 02 ef ff ff       	call   8022df <set_block_data>
  8033dd:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	83 e8 04             	sub    $0x4,%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8033eb:	89 c2                	mov    %eax,%edx
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	01 d0                	add    %edx,%eax
  8033f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033f5:	83 ec 04             	sub    $0x4,%esp
  8033f8:	6a 00                	push   $0x0
  8033fa:	ff 75 cc             	pushl  -0x34(%ebp)
  8033fd:	ff 75 c8             	pushl  -0x38(%ebp)
  803400:	e8 da ee ff ff       	call   8022df <set_block_data>
  803405:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803408:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80340c:	74 06                	je     803414 <realloc_block_FF+0x142>
  80340e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803412:	75 17                	jne    80342b <realloc_block_FF+0x159>
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	68 24 45 80 00       	push   $0x804524
  80341c:	68 f6 01 00 00       	push   $0x1f6
  803421:	68 b1 44 80 00       	push   $0x8044b1
  803426:	e8 fc 05 00 00       	call   803a27 <_panic>
  80342b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342e:	8b 10                	mov    (%eax),%edx
  803430:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803433:	89 10                	mov    %edx,(%eax)
  803435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	85 c0                	test   %eax,%eax
  80343c:	74 0b                	je     803449 <realloc_block_FF+0x177>
  80343e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803446:	89 50 04             	mov    %edx,0x4(%eax)
  803449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80344f:	89 10                	mov    %edx,(%eax)
  803451:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803457:	89 50 04             	mov    %edx,0x4(%eax)
  80345a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	85 c0                	test   %eax,%eax
  803461:	75 08                	jne    80346b <realloc_block_FF+0x199>
  803463:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803466:	a3 30 50 80 00       	mov    %eax,0x805030
  80346b:	a1 38 50 80 00       	mov    0x805038,%eax
  803470:	40                   	inc    %eax
  803471:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803476:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80347a:	75 17                	jne    803493 <realloc_block_FF+0x1c1>
  80347c:	83 ec 04             	sub    $0x4,%esp
  80347f:	68 93 44 80 00       	push   $0x804493
  803484:	68 f7 01 00 00       	push   $0x1f7
  803489:	68 b1 44 80 00       	push   $0x8044b1
  80348e:	e8 94 05 00 00       	call   803a27 <_panic>
  803493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803496:	8b 00                	mov    (%eax),%eax
  803498:	85 c0                	test   %eax,%eax
  80349a:	74 10                	je     8034ac <realloc_block_FF+0x1da>
  80349c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a4:	8b 52 04             	mov    0x4(%edx),%edx
  8034a7:	89 50 04             	mov    %edx,0x4(%eax)
  8034aa:	eb 0b                	jmp    8034b7 <realloc_block_FF+0x1e5>
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ba:	8b 40 04             	mov    0x4(%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 0f                	je     8034d0 <realloc_block_FF+0x1fe>
  8034c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ca:	8b 12                	mov    (%edx),%edx
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	eb 0a                	jmp    8034da <realloc_block_FF+0x208>
  8034d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f2:	48                   	dec    %eax
  8034f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f8:	e9 83 02 00 00       	jmp    803780 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034fd:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803501:	0f 86 69 02 00 00    	jbe    803770 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	6a 01                	push   $0x1
  80350c:	ff 75 f0             	pushl  -0x10(%ebp)
  80350f:	ff 75 08             	pushl  0x8(%ebp)
  803512:	e8 c8 ed ff ff       	call   8022df <set_block_data>
  803517:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	83 e8 04             	sub    $0x4,%eax
  803520:	8b 00                	mov    (%eax),%eax
  803522:	83 e0 fe             	and    $0xfffffffe,%eax
  803525:	89 c2                	mov    %eax,%edx
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	01 d0                	add    %edx,%eax
  80352c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80352f:	a1 38 50 80 00       	mov    0x805038,%eax
  803534:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803537:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80353b:	75 68                	jne    8035a5 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80353d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803541:	75 17                	jne    80355a <realloc_block_FF+0x288>
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	68 cc 44 80 00       	push   $0x8044cc
  80354b:	68 06 02 00 00       	push   $0x206
  803550:	68 b1 44 80 00       	push   $0x8044b1
  803555:	e8 cd 04 00 00       	call   803a27 <_panic>
  80355a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803563:	89 10                	mov    %edx,(%eax)
  803565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803568:	8b 00                	mov    (%eax),%eax
  80356a:	85 c0                	test   %eax,%eax
  80356c:	74 0d                	je     80357b <realloc_block_FF+0x2a9>
  80356e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803573:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803576:	89 50 04             	mov    %edx,0x4(%eax)
  803579:	eb 08                	jmp    803583 <realloc_block_FF+0x2b1>
  80357b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357e:	a3 30 50 80 00       	mov    %eax,0x805030
  803583:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803586:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80358b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803595:	a1 38 50 80 00       	mov    0x805038,%eax
  80359a:	40                   	inc    %eax
  80359b:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a0:	e9 b0 01 00 00       	jmp    803755 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ad:	76 68                	jbe    803617 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035b3:	75 17                	jne    8035cc <realloc_block_FF+0x2fa>
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	68 cc 44 80 00       	push   $0x8044cc
  8035bd:	68 0b 02 00 00       	push   $0x20b
  8035c2:	68 b1 44 80 00       	push   $0x8044b1
  8035c7:	e8 5b 04 00 00       	call   803a27 <_panic>
  8035cc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	89 10                	mov    %edx,(%eax)
  8035d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	85 c0                	test   %eax,%eax
  8035de:	74 0d                	je     8035ed <realloc_block_FF+0x31b>
  8035e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035e8:	89 50 04             	mov    %edx,0x4(%eax)
  8035eb:	eb 08                	jmp    8035f5 <realloc_block_FF+0x323>
  8035ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803607:	a1 38 50 80 00       	mov    0x805038,%eax
  80360c:	40                   	inc    %eax
  80360d:	a3 38 50 80 00       	mov    %eax,0x805038
  803612:	e9 3e 01 00 00       	jmp    803755 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803617:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80361c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80361f:	73 68                	jae    803689 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803621:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803625:	75 17                	jne    80363e <realloc_block_FF+0x36c>
  803627:	83 ec 04             	sub    $0x4,%esp
  80362a:	68 00 45 80 00       	push   $0x804500
  80362f:	68 10 02 00 00       	push   $0x210
  803634:	68 b1 44 80 00       	push   $0x8044b1
  803639:	e8 e9 03 00 00       	call   803a27 <_panic>
  80363e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803647:	89 50 04             	mov    %edx,0x4(%eax)
  80364a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364d:	8b 40 04             	mov    0x4(%eax),%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	74 0c                	je     803660 <realloc_block_FF+0x38e>
  803654:	a1 30 50 80 00       	mov    0x805030,%eax
  803659:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80365c:	89 10                	mov    %edx,(%eax)
  80365e:	eb 08                	jmp    803668 <realloc_block_FF+0x396>
  803660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803663:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366b:	a3 30 50 80 00       	mov    %eax,0x805030
  803670:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803679:	a1 38 50 80 00       	mov    0x805038,%eax
  80367e:	40                   	inc    %eax
  80367f:	a3 38 50 80 00       	mov    %eax,0x805038
  803684:	e9 cc 00 00 00       	jmp    803755 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803689:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803690:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803695:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803698:	e9 8a 00 00 00       	jmp    803727 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036a3:	73 7a                	jae    80371f <realloc_block_FF+0x44d>
  8036a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036ad:	73 70                	jae    80371f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b3:	74 06                	je     8036bb <realloc_block_FF+0x3e9>
  8036b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b9:	75 17                	jne    8036d2 <realloc_block_FF+0x400>
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 24 45 80 00       	push   $0x804524
  8036c3:	68 1a 02 00 00       	push   $0x21a
  8036c8:	68 b1 44 80 00       	push   $0x8044b1
  8036cd:	e8 55 03 00 00       	call   803a27 <_panic>
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	8b 10                	mov    (%eax),%edx
  8036d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	74 0b                	je     8036f0 <realloc_block_FF+0x41e>
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 00                	mov    (%eax),%eax
  8036ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ed:	89 50 04             	mov    %edx,0x4(%eax)
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f6:	89 10                	mov    %edx,(%eax)
  8036f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036fe:	89 50 04             	mov    %edx,0x4(%eax)
  803701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	85 c0                	test   %eax,%eax
  803708:	75 08                	jne    803712 <realloc_block_FF+0x440>
  80370a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370d:	a3 30 50 80 00       	mov    %eax,0x805030
  803712:	a1 38 50 80 00       	mov    0x805038,%eax
  803717:	40                   	inc    %eax
  803718:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80371d:	eb 36                	jmp    803755 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80371f:	a1 34 50 80 00       	mov    0x805034,%eax
  803724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372b:	74 07                	je     803734 <realloc_block_FF+0x462>
  80372d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	eb 05                	jmp    803739 <realloc_block_FF+0x467>
  803734:	b8 00 00 00 00       	mov    $0x0,%eax
  803739:	a3 34 50 80 00       	mov    %eax,0x805034
  80373e:	a1 34 50 80 00       	mov    0x805034,%eax
  803743:	85 c0                	test   %eax,%eax
  803745:	0f 85 52 ff ff ff    	jne    80369d <realloc_block_FF+0x3cb>
  80374b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374f:	0f 85 48 ff ff ff    	jne    80369d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803755:	83 ec 04             	sub    $0x4,%esp
  803758:	6a 00                	push   $0x0
  80375a:	ff 75 d8             	pushl  -0x28(%ebp)
  80375d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803760:	e8 7a eb ff ff       	call   8022df <set_block_data>
  803765:	83 c4 10             	add    $0x10,%esp
				return va;
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	e9 7b 02 00 00       	jmp    8039eb <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803770:	83 ec 0c             	sub    $0xc,%esp
  803773:	68 a1 45 80 00       	push   $0x8045a1
  803778:	e8 09 cf ff ff       	call   800686 <cprintf>
  80377d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	e9 63 02 00 00       	jmp    8039eb <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80378e:	0f 86 4d 02 00 00    	jbe    8039e1 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803794:	83 ec 0c             	sub    $0xc,%esp
  803797:	ff 75 e4             	pushl  -0x1c(%ebp)
  80379a:	e8 08 e8 ff ff       	call   801fa7 <is_free_block>
  80379f:	83 c4 10             	add    $0x10,%esp
  8037a2:	84 c0                	test   %al,%al
  8037a4:	0f 84 37 02 00 00    	je     8039e1 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ad:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037b0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037b6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037b9:	76 38                	jbe    8037f3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037bb:	83 ec 0c             	sub    $0xc,%esp
  8037be:	ff 75 08             	pushl  0x8(%ebp)
  8037c1:	e8 0c fa ff ff       	call   8031d2 <free_block>
  8037c6:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037c9:	83 ec 0c             	sub    $0xc,%esp
  8037cc:	ff 75 0c             	pushl  0xc(%ebp)
  8037cf:	e8 3a eb ff ff       	call   80230e <alloc_block_FF>
  8037d4:	83 c4 10             	add    $0x10,%esp
  8037d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037da:	83 ec 08             	sub    $0x8,%esp
  8037dd:	ff 75 c0             	pushl  -0x40(%ebp)
  8037e0:	ff 75 08             	pushl  0x8(%ebp)
  8037e3:	e8 ab fa ff ff       	call   803293 <copy_data>
  8037e8:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037ee:	e9 f8 01 00 00       	jmp    8039eb <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037f9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037fc:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803800:	0f 87 a0 00 00 00    	ja     8038a6 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80380a:	75 17                	jne    803823 <realloc_block_FF+0x551>
  80380c:	83 ec 04             	sub    $0x4,%esp
  80380f:	68 93 44 80 00       	push   $0x804493
  803814:	68 38 02 00 00       	push   $0x238
  803819:	68 b1 44 80 00       	push   $0x8044b1
  80381e:	e8 04 02 00 00       	call   803a27 <_panic>
  803823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	85 c0                	test   %eax,%eax
  80382a:	74 10                	je     80383c <realloc_block_FF+0x56a>
  80382c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382f:	8b 00                	mov    (%eax),%eax
  803831:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803834:	8b 52 04             	mov    0x4(%edx),%edx
  803837:	89 50 04             	mov    %edx,0x4(%eax)
  80383a:	eb 0b                	jmp    803847 <realloc_block_FF+0x575>
  80383c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383f:	8b 40 04             	mov    0x4(%eax),%eax
  803842:	a3 30 50 80 00       	mov    %eax,0x805030
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	8b 40 04             	mov    0x4(%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 0f                	je     803860 <realloc_block_FF+0x58e>
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	8b 40 04             	mov    0x4(%eax),%eax
  803857:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385a:	8b 12                	mov    (%edx),%edx
  80385c:	89 10                	mov    %edx,(%eax)
  80385e:	eb 0a                	jmp    80386a <realloc_block_FF+0x598>
  803860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803863:	8b 00                	mov    (%eax),%eax
  803865:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80386a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387d:	a1 38 50 80 00       	mov    0x805038,%eax
  803882:	48                   	dec    %eax
  803883:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388e:	01 d0                	add    %edx,%eax
  803890:	83 ec 04             	sub    $0x4,%esp
  803893:	6a 01                	push   $0x1
  803895:	50                   	push   %eax
  803896:	ff 75 08             	pushl  0x8(%ebp)
  803899:	e8 41 ea ff ff       	call   8022df <set_block_data>
  80389e:	83 c4 10             	add    $0x10,%esp
  8038a1:	e9 36 01 00 00       	jmp    8039dc <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038ac:	01 d0                	add    %edx,%eax
  8038ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038b1:	83 ec 04             	sub    $0x4,%esp
  8038b4:	6a 01                	push   $0x1
  8038b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8038b9:	ff 75 08             	pushl  0x8(%ebp)
  8038bc:	e8 1e ea ff ff       	call   8022df <set_block_data>
  8038c1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c7:	83 e8 04             	sub    $0x4,%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8038cf:	89 c2                	mov    %eax,%edx
  8038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d4:	01 d0                	add    %edx,%eax
  8038d6:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038dd:	74 06                	je     8038e5 <realloc_block_FF+0x613>
  8038df:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038e3:	75 17                	jne    8038fc <realloc_block_FF+0x62a>
  8038e5:	83 ec 04             	sub    $0x4,%esp
  8038e8:	68 24 45 80 00       	push   $0x804524
  8038ed:	68 44 02 00 00       	push   $0x244
  8038f2:	68 b1 44 80 00       	push   $0x8044b1
  8038f7:	e8 2b 01 00 00       	call   803a27 <_panic>
  8038fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ff:	8b 10                	mov    (%eax),%edx
  803901:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803904:	89 10                	mov    %edx,(%eax)
  803906:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803909:	8b 00                	mov    (%eax),%eax
  80390b:	85 c0                	test   %eax,%eax
  80390d:	74 0b                	je     80391a <realloc_block_FF+0x648>
  80390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803917:	89 50 04             	mov    %edx,0x4(%eax)
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803920:	89 10                	mov    %edx,(%eax)
  803922:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803928:	89 50 04             	mov    %edx,0x4(%eax)
  80392b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	85 c0                	test   %eax,%eax
  803932:	75 08                	jne    80393c <realloc_block_FF+0x66a>
  803934:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803937:	a3 30 50 80 00       	mov    %eax,0x805030
  80393c:	a1 38 50 80 00       	mov    0x805038,%eax
  803941:	40                   	inc    %eax
  803942:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80394b:	75 17                	jne    803964 <realloc_block_FF+0x692>
  80394d:	83 ec 04             	sub    $0x4,%esp
  803950:	68 93 44 80 00       	push   $0x804493
  803955:	68 45 02 00 00       	push   $0x245
  80395a:	68 b1 44 80 00       	push   $0x8044b1
  80395f:	e8 c3 00 00 00       	call   803a27 <_panic>
  803964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803967:	8b 00                	mov    (%eax),%eax
  803969:	85 c0                	test   %eax,%eax
  80396b:	74 10                	je     80397d <realloc_block_FF+0x6ab>
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803975:	8b 52 04             	mov    0x4(%edx),%edx
  803978:	89 50 04             	mov    %edx,0x4(%eax)
  80397b:	eb 0b                	jmp    803988 <realloc_block_FF+0x6b6>
  80397d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803980:	8b 40 04             	mov    0x4(%eax),%eax
  803983:	a3 30 50 80 00       	mov    %eax,0x805030
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	8b 40 04             	mov    0x4(%eax),%eax
  80398e:	85 c0                	test   %eax,%eax
  803990:	74 0f                	je     8039a1 <realloc_block_FF+0x6cf>
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	8b 40 04             	mov    0x4(%eax),%eax
  803998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399b:	8b 12                	mov    (%edx),%edx
  80399d:	89 10                	mov    %edx,(%eax)
  80399f:	eb 0a                	jmp    8039ab <realloc_block_FF+0x6d9>
  8039a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039be:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c3:	48                   	dec    %eax
  8039c4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039c9:	83 ec 04             	sub    $0x4,%esp
  8039cc:	6a 00                	push   $0x0
  8039ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8039d1:	ff 75 b8             	pushl  -0x48(%ebp)
  8039d4:	e8 06 e9 ff ff       	call   8022df <set_block_data>
  8039d9:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	eb 0a                	jmp    8039eb <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039e1:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039eb:	c9                   	leave  
  8039ec:	c3                   	ret    

008039ed <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039ed:	55                   	push   %ebp
  8039ee:	89 e5                	mov    %esp,%ebp
  8039f0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039f3:	83 ec 04             	sub    $0x4,%esp
  8039f6:	68 a8 45 80 00       	push   $0x8045a8
  8039fb:	68 58 02 00 00       	push   $0x258
  803a00:	68 b1 44 80 00       	push   $0x8044b1
  803a05:	e8 1d 00 00 00       	call   803a27 <_panic>

00803a0a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a0a:	55                   	push   %ebp
  803a0b:	89 e5                	mov    %esp,%ebp
  803a0d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a10:	83 ec 04             	sub    $0x4,%esp
  803a13:	68 d0 45 80 00       	push   $0x8045d0
  803a18:	68 61 02 00 00       	push   $0x261
  803a1d:	68 b1 44 80 00       	push   $0x8044b1
  803a22:	e8 00 00 00 00       	call   803a27 <_panic>

00803a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a27:	55                   	push   %ebp
  803a28:	89 e5                	mov    %esp,%ebp
  803a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  803a30:	83 c0 04             	add    $0x4,%eax
  803a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a36:	a1 60 50 98 00       	mov    0x985060,%eax
  803a3b:	85 c0                	test   %eax,%eax
  803a3d:	74 16                	je     803a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a3f:	a1 60 50 98 00       	mov    0x985060,%eax
  803a44:	83 ec 08             	sub    $0x8,%esp
  803a47:	50                   	push   %eax
  803a48:	68 f8 45 80 00       	push   $0x8045f8
  803a4d:	e8 34 cc ff ff       	call   800686 <cprintf>
  803a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a55:	a1 00 50 80 00       	mov    0x805000,%eax
  803a5a:	ff 75 0c             	pushl  0xc(%ebp)
  803a5d:	ff 75 08             	pushl  0x8(%ebp)
  803a60:	50                   	push   %eax
  803a61:	68 fd 45 80 00       	push   $0x8045fd
  803a66:	e8 1b cc ff ff       	call   800686 <cprintf>
  803a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  803a71:	83 ec 08             	sub    $0x8,%esp
  803a74:	ff 75 f4             	pushl  -0xc(%ebp)
  803a77:	50                   	push   %eax
  803a78:	e8 9e cb ff ff       	call   80061b <vcprintf>
  803a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a80:	83 ec 08             	sub    $0x8,%esp
  803a83:	6a 00                	push   $0x0
  803a85:	68 19 46 80 00       	push   $0x804619
  803a8a:	e8 8c cb ff ff       	call   80061b <vcprintf>
  803a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a92:	e8 0d cb ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  803a97:	eb fe                	jmp    803a97 <_panic+0x70>

00803a99 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a99:	55                   	push   %ebp
  803a9a:	89 e5                	mov    %esp,%ebp
  803a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  803aa4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aad:	39 c2                	cmp    %eax,%edx
  803aaf:	74 14                	je     803ac5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ab1:	83 ec 04             	sub    $0x4,%esp
  803ab4:	68 1c 46 80 00       	push   $0x80461c
  803ab9:	6a 26                	push   $0x26
  803abb:	68 68 46 80 00       	push   $0x804668
  803ac0:	e8 62 ff ff ff       	call   803a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803acc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ad3:	e9 c5 00 00 00       	jmp    803b9d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803adb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae5:	01 d0                	add    %edx,%eax
  803ae7:	8b 00                	mov    (%eax),%eax
  803ae9:	85 c0                	test   %eax,%eax
  803aeb:	75 08                	jne    803af5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803aed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803af0:	e9 a5 00 00 00       	jmp    803b9a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803af5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803afc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b03:	eb 69                	jmp    803b6e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b05:	a1 20 50 80 00       	mov    0x805020,%eax
  803b0a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b13:	89 d0                	mov    %edx,%eax
  803b15:	01 c0                	add    %eax,%eax
  803b17:	01 d0                	add    %edx,%eax
  803b19:	c1 e0 03             	shl    $0x3,%eax
  803b1c:	01 c8                	add    %ecx,%eax
  803b1e:	8a 40 04             	mov    0x4(%eax),%al
  803b21:	84 c0                	test   %al,%al
  803b23:	75 46                	jne    803b6b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b25:	a1 20 50 80 00       	mov    0x805020,%eax
  803b2a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b33:	89 d0                	mov    %edx,%eax
  803b35:	01 c0                	add    %eax,%eax
  803b37:	01 d0                	add    %edx,%eax
  803b39:	c1 e0 03             	shl    $0x3,%eax
  803b3c:	01 c8                	add    %ecx,%eax
  803b3e:	8b 00                	mov    (%eax),%eax
  803b40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b4b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b50:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b57:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5a:	01 c8                	add    %ecx,%eax
  803b5c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b5e:	39 c2                	cmp    %eax,%edx
  803b60:	75 09                	jne    803b6b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b62:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b69:	eb 15                	jmp    803b80 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b6b:	ff 45 e8             	incl   -0x18(%ebp)
  803b6e:	a1 20 50 80 00       	mov    0x805020,%eax
  803b73:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7c:	39 c2                	cmp    %eax,%edx
  803b7e:	77 85                	ja     803b05 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b84:	75 14                	jne    803b9a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b86:	83 ec 04             	sub    $0x4,%esp
  803b89:	68 74 46 80 00       	push   $0x804674
  803b8e:	6a 3a                	push   $0x3a
  803b90:	68 68 46 80 00       	push   $0x804668
  803b95:	e8 8d fe ff ff       	call   803a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b9a:	ff 45 f0             	incl   -0x10(%ebp)
  803b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ba3:	0f 8c 2f ff ff ff    	jl     803ad8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ba9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803bb7:	eb 26                	jmp    803bdf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803bb9:	a1 20 50 80 00       	mov    0x805020,%eax
  803bbe:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803bc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bc7:	89 d0                	mov    %edx,%eax
  803bc9:	01 c0                	add    %eax,%eax
  803bcb:	01 d0                	add    %edx,%eax
  803bcd:	c1 e0 03             	shl    $0x3,%eax
  803bd0:	01 c8                	add    %ecx,%eax
  803bd2:	8a 40 04             	mov    0x4(%eax),%al
  803bd5:	3c 01                	cmp    $0x1,%al
  803bd7:	75 03                	jne    803bdc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bd9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bdc:	ff 45 e0             	incl   -0x20(%ebp)
  803bdf:	a1 20 50 80 00       	mov    0x805020,%eax
  803be4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bed:	39 c2                	cmp    %eax,%edx
  803bef:	77 c8                	ja     803bb9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bf7:	74 14                	je     803c0d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bf9:	83 ec 04             	sub    $0x4,%esp
  803bfc:	68 c8 46 80 00       	push   $0x8046c8
  803c01:	6a 44                	push   $0x44
  803c03:	68 68 46 80 00       	push   $0x804668
  803c08:	e8 1a fe ff ff       	call   803a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c0d:	90                   	nop
  803c0e:	c9                   	leave  
  803c0f:	c3                   	ret    

00803c10 <__udivdi3>:
  803c10:	55                   	push   %ebp
  803c11:	57                   	push   %edi
  803c12:	56                   	push   %esi
  803c13:	53                   	push   %ebx
  803c14:	83 ec 1c             	sub    $0x1c,%esp
  803c17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c27:	89 ca                	mov    %ecx,%edx
  803c29:	89 f8                	mov    %edi,%eax
  803c2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c2f:	85 f6                	test   %esi,%esi
  803c31:	75 2d                	jne    803c60 <__udivdi3+0x50>
  803c33:	39 cf                	cmp    %ecx,%edi
  803c35:	77 65                	ja     803c9c <__udivdi3+0x8c>
  803c37:	89 fd                	mov    %edi,%ebp
  803c39:	85 ff                	test   %edi,%edi
  803c3b:	75 0b                	jne    803c48 <__udivdi3+0x38>
  803c3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c42:	31 d2                	xor    %edx,%edx
  803c44:	f7 f7                	div    %edi
  803c46:	89 c5                	mov    %eax,%ebp
  803c48:	31 d2                	xor    %edx,%edx
  803c4a:	89 c8                	mov    %ecx,%eax
  803c4c:	f7 f5                	div    %ebp
  803c4e:	89 c1                	mov    %eax,%ecx
  803c50:	89 d8                	mov    %ebx,%eax
  803c52:	f7 f5                	div    %ebp
  803c54:	89 cf                	mov    %ecx,%edi
  803c56:	89 fa                	mov    %edi,%edx
  803c58:	83 c4 1c             	add    $0x1c,%esp
  803c5b:	5b                   	pop    %ebx
  803c5c:	5e                   	pop    %esi
  803c5d:	5f                   	pop    %edi
  803c5e:	5d                   	pop    %ebp
  803c5f:	c3                   	ret    
  803c60:	39 ce                	cmp    %ecx,%esi
  803c62:	77 28                	ja     803c8c <__udivdi3+0x7c>
  803c64:	0f bd fe             	bsr    %esi,%edi
  803c67:	83 f7 1f             	xor    $0x1f,%edi
  803c6a:	75 40                	jne    803cac <__udivdi3+0x9c>
  803c6c:	39 ce                	cmp    %ecx,%esi
  803c6e:	72 0a                	jb     803c7a <__udivdi3+0x6a>
  803c70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c74:	0f 87 9e 00 00 00    	ja     803d18 <__udivdi3+0x108>
  803c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c7f:	89 fa                	mov    %edi,%edx
  803c81:	83 c4 1c             	add    $0x1c,%esp
  803c84:	5b                   	pop    %ebx
  803c85:	5e                   	pop    %esi
  803c86:	5f                   	pop    %edi
  803c87:	5d                   	pop    %ebp
  803c88:	c3                   	ret    
  803c89:	8d 76 00             	lea    0x0(%esi),%esi
  803c8c:	31 ff                	xor    %edi,%edi
  803c8e:	31 c0                	xor    %eax,%eax
  803c90:	89 fa                	mov    %edi,%edx
  803c92:	83 c4 1c             	add    $0x1c,%esp
  803c95:	5b                   	pop    %ebx
  803c96:	5e                   	pop    %esi
  803c97:	5f                   	pop    %edi
  803c98:	5d                   	pop    %ebp
  803c99:	c3                   	ret    
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	89 d8                	mov    %ebx,%eax
  803c9e:	f7 f7                	div    %edi
  803ca0:	31 ff                	xor    %edi,%edi
  803ca2:	89 fa                	mov    %edi,%edx
  803ca4:	83 c4 1c             	add    $0x1c,%esp
  803ca7:	5b                   	pop    %ebx
  803ca8:	5e                   	pop    %esi
  803ca9:	5f                   	pop    %edi
  803caa:	5d                   	pop    %ebp
  803cab:	c3                   	ret    
  803cac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cb1:	89 eb                	mov    %ebp,%ebx
  803cb3:	29 fb                	sub    %edi,%ebx
  803cb5:	89 f9                	mov    %edi,%ecx
  803cb7:	d3 e6                	shl    %cl,%esi
  803cb9:	89 c5                	mov    %eax,%ebp
  803cbb:	88 d9                	mov    %bl,%cl
  803cbd:	d3 ed                	shr    %cl,%ebp
  803cbf:	89 e9                	mov    %ebp,%ecx
  803cc1:	09 f1                	or     %esi,%ecx
  803cc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cc7:	89 f9                	mov    %edi,%ecx
  803cc9:	d3 e0                	shl    %cl,%eax
  803ccb:	89 c5                	mov    %eax,%ebp
  803ccd:	89 d6                	mov    %edx,%esi
  803ccf:	88 d9                	mov    %bl,%cl
  803cd1:	d3 ee                	shr    %cl,%esi
  803cd3:	89 f9                	mov    %edi,%ecx
  803cd5:	d3 e2                	shl    %cl,%edx
  803cd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cdb:	88 d9                	mov    %bl,%cl
  803cdd:	d3 e8                	shr    %cl,%eax
  803cdf:	09 c2                	or     %eax,%edx
  803ce1:	89 d0                	mov    %edx,%eax
  803ce3:	89 f2                	mov    %esi,%edx
  803ce5:	f7 74 24 0c          	divl   0xc(%esp)
  803ce9:	89 d6                	mov    %edx,%esi
  803ceb:	89 c3                	mov    %eax,%ebx
  803ced:	f7 e5                	mul    %ebp
  803cef:	39 d6                	cmp    %edx,%esi
  803cf1:	72 19                	jb     803d0c <__udivdi3+0xfc>
  803cf3:	74 0b                	je     803d00 <__udivdi3+0xf0>
  803cf5:	89 d8                	mov    %ebx,%eax
  803cf7:	31 ff                	xor    %edi,%edi
  803cf9:	e9 58 ff ff ff       	jmp    803c56 <__udivdi3+0x46>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d04:	89 f9                	mov    %edi,%ecx
  803d06:	d3 e2                	shl    %cl,%edx
  803d08:	39 c2                	cmp    %eax,%edx
  803d0a:	73 e9                	jae    803cf5 <__udivdi3+0xe5>
  803d0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d0f:	31 ff                	xor    %edi,%edi
  803d11:	e9 40 ff ff ff       	jmp    803c56 <__udivdi3+0x46>
  803d16:	66 90                	xchg   %ax,%ax
  803d18:	31 c0                	xor    %eax,%eax
  803d1a:	e9 37 ff ff ff       	jmp    803c56 <__udivdi3+0x46>
  803d1f:	90                   	nop

00803d20 <__umoddi3>:
  803d20:	55                   	push   %ebp
  803d21:	57                   	push   %edi
  803d22:	56                   	push   %esi
  803d23:	53                   	push   %ebx
  803d24:	83 ec 1c             	sub    $0x1c,%esp
  803d27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d3f:	89 f3                	mov    %esi,%ebx
  803d41:	89 fa                	mov    %edi,%edx
  803d43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d47:	89 34 24             	mov    %esi,(%esp)
  803d4a:	85 c0                	test   %eax,%eax
  803d4c:	75 1a                	jne    803d68 <__umoddi3+0x48>
  803d4e:	39 f7                	cmp    %esi,%edi
  803d50:	0f 86 a2 00 00 00    	jbe    803df8 <__umoddi3+0xd8>
  803d56:	89 c8                	mov    %ecx,%eax
  803d58:	89 f2                	mov    %esi,%edx
  803d5a:	f7 f7                	div    %edi
  803d5c:	89 d0                	mov    %edx,%eax
  803d5e:	31 d2                	xor    %edx,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	39 f0                	cmp    %esi,%eax
  803d6a:	0f 87 ac 00 00 00    	ja     803e1c <__umoddi3+0xfc>
  803d70:	0f bd e8             	bsr    %eax,%ebp
  803d73:	83 f5 1f             	xor    $0x1f,%ebp
  803d76:	0f 84 ac 00 00 00    	je     803e28 <__umoddi3+0x108>
  803d7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d81:	29 ef                	sub    %ebp,%edi
  803d83:	89 fe                	mov    %edi,%esi
  803d85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d89:	89 e9                	mov    %ebp,%ecx
  803d8b:	d3 e0                	shl    %cl,%eax
  803d8d:	89 d7                	mov    %edx,%edi
  803d8f:	89 f1                	mov    %esi,%ecx
  803d91:	d3 ef                	shr    %cl,%edi
  803d93:	09 c7                	or     %eax,%edi
  803d95:	89 e9                	mov    %ebp,%ecx
  803d97:	d3 e2                	shl    %cl,%edx
  803d99:	89 14 24             	mov    %edx,(%esp)
  803d9c:	89 d8                	mov    %ebx,%eax
  803d9e:	d3 e0                	shl    %cl,%eax
  803da0:	89 c2                	mov    %eax,%edx
  803da2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803da6:	d3 e0                	shl    %cl,%eax
  803da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803db0:	89 f1                	mov    %esi,%ecx
  803db2:	d3 e8                	shr    %cl,%eax
  803db4:	09 d0                	or     %edx,%eax
  803db6:	d3 eb                	shr    %cl,%ebx
  803db8:	89 da                	mov    %ebx,%edx
  803dba:	f7 f7                	div    %edi
  803dbc:	89 d3                	mov    %edx,%ebx
  803dbe:	f7 24 24             	mull   (%esp)
  803dc1:	89 c6                	mov    %eax,%esi
  803dc3:	89 d1                	mov    %edx,%ecx
  803dc5:	39 d3                	cmp    %edx,%ebx
  803dc7:	0f 82 87 00 00 00    	jb     803e54 <__umoddi3+0x134>
  803dcd:	0f 84 91 00 00 00    	je     803e64 <__umoddi3+0x144>
  803dd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dd7:	29 f2                	sub    %esi,%edx
  803dd9:	19 cb                	sbb    %ecx,%ebx
  803ddb:	89 d8                	mov    %ebx,%eax
  803ddd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803de1:	d3 e0                	shl    %cl,%eax
  803de3:	89 e9                	mov    %ebp,%ecx
  803de5:	d3 ea                	shr    %cl,%edx
  803de7:	09 d0                	or     %edx,%eax
  803de9:	89 e9                	mov    %ebp,%ecx
  803deb:	d3 eb                	shr    %cl,%ebx
  803ded:	89 da                	mov    %ebx,%edx
  803def:	83 c4 1c             	add    $0x1c,%esp
  803df2:	5b                   	pop    %ebx
  803df3:	5e                   	pop    %esi
  803df4:	5f                   	pop    %edi
  803df5:	5d                   	pop    %ebp
  803df6:	c3                   	ret    
  803df7:	90                   	nop
  803df8:	89 fd                	mov    %edi,%ebp
  803dfa:	85 ff                	test   %edi,%edi
  803dfc:	75 0b                	jne    803e09 <__umoddi3+0xe9>
  803dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  803e03:	31 d2                	xor    %edx,%edx
  803e05:	f7 f7                	div    %edi
  803e07:	89 c5                	mov    %eax,%ebp
  803e09:	89 f0                	mov    %esi,%eax
  803e0b:	31 d2                	xor    %edx,%edx
  803e0d:	f7 f5                	div    %ebp
  803e0f:	89 c8                	mov    %ecx,%eax
  803e11:	f7 f5                	div    %ebp
  803e13:	89 d0                	mov    %edx,%eax
  803e15:	e9 44 ff ff ff       	jmp    803d5e <__umoddi3+0x3e>
  803e1a:	66 90                	xchg   %ax,%ax
  803e1c:	89 c8                	mov    %ecx,%eax
  803e1e:	89 f2                	mov    %esi,%edx
  803e20:	83 c4 1c             	add    $0x1c,%esp
  803e23:	5b                   	pop    %ebx
  803e24:	5e                   	pop    %esi
  803e25:	5f                   	pop    %edi
  803e26:	5d                   	pop    %ebp
  803e27:	c3                   	ret    
  803e28:	3b 04 24             	cmp    (%esp),%eax
  803e2b:	72 06                	jb     803e33 <__umoddi3+0x113>
  803e2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e31:	77 0f                	ja     803e42 <__umoddi3+0x122>
  803e33:	89 f2                	mov    %esi,%edx
  803e35:	29 f9                	sub    %edi,%ecx
  803e37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e3b:	89 14 24             	mov    %edx,(%esp)
  803e3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e46:	8b 14 24             	mov    (%esp),%edx
  803e49:	83 c4 1c             	add    $0x1c,%esp
  803e4c:	5b                   	pop    %ebx
  803e4d:	5e                   	pop    %esi
  803e4e:	5f                   	pop    %edi
  803e4f:	5d                   	pop    %ebp
  803e50:	c3                   	ret    
  803e51:	8d 76 00             	lea    0x0(%esi),%esi
  803e54:	2b 04 24             	sub    (%esp),%eax
  803e57:	19 fa                	sbb    %edi,%edx
  803e59:	89 d1                	mov    %edx,%ecx
  803e5b:	89 c6                	mov    %eax,%esi
  803e5d:	e9 71 ff ff ff       	jmp    803dd3 <__umoddi3+0xb3>
  803e62:	66 90                	xchg   %ax,%ax
  803e64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e68:	72 ea                	jb     803e54 <__umoddi3+0x134>
  803e6a:	89 d9                	mov    %ebx,%ecx
  803e6c:	e9 62 ff ff ff       	jmp    803dd3 <__umoddi3+0xb3>
