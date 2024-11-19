
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
  80003e:	e8 01 18 00 00       	call   801844 <sys_getparentenvid>
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
  800057:	68 c0 1f 80 00       	push   $0x801fc0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 3c 14 00 00       	call   8014a0 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 c4 1f 80 00       	push   $0x801fc4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 26 14 00 00       	call   8014a0 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 cc 1f 80 00       	push   $0x801fcc
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 09 14 00 00       	call   8014a0 <sget>
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
  8000ab:	68 da 1f 80 00       	push   $0x801fda
  8000b0:	e8 bc 13 00 00       	call   801471 <smalloc>
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
  80010c:	68 e9 1f 80 00       	push   $0x801fe9
  800111:	e8 68 05 00 00       	call   80067e <cprintf>
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
  8001a2:	68 05 20 80 00       	push   $0x802005
  8001a7:	e8 d2 04 00 00       	call   80067e <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 07 20 80 00       	push   $0x802007
  8001c9:	e8 b0 04 00 00       	call   80067e <cprintf>
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
  8001f2:	68 0c 20 80 00       	push   $0x80200c
  8001f7:	e8 82 04 00 00       	call   80067e <cprintf>
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
  800298:	e8 91 11 00 00       	call   80142e <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 7c 11 00 00       	call   80142e <malloc>
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
  80045a:	e8 f8 0f 00 00       	call   801457 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 ea 0f 00 00       	call   801457 <free>
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
  800479:	e8 ad 13 00 00       	call   80182b <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 02             	shl    $0x2,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	c1 e0 02             	shl    $0x2,%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	01 c0                	add    %eax,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004aa:	8a 40 20             	mov    0x20(%eax),%al
  8004ad:	84 c0                	test   %al,%al
  8004af:	74 0d                	je     8004be <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8004b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b6:	83 c0 20             	add    $0x20,%eax
  8004b9:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c2:	7e 0a                	jle    8004ce <libmain+0x5b>
		binaryname = argv[0];
  8004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	e8 5c fb ff ff       	call   800038 <_main>
  8004dc:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004df:	e8 cb 10 00 00       	call   8015af <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004e4:	83 ec 0c             	sub    $0xc,%esp
  8004e7:	68 28 20 80 00       	push   $0x802028
  8004ec:	e8 8d 01 00 00       	call   80067e <cprintf>
  8004f1:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8004f9:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8004ff:	a1 04 30 80 00       	mov    0x803004,%eax
  800504:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80050a:	83 ec 04             	sub    $0x4,%esp
  80050d:	52                   	push   %edx
  80050e:	50                   	push   %eax
  80050f:	68 50 20 80 00       	push   $0x802050
  800514:	e8 65 01 00 00       	call   80067e <cprintf>
  800519:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80051c:	a1 04 30 80 00       	mov    0x803004,%eax
  800521:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800527:	a1 04 30 80 00       	mov    0x803004,%eax
  80052c:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800532:	a1 04 30 80 00       	mov    0x803004,%eax
  800537:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80053d:	51                   	push   %ecx
  80053e:	52                   	push   %edx
  80053f:	50                   	push   %eax
  800540:	68 78 20 80 00       	push   $0x802078
  800545:	e8 34 01 00 00       	call   80067e <cprintf>
  80054a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80054d:	a1 04 30 80 00       	mov    0x803004,%eax
  800552:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	50                   	push   %eax
  80055c:	68 d0 20 80 00       	push   $0x8020d0
  800561:	e8 18 01 00 00       	call   80067e <cprintf>
  800566:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800569:	83 ec 0c             	sub    $0xc,%esp
  80056c:	68 28 20 80 00       	push   $0x802028
  800571:	e8 08 01 00 00       	call   80067e <cprintf>
  800576:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800579:	e8 4b 10 00 00       	call   8015c9 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80057e:	e8 19 00 00 00       	call   80059c <exit>
}
  800583:	90                   	nop
  800584:	c9                   	leave  
  800585:	c3                   	ret    

00800586 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	6a 00                	push   $0x0
  800591:	e8 61 12 00 00       	call   8017f7 <sys_destroy_env>
  800596:	83 c4 10             	add    $0x10,%esp
}
  800599:	90                   	nop
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <exit>:

void
exit(void)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a2:	e8 b6 12 00 00       	call   80185d <sys_exit_env>
}
  8005a7:	90                   	nop
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8005b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005bb:	89 0a                	mov    %ecx,(%edx)
  8005bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c0:	88 d1                	mov    %dl,%cl
  8005c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d3:	75 2c                	jne    800601 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005d5:	a0 08 30 80 00       	mov    0x803008,%al
  8005da:	0f b6 c0             	movzbl %al,%eax
  8005dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e0:	8b 12                	mov    (%edx),%edx
  8005e2:	89 d1                	mov    %edx,%ecx
  8005e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e7:	83 c2 08             	add    $0x8,%edx
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	50                   	push   %eax
  8005ee:	51                   	push   %ecx
  8005ef:	52                   	push   %edx
  8005f0:	e8 78 0f 00 00       	call   80156d <sys_cputs>
  8005f5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800601:	8b 45 0c             	mov    0xc(%ebp),%eax
  800604:	8b 40 04             	mov    0x4(%eax),%eax
  800607:	8d 50 01             	lea    0x1(%eax),%edx
  80060a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800610:	90                   	nop
  800611:	c9                   	leave  
  800612:	c3                   	ret    

00800613 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800613:	55                   	push   %ebp
  800614:	89 e5                	mov    %esp,%ebp
  800616:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80061c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800623:	00 00 00 
	b.cnt = 0;
  800626:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80062d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800630:	ff 75 0c             	pushl  0xc(%ebp)
  800633:	ff 75 08             	pushl  0x8(%ebp)
  800636:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063c:	50                   	push   %eax
  80063d:	68 aa 05 80 00       	push   $0x8005aa
  800642:	e8 11 02 00 00       	call   800858 <vprintfmt>
  800647:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064a:	a0 08 30 80 00       	mov    0x803008,%al
  80064f:	0f b6 c0             	movzbl %al,%eax
  800652:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	50                   	push   %eax
  80065c:	52                   	push   %edx
  80065d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800663:	83 c0 08             	add    $0x8,%eax
  800666:	50                   	push   %eax
  800667:	e8 01 0f 00 00       	call   80156d <sys_cputs>
  80066c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80066f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800676:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800684:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80068b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	ff 75 f4             	pushl  -0xc(%ebp)
  80069a:	50                   	push   %eax
  80069b:	e8 73 ff ff ff       	call   800613 <vcprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006b1:	e8 f9 0e 00 00       	call   8015af <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c5:	50                   	push   %eax
  8006c6:	e8 48 ff ff ff       	call   800613 <vcprintf>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006d1:	e8 f3 0e 00 00       	call   8015c9 <sys_unlock_cons>
	return cnt;
  8006d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	53                   	push   %ebx
  8006df:	83 ec 14             	sub    $0x14,%esp
  8006e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006f9:	77 55                	ja     800750 <printnum+0x75>
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	72 05                	jb     800705 <printnum+0x2a>
  800700:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800703:	77 4b                	ja     800750 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800705:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800708:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80070b:	8b 45 18             	mov    0x18(%ebp),%eax
  80070e:	ba 00 00 00 00       	mov    $0x0,%edx
  800713:	52                   	push   %edx
  800714:	50                   	push   %eax
  800715:	ff 75 f4             	pushl  -0xc(%ebp)
  800718:	ff 75 f0             	pushl  -0x10(%ebp)
  80071b:	e8 34 16 00 00       	call   801d54 <__udivdi3>
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	83 ec 04             	sub    $0x4,%esp
  800726:	ff 75 20             	pushl  0x20(%ebp)
  800729:	53                   	push   %ebx
  80072a:	ff 75 18             	pushl  0x18(%ebp)
  80072d:	52                   	push   %edx
  80072e:	50                   	push   %eax
  80072f:	ff 75 0c             	pushl  0xc(%ebp)
  800732:	ff 75 08             	pushl  0x8(%ebp)
  800735:	e8 a1 ff ff ff       	call   8006db <printnum>
  80073a:	83 c4 20             	add    $0x20,%esp
  80073d:	eb 1a                	jmp    800759 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 0c             	pushl  0xc(%ebp)
  800745:	ff 75 20             	pushl  0x20(%ebp)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800750:	ff 4d 1c             	decl   0x1c(%ebp)
  800753:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800757:	7f e6                	jg     80073f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800759:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80075c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800767:	53                   	push   %ebx
  800768:	51                   	push   %ecx
  800769:	52                   	push   %edx
  80076a:	50                   	push   %eax
  80076b:	e8 f4 16 00 00       	call   801e64 <__umoddi3>
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	05 14 23 80 00       	add    $0x802314,%eax
  800778:	8a 00                	mov    (%eax),%al
  80077a:	0f be c0             	movsbl %al,%eax
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	50                   	push   %eax
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	ff d0                	call   *%eax
  800789:	83 c4 10             	add    $0x10,%esp
}
  80078c:	90                   	nop
  80078d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800795:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800799:	7e 1c                	jle    8007b7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	8d 50 08             	lea    0x8(%eax),%edx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	89 10                	mov    %edx,(%eax)
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	83 e8 08             	sub    $0x8,%eax
  8007b0:	8b 50 04             	mov    0x4(%eax),%edx
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	eb 40                	jmp    8007f7 <getuint+0x65>
	else if (lflag)
  8007b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007bb:	74 1e                	je     8007db <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	89 10                	mov    %edx,(%eax)
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	83 e8 04             	sub    $0x4,%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d9:	eb 1c                	jmp    8007f7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 04             	sub    $0x4,%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800800:	7e 1c                	jle    80081e <getint+0x25>
		return va_arg(*ap, long long);
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	8d 50 08             	lea    0x8(%eax),%edx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	89 10                	mov    %edx,(%eax)
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	83 e8 08             	sub    $0x8,%eax
  800817:	8b 50 04             	mov    0x4(%eax),%edx
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	eb 38                	jmp    800856 <getint+0x5d>
	else if (lflag)
  80081e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800822:	74 1a                	je     80083e <getint+0x45>
		return va_arg(*ap, long);
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	8d 50 04             	lea    0x4(%eax),%edx
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	89 10                	mov    %edx,(%eax)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	83 e8 04             	sub    $0x4,%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	99                   	cltd   
  80083c:	eb 18                	jmp    800856 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	8d 50 04             	lea    0x4(%eax),%edx
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	89 10                	mov    %edx,(%eax)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	83 e8 04             	sub    $0x4,%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	99                   	cltd   
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	56                   	push   %esi
  80085c:	53                   	push   %ebx
  80085d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800860:	eb 17                	jmp    800879 <vprintfmt+0x21>
			if (ch == '\0')
  800862:	85 db                	test   %ebx,%ebx
  800864:	0f 84 c1 03 00 00    	je     800c2b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	53                   	push   %ebx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800879:	8b 45 10             	mov    0x10(%ebp),%eax
  80087c:	8d 50 01             	lea    0x1(%eax),%edx
  80087f:	89 55 10             	mov    %edx,0x10(%ebp)
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f b6 d8             	movzbl %al,%ebx
  800887:	83 fb 25             	cmp    $0x25,%ebx
  80088a:	75 d6                	jne    800862 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80088c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800890:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800897:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80089e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8008af:	8d 50 01             	lea    0x1(%eax),%edx
  8008b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b5:	8a 00                	mov    (%eax),%al
  8008b7:	0f b6 d8             	movzbl %al,%ebx
  8008ba:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008bd:	83 f8 5b             	cmp    $0x5b,%eax
  8008c0:	0f 87 3d 03 00 00    	ja     800c03 <vprintfmt+0x3ab>
  8008c6:	8b 04 85 38 23 80 00 	mov    0x802338(,%eax,4),%eax
  8008cd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008cf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d3:	eb d7                	jmp    8008ac <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008d9:	eb d1                	jmp    8008ac <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e5:	89 d0                	mov    %edx,%eax
  8008e7:	c1 e0 02             	shl    $0x2,%eax
  8008ea:	01 d0                	add    %edx,%eax
  8008ec:	01 c0                	add    %eax,%eax
  8008ee:	01 d8                	add    %ebx,%eax
  8008f0:	83 e8 30             	sub    $0x30,%eax
  8008f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f9:	8a 00                	mov    (%eax),%al
  8008fb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008fe:	83 fb 2f             	cmp    $0x2f,%ebx
  800901:	7e 3e                	jle    800941 <vprintfmt+0xe9>
  800903:	83 fb 39             	cmp    $0x39,%ebx
  800906:	7f 39                	jg     800941 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800908:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80090b:	eb d5                	jmp    8008e2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	83 e8 04             	sub    $0x4,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800921:	eb 1f                	jmp    800942 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800923:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800927:	79 83                	jns    8008ac <vprintfmt+0x54>
				width = 0;
  800929:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800930:	e9 77 ff ff ff       	jmp    8008ac <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800935:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80093c:	e9 6b ff ff ff       	jmp    8008ac <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800941:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800942:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800946:	0f 89 60 ff ff ff    	jns    8008ac <vprintfmt+0x54>
				width = precision, precision = -1;
  80094c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800952:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800959:	e9 4e ff ff ff       	jmp    8008ac <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80095e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800961:	e9 46 ff ff ff       	jmp    8008ac <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	83 e8 04             	sub    $0x4,%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	50                   	push   %eax
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	ff d0                	call   *%eax
  800983:	83 c4 10             	add    $0x10,%esp
			break;
  800986:	e9 9b 02 00 00       	jmp    800c26 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 c0 04             	add    $0x4,%eax
  800991:	89 45 14             	mov    %eax,0x14(%ebp)
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80099c:	85 db                	test   %ebx,%ebx
  80099e:	79 02                	jns    8009a2 <vprintfmt+0x14a>
				err = -err;
  8009a0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a2:	83 fb 64             	cmp    $0x64,%ebx
  8009a5:	7f 0b                	jg     8009b2 <vprintfmt+0x15a>
  8009a7:	8b 34 9d 80 21 80 00 	mov    0x802180(,%ebx,4),%esi
  8009ae:	85 f6                	test   %esi,%esi
  8009b0:	75 19                	jne    8009cb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b2:	53                   	push   %ebx
  8009b3:	68 25 23 80 00       	push   $0x802325
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	ff 75 08             	pushl  0x8(%ebp)
  8009be:	e8 70 02 00 00       	call   800c33 <printfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c6:	e9 5b 02 00 00       	jmp    800c26 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009cb:	56                   	push   %esi
  8009cc:	68 2e 23 80 00       	push   $0x80232e
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	ff 75 08             	pushl  0x8(%ebp)
  8009d7:	e8 57 02 00 00       	call   800c33 <printfmt>
  8009dc:	83 c4 10             	add    $0x10,%esp
			break;
  8009df:	e9 42 02 00 00       	jmp    800c26 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	83 c0 04             	add    $0x4,%eax
  8009ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	83 e8 04             	sub    $0x4,%eax
  8009f3:	8b 30                	mov    (%eax),%esi
  8009f5:	85 f6                	test   %esi,%esi
  8009f7:	75 05                	jne    8009fe <vprintfmt+0x1a6>
				p = "(null)";
  8009f9:	be 31 23 80 00       	mov    $0x802331,%esi
			if (width > 0 && padc != '-')
  8009fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a02:	7e 6d                	jle    800a71 <vprintfmt+0x219>
  800a04:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a08:	74 67                	je     800a71 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	50                   	push   %eax
  800a11:	56                   	push   %esi
  800a12:	e8 1e 03 00 00       	call   800d35 <strnlen>
  800a17:	83 c4 10             	add    $0x10,%esp
  800a1a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a1d:	eb 16                	jmp    800a35 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a1f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	ff d0                	call   *%eax
  800a2f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a32:	ff 4d e4             	decl   -0x1c(%ebp)
  800a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a39:	7f e4                	jg     800a1f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3b:	eb 34                	jmp    800a71 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a41:	74 1c                	je     800a5f <vprintfmt+0x207>
  800a43:	83 fb 1f             	cmp    $0x1f,%ebx
  800a46:	7e 05                	jle    800a4d <vprintfmt+0x1f5>
  800a48:	83 fb 7e             	cmp    $0x7e,%ebx
  800a4b:	7e 12                	jle    800a5f <vprintfmt+0x207>
					putch('?', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 3f                	push   $0x3f
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	eb 0f                	jmp    800a6e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	53                   	push   %ebx
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a71:	89 f0                	mov    %esi,%eax
  800a73:	8d 70 01             	lea    0x1(%eax),%esi
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	0f be d8             	movsbl %al,%ebx
  800a7b:	85 db                	test   %ebx,%ebx
  800a7d:	74 24                	je     800aa3 <vprintfmt+0x24b>
  800a7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a83:	78 b8                	js     800a3d <vprintfmt+0x1e5>
  800a85:	ff 4d e0             	decl   -0x20(%ebp)
  800a88:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a8c:	79 af                	jns    800a3d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a8e:	eb 13                	jmp    800aa3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	6a 20                	push   $0x20
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	7f e7                	jg     800a90 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aa9:	e9 78 01 00 00       	jmp    800c26 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab7:	50                   	push   %eax
  800ab8:	e8 3c fd ff ff       	call   8007f9 <getint>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800acc:	85 d2                	test   %edx,%edx
  800ace:	79 23                	jns    800af3 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 2d                	push   $0x2d
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae6:	f7 d8                	neg    %eax
  800ae8:	83 d2 00             	adc    $0x0,%edx
  800aeb:	f7 da                	neg    %edx
  800aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800afa:	e9 bc 00 00 00       	jmp    800bbb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 e8             	pushl  -0x18(%ebp)
  800b05:	8d 45 14             	lea    0x14(%ebp),%eax
  800b08:	50                   	push   %eax
  800b09:	e8 84 fc ff ff       	call   800792 <getuint>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b17:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b1e:	e9 98 00 00 00       	jmp    800bbb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	6a 58                	push   $0x58
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	ff d0                	call   *%eax
  800b30:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	6a 58                	push   $0x58
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	ff d0                	call   *%eax
  800b40:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	6a 58                	push   $0x58
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
			break;
  800b53:	e9 ce 00 00 00       	jmp    800c26 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 30                	push   $0x30
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	6a 78                	push   $0x78
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b78:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7b:	83 c0 04             	add    $0x4,%eax
  800b7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b81:	8b 45 14             	mov    0x14(%ebp),%eax
  800b84:	83 e8 04             	sub    $0x4,%eax
  800b87:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b93:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9a:	eb 1f                	jmp    800bbb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba5:	50                   	push   %eax
  800ba6:	e8 e7 fb ff ff       	call   800792 <getuint>
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bbb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	52                   	push   %edx
  800bc6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bc9:	50                   	push   %eax
  800bca:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcd:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	ff 75 08             	pushl  0x8(%ebp)
  800bd6:	e8 00 fb ff ff       	call   8006db <printnum>
  800bdb:	83 c4 20             	add    $0x20,%esp
			break;
  800bde:	eb 46                	jmp    800c26 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 0c             	pushl  0xc(%ebp)
  800be6:	53                   	push   %ebx
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
  800bec:	83 c4 10             	add    $0x10,%esp
			break;
  800bef:	eb 35                	jmp    800c26 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bf1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800bf8:	eb 2c                	jmp    800c26 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bfa:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c01:	eb 23                	jmp    800c26 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 25                	push   $0x25
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c13:	ff 4d 10             	decl   0x10(%ebp)
  800c16:	eb 03                	jmp    800c1b <vprintfmt+0x3c3>
  800c18:	ff 4d 10             	decl   0x10(%ebp)
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	48                   	dec    %eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	3c 25                	cmp    $0x25,%al
  800c23:	75 f3                	jne    800c18 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c25:	90                   	nop
		}
	}
  800c26:	e9 35 fc ff ff       	jmp    800860 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c2b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c39:	8d 45 10             	lea    0x10(%ebp),%eax
  800c3c:	83 c0 04             	add    $0x4,%eax
  800c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c42:	8b 45 10             	mov    0x10(%ebp),%eax
  800c45:	ff 75 f4             	pushl  -0xc(%ebp)
  800c48:	50                   	push   %eax
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	ff 75 08             	pushl  0x8(%ebp)
  800c4f:	e8 04 fc ff ff       	call   800858 <vprintfmt>
  800c54:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c57:	90                   	nop
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8b 40 08             	mov    0x8(%eax),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	8b 10                	mov    (%eax),%edx
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	8b 40 04             	mov    0x4(%eax),%eax
  800c77:	39 c2                	cmp    %eax,%edx
  800c79:	73 12                	jae    800c8d <sprintputch+0x33>
		*b->buf++ = ch;
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	8d 48 01             	lea    0x1(%eax),%ecx
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	89 0a                	mov    %ecx,(%edx)
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	88 10                	mov    %dl,(%eax)
}
  800c8d:	90                   	nop
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	01 d0                	add    %edx,%eax
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cb5:	74 06                	je     800cbd <vsnprintf+0x2d>
  800cb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbb:	7f 07                	jg     800cc4 <vsnprintf+0x34>
		return -E_INVAL;
  800cbd:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc2:	eb 20                	jmp    800ce4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cc4:	ff 75 14             	pushl  0x14(%ebp)
  800cc7:	ff 75 10             	pushl  0x10(%ebp)
  800cca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	68 5a 0c 80 00       	push   $0x800c5a
  800cd3:	e8 80 fb ff ff       	call   800858 <vprintfmt>
  800cd8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cde:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cec:	8d 45 10             	lea    0x10(%ebp),%eax
  800cef:	83 c0 04             	add    $0x4,%eax
  800cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	ff 75 08             	pushl  0x8(%ebp)
  800d02:	e8 89 ff ff ff       	call   800c90 <vsnprintf>
  800d07:	83 c4 10             	add    $0x10,%esp
  800d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1f:	eb 06                	jmp    800d27 <strlen+0x15>
		n++;
  800d21:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d24:	ff 45 08             	incl   0x8(%ebp)
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	84 c0                	test   %al,%al
  800d2e:	75 f1                	jne    800d21 <strlen+0xf>
		n++;
	return n;
  800d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d33:	c9                   	leave  
  800d34:	c3                   	ret    

00800d35 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d42:	eb 09                	jmp    800d4d <strnlen+0x18>
		n++;
  800d44:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d47:	ff 45 08             	incl   0x8(%ebp)
  800d4a:	ff 4d 0c             	decl   0xc(%ebp)
  800d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d51:	74 09                	je     800d5c <strnlen+0x27>
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 e8                	jne    800d44 <strnlen+0xf>
		n++;
	return n;
  800d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d6d:	90                   	nop
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8d 50 01             	lea    0x1(%eax),%edx
  800d74:	89 55 08             	mov    %edx,0x8(%ebp)
  800d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d80:	8a 12                	mov    (%edx),%dl
  800d82:	88 10                	mov    %dl,(%eax)
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	75 e4                	jne    800d6e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da2:	eb 1f                	jmp    800dc3 <strncpy+0x34>
		*dst++ = *src;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 08             	mov    %edx,0x8(%ebp)
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	8a 12                	mov    (%edx),%dl
  800db2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 03                	je     800dc0 <strncpy+0x31>
			src++;
  800dbd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dc0:	ff 45 fc             	incl   -0x4(%ebp)
  800dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc9:	72 d9                	jb     800da4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ddc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de0:	74 30                	je     800e12 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800de2:	eb 16                	jmp    800dfa <strlcpy+0x2a>
			*dst++ = *src++;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8d 50 01             	lea    0x1(%eax),%edx
  800dea:	89 55 08             	mov    %edx,0x8(%ebp)
  800ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800df6:	8a 12                	mov    (%edx),%dl
  800df8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dfa:	ff 4d 10             	decl   0x10(%ebp)
  800dfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e01:	74 09                	je     800e0c <strlcpy+0x3c>
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	84 c0                	test   %al,%al
  800e0a:	75 d8                	jne    800de4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e18:	29 c2                	sub    %eax,%edx
  800e1a:	89 d0                	mov    %edx,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e21:	eb 06                	jmp    800e29 <strcmp+0xb>
		p++, q++;
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	84 c0                	test   %al,%al
  800e30:	74 0e                	je     800e40 <strcmp+0x22>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 10                	mov    (%eax),%dl
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	38 c2                	cmp    %al,%dl
  800e3e:	74 e3                	je     800e23 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	0f b6 d0             	movzbl %al,%edx
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 c0             	movzbl %al,%eax
  800e50:	29 c2                	sub    %eax,%edx
  800e52:	89 d0                	mov    %edx,%eax
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e59:	eb 09                	jmp    800e64 <strncmp+0xe>
		n--, p++, q++;
  800e5b:	ff 4d 10             	decl   0x10(%ebp)
  800e5e:	ff 45 08             	incl   0x8(%ebp)
  800e61:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e68:	74 17                	je     800e81 <strncmp+0x2b>
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 0e                	je     800e81 <strncmp+0x2b>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 10                	mov    (%eax),%dl
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	38 c2                	cmp    %al,%dl
  800e7f:	74 da                	je     800e5b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e85:	75 07                	jne    800e8e <strncmp+0x38>
		return 0;
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	eb 14                	jmp    800ea2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	0f b6 d0             	movzbl %al,%edx
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	0f b6 c0             	movzbl %al,%eax
  800e9e:	29 c2                	sub    %eax,%edx
  800ea0:	89 d0                	mov    %edx,%eax
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb0:	eb 12                	jmp    800ec4 <strchr+0x20>
		if (*s == c)
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eba:	75 05                	jne    800ec1 <strchr+0x1d>
			return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	eb 11                	jmp    800ed2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	84 c0                	test   %al,%al
  800ecb:	75 e5                	jne    800eb2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 04             	sub    $0x4,%esp
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee0:	eb 0d                	jmp    800eef <strfind+0x1b>
		if (*s == c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eea:	74 0e                	je     800efa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eec:	ff 45 08             	incl   0x8(%ebp)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 ea                	jne    800ee2 <strfind+0xe>
  800ef8:	eb 01                	jmp    800efb <strfind+0x27>
		if (*s == c)
			break;
  800efa:	90                   	nop
	return (char *) s;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f12:	eb 0e                	jmp    800f22 <memset+0x22>
		*p++ = c;
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f20:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f22:	ff 4d f8             	decl   -0x8(%ebp)
  800f25:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f29:	79 e9                	jns    800f14 <memset+0x14>
		*p++ = c;

	return v;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f42:	eb 16                	jmp    800f5a <memcpy+0x2a>
		*d++ = *s++;
  800f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f53:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f56:	8a 12                	mov    (%edx),%dl
  800f58:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f60:	89 55 10             	mov    %edx,0x10(%ebp)
  800f63:	85 c0                	test   %eax,%eax
  800f65:	75 dd                	jne    800f44 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    

00800f6c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	73 50                	jae    800fd6 <memmove+0x6a>
  800f86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	01 d0                	add    %edx,%eax
  800f8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f91:	76 43                	jbe    800fd6 <memmove+0x6a>
		s += n;
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9f:	eb 10                	jmp    800fb1 <memmove+0x45>
			*--d = *--s;
  800fa1:	ff 4d f8             	decl   -0x8(%ebp)
  800fa4:	ff 4d fc             	decl   -0x4(%ebp)
  800fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faa:	8a 10                	mov    (%eax),%dl
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	75 e3                	jne    800fa1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fbe:	eb 23                	jmp    800fe3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd2:	8a 12                	mov    (%edx),%dl
  800fd4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	75 dd                	jne    800fc0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ffa:	eb 2a                	jmp    801026 <memcmp+0x3e>
		if (*s1 != *s2)
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8a 10                	mov    (%eax),%dl
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	38 c2                	cmp    %al,%dl
  801008:	74 16                	je     801020 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	0f b6 d0             	movzbl %al,%edx
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	0f b6 c0             	movzbl %al,%eax
  80101a:	29 c2                	sub    %eax,%edx
  80101c:	89 d0                	mov    %edx,%eax
  80101e:	eb 18                	jmp    801038 <memcmp+0x50>
		s1++, s2++;
  801020:	ff 45 fc             	incl   -0x4(%ebp)
  801023:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102c:	89 55 10             	mov    %edx,0x10(%ebp)
  80102f:	85 c0                	test   %eax,%eax
  801031:	75 c9                	jne    800ffc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80104b:	eb 15                	jmp    801062 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	0f b6 d0             	movzbl %al,%edx
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	0f b6 c0             	movzbl %al,%eax
  80105b:	39 c2                	cmp    %eax,%edx
  80105d:	74 0d                	je     80106c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801068:	72 e3                	jb     80104d <memfind+0x13>
  80106a:	eb 01                	jmp    80106d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80106c:	90                   	nop
	return (void *) s;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80107f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801086:	eb 03                	jmp    80108b <strtol+0x19>
		s++;
  801088:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 20                	cmp    $0x20,%al
  801092:	74 f4                	je     801088 <strtol+0x16>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	3c 09                	cmp    $0x9,%al
  80109b:	74 eb                	je     801088 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	3c 2b                	cmp    $0x2b,%al
  8010a4:	75 05                	jne    8010ab <strtol+0x39>
		s++;
  8010a6:	ff 45 08             	incl   0x8(%ebp)
  8010a9:	eb 13                	jmp    8010be <strtol+0x4c>
	else if (*s == '-')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 2d                	cmp    $0x2d,%al
  8010b2:	75 0a                	jne    8010be <strtol+0x4c>
		s++, neg = 1;
  8010b4:	ff 45 08             	incl   0x8(%ebp)
  8010b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c2:	74 06                	je     8010ca <strtol+0x58>
  8010c4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c8:	75 20                	jne    8010ea <strtol+0x78>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 30                	cmp    $0x30,%al
  8010d1:	75 17                	jne    8010ea <strtol+0x78>
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	40                   	inc    %eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	3c 78                	cmp    $0x78,%al
  8010db:	75 0d                	jne    8010ea <strtol+0x78>
		s += 2, base = 16;
  8010dd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e8:	eb 28                	jmp    801112 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	75 15                	jne    801105 <strtol+0x93>
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	3c 30                	cmp    $0x30,%al
  8010f7:	75 0c                	jne    801105 <strtol+0x93>
		s++, base = 8;
  8010f9:	ff 45 08             	incl   0x8(%ebp)
  8010fc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801103:	eb 0d                	jmp    801112 <strtol+0xa0>
	else if (base == 0)
  801105:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801109:	75 07                	jne    801112 <strtol+0xa0>
		base = 10;
  80110b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	3c 2f                	cmp    $0x2f,%al
  801119:	7e 19                	jle    801134 <strtol+0xc2>
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	3c 39                	cmp    $0x39,%al
  801122:	7f 10                	jg     801134 <strtol+0xc2>
			dig = *s - '0';
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	0f be c0             	movsbl %al,%eax
  80112c:	83 e8 30             	sub    $0x30,%eax
  80112f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801132:	eb 42                	jmp    801176 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	3c 60                	cmp    $0x60,%al
  80113b:	7e 19                	jle    801156 <strtol+0xe4>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	3c 7a                	cmp    $0x7a,%al
  801144:	7f 10                	jg     801156 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	0f be c0             	movsbl %al,%eax
  80114e:	83 e8 57             	sub    $0x57,%eax
  801151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801154:	eb 20                	jmp    801176 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 40                	cmp    $0x40,%al
  80115d:	7e 39                	jle    801198 <strtol+0x126>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 5a                	cmp    $0x5a,%al
  801166:	7f 30                	jg     801198 <strtol+0x126>
			dig = *s - 'A' + 10;
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f be c0             	movsbl %al,%eax
  801170:	83 e8 37             	sub    $0x37,%eax
  801173:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801179:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117c:	7d 19                	jge    801197 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80117e:	ff 45 08             	incl   0x8(%ebp)
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	0f af 45 10          	imul   0x10(%ebp),%eax
  801188:	89 c2                	mov    %eax,%edx
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	01 d0                	add    %edx,%eax
  80118f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801192:	e9 7b ff ff ff       	jmp    801112 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801197:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801198:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119c:	74 08                	je     8011a6 <strtol+0x134>
		*endptr = (char *) s;
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011aa:	74 07                	je     8011b3 <strtol+0x141>
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011af:	f7 d8                	neg    %eax
  8011b1:	eb 03                	jmp    8011b6 <strtol+0x144>
  8011b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d0:	79 13                	jns    8011e5 <ltostr+0x2d>
	{
		neg = 1;
  8011d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011df:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ed:	99                   	cltd   
  8011ee:	f7 f9                	idiv   %ecx
  8011f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fc:	89 c2                	mov    %eax,%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801206:	83 c2 30             	add    $0x30,%edx
  801209:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80120b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801213:	f7 e9                	imul   %ecx
  801215:	c1 fa 02             	sar    $0x2,%edx
  801218:	89 c8                	mov    %ecx,%eax
  80121a:	c1 f8 1f             	sar    $0x1f,%eax
  80121d:	29 c2                	sub    %eax,%edx
  80121f:	89 d0                	mov    %edx,%eax
  801221:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801224:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801228:	75 bb                	jne    8011e5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80122a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801231:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801234:	48                   	dec    %eax
  801235:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801238:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123c:	74 3d                	je     80127b <ltostr+0xc3>
		start = 1 ;
  80123e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801245:	eb 34                	jmp    80127b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	01 c2                	add    %eax,%edx
  80125c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 c8                	add    %ecx,%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801268:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	01 c2                	add    %eax,%edx
  801270:	8a 45 eb             	mov    -0x15(%ebp),%al
  801273:	88 02                	mov    %al,(%edx)
		start++ ;
  801275:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801278:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80127b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801281:	7c c4                	jl     801247 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801283:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 d0                	add    %edx,%eax
  80128b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80128e:	90                   	nop
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 73 fa ff ff       	call   800d12 <strlen>
  80129f:	83 c4 04             	add    $0x4,%esp
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a5:	ff 75 0c             	pushl  0xc(%ebp)
  8012a8:	e8 65 fa ff ff       	call   800d12 <strlen>
  8012ad:	83 c4 04             	add    $0x4,%esp
  8012b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c1:	eb 17                	jmp    8012da <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c9:	01 c2                	add    %eax,%edx
  8012cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	01 c8                	add    %ecx,%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012e0:	7c e1                	jl     8012c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012f0:	eb 1f                	jmp    801311 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f5:	8d 50 01             	lea    0x1(%eax),%edx
  8012f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fb:	89 c2                	mov    %eax,%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80130e:	ff 45 f8             	incl   -0x8(%ebp)
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801317:	7c d9                	jl     8012f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
  80131f:	01 d0                	add    %edx,%eax
  801321:	c6 00 00             	movb   $0x0,(%eax)
}
  801324:	90                   	nop
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80132a:	8b 45 14             	mov    0x14(%ebp),%eax
  80132d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133f:	8b 45 10             	mov    0x10(%ebp),%eax
  801342:	01 d0                	add    %edx,%eax
  801344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80134a:	eb 0c                	jmp    801358 <strsplit+0x31>
			*string++ = 0;
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8d 50 01             	lea    0x1(%eax),%edx
  801352:	89 55 08             	mov    %edx,0x8(%ebp)
  801355:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	84 c0                	test   %al,%al
  80135f:	74 18                	je     801379 <strsplit+0x52>
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	0f be c0             	movsbl %al,%eax
  801369:	50                   	push   %eax
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	e8 32 fb ff ff       	call   800ea4 <strchr>
  801372:	83 c4 08             	add    $0x8,%esp
  801375:	85 c0                	test   %eax,%eax
  801377:	75 d3                	jne    80134c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 5a                	je     8013dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801382:	8b 45 14             	mov    0x14(%ebp),%eax
  801385:	8b 00                	mov    (%eax),%eax
  801387:	83 f8 0f             	cmp    $0xf,%eax
  80138a:	75 07                	jne    801393 <strsplit+0x6c>
		{
			return 0;
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
  801391:	eb 66                	jmp    8013f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801393:	8b 45 14             	mov    0x14(%ebp),%eax
  801396:	8b 00                	mov    (%eax),%eax
  801398:	8d 48 01             	lea    0x1(%eax),%ecx
  80139b:	8b 55 14             	mov    0x14(%ebp),%edx
  80139e:	89 0a                	mov    %ecx,(%edx)
  8013a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013aa:	01 c2                	add    %eax,%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b1:	eb 03                	jmp    8013b6 <strsplit+0x8f>
			string++;
  8013b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	84 c0                	test   %al,%al
  8013bd:	74 8b                	je     80134a <strsplit+0x23>
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	0f be c0             	movsbl %al,%eax
  8013c7:	50                   	push   %eax
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	e8 d4 fa ff ff       	call   800ea4 <strchr>
  8013d0:	83 c4 08             	add    $0x8,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	74 dc                	je     8013b3 <strsplit+0x8c>
			string++;
	}
  8013d7:	e9 6e ff ff ff       	jmp    80134a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e0:	8b 00                	mov    (%eax),%eax
  8013e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ec:	01 d0                	add    %edx,%eax
  8013ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801401:	83 ec 04             	sub    $0x4,%esp
  801404:	68 a8 24 80 00       	push   $0x8024a8
  801409:	68 3f 01 00 00       	push   $0x13f
  80140e:	68 ca 24 80 00       	push   $0x8024ca
  801413:	e8 53 07 00 00       	call   801b6b <_panic>

00801418 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	ff 75 08             	pushl  0x8(%ebp)
  801424:	e8 ef 06 00 00       	call   801b18 <sys_sbrk>
  801429:	83 c4 10             	add    $0x10,%esp
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801434:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801438:	75 07                	jne    801441 <malloc+0x13>
  80143a:	b8 00 00 00 00       	mov    $0x0,%eax
  80143f:	eb 14                	jmp    801455 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	68 d8 24 80 00       	push   $0x8024d8
  801449:	6a 1b                	push   $0x1b
  80144b:	68 fd 24 80 00       	push   $0x8024fd
  801450:	e8 16 07 00 00       	call   801b6b <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	68 0c 25 80 00       	push   $0x80250c
  801465:	6a 29                	push   $0x29
  801467:	68 fd 24 80 00       	push   $0x8024fd
  80146c:	e8 fa 06 00 00       	call   801b6b <_panic>

00801471 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 18             	sub    $0x18,%esp
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80147d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801481:	75 07                	jne    80148a <smalloc+0x19>
  801483:	b8 00 00 00 00       	mov    $0x0,%eax
  801488:	eb 14                	jmp    80149e <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 30 25 80 00       	push   $0x802530
  801492:	6a 38                	push   $0x38
  801494:	68 fd 24 80 00       	push   $0x8024fd
  801499:	e8 cd 06 00 00       	call   801b6b <_panic>
	return NULL;
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 58 25 80 00       	push   $0x802558
  8014ae:	6a 43                	push   $0x43
  8014b0:	68 fd 24 80 00       	push   $0x8024fd
  8014b5:	e8 b1 06 00 00       	call   801b6b <_panic>

008014ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 7c 25 80 00       	push   $0x80257c
  8014c8:	6a 5b                	push   $0x5b
  8014ca:	68 fd 24 80 00       	push   $0x8024fd
  8014cf:	e8 97 06 00 00       	call   801b6b <_panic>

008014d4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	68 a0 25 80 00       	push   $0x8025a0
  8014e2:	6a 72                	push   $0x72
  8014e4:	68 fd 24 80 00       	push   $0x8024fd
  8014e9:	e8 7d 06 00 00       	call   801b6b <_panic>

008014ee <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 c6 25 80 00       	push   $0x8025c6
  8014fc:	6a 7e                	push   $0x7e
  8014fe:	68 fd 24 80 00       	push   $0x8024fd
  801503:	e8 63 06 00 00       	call   801b6b <_panic>

00801508 <shrink>:

}
void shrink(uint32 newSize)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	68 c6 25 80 00       	push   $0x8025c6
  801516:	68 83 00 00 00       	push   $0x83
  80151b:	68 fd 24 80 00       	push   $0x8024fd
  801520:	e8 46 06 00 00       	call   801b6b <_panic>

00801525 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	68 c6 25 80 00       	push   $0x8025c6
  801533:	68 88 00 00 00       	push   $0x88
  801538:	68 fd 24 80 00       	push   $0x8024fd
  80153d:	e8 29 06 00 00       	call   801b6b <_panic>

00801542 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	57                   	push   %edi
  801546:	56                   	push   %esi
  801547:	53                   	push   %ebx
  801548:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801551:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801554:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801557:	8b 7d 18             	mov    0x18(%ebp),%edi
  80155a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80155d:	cd 30                	int    $0x30
  80155f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801562:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	5f                   	pop    %edi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801579:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	52                   	push   %edx
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	50                   	push   %eax
  801589:	6a 00                	push   $0x0
  80158b:	e8 b2 ff ff ff       	call   801542 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	90                   	nop
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_cgetc>:

int
sys_cgetc(void)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 02                	push   $0x2
  8015a5:	e8 98 ff ff ff       	call   801542 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 03                	push   $0x3
  8015be:	e8 7f ff ff ff       	call   801542 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	90                   	nop
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 04                	push   $0x4
  8015d8:	e8 65 ff ff ff       	call   801542 <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	52                   	push   %edx
  8015f3:	50                   	push   %eax
  8015f4:	6a 08                	push   $0x8
  8015f6:	e8 47 ff ff ff       	call   801542 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801605:	8b 75 18             	mov    0x18(%ebp),%esi
  801608:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	56                   	push   %esi
  801615:	53                   	push   %ebx
  801616:	51                   	push   %ecx
  801617:	52                   	push   %edx
  801618:	50                   	push   %eax
  801619:	6a 09                	push   $0x9
  80161b:	e8 22 ff ff ff       	call   801542 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80162d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	52                   	push   %edx
  80163a:	50                   	push   %eax
  80163b:	6a 0a                	push   $0xa
  80163d:	e8 00 ff ff ff       	call   801542 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	6a 0b                	push   $0xb
  801658:	e8 e5 fe ff ff       	call   801542 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 0c                	push   $0xc
  801671:	e8 cc fe ff ff       	call   801542 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 0d                	push   $0xd
  80168a:	e8 b3 fe ff ff       	call   801542 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 0e                	push   $0xe
  8016a3:	e8 9a fe ff ff       	call   801542 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 0f                	push   $0xf
  8016bc:	e8 81 fe ff ff       	call   801542 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	6a 10                	push   $0x10
  8016d6:	e8 67 fe ff ff       	call   801542 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 11                	push   $0x11
  8016ef:	e8 4e fe ff ff       	call   801542 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801706:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	50                   	push   %eax
  801713:	6a 01                	push   $0x1
  801715:	e8 28 fe ff ff       	call   801542 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	90                   	nop
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 14                	push   $0x14
  80172f:	e8 0e fe ff ff       	call   801542 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	90                   	nop
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	8b 45 10             	mov    0x10(%ebp),%eax
  801743:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801746:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801749:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	51                   	push   %ecx
  801753:	52                   	push   %edx
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	50                   	push   %eax
  801758:	6a 15                	push   $0x15
  80175a:	e8 e3 fd ff ff       	call   801542 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	6a 16                	push   $0x16
  801777:	e8 c6 fd ff ff       	call   801542 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801784:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	51                   	push   %ecx
  801792:	52                   	push   %edx
  801793:	50                   	push   %eax
  801794:	6a 17                	push   $0x17
  801796:	e8 a7 fd ff ff       	call   801542 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	52                   	push   %edx
  8017b0:	50                   	push   %eax
  8017b1:	6a 18                	push   $0x18
  8017b3:	e8 8a fd ff ff       	call   801542 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 14             	pushl  0x14(%ebp)
  8017c8:	ff 75 10             	pushl  0x10(%ebp)
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	50                   	push   %eax
  8017cf:	6a 19                	push   $0x19
  8017d1:	e8 6c fd ff ff       	call   801542 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	50                   	push   %eax
  8017ea:	6a 1a                	push   $0x1a
  8017ec:	e8 51 fd ff ff       	call   801542 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	90                   	nop
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	50                   	push   %eax
  801806:	6a 1b                	push   $0x1b
  801808:	e8 35 fd ff ff       	call   801542 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 05                	push   $0x5
  801821:	e8 1c fd ff ff       	call   801542 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 06                	push   $0x6
  80183a:	e8 03 fd ff ff       	call   801542 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 07                	push   $0x7
  801853:	e8 ea fc ff ff       	call   801542 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_exit_env>:


void sys_exit_env(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 1c                	push   $0x1c
  80186c:	e8 d1 fc ff ff       	call   801542 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80187d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801880:	8d 50 04             	lea    0x4(%eax),%edx
  801883:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 1d                	push   $0x1d
  801890:	e8 ad fc ff ff       	call   801542 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return result;
  801898:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a1:	89 01                	mov    %eax,(%ecx)
  8018a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	c9                   	leave  
  8018aa:	c2 04 00             	ret    $0x4

008018ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 10             	pushl  0x10(%ebp)
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 13                	push   $0x13
  8018bf:	e8 7e fc ff ff       	call   801542 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 1e                	push   $0x1e
  8018d9:	e8 64 fc ff ff       	call   801542 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	50                   	push   %eax
  8018fc:	6a 1f                	push   $0x1f
  8018fe:	e8 3f fc ff ff       	call   801542 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return ;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <rsttst>:
void rsttst()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 21                	push   $0x21
  801918:	e8 25 fc ff ff       	call   801542 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
	return ;
  801920:	90                   	nop
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 45 14             	mov    0x14(%ebp),%eax
  80192c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80192f:	8b 55 18             	mov    0x18(%ebp),%edx
  801932:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	ff 75 10             	pushl  0x10(%ebp)
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 20                	push   $0x20
  801943:	e8 fa fb ff ff       	call   801542 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return ;
  80194b:	90                   	nop
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <chktst>:
void chktst(uint32 n)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 22                	push   $0x22
  80195e:	e8 df fb ff ff       	call   801542 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <inctst>:

void inctst()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 23                	push   $0x23
  801978:	e8 c5 fb ff ff       	call   801542 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
	return ;
  801980:	90                   	nop
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <gettst>:
uint32 gettst()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 24                	push   $0x24
  801992:	e8 ab fb ff ff       	call   801542 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 25                	push   $0x25
  8019ae:	e8 8f fb ff ff       	call   801542 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
  8019b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019b9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019bd:	75 07                	jne    8019c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c4:	eb 05                	jmp    8019cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 25                	push   $0x25
  8019df:	e8 5e fb ff ff       	call   801542 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
  8019e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019ea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019ee:	75 07                	jne    8019f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f5:	eb 05                	jmp    8019fc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 25                	push   $0x25
  801a10:	e8 2d fb ff ff       	call   801542 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
  801a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a1b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a1f:	75 07                	jne    801a28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a21:	b8 01 00 00 00       	mov    $0x1,%eax
  801a26:	eb 05                	jmp    801a2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 25                	push   $0x25
  801a41:	e8 fc fa ff ff       	call   801542 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
  801a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a4c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a50:	75 07                	jne    801a59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	eb 05                	jmp    801a5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 26                	push   $0x26
  801a70:	e8 cd fa ff ff       	call   801542 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	53                   	push   %ebx
  801a8e:	51                   	push   %ecx
  801a8f:	52                   	push   %edx
  801a90:	50                   	push   %eax
  801a91:	6a 27                	push   $0x27
  801a93:	e8 aa fa ff ff       	call   801542 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 28                	push   $0x28
  801ab3:	e8 8a fa ff ff       	call   801542 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ac0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	51                   	push   %ecx
  801acc:	ff 75 10             	pushl  0x10(%ebp)
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 29                	push   $0x29
  801ad3:	e8 6a fa ff ff       	call   801542 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	ff 75 10             	pushl  0x10(%ebp)
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 12                	push   $0x12
  801aef:	e8 4e fa ff ff       	call   801542 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
	return ;
  801af7:	90                   	nop
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 2a                	push   $0x2a
  801b0d:	e8 30 fa ff ff       	call   801542 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
	return;
  801b15:	90                   	nop
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	50                   	push   %eax
  801b27:	6a 2b                	push   $0x2b
  801b29:	e8 14 fa ff ff       	call   801542 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	6a 2c                	push   $0x2c
  801b44:	e8 f9 f9 ff ff       	call   801542 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return;
  801b4c:	90                   	nop
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	ff 75 08             	pushl  0x8(%ebp)
  801b5e:	6a 2d                	push   $0x2d
  801b60:	e8 dd f9 ff ff       	call   801542 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
	return;
  801b68:	90                   	nop
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801b71:	8d 45 10             	lea    0x10(%ebp),%eax
  801b74:	83 c0 04             	add    $0x4,%eax
  801b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801b7a:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	74 16                	je     801b99 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801b83:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801b88:	83 ec 08             	sub    $0x8,%esp
  801b8b:	50                   	push   %eax
  801b8c:	68 d8 25 80 00       	push   $0x8025d8
  801b91:	e8 e8 ea ff ff       	call   80067e <cprintf>
  801b96:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801b99:	a1 00 30 80 00       	mov    0x803000,%eax
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	ff 75 08             	pushl  0x8(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	68 dd 25 80 00       	push   $0x8025dd
  801baa:	e8 cf ea ff ff       	call   80067e <cprintf>
  801baf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	83 ec 08             	sub    $0x8,%esp
  801bb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbb:	50                   	push   %eax
  801bbc:	e8 52 ea ff ff       	call   800613 <vcprintf>
  801bc1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	6a 00                	push   $0x0
  801bc9:	68 f9 25 80 00       	push   $0x8025f9
  801bce:	e8 40 ea ff ff       	call   800613 <vcprintf>
  801bd3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801bd6:	e8 c1 e9 ff ff       	call   80059c <exit>

	// should not return here
	while (1) ;
  801bdb:	eb fe                	jmp    801bdb <_panic+0x70>

00801bdd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801be3:	a1 04 30 80 00       	mov    0x803004,%eax
  801be8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf1:	39 c2                	cmp    %eax,%edx
  801bf3:	74 14                	je     801c09 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	68 fc 25 80 00       	push   $0x8025fc
  801bfd:	6a 26                	push   $0x26
  801bff:	68 48 26 80 00       	push   $0x802648
  801c04:	e8 62 ff ff ff       	call   801b6b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801c09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801c10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801c17:	e9 c5 00 00 00       	jmp    801ce1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	01 d0                	add    %edx,%eax
  801c2b:	8b 00                	mov    (%eax),%eax
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	75 08                	jne    801c39 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801c31:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801c34:	e9 a5 00 00 00       	jmp    801cde <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801c39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c47:	eb 69                	jmp    801cb2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801c49:	a1 04 30 80 00       	mov    0x803004,%eax
  801c4e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801c54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c57:	89 d0                	mov    %edx,%eax
  801c59:	01 c0                	add    %eax,%eax
  801c5b:	01 d0                	add    %edx,%eax
  801c5d:	c1 e0 03             	shl    $0x3,%eax
  801c60:	01 c8                	add    %ecx,%eax
  801c62:	8a 40 04             	mov    0x4(%eax),%al
  801c65:	84 c0                	test   %al,%al
  801c67:	75 46                	jne    801caf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c69:	a1 04 30 80 00       	mov    0x803004,%eax
  801c6e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801c74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c77:	89 d0                	mov    %edx,%eax
  801c79:	01 c0                	add    %eax,%eax
  801c7b:	01 d0                	add    %edx,%eax
  801c7d:	c1 e0 03             	shl    $0x3,%eax
  801c80:	01 c8                	add    %ecx,%eax
  801c82:	8b 00                	mov    (%eax),%eax
  801c84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c8f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c94:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	01 c8                	add    %ecx,%eax
  801ca0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ca2:	39 c2                	cmp    %eax,%edx
  801ca4:	75 09                	jne    801caf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ca6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801cad:	eb 15                	jmp    801cc4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801caf:	ff 45 e8             	incl   -0x18(%ebp)
  801cb2:	a1 04 30 80 00       	mov    0x803004,%eax
  801cb7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc0:	39 c2                	cmp    %eax,%edx
  801cc2:	77 85                	ja     801c49 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801cc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cc8:	75 14                	jne    801cde <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	68 54 26 80 00       	push   $0x802654
  801cd2:	6a 3a                	push   $0x3a
  801cd4:	68 48 26 80 00       	push   $0x802648
  801cd9:	e8 8d fe ff ff       	call   801b6b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801cde:	ff 45 f0             	incl   -0x10(%ebp)
  801ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ce7:	0f 8c 2f ff ff ff    	jl     801c1c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ced:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cf4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801cfb:	eb 26                	jmp    801d23 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801cfd:	a1 04 30 80 00       	mov    0x803004,%eax
  801d02:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801d08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	01 c0                	add    %eax,%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	c1 e0 03             	shl    $0x3,%eax
  801d14:	01 c8                	add    %ecx,%eax
  801d16:	8a 40 04             	mov    0x4(%eax),%al
  801d19:	3c 01                	cmp    $0x1,%al
  801d1b:	75 03                	jne    801d20 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801d1d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d20:	ff 45 e0             	incl   -0x20(%ebp)
  801d23:	a1 04 30 80 00       	mov    0x803004,%eax
  801d28:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d31:	39 c2                	cmp    %eax,%edx
  801d33:	77 c8                	ja     801cfd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d3b:	74 14                	je     801d51 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	68 a8 26 80 00       	push   $0x8026a8
  801d45:	6a 44                	push   $0x44
  801d47:	68 48 26 80 00       	push   $0x802648
  801d4c:	e8 1a fe ff ff       	call   801b6b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <__udivdi3>:
  801d54:	55                   	push   %ebp
  801d55:	57                   	push   %edi
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	83 ec 1c             	sub    $0x1c,%esp
  801d5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d6b:	89 ca                	mov    %ecx,%edx
  801d6d:	89 f8                	mov    %edi,%eax
  801d6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d73:	85 f6                	test   %esi,%esi
  801d75:	75 2d                	jne    801da4 <__udivdi3+0x50>
  801d77:	39 cf                	cmp    %ecx,%edi
  801d79:	77 65                	ja     801de0 <__udivdi3+0x8c>
  801d7b:	89 fd                	mov    %edi,%ebp
  801d7d:	85 ff                	test   %edi,%edi
  801d7f:	75 0b                	jne    801d8c <__udivdi3+0x38>
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	31 d2                	xor    %edx,%edx
  801d88:	f7 f7                	div    %edi
  801d8a:	89 c5                	mov    %eax,%ebp
  801d8c:	31 d2                	xor    %edx,%edx
  801d8e:	89 c8                	mov    %ecx,%eax
  801d90:	f7 f5                	div    %ebp
  801d92:	89 c1                	mov    %eax,%ecx
  801d94:	89 d8                	mov    %ebx,%eax
  801d96:	f7 f5                	div    %ebp
  801d98:	89 cf                	mov    %ecx,%edi
  801d9a:	89 fa                	mov    %edi,%edx
  801d9c:	83 c4 1c             	add    $0x1c,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    
  801da4:	39 ce                	cmp    %ecx,%esi
  801da6:	77 28                	ja     801dd0 <__udivdi3+0x7c>
  801da8:	0f bd fe             	bsr    %esi,%edi
  801dab:	83 f7 1f             	xor    $0x1f,%edi
  801dae:	75 40                	jne    801df0 <__udivdi3+0x9c>
  801db0:	39 ce                	cmp    %ecx,%esi
  801db2:	72 0a                	jb     801dbe <__udivdi3+0x6a>
  801db4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801db8:	0f 87 9e 00 00 00    	ja     801e5c <__udivdi3+0x108>
  801dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc3:	89 fa                	mov    %edi,%edx
  801dc5:	83 c4 1c             	add    $0x1c,%esp
  801dc8:	5b                   	pop    %ebx
  801dc9:	5e                   	pop    %esi
  801dca:	5f                   	pop    %edi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    
  801dcd:	8d 76 00             	lea    0x0(%esi),%esi
  801dd0:	31 ff                	xor    %edi,%edi
  801dd2:	31 c0                	xor    %eax,%eax
  801dd4:	89 fa                	mov    %edi,%edx
  801dd6:	83 c4 1c             	add    $0x1c,%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5e                   	pop    %esi
  801ddb:	5f                   	pop    %edi
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    
  801dde:	66 90                	xchg   %ax,%ax
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	f7 f7                	div    %edi
  801de4:	31 ff                	xor    %edi,%edi
  801de6:	89 fa                	mov    %edi,%edx
  801de8:	83 c4 1c             	add    $0x1c,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
  801df0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801df5:	89 eb                	mov    %ebp,%ebx
  801df7:	29 fb                	sub    %edi,%ebx
  801df9:	89 f9                	mov    %edi,%ecx
  801dfb:	d3 e6                	shl    %cl,%esi
  801dfd:	89 c5                	mov    %eax,%ebp
  801dff:	88 d9                	mov    %bl,%cl
  801e01:	d3 ed                	shr    %cl,%ebp
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	09 f1                	or     %esi,%ecx
  801e07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e0b:	89 f9                	mov    %edi,%ecx
  801e0d:	d3 e0                	shl    %cl,%eax
  801e0f:	89 c5                	mov    %eax,%ebp
  801e11:	89 d6                	mov    %edx,%esi
  801e13:	88 d9                	mov    %bl,%cl
  801e15:	d3 ee                	shr    %cl,%esi
  801e17:	89 f9                	mov    %edi,%ecx
  801e19:	d3 e2                	shl    %cl,%edx
  801e1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e1f:	88 d9                	mov    %bl,%cl
  801e21:	d3 e8                	shr    %cl,%eax
  801e23:	09 c2                	or     %eax,%edx
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	89 f2                	mov    %esi,%edx
  801e29:	f7 74 24 0c          	divl   0xc(%esp)
  801e2d:	89 d6                	mov    %edx,%esi
  801e2f:	89 c3                	mov    %eax,%ebx
  801e31:	f7 e5                	mul    %ebp
  801e33:	39 d6                	cmp    %edx,%esi
  801e35:	72 19                	jb     801e50 <__udivdi3+0xfc>
  801e37:	74 0b                	je     801e44 <__udivdi3+0xf0>
  801e39:	89 d8                	mov    %ebx,%eax
  801e3b:	31 ff                	xor    %edi,%edi
  801e3d:	e9 58 ff ff ff       	jmp    801d9a <__udivdi3+0x46>
  801e42:	66 90                	xchg   %ax,%ax
  801e44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e48:	89 f9                	mov    %edi,%ecx
  801e4a:	d3 e2                	shl    %cl,%edx
  801e4c:	39 c2                	cmp    %eax,%edx
  801e4e:	73 e9                	jae    801e39 <__udivdi3+0xe5>
  801e50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e53:	31 ff                	xor    %edi,%edi
  801e55:	e9 40 ff ff ff       	jmp    801d9a <__udivdi3+0x46>
  801e5a:	66 90                	xchg   %ax,%ax
  801e5c:	31 c0                	xor    %eax,%eax
  801e5e:	e9 37 ff ff ff       	jmp    801d9a <__udivdi3+0x46>
  801e63:	90                   	nop

00801e64 <__umoddi3>:
  801e64:	55                   	push   %ebp
  801e65:	57                   	push   %edi
  801e66:	56                   	push   %esi
  801e67:	53                   	push   %ebx
  801e68:	83 ec 1c             	sub    $0x1c,%esp
  801e6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e83:	89 f3                	mov    %esi,%ebx
  801e85:	89 fa                	mov    %edi,%edx
  801e87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e8b:	89 34 24             	mov    %esi,(%esp)
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	75 1a                	jne    801eac <__umoddi3+0x48>
  801e92:	39 f7                	cmp    %esi,%edi
  801e94:	0f 86 a2 00 00 00    	jbe    801f3c <__umoddi3+0xd8>
  801e9a:	89 c8                	mov    %ecx,%eax
  801e9c:	89 f2                	mov    %esi,%edx
  801e9e:	f7 f7                	div    %edi
  801ea0:	89 d0                	mov    %edx,%eax
  801ea2:	31 d2                	xor    %edx,%edx
  801ea4:	83 c4 1c             	add    $0x1c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    
  801eac:	39 f0                	cmp    %esi,%eax
  801eae:	0f 87 ac 00 00 00    	ja     801f60 <__umoddi3+0xfc>
  801eb4:	0f bd e8             	bsr    %eax,%ebp
  801eb7:	83 f5 1f             	xor    $0x1f,%ebp
  801eba:	0f 84 ac 00 00 00    	je     801f6c <__umoddi3+0x108>
  801ec0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ec5:	29 ef                	sub    %ebp,%edi
  801ec7:	89 fe                	mov    %edi,%esi
  801ec9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ecd:	89 e9                	mov    %ebp,%ecx
  801ecf:	d3 e0                	shl    %cl,%eax
  801ed1:	89 d7                	mov    %edx,%edi
  801ed3:	89 f1                	mov    %esi,%ecx
  801ed5:	d3 ef                	shr    %cl,%edi
  801ed7:	09 c7                	or     %eax,%edi
  801ed9:	89 e9                	mov    %ebp,%ecx
  801edb:	d3 e2                	shl    %cl,%edx
  801edd:	89 14 24             	mov    %edx,(%esp)
  801ee0:	89 d8                	mov    %ebx,%eax
  801ee2:	d3 e0                	shl    %cl,%eax
  801ee4:	89 c2                	mov    %eax,%edx
  801ee6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eea:	d3 e0                	shl    %cl,%eax
  801eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ef4:	89 f1                	mov    %esi,%ecx
  801ef6:	d3 e8                	shr    %cl,%eax
  801ef8:	09 d0                	or     %edx,%eax
  801efa:	d3 eb                	shr    %cl,%ebx
  801efc:	89 da                	mov    %ebx,%edx
  801efe:	f7 f7                	div    %edi
  801f00:	89 d3                	mov    %edx,%ebx
  801f02:	f7 24 24             	mull   (%esp)
  801f05:	89 c6                	mov    %eax,%esi
  801f07:	89 d1                	mov    %edx,%ecx
  801f09:	39 d3                	cmp    %edx,%ebx
  801f0b:	0f 82 87 00 00 00    	jb     801f98 <__umoddi3+0x134>
  801f11:	0f 84 91 00 00 00    	je     801fa8 <__umoddi3+0x144>
  801f17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f1b:	29 f2                	sub    %esi,%edx
  801f1d:	19 cb                	sbb    %ecx,%ebx
  801f1f:	89 d8                	mov    %ebx,%eax
  801f21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f25:	d3 e0                	shl    %cl,%eax
  801f27:	89 e9                	mov    %ebp,%ecx
  801f29:	d3 ea                	shr    %cl,%edx
  801f2b:	09 d0                	or     %edx,%eax
  801f2d:	89 e9                	mov    %ebp,%ecx
  801f2f:	d3 eb                	shr    %cl,%ebx
  801f31:	89 da                	mov    %ebx,%edx
  801f33:	83 c4 1c             	add    $0x1c,%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5e                   	pop    %esi
  801f38:	5f                   	pop    %edi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    
  801f3b:	90                   	nop
  801f3c:	89 fd                	mov    %edi,%ebp
  801f3e:	85 ff                	test   %edi,%edi
  801f40:	75 0b                	jne    801f4d <__umoddi3+0xe9>
  801f42:	b8 01 00 00 00       	mov    $0x1,%eax
  801f47:	31 d2                	xor    %edx,%edx
  801f49:	f7 f7                	div    %edi
  801f4b:	89 c5                	mov    %eax,%ebp
  801f4d:	89 f0                	mov    %esi,%eax
  801f4f:	31 d2                	xor    %edx,%edx
  801f51:	f7 f5                	div    %ebp
  801f53:	89 c8                	mov    %ecx,%eax
  801f55:	f7 f5                	div    %ebp
  801f57:	89 d0                	mov    %edx,%eax
  801f59:	e9 44 ff ff ff       	jmp    801ea2 <__umoddi3+0x3e>
  801f5e:	66 90                	xchg   %ax,%ax
  801f60:	89 c8                	mov    %ecx,%eax
  801f62:	89 f2                	mov    %esi,%edx
  801f64:	83 c4 1c             	add    $0x1c,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5f                   	pop    %edi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    
  801f6c:	3b 04 24             	cmp    (%esp),%eax
  801f6f:	72 06                	jb     801f77 <__umoddi3+0x113>
  801f71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f75:	77 0f                	ja     801f86 <__umoddi3+0x122>
  801f77:	89 f2                	mov    %esi,%edx
  801f79:	29 f9                	sub    %edi,%ecx
  801f7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f7f:	89 14 24             	mov    %edx,(%esp)
  801f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f8a:	8b 14 24             	mov    (%esp),%edx
  801f8d:	83 c4 1c             	add    $0x1c,%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5f                   	pop    %edi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    
  801f95:	8d 76 00             	lea    0x0(%esi),%esi
  801f98:	2b 04 24             	sub    (%esp),%eax
  801f9b:	19 fa                	sbb    %edi,%edx
  801f9d:	89 d1                	mov    %edx,%ecx
  801f9f:	89 c6                	mov    %eax,%esi
  801fa1:	e9 71 ff ff ff       	jmp    801f17 <__umoddi3+0xb3>
  801fa6:	66 90                	xchg   %ax,%ax
  801fa8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fac:	72 ea                	jb     801f98 <__umoddi3+0x134>
  801fae:	89 d9                	mov    %ebx,%ecx
  801fb0:	e9 62 ff ff ff       	jmp    801f17 <__umoddi3+0xb3>
