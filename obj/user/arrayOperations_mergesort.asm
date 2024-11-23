
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
  80003e:	e8 a7 1b 00 00       	call   801bea <sys_getparentenvid>
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
  800057:	68 00 3e 80 00       	push   $0x803e00
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 6e 17 00 00       	call   8017d2 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 04 3e 80 00       	push   $0x803e04
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 58 17 00 00       	call   8017d2 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 0c 3e 80 00       	push   $0x803e0c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 3b 17 00 00       	call   8017d2 <sget>
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
  8000ab:	68 1a 3e 80 00       	push   $0x803e1a
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
  80010c:	68 29 3e 80 00       	push   $0x803e29
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
  8001a2:	68 45 3e 80 00       	push   $0x803e45
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
  8001c4:	68 47 3e 80 00       	push   $0x803e47
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
  8001f2:	68 4c 3e 80 00       	push   $0x803e4c
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
  800479:	e8 53 17 00 00       	call   801bd1 <sys_getenvindex>
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
  8004e7:	e8 69 14 00 00       	call   801955 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 68 3e 80 00       	push   $0x803e68
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
  800517:	68 90 3e 80 00       	push   $0x803e90
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
  800548:	68 b8 3e 80 00       	push   $0x803eb8
  80054d:	e8 34 01 00 00       	call   800686 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 10 3f 80 00       	push   $0x803f10
  800569:	e8 18 01 00 00       	call   800686 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 68 3e 80 00       	push   $0x803e68
  800579:	e8 08 01 00 00       	call   800686 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800581:	e8 e9 13 00 00       	call   80196f <sys_unlock_cons>
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
  800599:	e8 ff 15 00 00       	call   801b9d <sys_destroy_env>
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
  8005aa:	e8 54 16 00 00       	call   801c03 <sys_exit_env>
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
  8005f8:	e8 16 13 00 00       	call   801913 <sys_cputs>
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
  80066f:	e8 9f 12 00 00       	call   801913 <sys_cputs>
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
  8006b9:	e8 97 12 00 00       	call   801955 <sys_lock_cons>
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
  8006d9:	e8 91 12 00 00       	call   80196f <sys_unlock_cons>
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
  800723:	e8 6c 34 00 00       	call   803b94 <__udivdi3>
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
  800773:	e8 2c 35 00 00       	call   803ca4 <__umoddi3>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	05 54 41 80 00       	add    $0x804154,%eax
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
  8008ce:	8b 04 85 78 41 80 00 	mov    0x804178(,%eax,4),%eax
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
  8009af:	8b 34 9d c0 3f 80 00 	mov    0x803fc0(,%ebx,4),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 19                	jne    8009d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	53                   	push   %ebx
  8009bb:	68 65 41 80 00       	push   $0x804165
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
  8009d4:	68 6e 41 80 00       	push   $0x80416e
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
  800a01:	be 71 41 80 00       	mov    $0x804171,%esi
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
  80140c:	68 e8 42 80 00       	push   $0x8042e8
  801411:	68 3f 01 00 00       	push   $0x13f
  801416:	68 0a 43 80 00       	push   $0x80430a
  80141b:	e8 8a 25 00 00       	call   8039aa <_panic>

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
  80142c:	e8 8d 0a 00 00       	call   801ebe <sys_sbrk>
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
  8014a7:	e8 96 08 00 00       	call   801d42 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 16                	je     8014c6 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 d6 0d 00 00       	call   802291 <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	e9 8a 01 00 00       	jmp    801650 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014c6:	e8 a8 08 00 00       	call   801d73 <sys_isUHeapPlacementStrategyBESTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 84 7d 01 00 00    	je     801650 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 6f 12 00 00       	call   80274d <alloc_block_BF>
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
  80163f:	e8 b1 08 00 00       	call   801ef5 <sys_allocate_user_mem>
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
  801687:	e8 85 08 00 00       	call   801f11 <get_block_size>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 b8 1a 00 00       	call   803155 <free_block>
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
  80172f:	e8 a5 07 00 00       	call   801ed9 <sys_free_user_mem>
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
  80173d:	68 18 43 80 00       	push   $0x804318
  801742:	68 84 00 00 00       	push   $0x84
  801747:	68 42 43 80 00       	push   $0x804342
  80174c:	e8 59 22 00 00       	call   8039aa <_panic>
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
  80176a:	eb 64                	jmp    8017d0 <smalloc+0x7d>
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
  80179f:	eb 2f                	jmp    8017d0 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017a1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a8:	50                   	push   %eax
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	e8 2c 03 00 00       	call   801ae0 <sys_createSharedObject>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017ba:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017be:	74 06                	je     8017c6 <smalloc+0x73>
  8017c0:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017c4:	75 07                	jne    8017cd <smalloc+0x7a>
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	eb 03                	jmp    8017d0 <smalloc+0x7d>
	 return ptr;
  8017cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	e8 24 03 00 00       	call   801b0a <sys_getSizeOfSharedObject>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017ec:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017f0:	75 07                	jne    8017f9 <sget+0x27>
  8017f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f7:	eb 5c                	jmp    801855 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ff:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801806:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180c:	39 d0                	cmp    %edx,%eax
  80180e:	7d 02                	jge    801812 <sget+0x40>
  801810:	89 d0                	mov    %edx,%eax
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	50                   	push   %eax
  801816:	e8 1b fc ff ff       	call   801436 <malloc>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801821:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801825:	75 07                	jne    80182e <sget+0x5c>
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	eb 27                	jmp    801855 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	ff 75 e8             	pushl  -0x18(%ebp)
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 e8 02 00 00       	call   801b27 <sys_getSharedObject>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801845:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801849:	75 07                	jne    801852 <sget+0x80>
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	eb 03                	jmp    801855 <sget+0x83>
	return ptr;
  801852:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	68 50 43 80 00       	push   $0x804350
  801865:	68 c1 00 00 00       	push   $0xc1
  80186a:	68 42 43 80 00       	push   $0x804342
  80186f:	e8 36 21 00 00       	call   8039aa <_panic>

00801874 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 74 43 80 00       	push   $0x804374
  801882:	68 d8 00 00 00       	push   $0xd8
  801887:	68 42 43 80 00       	push   $0x804342
  80188c:	e8 19 21 00 00       	call   8039aa <_panic>

00801891 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	68 9a 43 80 00       	push   $0x80439a
  80189f:	68 e4 00 00 00       	push   $0xe4
  8018a4:	68 42 43 80 00       	push   $0x804342
  8018a9:	e8 fc 20 00 00       	call   8039aa <_panic>

008018ae <shrink>:

}
void shrink(uint32 newSize)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 9a 43 80 00       	push   $0x80439a
  8018bc:	68 e9 00 00 00       	push   $0xe9
  8018c1:	68 42 43 80 00       	push   $0x804342
  8018c6:	e8 df 20 00 00       	call   8039aa <_panic>

008018cb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	68 9a 43 80 00       	push   $0x80439a
  8018d9:	68 ee 00 00 00       	push   $0xee
  8018de:	68 42 43 80 00       	push   $0x804342
  8018e3:	e8 c2 20 00 00       	call   8039aa <_panic>

008018e8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	57                   	push   %edi
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
  8018ee:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801900:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801903:	cd 30                	int    $0x30
  801905:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	5b                   	pop    %ebx
  80190f:	5e                   	pop    %esi
  801910:	5f                   	pop    %edi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80191f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	52                   	push   %edx
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	50                   	push   %eax
  80192f:	6a 00                	push   $0x0
  801931:	e8 b2 ff ff ff       	call   8018e8 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	90                   	nop
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_cgetc>:

int
sys_cgetc(void)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 02                	push   $0x2
  80194b:	e8 98 ff ff ff       	call   8018e8 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 03                	push   $0x3
  801964:	e8 7f ff ff ff       	call   8018e8 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	90                   	nop
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 04                	push   $0x4
  80197e:	e8 65 ff ff ff       	call   8018e8 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80198c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	52                   	push   %edx
  801999:	50                   	push   %eax
  80199a:	6a 08                	push   $0x8
  80199c:	e8 47 ff ff ff       	call   8018e8 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	56                   	push   %esi
  8019aa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	51                   	push   %ecx
  8019bd:	52                   	push   %edx
  8019be:	50                   	push   %eax
  8019bf:	6a 09                	push   $0x9
  8019c1:	e8 22 ff ff ff       	call   8018e8 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	52                   	push   %edx
  8019e0:	50                   	push   %eax
  8019e1:	6a 0a                	push   $0xa
  8019e3:	e8 00 ff ff ff       	call   8018e8 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	6a 0b                	push   $0xb
  8019fe:	e8 e5 fe ff ff       	call   8018e8 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0c                	push   $0xc
  801a17:	e8 cc fe ff ff       	call   8018e8 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 0d                	push   $0xd
  801a30:	e8 b3 fe ff ff       	call   8018e8 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 0e                	push   $0xe
  801a49:	e8 9a fe ff ff       	call   8018e8 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 0f                	push   $0xf
  801a62:	e8 81 fe ff ff       	call   8018e8 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 08             	pushl  0x8(%ebp)
  801a7a:	6a 10                	push   $0x10
  801a7c:	e8 67 fe ff ff       	call   8018e8 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 11                	push   $0x11
  801a95:	e8 4e fe ff ff       	call   8018e8 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_cputc>:

void
sys_cputc(const char c)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	50                   	push   %eax
  801ab9:	6a 01                	push   $0x1
  801abb:	e8 28 fe ff ff       	call   8018e8 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 14                	push   $0x14
  801ad5:	e8 0e fe ff ff       	call   8018e8 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	51                   	push   %ecx
  801af9:	52                   	push   %edx
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	50                   	push   %eax
  801afe:	6a 15                	push   $0x15
  801b00:	e8 e3 fd ff ff       	call   8018e8 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	52                   	push   %edx
  801b1a:	50                   	push   %eax
  801b1b:	6a 16                	push   $0x16
  801b1d:	e8 c6 fd ff ff       	call   8018e8 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	51                   	push   %ecx
  801b38:	52                   	push   %edx
  801b39:	50                   	push   %eax
  801b3a:	6a 17                	push   $0x17
  801b3c:	e8 a7 fd ff ff       	call   8018e8 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 18                	push   $0x18
  801b59:	e8 8a fd ff ff       	call   8018e8 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	ff 75 14             	pushl  0x14(%ebp)
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 19                	push   $0x19
  801b77:	e8 6c fd ff ff       	call   8018e8 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	50                   	push   %eax
  801b90:	6a 1a                	push   $0x1a
  801b92:	e8 51 fd ff ff       	call   8018e8 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 1b                	push   $0x1b
  801bae:	e8 35 fd ff ff       	call   8018e8 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 05                	push   $0x5
  801bc7:	e8 1c fd ff ff       	call   8018e8 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 06                	push   $0x6
  801be0:	e8 03 fd ff ff       	call   8018e8 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 07                	push   $0x7
  801bf9:	e8 ea fc ff ff       	call   8018e8 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_exit_env>:


void sys_exit_env(void)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 1c                	push   $0x1c
  801c12:	e8 d1 fc ff ff       	call   8018e8 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c26:	8d 50 04             	lea    0x4(%eax),%edx
  801c29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	52                   	push   %edx
  801c33:	50                   	push   %eax
  801c34:	6a 1d                	push   $0x1d
  801c36:	e8 ad fc ff ff       	call   8018e8 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c47:	89 01                	mov    %eax,(%ecx)
  801c49:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	c9                   	leave  
  801c50:	c2 04 00             	ret    $0x4

00801c53 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	ff 75 10             	pushl  0x10(%ebp)
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	6a 13                	push   $0x13
  801c65:	e8 7e fc ff ff       	call   8018e8 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6d:	90                   	nop
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 1e                	push   $0x1e
  801c7f:	e8 64 fc ff ff       	call   8018e8 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c95:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	50                   	push   %eax
  801ca2:	6a 1f                	push   $0x1f
  801ca4:	e8 3f fc ff ff       	call   8018e8 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cac:	90                   	nop
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <rsttst>:
void rsttst()
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 21                	push   $0x21
  801cbe:	e8 25 fc ff ff       	call   8018e8 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc6:	90                   	nop
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cd5:	8b 55 18             	mov    0x18(%ebp),%edx
  801cd8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cdc:	52                   	push   %edx
  801cdd:	50                   	push   %eax
  801cde:	ff 75 10             	pushl  0x10(%ebp)
  801ce1:	ff 75 0c             	pushl  0xc(%ebp)
  801ce4:	ff 75 08             	pushl  0x8(%ebp)
  801ce7:	6a 20                	push   $0x20
  801ce9:	e8 fa fb ff ff       	call   8018e8 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf1:	90                   	nop
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <chktst>:
void chktst(uint32 n)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	6a 22                	push   $0x22
  801d04:	e8 df fb ff ff       	call   8018e8 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0c:	90                   	nop
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <inctst>:

void inctst()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 23                	push   $0x23
  801d1e:	e8 c5 fb ff ff       	call   8018e8 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
	return ;
  801d26:	90                   	nop
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <gettst>:
uint32 gettst()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 24                	push   $0x24
  801d38:	e8 ab fb ff ff       	call   8018e8 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 25                	push   $0x25
  801d54:	e8 8f fb ff ff       	call   8018e8 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d5f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d63:	75 07                	jne    801d6c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb 05                	jmp    801d71 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 25                	push   $0x25
  801d85:	e8 5e fb ff ff       	call   8018e8 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d90:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 25                	push   $0x25
  801db6:	e8 2d fb ff ff       	call   8018e8 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dc1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 25                	push   $0x25
  801de7:	e8 fc fa ff ff       	call   8018e8 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
  801def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801df2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801df6:	75 07                	jne    801dff <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801df8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfd:	eb 05                	jmp    801e04 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 08             	pushl  0x8(%ebp)
  801e14:	6a 26                	push   $0x26
  801e16:	e8 cd fa ff ff       	call   8018e8 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1e:	90                   	nop
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	6a 00                	push   $0x0
  801e33:	53                   	push   %ebx
  801e34:	51                   	push   %ecx
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	6a 27                	push   $0x27
  801e39:	e8 aa fa ff ff       	call   8018e8 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	52                   	push   %edx
  801e56:	50                   	push   %eax
  801e57:	6a 28                	push   $0x28
  801e59:	e8 8a fa ff ff       	call   8018e8 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e66:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	6a 00                	push   $0x0
  801e71:	51                   	push   %ecx
  801e72:	ff 75 10             	pushl  0x10(%ebp)
  801e75:	52                   	push   %edx
  801e76:	50                   	push   %eax
  801e77:	6a 29                	push   $0x29
  801e79:	e8 6a fa ff ff       	call   8018e8 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	ff 75 10             	pushl  0x10(%ebp)
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	6a 12                	push   $0x12
  801e95:	e8 4e fa ff ff       	call   8018e8 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9d:	90                   	nop
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 2a                	push   $0x2a
  801eb3:	e8 30 fa ff ff       	call   8018e8 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	50                   	push   %eax
  801ecd:	6a 2b                	push   $0x2b
  801ecf:	e8 14 fa ff ff       	call   8018e8 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	ff 75 0c             	pushl  0xc(%ebp)
  801ee5:	ff 75 08             	pushl  0x8(%ebp)
  801ee8:	6a 2c                	push   $0x2c
  801eea:	e8 f9 f9 ff ff       	call   8018e8 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
	return;
  801ef2:	90                   	nop
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	ff 75 0c             	pushl  0xc(%ebp)
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	6a 2d                	push   $0x2d
  801f06:	e8 dd f9 ff ff       	call   8018e8 <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
	return;
  801f0e:	90                   	nop
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	83 e8 04             	sub    $0x4,%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f23:	8b 00                	mov    (%eax),%eax
  801f25:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	83 e8 04             	sub    $0x4,%eax
  801f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3c:	8b 00                	mov    (%eax),%eax
  801f3e:	83 e0 01             	and    $0x1,%eax
  801f41:	85 c0                	test   %eax,%eax
  801f43:	0f 94 c0             	sete   %al
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	83 f8 02             	cmp    $0x2,%eax
  801f5b:	74 2b                	je     801f88 <alloc_block+0x40>
  801f5d:	83 f8 02             	cmp    $0x2,%eax
  801f60:	7f 07                	jg     801f69 <alloc_block+0x21>
  801f62:	83 f8 01             	cmp    $0x1,%eax
  801f65:	74 0e                	je     801f75 <alloc_block+0x2d>
  801f67:	eb 58                	jmp    801fc1 <alloc_block+0x79>
  801f69:	83 f8 03             	cmp    $0x3,%eax
  801f6c:	74 2d                	je     801f9b <alloc_block+0x53>
  801f6e:	83 f8 04             	cmp    $0x4,%eax
  801f71:	74 3b                	je     801fae <alloc_block+0x66>
  801f73:	eb 4c                	jmp    801fc1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	ff 75 08             	pushl  0x8(%ebp)
  801f7b:	e8 11 03 00 00       	call   802291 <alloc_block_FF>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f86:	eb 4a                	jmp    801fd2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	ff 75 08             	pushl  0x8(%ebp)
  801f8e:	e8 fa 19 00 00       	call   80398d <alloc_block_NF>
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f99:	eb 37                	jmp    801fd2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	e8 a7 07 00 00       	call   80274d <alloc_block_BF>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fac:	eb 24                	jmp    801fd2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 08             	pushl  0x8(%ebp)
  801fb4:	e8 b7 19 00 00       	call   803970 <alloc_block_WF>
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fbf:	eb 11                	jmp    801fd2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	68 ac 43 80 00       	push   $0x8043ac
  801fc9:	e8 b8 e6 ff ff       	call   800686 <cprintf>
  801fce:	83 c4 10             	add    $0x10,%esp
		break;
  801fd1:	90                   	nop
	}
	return va;
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	53                   	push   %ebx
  801fdb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	68 cc 43 80 00       	push   $0x8043cc
  801fe6:	e8 9b e6 ff ff       	call   800686 <cprintf>
  801feb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 f7 43 80 00       	push   $0x8043f7
  801ff6:	e8 8b e6 ff ff       	call   800686 <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802004:	eb 37                	jmp    80203d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	ff 75 f4             	pushl  -0xc(%ebp)
  80200c:	e8 19 ff ff ff       	call   801f2a <is_free_block>
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	0f be d8             	movsbl %al,%ebx
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	ff 75 f4             	pushl  -0xc(%ebp)
  80201d:	e8 ef fe ff ff       	call   801f11 <get_block_size>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	53                   	push   %ebx
  802029:	50                   	push   %eax
  80202a:	68 0f 44 80 00       	push   $0x80440f
  80202f:	e8 52 e6 ff ff       	call   800686 <cprintf>
  802034:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802037:	8b 45 10             	mov    0x10(%ebp),%eax
  80203a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802041:	74 07                	je     80204a <print_blocks_list+0x73>
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	8b 00                	mov    (%eax),%eax
  802048:	eb 05                	jmp    80204f <print_blocks_list+0x78>
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	89 45 10             	mov    %eax,0x10(%ebp)
  802052:	8b 45 10             	mov    0x10(%ebp),%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	75 ad                	jne    802006 <print_blocks_list+0x2f>
  802059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205d:	75 a7                	jne    802006 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	68 cc 43 80 00       	push   $0x8043cc
  802067:	e8 1a e6 ff ff       	call   800686 <cprintf>
  80206c:	83 c4 10             	add    $0x10,%esp

}
  80206f:	90                   	nop
  802070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80207b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207e:	83 e0 01             	and    $0x1,%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	74 03                	je     802088 <initialize_dynamic_allocator+0x13>
  802085:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802088:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208c:	0f 84 c7 01 00 00    	je     802259 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802092:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802099:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80209c:	8b 55 08             	mov    0x8(%ebp),%edx
  80209f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020a9:	0f 87 ad 01 00 00    	ja     80225c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	0f 89 a5 01 00 00    	jns    80225f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c0:	01 d0                	add    %edx,%eax
  8020c2:	83 e8 04             	sub    $0x4,%eax
  8020c5:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d9:	e9 87 00 00 00       	jmp    802165 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e2:	75 14                	jne    8020f8 <initialize_dynamic_allocator+0x83>
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	68 27 44 80 00       	push   $0x804427
  8020ec:	6a 79                	push   $0x79
  8020ee:	68 45 44 80 00       	push   $0x804445
  8020f3:	e8 b2 18 00 00       	call   8039aa <_panic>
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 00                	mov    (%eax),%eax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	74 10                	je     802111 <initialize_dynamic_allocator+0x9c>
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	8b 00                	mov    (%eax),%eax
  802106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802109:	8b 52 04             	mov    0x4(%edx),%edx
  80210c:	89 50 04             	mov    %edx,0x4(%eax)
  80210f:	eb 0b                	jmp    80211c <initialize_dynamic_allocator+0xa7>
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 40 04             	mov    0x4(%eax),%eax
  802117:	a3 30 50 80 00       	mov    %eax,0x805030
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 40 04             	mov    0x4(%eax),%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	74 0f                	je     802135 <initialize_dynamic_allocator+0xc0>
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8b 40 04             	mov    0x4(%eax),%eax
  80212c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212f:	8b 12                	mov    (%edx),%edx
  802131:	89 10                	mov    %edx,(%eax)
  802133:	eb 0a                	jmp    80213f <initialize_dynamic_allocator+0xca>
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 00                	mov    (%eax),%eax
  80213a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802152:	a1 38 50 80 00       	mov    0x805038,%eax
  802157:	48                   	dec    %eax
  802158:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80215d:	a1 34 50 80 00       	mov    0x805034,%eax
  802162:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802169:	74 07                	je     802172 <initialize_dynamic_allocator+0xfd>
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	eb 05                	jmp    802177 <initialize_dynamic_allocator+0x102>
  802172:	b8 00 00 00 00       	mov    $0x0,%eax
  802177:	a3 34 50 80 00       	mov    %eax,0x805034
  80217c:	a1 34 50 80 00       	mov    0x805034,%eax
  802181:	85 c0                	test   %eax,%eax
  802183:	0f 85 55 ff ff ff    	jne    8020de <initialize_dynamic_allocator+0x69>
  802189:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218d:	0f 85 4b ff ff ff    	jne    8020de <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021a2:	a1 44 50 80 00       	mov    0x805044,%eax
  8021a7:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	83 c0 08             	add    $0x8,%eax
  8021bd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	83 c0 04             	add    $0x4,%eax
  8021c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c9:	83 ea 08             	sub    $0x8,%edx
  8021cc:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	01 d0                	add    %edx,%eax
  8021d6:	83 e8 08             	sub    $0x8,%eax
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	83 ea 08             	sub    $0x8,%edx
  8021df:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021f8:	75 17                	jne    802211 <initialize_dynamic_allocator+0x19c>
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 60 44 80 00       	push   $0x804460
  802202:	68 90 00 00 00       	push   $0x90
  802207:	68 45 44 80 00       	push   $0x804445
  80220c:	e8 99 17 00 00       	call   8039aa <_panic>
  802211:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221a:	89 10                	mov    %edx,(%eax)
  80221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	74 0d                	je     802232 <initialize_dynamic_allocator+0x1bd>
  802225:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80222a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80222d:	89 50 04             	mov    %edx,0x4(%eax)
  802230:	eb 08                	jmp    80223a <initialize_dynamic_allocator+0x1c5>
  802232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802235:	a3 30 50 80 00       	mov    %eax,0x805030
  80223a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224c:	a1 38 50 80 00       	mov    0x805038,%eax
  802251:	40                   	inc    %eax
  802252:	a3 38 50 80 00       	mov    %eax,0x805038
  802257:	eb 07                	jmp    802260 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802259:	90                   	nop
  80225a:	eb 04                	jmp    802260 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80225c:	90                   	nop
  80225d:	eb 01                	jmp    802260 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80225f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802265:	8b 45 10             	mov    0x10(%ebp),%eax
  802268:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802271:	8b 45 0c             	mov    0xc(%ebp),%eax
  802274:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	83 e8 04             	sub    $0x4,%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	83 e0 fe             	and    $0xfffffffe,%eax
  802281:	8d 50 f8             	lea    -0x8(%eax),%edx
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	01 c2                	add    %eax,%edx
  802289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228c:	89 02                	mov    %eax,(%edx)
}
  80228e:	90                   	nop
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    

00802291 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	83 e0 01             	and    $0x1,%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	74 03                	je     8022a4 <alloc_block_FF+0x13>
  8022a1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022a4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022a8:	77 07                	ja     8022b1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022aa:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022b1:	a1 24 50 80 00       	mov    0x805024,%eax
  8022b6:	85 c0                	test   %eax,%eax
  8022b8:	75 73                	jne    80232d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	83 c0 10             	add    $0x10,%eax
  8022c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022c3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d0:	01 d0                	add    %edx,%eax
  8022d2:	48                   	dec    %eax
  8022d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022de:	f7 75 ec             	divl   -0x14(%ebp)
  8022e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e4:	29 d0                	sub    %edx,%eax
  8022e6:	c1 e8 0c             	shr    $0xc,%eax
  8022e9:	83 ec 0c             	sub    $0xc,%esp
  8022ec:	50                   	push   %eax
  8022ed:	e8 2e f1 ff ff       	call   801420 <sbrk>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022f8:	83 ec 0c             	sub    $0xc,%esp
  8022fb:	6a 00                	push   $0x0
  8022fd:	e8 1e f1 ff ff       	call   801420 <sbrk>
  802302:	83 c4 10             	add    $0x10,%esp
  802305:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802308:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80230e:	83 ec 08             	sub    $0x8,%esp
  802311:	50                   	push   %eax
  802312:	ff 75 e4             	pushl  -0x1c(%ebp)
  802315:	e8 5b fd ff ff       	call   802075 <initialize_dynamic_allocator>
  80231a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80231d:	83 ec 0c             	sub    $0xc,%esp
  802320:	68 83 44 80 00       	push   $0x804483
  802325:	e8 5c e3 ff ff       	call   800686 <cprintf>
  80232a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80232d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802331:	75 0a                	jne    80233d <alloc_block_FF+0xac>
	        return NULL;
  802333:	b8 00 00 00 00       	mov    $0x0,%eax
  802338:	e9 0e 04 00 00       	jmp    80274b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80233d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802344:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234c:	e9 f3 02 00 00       	jmp    802644 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	ff 75 bc             	pushl  -0x44(%ebp)
  80235d:	e8 af fb ff ff       	call   801f11 <get_block_size>
  802362:	83 c4 10             	add    $0x10,%esp
  802365:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	83 c0 08             	add    $0x8,%eax
  80236e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802371:	0f 87 c5 02 00 00    	ja     80263c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	83 c0 18             	add    $0x18,%eax
  80237d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802380:	0f 87 19 02 00 00    	ja     80259f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802386:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802389:	2b 45 08             	sub    0x8(%ebp),%eax
  80238c:	83 e8 08             	sub    $0x8,%eax
  80238f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8d 50 08             	lea    0x8(%eax),%edx
  802398:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80239b:	01 d0                	add    %edx,%eax
  80239d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	83 c0 08             	add    $0x8,%eax
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	6a 01                	push   $0x1
  8023ab:	50                   	push   %eax
  8023ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8023af:	e8 ae fe ff ff       	call   802262 <set_block_data>
  8023b4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 04             	mov    0x4(%eax),%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	75 68                	jne    802429 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023c1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023c5:	75 17                	jne    8023de <alloc_block_FF+0x14d>
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	68 60 44 80 00       	push   $0x804460
  8023cf:	68 d7 00 00 00       	push   $0xd7
  8023d4:	68 45 44 80 00       	push   $0x804445
  8023d9:	e8 cc 15 00 00       	call   8039aa <_panic>
  8023de:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e7:	89 10                	mov    %edx,(%eax)
  8023e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	74 0d                	je     8023ff <alloc_block_FF+0x16e>
  8023f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023fa:	89 50 04             	mov    %edx,0x4(%eax)
  8023fd:	eb 08                	jmp    802407 <alloc_block_FF+0x176>
  8023ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802402:	a3 30 50 80 00       	mov    %eax,0x805030
  802407:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80240f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802419:	a1 38 50 80 00       	mov    0x805038,%eax
  80241e:	40                   	inc    %eax
  80241f:	a3 38 50 80 00       	mov    %eax,0x805038
  802424:	e9 dc 00 00 00       	jmp    802505 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 00                	mov    (%eax),%eax
  80242e:	85 c0                	test   %eax,%eax
  802430:	75 65                	jne    802497 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802432:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802436:	75 17                	jne    80244f <alloc_block_FF+0x1be>
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	68 94 44 80 00       	push   $0x804494
  802440:	68 db 00 00 00       	push   $0xdb
  802445:	68 45 44 80 00       	push   $0x804445
  80244a:	e8 5b 15 00 00       	call   8039aa <_panic>
  80244f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802455:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802458:	89 50 04             	mov    %edx,0x4(%eax)
  80245b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245e:	8b 40 04             	mov    0x4(%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 0c                	je     802471 <alloc_block_FF+0x1e0>
  802465:	a1 30 50 80 00       	mov    0x805030,%eax
  80246a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80246d:	89 10                	mov    %edx,(%eax)
  80246f:	eb 08                	jmp    802479 <alloc_block_FF+0x1e8>
  802471:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802474:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802479:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247c:	a3 30 50 80 00       	mov    %eax,0x805030
  802481:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802484:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248a:	a1 38 50 80 00       	mov    0x805038,%eax
  80248f:	40                   	inc    %eax
  802490:	a3 38 50 80 00       	mov    %eax,0x805038
  802495:	eb 6e                	jmp    802505 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249b:	74 06                	je     8024a3 <alloc_block_FF+0x212>
  80249d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024a1:	75 17                	jne    8024ba <alloc_block_FF+0x229>
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	68 b8 44 80 00       	push   $0x8044b8
  8024ab:	68 df 00 00 00       	push   $0xdf
  8024b0:	68 45 44 80 00       	push   $0x804445
  8024b5:	e8 f0 14 00 00       	call   8039aa <_panic>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 10                	mov    (%eax),%edx
  8024bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c2:	89 10                	mov    %edx,(%eax)
  8024c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 0b                	je     8024d8 <alloc_block_FF+0x247>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024d5:	89 50 04             	mov    %edx,0x4(%eax)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024de:	89 10                	mov    %edx,(%eax)
  8024e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e6:	89 50 04             	mov    %edx,0x4(%eax)
  8024e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	75 08                	jne    8024fa <alloc_block_FF+0x269>
  8024f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8024ff:	40                   	inc    %eax
  802500:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	75 17                	jne    802522 <alloc_block_FF+0x291>
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	68 27 44 80 00       	push   $0x804427
  802513:	68 e1 00 00 00       	push   $0xe1
  802518:	68 45 44 80 00       	push   $0x804445
  80251d:	e8 88 14 00 00       	call   8039aa <_panic>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 10                	je     80253b <alloc_block_FF+0x2aa>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802533:	8b 52 04             	mov    0x4(%edx),%edx
  802536:	89 50 04             	mov    %edx,0x4(%eax)
  802539:	eb 0b                	jmp    802546 <alloc_block_FF+0x2b5>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 40 04             	mov    0x4(%eax),%eax
  802541:	a3 30 50 80 00       	mov    %eax,0x805030
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	74 0f                	je     80255f <alloc_block_FF+0x2ce>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	8b 12                	mov    (%edx),%edx
  80255b:	89 10                	mov    %edx,(%eax)
  80255d:	eb 0a                	jmp    802569 <alloc_block_FF+0x2d8>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257c:	a1 38 50 80 00       	mov    0x805038,%eax
  802581:	48                   	dec    %eax
  802582:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	6a 00                	push   $0x0
  80258c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80258f:	ff 75 b0             	pushl  -0x50(%ebp)
  802592:	e8 cb fc ff ff       	call   802262 <set_block_data>
  802597:	83 c4 10             	add    $0x10,%esp
  80259a:	e9 95 00 00 00       	jmp    802634 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	6a 01                	push   $0x1
  8025a4:	ff 75 b8             	pushl  -0x48(%ebp)
  8025a7:	ff 75 bc             	pushl  -0x44(%ebp)
  8025aa:	e8 b3 fc ff ff       	call   802262 <set_block_data>
  8025af:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	75 17                	jne    8025cf <alloc_block_FF+0x33e>
  8025b8:	83 ec 04             	sub    $0x4,%esp
  8025bb:	68 27 44 80 00       	push   $0x804427
  8025c0:	68 e8 00 00 00       	push   $0xe8
  8025c5:	68 45 44 80 00       	push   $0x804445
  8025ca:	e8 db 13 00 00       	call   8039aa <_panic>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 10                	je     8025e8 <alloc_block_FF+0x357>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e0:	8b 52 04             	mov    0x4(%edx),%edx
  8025e3:	89 50 04             	mov    %edx,0x4(%eax)
  8025e6:	eb 0b                	jmp    8025f3 <alloc_block_FF+0x362>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	74 0f                	je     80260c <alloc_block_FF+0x37b>
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802606:	8b 12                	mov    (%edx),%edx
  802608:	89 10                	mov    %edx,(%eax)
  80260a:	eb 0a                	jmp    802616 <alloc_block_FF+0x385>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802629:	a1 38 50 80 00       	mov    0x805038,%eax
  80262e:	48                   	dec    %eax
  80262f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802634:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802637:	e9 0f 01 00 00       	jmp    80274b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80263c:	a1 34 50 80 00       	mov    0x805034,%eax
  802641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802648:	74 07                	je     802651 <alloc_block_FF+0x3c0>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	eb 05                	jmp    802656 <alloc_block_FF+0x3c5>
  802651:	b8 00 00 00 00       	mov    $0x0,%eax
  802656:	a3 34 50 80 00       	mov    %eax,0x805034
  80265b:	a1 34 50 80 00       	mov    0x805034,%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	0f 85 e9 fc ff ff    	jne    802351 <alloc_block_FF+0xc0>
  802668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266c:	0f 85 df fc ff ff    	jne    802351 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	83 c0 08             	add    $0x8,%eax
  802678:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80267b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802682:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802685:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802688:	01 d0                	add    %edx,%eax
  80268a:	48                   	dec    %eax
  80268b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80268e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802691:	ba 00 00 00 00       	mov    $0x0,%edx
  802696:	f7 75 d8             	divl   -0x28(%ebp)
  802699:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80269c:	29 d0                	sub    %edx,%eax
  80269e:	c1 e8 0c             	shr    $0xc,%eax
  8026a1:	83 ec 0c             	sub    $0xc,%esp
  8026a4:	50                   	push   %eax
  8026a5:	e8 76 ed ff ff       	call   801420 <sbrk>
  8026aa:	83 c4 10             	add    $0x10,%esp
  8026ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026b0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026b4:	75 0a                	jne    8026c0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bb:	e9 8b 00 00 00       	jmp    80274b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026c0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026cd:	01 d0                	add    %edx,%eax
  8026cf:	48                   	dec    %eax
  8026d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026db:	f7 75 cc             	divl   -0x34(%ebp)
  8026de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e1:	29 d0                	sub    %edx,%eax
  8026e3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026e9:	01 d0                	add    %edx,%eax
  8026eb:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026fb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802705:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802708:	01 d0                	add    %edx,%eax
  80270a:	48                   	dec    %eax
  80270b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80270e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802711:	ba 00 00 00 00       	mov    $0x0,%edx
  802716:	f7 75 c4             	divl   -0x3c(%ebp)
  802719:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80271c:	29 d0                	sub    %edx,%eax
  80271e:	83 ec 04             	sub    $0x4,%esp
  802721:	6a 01                	push   $0x1
  802723:	50                   	push   %eax
  802724:	ff 75 d0             	pushl  -0x30(%ebp)
  802727:	e8 36 fb ff ff       	call   802262 <set_block_data>
  80272c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80272f:	83 ec 0c             	sub    $0xc,%esp
  802732:	ff 75 d0             	pushl  -0x30(%ebp)
  802735:	e8 1b 0a 00 00       	call   803155 <free_block>
  80273a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	ff 75 08             	pushl  0x8(%ebp)
  802743:	e8 49 fb ff ff       	call   802291 <alloc_block_FF>
  802748:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	83 e0 01             	and    $0x1,%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 03                	je     802760 <alloc_block_BF+0x13>
  80275d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802760:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802764:	77 07                	ja     80276d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802766:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80276d:	a1 24 50 80 00       	mov    0x805024,%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	75 73                	jne    8027e9 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	83 c0 10             	add    $0x10,%eax
  80277c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80277f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802786:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278c:	01 d0                	add    %edx,%eax
  80278e:	48                   	dec    %eax
  80278f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802792:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802795:	ba 00 00 00 00       	mov    $0x0,%edx
  80279a:	f7 75 e0             	divl   -0x20(%ebp)
  80279d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027a0:	29 d0                	sub    %edx,%eax
  8027a2:	c1 e8 0c             	shr    $0xc,%eax
  8027a5:	83 ec 0c             	sub    $0xc,%esp
  8027a8:	50                   	push   %eax
  8027a9:	e8 72 ec ff ff       	call   801420 <sbrk>
  8027ae:	83 c4 10             	add    $0x10,%esp
  8027b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027b4:	83 ec 0c             	sub    $0xc,%esp
  8027b7:	6a 00                	push   $0x0
  8027b9:	e8 62 ec ff ff       	call   801420 <sbrk>
  8027be:	83 c4 10             	add    $0x10,%esp
  8027c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027ca:	83 ec 08             	sub    $0x8,%esp
  8027cd:	50                   	push   %eax
  8027ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8027d1:	e8 9f f8 ff ff       	call   802075 <initialize_dynamic_allocator>
  8027d6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027d9:	83 ec 0c             	sub    $0xc,%esp
  8027dc:	68 83 44 80 00       	push   $0x804483
  8027e1:	e8 a0 de ff ff       	call   800686 <cprintf>
  8027e6:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027f7:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802805:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280d:	e9 1d 01 00 00       	jmp    80292f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	ff 75 a8             	pushl  -0x58(%ebp)
  80281e:	e8 ee f6 ff ff       	call   801f11 <get_block_size>
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	83 c0 08             	add    $0x8,%eax
  80282f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802832:	0f 87 ef 00 00 00    	ja     802927 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	83 c0 18             	add    $0x18,%eax
  80283e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802841:	77 1d                	ja     802860 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802846:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802849:	0f 86 d8 00 00 00    	jbe    802927 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80284f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802852:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802855:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802858:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80285b:	e9 c7 00 00 00       	jmp    802927 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	83 c0 08             	add    $0x8,%eax
  802866:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802869:	0f 85 9d 00 00 00    	jne    80290c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80286f:	83 ec 04             	sub    $0x4,%esp
  802872:	6a 01                	push   $0x1
  802874:	ff 75 a4             	pushl  -0x5c(%ebp)
  802877:	ff 75 a8             	pushl  -0x58(%ebp)
  80287a:	e8 e3 f9 ff ff       	call   802262 <set_block_data>
  80287f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802886:	75 17                	jne    80289f <alloc_block_BF+0x152>
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	68 27 44 80 00       	push   $0x804427
  802890:	68 2c 01 00 00       	push   $0x12c
  802895:	68 45 44 80 00       	push   $0x804445
  80289a:	e8 0b 11 00 00       	call   8039aa <_panic>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 10                	je     8028b8 <alloc_block_BF+0x16b>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b0:	8b 52 04             	mov    0x4(%edx),%edx
  8028b3:	89 50 04             	mov    %edx,0x4(%eax)
  8028b6:	eb 0b                	jmp    8028c3 <alloc_block_BF+0x176>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 0f                	je     8028dc <alloc_block_BF+0x18f>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d6:	8b 12                	mov    (%edx),%edx
  8028d8:	89 10                	mov    %edx,(%eax)
  8028da:	eb 0a                	jmp    8028e6 <alloc_block_BF+0x199>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fe:	48                   	dec    %eax
  8028ff:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802904:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802907:	e9 24 04 00 00       	jmp    802d30 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80290c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802912:	76 13                	jbe    802927 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802914:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80291b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80291e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802921:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802924:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802927:	a1 34 50 80 00       	mov    0x805034,%eax
  80292c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	74 07                	je     80293c <alloc_block_BF+0x1ef>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	eb 05                	jmp    802941 <alloc_block_BF+0x1f4>
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
  802941:	a3 34 50 80 00       	mov    %eax,0x805034
  802946:	a1 34 50 80 00       	mov    0x805034,%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	0f 85 bf fe ff ff    	jne    802812 <alloc_block_BF+0xc5>
  802953:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802957:	0f 85 b5 fe ff ff    	jne    802812 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80295d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802961:	0f 84 26 02 00 00    	je     802b8d <alloc_block_BF+0x440>
  802967:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296b:	0f 85 1c 02 00 00    	jne    802b8d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	2b 45 08             	sub    0x8(%ebp),%eax
  802977:	83 e8 08             	sub    $0x8,%eax
  80297a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8d 50 08             	lea    0x8(%eax),%edx
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	01 d0                	add    %edx,%eax
  802988:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	83 c0 08             	add    $0x8,%eax
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	6a 01                	push   $0x1
  802996:	50                   	push   %eax
  802997:	ff 75 f0             	pushl  -0x10(%ebp)
  80299a:	e8 c3 f8 ff ff       	call   802262 <set_block_data>
  80299f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	75 68                	jne    802a14 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ac:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029b0:	75 17                	jne    8029c9 <alloc_block_BF+0x27c>
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	68 60 44 80 00       	push   $0x804460
  8029ba:	68 45 01 00 00       	push   $0x145
  8029bf:	68 45 44 80 00       	push   $0x804445
  8029c4:	e8 e1 0f 00 00       	call   8039aa <_panic>
  8029c9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d2:	89 10                	mov    %edx,(%eax)
  8029d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0d                	je     8029ea <alloc_block_BF+0x29d>
  8029dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e5:	89 50 04             	mov    %edx,0x4(%eax)
  8029e8:	eb 08                	jmp    8029f2 <alloc_block_BF+0x2a5>
  8029ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a04:	a1 38 50 80 00       	mov    0x805038,%eax
  802a09:	40                   	inc    %eax
  802a0a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a0f:	e9 dc 00 00 00       	jmp    802af0 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 65                	jne    802a82 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a21:	75 17                	jne    802a3a <alloc_block_BF+0x2ed>
  802a23:	83 ec 04             	sub    $0x4,%esp
  802a26:	68 94 44 80 00       	push   $0x804494
  802a2b:	68 4a 01 00 00       	push   $0x14a
  802a30:	68 45 44 80 00       	push   $0x804445
  802a35:	e8 70 0f 00 00       	call   8039aa <_panic>
  802a3a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a43:	89 50 04             	mov    %edx,0x4(%eax)
  802a46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	74 0c                	je     802a5c <alloc_block_BF+0x30f>
  802a50:	a1 30 50 80 00       	mov    0x805030,%eax
  802a55:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a58:	89 10                	mov    %edx,(%eax)
  802a5a:	eb 08                	jmp    802a64 <alloc_block_BF+0x317>
  802a5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a67:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a75:	a1 38 50 80 00       	mov    0x805038,%eax
  802a7a:	40                   	inc    %eax
  802a7b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a80:	eb 6e                	jmp    802af0 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a86:	74 06                	je     802a8e <alloc_block_BF+0x341>
  802a88:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a8c:	75 17                	jne    802aa5 <alloc_block_BF+0x358>
  802a8e:	83 ec 04             	sub    $0x4,%esp
  802a91:	68 b8 44 80 00       	push   $0x8044b8
  802a96:	68 4f 01 00 00       	push   $0x14f
  802a9b:	68 45 44 80 00       	push   $0x804445
  802aa0:	e8 05 0f 00 00       	call   8039aa <_panic>
  802aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa8:	8b 10                	mov    (%eax),%edx
  802aaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aad:	89 10                	mov    %edx,(%eax)
  802aaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	74 0b                	je     802ac3 <alloc_block_BF+0x376>
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ac9:	89 10                	mov    %edx,(%eax)
  802acb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad1:	89 50 04             	mov    %edx,0x4(%eax)
  802ad4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	75 08                	jne    802ae5 <alloc_block_BF+0x398>
  802add:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae5:	a1 38 50 80 00       	mov    0x805038,%eax
  802aea:	40                   	inc    %eax
  802aeb:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802af0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af4:	75 17                	jne    802b0d <alloc_block_BF+0x3c0>
  802af6:	83 ec 04             	sub    $0x4,%esp
  802af9:	68 27 44 80 00       	push   $0x804427
  802afe:	68 51 01 00 00       	push   $0x151
  802b03:	68 45 44 80 00       	push   $0x804445
  802b08:	e8 9d 0e 00 00       	call   8039aa <_panic>
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	74 10                	je     802b26 <alloc_block_BF+0x3d9>
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1e:	8b 52 04             	mov    0x4(%edx),%edx
  802b21:	89 50 04             	mov    %edx,0x4(%eax)
  802b24:	eb 0b                	jmp    802b31 <alloc_block_BF+0x3e4>
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	74 0f                	je     802b4a <alloc_block_BF+0x3fd>
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b44:	8b 12                	mov    (%edx),%edx
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	eb 0a                	jmp    802b54 <alloc_block_BF+0x407>
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b67:	a1 38 50 80 00       	mov    0x805038,%eax
  802b6c:	48                   	dec    %eax
  802b6d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	6a 00                	push   $0x0
  802b77:	ff 75 d0             	pushl  -0x30(%ebp)
  802b7a:	ff 75 cc             	pushl  -0x34(%ebp)
  802b7d:	e8 e0 f6 ff ff       	call   802262 <set_block_data>
  802b82:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	e9 a3 01 00 00       	jmp    802d30 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b8d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b91:	0f 85 9d 00 00 00    	jne    802c34 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b97:	83 ec 04             	sub    $0x4,%esp
  802b9a:	6a 01                	push   $0x1
  802b9c:	ff 75 ec             	pushl  -0x14(%ebp)
  802b9f:	ff 75 f0             	pushl  -0x10(%ebp)
  802ba2:	e8 bb f6 ff ff       	call   802262 <set_block_data>
  802ba7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802baa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bae:	75 17                	jne    802bc7 <alloc_block_BF+0x47a>
  802bb0:	83 ec 04             	sub    $0x4,%esp
  802bb3:	68 27 44 80 00       	push   $0x804427
  802bb8:	68 58 01 00 00       	push   $0x158
  802bbd:	68 45 44 80 00       	push   $0x804445
  802bc2:	e8 e3 0d 00 00       	call   8039aa <_panic>
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 10                	je     802be0 <alloc_block_BF+0x493>
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd8:	8b 52 04             	mov    0x4(%edx),%edx
  802bdb:	89 50 04             	mov    %edx,0x4(%eax)
  802bde:	eb 0b                	jmp    802beb <alloc_block_BF+0x49e>
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	a3 30 50 80 00       	mov    %eax,0x805030
  802beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	74 0f                	je     802c04 <alloc_block_BF+0x4b7>
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfe:	8b 12                	mov    (%edx),%edx
  802c00:	89 10                	mov    %edx,(%eax)
  802c02:	eb 0a                	jmp    802c0e <alloc_block_BF+0x4c1>
  802c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c21:	a1 38 50 80 00       	mov    0x805038,%eax
  802c26:	48                   	dec    %eax
  802c27:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	e9 fc 00 00 00       	jmp    802d30 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	83 c0 08             	add    $0x8,%eax
  802c3a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c3d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c44:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c4a:	01 d0                	add    %edx,%eax
  802c4c:	48                   	dec    %eax
  802c4d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c53:	ba 00 00 00 00       	mov    $0x0,%edx
  802c58:	f7 75 c4             	divl   -0x3c(%ebp)
  802c5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c5e:	29 d0                	sub    %edx,%eax
  802c60:	c1 e8 0c             	shr    $0xc,%eax
  802c63:	83 ec 0c             	sub    $0xc,%esp
  802c66:	50                   	push   %eax
  802c67:	e8 b4 e7 ff ff       	call   801420 <sbrk>
  802c6c:	83 c4 10             	add    $0x10,%esp
  802c6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c72:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c76:	75 0a                	jne    802c82 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7d:	e9 ae 00 00 00       	jmp    802d30 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c82:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c8f:	01 d0                	add    %edx,%eax
  802c91:	48                   	dec    %eax
  802c92:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c98:	ba 00 00 00 00       	mov    $0x0,%edx
  802c9d:	f7 75 b8             	divl   -0x48(%ebp)
  802ca0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca3:	29 d0                	sub    %edx,%eax
  802ca5:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ca8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cab:	01 d0                	add    %edx,%eax
  802cad:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cb2:	a1 40 50 80 00       	mov    0x805040,%eax
  802cb7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cbd:	83 ec 0c             	sub    $0xc,%esp
  802cc0:	68 ec 44 80 00       	push   $0x8044ec
  802cc5:	e8 bc d9 ff ff       	call   800686 <cprintf>
  802cca:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ccd:	83 ec 08             	sub    $0x8,%esp
  802cd0:	ff 75 bc             	pushl  -0x44(%ebp)
  802cd3:	68 f1 44 80 00       	push   $0x8044f1
  802cd8:	e8 a9 d9 ff ff       	call   800686 <cprintf>
  802cdd:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ce0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ce7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ced:	01 d0                	add    %edx,%eax
  802cef:	48                   	dec    %eax
  802cf0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cf3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfb:	f7 75 b0             	divl   -0x50(%ebp)
  802cfe:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d01:	29 d0                	sub    %edx,%eax
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	6a 01                	push   $0x1
  802d08:	50                   	push   %eax
  802d09:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0c:	e8 51 f5 ff ff       	call   802262 <set_block_data>
  802d11:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d14:	83 ec 0c             	sub    $0xc,%esp
  802d17:	ff 75 bc             	pushl  -0x44(%ebp)
  802d1a:	e8 36 04 00 00       	call   803155 <free_block>
  802d1f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d22:	83 ec 0c             	sub    $0xc,%esp
  802d25:	ff 75 08             	pushl  0x8(%ebp)
  802d28:	e8 20 fa ff ff       	call   80274d <alloc_block_BF>
  802d2d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d30:	c9                   	leave  
  802d31:	c3                   	ret    

00802d32 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d32:	55                   	push   %ebp
  802d33:	89 e5                	mov    %esp,%ebp
  802d35:	53                   	push   %ebx
  802d36:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4b:	74 1e                	je     802d6b <merging+0x39>
  802d4d:	ff 75 08             	pushl  0x8(%ebp)
  802d50:	e8 bc f1 ff ff       	call   801f11 <get_block_size>
  802d55:	83 c4 04             	add    $0x4,%esp
  802d58:	89 c2                	mov    %eax,%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	01 d0                	add    %edx,%eax
  802d5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d62:	75 07                	jne    802d6b <merging+0x39>
		prev_is_free = 1;
  802d64:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d6f:	74 1e                	je     802d8f <merging+0x5d>
  802d71:	ff 75 10             	pushl  0x10(%ebp)
  802d74:	e8 98 f1 ff ff       	call   801f11 <get_block_size>
  802d79:	83 c4 04             	add    $0x4,%esp
  802d7c:	89 c2                	mov    %eax,%edx
  802d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d81:	01 d0                	add    %edx,%eax
  802d83:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d86:	75 07                	jne    802d8f <merging+0x5d>
		next_is_free = 1;
  802d88:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	0f 84 cc 00 00 00    	je     802e65 <merging+0x133>
  802d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9d:	0f 84 c2 00 00 00    	je     802e65 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802da3:	ff 75 08             	pushl  0x8(%ebp)
  802da6:	e8 66 f1 ff ff       	call   801f11 <get_block_size>
  802dab:	83 c4 04             	add    $0x4,%esp
  802dae:	89 c3                	mov    %eax,%ebx
  802db0:	ff 75 10             	pushl  0x10(%ebp)
  802db3:	e8 59 f1 ff ff       	call   801f11 <get_block_size>
  802db8:	83 c4 04             	add    $0x4,%esp
  802dbb:	01 c3                	add    %eax,%ebx
  802dbd:	ff 75 0c             	pushl  0xc(%ebp)
  802dc0:	e8 4c f1 ff ff       	call   801f11 <get_block_size>
  802dc5:	83 c4 04             	add    $0x4,%esp
  802dc8:	01 d8                	add    %ebx,%eax
  802dca:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dcd:	6a 00                	push   $0x0
  802dcf:	ff 75 ec             	pushl  -0x14(%ebp)
  802dd2:	ff 75 08             	pushl  0x8(%ebp)
  802dd5:	e8 88 f4 ff ff       	call   802262 <set_block_data>
  802dda:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ddd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de1:	75 17                	jne    802dfa <merging+0xc8>
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 27 44 80 00       	push   $0x804427
  802deb:	68 7d 01 00 00       	push   $0x17d
  802df0:	68 45 44 80 00       	push   $0x804445
  802df5:	e8 b0 0b 00 00       	call   8039aa <_panic>
  802dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 10                	je     802e13 <merging+0xe1>
  802e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0b:	8b 52 04             	mov    0x4(%edx),%edx
  802e0e:	89 50 04             	mov    %edx,0x4(%eax)
  802e11:	eb 0b                	jmp    802e1e <merging+0xec>
  802e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 0f                	je     802e37 <merging+0x105>
  802e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e31:	8b 12                	mov    (%edx),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	eb 0a                	jmp    802e41 <merging+0x10f>
  802e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e54:	a1 38 50 80 00       	mov    0x805038,%eax
  802e59:	48                   	dec    %eax
  802e5a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e5f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e60:	e9 ea 02 00 00       	jmp    80314f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e69:	74 3b                	je     802ea6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e6b:	83 ec 0c             	sub    $0xc,%esp
  802e6e:	ff 75 08             	pushl  0x8(%ebp)
  802e71:	e8 9b f0 ff ff       	call   801f11 <get_block_size>
  802e76:	83 c4 10             	add    $0x10,%esp
  802e79:	89 c3                	mov    %eax,%ebx
  802e7b:	83 ec 0c             	sub    $0xc,%esp
  802e7e:	ff 75 10             	pushl  0x10(%ebp)
  802e81:	e8 8b f0 ff ff       	call   801f11 <get_block_size>
  802e86:	83 c4 10             	add    $0x10,%esp
  802e89:	01 d8                	add    %ebx,%eax
  802e8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e8e:	83 ec 04             	sub    $0x4,%esp
  802e91:	6a 00                	push   $0x0
  802e93:	ff 75 e8             	pushl  -0x18(%ebp)
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	e8 c4 f3 ff ff       	call   802262 <set_block_data>
  802e9e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ea1:	e9 a9 02 00 00       	jmp    80314f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eaa:	0f 84 2d 01 00 00    	je     802fdd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802eb0:	83 ec 0c             	sub    $0xc,%esp
  802eb3:	ff 75 10             	pushl  0x10(%ebp)
  802eb6:	e8 56 f0 ff ff       	call   801f11 <get_block_size>
  802ebb:	83 c4 10             	add    $0x10,%esp
  802ebe:	89 c3                	mov    %eax,%ebx
  802ec0:	83 ec 0c             	sub    $0xc,%esp
  802ec3:	ff 75 0c             	pushl  0xc(%ebp)
  802ec6:	e8 46 f0 ff ff       	call   801f11 <get_block_size>
  802ecb:	83 c4 10             	add    $0x10,%esp
  802ece:	01 d8                	add    %ebx,%eax
  802ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ed3:	83 ec 04             	sub    $0x4,%esp
  802ed6:	6a 00                	push   $0x0
  802ed8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802edb:	ff 75 10             	pushl  0x10(%ebp)
  802ede:	e8 7f f3 ff ff       	call   802262 <set_block_data>
  802ee3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802eec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef0:	74 06                	je     802ef8 <merging+0x1c6>
  802ef2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ef6:	75 17                	jne    802f0f <merging+0x1dd>
  802ef8:	83 ec 04             	sub    $0x4,%esp
  802efb:	68 00 45 80 00       	push   $0x804500
  802f00:	68 8d 01 00 00       	push   $0x18d
  802f05:	68 45 44 80 00       	push   $0x804445
  802f0a:	e8 9b 0a 00 00       	call   8039aa <_panic>
  802f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f12:	8b 50 04             	mov    0x4(%eax),%edx
  802f15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f18:	89 50 04             	mov    %edx,0x4(%eax)
  802f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0d                	je     802f3a <merging+0x208>
  802f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	eb 08                	jmp    802f42 <merging+0x210>
  802f3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f50:	40                   	inc    %eax
  802f51:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f5a:	75 17                	jne    802f73 <merging+0x241>
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	68 27 44 80 00       	push   $0x804427
  802f64:	68 8e 01 00 00       	push   $0x18e
  802f69:	68 45 44 80 00       	push   $0x804445
  802f6e:	e8 37 0a 00 00       	call   8039aa <_panic>
  802f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	74 10                	je     802f8c <merging+0x25a>
  802f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f84:	8b 52 04             	mov    0x4(%edx),%edx
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	eb 0b                	jmp    802f97 <merging+0x265>
  802f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	a3 30 50 80 00       	mov    %eax,0x805030
  802f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	74 0f                	je     802fb0 <merging+0x27e>
  802fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802faa:	8b 12                	mov    (%edx),%edx
  802fac:	89 10                	mov    %edx,(%eax)
  802fae:	eb 0a                	jmp    802fba <merging+0x288>
  802fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcd:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd2:	48                   	dec    %eax
  802fd3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fd8:	e9 72 01 00 00       	jmp    80314f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  802fe0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fe3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe7:	74 79                	je     803062 <merging+0x330>
  802fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fed:	74 73                	je     803062 <merging+0x330>
  802fef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff3:	74 06                	je     802ffb <merging+0x2c9>
  802ff5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ff9:	75 17                	jne    803012 <merging+0x2e0>
  802ffb:	83 ec 04             	sub    $0x4,%esp
  802ffe:	68 b8 44 80 00       	push   $0x8044b8
  803003:	68 94 01 00 00       	push   $0x194
  803008:	68 45 44 80 00       	push   $0x804445
  80300d:	e8 98 09 00 00       	call   8039aa <_panic>
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 10                	mov    (%eax),%edx
  803017:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0b                	je     803030 <merging+0x2fe>
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803036:	89 10                	mov    %edx,(%eax)
  803038:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303b:	8b 55 08             	mov    0x8(%ebp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	75 08                	jne    803052 <merging+0x320>
  80304a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304d:	a3 30 50 80 00       	mov    %eax,0x805030
  803052:	a1 38 50 80 00       	mov    0x805038,%eax
  803057:	40                   	inc    %eax
  803058:	a3 38 50 80 00       	mov    %eax,0x805038
  80305d:	e9 ce 00 00 00       	jmp    803130 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803066:	74 65                	je     8030cd <merging+0x39b>
  803068:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80306c:	75 17                	jne    803085 <merging+0x353>
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	68 94 44 80 00       	push   $0x804494
  803076:	68 95 01 00 00       	push   $0x195
  80307b:	68 45 44 80 00       	push   $0x804445
  803080:	e8 25 09 00 00       	call   8039aa <_panic>
  803085:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80308b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803094:	8b 40 04             	mov    0x4(%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 0c                	je     8030a7 <merging+0x375>
  80309b:	a1 30 50 80 00       	mov    0x805030,%eax
  8030a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a3:	89 10                	mov    %edx,(%eax)
  8030a5:	eb 08                	jmp    8030af <merging+0x37d>
  8030a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c5:	40                   	inc    %eax
  8030c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8030cb:	eb 63                	jmp    803130 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030d1:	75 17                	jne    8030ea <merging+0x3b8>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 60 44 80 00       	push   $0x804460
  8030db:	68 98 01 00 00       	push   $0x198
  8030e0:	68 45 44 80 00       	push   $0x804445
  8030e5:	e8 c0 08 00 00       	call   8039aa <_panic>
  8030ea:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0d                	je     80310b <merging+0x3d9>
  8030fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803103:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 08                	jmp    803113 <merging+0x3e1>
  80310b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310e:	a3 30 50 80 00       	mov    %eax,0x805030
  803113:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803116:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 38 50 80 00       	mov    0x805038,%eax
  80312a:	40                   	inc    %eax
  80312b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803130:	83 ec 0c             	sub    $0xc,%esp
  803133:	ff 75 10             	pushl  0x10(%ebp)
  803136:	e8 d6 ed ff ff       	call   801f11 <get_block_size>
  80313b:	83 c4 10             	add    $0x10,%esp
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	6a 00                	push   $0x0
  803143:	50                   	push   %eax
  803144:	ff 75 10             	pushl  0x10(%ebp)
  803147:	e8 16 f1 ff ff       	call   802262 <set_block_data>
  80314c:	83 c4 10             	add    $0x10,%esp
	}
}
  80314f:	90                   	nop
  803150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803153:	c9                   	leave  
  803154:	c3                   	ret    

00803155 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803155:	55                   	push   %ebp
  803156:	89 e5                	mov    %esp,%ebp
  803158:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80315b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803160:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803163:	a1 30 50 80 00       	mov    0x805030,%eax
  803168:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316b:	73 1b                	jae    803188 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80316d:	a1 30 50 80 00       	mov    0x805030,%eax
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	6a 00                	push   $0x0
  80317a:	50                   	push   %eax
  80317b:	e8 b2 fb ff ff       	call   802d32 <merging>
  803180:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803183:	e9 8b 00 00 00       	jmp    803213 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803188:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80318d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803190:	76 18                	jbe    8031aa <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803192:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	ff 75 08             	pushl  0x8(%ebp)
  80319d:	50                   	push   %eax
  80319e:	6a 00                	push   $0x0
  8031a0:	e8 8d fb ff ff       	call   802d32 <merging>
  8031a5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031a8:	eb 69                	jmp    803213 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b2:	eb 39                	jmp    8031ed <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ba:	73 29                	jae    8031e5 <free_block+0x90>
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c4:	76 1f                	jbe    8031e5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031ce:	83 ec 04             	sub    $0x4,%esp
  8031d1:	ff 75 08             	pushl  0x8(%ebp)
  8031d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031da:	e8 53 fb ff ff       	call   802d32 <merging>
  8031df:	83 c4 10             	add    $0x10,%esp
			break;
  8031e2:	90                   	nop
		}
	}
}
  8031e3:	eb 2e                	jmp    803213 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031e5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f1:	74 07                	je     8031fa <free_block+0xa5>
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	eb 05                	jmp    8031ff <free_block+0xaa>
  8031fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ff:	a3 34 50 80 00       	mov    %eax,0x805034
  803204:	a1 34 50 80 00       	mov    0x805034,%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	75 a7                	jne    8031b4 <free_block+0x5f>
  80320d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803211:	75 a1                	jne    8031b4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803213:	90                   	nop
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80321c:	ff 75 08             	pushl  0x8(%ebp)
  80321f:	e8 ed ec ff ff       	call   801f11 <get_block_size>
  803224:	83 c4 04             	add    $0x4,%esp
  803227:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80322a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803231:	eb 17                	jmp    80324a <copy_data+0x34>
  803233:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803236:	8b 45 0c             	mov    0xc(%ebp),%eax
  803239:	01 c2                	add    %eax,%edx
  80323b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	01 c8                	add    %ecx,%eax
  803243:	8a 00                	mov    (%eax),%al
  803245:	88 02                	mov    %al,(%edx)
  803247:	ff 45 fc             	incl   -0x4(%ebp)
  80324a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80324d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803250:	72 e1                	jb     803233 <copy_data+0x1d>
}
  803252:	90                   	nop
  803253:	c9                   	leave  
  803254:	c3                   	ret    

00803255 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803255:	55                   	push   %ebp
  803256:	89 e5                	mov    %esp,%ebp
  803258:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80325b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325f:	75 23                	jne    803284 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803265:	74 13                	je     80327a <realloc_block_FF+0x25>
  803267:	83 ec 0c             	sub    $0xc,%esp
  80326a:	ff 75 0c             	pushl  0xc(%ebp)
  80326d:	e8 1f f0 ff ff       	call   802291 <alloc_block_FF>
  803272:	83 c4 10             	add    $0x10,%esp
  803275:	e9 f4 06 00 00       	jmp    80396e <realloc_block_FF+0x719>
		return NULL;
  80327a:	b8 00 00 00 00       	mov    $0x0,%eax
  80327f:	e9 ea 06 00 00       	jmp    80396e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803284:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803288:	75 18                	jne    8032a2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80328a:	83 ec 0c             	sub    $0xc,%esp
  80328d:	ff 75 08             	pushl  0x8(%ebp)
  803290:	e8 c0 fe ff ff       	call   803155 <free_block>
  803295:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803298:	b8 00 00 00 00       	mov    $0x0,%eax
  80329d:	e9 cc 06 00 00       	jmp    80396e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032a2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032a6:	77 07                	ja     8032af <realloc_block_FF+0x5a>
  8032a8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b2:	83 e0 01             	and    $0x1,%eax
  8032b5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bb:	83 c0 08             	add    $0x8,%eax
  8032be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032c1:	83 ec 0c             	sub    $0xc,%esp
  8032c4:	ff 75 08             	pushl  0x8(%ebp)
  8032c7:	e8 45 ec ff ff       	call   801f11 <get_block_size>
  8032cc:	83 c4 10             	add    $0x10,%esp
  8032cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d5:	83 e8 08             	sub    $0x8,%eax
  8032d8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	83 e8 04             	sub    $0x4,%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	83 e0 fe             	and    $0xfffffffe,%eax
  8032e6:	89 c2                	mov    %eax,%edx
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	01 d0                	add    %edx,%eax
  8032ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032f0:	83 ec 0c             	sub    $0xc,%esp
  8032f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032f6:	e8 16 ec ff ff       	call   801f11 <get_block_size>
  8032fb:	83 c4 10             	add    $0x10,%esp
  8032fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803301:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803304:	83 e8 08             	sub    $0x8,%eax
  803307:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803310:	75 08                	jne    80331a <realloc_block_FF+0xc5>
	{
		 return va;
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	e9 54 06 00 00       	jmp    80396e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80331a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803320:	0f 83 e5 03 00 00    	jae    80370b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	2b 45 0c             	sub    0xc(%ebp),%eax
  80332c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80332f:	83 ec 0c             	sub    $0xc,%esp
  803332:	ff 75 e4             	pushl  -0x1c(%ebp)
  803335:	e8 f0 eb ff ff       	call   801f2a <is_free_block>
  80333a:	83 c4 10             	add    $0x10,%esp
  80333d:	84 c0                	test   %al,%al
  80333f:	0f 84 3b 01 00 00    	je     803480 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803345:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803348:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80334b:	01 d0                	add    %edx,%eax
  80334d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	6a 01                	push   $0x1
  803355:	ff 75 f0             	pushl  -0x10(%ebp)
  803358:	ff 75 08             	pushl  0x8(%ebp)
  80335b:	e8 02 ef ff ff       	call   802262 <set_block_data>
  803360:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	83 e8 04             	sub    $0x4,%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	83 e0 fe             	and    $0xfffffffe,%eax
  80336e:	89 c2                	mov    %eax,%edx
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	01 d0                	add    %edx,%eax
  803375:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803378:	83 ec 04             	sub    $0x4,%esp
  80337b:	6a 00                	push   $0x0
  80337d:	ff 75 cc             	pushl  -0x34(%ebp)
  803380:	ff 75 c8             	pushl  -0x38(%ebp)
  803383:	e8 da ee ff ff       	call   802262 <set_block_data>
  803388:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80338b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80338f:	74 06                	je     803397 <realloc_block_FF+0x142>
  803391:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803395:	75 17                	jne    8033ae <realloc_block_FF+0x159>
  803397:	83 ec 04             	sub    $0x4,%esp
  80339a:	68 b8 44 80 00       	push   $0x8044b8
  80339f:	68 f6 01 00 00       	push   $0x1f6
  8033a4:	68 45 44 80 00       	push   $0x804445
  8033a9:	e8 fc 05 00 00       	call   8039aa <_panic>
  8033ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b1:	8b 10                	mov    (%eax),%edx
  8033b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b6:	89 10                	mov    %edx,(%eax)
  8033b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033bb:	8b 00                	mov    (%eax),%eax
  8033bd:	85 c0                	test   %eax,%eax
  8033bf:	74 0b                	je     8033cc <realloc_block_FF+0x177>
  8033c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c4:	8b 00                	mov    (%eax),%eax
  8033c6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033c9:	89 50 04             	mov    %edx,0x4(%eax)
  8033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033d2:	89 10                	mov    %edx,(%eax)
  8033d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033da:	89 50 04             	mov    %edx,0x4(%eax)
  8033dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	75 08                	jne    8033ee <realloc_block_FF+0x199>
  8033e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f3:	40                   	inc    %eax
  8033f4:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fd:	75 17                	jne    803416 <realloc_block_FF+0x1c1>
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	68 27 44 80 00       	push   $0x804427
  803407:	68 f7 01 00 00       	push   $0x1f7
  80340c:	68 45 44 80 00       	push   $0x804445
  803411:	e8 94 05 00 00       	call   8039aa <_panic>
  803416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 10                	je     80342f <realloc_block_FF+0x1da>
  80341f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803427:	8b 52 04             	mov    0x4(%edx),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	eb 0b                	jmp    80343a <realloc_block_FF+0x1e5>
  80342f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	a3 30 50 80 00       	mov    %eax,0x805030
  80343a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343d:	8b 40 04             	mov    0x4(%eax),%eax
  803440:	85 c0                	test   %eax,%eax
  803442:	74 0f                	je     803453 <realloc_block_FF+0x1fe>
  803444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344d:	8b 12                	mov    (%edx),%edx
  80344f:	89 10                	mov    %edx,(%eax)
  803451:	eb 0a                	jmp    80345d <realloc_block_FF+0x208>
  803453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80345d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803469:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803470:	a1 38 50 80 00       	mov    0x805038,%eax
  803475:	48                   	dec    %eax
  803476:	a3 38 50 80 00       	mov    %eax,0x805038
  80347b:	e9 83 02 00 00       	jmp    803703 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803480:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803484:	0f 86 69 02 00 00    	jbe    8036f3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80348a:	83 ec 04             	sub    $0x4,%esp
  80348d:	6a 01                	push   $0x1
  80348f:	ff 75 f0             	pushl  -0x10(%ebp)
  803492:	ff 75 08             	pushl  0x8(%ebp)
  803495:	e8 c8 ed ff ff       	call   802262 <set_block_data>
  80349a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	83 e8 04             	sub    $0x4,%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8034a8:	89 c2                	mov    %eax,%edx
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	01 d0                	add    %edx,%eax
  8034af:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034be:	75 68                	jne    803528 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c4:	75 17                	jne    8034dd <realloc_block_FF+0x288>
  8034c6:	83 ec 04             	sub    $0x4,%esp
  8034c9:	68 60 44 80 00       	push   $0x804460
  8034ce:	68 06 02 00 00       	push   $0x206
  8034d3:	68 45 44 80 00       	push   $0x804445
  8034d8:	e8 cd 04 00 00       	call   8039aa <_panic>
  8034dd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	89 10                	mov    %edx,(%eax)
  8034e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	74 0d                	je     8034fe <realloc_block_FF+0x2a9>
  8034f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034f9:	89 50 04             	mov    %edx,0x4(%eax)
  8034fc:	eb 08                	jmp    803506 <realloc_block_FF+0x2b1>
  8034fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803501:	a3 30 50 80 00       	mov    %eax,0x805030
  803506:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803509:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80350e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803511:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803518:	a1 38 50 80 00       	mov    0x805038,%eax
  80351d:	40                   	inc    %eax
  80351e:	a3 38 50 80 00       	mov    %eax,0x805038
  803523:	e9 b0 01 00 00       	jmp    8036d8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803528:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803530:	76 68                	jbe    80359a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803532:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803536:	75 17                	jne    80354f <realloc_block_FF+0x2fa>
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	68 60 44 80 00       	push   $0x804460
  803540:	68 0b 02 00 00       	push   $0x20b
  803545:	68 45 44 80 00       	push   $0x804445
  80354a:	e8 5b 04 00 00       	call   8039aa <_panic>
  80354f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803558:	89 10                	mov    %edx,(%eax)
  80355a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 0d                	je     803570 <realloc_block_FF+0x31b>
  803563:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803568:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80356b:	89 50 04             	mov    %edx,0x4(%eax)
  80356e:	eb 08                	jmp    803578 <realloc_block_FF+0x323>
  803570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803573:	a3 30 50 80 00       	mov    %eax,0x805030
  803578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358a:	a1 38 50 80 00       	mov    0x805038,%eax
  80358f:	40                   	inc    %eax
  803590:	a3 38 50 80 00       	mov    %eax,0x805038
  803595:	e9 3e 01 00 00       	jmp    8036d8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80359a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035a2:	73 68                	jae    80360c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a8:	75 17                	jne    8035c1 <realloc_block_FF+0x36c>
  8035aa:	83 ec 04             	sub    $0x4,%esp
  8035ad:	68 94 44 80 00       	push   $0x804494
  8035b2:	68 10 02 00 00       	push   $0x210
  8035b7:	68 45 44 80 00       	push   $0x804445
  8035bc:	e8 e9 03 00 00       	call   8039aa <_panic>
  8035c1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ca:	89 50 04             	mov    %edx,0x4(%eax)
  8035cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d0:	8b 40 04             	mov    0x4(%eax),%eax
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	74 0c                	je     8035e3 <realloc_block_FF+0x38e>
  8035d7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035df:	89 10                	mov    %edx,(%eax)
  8035e1:	eb 08                	jmp    8035eb <realloc_block_FF+0x396>
  8035e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803601:	40                   	inc    %eax
  803602:	a3 38 50 80 00       	mov    %eax,0x805038
  803607:	e9 cc 00 00 00       	jmp    8036d8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80360c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803613:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803618:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80361b:	e9 8a 00 00 00       	jmp    8036aa <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803623:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803626:	73 7a                	jae    8036a2 <realloc_block_FF+0x44d>
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803630:	73 70                	jae    8036a2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803636:	74 06                	je     80363e <realloc_block_FF+0x3e9>
  803638:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80363c:	75 17                	jne    803655 <realloc_block_FF+0x400>
  80363e:	83 ec 04             	sub    $0x4,%esp
  803641:	68 b8 44 80 00       	push   $0x8044b8
  803646:	68 1a 02 00 00       	push   $0x21a
  80364b:	68 45 44 80 00       	push   $0x804445
  803650:	e8 55 03 00 00       	call   8039aa <_panic>
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	8b 10                	mov    (%eax),%edx
  80365a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365d:	89 10                	mov    %edx,(%eax)
  80365f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	85 c0                	test   %eax,%eax
  803666:	74 0b                	je     803673 <realloc_block_FF+0x41e>
  803668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366b:	8b 00                	mov    (%eax),%eax
  80366d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803670:	89 50 04             	mov    %edx,0x4(%eax)
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803679:	89 10                	mov    %edx,(%eax)
  80367b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803681:	89 50 04             	mov    %edx,0x4(%eax)
  803684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	85 c0                	test   %eax,%eax
  80368b:	75 08                	jne    803695 <realloc_block_FF+0x440>
  80368d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803690:	a3 30 50 80 00       	mov    %eax,0x805030
  803695:	a1 38 50 80 00       	mov    0x805038,%eax
  80369a:	40                   	inc    %eax
  80369b:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036a0:	eb 36                	jmp    8036d8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ae:	74 07                	je     8036b7 <realloc_block_FF+0x462>
  8036b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b3:	8b 00                	mov    (%eax),%eax
  8036b5:	eb 05                	jmp    8036bc <realloc_block_FF+0x467>
  8036b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c1:	a1 34 50 80 00       	mov    0x805034,%eax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	0f 85 52 ff ff ff    	jne    803620 <realloc_block_FF+0x3cb>
  8036ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d2:	0f 85 48 ff ff ff    	jne    803620 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036d8:	83 ec 04             	sub    $0x4,%esp
  8036db:	6a 00                	push   $0x0
  8036dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8036e0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036e3:	e8 7a eb ff ff       	call   802262 <set_block_data>
  8036e8:	83 c4 10             	add    $0x10,%esp
				return va;
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	e9 7b 02 00 00       	jmp    80396e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036f3:	83 ec 0c             	sub    $0xc,%esp
  8036f6:	68 35 45 80 00       	push   $0x804535
  8036fb:	e8 86 cf ff ff       	call   800686 <cprintf>
  803700:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	e9 63 02 00 00       	jmp    80396e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80370b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803711:	0f 86 4d 02 00 00    	jbe    803964 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803717:	83 ec 0c             	sub    $0xc,%esp
  80371a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80371d:	e8 08 e8 ff ff       	call   801f2a <is_free_block>
  803722:	83 c4 10             	add    $0x10,%esp
  803725:	84 c0                	test   %al,%al
  803727:	0f 84 37 02 00 00    	je     803964 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80372d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803730:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803733:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803736:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803739:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80373c:	76 38                	jbe    803776 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80373e:	83 ec 0c             	sub    $0xc,%esp
  803741:	ff 75 08             	pushl  0x8(%ebp)
  803744:	e8 0c fa ff ff       	call   803155 <free_block>
  803749:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80374c:	83 ec 0c             	sub    $0xc,%esp
  80374f:	ff 75 0c             	pushl  0xc(%ebp)
  803752:	e8 3a eb ff ff       	call   802291 <alloc_block_FF>
  803757:	83 c4 10             	add    $0x10,%esp
  80375a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80375d:	83 ec 08             	sub    $0x8,%esp
  803760:	ff 75 c0             	pushl  -0x40(%ebp)
  803763:	ff 75 08             	pushl  0x8(%ebp)
  803766:	e8 ab fa ff ff       	call   803216 <copy_data>
  80376b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80376e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803771:	e9 f8 01 00 00       	jmp    80396e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803779:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80377c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80377f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803783:	0f 87 a0 00 00 00    	ja     803829 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80378d:	75 17                	jne    8037a6 <realloc_block_FF+0x551>
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	68 27 44 80 00       	push   $0x804427
  803797:	68 38 02 00 00       	push   $0x238
  80379c:	68 45 44 80 00       	push   $0x804445
  8037a1:	e8 04 02 00 00       	call   8039aa <_panic>
  8037a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 10                	je     8037bf <realloc_block_FF+0x56a>
  8037af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037b7:	8b 52 04             	mov    0x4(%edx),%edx
  8037ba:	89 50 04             	mov    %edx,0x4(%eax)
  8037bd:	eb 0b                	jmp    8037ca <realloc_block_FF+0x575>
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	8b 40 04             	mov    0x4(%eax),%eax
  8037c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8037ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cd:	8b 40 04             	mov    0x4(%eax),%eax
  8037d0:	85 c0                	test   %eax,%eax
  8037d2:	74 0f                	je     8037e3 <realloc_block_FF+0x58e>
  8037d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037dd:	8b 12                	mov    (%edx),%edx
  8037df:	89 10                	mov    %edx,(%eax)
  8037e1:	eb 0a                	jmp    8037ed <realloc_block_FF+0x598>
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803800:	a1 38 50 80 00       	mov    0x805038,%eax
  803805:	48                   	dec    %eax
  803806:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80380b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80380e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803811:	01 d0                	add    %edx,%eax
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	6a 01                	push   $0x1
  803818:	50                   	push   %eax
  803819:	ff 75 08             	pushl  0x8(%ebp)
  80381c:	e8 41 ea ff ff       	call   802262 <set_block_data>
  803821:	83 c4 10             	add    $0x10,%esp
  803824:	e9 36 01 00 00       	jmp    80395f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803829:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80382c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80382f:	01 d0                	add    %edx,%eax
  803831:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803834:	83 ec 04             	sub    $0x4,%esp
  803837:	6a 01                	push   $0x1
  803839:	ff 75 f0             	pushl  -0x10(%ebp)
  80383c:	ff 75 08             	pushl  0x8(%ebp)
  80383f:	e8 1e ea ff ff       	call   802262 <set_block_data>
  803844:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	83 e8 04             	sub    $0x4,%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	83 e0 fe             	and    $0xfffffffe,%eax
  803852:	89 c2                	mov    %eax,%edx
  803854:	8b 45 08             	mov    0x8(%ebp),%eax
  803857:	01 d0                	add    %edx,%eax
  803859:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80385c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803860:	74 06                	je     803868 <realloc_block_FF+0x613>
  803862:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803866:	75 17                	jne    80387f <realloc_block_FF+0x62a>
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	68 b8 44 80 00       	push   $0x8044b8
  803870:	68 44 02 00 00       	push   $0x244
  803875:	68 45 44 80 00       	push   $0x804445
  80387a:	e8 2b 01 00 00       	call   8039aa <_panic>
  80387f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803882:	8b 10                	mov    (%eax),%edx
  803884:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803887:	89 10                	mov    %edx,(%eax)
  803889:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80388c:	8b 00                	mov    (%eax),%eax
  80388e:	85 c0                	test   %eax,%eax
  803890:	74 0b                	je     80389d <realloc_block_FF+0x648>
  803892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803895:	8b 00                	mov    (%eax),%eax
  803897:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80389a:	89 50 04             	mov    %edx,0x4(%eax)
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038a3:	89 10                	mov    %edx,(%eax)
  8038a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ab:	89 50 04             	mov    %edx,0x4(%eax)
  8038ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	85 c0                	test   %eax,%eax
  8038b5:	75 08                	jne    8038bf <realloc_block_FF+0x66a>
  8038b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8038bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8038c4:	40                   	inc    %eax
  8038c5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ce:	75 17                	jne    8038e7 <realloc_block_FF+0x692>
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 27 44 80 00       	push   $0x804427
  8038d8:	68 45 02 00 00       	push   $0x245
  8038dd:	68 45 44 80 00       	push   $0x804445
  8038e2:	e8 c3 00 00 00       	call   8039aa <_panic>
  8038e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ea:	8b 00                	mov    (%eax),%eax
  8038ec:	85 c0                	test   %eax,%eax
  8038ee:	74 10                	je     803900 <realloc_block_FF+0x6ab>
  8038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f3:	8b 00                	mov    (%eax),%eax
  8038f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f8:	8b 52 04             	mov    0x4(%edx),%edx
  8038fb:	89 50 04             	mov    %edx,0x4(%eax)
  8038fe:	eb 0b                	jmp    80390b <realloc_block_FF+0x6b6>
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 40 04             	mov    0x4(%eax),%eax
  803906:	a3 30 50 80 00       	mov    %eax,0x805030
  80390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	85 c0                	test   %eax,%eax
  803913:	74 0f                	je     803924 <realloc_block_FF+0x6cf>
  803915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803918:	8b 40 04             	mov    0x4(%eax),%eax
  80391b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80391e:	8b 12                	mov    (%edx),%edx
  803920:	89 10                	mov    %edx,(%eax)
  803922:	eb 0a                	jmp    80392e <realloc_block_FF+0x6d9>
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803941:	a1 38 50 80 00       	mov    0x805038,%eax
  803946:	48                   	dec    %eax
  803947:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80394c:	83 ec 04             	sub    $0x4,%esp
  80394f:	6a 00                	push   $0x0
  803951:	ff 75 bc             	pushl  -0x44(%ebp)
  803954:	ff 75 b8             	pushl  -0x48(%ebp)
  803957:	e8 06 e9 ff ff       	call   802262 <set_block_data>
  80395c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80395f:	8b 45 08             	mov    0x8(%ebp),%eax
  803962:	eb 0a                	jmp    80396e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803964:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80396e:	c9                   	leave  
  80396f:	c3                   	ret    

00803970 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803970:	55                   	push   %ebp
  803971:	89 e5                	mov    %esp,%ebp
  803973:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803976:	83 ec 04             	sub    $0x4,%esp
  803979:	68 3c 45 80 00       	push   $0x80453c
  80397e:	68 58 02 00 00       	push   $0x258
  803983:	68 45 44 80 00       	push   $0x804445
  803988:	e8 1d 00 00 00       	call   8039aa <_panic>

0080398d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80398d:	55                   	push   %ebp
  80398e:	89 e5                	mov    %esp,%ebp
  803990:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803993:	83 ec 04             	sub    $0x4,%esp
  803996:	68 64 45 80 00       	push   $0x804564
  80399b:	68 61 02 00 00       	push   $0x261
  8039a0:	68 45 44 80 00       	push   $0x804445
  8039a5:	e8 00 00 00 00       	call   8039aa <_panic>

008039aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039aa:	55                   	push   %ebp
  8039ab:	89 e5                	mov    %esp,%ebp
  8039ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8039b3:	83 c0 04             	add    $0x4,%eax
  8039b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039b9:	a1 60 50 90 00       	mov    0x905060,%eax
  8039be:	85 c0                	test   %eax,%eax
  8039c0:	74 16                	je     8039d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039c2:	a1 60 50 90 00       	mov    0x905060,%eax
  8039c7:	83 ec 08             	sub    $0x8,%esp
  8039ca:	50                   	push   %eax
  8039cb:	68 8c 45 80 00       	push   $0x80458c
  8039d0:	e8 b1 cc ff ff       	call   800686 <cprintf>
  8039d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8039d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8039dd:	ff 75 0c             	pushl  0xc(%ebp)
  8039e0:	ff 75 08             	pushl  0x8(%ebp)
  8039e3:	50                   	push   %eax
  8039e4:	68 91 45 80 00       	push   $0x804591
  8039e9:	e8 98 cc ff ff       	call   800686 <cprintf>
  8039ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8039f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8039f4:	83 ec 08             	sub    $0x8,%esp
  8039f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8039fa:	50                   	push   %eax
  8039fb:	e8 1b cc ff ff       	call   80061b <vcprintf>
  803a00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a03:	83 ec 08             	sub    $0x8,%esp
  803a06:	6a 00                	push   $0x0
  803a08:	68 ad 45 80 00       	push   $0x8045ad
  803a0d:	e8 09 cc ff ff       	call   80061b <vcprintf>
  803a12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a15:	e8 8a cb ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  803a1a:	eb fe                	jmp    803a1a <_panic+0x70>

00803a1c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a1c:	55                   	push   %ebp
  803a1d:	89 e5                	mov    %esp,%ebp
  803a1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a22:	a1 20 50 80 00       	mov    0x805020,%eax
  803a27:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a30:	39 c2                	cmp    %eax,%edx
  803a32:	74 14                	je     803a48 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a34:	83 ec 04             	sub    $0x4,%esp
  803a37:	68 b0 45 80 00       	push   $0x8045b0
  803a3c:	6a 26                	push   $0x26
  803a3e:	68 fc 45 80 00       	push   $0x8045fc
  803a43:	e8 62 ff ff ff       	call   8039aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a56:	e9 c5 00 00 00       	jmp    803b20 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a65:	8b 45 08             	mov    0x8(%ebp),%eax
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	8b 00                	mov    (%eax),%eax
  803a6c:	85 c0                	test   %eax,%eax
  803a6e:	75 08                	jne    803a78 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a70:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a73:	e9 a5 00 00 00       	jmp    803b1d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a86:	eb 69                	jmp    803af1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a88:	a1 20 50 80 00       	mov    0x805020,%eax
  803a8d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a96:	89 d0                	mov    %edx,%eax
  803a98:	01 c0                	add    %eax,%eax
  803a9a:	01 d0                	add    %edx,%eax
  803a9c:	c1 e0 03             	shl    $0x3,%eax
  803a9f:	01 c8                	add    %ecx,%eax
  803aa1:	8a 40 04             	mov    0x4(%eax),%al
  803aa4:	84 c0                	test   %al,%al
  803aa6:	75 46                	jne    803aee <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803aa8:	a1 20 50 80 00       	mov    0x805020,%eax
  803aad:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ab3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab6:	89 d0                	mov    %edx,%eax
  803ab8:	01 c0                	add    %eax,%eax
  803aba:	01 d0                	add    %edx,%eax
  803abc:	c1 e0 03             	shl    $0x3,%eax
  803abf:	01 c8                	add    %ecx,%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ac6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803ace:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803ada:	8b 45 08             	mov    0x8(%ebp),%eax
  803add:	01 c8                	add    %ecx,%eax
  803adf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ae1:	39 c2                	cmp    %eax,%edx
  803ae3:	75 09                	jne    803aee <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803ae5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803aec:	eb 15                	jmp    803b03 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803aee:	ff 45 e8             	incl   -0x18(%ebp)
  803af1:	a1 20 50 80 00       	mov    0x805020,%eax
  803af6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aff:	39 c2                	cmp    %eax,%edx
  803b01:	77 85                	ja     803a88 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b07:	75 14                	jne    803b1d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	68 08 46 80 00       	push   $0x804608
  803b11:	6a 3a                	push   $0x3a
  803b13:	68 fc 45 80 00       	push   $0x8045fc
  803b18:	e8 8d fe ff ff       	call   8039aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b1d:	ff 45 f0             	incl   -0x10(%ebp)
  803b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b23:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b26:	0f 8c 2f ff ff ff    	jl     803a5b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b33:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b3a:	eb 26                	jmp    803b62 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b3c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b41:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b4a:	89 d0                	mov    %edx,%eax
  803b4c:	01 c0                	add    %eax,%eax
  803b4e:	01 d0                	add    %edx,%eax
  803b50:	c1 e0 03             	shl    $0x3,%eax
  803b53:	01 c8                	add    %ecx,%eax
  803b55:	8a 40 04             	mov    0x4(%eax),%al
  803b58:	3c 01                	cmp    $0x1,%al
  803b5a:	75 03                	jne    803b5f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b5c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b5f:	ff 45 e0             	incl   -0x20(%ebp)
  803b62:	a1 20 50 80 00       	mov    0x805020,%eax
  803b67:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b70:	39 c2                	cmp    %eax,%edx
  803b72:	77 c8                	ja     803b3c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b77:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b7a:	74 14                	je     803b90 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b7c:	83 ec 04             	sub    $0x4,%esp
  803b7f:	68 5c 46 80 00       	push   $0x80465c
  803b84:	6a 44                	push   $0x44
  803b86:	68 fc 45 80 00       	push   $0x8045fc
  803b8b:	e8 1a fe ff ff       	call   8039aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b90:	90                   	nop
  803b91:	c9                   	leave  
  803b92:	c3                   	ret    
  803b93:	90                   	nop

00803b94 <__udivdi3>:
  803b94:	55                   	push   %ebp
  803b95:	57                   	push   %edi
  803b96:	56                   	push   %esi
  803b97:	53                   	push   %ebx
  803b98:	83 ec 1c             	sub    $0x1c,%esp
  803b9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bab:	89 ca                	mov    %ecx,%edx
  803bad:	89 f8                	mov    %edi,%eax
  803baf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bb3:	85 f6                	test   %esi,%esi
  803bb5:	75 2d                	jne    803be4 <__udivdi3+0x50>
  803bb7:	39 cf                	cmp    %ecx,%edi
  803bb9:	77 65                	ja     803c20 <__udivdi3+0x8c>
  803bbb:	89 fd                	mov    %edi,%ebp
  803bbd:	85 ff                	test   %edi,%edi
  803bbf:	75 0b                	jne    803bcc <__udivdi3+0x38>
  803bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc6:	31 d2                	xor    %edx,%edx
  803bc8:	f7 f7                	div    %edi
  803bca:	89 c5                	mov    %eax,%ebp
  803bcc:	31 d2                	xor    %edx,%edx
  803bce:	89 c8                	mov    %ecx,%eax
  803bd0:	f7 f5                	div    %ebp
  803bd2:	89 c1                	mov    %eax,%ecx
  803bd4:	89 d8                	mov    %ebx,%eax
  803bd6:	f7 f5                	div    %ebp
  803bd8:	89 cf                	mov    %ecx,%edi
  803bda:	89 fa                	mov    %edi,%edx
  803bdc:	83 c4 1c             	add    $0x1c,%esp
  803bdf:	5b                   	pop    %ebx
  803be0:	5e                   	pop    %esi
  803be1:	5f                   	pop    %edi
  803be2:	5d                   	pop    %ebp
  803be3:	c3                   	ret    
  803be4:	39 ce                	cmp    %ecx,%esi
  803be6:	77 28                	ja     803c10 <__udivdi3+0x7c>
  803be8:	0f bd fe             	bsr    %esi,%edi
  803beb:	83 f7 1f             	xor    $0x1f,%edi
  803bee:	75 40                	jne    803c30 <__udivdi3+0x9c>
  803bf0:	39 ce                	cmp    %ecx,%esi
  803bf2:	72 0a                	jb     803bfe <__udivdi3+0x6a>
  803bf4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bf8:	0f 87 9e 00 00 00    	ja     803c9c <__udivdi3+0x108>
  803bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  803c03:	89 fa                	mov    %edi,%edx
  803c05:	83 c4 1c             	add    $0x1c,%esp
  803c08:	5b                   	pop    %ebx
  803c09:	5e                   	pop    %esi
  803c0a:	5f                   	pop    %edi
  803c0b:	5d                   	pop    %ebp
  803c0c:	c3                   	ret    
  803c0d:	8d 76 00             	lea    0x0(%esi),%esi
  803c10:	31 ff                	xor    %edi,%edi
  803c12:	31 c0                	xor    %eax,%eax
  803c14:	89 fa                	mov    %edi,%edx
  803c16:	83 c4 1c             	add    $0x1c,%esp
  803c19:	5b                   	pop    %ebx
  803c1a:	5e                   	pop    %esi
  803c1b:	5f                   	pop    %edi
  803c1c:	5d                   	pop    %ebp
  803c1d:	c3                   	ret    
  803c1e:	66 90                	xchg   %ax,%ax
  803c20:	89 d8                	mov    %ebx,%eax
  803c22:	f7 f7                	div    %edi
  803c24:	31 ff                	xor    %edi,%edi
  803c26:	89 fa                	mov    %edi,%edx
  803c28:	83 c4 1c             	add    $0x1c,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5e                   	pop    %esi
  803c2d:	5f                   	pop    %edi
  803c2e:	5d                   	pop    %ebp
  803c2f:	c3                   	ret    
  803c30:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c35:	89 eb                	mov    %ebp,%ebx
  803c37:	29 fb                	sub    %edi,%ebx
  803c39:	89 f9                	mov    %edi,%ecx
  803c3b:	d3 e6                	shl    %cl,%esi
  803c3d:	89 c5                	mov    %eax,%ebp
  803c3f:	88 d9                	mov    %bl,%cl
  803c41:	d3 ed                	shr    %cl,%ebp
  803c43:	89 e9                	mov    %ebp,%ecx
  803c45:	09 f1                	or     %esi,%ecx
  803c47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c4b:	89 f9                	mov    %edi,%ecx
  803c4d:	d3 e0                	shl    %cl,%eax
  803c4f:	89 c5                	mov    %eax,%ebp
  803c51:	89 d6                	mov    %edx,%esi
  803c53:	88 d9                	mov    %bl,%cl
  803c55:	d3 ee                	shr    %cl,%esi
  803c57:	89 f9                	mov    %edi,%ecx
  803c59:	d3 e2                	shl    %cl,%edx
  803c5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c5f:	88 d9                	mov    %bl,%cl
  803c61:	d3 e8                	shr    %cl,%eax
  803c63:	09 c2                	or     %eax,%edx
  803c65:	89 d0                	mov    %edx,%eax
  803c67:	89 f2                	mov    %esi,%edx
  803c69:	f7 74 24 0c          	divl   0xc(%esp)
  803c6d:	89 d6                	mov    %edx,%esi
  803c6f:	89 c3                	mov    %eax,%ebx
  803c71:	f7 e5                	mul    %ebp
  803c73:	39 d6                	cmp    %edx,%esi
  803c75:	72 19                	jb     803c90 <__udivdi3+0xfc>
  803c77:	74 0b                	je     803c84 <__udivdi3+0xf0>
  803c79:	89 d8                	mov    %ebx,%eax
  803c7b:	31 ff                	xor    %edi,%edi
  803c7d:	e9 58 ff ff ff       	jmp    803bda <__udivdi3+0x46>
  803c82:	66 90                	xchg   %ax,%ax
  803c84:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c88:	89 f9                	mov    %edi,%ecx
  803c8a:	d3 e2                	shl    %cl,%edx
  803c8c:	39 c2                	cmp    %eax,%edx
  803c8e:	73 e9                	jae    803c79 <__udivdi3+0xe5>
  803c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c93:	31 ff                	xor    %edi,%edi
  803c95:	e9 40 ff ff ff       	jmp    803bda <__udivdi3+0x46>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	31 c0                	xor    %eax,%eax
  803c9e:	e9 37 ff ff ff       	jmp    803bda <__udivdi3+0x46>
  803ca3:	90                   	nop

00803ca4 <__umoddi3>:
  803ca4:	55                   	push   %ebp
  803ca5:	57                   	push   %edi
  803ca6:	56                   	push   %esi
  803ca7:	53                   	push   %ebx
  803ca8:	83 ec 1c             	sub    $0x1c,%esp
  803cab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803caf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cc3:	89 f3                	mov    %esi,%ebx
  803cc5:	89 fa                	mov    %edi,%edx
  803cc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ccb:	89 34 24             	mov    %esi,(%esp)
  803cce:	85 c0                	test   %eax,%eax
  803cd0:	75 1a                	jne    803cec <__umoddi3+0x48>
  803cd2:	39 f7                	cmp    %esi,%edi
  803cd4:	0f 86 a2 00 00 00    	jbe    803d7c <__umoddi3+0xd8>
  803cda:	89 c8                	mov    %ecx,%eax
  803cdc:	89 f2                	mov    %esi,%edx
  803cde:	f7 f7                	div    %edi
  803ce0:	89 d0                	mov    %edx,%eax
  803ce2:	31 d2                	xor    %edx,%edx
  803ce4:	83 c4 1c             	add    $0x1c,%esp
  803ce7:	5b                   	pop    %ebx
  803ce8:	5e                   	pop    %esi
  803ce9:	5f                   	pop    %edi
  803cea:	5d                   	pop    %ebp
  803ceb:	c3                   	ret    
  803cec:	39 f0                	cmp    %esi,%eax
  803cee:	0f 87 ac 00 00 00    	ja     803da0 <__umoddi3+0xfc>
  803cf4:	0f bd e8             	bsr    %eax,%ebp
  803cf7:	83 f5 1f             	xor    $0x1f,%ebp
  803cfa:	0f 84 ac 00 00 00    	je     803dac <__umoddi3+0x108>
  803d00:	bf 20 00 00 00       	mov    $0x20,%edi
  803d05:	29 ef                	sub    %ebp,%edi
  803d07:	89 fe                	mov    %edi,%esi
  803d09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d0d:	89 e9                	mov    %ebp,%ecx
  803d0f:	d3 e0                	shl    %cl,%eax
  803d11:	89 d7                	mov    %edx,%edi
  803d13:	89 f1                	mov    %esi,%ecx
  803d15:	d3 ef                	shr    %cl,%edi
  803d17:	09 c7                	or     %eax,%edi
  803d19:	89 e9                	mov    %ebp,%ecx
  803d1b:	d3 e2                	shl    %cl,%edx
  803d1d:	89 14 24             	mov    %edx,(%esp)
  803d20:	89 d8                	mov    %ebx,%eax
  803d22:	d3 e0                	shl    %cl,%eax
  803d24:	89 c2                	mov    %eax,%edx
  803d26:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2a:	d3 e0                	shl    %cl,%eax
  803d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d30:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d34:	89 f1                	mov    %esi,%ecx
  803d36:	d3 e8                	shr    %cl,%eax
  803d38:	09 d0                	or     %edx,%eax
  803d3a:	d3 eb                	shr    %cl,%ebx
  803d3c:	89 da                	mov    %ebx,%edx
  803d3e:	f7 f7                	div    %edi
  803d40:	89 d3                	mov    %edx,%ebx
  803d42:	f7 24 24             	mull   (%esp)
  803d45:	89 c6                	mov    %eax,%esi
  803d47:	89 d1                	mov    %edx,%ecx
  803d49:	39 d3                	cmp    %edx,%ebx
  803d4b:	0f 82 87 00 00 00    	jb     803dd8 <__umoddi3+0x134>
  803d51:	0f 84 91 00 00 00    	je     803de8 <__umoddi3+0x144>
  803d57:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d5b:	29 f2                	sub    %esi,%edx
  803d5d:	19 cb                	sbb    %ecx,%ebx
  803d5f:	89 d8                	mov    %ebx,%eax
  803d61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d65:	d3 e0                	shl    %cl,%eax
  803d67:	89 e9                	mov    %ebp,%ecx
  803d69:	d3 ea                	shr    %cl,%edx
  803d6b:	09 d0                	or     %edx,%eax
  803d6d:	89 e9                	mov    %ebp,%ecx
  803d6f:	d3 eb                	shr    %cl,%ebx
  803d71:	89 da                	mov    %ebx,%edx
  803d73:	83 c4 1c             	add    $0x1c,%esp
  803d76:	5b                   	pop    %ebx
  803d77:	5e                   	pop    %esi
  803d78:	5f                   	pop    %edi
  803d79:	5d                   	pop    %ebp
  803d7a:	c3                   	ret    
  803d7b:	90                   	nop
  803d7c:	89 fd                	mov    %edi,%ebp
  803d7e:	85 ff                	test   %edi,%edi
  803d80:	75 0b                	jne    803d8d <__umoddi3+0xe9>
  803d82:	b8 01 00 00 00       	mov    $0x1,%eax
  803d87:	31 d2                	xor    %edx,%edx
  803d89:	f7 f7                	div    %edi
  803d8b:	89 c5                	mov    %eax,%ebp
  803d8d:	89 f0                	mov    %esi,%eax
  803d8f:	31 d2                	xor    %edx,%edx
  803d91:	f7 f5                	div    %ebp
  803d93:	89 c8                	mov    %ecx,%eax
  803d95:	f7 f5                	div    %ebp
  803d97:	89 d0                	mov    %edx,%eax
  803d99:	e9 44 ff ff ff       	jmp    803ce2 <__umoddi3+0x3e>
  803d9e:	66 90                	xchg   %ax,%ax
  803da0:	89 c8                	mov    %ecx,%eax
  803da2:	89 f2                	mov    %esi,%edx
  803da4:	83 c4 1c             	add    $0x1c,%esp
  803da7:	5b                   	pop    %ebx
  803da8:	5e                   	pop    %esi
  803da9:	5f                   	pop    %edi
  803daa:	5d                   	pop    %ebp
  803dab:	c3                   	ret    
  803dac:	3b 04 24             	cmp    (%esp),%eax
  803daf:	72 06                	jb     803db7 <__umoddi3+0x113>
  803db1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803db5:	77 0f                	ja     803dc6 <__umoddi3+0x122>
  803db7:	89 f2                	mov    %esi,%edx
  803db9:	29 f9                	sub    %edi,%ecx
  803dbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dbf:	89 14 24             	mov    %edx,(%esp)
  803dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dca:	8b 14 24             	mov    (%esp),%edx
  803dcd:	83 c4 1c             	add    $0x1c,%esp
  803dd0:	5b                   	pop    %ebx
  803dd1:	5e                   	pop    %esi
  803dd2:	5f                   	pop    %edi
  803dd3:	5d                   	pop    %ebp
  803dd4:	c3                   	ret    
  803dd5:	8d 76 00             	lea    0x0(%esi),%esi
  803dd8:	2b 04 24             	sub    (%esp),%eax
  803ddb:	19 fa                	sbb    %edi,%edx
  803ddd:	89 d1                	mov    %edx,%ecx
  803ddf:	89 c6                	mov    %eax,%esi
  803de1:	e9 71 ff ff ff       	jmp    803d57 <__umoddi3+0xb3>
  803de6:	66 90                	xchg   %ax,%ax
  803de8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dec:	72 ea                	jb     803dd8 <__umoddi3+0x134>
  803dee:	89 d9                	mov    %ebx,%ecx
  803df0:	e9 62 ff ff ff       	jmp    803d57 <__umoddi3+0xb3>
