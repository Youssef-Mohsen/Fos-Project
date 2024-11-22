
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
  80003e:	e8 b7 1b 00 00       	call   801bfa <sys_getparentenvid>
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
  800057:	68 20 3e 80 00       	push   $0x803e20
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 7e 17 00 00       	call   8017e2 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 24 3e 80 00       	push   $0x803e24
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
  80008a:	68 2c 3e 80 00       	push   $0x803e2c
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
  8000ab:	68 3a 3e 80 00       	push   $0x803e3a
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
  80010c:	68 49 3e 80 00       	push   $0x803e49
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
  8001a2:	68 65 3e 80 00       	push   $0x803e65
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
  8001c4:	68 67 3e 80 00       	push   $0x803e67
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
  8001f2:	68 6c 3e 80 00       	push   $0x803e6c
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
  800479:	e8 63 17 00 00       	call   801be1 <sys_getenvindex>
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
  8004e7:	e8 79 14 00 00       	call   801965 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 88 3e 80 00       	push   $0x803e88
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
  800517:	68 b0 3e 80 00       	push   $0x803eb0
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
  800548:	68 d8 3e 80 00       	push   $0x803ed8
  80054d:	e8 34 01 00 00       	call   800686 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 30 3f 80 00       	push   $0x803f30
  800569:	e8 18 01 00 00       	call   800686 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 88 3e 80 00       	push   $0x803e88
  800579:	e8 08 01 00 00       	call   800686 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800581:	e8 f9 13 00 00       	call   80197f <sys_unlock_cons>
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
  800599:	e8 0f 16 00 00       	call   801bad <sys_destroy_env>
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
  8005aa:	e8 64 16 00 00       	call   801c13 <sys_exit_env>
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
  8005f8:	e8 26 13 00 00       	call   801923 <sys_cputs>
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
  80066f:	e8 af 12 00 00       	call   801923 <sys_cputs>
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
  8006b9:	e8 a7 12 00 00       	call   801965 <sys_lock_cons>
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
  8006d9:	e8 a1 12 00 00       	call   80197f <sys_unlock_cons>
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
  800723:	e8 7c 34 00 00       	call   803ba4 <__udivdi3>
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
  800773:	e8 3c 35 00 00       	call   803cb4 <__umoddi3>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	05 74 41 80 00       	add    $0x804174,%eax
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
  8008ce:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  8009af:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 19                	jne    8009d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	53                   	push   %ebx
  8009bb:	68 85 41 80 00       	push   $0x804185
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
  8009d4:	68 8e 41 80 00       	push   $0x80418e
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
  800a01:	be 91 41 80 00       	mov    $0x804191,%esi
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
  80140c:	68 08 43 80 00       	push   $0x804308
  801411:	68 3f 01 00 00       	push   $0x13f
  801416:	68 2a 43 80 00       	push   $0x80432a
  80141b:	e8 9a 25 00 00       	call   8039ba <_panic>

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
  80142c:	e8 9d 0a 00 00       	call   801ece <sys_sbrk>
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
  8014a7:	e8 a6 08 00 00       	call   801d52 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 16                	je     8014c6 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 e6 0d 00 00       	call   8022a1 <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	e9 8a 01 00 00       	jmp    801650 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014c6:	e8 b8 08 00 00       	call   801d83 <sys_isUHeapPlacementStrategyBESTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 84 7d 01 00 00    	je     801650 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 7f 12 00 00       	call   80275d <alloc_block_BF>
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
  80163f:	e8 c1 08 00 00       	call   801f05 <sys_allocate_user_mem>
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
  801687:	e8 95 08 00 00       	call   801f21 <get_block_size>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 c8 1a 00 00       	call   803165 <free_block>
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
  80172f:	e8 b5 07 00 00       	call   801ee9 <sys_free_user_mem>
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
  80173d:	68 38 43 80 00       	push   $0x804338
  801742:	68 84 00 00 00       	push   $0x84
  801747:	68 62 43 80 00       	push   $0x804362
  80174c:	e8 69 22 00 00       	call   8039ba <_panic>
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
  8017af:	e8 3c 03 00 00       	call   801af0 <sys_createSharedObject>
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
  8017d0:	68 6e 43 80 00       	push   $0x80436e
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
  8017e5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017e8:	83 ec 08             	sub    $0x8,%esp
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	ff 75 08             	pushl  0x8(%ebp)
  8017f1:	e8 24 03 00 00       	call   801b1a <sys_getSizeOfSharedObject>
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017fc:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801800:	75 07                	jne    801809 <sget+0x27>
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	eb 5c                	jmp    801865 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80180f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801816:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181c:	39 d0                	cmp    %edx,%eax
  80181e:	7d 02                	jge    801822 <sget+0x40>
  801820:	89 d0                	mov    %edx,%eax
  801822:	83 ec 0c             	sub    $0xc,%esp
  801825:	50                   	push   %eax
  801826:	e8 0b fc ff ff       	call   801436 <malloc>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801831:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801835:	75 07                	jne    80183e <sget+0x5c>
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
  80183c:	eb 27                	jmp    801865 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	ff 75 e8             	pushl  -0x18(%ebp)
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	e8 e8 02 00 00       	call   801b37 <sys_getSharedObject>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801855:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801859:	75 07                	jne    801862 <sget+0x80>
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
  801860:	eb 03                	jmp    801865 <sget+0x83>
	return ptr;
  801862:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 74 43 80 00       	push   $0x804374
  801875:	68 c2 00 00 00       	push   $0xc2
  80187a:	68 62 43 80 00       	push   $0x804362
  80187f:	e8 36 21 00 00       	call   8039ba <_panic>

00801884 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	68 98 43 80 00       	push   $0x804398
  801892:	68 d9 00 00 00       	push   $0xd9
  801897:	68 62 43 80 00       	push   $0x804362
  80189c:	e8 19 21 00 00       	call   8039ba <_panic>

008018a1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 be 43 80 00       	push   $0x8043be
  8018af:	68 e5 00 00 00       	push   $0xe5
  8018b4:	68 62 43 80 00       	push   $0x804362
  8018b9:	e8 fc 20 00 00       	call   8039ba <_panic>

008018be <shrink>:

}
void shrink(uint32 newSize)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	68 be 43 80 00       	push   $0x8043be
  8018cc:	68 ea 00 00 00       	push   $0xea
  8018d1:	68 62 43 80 00       	push   $0x804362
  8018d6:	e8 df 20 00 00       	call   8039ba <_panic>

008018db <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	68 be 43 80 00       	push   $0x8043be
  8018e9:	68 ef 00 00 00       	push   $0xef
  8018ee:	68 62 43 80 00       	push   $0x804362
  8018f3:	e8 c2 20 00 00       	call   8039ba <_panic>

008018f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	57                   	push   %edi
  8018fc:	56                   	push   %esi
  8018fd:	53                   	push   %ebx
  8018fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801910:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801913:	cd 30                	int    $0x30
  801915:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801918:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5f                   	pop    %edi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 45 10             	mov    0x10(%ebp),%eax
  80192c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	52                   	push   %edx
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	50                   	push   %eax
  80193f:	6a 00                	push   $0x0
  801941:	e8 b2 ff ff ff       	call   8018f8 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_cgetc>:

int
sys_cgetc(void)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 02                	push   $0x2
  80195b:	e8 98 ff ff ff       	call   8018f8 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 03                	push   $0x3
  801974:	e8 7f ff ff ff       	call   8018f8 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 04                	push   $0x4
  80198e:	e8 65 ff ff ff       	call   8018f8 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80199c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	6a 08                	push   $0x8
  8019ac:	e8 47 ff ff ff       	call   8018f8 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	56                   	push   %esi
  8019ba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8019be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	51                   	push   %ecx
  8019cd:	52                   	push   %edx
  8019ce:	50                   	push   %eax
  8019cf:	6a 09                	push   $0x9
  8019d1:	e8 22 ff ff ff       	call   8018f8 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	52                   	push   %edx
  8019f0:	50                   	push   %eax
  8019f1:	6a 0a                	push   $0xa
  8019f3:	e8 00 ff ff ff       	call   8018f8 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	ff 75 08             	pushl  0x8(%ebp)
  801a0c:	6a 0b                	push   $0xb
  801a0e:	e8 e5 fe ff ff       	call   8018f8 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 0c                	push   $0xc
  801a27:	e8 cc fe ff ff       	call   8018f8 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 0d                	push   $0xd
  801a40:	e8 b3 fe ff ff       	call   8018f8 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 0e                	push   $0xe
  801a59:	e8 9a fe ff ff       	call   8018f8 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 0f                	push   $0xf
  801a72:	e8 81 fe ff ff       	call   8018f8 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	6a 10                	push   $0x10
  801a8c:	e8 67 fe ff ff       	call   8018f8 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 11                	push   $0x11
  801aa5:	e8 4e fe ff ff       	call   8018f8 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801abc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	50                   	push   %eax
  801ac9:	6a 01                	push   $0x1
  801acb:	e8 28 fe ff ff       	call   8018f8 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 14                	push   $0x14
  801ae5:	e8 0e fe ff ff       	call   8018f8 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	8b 45 10             	mov    0x10(%ebp),%eax
  801af9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801afc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	51                   	push   %ecx
  801b09:	52                   	push   %edx
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	6a 15                	push   $0x15
  801b10:	e8 e3 fd ff ff       	call   8018f8 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 16                	push   $0x16
  801b2d:	e8 c6 fd ff ff       	call   8018f8 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	51                   	push   %ecx
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 17                	push   $0x17
  801b4c:	e8 a7 fd ff ff       	call   8018f8 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 18                	push   $0x18
  801b69:	e8 8a fd ff ff       	call   8018f8 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 14             	pushl  0x14(%ebp)
  801b7e:	ff 75 10             	pushl  0x10(%ebp)
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	50                   	push   %eax
  801b85:	6a 19                	push   $0x19
  801b87:	e8 6c fd ff ff       	call   8018f8 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	50                   	push   %eax
  801ba0:	6a 1a                	push   $0x1a
  801ba2:	e8 51 fd ff ff       	call   8018f8 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	90                   	nop
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	50                   	push   %eax
  801bbc:	6a 1b                	push   $0x1b
  801bbe:	e8 35 fd ff ff       	call   8018f8 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 05                	push   $0x5
  801bd7:	e8 1c fd ff ff       	call   8018f8 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 06                	push   $0x6
  801bf0:	e8 03 fd ff ff       	call   8018f8 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 07                	push   $0x7
  801c09:	e8 ea fc ff ff       	call   8018f8 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_exit_env>:


void sys_exit_env(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 1c                	push   $0x1c
  801c22:	e8 d1 fc ff ff       	call   8018f8 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	90                   	nop
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c36:	8d 50 04             	lea    0x4(%eax),%edx
  801c39:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	6a 1d                	push   $0x1d
  801c46:	e8 ad fc ff ff       	call   8018f8 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c57:	89 01                	mov    %eax,(%ecx)
  801c59:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	c9                   	leave  
  801c60:	c2 04 00             	ret    $0x4

00801c63 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	ff 75 10             	pushl  0x10(%ebp)
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	6a 13                	push   $0x13
  801c75:	e8 7e fc ff ff       	call   8018f8 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7d:	90                   	nop
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 1e                	push   $0x1e
  801c8f:	e8 64 fc ff ff       	call   8018f8 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	50                   	push   %eax
  801cb2:	6a 1f                	push   $0x1f
  801cb4:	e8 3f fc ff ff       	call   8018f8 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbc:	90                   	nop
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <rsttst>:
void rsttst()
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 21                	push   $0x21
  801cce:	e8 25 fc ff ff       	call   8018f8 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd6:	90                   	nop
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 04             	sub    $0x4,%esp
  801cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ce8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	ff 75 10             	pushl  0x10(%ebp)
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	6a 20                	push   $0x20
  801cf9:	e8 fa fb ff ff       	call   8018f8 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <chktst>:
void chktst(uint32 n)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 08             	pushl  0x8(%ebp)
  801d12:	6a 22                	push   $0x22
  801d14:	e8 df fb ff ff       	call   8018f8 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1c:	90                   	nop
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <inctst>:

void inctst()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 23                	push   $0x23
  801d2e:	e8 c5 fb ff ff       	call   8018f8 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return ;
  801d36:	90                   	nop
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <gettst>:
uint32 gettst()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 24                	push   $0x24
  801d48:	e8 ab fb ff ff       	call   8018f8 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 25                	push   $0x25
  801d64:	e8 8f fb ff ff       	call   8018f8 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
  801d6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d6f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d73:	75 07                	jne    801d7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d75:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7a:	eb 05                	jmp    801d81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 25                	push   $0x25
  801d95:	e8 5e fb ff ff       	call   8018f8 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
  801d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da4:	75 07                	jne    801dad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	eb 05                	jmp    801db2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 25                	push   $0x25
  801dc6:	e8 2d fb ff ff       	call   8018f8 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
  801dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd5:	75 07                	jne    801dde <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddc:	eb 05                	jmp    801de3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 25                	push   $0x25
  801df7:	e8 fc fa ff ff       	call   8018f8 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
  801dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e02:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e06:	75 07                	jne    801e0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e08:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0d:	eb 05                	jmp    801e14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	6a 26                	push   $0x26
  801e26:	e8 cd fa ff ff       	call   8018f8 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2e:	90                   	nop
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	6a 00                	push   $0x0
  801e43:	53                   	push   %ebx
  801e44:	51                   	push   %ecx
  801e45:	52                   	push   %edx
  801e46:	50                   	push   %eax
  801e47:	6a 27                	push   $0x27
  801e49:	e8 aa fa ff ff       	call   8018f8 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 28                	push   $0x28
  801e69:	e8 8a fa ff ff       	call   8018f8 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e76:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	51                   	push   %ecx
  801e82:	ff 75 10             	pushl  0x10(%ebp)
  801e85:	52                   	push   %edx
  801e86:	50                   	push   %eax
  801e87:	6a 29                	push   $0x29
  801e89:	e8 6a fa ff ff       	call   8018f8 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	ff 75 10             	pushl  0x10(%ebp)
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	6a 12                	push   $0x12
  801ea5:	e8 4e fa ff ff       	call   8018f8 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
	return ;
  801ead:	90                   	nop
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	52                   	push   %edx
  801ec0:	50                   	push   %eax
  801ec1:	6a 2a                	push   $0x2a
  801ec3:	e8 30 fa ff ff       	call   8018f8 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
	return;
  801ecb:	90                   	nop
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	50                   	push   %eax
  801edd:	6a 2b                	push   $0x2b
  801edf:	e8 14 fa ff ff       	call   8018f8 <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	6a 2c                	push   $0x2c
  801efa:	e8 f9 f9 ff ff       	call   8018f8 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
	return;
  801f02:	90                   	nop
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 0c             	pushl  0xc(%ebp)
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	6a 2d                	push   $0x2d
  801f16:	e8 dd f9 ff ff       	call   8018f8 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
	return;
  801f1e:	90                   	nop
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	83 e8 04             	sub    $0x4,%eax
  801f2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f33:	8b 00                	mov    (%eax),%eax
  801f35:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	83 e8 04             	sub    $0x4,%eax
  801f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	83 e0 01             	and    $0x1,%eax
  801f51:	85 c0                	test   %eax,%eax
  801f53:	0f 94 c0             	sete   %al
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f68:	83 f8 02             	cmp    $0x2,%eax
  801f6b:	74 2b                	je     801f98 <alloc_block+0x40>
  801f6d:	83 f8 02             	cmp    $0x2,%eax
  801f70:	7f 07                	jg     801f79 <alloc_block+0x21>
  801f72:	83 f8 01             	cmp    $0x1,%eax
  801f75:	74 0e                	je     801f85 <alloc_block+0x2d>
  801f77:	eb 58                	jmp    801fd1 <alloc_block+0x79>
  801f79:	83 f8 03             	cmp    $0x3,%eax
  801f7c:	74 2d                	je     801fab <alloc_block+0x53>
  801f7e:	83 f8 04             	cmp    $0x4,%eax
  801f81:	74 3b                	je     801fbe <alloc_block+0x66>
  801f83:	eb 4c                	jmp    801fd1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	e8 11 03 00 00       	call   8022a1 <alloc_block_FF>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f96:	eb 4a                	jmp    801fe2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	e8 fa 19 00 00       	call   80399d <alloc_block_NF>
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fa9:	eb 37                	jmp    801fe2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	ff 75 08             	pushl  0x8(%ebp)
  801fb1:	e8 a7 07 00 00       	call   80275d <alloc_block_BF>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fbc:	eb 24                	jmp    801fe2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	ff 75 08             	pushl  0x8(%ebp)
  801fc4:	e8 b7 19 00 00       	call   803980 <alloc_block_WF>
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fcf:	eb 11                	jmp    801fe2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	68 d0 43 80 00       	push   $0x8043d0
  801fd9:	e8 a8 e6 ff ff       	call   800686 <cprintf>
  801fde:	83 c4 10             	add    $0x10,%esp
		break;
  801fe1:	90                   	nop
	}
	return va;
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	53                   	push   %ebx
  801feb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 f0 43 80 00       	push   $0x8043f0
  801ff6:	e8 8b e6 ff ff       	call   800686 <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	68 1b 44 80 00       	push   $0x80441b
  802006:	e8 7b e6 ff ff       	call   800686 <cprintf>
  80200b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802014:	eb 37                	jmp    80204d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	ff 75 f4             	pushl  -0xc(%ebp)
  80201c:	e8 19 ff ff ff       	call   801f3a <is_free_block>
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	0f be d8             	movsbl %al,%ebx
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	ff 75 f4             	pushl  -0xc(%ebp)
  80202d:	e8 ef fe ff ff       	call   801f21 <get_block_size>
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	53                   	push   %ebx
  802039:	50                   	push   %eax
  80203a:	68 33 44 80 00       	push   $0x804433
  80203f:	e8 42 e6 ff ff       	call   800686 <cprintf>
  802044:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802047:	8b 45 10             	mov    0x10(%ebp),%eax
  80204a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802051:	74 07                	je     80205a <print_blocks_list+0x73>
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 00                	mov    (%eax),%eax
  802058:	eb 05                	jmp    80205f <print_blocks_list+0x78>
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	89 45 10             	mov    %eax,0x10(%ebp)
  802062:	8b 45 10             	mov    0x10(%ebp),%eax
  802065:	85 c0                	test   %eax,%eax
  802067:	75 ad                	jne    802016 <print_blocks_list+0x2f>
  802069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206d:	75 a7                	jne    802016 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	68 f0 43 80 00       	push   $0x8043f0
  802077:	e8 0a e6 ff ff       	call   800686 <cprintf>
  80207c:	83 c4 10             	add    $0x10,%esp

}
  80207f:	90                   	nop
  802080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80208b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208e:	83 e0 01             	and    $0x1,%eax
  802091:	85 c0                	test   %eax,%eax
  802093:	74 03                	je     802098 <initialize_dynamic_allocator+0x13>
  802095:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80209c:	0f 84 c7 01 00 00    	je     802269 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020a2:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020a9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8020af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b2:	01 d0                	add    %edx,%eax
  8020b4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020b9:	0f 87 ad 01 00 00    	ja     80226c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	0f 89 a5 01 00 00    	jns    80226f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	83 e8 04             	sub    $0x4,%eax
  8020d5:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e9:	e9 87 00 00 00       	jmp    802175 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f2:	75 14                	jne    802108 <initialize_dynamic_allocator+0x83>
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	68 4b 44 80 00       	push   $0x80444b
  8020fc:	6a 79                	push   $0x79
  8020fe:	68 69 44 80 00       	push   $0x804469
  802103:	e8 b2 18 00 00       	call   8039ba <_panic>
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	8b 00                	mov    (%eax),%eax
  80210d:	85 c0                	test   %eax,%eax
  80210f:	74 10                	je     802121 <initialize_dynamic_allocator+0x9c>
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 00                	mov    (%eax),%eax
  802116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802119:	8b 52 04             	mov    0x4(%edx),%edx
  80211c:	89 50 04             	mov    %edx,0x4(%eax)
  80211f:	eb 0b                	jmp    80212c <initialize_dynamic_allocator+0xa7>
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 40 04             	mov    0x4(%eax),%eax
  802127:	a3 30 50 80 00       	mov    %eax,0x805030
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	8b 40 04             	mov    0x4(%eax),%eax
  802132:	85 c0                	test   %eax,%eax
  802134:	74 0f                	je     802145 <initialize_dynamic_allocator+0xc0>
  802136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802139:	8b 40 04             	mov    0x4(%eax),%eax
  80213c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213f:	8b 12                	mov    (%edx),%edx
  802141:	89 10                	mov    %edx,(%eax)
  802143:	eb 0a                	jmp    80214f <initialize_dynamic_allocator+0xca>
  802145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802148:	8b 00                	mov    (%eax),%eax
  80214a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802162:	a1 38 50 80 00       	mov    0x805038,%eax
  802167:	48                   	dec    %eax
  802168:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80216d:	a1 34 50 80 00       	mov    0x805034,%eax
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802179:	74 07                	je     802182 <initialize_dynamic_allocator+0xfd>
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	eb 05                	jmp    802187 <initialize_dynamic_allocator+0x102>
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	a3 34 50 80 00       	mov    %eax,0x805034
  80218c:	a1 34 50 80 00       	mov    0x805034,%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	0f 85 55 ff ff ff    	jne    8020ee <initialize_dynamic_allocator+0x69>
  802199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219d:	0f 85 4b ff ff ff    	jne    8020ee <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021b2:	a1 44 50 80 00       	mov    0x805044,%eax
  8021b7:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	83 c0 08             	add    $0x8,%eax
  8021cd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	83 c0 04             	add    $0x4,%eax
  8021d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d9:	83 ea 08             	sub    $0x8,%edx
  8021dc:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	01 d0                	add    %edx,%eax
  8021e6:	83 e8 08             	sub    $0x8,%eax
  8021e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ec:	83 ea 08             	sub    $0x8,%edx
  8021ef:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802204:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802208:	75 17                	jne    802221 <initialize_dynamic_allocator+0x19c>
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 84 44 80 00       	push   $0x804484
  802212:	68 90 00 00 00       	push   $0x90
  802217:	68 69 44 80 00       	push   $0x804469
  80221c:	e8 99 17 00 00       	call   8039ba <_panic>
  802221:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222a:	89 10                	mov    %edx,(%eax)
  80222c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222f:	8b 00                	mov    (%eax),%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	74 0d                	je     802242 <initialize_dynamic_allocator+0x1bd>
  802235:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80223a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80223d:	89 50 04             	mov    %edx,0x4(%eax)
  802240:	eb 08                	jmp    80224a <initialize_dynamic_allocator+0x1c5>
  802242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802245:	a3 30 50 80 00       	mov    %eax,0x805030
  80224a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225c:	a1 38 50 80 00       	mov    0x805038,%eax
  802261:	40                   	inc    %eax
  802262:	a3 38 50 80 00       	mov    %eax,0x805038
  802267:	eb 07                	jmp    802270 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802269:	90                   	nop
  80226a:	eb 04                	jmp    802270 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80226c:	90                   	nop
  80226d:	eb 01                	jmp    802270 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80226f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802275:	8b 45 10             	mov    0x10(%ebp),%eax
  802278:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	83 e8 04             	sub    $0x4,%eax
  80228c:	8b 00                	mov    (%eax),%eax
  80228e:	83 e0 fe             	and    $0xfffffffe,%eax
  802291:	8d 50 f8             	lea    -0x8(%eax),%edx
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
}
  80229e:	90                   	nop
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    

008022a1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	83 e0 01             	and    $0x1,%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	74 03                	je     8022b4 <alloc_block_FF+0x13>
  8022b1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022b4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022b8:	77 07                	ja     8022c1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022ba:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022c1:	a1 24 50 80 00       	mov    0x805024,%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	75 73                	jne    80233d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	83 c0 10             	add    $0x10,%eax
  8022d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022d3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e0:	01 d0                	add    %edx,%eax
  8022e2:	48                   	dec    %eax
  8022e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ee:	f7 75 ec             	divl   -0x14(%ebp)
  8022f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f4:	29 d0                	sub    %edx,%eax
  8022f6:	c1 e8 0c             	shr    $0xc,%eax
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	50                   	push   %eax
  8022fd:	e8 1e f1 ff ff       	call   801420 <sbrk>
  802302:	83 c4 10             	add    $0x10,%esp
  802305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802308:	83 ec 0c             	sub    $0xc,%esp
  80230b:	6a 00                	push   $0x0
  80230d:	e8 0e f1 ff ff       	call   801420 <sbrk>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80231b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80231e:	83 ec 08             	sub    $0x8,%esp
  802321:	50                   	push   %eax
  802322:	ff 75 e4             	pushl  -0x1c(%ebp)
  802325:	e8 5b fd ff ff       	call   802085 <initialize_dynamic_allocator>
  80232a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	68 a7 44 80 00       	push   $0x8044a7
  802335:	e8 4c e3 ff ff       	call   800686 <cprintf>
  80233a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80233d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802341:	75 0a                	jne    80234d <alloc_block_FF+0xac>
	        return NULL;
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	e9 0e 04 00 00       	jmp    80275b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80234d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802354:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235c:	e9 f3 02 00 00       	jmp    802654 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802367:	83 ec 0c             	sub    $0xc,%esp
  80236a:	ff 75 bc             	pushl  -0x44(%ebp)
  80236d:	e8 af fb ff ff       	call   801f21 <get_block_size>
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	83 c0 08             	add    $0x8,%eax
  80237e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802381:	0f 87 c5 02 00 00    	ja     80264c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	83 c0 18             	add    $0x18,%eax
  80238d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802390:	0f 87 19 02 00 00    	ja     8025af <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802396:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802399:	2b 45 08             	sub    0x8(%ebp),%eax
  80239c:	83 e8 08             	sub    $0x8,%eax
  80239f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8d 50 08             	lea    0x8(%eax),%edx
  8023a8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ab:	01 d0                	add    %edx,%eax
  8023ad:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	83 c0 08             	add    $0x8,%eax
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	6a 01                	push   $0x1
  8023bb:	50                   	push   %eax
  8023bc:	ff 75 bc             	pushl  -0x44(%ebp)
  8023bf:	e8 ae fe ff ff       	call   802272 <set_block_data>
  8023c4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	75 68                	jne    802439 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023d1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023d5:	75 17                	jne    8023ee <alloc_block_FF+0x14d>
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 84 44 80 00       	push   $0x804484
  8023df:	68 d7 00 00 00       	push   $0xd7
  8023e4:	68 69 44 80 00       	push   $0x804469
  8023e9:	e8 cc 15 00 00       	call   8039ba <_panic>
  8023ee:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f7:	89 10                	mov    %edx,(%eax)
  8023f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	74 0d                	je     80240f <alloc_block_FF+0x16e>
  802402:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802407:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
  80240d:	eb 08                	jmp    802417 <alloc_block_FF+0x176>
  80240f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802412:	a3 30 50 80 00       	mov    %eax,0x805030
  802417:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802429:	a1 38 50 80 00       	mov    0x805038,%eax
  80242e:	40                   	inc    %eax
  80242f:	a3 38 50 80 00       	mov    %eax,0x805038
  802434:	e9 dc 00 00 00       	jmp    802515 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	75 65                	jne    8024a7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802442:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802446:	75 17                	jne    80245f <alloc_block_FF+0x1be>
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	68 b8 44 80 00       	push   $0x8044b8
  802450:	68 db 00 00 00       	push   $0xdb
  802455:	68 69 44 80 00       	push   $0x804469
  80245a:	e8 5b 15 00 00       	call   8039ba <_panic>
  80245f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802465:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802468:	89 50 04             	mov    %edx,0x4(%eax)
  80246b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246e:	8b 40 04             	mov    0x4(%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 0c                	je     802481 <alloc_block_FF+0x1e0>
  802475:	a1 30 50 80 00       	mov    0x805030,%eax
  80247a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80247d:	89 10                	mov    %edx,(%eax)
  80247f:	eb 08                	jmp    802489 <alloc_block_FF+0x1e8>
  802481:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802484:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802489:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248c:	a3 30 50 80 00       	mov    %eax,0x805030
  802491:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249a:	a1 38 50 80 00       	mov    0x805038,%eax
  80249f:	40                   	inc    %eax
  8024a0:	a3 38 50 80 00       	mov    %eax,0x805038
  8024a5:	eb 6e                	jmp    802515 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ab:	74 06                	je     8024b3 <alloc_block_FF+0x212>
  8024ad:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024b1:	75 17                	jne    8024ca <alloc_block_FF+0x229>
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 dc 44 80 00       	push   $0x8044dc
  8024bb:	68 df 00 00 00       	push   $0xdf
  8024c0:	68 69 44 80 00       	push   $0x804469
  8024c5:	e8 f0 14 00 00       	call   8039ba <_panic>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 10                	mov    (%eax),%edx
  8024cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d2:	89 10                	mov    %edx,(%eax)
  8024d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 0b                	je     8024e8 <alloc_block_FF+0x247>
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024e5:	89 50 04             	mov    %edx,0x4(%eax)
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
  8024f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	89 50 04             	mov    %edx,0x4(%eax)
  8024f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fc:	8b 00                	mov    (%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	75 08                	jne    80250a <alloc_block_FF+0x269>
  802502:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802505:	a3 30 50 80 00       	mov    %eax,0x805030
  80250a:	a1 38 50 80 00       	mov    0x805038,%eax
  80250f:	40                   	inc    %eax
  802510:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802519:	75 17                	jne    802532 <alloc_block_FF+0x291>
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	68 4b 44 80 00       	push   $0x80444b
  802523:	68 e1 00 00 00       	push   $0xe1
  802528:	68 69 44 80 00       	push   $0x804469
  80252d:	e8 88 14 00 00       	call   8039ba <_panic>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 10                	je     80254b <alloc_block_FF+0x2aa>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802543:	8b 52 04             	mov    0x4(%edx),%edx
  802546:	89 50 04             	mov    %edx,0x4(%eax)
  802549:	eb 0b                	jmp    802556 <alloc_block_FF+0x2b5>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	a3 30 50 80 00       	mov    %eax,0x805030
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	74 0f                	je     80256f <alloc_block_FF+0x2ce>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802569:	8b 12                	mov    (%edx),%edx
  80256b:	89 10                	mov    %edx,(%eax)
  80256d:	eb 0a                	jmp    802579 <alloc_block_FF+0x2d8>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258c:	a1 38 50 80 00       	mov    0x805038,%eax
  802591:	48                   	dec    %eax
  802592:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	6a 00                	push   $0x0
  80259c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80259f:	ff 75 b0             	pushl  -0x50(%ebp)
  8025a2:	e8 cb fc ff ff       	call   802272 <set_block_data>
  8025a7:	83 c4 10             	add    $0x10,%esp
  8025aa:	e9 95 00 00 00       	jmp    802644 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	6a 01                	push   $0x1
  8025b4:	ff 75 b8             	pushl  -0x48(%ebp)
  8025b7:	ff 75 bc             	pushl  -0x44(%ebp)
  8025ba:	e8 b3 fc ff ff       	call   802272 <set_block_data>
  8025bf:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	75 17                	jne    8025df <alloc_block_FF+0x33e>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 4b 44 80 00       	push   $0x80444b
  8025d0:	68 e8 00 00 00       	push   $0xe8
  8025d5:	68 69 44 80 00       	push   $0x804469
  8025da:	e8 db 13 00 00       	call   8039ba <_panic>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 10                	je     8025f8 <alloc_block_FF+0x357>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	8b 52 04             	mov    0x4(%edx),%edx
  8025f3:	89 50 04             	mov    %edx,0x4(%eax)
  8025f6:	eb 0b                	jmp    802603 <alloc_block_FF+0x362>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 0f                	je     80261c <alloc_block_FF+0x37b>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802616:	8b 12                	mov    (%edx),%edx
  802618:	89 10                	mov    %edx,(%eax)
  80261a:	eb 0a                	jmp    802626 <alloc_block_FF+0x385>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802639:	a1 38 50 80 00       	mov    0x805038,%eax
  80263e:	48                   	dec    %eax
  80263f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802644:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802647:	e9 0f 01 00 00       	jmp    80275b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80264c:	a1 34 50 80 00       	mov    0x805034,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802658:	74 07                	je     802661 <alloc_block_FF+0x3c0>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	eb 05                	jmp    802666 <alloc_block_FF+0x3c5>
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	a3 34 50 80 00       	mov    %eax,0x805034
  80266b:	a1 34 50 80 00       	mov    0x805034,%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	0f 85 e9 fc ff ff    	jne    802361 <alloc_block_FF+0xc0>
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	0f 85 df fc ff ff    	jne    802361 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	83 c0 08             	add    $0x8,%eax
  802688:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80268b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802692:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	48                   	dec    %eax
  80269b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80269e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a6:	f7 75 d8             	divl   -0x28(%ebp)
  8026a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ac:	29 d0                	sub    %edx,%eax
  8026ae:	c1 e8 0c             	shr    $0xc,%eax
  8026b1:	83 ec 0c             	sub    $0xc,%esp
  8026b4:	50                   	push   %eax
  8026b5:	e8 66 ed ff ff       	call   801420 <sbrk>
  8026ba:	83 c4 10             	add    $0x10,%esp
  8026bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026c0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026c4:	75 0a                	jne    8026d0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cb:	e9 8b 00 00 00       	jmp    80275b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026d0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026dd:	01 d0                	add    %edx,%eax
  8026df:	48                   	dec    %eax
  8026e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026eb:	f7 75 cc             	divl   -0x34(%ebp)
  8026ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026f1:	29 d0                	sub    %edx,%eax
  8026f3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802700:	a1 40 50 80 00       	mov    0x805040,%eax
  802705:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80270b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802712:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802715:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802718:	01 d0                	add    %edx,%eax
  80271a:	48                   	dec    %eax
  80271b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80271e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802721:	ba 00 00 00 00       	mov    $0x0,%edx
  802726:	f7 75 c4             	divl   -0x3c(%ebp)
  802729:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80272c:	29 d0                	sub    %edx,%eax
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	6a 01                	push   $0x1
  802733:	50                   	push   %eax
  802734:	ff 75 d0             	pushl  -0x30(%ebp)
  802737:	e8 36 fb ff ff       	call   802272 <set_block_data>
  80273c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80273f:	83 ec 0c             	sub    $0xc,%esp
  802742:	ff 75 d0             	pushl  -0x30(%ebp)
  802745:	e8 1b 0a 00 00       	call   803165 <free_block>
  80274a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	ff 75 08             	pushl  0x8(%ebp)
  802753:	e8 49 fb ff ff       	call   8022a1 <alloc_block_FF>
  802758:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	83 e0 01             	and    $0x1,%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 03                	je     802770 <alloc_block_BF+0x13>
  80276d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802770:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802774:	77 07                	ja     80277d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802776:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80277d:	a1 24 50 80 00       	mov    0x805024,%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	75 73                	jne    8027f9 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	83 c0 10             	add    $0x10,%eax
  80278c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80278f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802796:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	48                   	dec    %eax
  80279f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027aa:	f7 75 e0             	divl   -0x20(%ebp)
  8027ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027b0:	29 d0                	sub    %edx,%eax
  8027b2:	c1 e8 0c             	shr    $0xc,%eax
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	50                   	push   %eax
  8027b9:	e8 62 ec ff ff       	call   801420 <sbrk>
  8027be:	83 c4 10             	add    $0x10,%esp
  8027c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027c4:	83 ec 0c             	sub    $0xc,%esp
  8027c7:	6a 00                	push   $0x0
  8027c9:	e8 52 ec ff ff       	call   801420 <sbrk>
  8027ce:	83 c4 10             	add    $0x10,%esp
  8027d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027da:	83 ec 08             	sub    $0x8,%esp
  8027dd:	50                   	push   %eax
  8027de:	ff 75 d8             	pushl  -0x28(%ebp)
  8027e1:	e8 9f f8 ff ff       	call   802085 <initialize_dynamic_allocator>
  8027e6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027e9:	83 ec 0c             	sub    $0xc,%esp
  8027ec:	68 a7 44 80 00       	push   $0x8044a7
  8027f1:	e8 90 de ff ff       	call   800686 <cprintf>
  8027f6:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802800:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802807:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80280e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802815:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80281a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281d:	e9 1d 01 00 00       	jmp    80293f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802828:	83 ec 0c             	sub    $0xc,%esp
  80282b:	ff 75 a8             	pushl  -0x58(%ebp)
  80282e:	e8 ee f6 ff ff       	call   801f21 <get_block_size>
  802833:	83 c4 10             	add    $0x10,%esp
  802836:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	83 c0 08             	add    $0x8,%eax
  80283f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802842:	0f 87 ef 00 00 00    	ja     802937 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	83 c0 18             	add    $0x18,%eax
  80284e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802851:	77 1d                	ja     802870 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802856:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802859:	0f 86 d8 00 00 00    	jbe    802937 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80285f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802862:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802865:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80286b:	e9 c7 00 00 00       	jmp    802937 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	83 c0 08             	add    $0x8,%eax
  802876:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802879:	0f 85 9d 00 00 00    	jne    80291c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	6a 01                	push   $0x1
  802884:	ff 75 a4             	pushl  -0x5c(%ebp)
  802887:	ff 75 a8             	pushl  -0x58(%ebp)
  80288a:	e8 e3 f9 ff ff       	call   802272 <set_block_data>
  80288f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802896:	75 17                	jne    8028af <alloc_block_BF+0x152>
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	68 4b 44 80 00       	push   $0x80444b
  8028a0:	68 2c 01 00 00       	push   $0x12c
  8028a5:	68 69 44 80 00       	push   $0x804469
  8028aa:	e8 0b 11 00 00       	call   8039ba <_panic>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	74 10                	je     8028c8 <alloc_block_BF+0x16b>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	8b 52 04             	mov    0x4(%edx),%edx
  8028c3:	89 50 04             	mov    %edx,0x4(%eax)
  8028c6:	eb 0b                	jmp    8028d3 <alloc_block_BF+0x176>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 0f                	je     8028ec <alloc_block_BF+0x18f>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 04             	mov    0x4(%eax),%eax
  8028e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e6:	8b 12                	mov    (%edx),%edx
  8028e8:	89 10                	mov    %edx,(%eax)
  8028ea:	eb 0a                	jmp    8028f6 <alloc_block_BF+0x199>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802909:	a1 38 50 80 00       	mov    0x805038,%eax
  80290e:	48                   	dec    %eax
  80290f:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802914:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802917:	e9 24 04 00 00       	jmp    802d40 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80291c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802922:	76 13                	jbe    802937 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802924:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80292b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80292e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802931:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802934:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802937:	a1 34 50 80 00       	mov    0x805034,%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	74 07                	je     80294c <alloc_block_BF+0x1ef>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	eb 05                	jmp    802951 <alloc_block_BF+0x1f4>
  80294c:	b8 00 00 00 00       	mov    $0x0,%eax
  802951:	a3 34 50 80 00       	mov    %eax,0x805034
  802956:	a1 34 50 80 00       	mov    0x805034,%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	0f 85 bf fe ff ff    	jne    802822 <alloc_block_BF+0xc5>
  802963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802967:	0f 85 b5 fe ff ff    	jne    802822 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80296d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802971:	0f 84 26 02 00 00    	je     802b9d <alloc_block_BF+0x440>
  802977:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80297b:	0f 85 1c 02 00 00    	jne    802b9d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802984:	2b 45 08             	sub    0x8(%ebp),%eax
  802987:	83 e8 08             	sub    $0x8,%eax
  80298a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	8d 50 08             	lea    0x8(%eax),%edx
  802993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802996:	01 d0                	add    %edx,%eax
  802998:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	83 c0 08             	add    $0x8,%eax
  8029a1:	83 ec 04             	sub    $0x4,%esp
  8029a4:	6a 01                	push   $0x1
  8029a6:	50                   	push   %eax
  8029a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8029aa:	e8 c3 f8 ff ff       	call   802272 <set_block_data>
  8029af:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	75 68                	jne    802a24 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c0:	75 17                	jne    8029d9 <alloc_block_BF+0x27c>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 84 44 80 00       	push   $0x804484
  8029ca:	68 45 01 00 00       	push   $0x145
  8029cf:	68 69 44 80 00       	push   $0x804469
  8029d4:	e8 e1 0f 00 00       	call   8039ba <_panic>
  8029d9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e2:	89 10                	mov    %edx,(%eax)
  8029e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 0d                	je     8029fa <alloc_block_BF+0x29d>
  8029ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029f2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029f5:	89 50 04             	mov    %edx,0x4(%eax)
  8029f8:	eb 08                	jmp    802a02 <alloc_block_BF+0x2a5>
  8029fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fd:	a3 30 50 80 00       	mov    %eax,0x805030
  802a02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a05:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a14:	a1 38 50 80 00       	mov    0x805038,%eax
  802a19:	40                   	inc    %eax
  802a1a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a1f:	e9 dc 00 00 00       	jmp    802b00 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 65                	jne    802a92 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a31:	75 17                	jne    802a4a <alloc_block_BF+0x2ed>
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 b8 44 80 00       	push   $0x8044b8
  802a3b:	68 4a 01 00 00       	push   $0x14a
  802a40:	68 69 44 80 00       	push   $0x804469
  802a45:	e8 70 0f 00 00       	call   8039ba <_panic>
  802a4a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a53:	89 50 04             	mov    %edx,0x4(%eax)
  802a56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 0c                	je     802a6c <alloc_block_BF+0x30f>
  802a60:	a1 30 50 80 00       	mov    0x805030,%eax
  802a65:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	eb 08                	jmp    802a74 <alloc_block_BF+0x317>
  802a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a77:	a3 30 50 80 00       	mov    %eax,0x805030
  802a7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a85:	a1 38 50 80 00       	mov    0x805038,%eax
  802a8a:	40                   	inc    %eax
  802a8b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a90:	eb 6e                	jmp    802b00 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a96:	74 06                	je     802a9e <alloc_block_BF+0x341>
  802a98:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a9c:	75 17                	jne    802ab5 <alloc_block_BF+0x358>
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	68 dc 44 80 00       	push   $0x8044dc
  802aa6:	68 4f 01 00 00       	push   $0x14f
  802aab:	68 69 44 80 00       	push   $0x804469
  802ab0:	e8 05 0f 00 00       	call   8039ba <_panic>
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 10                	mov    (%eax),%edx
  802aba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 0b                	je     802ad3 <alloc_block_BF+0x376>
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad0:	89 50 04             	mov    %edx,0x4(%eax)
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad9:	89 10                	mov    %edx,(%eax)
  802adb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ade:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	75 08                	jne    802af5 <alloc_block_BF+0x398>
  802aed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af0:	a3 30 50 80 00       	mov    %eax,0x805030
  802af5:	a1 38 50 80 00       	mov    0x805038,%eax
  802afa:	40                   	inc    %eax
  802afb:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b04:	75 17                	jne    802b1d <alloc_block_BF+0x3c0>
  802b06:	83 ec 04             	sub    $0x4,%esp
  802b09:	68 4b 44 80 00       	push   $0x80444b
  802b0e:	68 51 01 00 00       	push   $0x151
  802b13:	68 69 44 80 00       	push   $0x804469
  802b18:	e8 9d 0e 00 00       	call   8039ba <_panic>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 10                	je     802b36 <alloc_block_BF+0x3d9>
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2e:	8b 52 04             	mov    0x4(%edx),%edx
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	eb 0b                	jmp    802b41 <alloc_block_BF+0x3e4>
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 40 04             	mov    0x4(%eax),%eax
  802b3c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 0f                	je     802b5a <alloc_block_BF+0x3fd>
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	8b 40 04             	mov    0x4(%eax),%eax
  802b51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b54:	8b 12                	mov    (%edx),%edx
  802b56:	89 10                	mov    %edx,(%eax)
  802b58:	eb 0a                	jmp    802b64 <alloc_block_BF+0x407>
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b77:	a1 38 50 80 00       	mov    0x805038,%eax
  802b7c:	48                   	dec    %eax
  802b7d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	6a 00                	push   $0x0
  802b87:	ff 75 d0             	pushl  -0x30(%ebp)
  802b8a:	ff 75 cc             	pushl  -0x34(%ebp)
  802b8d:	e8 e0 f6 ff ff       	call   802272 <set_block_data>
  802b92:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	e9 a3 01 00 00       	jmp    802d40 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b9d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ba1:	0f 85 9d 00 00 00    	jne    802c44 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ba7:	83 ec 04             	sub    $0x4,%esp
  802baa:	6a 01                	push   $0x1
  802bac:	ff 75 ec             	pushl  -0x14(%ebp)
  802baf:	ff 75 f0             	pushl  -0x10(%ebp)
  802bb2:	e8 bb f6 ff ff       	call   802272 <set_block_data>
  802bb7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bbe:	75 17                	jne    802bd7 <alloc_block_BF+0x47a>
  802bc0:	83 ec 04             	sub    $0x4,%esp
  802bc3:	68 4b 44 80 00       	push   $0x80444b
  802bc8:	68 58 01 00 00       	push   $0x158
  802bcd:	68 69 44 80 00       	push   $0x804469
  802bd2:	e8 e3 0d 00 00       	call   8039ba <_panic>
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 10                	je     802bf0 <alloc_block_BF+0x493>
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be8:	8b 52 04             	mov    0x4(%edx),%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	eb 0b                	jmp    802bfb <alloc_block_BF+0x49e>
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	85 c0                	test   %eax,%eax
  802c03:	74 0f                	je     802c14 <alloc_block_BF+0x4b7>
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0e:	8b 12                	mov    (%edx),%edx
  802c10:	89 10                	mov    %edx,(%eax)
  802c12:	eb 0a                	jmp    802c1e <alloc_block_BF+0x4c1>
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c31:	a1 38 50 80 00       	mov    0x805038,%eax
  802c36:	48                   	dec    %eax
  802c37:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	e9 fc 00 00 00       	jmp    802d40 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	83 c0 08             	add    $0x8,%eax
  802c4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c4d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c54:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c5a:	01 d0                	add    %edx,%eax
  802c5c:	48                   	dec    %eax
  802c5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c63:	ba 00 00 00 00       	mov    $0x0,%edx
  802c68:	f7 75 c4             	divl   -0x3c(%ebp)
  802c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c6e:	29 d0                	sub    %edx,%eax
  802c70:	c1 e8 0c             	shr    $0xc,%eax
  802c73:	83 ec 0c             	sub    $0xc,%esp
  802c76:	50                   	push   %eax
  802c77:	e8 a4 e7 ff ff       	call   801420 <sbrk>
  802c7c:	83 c4 10             	add    $0x10,%esp
  802c7f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c82:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c86:	75 0a                	jne    802c92 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c88:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8d:	e9 ae 00 00 00       	jmp    802d40 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c92:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c99:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c9c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c9f:	01 d0                	add    %edx,%eax
  802ca1:	48                   	dec    %eax
  802ca2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ca5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca8:	ba 00 00 00 00       	mov    $0x0,%edx
  802cad:	f7 75 b8             	divl   -0x48(%ebp)
  802cb0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cb3:	29 d0                	sub    %edx,%eax
  802cb5:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cb8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cbb:	01 d0                	add    %edx,%eax
  802cbd:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cc2:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ccd:	83 ec 0c             	sub    $0xc,%esp
  802cd0:	68 10 45 80 00       	push   $0x804510
  802cd5:	e8 ac d9 ff ff       	call   800686 <cprintf>
  802cda:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cdd:	83 ec 08             	sub    $0x8,%esp
  802ce0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ce3:	68 15 45 80 00       	push   $0x804515
  802ce8:	e8 99 d9 ff ff       	call   800686 <cprintf>
  802ced:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cf0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cf7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cfa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	48                   	dec    %eax
  802d00:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d03:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d06:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0b:	f7 75 b0             	divl   -0x50(%ebp)
  802d0e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d11:	29 d0                	sub    %edx,%eax
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	6a 01                	push   $0x1
  802d18:	50                   	push   %eax
  802d19:	ff 75 bc             	pushl  -0x44(%ebp)
  802d1c:	e8 51 f5 ff ff       	call   802272 <set_block_data>
  802d21:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d24:	83 ec 0c             	sub    $0xc,%esp
  802d27:	ff 75 bc             	pushl  -0x44(%ebp)
  802d2a:	e8 36 04 00 00       	call   803165 <free_block>
  802d2f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d32:	83 ec 0c             	sub    $0xc,%esp
  802d35:	ff 75 08             	pushl  0x8(%ebp)
  802d38:	e8 20 fa ff ff       	call   80275d <alloc_block_BF>
  802d3d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d40:	c9                   	leave  
  802d41:	c3                   	ret    

00802d42 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
  802d45:	53                   	push   %ebx
  802d46:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5b:	74 1e                	je     802d7b <merging+0x39>
  802d5d:	ff 75 08             	pushl  0x8(%ebp)
  802d60:	e8 bc f1 ff ff       	call   801f21 <get_block_size>
  802d65:	83 c4 04             	add    $0x4,%esp
  802d68:	89 c2                	mov    %eax,%edx
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	01 d0                	add    %edx,%eax
  802d6f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d72:	75 07                	jne    802d7b <merging+0x39>
		prev_is_free = 1;
  802d74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d7f:	74 1e                	je     802d9f <merging+0x5d>
  802d81:	ff 75 10             	pushl  0x10(%ebp)
  802d84:	e8 98 f1 ff ff       	call   801f21 <get_block_size>
  802d89:	83 c4 04             	add    $0x4,%esp
  802d8c:	89 c2                	mov    %eax,%edx
  802d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d91:	01 d0                	add    %edx,%eax
  802d93:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d96:	75 07                	jne    802d9f <merging+0x5d>
		next_is_free = 1;
  802d98:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da3:	0f 84 cc 00 00 00    	je     802e75 <merging+0x133>
  802da9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dad:	0f 84 c2 00 00 00    	je     802e75 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802db3:	ff 75 08             	pushl  0x8(%ebp)
  802db6:	e8 66 f1 ff ff       	call   801f21 <get_block_size>
  802dbb:	83 c4 04             	add    $0x4,%esp
  802dbe:	89 c3                	mov    %eax,%ebx
  802dc0:	ff 75 10             	pushl  0x10(%ebp)
  802dc3:	e8 59 f1 ff ff       	call   801f21 <get_block_size>
  802dc8:	83 c4 04             	add    $0x4,%esp
  802dcb:	01 c3                	add    %eax,%ebx
  802dcd:	ff 75 0c             	pushl  0xc(%ebp)
  802dd0:	e8 4c f1 ff ff       	call   801f21 <get_block_size>
  802dd5:	83 c4 04             	add    $0x4,%esp
  802dd8:	01 d8                	add    %ebx,%eax
  802dda:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ddd:	6a 00                	push   $0x0
  802ddf:	ff 75 ec             	pushl  -0x14(%ebp)
  802de2:	ff 75 08             	pushl  0x8(%ebp)
  802de5:	e8 88 f4 ff ff       	call   802272 <set_block_data>
  802dea:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ded:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df1:	75 17                	jne    802e0a <merging+0xc8>
  802df3:	83 ec 04             	sub    $0x4,%esp
  802df6:	68 4b 44 80 00       	push   $0x80444b
  802dfb:	68 7d 01 00 00       	push   $0x17d
  802e00:	68 69 44 80 00       	push   $0x804469
  802e05:	e8 b0 0b 00 00       	call   8039ba <_panic>
  802e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 10                	je     802e23 <merging+0xe1>
  802e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e1b:	8b 52 04             	mov    0x4(%edx),%edx
  802e1e:	89 50 04             	mov    %edx,0x4(%eax)
  802e21:	eb 0b                	jmp    802e2e <merging+0xec>
  802e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	a3 30 50 80 00       	mov    %eax,0x805030
  802e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	74 0f                	je     802e47 <merging+0x105>
  802e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e41:	8b 12                	mov    (%edx),%edx
  802e43:	89 10                	mov    %edx,(%eax)
  802e45:	eb 0a                	jmp    802e51 <merging+0x10f>
  802e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e64:	a1 38 50 80 00       	mov    0x805038,%eax
  802e69:	48                   	dec    %eax
  802e6a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e6f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e70:	e9 ea 02 00 00       	jmp    80315f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e79:	74 3b                	je     802eb6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e7b:	83 ec 0c             	sub    $0xc,%esp
  802e7e:	ff 75 08             	pushl  0x8(%ebp)
  802e81:	e8 9b f0 ff ff       	call   801f21 <get_block_size>
  802e86:	83 c4 10             	add    $0x10,%esp
  802e89:	89 c3                	mov    %eax,%ebx
  802e8b:	83 ec 0c             	sub    $0xc,%esp
  802e8e:	ff 75 10             	pushl  0x10(%ebp)
  802e91:	e8 8b f0 ff ff       	call   801f21 <get_block_size>
  802e96:	83 c4 10             	add    $0x10,%esp
  802e99:	01 d8                	add    %ebx,%eax
  802e9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	6a 00                	push   $0x0
  802ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  802ea6:	ff 75 08             	pushl  0x8(%ebp)
  802ea9:	e8 c4 f3 ff ff       	call   802272 <set_block_data>
  802eae:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eb1:	e9 a9 02 00 00       	jmp    80315f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802eb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eba:	0f 84 2d 01 00 00    	je     802fed <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ec0:	83 ec 0c             	sub    $0xc,%esp
  802ec3:	ff 75 10             	pushl  0x10(%ebp)
  802ec6:	e8 56 f0 ff ff       	call   801f21 <get_block_size>
  802ecb:	83 c4 10             	add    $0x10,%esp
  802ece:	89 c3                	mov    %eax,%ebx
  802ed0:	83 ec 0c             	sub    $0xc,%esp
  802ed3:	ff 75 0c             	pushl  0xc(%ebp)
  802ed6:	e8 46 f0 ff ff       	call   801f21 <get_block_size>
  802edb:	83 c4 10             	add    $0x10,%esp
  802ede:	01 d8                	add    %ebx,%eax
  802ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	6a 00                	push   $0x0
  802ee8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eeb:	ff 75 10             	pushl  0x10(%ebp)
  802eee:	e8 7f f3 ff ff       	call   802272 <set_block_data>
  802ef3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ef9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802efc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f00:	74 06                	je     802f08 <merging+0x1c6>
  802f02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f06:	75 17                	jne    802f1f <merging+0x1dd>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 24 45 80 00       	push   $0x804524
  802f10:	68 8d 01 00 00       	push   $0x18d
  802f15:	68 69 44 80 00       	push   $0x804469
  802f1a:	e8 9b 0a 00 00       	call   8039ba <_panic>
  802f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f22:	8b 50 04             	mov    0x4(%eax),%edx
  802f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f31:	89 10                	mov    %edx,(%eax)
  802f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	85 c0                	test   %eax,%eax
  802f3b:	74 0d                	je     802f4a <merging+0x208>
  802f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f46:	89 10                	mov    %edx,(%eax)
  802f48:	eb 08                	jmp    802f52 <merging+0x210>
  802f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f58:	89 50 04             	mov    %edx,0x4(%eax)
  802f5b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6a:	75 17                	jne    802f83 <merging+0x241>
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	68 4b 44 80 00       	push   $0x80444b
  802f74:	68 8e 01 00 00       	push   $0x18e
  802f79:	68 69 44 80 00       	push   $0x804469
  802f7e:	e8 37 0a 00 00       	call   8039ba <_panic>
  802f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 10                	je     802f9c <merging+0x25a>
  802f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f94:	8b 52 04             	mov    0x4(%edx),%edx
  802f97:	89 50 04             	mov    %edx,0x4(%eax)
  802f9a:	eb 0b                	jmp    802fa7 <merging+0x265>
  802f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802faa:	8b 40 04             	mov    0x4(%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 0f                	je     802fc0 <merging+0x27e>
  802fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fba:	8b 12                	mov    (%edx),%edx
  802fbc:	89 10                	mov    %edx,(%eax)
  802fbe:	eb 0a                	jmp    802fca <merging+0x288>
  802fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdd:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe2:	48                   	dec    %eax
  802fe3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fe8:	e9 72 01 00 00       	jmp    80315f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fed:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff7:	74 79                	je     803072 <merging+0x330>
  802ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ffd:	74 73                	je     803072 <merging+0x330>
  802fff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803003:	74 06                	je     80300b <merging+0x2c9>
  803005:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803009:	75 17                	jne    803022 <merging+0x2e0>
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	68 dc 44 80 00       	push   $0x8044dc
  803013:	68 94 01 00 00       	push   $0x194
  803018:	68 69 44 80 00       	push   $0x804469
  80301d:	e8 98 09 00 00       	call   8039ba <_panic>
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 10                	mov    (%eax),%edx
  803027:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302a:	89 10                	mov    %edx,(%eax)
  80302c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	74 0b                	je     803040 <merging+0x2fe>
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303d:	89 50 04             	mov    %edx,0x4(%eax)
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803046:	89 10                	mov    %edx,(%eax)
  803048:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304b:	8b 55 08             	mov    0x8(%ebp),%edx
  80304e:	89 50 04             	mov    %edx,0x4(%eax)
  803051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	75 08                	jne    803062 <merging+0x320>
  80305a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305d:	a3 30 50 80 00       	mov    %eax,0x805030
  803062:	a1 38 50 80 00       	mov    0x805038,%eax
  803067:	40                   	inc    %eax
  803068:	a3 38 50 80 00       	mov    %eax,0x805038
  80306d:	e9 ce 00 00 00       	jmp    803140 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803076:	74 65                	je     8030dd <merging+0x39b>
  803078:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80307c:	75 17                	jne    803095 <merging+0x353>
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	68 b8 44 80 00       	push   $0x8044b8
  803086:	68 95 01 00 00       	push   $0x195
  80308b:	68 69 44 80 00       	push   $0x804469
  803090:	e8 25 09 00 00       	call   8039ba <_panic>
  803095:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80309b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a4:	8b 40 04             	mov    0x4(%eax),%eax
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	74 0c                	je     8030b7 <merging+0x375>
  8030ab:	a1 30 50 80 00       	mov    0x805030,%eax
  8030b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030b3:	89 10                	mov    %edx,(%eax)
  8030b5:	eb 08                	jmp    8030bf <merging+0x37d>
  8030b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d5:	40                   	inc    %eax
  8030d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8030db:	eb 63                	jmp    803140 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030e1:	75 17                	jne    8030fa <merging+0x3b8>
  8030e3:	83 ec 04             	sub    $0x4,%esp
  8030e6:	68 84 44 80 00       	push   $0x804484
  8030eb:	68 98 01 00 00       	push   $0x198
  8030f0:	68 69 44 80 00       	push   $0x804469
  8030f5:	e8 c0 08 00 00       	call   8039ba <_panic>
  8030fa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803103:	89 10                	mov    %edx,(%eax)
  803105:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 0d                	je     80311b <merging+0x3d9>
  80310e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803113:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	eb 08                	jmp    803123 <merging+0x3e1>
  80311b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311e:	a3 30 50 80 00       	mov    %eax,0x805030
  803123:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803126:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80312b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803135:	a1 38 50 80 00       	mov    0x805038,%eax
  80313a:	40                   	inc    %eax
  80313b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803140:	83 ec 0c             	sub    $0xc,%esp
  803143:	ff 75 10             	pushl  0x10(%ebp)
  803146:	e8 d6 ed ff ff       	call   801f21 <get_block_size>
  80314b:	83 c4 10             	add    $0x10,%esp
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	6a 00                	push   $0x0
  803153:	50                   	push   %eax
  803154:	ff 75 10             	pushl  0x10(%ebp)
  803157:	e8 16 f1 ff ff       	call   802272 <set_block_data>
  80315c:	83 c4 10             	add    $0x10,%esp
	}
}
  80315f:	90                   	nop
  803160:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803163:	c9                   	leave  
  803164:	c3                   	ret    

00803165 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803165:	55                   	push   %ebp
  803166:	89 e5                	mov    %esp,%ebp
  803168:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80316b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803170:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803173:	a1 30 50 80 00       	mov    0x805030,%eax
  803178:	3b 45 08             	cmp    0x8(%ebp),%eax
  80317b:	73 1b                	jae    803198 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80317d:	a1 30 50 80 00       	mov    0x805030,%eax
  803182:	83 ec 04             	sub    $0x4,%esp
  803185:	ff 75 08             	pushl  0x8(%ebp)
  803188:	6a 00                	push   $0x0
  80318a:	50                   	push   %eax
  80318b:	e8 b2 fb ff ff       	call   802d42 <merging>
  803190:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803193:	e9 8b 00 00 00       	jmp    803223 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803198:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80319d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a0:	76 18                	jbe    8031ba <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	ff 75 08             	pushl  0x8(%ebp)
  8031ad:	50                   	push   %eax
  8031ae:	6a 00                	push   $0x0
  8031b0:	e8 8d fb ff ff       	call   802d42 <merging>
  8031b5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031b8:	eb 69                	jmp    803223 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c2:	eb 39                	jmp    8031fd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ca:	73 29                	jae    8031f5 <free_block+0x90>
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d4:	76 1f                	jbe    8031f5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	ff 75 08             	pushl  0x8(%ebp)
  8031e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031ea:	e8 53 fb ff ff       	call   802d42 <merging>
  8031ef:	83 c4 10             	add    $0x10,%esp
			break;
  8031f2:	90                   	nop
		}
	}
}
  8031f3:	eb 2e                	jmp    803223 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031f5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	74 07                	je     80320a <free_block+0xa5>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	eb 05                	jmp    80320f <free_block+0xaa>
  80320a:	b8 00 00 00 00       	mov    $0x0,%eax
  80320f:	a3 34 50 80 00       	mov    %eax,0x805034
  803214:	a1 34 50 80 00       	mov    0x805034,%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	75 a7                	jne    8031c4 <free_block+0x5f>
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	75 a1                	jne    8031c4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803223:	90                   	nop
  803224:	c9                   	leave  
  803225:	c3                   	ret    

00803226 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803226:	55                   	push   %ebp
  803227:	89 e5                	mov    %esp,%ebp
  803229:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80322c:	ff 75 08             	pushl  0x8(%ebp)
  80322f:	e8 ed ec ff ff       	call   801f21 <get_block_size>
  803234:	83 c4 04             	add    $0x4,%esp
  803237:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80323a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803241:	eb 17                	jmp    80325a <copy_data+0x34>
  803243:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803246:	8b 45 0c             	mov    0xc(%ebp),%eax
  803249:	01 c2                	add    %eax,%edx
  80324b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	01 c8                	add    %ecx,%eax
  803253:	8a 00                	mov    (%eax),%al
  803255:	88 02                	mov    %al,(%edx)
  803257:	ff 45 fc             	incl   -0x4(%ebp)
  80325a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80325d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803260:	72 e1                	jb     803243 <copy_data+0x1d>
}
  803262:	90                   	nop
  803263:	c9                   	leave  
  803264:	c3                   	ret    

00803265 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803265:	55                   	push   %ebp
  803266:	89 e5                	mov    %esp,%ebp
  803268:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80326b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326f:	75 23                	jne    803294 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803271:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803275:	74 13                	je     80328a <realloc_block_FF+0x25>
  803277:	83 ec 0c             	sub    $0xc,%esp
  80327a:	ff 75 0c             	pushl  0xc(%ebp)
  80327d:	e8 1f f0 ff ff       	call   8022a1 <alloc_block_FF>
  803282:	83 c4 10             	add    $0x10,%esp
  803285:	e9 f4 06 00 00       	jmp    80397e <realloc_block_FF+0x719>
		return NULL;
  80328a:	b8 00 00 00 00       	mov    $0x0,%eax
  80328f:	e9 ea 06 00 00       	jmp    80397e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803294:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803298:	75 18                	jne    8032b2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80329a:	83 ec 0c             	sub    $0xc,%esp
  80329d:	ff 75 08             	pushl  0x8(%ebp)
  8032a0:	e8 c0 fe ff ff       	call   803165 <free_block>
  8032a5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	e9 cc 06 00 00       	jmp    80397e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032b2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032b6:	77 07                	ja     8032bf <realloc_block_FF+0x5a>
  8032b8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c2:	83 e0 01             	and    $0x1,%eax
  8032c5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032cb:	83 c0 08             	add    $0x8,%eax
  8032ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032d1:	83 ec 0c             	sub    $0xc,%esp
  8032d4:	ff 75 08             	pushl  0x8(%ebp)
  8032d7:	e8 45 ec ff ff       	call   801f21 <get_block_size>
  8032dc:	83 c4 10             	add    $0x10,%esp
  8032df:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e5:	83 e8 08             	sub    $0x8,%eax
  8032e8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	83 e8 04             	sub    $0x4,%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	83 e0 fe             	and    $0xfffffffe,%eax
  8032f6:	89 c2                	mov    %eax,%edx
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	01 d0                	add    %edx,%eax
  8032fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803300:	83 ec 0c             	sub    $0xc,%esp
  803303:	ff 75 e4             	pushl  -0x1c(%ebp)
  803306:	e8 16 ec ff ff       	call   801f21 <get_block_size>
  80330b:	83 c4 10             	add    $0x10,%esp
  80330e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803311:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803314:	83 e8 08             	sub    $0x8,%eax
  803317:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80331a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803320:	75 08                	jne    80332a <realloc_block_FF+0xc5>
	{
		 return va;
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	e9 54 06 00 00       	jmp    80397e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80332a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803330:	0f 83 e5 03 00 00    	jae    80371b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	2b 45 0c             	sub    0xc(%ebp),%eax
  80333c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80333f:	83 ec 0c             	sub    $0xc,%esp
  803342:	ff 75 e4             	pushl  -0x1c(%ebp)
  803345:	e8 f0 eb ff ff       	call   801f3a <is_free_block>
  80334a:	83 c4 10             	add    $0x10,%esp
  80334d:	84 c0                	test   %al,%al
  80334f:	0f 84 3b 01 00 00    	je     803490 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803355:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803358:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803360:	83 ec 04             	sub    $0x4,%esp
  803363:	6a 01                	push   $0x1
  803365:	ff 75 f0             	pushl  -0x10(%ebp)
  803368:	ff 75 08             	pushl  0x8(%ebp)
  80336b:	e8 02 ef ff ff       	call   802272 <set_block_data>
  803370:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	83 e8 04             	sub    $0x4,%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	83 e0 fe             	and    $0xfffffffe,%eax
  80337e:	89 c2                	mov    %eax,%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	01 d0                	add    %edx,%eax
  803385:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	6a 00                	push   $0x0
  80338d:	ff 75 cc             	pushl  -0x34(%ebp)
  803390:	ff 75 c8             	pushl  -0x38(%ebp)
  803393:	e8 da ee ff ff       	call   802272 <set_block_data>
  803398:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80339b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80339f:	74 06                	je     8033a7 <realloc_block_FF+0x142>
  8033a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033a5:	75 17                	jne    8033be <realloc_block_FF+0x159>
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	68 dc 44 80 00       	push   $0x8044dc
  8033af:	68 f6 01 00 00       	push   $0x1f6
  8033b4:	68 69 44 80 00       	push   $0x804469
  8033b9:	e8 fc 05 00 00       	call   8039ba <_panic>
  8033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c1:	8b 10                	mov    (%eax),%edx
  8033c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c6:	89 10                	mov    %edx,(%eax)
  8033c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033cb:	8b 00                	mov    (%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0b                	je     8033dc <realloc_block_FF+0x177>
  8033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033d9:	89 50 04             	mov    %edx,0x4(%eax)
  8033dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033df:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033e2:	89 10                	mov    %edx,(%eax)
  8033e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ea:	89 50 04             	mov    %edx,0x4(%eax)
  8033ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	75 08                	jne    8033fe <realloc_block_FF+0x199>
  8033f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803403:	40                   	inc    %eax
  803404:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803409:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80340d:	75 17                	jne    803426 <realloc_block_FF+0x1c1>
  80340f:	83 ec 04             	sub    $0x4,%esp
  803412:	68 4b 44 80 00       	push   $0x80444b
  803417:	68 f7 01 00 00       	push   $0x1f7
  80341c:	68 69 44 80 00       	push   $0x804469
  803421:	e8 94 05 00 00       	call   8039ba <_panic>
  803426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 10                	je     80343f <realloc_block_FF+0x1da>
  80342f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803437:	8b 52 04             	mov    0x4(%edx),%edx
  80343a:	89 50 04             	mov    %edx,0x4(%eax)
  80343d:	eb 0b                	jmp    80344a <realloc_block_FF+0x1e5>
  80343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803442:	8b 40 04             	mov    0x4(%eax),%eax
  803445:	a3 30 50 80 00       	mov    %eax,0x805030
  80344a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	74 0f                	je     803463 <realloc_block_FF+0x1fe>
  803454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803457:	8b 40 04             	mov    0x4(%eax),%eax
  80345a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345d:	8b 12                	mov    (%edx),%edx
  80345f:	89 10                	mov    %edx,(%eax)
  803461:	eb 0a                	jmp    80346d <realloc_block_FF+0x208>
  803463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80346d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803480:	a1 38 50 80 00       	mov    0x805038,%eax
  803485:	48                   	dec    %eax
  803486:	a3 38 50 80 00       	mov    %eax,0x805038
  80348b:	e9 83 02 00 00       	jmp    803713 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803490:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803494:	0f 86 69 02 00 00    	jbe    803703 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80349a:	83 ec 04             	sub    $0x4,%esp
  80349d:	6a 01                	push   $0x1
  80349f:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a2:	ff 75 08             	pushl  0x8(%ebp)
  8034a5:	e8 c8 ed ff ff       	call   802272 <set_block_data>
  8034aa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	83 e8 04             	sub    $0x4,%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8034b8:	89 c2                	mov    %eax,%edx
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	01 d0                	add    %edx,%eax
  8034bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034ca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034ce:	75 68                	jne    803538 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034d4:	75 17                	jne    8034ed <realloc_block_FF+0x288>
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	68 84 44 80 00       	push   $0x804484
  8034de:	68 06 02 00 00       	push   $0x206
  8034e3:	68 69 44 80 00       	push   $0x804469
  8034e8:	e8 cd 04 00 00       	call   8039ba <_panic>
  8034ed:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f6:	89 10                	mov    %edx,(%eax)
  8034f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	74 0d                	je     80350e <realloc_block_FF+0x2a9>
  803501:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803506:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803509:	89 50 04             	mov    %edx,0x4(%eax)
  80350c:	eb 08                	jmp    803516 <realloc_block_FF+0x2b1>
  80350e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803511:	a3 30 50 80 00       	mov    %eax,0x805030
  803516:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803519:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80351e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803521:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803528:	a1 38 50 80 00       	mov    0x805038,%eax
  80352d:	40                   	inc    %eax
  80352e:	a3 38 50 80 00       	mov    %eax,0x805038
  803533:	e9 b0 01 00 00       	jmp    8036e8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803538:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80353d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803540:	76 68                	jbe    8035aa <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803542:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803546:	75 17                	jne    80355f <realloc_block_FF+0x2fa>
  803548:	83 ec 04             	sub    $0x4,%esp
  80354b:	68 84 44 80 00       	push   $0x804484
  803550:	68 0b 02 00 00       	push   $0x20b
  803555:	68 69 44 80 00       	push   $0x804469
  80355a:	e8 5b 04 00 00       	call   8039ba <_panic>
  80355f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803568:	89 10                	mov    %edx,(%eax)
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	85 c0                	test   %eax,%eax
  803571:	74 0d                	je     803580 <realloc_block_FF+0x31b>
  803573:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803578:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80357b:	89 50 04             	mov    %edx,0x4(%eax)
  80357e:	eb 08                	jmp    803588 <realloc_block_FF+0x323>
  803580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803583:	a3 30 50 80 00       	mov    %eax,0x805030
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803593:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359a:	a1 38 50 80 00       	mov    0x805038,%eax
  80359f:	40                   	inc    %eax
  8035a0:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a5:	e9 3e 01 00 00       	jmp    8036e8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035af:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b2:	73 68                	jae    80361c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035b8:	75 17                	jne    8035d1 <realloc_block_FF+0x36c>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 b8 44 80 00       	push   $0x8044b8
  8035c2:	68 10 02 00 00       	push   $0x210
  8035c7:	68 69 44 80 00       	push   $0x804469
  8035cc:	e8 e9 03 00 00       	call   8039ba <_panic>
  8035d1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035da:	89 50 04             	mov    %edx,0x4(%eax)
  8035dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e0:	8b 40 04             	mov    0x4(%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 0c                	je     8035f3 <realloc_block_FF+0x38e>
  8035e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ef:	89 10                	mov    %edx,(%eax)
  8035f1:	eb 08                	jmp    8035fb <realloc_block_FF+0x396>
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803603:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803606:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360c:	a1 38 50 80 00       	mov    0x805038,%eax
  803611:	40                   	inc    %eax
  803612:	a3 38 50 80 00       	mov    %eax,0x805038
  803617:	e9 cc 00 00 00       	jmp    8036e8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80361c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803623:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362b:	e9 8a 00 00 00       	jmp    8036ba <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803633:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803636:	73 7a                	jae    8036b2 <realloc_block_FF+0x44d>
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	8b 00                	mov    (%eax),%eax
  80363d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803640:	73 70                	jae    8036b2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803646:	74 06                	je     80364e <realloc_block_FF+0x3e9>
  803648:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80364c:	75 17                	jne    803665 <realloc_block_FF+0x400>
  80364e:	83 ec 04             	sub    $0x4,%esp
  803651:	68 dc 44 80 00       	push   $0x8044dc
  803656:	68 1a 02 00 00       	push   $0x21a
  80365b:	68 69 44 80 00       	push   $0x804469
  803660:	e8 55 03 00 00       	call   8039ba <_panic>
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	8b 10                	mov    (%eax),%edx
  80366a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366d:	89 10                	mov    %edx,(%eax)
  80366f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803672:	8b 00                	mov    (%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 0b                	je     803683 <realloc_block_FF+0x41e>
  803678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803680:	89 50 04             	mov    %edx,0x4(%eax)
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803689:	89 10                	mov    %edx,(%eax)
  80368b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	85 c0                	test   %eax,%eax
  80369b:	75 08                	jne    8036a5 <realloc_block_FF+0x440>
  80369d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8036aa:	40                   	inc    %eax
  8036ab:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036b0:	eb 36                	jmp    8036e8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036be:	74 07                	je     8036c7 <realloc_block_FF+0x462>
  8036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c3:	8b 00                	mov    (%eax),%eax
  8036c5:	eb 05                	jmp    8036cc <realloc_block_FF+0x467>
  8036c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cc:	a3 34 50 80 00       	mov    %eax,0x805034
  8036d1:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	0f 85 52 ff ff ff    	jne    803630 <realloc_block_FF+0x3cb>
  8036de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e2:	0f 85 48 ff ff ff    	jne    803630 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	6a 00                	push   $0x0
  8036ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8036f0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036f3:	e8 7a eb ff ff       	call   802272 <set_block_data>
  8036f8:	83 c4 10             	add    $0x10,%esp
				return va;
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	e9 7b 02 00 00       	jmp    80397e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803703:	83 ec 0c             	sub    $0xc,%esp
  803706:	68 59 45 80 00       	push   $0x804559
  80370b:	e8 76 cf ff ff       	call   800686 <cprintf>
  803710:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	e9 63 02 00 00       	jmp    80397e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80371b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803721:	0f 86 4d 02 00 00    	jbe    803974 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803727:	83 ec 0c             	sub    $0xc,%esp
  80372a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80372d:	e8 08 e8 ff ff       	call   801f3a <is_free_block>
  803732:	83 c4 10             	add    $0x10,%esp
  803735:	84 c0                	test   %al,%al
  803737:	0f 84 37 02 00 00    	je     803974 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80373d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803740:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803743:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803746:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803749:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80374c:	76 38                	jbe    803786 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80374e:	83 ec 0c             	sub    $0xc,%esp
  803751:	ff 75 08             	pushl  0x8(%ebp)
  803754:	e8 0c fa ff ff       	call   803165 <free_block>
  803759:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80375c:	83 ec 0c             	sub    $0xc,%esp
  80375f:	ff 75 0c             	pushl  0xc(%ebp)
  803762:	e8 3a eb ff ff       	call   8022a1 <alloc_block_FF>
  803767:	83 c4 10             	add    $0x10,%esp
  80376a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80376d:	83 ec 08             	sub    $0x8,%esp
  803770:	ff 75 c0             	pushl  -0x40(%ebp)
  803773:	ff 75 08             	pushl  0x8(%ebp)
  803776:	e8 ab fa ff ff       	call   803226 <copy_data>
  80377b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80377e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803781:	e9 f8 01 00 00       	jmp    80397e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80378c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80378f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803793:	0f 87 a0 00 00 00    	ja     803839 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803799:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80379d:	75 17                	jne    8037b6 <realloc_block_FF+0x551>
  80379f:	83 ec 04             	sub    $0x4,%esp
  8037a2:	68 4b 44 80 00       	push   $0x80444b
  8037a7:	68 38 02 00 00       	push   $0x238
  8037ac:	68 69 44 80 00       	push   $0x804469
  8037b1:	e8 04 02 00 00       	call   8039ba <_panic>
  8037b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b9:	8b 00                	mov    (%eax),%eax
  8037bb:	85 c0                	test   %eax,%eax
  8037bd:	74 10                	je     8037cf <realloc_block_FF+0x56a>
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c7:	8b 52 04             	mov    0x4(%edx),%edx
  8037ca:	89 50 04             	mov    %edx,0x4(%eax)
  8037cd:	eb 0b                	jmp    8037da <realloc_block_FF+0x575>
  8037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d2:	8b 40 04             	mov    0x4(%eax),%eax
  8037d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8037da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dd:	8b 40 04             	mov    0x4(%eax),%eax
  8037e0:	85 c0                	test   %eax,%eax
  8037e2:	74 0f                	je     8037f3 <realloc_block_FF+0x58e>
  8037e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ed:	8b 12                	mov    (%edx),%edx
  8037ef:	89 10                	mov    %edx,(%eax)
  8037f1:	eb 0a                	jmp    8037fd <realloc_block_FF+0x598>
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 00                	mov    (%eax),%eax
  8037f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803809:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803810:	a1 38 50 80 00       	mov    0x805038,%eax
  803815:	48                   	dec    %eax
  803816:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80381b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80381e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803821:	01 d0                	add    %edx,%eax
  803823:	83 ec 04             	sub    $0x4,%esp
  803826:	6a 01                	push   $0x1
  803828:	50                   	push   %eax
  803829:	ff 75 08             	pushl  0x8(%ebp)
  80382c:	e8 41 ea ff ff       	call   802272 <set_block_data>
  803831:	83 c4 10             	add    $0x10,%esp
  803834:	e9 36 01 00 00       	jmp    80396f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803839:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80383c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80383f:	01 d0                	add    %edx,%eax
  803841:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	6a 01                	push   $0x1
  803849:	ff 75 f0             	pushl  -0x10(%ebp)
  80384c:	ff 75 08             	pushl  0x8(%ebp)
  80384f:	e8 1e ea ff ff       	call   802272 <set_block_data>
  803854:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	83 e8 04             	sub    $0x4,%eax
  80385d:	8b 00                	mov    (%eax),%eax
  80385f:	83 e0 fe             	and    $0xfffffffe,%eax
  803862:	89 c2                	mov    %eax,%edx
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	01 d0                	add    %edx,%eax
  803869:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80386c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803870:	74 06                	je     803878 <realloc_block_FF+0x613>
  803872:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803876:	75 17                	jne    80388f <realloc_block_FF+0x62a>
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	68 dc 44 80 00       	push   $0x8044dc
  803880:	68 44 02 00 00       	push   $0x244
  803885:	68 69 44 80 00       	push   $0x804469
  80388a:	e8 2b 01 00 00       	call   8039ba <_panic>
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 10                	mov    (%eax),%edx
  803894:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803897:	89 10                	mov    %edx,(%eax)
  803899:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80389c:	8b 00                	mov    (%eax),%eax
  80389e:	85 c0                	test   %eax,%eax
  8038a0:	74 0b                	je     8038ad <realloc_block_FF+0x648>
  8038a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038aa:	89 50 04             	mov    %edx,0x4(%eax)
  8038ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038b3:	89 10                	mov    %edx,(%eax)
  8038b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038bb:	89 50 04             	mov    %edx,0x4(%eax)
  8038be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c1:	8b 00                	mov    (%eax),%eax
  8038c3:	85 c0                	test   %eax,%eax
  8038c5:	75 08                	jne    8038cf <realloc_block_FF+0x66a>
  8038c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8038cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8038d4:	40                   	inc    %eax
  8038d5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038de:	75 17                	jne    8038f7 <realloc_block_FF+0x692>
  8038e0:	83 ec 04             	sub    $0x4,%esp
  8038e3:	68 4b 44 80 00       	push   $0x80444b
  8038e8:	68 45 02 00 00       	push   $0x245
  8038ed:	68 69 44 80 00       	push   $0x804469
  8038f2:	e8 c3 00 00 00       	call   8039ba <_panic>
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	85 c0                	test   %eax,%eax
  8038fe:	74 10                	je     803910 <realloc_block_FF+0x6ab>
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803908:	8b 52 04             	mov    0x4(%edx),%edx
  80390b:	89 50 04             	mov    %edx,0x4(%eax)
  80390e:	eb 0b                	jmp    80391b <realloc_block_FF+0x6b6>
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	8b 40 04             	mov    0x4(%eax),%eax
  803916:	a3 30 50 80 00       	mov    %eax,0x805030
  80391b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391e:	8b 40 04             	mov    0x4(%eax),%eax
  803921:	85 c0                	test   %eax,%eax
  803923:	74 0f                	je     803934 <realloc_block_FF+0x6cf>
  803925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803928:	8b 40 04             	mov    0x4(%eax),%eax
  80392b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392e:	8b 12                	mov    (%edx),%edx
  803930:	89 10                	mov    %edx,(%eax)
  803932:	eb 0a                	jmp    80393e <realloc_block_FF+0x6d9>
  803934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803937:	8b 00                	mov    (%eax),%eax
  803939:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803951:	a1 38 50 80 00       	mov    0x805038,%eax
  803956:	48                   	dec    %eax
  803957:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80395c:	83 ec 04             	sub    $0x4,%esp
  80395f:	6a 00                	push   $0x0
  803961:	ff 75 bc             	pushl  -0x44(%ebp)
  803964:	ff 75 b8             	pushl  -0x48(%ebp)
  803967:	e8 06 e9 ff ff       	call   802272 <set_block_data>
  80396c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80396f:	8b 45 08             	mov    0x8(%ebp),%eax
  803972:	eb 0a                	jmp    80397e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803974:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80397e:	c9                   	leave  
  80397f:	c3                   	ret    

00803980 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803980:	55                   	push   %ebp
  803981:	89 e5                	mov    %esp,%ebp
  803983:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803986:	83 ec 04             	sub    $0x4,%esp
  803989:	68 60 45 80 00       	push   $0x804560
  80398e:	68 58 02 00 00       	push   $0x258
  803993:	68 69 44 80 00       	push   $0x804469
  803998:	e8 1d 00 00 00       	call   8039ba <_panic>

0080399d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80399d:	55                   	push   %ebp
  80399e:	89 e5                	mov    %esp,%ebp
  8039a0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039a3:	83 ec 04             	sub    $0x4,%esp
  8039a6:	68 88 45 80 00       	push   $0x804588
  8039ab:	68 61 02 00 00       	push   $0x261
  8039b0:	68 69 44 80 00       	push   $0x804469
  8039b5:	e8 00 00 00 00       	call   8039ba <_panic>

008039ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039ba:	55                   	push   %ebp
  8039bb:	89 e5                	mov    %esp,%ebp
  8039bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039c0:	8d 45 10             	lea    0x10(%ebp),%eax
  8039c3:	83 c0 04             	add    $0x4,%eax
  8039c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039c9:	a1 60 50 90 00       	mov    0x905060,%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	74 16                	je     8039e8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039d2:	a1 60 50 90 00       	mov    0x905060,%eax
  8039d7:	83 ec 08             	sub    $0x8,%esp
  8039da:	50                   	push   %eax
  8039db:	68 b0 45 80 00       	push   $0x8045b0
  8039e0:	e8 a1 cc ff ff       	call   800686 <cprintf>
  8039e5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8039e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8039ed:	ff 75 0c             	pushl  0xc(%ebp)
  8039f0:	ff 75 08             	pushl  0x8(%ebp)
  8039f3:	50                   	push   %eax
  8039f4:	68 b5 45 80 00       	push   $0x8045b5
  8039f9:	e8 88 cc ff ff       	call   800686 <cprintf>
  8039fe:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a01:	8b 45 10             	mov    0x10(%ebp),%eax
  803a04:	83 ec 08             	sub    $0x8,%esp
  803a07:	ff 75 f4             	pushl  -0xc(%ebp)
  803a0a:	50                   	push   %eax
  803a0b:	e8 0b cc ff ff       	call   80061b <vcprintf>
  803a10:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a13:	83 ec 08             	sub    $0x8,%esp
  803a16:	6a 00                	push   $0x0
  803a18:	68 d1 45 80 00       	push   $0x8045d1
  803a1d:	e8 f9 cb ff ff       	call   80061b <vcprintf>
  803a22:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a25:	e8 7a cb ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  803a2a:	eb fe                	jmp    803a2a <_panic+0x70>

00803a2c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a2c:	55                   	push   %ebp
  803a2d:	89 e5                	mov    %esp,%ebp
  803a2f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a32:	a1 20 50 80 00       	mov    0x805020,%eax
  803a37:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a40:	39 c2                	cmp    %eax,%edx
  803a42:	74 14                	je     803a58 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a44:	83 ec 04             	sub    $0x4,%esp
  803a47:	68 d4 45 80 00       	push   $0x8045d4
  803a4c:	6a 26                	push   $0x26
  803a4e:	68 20 46 80 00       	push   $0x804620
  803a53:	e8 62 ff ff ff       	call   8039ba <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a66:	e9 c5 00 00 00       	jmp    803b30 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a75:	8b 45 08             	mov    0x8(%ebp),%eax
  803a78:	01 d0                	add    %edx,%eax
  803a7a:	8b 00                	mov    (%eax),%eax
  803a7c:	85 c0                	test   %eax,%eax
  803a7e:	75 08                	jne    803a88 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a80:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a83:	e9 a5 00 00 00       	jmp    803b2d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a8f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a96:	eb 69                	jmp    803b01 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a98:	a1 20 50 80 00       	mov    0x805020,%eax
  803a9d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aa6:	89 d0                	mov    %edx,%eax
  803aa8:	01 c0                	add    %eax,%eax
  803aaa:	01 d0                	add    %edx,%eax
  803aac:	c1 e0 03             	shl    $0x3,%eax
  803aaf:	01 c8                	add    %ecx,%eax
  803ab1:	8a 40 04             	mov    0x4(%eax),%al
  803ab4:	84 c0                	test   %al,%al
  803ab6:	75 46                	jne    803afe <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ab8:	a1 20 50 80 00       	mov    0x805020,%eax
  803abd:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ac3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ac6:	89 d0                	mov    %edx,%eax
  803ac8:	01 c0                	add    %eax,%eax
  803aca:	01 d0                	add    %edx,%eax
  803acc:	c1 e0 03             	shl    $0x3,%eax
  803acf:	01 c8                	add    %ecx,%eax
  803ad1:	8b 00                	mov    (%eax),%eax
  803ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ad6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803ade:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803aea:	8b 45 08             	mov    0x8(%ebp),%eax
  803aed:	01 c8                	add    %ecx,%eax
  803aef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803af1:	39 c2                	cmp    %eax,%edx
  803af3:	75 09                	jne    803afe <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803af5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803afc:	eb 15                	jmp    803b13 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803afe:	ff 45 e8             	incl   -0x18(%ebp)
  803b01:	a1 20 50 80 00       	mov    0x805020,%eax
  803b06:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0f:	39 c2                	cmp    %eax,%edx
  803b11:	77 85                	ja     803a98 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b17:	75 14                	jne    803b2d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b19:	83 ec 04             	sub    $0x4,%esp
  803b1c:	68 2c 46 80 00       	push   $0x80462c
  803b21:	6a 3a                	push   $0x3a
  803b23:	68 20 46 80 00       	push   $0x804620
  803b28:	e8 8d fe ff ff       	call   8039ba <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b2d:	ff 45 f0             	incl   -0x10(%ebp)
  803b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b33:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b36:	0f 8c 2f ff ff ff    	jl     803a6b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b4a:	eb 26                	jmp    803b72 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b4c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b51:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b5a:	89 d0                	mov    %edx,%eax
  803b5c:	01 c0                	add    %eax,%eax
  803b5e:	01 d0                	add    %edx,%eax
  803b60:	c1 e0 03             	shl    $0x3,%eax
  803b63:	01 c8                	add    %ecx,%eax
  803b65:	8a 40 04             	mov    0x4(%eax),%al
  803b68:	3c 01                	cmp    $0x1,%al
  803b6a:	75 03                	jne    803b6f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b6c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b6f:	ff 45 e0             	incl   -0x20(%ebp)
  803b72:	a1 20 50 80 00       	mov    0x805020,%eax
  803b77:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b80:	39 c2                	cmp    %eax,%edx
  803b82:	77 c8                	ja     803b4c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b87:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b8a:	74 14                	je     803ba0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b8c:	83 ec 04             	sub    $0x4,%esp
  803b8f:	68 80 46 80 00       	push   $0x804680
  803b94:	6a 44                	push   $0x44
  803b96:	68 20 46 80 00       	push   $0x804620
  803b9b:	e8 1a fe ff ff       	call   8039ba <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ba0:	90                   	nop
  803ba1:	c9                   	leave  
  803ba2:	c3                   	ret    
  803ba3:	90                   	nop

00803ba4 <__udivdi3>:
  803ba4:	55                   	push   %ebp
  803ba5:	57                   	push   %edi
  803ba6:	56                   	push   %esi
  803ba7:	53                   	push   %ebx
  803ba8:	83 ec 1c             	sub    $0x1c,%esp
  803bab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803baf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bbb:	89 ca                	mov    %ecx,%edx
  803bbd:	89 f8                	mov    %edi,%eax
  803bbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bc3:	85 f6                	test   %esi,%esi
  803bc5:	75 2d                	jne    803bf4 <__udivdi3+0x50>
  803bc7:	39 cf                	cmp    %ecx,%edi
  803bc9:	77 65                	ja     803c30 <__udivdi3+0x8c>
  803bcb:	89 fd                	mov    %edi,%ebp
  803bcd:	85 ff                	test   %edi,%edi
  803bcf:	75 0b                	jne    803bdc <__udivdi3+0x38>
  803bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd6:	31 d2                	xor    %edx,%edx
  803bd8:	f7 f7                	div    %edi
  803bda:	89 c5                	mov    %eax,%ebp
  803bdc:	31 d2                	xor    %edx,%edx
  803bde:	89 c8                	mov    %ecx,%eax
  803be0:	f7 f5                	div    %ebp
  803be2:	89 c1                	mov    %eax,%ecx
  803be4:	89 d8                	mov    %ebx,%eax
  803be6:	f7 f5                	div    %ebp
  803be8:	89 cf                	mov    %ecx,%edi
  803bea:	89 fa                	mov    %edi,%edx
  803bec:	83 c4 1c             	add    $0x1c,%esp
  803bef:	5b                   	pop    %ebx
  803bf0:	5e                   	pop    %esi
  803bf1:	5f                   	pop    %edi
  803bf2:	5d                   	pop    %ebp
  803bf3:	c3                   	ret    
  803bf4:	39 ce                	cmp    %ecx,%esi
  803bf6:	77 28                	ja     803c20 <__udivdi3+0x7c>
  803bf8:	0f bd fe             	bsr    %esi,%edi
  803bfb:	83 f7 1f             	xor    $0x1f,%edi
  803bfe:	75 40                	jne    803c40 <__udivdi3+0x9c>
  803c00:	39 ce                	cmp    %ecx,%esi
  803c02:	72 0a                	jb     803c0e <__udivdi3+0x6a>
  803c04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c08:	0f 87 9e 00 00 00    	ja     803cac <__udivdi3+0x108>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	89 fa                	mov    %edi,%edx
  803c15:	83 c4 1c             	add    $0x1c,%esp
  803c18:	5b                   	pop    %ebx
  803c19:	5e                   	pop    %esi
  803c1a:	5f                   	pop    %edi
  803c1b:	5d                   	pop    %ebp
  803c1c:	c3                   	ret    
  803c1d:	8d 76 00             	lea    0x0(%esi),%esi
  803c20:	31 ff                	xor    %edi,%edi
  803c22:	31 c0                	xor    %eax,%eax
  803c24:	89 fa                	mov    %edi,%edx
  803c26:	83 c4 1c             	add    $0x1c,%esp
  803c29:	5b                   	pop    %ebx
  803c2a:	5e                   	pop    %esi
  803c2b:	5f                   	pop    %edi
  803c2c:	5d                   	pop    %ebp
  803c2d:	c3                   	ret    
  803c2e:	66 90                	xchg   %ax,%ax
  803c30:	89 d8                	mov    %ebx,%eax
  803c32:	f7 f7                	div    %edi
  803c34:	31 ff                	xor    %edi,%edi
  803c36:	89 fa                	mov    %edi,%edx
  803c38:	83 c4 1c             	add    $0x1c,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5f                   	pop    %edi
  803c3e:	5d                   	pop    %ebp
  803c3f:	c3                   	ret    
  803c40:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c45:	89 eb                	mov    %ebp,%ebx
  803c47:	29 fb                	sub    %edi,%ebx
  803c49:	89 f9                	mov    %edi,%ecx
  803c4b:	d3 e6                	shl    %cl,%esi
  803c4d:	89 c5                	mov    %eax,%ebp
  803c4f:	88 d9                	mov    %bl,%cl
  803c51:	d3 ed                	shr    %cl,%ebp
  803c53:	89 e9                	mov    %ebp,%ecx
  803c55:	09 f1                	or     %esi,%ecx
  803c57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c5b:	89 f9                	mov    %edi,%ecx
  803c5d:	d3 e0                	shl    %cl,%eax
  803c5f:	89 c5                	mov    %eax,%ebp
  803c61:	89 d6                	mov    %edx,%esi
  803c63:	88 d9                	mov    %bl,%cl
  803c65:	d3 ee                	shr    %cl,%esi
  803c67:	89 f9                	mov    %edi,%ecx
  803c69:	d3 e2                	shl    %cl,%edx
  803c6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6f:	88 d9                	mov    %bl,%cl
  803c71:	d3 e8                	shr    %cl,%eax
  803c73:	09 c2                	or     %eax,%edx
  803c75:	89 d0                	mov    %edx,%eax
  803c77:	89 f2                	mov    %esi,%edx
  803c79:	f7 74 24 0c          	divl   0xc(%esp)
  803c7d:	89 d6                	mov    %edx,%esi
  803c7f:	89 c3                	mov    %eax,%ebx
  803c81:	f7 e5                	mul    %ebp
  803c83:	39 d6                	cmp    %edx,%esi
  803c85:	72 19                	jb     803ca0 <__udivdi3+0xfc>
  803c87:	74 0b                	je     803c94 <__udivdi3+0xf0>
  803c89:	89 d8                	mov    %ebx,%eax
  803c8b:	31 ff                	xor    %edi,%edi
  803c8d:	e9 58 ff ff ff       	jmp    803bea <__udivdi3+0x46>
  803c92:	66 90                	xchg   %ax,%ax
  803c94:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c98:	89 f9                	mov    %edi,%ecx
  803c9a:	d3 e2                	shl    %cl,%edx
  803c9c:	39 c2                	cmp    %eax,%edx
  803c9e:	73 e9                	jae    803c89 <__udivdi3+0xe5>
  803ca0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ca3:	31 ff                	xor    %edi,%edi
  803ca5:	e9 40 ff ff ff       	jmp    803bea <__udivdi3+0x46>
  803caa:	66 90                	xchg   %ax,%ax
  803cac:	31 c0                	xor    %eax,%eax
  803cae:	e9 37 ff ff ff       	jmp    803bea <__udivdi3+0x46>
  803cb3:	90                   	nop

00803cb4 <__umoddi3>:
  803cb4:	55                   	push   %ebp
  803cb5:	57                   	push   %edi
  803cb6:	56                   	push   %esi
  803cb7:	53                   	push   %ebx
  803cb8:	83 ec 1c             	sub    $0x1c,%esp
  803cbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ccf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cd3:	89 f3                	mov    %esi,%ebx
  803cd5:	89 fa                	mov    %edi,%edx
  803cd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cdb:	89 34 24             	mov    %esi,(%esp)
  803cde:	85 c0                	test   %eax,%eax
  803ce0:	75 1a                	jne    803cfc <__umoddi3+0x48>
  803ce2:	39 f7                	cmp    %esi,%edi
  803ce4:	0f 86 a2 00 00 00    	jbe    803d8c <__umoddi3+0xd8>
  803cea:	89 c8                	mov    %ecx,%eax
  803cec:	89 f2                	mov    %esi,%edx
  803cee:	f7 f7                	div    %edi
  803cf0:	89 d0                	mov    %edx,%eax
  803cf2:	31 d2                	xor    %edx,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	39 f0                	cmp    %esi,%eax
  803cfe:	0f 87 ac 00 00 00    	ja     803db0 <__umoddi3+0xfc>
  803d04:	0f bd e8             	bsr    %eax,%ebp
  803d07:	83 f5 1f             	xor    $0x1f,%ebp
  803d0a:	0f 84 ac 00 00 00    	je     803dbc <__umoddi3+0x108>
  803d10:	bf 20 00 00 00       	mov    $0x20,%edi
  803d15:	29 ef                	sub    %ebp,%edi
  803d17:	89 fe                	mov    %edi,%esi
  803d19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d1d:	89 e9                	mov    %ebp,%ecx
  803d1f:	d3 e0                	shl    %cl,%eax
  803d21:	89 d7                	mov    %edx,%edi
  803d23:	89 f1                	mov    %esi,%ecx
  803d25:	d3 ef                	shr    %cl,%edi
  803d27:	09 c7                	or     %eax,%edi
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 e2                	shl    %cl,%edx
  803d2d:	89 14 24             	mov    %edx,(%esp)
  803d30:	89 d8                	mov    %ebx,%eax
  803d32:	d3 e0                	shl    %cl,%eax
  803d34:	89 c2                	mov    %eax,%edx
  803d36:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d3a:	d3 e0                	shl    %cl,%eax
  803d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d40:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d44:	89 f1                	mov    %esi,%ecx
  803d46:	d3 e8                	shr    %cl,%eax
  803d48:	09 d0                	or     %edx,%eax
  803d4a:	d3 eb                	shr    %cl,%ebx
  803d4c:	89 da                	mov    %ebx,%edx
  803d4e:	f7 f7                	div    %edi
  803d50:	89 d3                	mov    %edx,%ebx
  803d52:	f7 24 24             	mull   (%esp)
  803d55:	89 c6                	mov    %eax,%esi
  803d57:	89 d1                	mov    %edx,%ecx
  803d59:	39 d3                	cmp    %edx,%ebx
  803d5b:	0f 82 87 00 00 00    	jb     803de8 <__umoddi3+0x134>
  803d61:	0f 84 91 00 00 00    	je     803df8 <__umoddi3+0x144>
  803d67:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d6b:	29 f2                	sub    %esi,%edx
  803d6d:	19 cb                	sbb    %ecx,%ebx
  803d6f:	89 d8                	mov    %ebx,%eax
  803d71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d75:	d3 e0                	shl    %cl,%eax
  803d77:	89 e9                	mov    %ebp,%ecx
  803d79:	d3 ea                	shr    %cl,%edx
  803d7b:	09 d0                	or     %edx,%eax
  803d7d:	89 e9                	mov    %ebp,%ecx
  803d7f:	d3 eb                	shr    %cl,%ebx
  803d81:	89 da                	mov    %ebx,%edx
  803d83:	83 c4 1c             	add    $0x1c,%esp
  803d86:	5b                   	pop    %ebx
  803d87:	5e                   	pop    %esi
  803d88:	5f                   	pop    %edi
  803d89:	5d                   	pop    %ebp
  803d8a:	c3                   	ret    
  803d8b:	90                   	nop
  803d8c:	89 fd                	mov    %edi,%ebp
  803d8e:	85 ff                	test   %edi,%edi
  803d90:	75 0b                	jne    803d9d <__umoddi3+0xe9>
  803d92:	b8 01 00 00 00       	mov    $0x1,%eax
  803d97:	31 d2                	xor    %edx,%edx
  803d99:	f7 f7                	div    %edi
  803d9b:	89 c5                	mov    %eax,%ebp
  803d9d:	89 f0                	mov    %esi,%eax
  803d9f:	31 d2                	xor    %edx,%edx
  803da1:	f7 f5                	div    %ebp
  803da3:	89 c8                	mov    %ecx,%eax
  803da5:	f7 f5                	div    %ebp
  803da7:	89 d0                	mov    %edx,%eax
  803da9:	e9 44 ff ff ff       	jmp    803cf2 <__umoddi3+0x3e>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	89 c8                	mov    %ecx,%eax
  803db2:	89 f2                	mov    %esi,%edx
  803db4:	83 c4 1c             	add    $0x1c,%esp
  803db7:	5b                   	pop    %ebx
  803db8:	5e                   	pop    %esi
  803db9:	5f                   	pop    %edi
  803dba:	5d                   	pop    %ebp
  803dbb:	c3                   	ret    
  803dbc:	3b 04 24             	cmp    (%esp),%eax
  803dbf:	72 06                	jb     803dc7 <__umoddi3+0x113>
  803dc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dc5:	77 0f                	ja     803dd6 <__umoddi3+0x122>
  803dc7:	89 f2                	mov    %esi,%edx
  803dc9:	29 f9                	sub    %edi,%ecx
  803dcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dcf:	89 14 24             	mov    %edx,(%esp)
  803dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dda:	8b 14 24             	mov    (%esp),%edx
  803ddd:	83 c4 1c             	add    $0x1c,%esp
  803de0:	5b                   	pop    %ebx
  803de1:	5e                   	pop    %esi
  803de2:	5f                   	pop    %edi
  803de3:	5d                   	pop    %ebp
  803de4:	c3                   	ret    
  803de5:	8d 76 00             	lea    0x0(%esi),%esi
  803de8:	2b 04 24             	sub    (%esp),%eax
  803deb:	19 fa                	sbb    %edi,%edx
  803ded:	89 d1                	mov    %edx,%ecx
  803def:	89 c6                	mov    %eax,%esi
  803df1:	e9 71 ff ff ff       	jmp    803d67 <__umoddi3+0xb3>
  803df6:	66 90                	xchg   %ax,%ax
  803df8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dfc:	72 ea                	jb     803de8 <__umoddi3+0x134>
  803dfe:	89 d9                	mov    %ebx,%ecx
  803e00:	e9 62 ff ff ff       	jmp    803d67 <__umoddi3+0xb3>
