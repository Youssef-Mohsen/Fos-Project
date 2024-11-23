
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
  80003e:	e8 01 1c 00 00       	call   801c44 <sys_getparentenvid>
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
  800057:	68 60 3e 80 00       	push   $0x803e60
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 a7 17 00 00       	call   80180b <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 64 3e 80 00       	push   $0x803e64
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
  80008a:	68 6c 3e 80 00       	push   $0x803e6c
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
  8000ab:	68 7a 3e 80 00       	push   $0x803e7a
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
  80010c:	68 89 3e 80 00       	push   $0x803e89
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
  8001a2:	68 a5 3e 80 00       	push   $0x803ea5
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
  8001c4:	68 a7 3e 80 00       	push   $0x803ea7
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
  8001f2:	68 ac 3e 80 00       	push   $0x803eac
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
  800479:	e8 ad 17 00 00       	call   801c2b <sys_getenvindex>
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
  8004e7:	e8 c3 14 00 00       	call   8019af <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 c8 3e 80 00       	push   $0x803ec8
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
  800517:	68 f0 3e 80 00       	push   $0x803ef0
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
  800548:	68 18 3f 80 00       	push   $0x803f18
  80054d:	e8 34 01 00 00       	call   800686 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 70 3f 80 00       	push   $0x803f70
  800569:	e8 18 01 00 00       	call   800686 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 c8 3e 80 00       	push   $0x803ec8
  800579:	e8 08 01 00 00       	call   800686 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800581:	e8 43 14 00 00       	call   8019c9 <sys_unlock_cons>
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
  800599:	e8 59 16 00 00       	call   801bf7 <sys_destroy_env>
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
  8005aa:	e8 ae 16 00 00       	call   801c5d <sys_exit_env>
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
  8005f8:	e8 70 13 00 00       	call   80196d <sys_cputs>
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
  80066f:	e8 f9 12 00 00       	call   80196d <sys_cputs>
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
  8006b9:	e8 f1 12 00 00       	call   8019af <sys_lock_cons>
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
  8006d9:	e8 eb 12 00 00       	call   8019c9 <sys_unlock_cons>
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
  800723:	e8 c8 34 00 00       	call   803bf0 <__udivdi3>
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
  800773:	e8 88 35 00 00       	call   803d00 <__umoddi3>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	05 b4 41 80 00       	add    $0x8041b4,%eax
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
  8008ce:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
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
  8009af:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 19                	jne    8009d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	53                   	push   %ebx
  8009bb:	68 c5 41 80 00       	push   $0x8041c5
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
  8009d4:	68 ce 41 80 00       	push   $0x8041ce
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
  800a01:	be d1 41 80 00       	mov    $0x8041d1,%esi
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
  80140c:	68 48 43 80 00       	push   $0x804348
  801411:	68 3f 01 00 00       	push   $0x13f
  801416:	68 6a 43 80 00       	push   $0x80436a
  80141b:	e8 e4 25 00 00       	call   803a04 <_panic>

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
  80142c:	e8 e7 0a 00 00       	call   801f18 <sys_sbrk>
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
  8014a7:	e8 f0 08 00 00       	call   801d9c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 16                	je     8014c6 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 30 0e 00 00       	call   8022eb <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	e9 8a 01 00 00       	jmp    801650 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014c6:	e8 02 09 00 00       	call   801dcd <sys_isUHeapPlacementStrategyBESTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 84 7d 01 00 00    	je     801650 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 c9 12 00 00       	call   8027a7 <alloc_block_BF>
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
  80163f:	e8 0b 09 00 00       	call   801f4f <sys_allocate_user_mem>
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
  801687:	e8 df 08 00 00       	call   801f6b <get_block_size>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 12 1b 00 00       	call   8031af <free_block>
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
  80172f:	e8 ff 07 00 00       	call   801f33 <sys_free_user_mem>
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
  80173d:	68 78 43 80 00       	push   $0x804378
  801742:	68 85 00 00 00       	push   $0x85
  801747:	68 a2 43 80 00       	push   $0x8043a2
  80174c:	e8 b3 22 00 00       	call   803a04 <_panic>
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
  8017b2:	e8 83 03 00 00       	call   801b3a <sys_createSharedObject>
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
  8017d6:	68 ae 43 80 00       	push   $0x8043ae
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
  80181a:	e8 45 03 00 00       	call   801b64 <sys_getSizeOfSharedObject>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801825:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801829:	75 07                	jne    801832 <sget+0x27>
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
  801830:	eb 5c                	jmp    80188e <sget+0x83>
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
  801865:	eb 27                	jmp    80188e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	ff 75 e8             	pushl  -0x18(%ebp)
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	e8 09 03 00 00       	call   801b81 <sys_getSharedObject>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80187e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801882:	75 07                	jne    80188b <sget+0x80>
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	eb 03                	jmp    80188e <sget+0x83>
	return ptr;
  80188b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801896:	8b 55 08             	mov    0x8(%ebp),%edx
  801899:	a1 20 50 80 00       	mov    0x805020,%eax
  80189e:	8b 40 78             	mov    0x78(%eax),%eax
  8018a1:	29 c2                	sub    %eax,%edx
  8018a3:	89 d0                	mov    %edx,%eax
  8018a5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018aa:	c1 e8 0c             	shr    $0xc,%eax
  8018ad:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c0:	e8 db 02 00 00       	call   801ba0 <sys_freeSharedObject>
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	68 c0 43 80 00       	push   $0x8043c0
  8018dc:	68 dd 00 00 00       	push   $0xdd
  8018e1:	68 a2 43 80 00       	push   $0x8043a2
  8018e6:	e8 19 21 00 00       	call   803a04 <_panic>

008018eb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	68 e6 43 80 00       	push   $0x8043e6
  8018f9:	68 e9 00 00 00       	push   $0xe9
  8018fe:	68 a2 43 80 00       	push   $0x8043a2
  801903:	e8 fc 20 00 00       	call   803a04 <_panic>

00801908 <shrink>:

}
void shrink(uint32 newSize)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	68 e6 43 80 00       	push   $0x8043e6
  801916:	68 ee 00 00 00       	push   $0xee
  80191b:	68 a2 43 80 00       	push   $0x8043a2
  801920:	e8 df 20 00 00       	call   803a04 <_panic>

00801925 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	68 e6 43 80 00       	push   $0x8043e6
  801933:	68 f3 00 00 00       	push   $0xf3
  801938:	68 a2 43 80 00       	push   $0x8043a2
  80193d:	e8 c2 20 00 00       	call   803a04 <_panic>

00801942 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	57                   	push   %edi
  801946:	56                   	push   %esi
  801947:	53                   	push   %ebx
  801948:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801951:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801954:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801957:	8b 7d 18             	mov    0x18(%ebp),%edi
  80195a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80195d:	cd 30                	int    $0x30
  80195f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801962:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5f                   	pop    %edi
  80196b:	5d                   	pop    %ebp
  80196c:	c3                   	ret    

0080196d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	8b 45 10             	mov    0x10(%ebp),%eax
  801976:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801979:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	52                   	push   %edx
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	50                   	push   %eax
  801989:	6a 00                	push   $0x0
  80198b:	e8 b2 ff ff ff       	call   801942 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_cgetc>:

int
sys_cgetc(void)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 02                	push   $0x2
  8019a5:	e8 98 ff ff ff       	call   801942 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 03                	push   $0x3
  8019be:	e8 7f ff ff ff       	call   801942 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	90                   	nop
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 04                	push   $0x4
  8019d8:	e8 65 ff ff ff       	call   801942 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	6a 08                	push   $0x8
  8019f6:	e8 47 ff ff ff       	call   801942 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a05:	8b 75 18             	mov    0x18(%ebp),%esi
  801a08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	56                   	push   %esi
  801a15:	53                   	push   %ebx
  801a16:	51                   	push   %ecx
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	6a 09                	push   $0x9
  801a1b:	e8 22 ff ff ff       	call   801942 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5e                   	pop    %esi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    

00801a2a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	52                   	push   %edx
  801a3a:	50                   	push   %eax
  801a3b:	6a 0a                	push   $0xa
  801a3d:	e8 00 ff ff ff       	call   801942 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 0b                	push   $0xb
  801a58:	e8 e5 fe ff ff       	call   801942 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 0c                	push   $0xc
  801a71:	e8 cc fe ff ff       	call   801942 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 0d                	push   $0xd
  801a8a:	e8 b3 fe ff ff       	call   801942 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 0e                	push   $0xe
  801aa3:	e8 9a fe ff ff       	call   801942 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 0f                	push   $0xf
  801abc:	e8 81 fe ff ff       	call   801942 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	6a 10                	push   $0x10
  801ad6:	e8 67 fe ff ff       	call   801942 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 11                	push   $0x11
  801aef:	e8 4e fe ff ff       	call   801942 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	90                   	nop
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_cputc>:

void
sys_cputc(const char c)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	50                   	push   %eax
  801b13:	6a 01                	push   $0x1
  801b15:	e8 28 fe ff ff       	call   801942 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 14                	push   $0x14
  801b2f:	e8 0e fe ff ff       	call   801942 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	90                   	nop
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	8b 45 10             	mov    0x10(%ebp),%eax
  801b43:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	51                   	push   %ecx
  801b53:	52                   	push   %edx
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	50                   	push   %eax
  801b58:	6a 15                	push   $0x15
  801b5a:	e8 e3 fd ff ff       	call   801942 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 16                	push   $0x16
  801b77:	e8 c6 fd ff ff       	call   801942 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	51                   	push   %ecx
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 17                	push   $0x17
  801b96:	e8 a7 fd ff ff       	call   801942 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 18                	push   $0x18
  801bb3:	e8 8a fd ff ff       	call   801942 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	ff 75 14             	pushl  0x14(%ebp)
  801bc8:	ff 75 10             	pushl  0x10(%ebp)
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	6a 19                	push   $0x19
  801bd1:	e8 6c fd ff ff       	call   801942 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	50                   	push   %eax
  801bea:	6a 1a                	push   $0x1a
  801bec:	e8 51 fd ff ff       	call   801942 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	50                   	push   %eax
  801c06:	6a 1b                	push   $0x1b
  801c08:	e8 35 fd ff ff       	call   801942 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 05                	push   $0x5
  801c21:	e8 1c fd ff ff       	call   801942 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 06                	push   $0x6
  801c3a:	e8 03 fd ff ff       	call   801942 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 07                	push   $0x7
  801c53:	e8 ea fc ff ff       	call   801942 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_exit_env>:


void sys_exit_env(void)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 1c                	push   $0x1c
  801c6c:	e8 d1 fc ff ff       	call   801942 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	90                   	nop
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c7d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c80:	8d 50 04             	lea    0x4(%eax),%edx
  801c83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 1d                	push   $0x1d
  801c90:	e8 ad fc ff ff       	call   801942 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return result;
  801c98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca1:	89 01                	mov    %eax,(%ecx)
  801ca3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	c9                   	leave  
  801caa:	c2 04 00             	ret    $0x4

00801cad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	6a 13                	push   $0x13
  801cbf:	e8 7e fc ff ff       	call   801942 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc7:	90                   	nop
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_rcr2>:
uint32 sys_rcr2()
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 1e                	push   $0x1e
  801cd9:	e8 64 fc ff ff       	call   801942 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	50                   	push   %eax
  801cfc:	6a 1f                	push   $0x1f
  801cfe:	e8 3f fc ff ff       	call   801942 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <rsttst>:
void rsttst()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 21                	push   $0x21
  801d18:	e8 25 fc ff ff       	call   801942 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d2f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	ff 75 10             	pushl  0x10(%ebp)
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	6a 20                	push   $0x20
  801d43:	e8 fa fb ff ff       	call   801942 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <chktst>:
void chktst(uint32 n)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	6a 22                	push   $0x22
  801d5e:	e8 df fb ff ff       	call   801942 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return ;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <inctst>:

void inctst()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 23                	push   $0x23
  801d78:	e8 c5 fb ff ff       	call   801942 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d80:	90                   	nop
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <gettst>:
uint32 gettst()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 24                	push   $0x24
  801d92:	e8 ab fb ff ff       	call   801942 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 25                	push   $0x25
  801dae:	e8 8f fb ff ff       	call   801942 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801db9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 25                	push   $0x25
  801ddf:	e8 5e fb ff ff       	call   801942 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 25                	push   $0x25
  801e10:	e8 2d fb ff ff       	call   801942 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e1b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e1f:	75 07                	jne    801e28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e21:	b8 01 00 00 00       	mov    $0x1,%eax
  801e26:	eb 05                	jmp    801e2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 25                	push   $0x25
  801e41:	e8 fc fa ff ff       	call   801942 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
  801e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e50:	75 07                	jne    801e59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e52:	b8 01 00 00 00       	mov    $0x1,%eax
  801e57:	eb 05                	jmp    801e5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	ff 75 08             	pushl  0x8(%ebp)
  801e6e:	6a 26                	push   $0x26
  801e70:	e8 cd fa ff ff       	call   801942 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
	return ;
  801e78:	90                   	nop
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	53                   	push   %ebx
  801e8e:	51                   	push   %ecx
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	6a 27                	push   $0x27
  801e93:	e8 aa fa ff ff       	call   801942 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 28                	push   $0x28
  801eb3:	e8 8a fa ff ff       	call   801942 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ec0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	51                   	push   %ecx
  801ecc:	ff 75 10             	pushl  0x10(%ebp)
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	6a 29                	push   $0x29
  801ed3:	e8 6a fa ff ff       	call   801942 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	ff 75 10             	pushl  0x10(%ebp)
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	ff 75 08             	pushl  0x8(%ebp)
  801eed:	6a 12                	push   $0x12
  801eef:	e8 4e fa ff ff       	call   801942 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef7:	90                   	nop
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	52                   	push   %edx
  801f0a:	50                   	push   %eax
  801f0b:	6a 2a                	push   $0x2a
  801f0d:	e8 30 fa ff ff       	call   801942 <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
	return;
  801f15:	90                   	nop
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	50                   	push   %eax
  801f27:	6a 2b                	push   $0x2b
  801f29:	e8 14 fa ff ff       	call   801942 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	6a 2c                	push   $0x2c
  801f44:	e8 f9 f9 ff ff       	call   801942 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return;
  801f4c:	90                   	nop
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	6a 2d                	push   $0x2d
  801f60:	e8 dd f9 ff ff       	call   801942 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return;
  801f68:	90                   	nop
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	83 e8 04             	sub    $0x4,%eax
  801f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7d:	8b 00                	mov    (%eax),%eax
  801f7f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	83 e8 04             	sub    $0x4,%eax
  801f90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f96:	8b 00                	mov    (%eax),%eax
  801f98:	83 e0 01             	and    $0x1,%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	0f 94 c0             	sete   %al
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb2:	83 f8 02             	cmp    $0x2,%eax
  801fb5:	74 2b                	je     801fe2 <alloc_block+0x40>
  801fb7:	83 f8 02             	cmp    $0x2,%eax
  801fba:	7f 07                	jg     801fc3 <alloc_block+0x21>
  801fbc:	83 f8 01             	cmp    $0x1,%eax
  801fbf:	74 0e                	je     801fcf <alloc_block+0x2d>
  801fc1:	eb 58                	jmp    80201b <alloc_block+0x79>
  801fc3:	83 f8 03             	cmp    $0x3,%eax
  801fc6:	74 2d                	je     801ff5 <alloc_block+0x53>
  801fc8:	83 f8 04             	cmp    $0x4,%eax
  801fcb:	74 3b                	je     802008 <alloc_block+0x66>
  801fcd:	eb 4c                	jmp    80201b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	ff 75 08             	pushl  0x8(%ebp)
  801fd5:	e8 11 03 00 00       	call   8022eb <alloc_block_FF>
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe0:	eb 4a                	jmp    80202c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	ff 75 08             	pushl  0x8(%ebp)
  801fe8:	e8 fa 19 00 00       	call   8039e7 <alloc_block_NF>
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff3:	eb 37                	jmp    80202c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	e8 a7 07 00 00       	call   8027a7 <alloc_block_BF>
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802006:	eb 24                	jmp    80202c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	e8 b7 19 00 00       	call   8039ca <alloc_block_WF>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802019:	eb 11                	jmp    80202c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	68 f8 43 80 00       	push   $0x8043f8
  802023:	e8 5e e6 ff ff       	call   800686 <cprintf>
  802028:	83 c4 10             	add    $0x10,%esp
		break;
  80202b:	90                   	nop
	}
	return va;
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	53                   	push   %ebx
  802035:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	68 18 44 80 00       	push   $0x804418
  802040:	e8 41 e6 ff ff       	call   800686 <cprintf>
  802045:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802048:	83 ec 0c             	sub    $0xc,%esp
  80204b:	68 43 44 80 00       	push   $0x804443
  802050:	e8 31 e6 ff ff       	call   800686 <cprintf>
  802055:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205e:	eb 37                	jmp    802097 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	ff 75 f4             	pushl  -0xc(%ebp)
  802066:	e8 19 ff ff ff       	call   801f84 <is_free_block>
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	0f be d8             	movsbl %al,%ebx
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	ff 75 f4             	pushl  -0xc(%ebp)
  802077:	e8 ef fe ff ff       	call   801f6b <get_block_size>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	53                   	push   %ebx
  802083:	50                   	push   %eax
  802084:	68 5b 44 80 00       	push   $0x80445b
  802089:	e8 f8 e5 ff ff       	call   800686 <cprintf>
  80208e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802091:	8b 45 10             	mov    0x10(%ebp),%eax
  802094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209b:	74 07                	je     8020a4 <print_blocks_list+0x73>
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 00                	mov    (%eax),%eax
  8020a2:	eb 05                	jmp    8020a9 <print_blocks_list+0x78>
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	89 45 10             	mov    %eax,0x10(%ebp)
  8020ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	75 ad                	jne    802060 <print_blocks_list+0x2f>
  8020b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b7:	75 a7                	jne    802060 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	68 18 44 80 00       	push   $0x804418
  8020c1:	e8 c0 e5 ff ff       	call   800686 <cprintf>
  8020c6:	83 c4 10             	add    $0x10,%esp

}
  8020c9:	90                   	nop
  8020ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	83 e0 01             	and    $0x1,%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	74 03                	je     8020e2 <initialize_dynamic_allocator+0x13>
  8020df:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020e6:	0f 84 c7 01 00 00    	je     8022b3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020ec:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020f3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802103:	0f 87 ad 01 00 00    	ja     8022b6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	0f 89 a5 01 00 00    	jns    8022b9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802114:	8b 55 08             	mov    0x8(%ebp),%edx
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	01 d0                	add    %edx,%eax
  80211c:	83 e8 04             	sub    $0x4,%eax
  80211f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802124:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80212b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802133:	e9 87 00 00 00       	jmp    8021bf <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213c:	75 14                	jne    802152 <initialize_dynamic_allocator+0x83>
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	68 73 44 80 00       	push   $0x804473
  802146:	6a 79                	push   $0x79
  802148:	68 91 44 80 00       	push   $0x804491
  80214d:	e8 b2 18 00 00       	call   803a04 <_panic>
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 10                	je     80216b <initialize_dynamic_allocator+0x9c>
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802163:	8b 52 04             	mov    0x4(%edx),%edx
  802166:	89 50 04             	mov    %edx,0x4(%eax)
  802169:	eb 0b                	jmp    802176 <initialize_dynamic_allocator+0xa7>
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 40 04             	mov    0x4(%eax),%eax
  802171:	a3 30 50 80 00       	mov    %eax,0x805030
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	8b 40 04             	mov    0x4(%eax),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	74 0f                	je     80218f <initialize_dynamic_allocator+0xc0>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 40 04             	mov    0x4(%eax),%eax
  802186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802189:	8b 12                	mov    (%edx),%edx
  80218b:	89 10                	mov    %edx,(%eax)
  80218d:	eb 0a                	jmp    802199 <initialize_dynamic_allocator+0xca>
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 00                	mov    (%eax),%eax
  802194:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b1:	48                   	dec    %eax
  8021b2:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c3:	74 07                	je     8021cc <initialize_dynamic_allocator+0xfd>
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	eb 05                	jmp    8021d1 <initialize_dynamic_allocator+0x102>
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d1:	a3 34 50 80 00       	mov    %eax,0x805034
  8021d6:	a1 34 50 80 00       	mov    0x805034,%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	0f 85 55 ff ff ff    	jne    802138 <initialize_dynamic_allocator+0x69>
  8021e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e7:	0f 85 4b ff ff ff    	jne    802138 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021fc:	a1 44 50 80 00       	mov    0x805044,%eax
  802201:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802206:	a1 40 50 80 00       	mov    0x805040,%eax
  80220b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	83 c0 08             	add    $0x8,%eax
  802217:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	83 c0 04             	add    $0x4,%eax
  802220:	8b 55 0c             	mov    0xc(%ebp),%edx
  802223:	83 ea 08             	sub    $0x8,%edx
  802226:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	01 d0                	add    %edx,%eax
  802230:	83 e8 08             	sub    $0x8,%eax
  802233:	8b 55 0c             	mov    0xc(%ebp),%edx
  802236:	83 ea 08             	sub    $0x8,%edx
  802239:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80223b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80224e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802252:	75 17                	jne    80226b <initialize_dynamic_allocator+0x19c>
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 ac 44 80 00       	push   $0x8044ac
  80225c:	68 90 00 00 00       	push   $0x90
  802261:	68 91 44 80 00       	push   $0x804491
  802266:	e8 99 17 00 00       	call   803a04 <_panic>
  80226b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802274:	89 10                	mov    %edx,(%eax)
  802276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	74 0d                	je     80228c <initialize_dynamic_allocator+0x1bd>
  80227f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802284:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802287:	89 50 04             	mov    %edx,0x4(%eax)
  80228a:	eb 08                	jmp    802294 <initialize_dynamic_allocator+0x1c5>
  80228c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228f:	a3 30 50 80 00       	mov    %eax,0x805030
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80229c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ab:	40                   	inc    %eax
  8022ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8022b1:	eb 07                	jmp    8022ba <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022b3:	90                   	nop
  8022b4:	eb 04                	jmp    8022ba <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022b6:	90                   	nop
  8022b7:	eb 01                	jmp    8022ba <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022b9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	83 e8 04             	sub    $0x4,%eax
  8022d6:	8b 00                	mov    (%eax),%eax
  8022d8:	83 e0 fe             	and    $0xfffffffe,%eax
  8022db:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	01 c2                	add    %eax,%edx
  8022e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e6:	89 02                	mov    %eax,(%edx)
}
  8022e8:	90                   	nop
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	83 e0 01             	and    $0x1,%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	74 03                	je     8022fe <alloc_block_FF+0x13>
  8022fb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022fe:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802302:	77 07                	ja     80230b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802304:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80230b:	a1 24 50 80 00       	mov    0x805024,%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	75 73                	jne    802387 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	83 c0 10             	add    $0x10,%eax
  80231a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80231d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802324:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232a:	01 d0                	add    %edx,%eax
  80232c:	48                   	dec    %eax
  80232d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802333:	ba 00 00 00 00       	mov    $0x0,%edx
  802338:	f7 75 ec             	divl   -0x14(%ebp)
  80233b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233e:	29 d0                	sub    %edx,%eax
  802340:	c1 e8 0c             	shr    $0xc,%eax
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	50                   	push   %eax
  802347:	e8 d4 f0 ff ff       	call   801420 <sbrk>
  80234c:	83 c4 10             	add    $0x10,%esp
  80234f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802352:	83 ec 0c             	sub    $0xc,%esp
  802355:	6a 00                	push   $0x0
  802357:	e8 c4 f0 ff ff       	call   801420 <sbrk>
  80235c:	83 c4 10             	add    $0x10,%esp
  80235f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802365:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802368:	83 ec 08             	sub    $0x8,%esp
  80236b:	50                   	push   %eax
  80236c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80236f:	e8 5b fd ff ff       	call   8020cf <initialize_dynamic_allocator>
  802374:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802377:	83 ec 0c             	sub    $0xc,%esp
  80237a:	68 cf 44 80 00       	push   $0x8044cf
  80237f:	e8 02 e3 ff ff       	call   800686 <cprintf>
  802384:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802387:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238b:	75 0a                	jne    802397 <alloc_block_FF+0xac>
	        return NULL;
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
  802392:	e9 0e 04 00 00       	jmp    8027a5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80239e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a6:	e9 f3 02 00 00       	jmp    80269e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023b1:	83 ec 0c             	sub    $0xc,%esp
  8023b4:	ff 75 bc             	pushl  -0x44(%ebp)
  8023b7:	e8 af fb ff ff       	call   801f6b <get_block_size>
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	83 c0 08             	add    $0x8,%eax
  8023c8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023cb:	0f 87 c5 02 00 00    	ja     802696 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	83 c0 18             	add    $0x18,%eax
  8023d7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023da:	0f 87 19 02 00 00    	ja     8025f9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e6:	83 e8 08             	sub    $0x8,%eax
  8023e9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	8d 50 08             	lea    0x8(%eax),%edx
  8023f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023f5:	01 d0                	add    %edx,%eax
  8023f7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	83 c0 08             	add    $0x8,%eax
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	6a 01                	push   $0x1
  802405:	50                   	push   %eax
  802406:	ff 75 bc             	pushl  -0x44(%ebp)
  802409:	e8 ae fe ff ff       	call   8022bc <set_block_data>
  80240e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	75 68                	jne    802483 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80241b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80241f:	75 17                	jne    802438 <alloc_block_FF+0x14d>
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	68 ac 44 80 00       	push   $0x8044ac
  802429:	68 d7 00 00 00       	push   $0xd7
  80242e:	68 91 44 80 00       	push   $0x804491
  802433:	e8 cc 15 00 00       	call   803a04 <_panic>
  802438:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80243e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802441:	89 10                	mov    %edx,(%eax)
  802443:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	74 0d                	je     802459 <alloc_block_FF+0x16e>
  80244c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802451:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802454:	89 50 04             	mov    %edx,0x4(%eax)
  802457:	eb 08                	jmp    802461 <alloc_block_FF+0x176>
  802459:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245c:	a3 30 50 80 00       	mov    %eax,0x805030
  802461:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802464:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802469:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802473:	a1 38 50 80 00       	mov    0x805038,%eax
  802478:	40                   	inc    %eax
  802479:	a3 38 50 80 00       	mov    %eax,0x805038
  80247e:	e9 dc 00 00 00       	jmp    80255f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	75 65                	jne    8024f1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80248c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802490:	75 17                	jne    8024a9 <alloc_block_FF+0x1be>
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	68 e0 44 80 00       	push   $0x8044e0
  80249a:	68 db 00 00 00       	push   $0xdb
  80249f:	68 91 44 80 00       	push   $0x804491
  8024a4:	e8 5b 15 00 00       	call   803a04 <_panic>
  8024a9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b2:	89 50 04             	mov    %edx,0x4(%eax)
  8024b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 0c                	je     8024cb <alloc_block_FF+0x1e0>
  8024bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8024c4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	eb 08                	jmp    8024d3 <alloc_block_FF+0x1e8>
  8024cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e9:	40                   	inc    %eax
  8024ea:	a3 38 50 80 00       	mov    %eax,0x805038
  8024ef:	eb 6e                	jmp    80255f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f5:	74 06                	je     8024fd <alloc_block_FF+0x212>
  8024f7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024fb:	75 17                	jne    802514 <alloc_block_FF+0x229>
  8024fd:	83 ec 04             	sub    $0x4,%esp
  802500:	68 04 45 80 00       	push   $0x804504
  802505:	68 df 00 00 00       	push   $0xdf
  80250a:	68 91 44 80 00       	push   $0x804491
  80250f:	e8 f0 14 00 00       	call   803a04 <_panic>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 10                	mov    (%eax),%edx
  802519:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251c:	89 10                	mov    %edx,(%eax)
  80251e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802521:	8b 00                	mov    (%eax),%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	74 0b                	je     802532 <alloc_block_FF+0x247>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80252f:	89 50 04             	mov    %edx,0x4(%eax)
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802538:	89 10                	mov    %edx,(%eax)
  80253a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802540:	89 50 04             	mov    %edx,0x4(%eax)
  802543:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	75 08                	jne    802554 <alloc_block_FF+0x269>
  80254c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254f:	a3 30 50 80 00       	mov    %eax,0x805030
  802554:	a1 38 50 80 00       	mov    0x805038,%eax
  802559:	40                   	inc    %eax
  80255a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	75 17                	jne    80257c <alloc_block_FF+0x291>
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	68 73 44 80 00       	push   $0x804473
  80256d:	68 e1 00 00 00       	push   $0xe1
  802572:	68 91 44 80 00       	push   $0x804491
  802577:	e8 88 14 00 00       	call   803a04 <_panic>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 10                	je     802595 <alloc_block_FF+0x2aa>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 52 04             	mov    0x4(%edx),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	eb 0b                	jmp    8025a0 <alloc_block_FF+0x2b5>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0f                	je     8025b9 <alloc_block_FF+0x2ce>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b3:	8b 12                	mov    (%edx),%edx
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	eb 0a                	jmp    8025c3 <alloc_block_FF+0x2d8>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8025db:	48                   	dec    %eax
  8025dc:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025e1:	83 ec 04             	sub    $0x4,%esp
  8025e4:	6a 00                	push   $0x0
  8025e6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025e9:	ff 75 b0             	pushl  -0x50(%ebp)
  8025ec:	e8 cb fc ff ff       	call   8022bc <set_block_data>
  8025f1:	83 c4 10             	add    $0x10,%esp
  8025f4:	e9 95 00 00 00       	jmp    80268e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	6a 01                	push   $0x1
  8025fe:	ff 75 b8             	pushl  -0x48(%ebp)
  802601:	ff 75 bc             	pushl  -0x44(%ebp)
  802604:	e8 b3 fc ff ff       	call   8022bc <set_block_data>
  802609:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	75 17                	jne    802629 <alloc_block_FF+0x33e>
  802612:	83 ec 04             	sub    $0x4,%esp
  802615:	68 73 44 80 00       	push   $0x804473
  80261a:	68 e8 00 00 00       	push   $0xe8
  80261f:	68 91 44 80 00       	push   $0x804491
  802624:	e8 db 13 00 00       	call   803a04 <_panic>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 10                	je     802642 <alloc_block_FF+0x357>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263a:	8b 52 04             	mov    0x4(%edx),%edx
  80263d:	89 50 04             	mov    %edx,0x4(%eax)
  802640:	eb 0b                	jmp    80264d <alloc_block_FF+0x362>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 04             	mov    0x4(%eax),%eax
  802648:	a3 30 50 80 00       	mov    %eax,0x805030
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 40 04             	mov    0x4(%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 0f                	je     802666 <alloc_block_FF+0x37b>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802660:	8b 12                	mov    (%edx),%edx
  802662:	89 10                	mov    %edx,(%eax)
  802664:	eb 0a                	jmp    802670 <alloc_block_FF+0x385>
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 00                	mov    (%eax),%eax
  80266b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802683:	a1 38 50 80 00       	mov    0x805038,%eax
  802688:	48                   	dec    %eax
  802689:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80268e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802691:	e9 0f 01 00 00       	jmp    8027a5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802696:	a1 34 50 80 00       	mov    0x805034,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	74 07                	je     8026ab <alloc_block_FF+0x3c0>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <alloc_block_FF+0x3c5>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 34 50 80 00       	mov    %eax,0x805034
  8026b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	0f 85 e9 fc ff ff    	jne    8023ab <alloc_block_FF+0xc0>
  8026c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c6:	0f 85 df fc ff ff    	jne    8023ab <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cf:	83 c0 08             	add    $0x8,%eax
  8026d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026d5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	48                   	dec    %eax
  8026e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f0:	f7 75 d8             	divl   -0x28(%ebp)
  8026f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f6:	29 d0                	sub    %edx,%eax
  8026f8:	c1 e8 0c             	shr    $0xc,%eax
  8026fb:	83 ec 0c             	sub    $0xc,%esp
  8026fe:	50                   	push   %eax
  8026ff:	e8 1c ed ff ff       	call   801420 <sbrk>
  802704:	83 c4 10             	add    $0x10,%esp
  802707:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80270a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80270e:	75 0a                	jne    80271a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	e9 8b 00 00 00       	jmp    8027a5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80271a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802721:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802724:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802727:	01 d0                	add    %edx,%eax
  802729:	48                   	dec    %eax
  80272a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80272d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802730:	ba 00 00 00 00       	mov    $0x0,%edx
  802735:	f7 75 cc             	divl   -0x34(%ebp)
  802738:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80273b:	29 d0                	sub    %edx,%eax
  80273d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802743:	01 d0                	add    %edx,%eax
  802745:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80274a:	a1 40 50 80 00       	mov    0x805040,%eax
  80274f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802755:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80275c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80275f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802762:	01 d0                	add    %edx,%eax
  802764:	48                   	dec    %eax
  802765:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802768:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80276b:	ba 00 00 00 00       	mov    $0x0,%edx
  802770:	f7 75 c4             	divl   -0x3c(%ebp)
  802773:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802776:	29 d0                	sub    %edx,%eax
  802778:	83 ec 04             	sub    $0x4,%esp
  80277b:	6a 01                	push   $0x1
  80277d:	50                   	push   %eax
  80277e:	ff 75 d0             	pushl  -0x30(%ebp)
  802781:	e8 36 fb ff ff       	call   8022bc <set_block_data>
  802786:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	ff 75 d0             	pushl  -0x30(%ebp)
  80278f:	e8 1b 0a 00 00       	call   8031af <free_block>
  802794:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802797:	83 ec 0c             	sub    $0xc,%esp
  80279a:	ff 75 08             	pushl  0x8(%ebp)
  80279d:	e8 49 fb ff ff       	call   8022eb <alloc_block_FF>
  8027a2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	83 e0 01             	and    $0x1,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	74 03                	je     8027ba <alloc_block_BF+0x13>
  8027b7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027ba:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027be:	77 07                	ja     8027c7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027c0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027c7:	a1 24 50 80 00       	mov    0x805024,%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	75 73                	jne    802843 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	83 c0 10             	add    $0x10,%eax
  8027d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027d9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e6:	01 d0                	add    %edx,%eax
  8027e8:	48                   	dec    %eax
  8027e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f4:	f7 75 e0             	divl   -0x20(%ebp)
  8027f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027fa:	29 d0                	sub    %edx,%eax
  8027fc:	c1 e8 0c             	shr    $0xc,%eax
  8027ff:	83 ec 0c             	sub    $0xc,%esp
  802802:	50                   	push   %eax
  802803:	e8 18 ec ff ff       	call   801420 <sbrk>
  802808:	83 c4 10             	add    $0x10,%esp
  80280b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	6a 00                	push   $0x0
  802813:	e8 08 ec ff ff       	call   801420 <sbrk>
  802818:	83 c4 10             	add    $0x10,%esp
  80281b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80281e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802821:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802824:	83 ec 08             	sub    $0x8,%esp
  802827:	50                   	push   %eax
  802828:	ff 75 d8             	pushl  -0x28(%ebp)
  80282b:	e8 9f f8 ff ff       	call   8020cf <initialize_dynamic_allocator>
  802830:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802833:	83 ec 0c             	sub    $0xc,%esp
  802836:	68 cf 44 80 00       	push   $0x8044cf
  80283b:	e8 46 de ff ff       	call   800686 <cprintf>
  802840:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802843:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80284a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802851:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802858:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80285f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802867:	e9 1d 01 00 00       	jmp    802989 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802872:	83 ec 0c             	sub    $0xc,%esp
  802875:	ff 75 a8             	pushl  -0x58(%ebp)
  802878:	e8 ee f6 ff ff       	call   801f6b <get_block_size>
  80287d:	83 c4 10             	add    $0x10,%esp
  802880:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	83 c0 08             	add    $0x8,%eax
  802889:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80288c:	0f 87 ef 00 00 00    	ja     802981 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	83 c0 18             	add    $0x18,%eax
  802898:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80289b:	77 1d                	ja     8028ba <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80289d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a3:	0f 86 d8 00 00 00    	jbe    802981 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028a9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028af:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028b5:	e9 c7 00 00 00       	jmp    802981 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	83 c0 08             	add    $0x8,%eax
  8028c0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c3:	0f 85 9d 00 00 00    	jne    802966 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	6a 01                	push   $0x1
  8028ce:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028d1:	ff 75 a8             	pushl  -0x58(%ebp)
  8028d4:	e8 e3 f9 ff ff       	call   8022bc <set_block_data>
  8028d9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e0:	75 17                	jne    8028f9 <alloc_block_BF+0x152>
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	68 73 44 80 00       	push   $0x804473
  8028ea:	68 2c 01 00 00       	push   $0x12c
  8028ef:	68 91 44 80 00       	push   $0x804491
  8028f4:	e8 0b 11 00 00       	call   803a04 <_panic>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 10                	je     802912 <alloc_block_BF+0x16b>
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 00                	mov    (%eax),%eax
  802907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290a:	8b 52 04             	mov    0x4(%edx),%edx
  80290d:	89 50 04             	mov    %edx,0x4(%eax)
  802910:	eb 0b                	jmp    80291d <alloc_block_BF+0x176>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	a3 30 50 80 00       	mov    %eax,0x805030
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 0f                	je     802936 <alloc_block_BF+0x18f>
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 04             	mov    0x4(%eax),%eax
  80292d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802930:	8b 12                	mov    (%edx),%edx
  802932:	89 10                	mov    %edx,(%eax)
  802934:	eb 0a                	jmp    802940 <alloc_block_BF+0x199>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802953:	a1 38 50 80 00       	mov    0x805038,%eax
  802958:	48                   	dec    %eax
  802959:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80295e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802961:	e9 24 04 00 00       	jmp    802d8a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802969:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80296c:	76 13                	jbe    802981 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80296e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802975:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802978:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80297b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80297e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802981:	a1 34 50 80 00       	mov    0x805034,%eax
  802986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	74 07                	je     802996 <alloc_block_BF+0x1ef>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	eb 05                	jmp    80299b <alloc_block_BF+0x1f4>
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
  80299b:	a3 34 50 80 00       	mov    %eax,0x805034
  8029a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	0f 85 bf fe ff ff    	jne    80286c <alloc_block_BF+0xc5>
  8029ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b1:	0f 85 b5 fe ff ff    	jne    80286c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029bb:	0f 84 26 02 00 00    	je     802be7 <alloc_block_BF+0x440>
  8029c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c5:	0f 85 1c 02 00 00    	jne    802be7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d1:	83 e8 08             	sub    $0x8,%eax
  8029d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	8d 50 08             	lea    0x8(%eax),%edx
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	01 d0                	add    %edx,%eax
  8029e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	83 c0 08             	add    $0x8,%eax
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	6a 01                	push   $0x1
  8029f0:	50                   	push   %eax
  8029f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8029f4:	e8 c3 f8 ff ff       	call   8022bc <set_block_data>
  8029f9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	75 68                	jne    802a6e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a06:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a0a:	75 17                	jne    802a23 <alloc_block_BF+0x27c>
  802a0c:	83 ec 04             	sub    $0x4,%esp
  802a0f:	68 ac 44 80 00       	push   $0x8044ac
  802a14:	68 45 01 00 00       	push   $0x145
  802a19:	68 91 44 80 00       	push   $0x804491
  802a1e:	e8 e1 0f 00 00       	call   803a04 <_panic>
  802a23:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2c:	89 10                	mov    %edx,(%eax)
  802a2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 0d                	je     802a44 <alloc_block_BF+0x29d>
  802a37:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a3c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a3f:	89 50 04             	mov    %edx,0x4(%eax)
  802a42:	eb 08                	jmp    802a4c <alloc_block_BF+0x2a5>
  802a44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a47:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a63:	40                   	inc    %eax
  802a64:	a3 38 50 80 00       	mov    %eax,0x805038
  802a69:	e9 dc 00 00 00       	jmp    802b4a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	75 65                	jne    802adc <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a77:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a7b:	75 17                	jne    802a94 <alloc_block_BF+0x2ed>
  802a7d:	83 ec 04             	sub    $0x4,%esp
  802a80:	68 e0 44 80 00       	push   $0x8044e0
  802a85:	68 4a 01 00 00       	push   $0x14a
  802a8a:	68 91 44 80 00       	push   $0x804491
  802a8f:	e8 70 0f 00 00       	call   803a04 <_panic>
  802a94:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9d:	89 50 04             	mov    %edx,0x4(%eax)
  802aa0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0c                	je     802ab6 <alloc_block_BF+0x30f>
  802aaa:	a1 30 50 80 00       	mov    0x805030,%eax
  802aaf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ab2:	89 10                	mov    %edx,(%eax)
  802ab4:	eb 08                	jmp    802abe <alloc_block_BF+0x317>
  802ab6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802abe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad4:	40                   	inc    %eax
  802ad5:	a3 38 50 80 00       	mov    %eax,0x805038
  802ada:	eb 6e                	jmp    802b4a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae0:	74 06                	je     802ae8 <alloc_block_BF+0x341>
  802ae2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ae6:	75 17                	jne    802aff <alloc_block_BF+0x358>
  802ae8:	83 ec 04             	sub    $0x4,%esp
  802aeb:	68 04 45 80 00       	push   $0x804504
  802af0:	68 4f 01 00 00       	push   $0x14f
  802af5:	68 91 44 80 00       	push   $0x804491
  802afa:	e8 05 0f 00 00       	call   803a04 <_panic>
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 10                	mov    (%eax),%edx
  802b04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0b                	je     802b1d <alloc_block_BF+0x376>
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	75 08                	jne    802b3f <alloc_block_BF+0x398>
  802b37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b44:	40                   	inc    %eax
  802b45:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4e:	75 17                	jne    802b67 <alloc_block_BF+0x3c0>
  802b50:	83 ec 04             	sub    $0x4,%esp
  802b53:	68 73 44 80 00       	push   $0x804473
  802b58:	68 51 01 00 00       	push   $0x151
  802b5d:	68 91 44 80 00       	push   $0x804491
  802b62:	e8 9d 0e 00 00       	call   803a04 <_panic>
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 10                	je     802b80 <alloc_block_BF+0x3d9>
  802b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b78:	8b 52 04             	mov    0x4(%edx),%edx
  802b7b:	89 50 04             	mov    %edx,0x4(%eax)
  802b7e:	eb 0b                	jmp    802b8b <alloc_block_BF+0x3e4>
  802b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b83:	8b 40 04             	mov    0x4(%eax),%eax
  802b86:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	74 0f                	je     802ba4 <alloc_block_BF+0x3fd>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9e:	8b 12                	mov    (%edx),%edx
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	eb 0a                	jmp    802bae <alloc_block_BF+0x407>
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc1:	a1 38 50 80 00       	mov    0x805038,%eax
  802bc6:	48                   	dec    %eax
  802bc7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bcc:	83 ec 04             	sub    $0x4,%esp
  802bcf:	6a 00                	push   $0x0
  802bd1:	ff 75 d0             	pushl  -0x30(%ebp)
  802bd4:	ff 75 cc             	pushl  -0x34(%ebp)
  802bd7:	e8 e0 f6 ff ff       	call   8022bc <set_block_data>
  802bdc:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	e9 a3 01 00 00       	jmp    802d8a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802be7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802beb:	0f 85 9d 00 00 00    	jne    802c8e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bf1:	83 ec 04             	sub    $0x4,%esp
  802bf4:	6a 01                	push   $0x1
  802bf6:	ff 75 ec             	pushl  -0x14(%ebp)
  802bf9:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfc:	e8 bb f6 ff ff       	call   8022bc <set_block_data>
  802c01:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c08:	75 17                	jne    802c21 <alloc_block_BF+0x47a>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 73 44 80 00       	push   $0x804473
  802c12:	68 58 01 00 00       	push   $0x158
  802c17:	68 91 44 80 00       	push   $0x804491
  802c1c:	e8 e3 0d 00 00       	call   803a04 <_panic>
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 10                	je     802c3a <alloc_block_BF+0x493>
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c32:	8b 52 04             	mov    0x4(%edx),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	eb 0b                	jmp    802c45 <alloc_block_BF+0x49e>
  802c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	a3 30 50 80 00       	mov    %eax,0x805030
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 0f                	je     802c5e <alloc_block_BF+0x4b7>
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c58:	8b 12                	mov    (%edx),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 0a                	jmp    802c68 <alloc_block_BF+0x4c1>
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c80:	48                   	dec    %eax
  802c81:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	e9 fc 00 00 00       	jmp    802d8a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	83 c0 08             	add    $0x8,%eax
  802c94:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c97:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c9e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ca1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ca4:	01 d0                	add    %edx,%eax
  802ca6:	48                   	dec    %eax
  802ca7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802caa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cad:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb2:	f7 75 c4             	divl   -0x3c(%ebp)
  802cb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb8:	29 d0                	sub    %edx,%eax
  802cba:	c1 e8 0c             	shr    $0xc,%eax
  802cbd:	83 ec 0c             	sub    $0xc,%esp
  802cc0:	50                   	push   %eax
  802cc1:	e8 5a e7 ff ff       	call   801420 <sbrk>
  802cc6:	83 c4 10             	add    $0x10,%esp
  802cc9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ccc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cd0:	75 0a                	jne    802cdc <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd7:	e9 ae 00 00 00       	jmp    802d8a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cdc:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ce3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ce6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ce9:	01 d0                	add    %edx,%eax
  802ceb:	48                   	dec    %eax
  802cec:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf7:	f7 75 b8             	divl   -0x48(%ebp)
  802cfa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cfd:	29 d0                	sub    %edx,%eax
  802cff:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d02:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d05:	01 d0                	add    %edx,%eax
  802d07:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d0c:	a1 40 50 80 00       	mov    0x805040,%eax
  802d11:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d17:	83 ec 0c             	sub    $0xc,%esp
  802d1a:	68 38 45 80 00       	push   $0x804538
  802d1f:	e8 62 d9 ff ff       	call   800686 <cprintf>
  802d24:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d27:	83 ec 08             	sub    $0x8,%esp
  802d2a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d2d:	68 3d 45 80 00       	push   $0x80453d
  802d32:	e8 4f d9 ff ff       	call   800686 <cprintf>
  802d37:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d3a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d41:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d47:	01 d0                	add    %edx,%eax
  802d49:	48                   	dec    %eax
  802d4a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d4d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d50:	ba 00 00 00 00       	mov    $0x0,%edx
  802d55:	f7 75 b0             	divl   -0x50(%ebp)
  802d58:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d5b:	29 d0                	sub    %edx,%eax
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	6a 01                	push   $0x1
  802d62:	50                   	push   %eax
  802d63:	ff 75 bc             	pushl  -0x44(%ebp)
  802d66:	e8 51 f5 ff ff       	call   8022bc <set_block_data>
  802d6b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d6e:	83 ec 0c             	sub    $0xc,%esp
  802d71:	ff 75 bc             	pushl  -0x44(%ebp)
  802d74:	e8 36 04 00 00       	call   8031af <free_block>
  802d79:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d7c:	83 ec 0c             	sub    $0xc,%esp
  802d7f:	ff 75 08             	pushl  0x8(%ebp)
  802d82:	e8 20 fa ff ff       	call   8027a7 <alloc_block_BF>
  802d87:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d8a:	c9                   	leave  
  802d8b:	c3                   	ret    

00802d8c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d8c:	55                   	push   %ebp
  802d8d:	89 e5                	mov    %esp,%ebp
  802d8f:	53                   	push   %ebx
  802d90:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802da1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da5:	74 1e                	je     802dc5 <merging+0x39>
  802da7:	ff 75 08             	pushl  0x8(%ebp)
  802daa:	e8 bc f1 ff ff       	call   801f6b <get_block_size>
  802daf:	83 c4 04             	add    $0x4,%esp
  802db2:	89 c2                	mov    %eax,%edx
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	01 d0                	add    %edx,%eax
  802db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dbc:	75 07                	jne    802dc5 <merging+0x39>
		prev_is_free = 1;
  802dbe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dc9:	74 1e                	je     802de9 <merging+0x5d>
  802dcb:	ff 75 10             	pushl  0x10(%ebp)
  802dce:	e8 98 f1 ff ff       	call   801f6b <get_block_size>
  802dd3:	83 c4 04             	add    $0x4,%esp
  802dd6:	89 c2                	mov    %eax,%edx
  802dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ddb:	01 d0                	add    %edx,%eax
  802ddd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802de0:	75 07                	jne    802de9 <merging+0x5d>
		next_is_free = 1;
  802de2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ded:	0f 84 cc 00 00 00    	je     802ebf <merging+0x133>
  802df3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df7:	0f 84 c2 00 00 00    	je     802ebf <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dfd:	ff 75 08             	pushl  0x8(%ebp)
  802e00:	e8 66 f1 ff ff       	call   801f6b <get_block_size>
  802e05:	83 c4 04             	add    $0x4,%esp
  802e08:	89 c3                	mov    %eax,%ebx
  802e0a:	ff 75 10             	pushl  0x10(%ebp)
  802e0d:	e8 59 f1 ff ff       	call   801f6b <get_block_size>
  802e12:	83 c4 04             	add    $0x4,%esp
  802e15:	01 c3                	add    %eax,%ebx
  802e17:	ff 75 0c             	pushl  0xc(%ebp)
  802e1a:	e8 4c f1 ff ff       	call   801f6b <get_block_size>
  802e1f:	83 c4 04             	add    $0x4,%esp
  802e22:	01 d8                	add    %ebx,%eax
  802e24:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e27:	6a 00                	push   $0x0
  802e29:	ff 75 ec             	pushl  -0x14(%ebp)
  802e2c:	ff 75 08             	pushl  0x8(%ebp)
  802e2f:	e8 88 f4 ff ff       	call   8022bc <set_block_data>
  802e34:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e3b:	75 17                	jne    802e54 <merging+0xc8>
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 73 44 80 00       	push   $0x804473
  802e45:	68 7d 01 00 00       	push   $0x17d
  802e4a:	68 91 44 80 00       	push   $0x804491
  802e4f:	e8 b0 0b 00 00       	call   803a04 <_panic>
  802e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	74 10                	je     802e6d <merging+0xe1>
  802e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e65:	8b 52 04             	mov    0x4(%edx),%edx
  802e68:	89 50 04             	mov    %edx,0x4(%eax)
  802e6b:	eb 0b                	jmp    802e78 <merging+0xec>
  802e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e70:	8b 40 04             	mov    0x4(%eax),%eax
  802e73:	a3 30 50 80 00       	mov    %eax,0x805030
  802e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 0f                	je     802e91 <merging+0x105>
  802e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8b:	8b 12                	mov    (%edx),%edx
  802e8d:	89 10                	mov    %edx,(%eax)
  802e8f:	eb 0a                	jmp    802e9b <merging+0x10f>
  802e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb3:	48                   	dec    %eax
  802eb4:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802eb9:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eba:	e9 ea 02 00 00       	jmp    8031a9 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ebf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec3:	74 3b                	je     802f00 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	ff 75 08             	pushl  0x8(%ebp)
  802ecb:	e8 9b f0 ff ff       	call   801f6b <get_block_size>
  802ed0:	83 c4 10             	add    $0x10,%esp
  802ed3:	89 c3                	mov    %eax,%ebx
  802ed5:	83 ec 0c             	sub    $0xc,%esp
  802ed8:	ff 75 10             	pushl  0x10(%ebp)
  802edb:	e8 8b f0 ff ff       	call   801f6b <get_block_size>
  802ee0:	83 c4 10             	add    $0x10,%esp
  802ee3:	01 d8                	add    %ebx,%eax
  802ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	6a 00                	push   $0x0
  802eed:	ff 75 e8             	pushl  -0x18(%ebp)
  802ef0:	ff 75 08             	pushl  0x8(%ebp)
  802ef3:	e8 c4 f3 ff ff       	call   8022bc <set_block_data>
  802ef8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802efb:	e9 a9 02 00 00       	jmp    8031a9 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f04:	0f 84 2d 01 00 00    	je     803037 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f0a:	83 ec 0c             	sub    $0xc,%esp
  802f0d:	ff 75 10             	pushl  0x10(%ebp)
  802f10:	e8 56 f0 ff ff       	call   801f6b <get_block_size>
  802f15:	83 c4 10             	add    $0x10,%esp
  802f18:	89 c3                	mov    %eax,%ebx
  802f1a:	83 ec 0c             	sub    $0xc,%esp
  802f1d:	ff 75 0c             	pushl  0xc(%ebp)
  802f20:	e8 46 f0 ff ff       	call   801f6b <get_block_size>
  802f25:	83 c4 10             	add    $0x10,%esp
  802f28:	01 d8                	add    %ebx,%eax
  802f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f2d:	83 ec 04             	sub    $0x4,%esp
  802f30:	6a 00                	push   $0x0
  802f32:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f35:	ff 75 10             	pushl  0x10(%ebp)
  802f38:	e8 7f f3 ff ff       	call   8022bc <set_block_data>
  802f3d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f40:	8b 45 10             	mov    0x10(%ebp),%eax
  802f43:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4a:	74 06                	je     802f52 <merging+0x1c6>
  802f4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f50:	75 17                	jne    802f69 <merging+0x1dd>
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	68 4c 45 80 00       	push   $0x80454c
  802f5a:	68 8d 01 00 00       	push   $0x18d
  802f5f:	68 91 44 80 00       	push   $0x804491
  802f64:	e8 9b 0a 00 00       	call   803a04 <_panic>
  802f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6c:	8b 50 04             	mov    0x4(%eax),%edx
  802f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0d                	je     802f94 <merging+0x208>
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	eb 08                	jmp    802f9c <merging+0x210>
  802f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f97:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa2:	89 50 04             	mov    %edx,0x4(%eax)
  802fa5:	a1 38 50 80 00       	mov    0x805038,%eax
  802faa:	40                   	inc    %eax
  802fab:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb4:	75 17                	jne    802fcd <merging+0x241>
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	68 73 44 80 00       	push   $0x804473
  802fbe:	68 8e 01 00 00       	push   $0x18e
  802fc3:	68 91 44 80 00       	push   $0x804491
  802fc8:	e8 37 0a 00 00       	call   803a04 <_panic>
  802fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 10                	je     802fe6 <merging+0x25a>
  802fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fde:	8b 52 04             	mov    0x4(%edx),%edx
  802fe1:	89 50 04             	mov    %edx,0x4(%eax)
  802fe4:	eb 0b                	jmp    802ff1 <merging+0x265>
  802fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 0f                	je     80300a <merging+0x27e>
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	8b 55 0c             	mov    0xc(%ebp),%edx
  803004:	8b 12                	mov    (%edx),%edx
  803006:	89 10                	mov    %edx,(%eax)
  803008:	eb 0a                	jmp    803014 <merging+0x288>
  80300a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	a1 38 50 80 00       	mov    0x805038,%eax
  80302c:	48                   	dec    %eax
  80302d:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803032:	e9 72 01 00 00       	jmp    8031a9 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803037:	8b 45 10             	mov    0x10(%ebp),%eax
  80303a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80303d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803041:	74 79                	je     8030bc <merging+0x330>
  803043:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803047:	74 73                	je     8030bc <merging+0x330>
  803049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304d:	74 06                	je     803055 <merging+0x2c9>
  80304f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803053:	75 17                	jne    80306c <merging+0x2e0>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 04 45 80 00       	push   $0x804504
  80305d:	68 94 01 00 00       	push   $0x194
  803062:	68 91 44 80 00       	push   $0x804491
  803067:	e8 98 09 00 00       	call   803a04 <_panic>
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	8b 10                	mov    (%eax),%edx
  803071:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803074:	89 10                	mov    %edx,(%eax)
  803076:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 0b                	je     80308a <merging+0x2fe>
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803090:	89 10                	mov    %edx,(%eax)
  803092:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803095:	8b 55 08             	mov    0x8(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	75 08                	jne    8030ac <merging+0x320>
  8030a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b1:	40                   	inc    %eax
  8030b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8030b7:	e9 ce 00 00 00       	jmp    80318a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c0:	74 65                	je     803127 <merging+0x39b>
  8030c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030c6:	75 17                	jne    8030df <merging+0x353>
  8030c8:	83 ec 04             	sub    $0x4,%esp
  8030cb:	68 e0 44 80 00       	push   $0x8044e0
  8030d0:	68 95 01 00 00       	push   $0x195
  8030d5:	68 91 44 80 00       	push   $0x804491
  8030da:	e8 25 09 00 00       	call   803a04 <_panic>
  8030df:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e8:	89 50 04             	mov    %edx,0x4(%eax)
  8030eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	74 0c                	je     803101 <merging+0x375>
  8030f5:	a1 30 50 80 00       	mov    0x805030,%eax
  8030fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030fd:	89 10                	mov    %edx,(%eax)
  8030ff:	eb 08                	jmp    803109 <merging+0x37d>
  803101:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803104:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803109:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310c:	a3 30 50 80 00       	mov    %eax,0x805030
  803111:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803114:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311a:	a1 38 50 80 00       	mov    0x805038,%eax
  80311f:	40                   	inc    %eax
  803120:	a3 38 50 80 00       	mov    %eax,0x805038
  803125:	eb 63                	jmp    80318a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803127:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80312b:	75 17                	jne    803144 <merging+0x3b8>
  80312d:	83 ec 04             	sub    $0x4,%esp
  803130:	68 ac 44 80 00       	push   $0x8044ac
  803135:	68 98 01 00 00       	push   $0x198
  80313a:	68 91 44 80 00       	push   $0x804491
  80313f:	e8 c0 08 00 00       	call   803a04 <_panic>
  803144:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80314a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314d:	89 10                	mov    %edx,(%eax)
  80314f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	85 c0                	test   %eax,%eax
  803156:	74 0d                	je     803165 <merging+0x3d9>
  803158:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80315d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	eb 08                	jmp    80316d <merging+0x3e1>
  803165:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803168:	a3 30 50 80 00       	mov    %eax,0x805030
  80316d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803170:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803175:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803178:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317f:	a1 38 50 80 00       	mov    0x805038,%eax
  803184:	40                   	inc    %eax
  803185:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80318a:	83 ec 0c             	sub    $0xc,%esp
  80318d:	ff 75 10             	pushl  0x10(%ebp)
  803190:	e8 d6 ed ff ff       	call   801f6b <get_block_size>
  803195:	83 c4 10             	add    $0x10,%esp
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	6a 00                	push   $0x0
  80319d:	50                   	push   %eax
  80319e:	ff 75 10             	pushl  0x10(%ebp)
  8031a1:	e8 16 f1 ff ff       	call   8022bc <set_block_data>
  8031a6:	83 c4 10             	add    $0x10,%esp
	}
}
  8031a9:	90                   	nop
  8031aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    

008031af <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031af:	55                   	push   %ebp
  8031b0:	89 e5                	mov    %esp,%ebp
  8031b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031bd:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c5:	73 1b                	jae    8031e2 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	ff 75 08             	pushl  0x8(%ebp)
  8031d2:	6a 00                	push   $0x0
  8031d4:	50                   	push   %eax
  8031d5:	e8 b2 fb ff ff       	call   802d8c <merging>
  8031da:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031dd:	e9 8b 00 00 00       	jmp    80326d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ea:	76 18                	jbe    803204 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	ff 75 08             	pushl  0x8(%ebp)
  8031f7:	50                   	push   %eax
  8031f8:	6a 00                	push   $0x0
  8031fa:	e8 8d fb ff ff       	call   802d8c <merging>
  8031ff:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803202:	eb 69                	jmp    80326d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803204:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320c:	eb 39                	jmp    803247 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	3b 45 08             	cmp    0x8(%ebp),%eax
  803214:	73 29                	jae    80323f <free_block+0x90>
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321e:	76 1f                	jbe    80323f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	ff 75 08             	pushl  0x8(%ebp)
  80322e:	ff 75 f0             	pushl  -0x10(%ebp)
  803231:	ff 75 f4             	pushl  -0xc(%ebp)
  803234:	e8 53 fb ff ff       	call   802d8c <merging>
  803239:	83 c4 10             	add    $0x10,%esp
			break;
  80323c:	90                   	nop
		}
	}
}
  80323d:	eb 2e                	jmp    80326d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80323f:	a1 34 50 80 00       	mov    0x805034,%eax
  803244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324b:	74 07                	je     803254 <free_block+0xa5>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	eb 05                	jmp    803259 <free_block+0xaa>
  803254:	b8 00 00 00 00       	mov    $0x0,%eax
  803259:	a3 34 50 80 00       	mov    %eax,0x805034
  80325e:	a1 34 50 80 00       	mov    0x805034,%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	75 a7                	jne    80320e <free_block+0x5f>
  803267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326b:	75 a1                	jne    80320e <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80326d:	90                   	nop
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803276:	ff 75 08             	pushl  0x8(%ebp)
  803279:	e8 ed ec ff ff       	call   801f6b <get_block_size>
  80327e:	83 c4 04             	add    $0x4,%esp
  803281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80328b:	eb 17                	jmp    8032a4 <copy_data+0x34>
  80328d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803290:	8b 45 0c             	mov    0xc(%ebp),%eax
  803293:	01 c2                	add    %eax,%edx
  803295:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	01 c8                	add    %ecx,%eax
  80329d:	8a 00                	mov    (%eax),%al
  80329f:	88 02                	mov    %al,(%edx)
  8032a1:	ff 45 fc             	incl   -0x4(%ebp)
  8032a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032aa:	72 e1                	jb     80328d <copy_data+0x1d>
}
  8032ac:	90                   	nop
  8032ad:	c9                   	leave  
  8032ae:	c3                   	ret    

008032af <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032af:	55                   	push   %ebp
  8032b0:	89 e5                	mov    %esp,%ebp
  8032b2:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b9:	75 23                	jne    8032de <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032bf:	74 13                	je     8032d4 <realloc_block_FF+0x25>
  8032c1:	83 ec 0c             	sub    $0xc,%esp
  8032c4:	ff 75 0c             	pushl  0xc(%ebp)
  8032c7:	e8 1f f0 ff ff       	call   8022eb <alloc_block_FF>
  8032cc:	83 c4 10             	add    $0x10,%esp
  8032cf:	e9 f4 06 00 00       	jmp    8039c8 <realloc_block_FF+0x719>
		return NULL;
  8032d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d9:	e9 ea 06 00 00       	jmp    8039c8 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032e2:	75 18                	jne    8032fc <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032e4:	83 ec 0c             	sub    $0xc,%esp
  8032e7:	ff 75 08             	pushl  0x8(%ebp)
  8032ea:	e8 c0 fe ff ff       	call   8031af <free_block>
  8032ef:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f7:	e9 cc 06 00 00       	jmp    8039c8 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032fc:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803300:	77 07                	ja     803309 <realloc_block_FF+0x5a>
  803302:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330c:	83 e0 01             	and    $0x1,%eax
  80330f:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803312:	8b 45 0c             	mov    0xc(%ebp),%eax
  803315:	83 c0 08             	add    $0x8,%eax
  803318:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80331b:	83 ec 0c             	sub    $0xc,%esp
  80331e:	ff 75 08             	pushl  0x8(%ebp)
  803321:	e8 45 ec ff ff       	call   801f6b <get_block_size>
  803326:	83 c4 10             	add    $0x10,%esp
  803329:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332f:	83 e8 08             	sub    $0x8,%eax
  803332:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	83 e8 04             	sub    $0x4,%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	83 e0 fe             	and    $0xfffffffe,%eax
  803340:	89 c2                	mov    %eax,%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	01 d0                	add    %edx,%eax
  803347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80334a:	83 ec 0c             	sub    $0xc,%esp
  80334d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803350:	e8 16 ec ff ff       	call   801f6b <get_block_size>
  803355:	83 c4 10             	add    $0x10,%esp
  803358:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80335b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335e:	83 e8 08             	sub    $0x8,%eax
  803361:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803364:	8b 45 0c             	mov    0xc(%ebp),%eax
  803367:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80336a:	75 08                	jne    803374 <realloc_block_FF+0xc5>
	{
		 return va;
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	e9 54 06 00 00       	jmp    8039c8 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803374:	8b 45 0c             	mov    0xc(%ebp),%eax
  803377:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80337a:	0f 83 e5 03 00 00    	jae    803765 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	2b 45 0c             	sub    0xc(%ebp),%eax
  803386:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803389:	83 ec 0c             	sub    $0xc,%esp
  80338c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80338f:	e8 f0 eb ff ff       	call   801f84 <is_free_block>
  803394:	83 c4 10             	add    $0x10,%esp
  803397:	84 c0                	test   %al,%al
  803399:	0f 84 3b 01 00 00    	je     8034da <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80339f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033aa:	83 ec 04             	sub    $0x4,%esp
  8033ad:	6a 01                	push   $0x1
  8033af:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b2:	ff 75 08             	pushl  0x8(%ebp)
  8033b5:	e8 02 ef ff ff       	call   8022bc <set_block_data>
  8033ba:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	83 e8 04             	sub    $0x4,%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c8:	89 c2                	mov    %eax,%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	6a 00                	push   $0x0
  8033d7:	ff 75 cc             	pushl  -0x34(%ebp)
  8033da:	ff 75 c8             	pushl  -0x38(%ebp)
  8033dd:	e8 da ee ff ff       	call   8022bc <set_block_data>
  8033e2:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033e9:	74 06                	je     8033f1 <realloc_block_FF+0x142>
  8033eb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033ef:	75 17                	jne    803408 <realloc_block_FF+0x159>
  8033f1:	83 ec 04             	sub    $0x4,%esp
  8033f4:	68 04 45 80 00       	push   $0x804504
  8033f9:	68 f6 01 00 00       	push   $0x1f6
  8033fe:	68 91 44 80 00       	push   $0x804491
  803403:	e8 fc 05 00 00       	call   803a04 <_panic>
  803408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340b:	8b 10                	mov    (%eax),%edx
  80340d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803410:	89 10                	mov    %edx,(%eax)
  803412:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	85 c0                	test   %eax,%eax
  803419:	74 0b                	je     803426 <realloc_block_FF+0x177>
  80341b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803423:	89 50 04             	mov    %edx,0x4(%eax)
  803426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803429:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80342c:	89 10                	mov    %edx,(%eax)
  80342e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803431:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	85 c0                	test   %eax,%eax
  80343e:	75 08                	jne    803448 <realloc_block_FF+0x199>
  803440:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803443:	a3 30 50 80 00       	mov    %eax,0x805030
  803448:	a1 38 50 80 00       	mov    0x805038,%eax
  80344d:	40                   	inc    %eax
  80344e:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803453:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803457:	75 17                	jne    803470 <realloc_block_FF+0x1c1>
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	68 73 44 80 00       	push   $0x804473
  803461:	68 f7 01 00 00       	push   $0x1f7
  803466:	68 91 44 80 00       	push   $0x804491
  80346b:	e8 94 05 00 00       	call   803a04 <_panic>
  803470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803473:	8b 00                	mov    (%eax),%eax
  803475:	85 c0                	test   %eax,%eax
  803477:	74 10                	je     803489 <realloc_block_FF+0x1da>
  803479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803481:	8b 52 04             	mov    0x4(%edx),%edx
  803484:	89 50 04             	mov    %edx,0x4(%eax)
  803487:	eb 0b                	jmp    803494 <realloc_block_FF+0x1e5>
  803489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348c:	8b 40 04             	mov    0x4(%eax),%eax
  80348f:	a3 30 50 80 00       	mov    %eax,0x805030
  803494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803497:	8b 40 04             	mov    0x4(%eax),%eax
  80349a:	85 c0                	test   %eax,%eax
  80349c:	74 0f                	je     8034ad <realloc_block_FF+0x1fe>
  80349e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a1:	8b 40 04             	mov    0x4(%eax),%eax
  8034a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a7:	8b 12                	mov    (%edx),%edx
  8034a9:	89 10                	mov    %edx,(%eax)
  8034ab:	eb 0a                	jmp    8034b7 <realloc_block_FF+0x208>
  8034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b0:	8b 00                	mov    (%eax),%eax
  8034b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8034cf:	48                   	dec    %eax
  8034d0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034d5:	e9 83 02 00 00       	jmp    80375d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034da:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034de:	0f 86 69 02 00 00    	jbe    80374d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034e4:	83 ec 04             	sub    $0x4,%esp
  8034e7:	6a 01                	push   $0x1
  8034e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8034ec:	ff 75 08             	pushl  0x8(%ebp)
  8034ef:	e8 c8 ed ff ff       	call   8022bc <set_block_data>
  8034f4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	83 e8 04             	sub    $0x4,%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	83 e0 fe             	and    $0xfffffffe,%eax
  803502:	89 c2                	mov    %eax,%edx
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	01 d0                	add    %edx,%eax
  803509:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80350c:	a1 38 50 80 00       	mov    0x805038,%eax
  803511:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803514:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803518:	75 68                	jne    803582 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80351a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80351e:	75 17                	jne    803537 <realloc_block_FF+0x288>
  803520:	83 ec 04             	sub    $0x4,%esp
  803523:	68 ac 44 80 00       	push   $0x8044ac
  803528:	68 06 02 00 00       	push   $0x206
  80352d:	68 91 44 80 00       	push   $0x804491
  803532:	e8 cd 04 00 00       	call   803a04 <_panic>
  803537:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80353d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803540:	89 10                	mov    %edx,(%eax)
  803542:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	85 c0                	test   %eax,%eax
  803549:	74 0d                	je     803558 <realloc_block_FF+0x2a9>
  80354b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803550:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803553:	89 50 04             	mov    %edx,0x4(%eax)
  803556:	eb 08                	jmp    803560 <realloc_block_FF+0x2b1>
  803558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355b:	a3 30 50 80 00       	mov    %eax,0x805030
  803560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803563:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803572:	a1 38 50 80 00       	mov    0x805038,%eax
  803577:	40                   	inc    %eax
  803578:	a3 38 50 80 00       	mov    %eax,0x805038
  80357d:	e9 b0 01 00 00       	jmp    803732 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803582:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803587:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80358a:	76 68                	jbe    8035f4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80358c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803590:	75 17                	jne    8035a9 <realloc_block_FF+0x2fa>
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 ac 44 80 00       	push   $0x8044ac
  80359a:	68 0b 02 00 00       	push   $0x20b
  80359f:	68 91 44 80 00       	push   $0x804491
  8035a4:	e8 5b 04 00 00       	call   803a04 <_panic>
  8035a9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	85 c0                	test   %eax,%eax
  8035bb:	74 0d                	je     8035ca <realloc_block_FF+0x31b>
  8035bd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	eb 08                	jmp    8035d2 <realloc_block_FF+0x323>
  8035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e9:	40                   	inc    %eax
  8035ea:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ef:	e9 3e 01 00 00       	jmp    803732 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035fc:	73 68                	jae    803666 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803602:	75 17                	jne    80361b <realloc_block_FF+0x36c>
  803604:	83 ec 04             	sub    $0x4,%esp
  803607:	68 e0 44 80 00       	push   $0x8044e0
  80360c:	68 10 02 00 00       	push   $0x210
  803611:	68 91 44 80 00       	push   $0x804491
  803616:	e8 e9 03 00 00       	call   803a04 <_panic>
  80361b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803621:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803624:	89 50 04             	mov    %edx,0x4(%eax)
  803627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362a:	8b 40 04             	mov    0x4(%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 0c                	je     80363d <realloc_block_FF+0x38e>
  803631:	a1 30 50 80 00       	mov    0x805030,%eax
  803636:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803639:	89 10                	mov    %edx,(%eax)
  80363b:	eb 08                	jmp    803645 <realloc_block_FF+0x396>
  80363d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803640:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803648:	a3 30 50 80 00       	mov    %eax,0x805030
  80364d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803656:	a1 38 50 80 00       	mov    0x805038,%eax
  80365b:	40                   	inc    %eax
  80365c:	a3 38 50 80 00       	mov    %eax,0x805038
  803661:	e9 cc 00 00 00       	jmp    803732 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803666:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80366d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803672:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803675:	e9 8a 00 00 00       	jmp    803704 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803680:	73 7a                	jae    8036fc <realloc_block_FF+0x44d>
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	8b 00                	mov    (%eax),%eax
  803687:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80368a:	73 70                	jae    8036fc <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80368c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803690:	74 06                	je     803698 <realloc_block_FF+0x3e9>
  803692:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803696:	75 17                	jne    8036af <realloc_block_FF+0x400>
  803698:	83 ec 04             	sub    $0x4,%esp
  80369b:	68 04 45 80 00       	push   $0x804504
  8036a0:	68 1a 02 00 00       	push   $0x21a
  8036a5:	68 91 44 80 00       	push   $0x804491
  8036aa:	e8 55 03 00 00       	call   803a04 <_panic>
  8036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b2:	8b 10                	mov    (%eax),%edx
  8036b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b7:	89 10                	mov    %edx,(%eax)
  8036b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bc:	8b 00                	mov    (%eax),%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	74 0b                	je     8036cd <realloc_block_FF+0x41e>
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ca:	89 50 04             	mov    %edx,0x4(%eax)
  8036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d3:	89 10                	mov    %edx,(%eax)
  8036d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036db:	89 50 04             	mov    %edx,0x4(%eax)
  8036de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	75 08                	jne    8036ef <realloc_block_FF+0x440>
  8036e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f4:	40                   	inc    %eax
  8036f5:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036fa:	eb 36                	jmp    803732 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036fc:	a1 34 50 80 00       	mov    0x805034,%eax
  803701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803708:	74 07                	je     803711 <realloc_block_FF+0x462>
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	eb 05                	jmp    803716 <realloc_block_FF+0x467>
  803711:	b8 00 00 00 00       	mov    $0x0,%eax
  803716:	a3 34 50 80 00       	mov    %eax,0x805034
  80371b:	a1 34 50 80 00       	mov    0x805034,%eax
  803720:	85 c0                	test   %eax,%eax
  803722:	0f 85 52 ff ff ff    	jne    80367a <realloc_block_FF+0x3cb>
  803728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372c:	0f 85 48 ff ff ff    	jne    80367a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803732:	83 ec 04             	sub    $0x4,%esp
  803735:	6a 00                	push   $0x0
  803737:	ff 75 d8             	pushl  -0x28(%ebp)
  80373a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80373d:	e8 7a eb ff ff       	call   8022bc <set_block_data>
  803742:	83 c4 10             	add    $0x10,%esp
				return va;
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	e9 7b 02 00 00       	jmp    8039c8 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80374d:	83 ec 0c             	sub    $0xc,%esp
  803750:	68 81 45 80 00       	push   $0x804581
  803755:	e8 2c cf ff ff       	call   800686 <cprintf>
  80375a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80375d:	8b 45 08             	mov    0x8(%ebp),%eax
  803760:	e9 63 02 00 00       	jmp    8039c8 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803765:	8b 45 0c             	mov    0xc(%ebp),%eax
  803768:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80376b:	0f 86 4d 02 00 00    	jbe    8039be <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803771:	83 ec 0c             	sub    $0xc,%esp
  803774:	ff 75 e4             	pushl  -0x1c(%ebp)
  803777:	e8 08 e8 ff ff       	call   801f84 <is_free_block>
  80377c:	83 c4 10             	add    $0x10,%esp
  80377f:	84 c0                	test   %al,%al
  803781:	0f 84 37 02 00 00    	je     8039be <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80378d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803790:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803793:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803796:	76 38                	jbe    8037d0 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803798:	83 ec 0c             	sub    $0xc,%esp
  80379b:	ff 75 08             	pushl  0x8(%ebp)
  80379e:	e8 0c fa ff ff       	call   8031af <free_block>
  8037a3:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037a6:	83 ec 0c             	sub    $0xc,%esp
  8037a9:	ff 75 0c             	pushl  0xc(%ebp)
  8037ac:	e8 3a eb ff ff       	call   8022eb <alloc_block_FF>
  8037b1:	83 c4 10             	add    $0x10,%esp
  8037b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037b7:	83 ec 08             	sub    $0x8,%esp
  8037ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8037bd:	ff 75 08             	pushl  0x8(%ebp)
  8037c0:	e8 ab fa ff ff       	call   803270 <copy_data>
  8037c5:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037cb:	e9 f8 01 00 00       	jmp    8039c8 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d3:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037d9:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037dd:	0f 87 a0 00 00 00    	ja     803883 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e7:	75 17                	jne    803800 <realloc_block_FF+0x551>
  8037e9:	83 ec 04             	sub    $0x4,%esp
  8037ec:	68 73 44 80 00       	push   $0x804473
  8037f1:	68 38 02 00 00       	push   $0x238
  8037f6:	68 91 44 80 00       	push   $0x804491
  8037fb:	e8 04 02 00 00       	call   803a04 <_panic>
  803800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	85 c0                	test   %eax,%eax
  803807:	74 10                	je     803819 <realloc_block_FF+0x56a>
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803811:	8b 52 04             	mov    0x4(%edx),%edx
  803814:	89 50 04             	mov    %edx,0x4(%eax)
  803817:	eb 0b                	jmp    803824 <realloc_block_FF+0x575>
  803819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381c:	8b 40 04             	mov    0x4(%eax),%eax
  80381f:	a3 30 50 80 00       	mov    %eax,0x805030
  803824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803827:	8b 40 04             	mov    0x4(%eax),%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	74 0f                	je     80383d <realloc_block_FF+0x58e>
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	8b 40 04             	mov    0x4(%eax),%eax
  803834:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803837:	8b 12                	mov    (%edx),%edx
  803839:	89 10                	mov    %edx,(%eax)
  80383b:	eb 0a                	jmp    803847 <realloc_block_FF+0x598>
  80383d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803840:	8b 00                	mov    (%eax),%eax
  803842:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385a:	a1 38 50 80 00       	mov    0x805038,%eax
  80385f:	48                   	dec    %eax
  803860:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803865:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386b:	01 d0                	add    %edx,%eax
  80386d:	83 ec 04             	sub    $0x4,%esp
  803870:	6a 01                	push   $0x1
  803872:	50                   	push   %eax
  803873:	ff 75 08             	pushl  0x8(%ebp)
  803876:	e8 41 ea ff ff       	call   8022bc <set_block_data>
  80387b:	83 c4 10             	add    $0x10,%esp
  80387e:	e9 36 01 00 00       	jmp    8039b9 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803883:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803886:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803889:	01 d0                	add    %edx,%eax
  80388b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80388e:	83 ec 04             	sub    $0x4,%esp
  803891:	6a 01                	push   $0x1
  803893:	ff 75 f0             	pushl  -0x10(%ebp)
  803896:	ff 75 08             	pushl  0x8(%ebp)
  803899:	e8 1e ea ff ff       	call   8022bc <set_block_data>
  80389e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a4:	83 e8 04             	sub    $0x4,%eax
  8038a7:	8b 00                	mov    (%eax),%eax
  8038a9:	83 e0 fe             	and    $0xfffffffe,%eax
  8038ac:	89 c2                	mov    %eax,%edx
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	01 d0                	add    %edx,%eax
  8038b3:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ba:	74 06                	je     8038c2 <realloc_block_FF+0x613>
  8038bc:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038c0:	75 17                	jne    8038d9 <realloc_block_FF+0x62a>
  8038c2:	83 ec 04             	sub    $0x4,%esp
  8038c5:	68 04 45 80 00       	push   $0x804504
  8038ca:	68 44 02 00 00       	push   $0x244
  8038cf:	68 91 44 80 00       	push   $0x804491
  8038d4:	e8 2b 01 00 00       	call   803a04 <_panic>
  8038d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038dc:	8b 10                	mov    (%eax),%edx
  8038de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e1:	89 10                	mov    %edx,(%eax)
  8038e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e6:	8b 00                	mov    (%eax),%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	74 0b                	je     8038f7 <realloc_block_FF+0x648>
  8038ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ef:	8b 00                	mov    (%eax),%eax
  8038f1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038f4:	89 50 04             	mov    %edx,0x4(%eax)
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038fd:	89 10                	mov    %edx,(%eax)
  8038ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803902:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803905:	89 50 04             	mov    %edx,0x4(%eax)
  803908:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390b:	8b 00                	mov    (%eax),%eax
  80390d:	85 c0                	test   %eax,%eax
  80390f:	75 08                	jne    803919 <realloc_block_FF+0x66a>
  803911:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803914:	a3 30 50 80 00       	mov    %eax,0x805030
  803919:	a1 38 50 80 00       	mov    0x805038,%eax
  80391e:	40                   	inc    %eax
  80391f:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803928:	75 17                	jne    803941 <realloc_block_FF+0x692>
  80392a:	83 ec 04             	sub    $0x4,%esp
  80392d:	68 73 44 80 00       	push   $0x804473
  803932:	68 45 02 00 00       	push   $0x245
  803937:	68 91 44 80 00       	push   $0x804491
  80393c:	e8 c3 00 00 00       	call   803a04 <_panic>
  803941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803944:	8b 00                	mov    (%eax),%eax
  803946:	85 c0                	test   %eax,%eax
  803948:	74 10                	je     80395a <realloc_block_FF+0x6ab>
  80394a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803952:	8b 52 04             	mov    0x4(%edx),%edx
  803955:	89 50 04             	mov    %edx,0x4(%eax)
  803958:	eb 0b                	jmp    803965 <realloc_block_FF+0x6b6>
  80395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395d:	8b 40 04             	mov    0x4(%eax),%eax
  803960:	a3 30 50 80 00       	mov    %eax,0x805030
  803965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803968:	8b 40 04             	mov    0x4(%eax),%eax
  80396b:	85 c0                	test   %eax,%eax
  80396d:	74 0f                	je     80397e <realloc_block_FF+0x6cf>
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	8b 40 04             	mov    0x4(%eax),%eax
  803975:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803978:	8b 12                	mov    (%edx),%edx
  80397a:	89 10                	mov    %edx,(%eax)
  80397c:	eb 0a                	jmp    803988 <realloc_block_FF+0x6d9>
  80397e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399b:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a0:	48                   	dec    %eax
  8039a1:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039a6:	83 ec 04             	sub    $0x4,%esp
  8039a9:	6a 00                	push   $0x0
  8039ab:	ff 75 bc             	pushl  -0x44(%ebp)
  8039ae:	ff 75 b8             	pushl  -0x48(%ebp)
  8039b1:	e8 06 e9 ff ff       	call   8022bc <set_block_data>
  8039b6:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bc:	eb 0a                	jmp    8039c8 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039be:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039c8:	c9                   	leave  
  8039c9:	c3                   	ret    

008039ca <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039ca:	55                   	push   %ebp
  8039cb:	89 e5                	mov    %esp,%ebp
  8039cd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039d0:	83 ec 04             	sub    $0x4,%esp
  8039d3:	68 88 45 80 00       	push   $0x804588
  8039d8:	68 58 02 00 00       	push   $0x258
  8039dd:	68 91 44 80 00       	push   $0x804491
  8039e2:	e8 1d 00 00 00       	call   803a04 <_panic>

008039e7 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039e7:	55                   	push   %ebp
  8039e8:	89 e5                	mov    %esp,%ebp
  8039ea:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039ed:	83 ec 04             	sub    $0x4,%esp
  8039f0:	68 b0 45 80 00       	push   $0x8045b0
  8039f5:	68 61 02 00 00       	push   $0x261
  8039fa:	68 91 44 80 00       	push   $0x804491
  8039ff:	e8 00 00 00 00       	call   803a04 <_panic>

00803a04 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a04:	55                   	push   %ebp
  803a05:	89 e5                	mov    %esp,%ebp
  803a07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a0a:	8d 45 10             	lea    0x10(%ebp),%eax
  803a0d:	83 c0 04             	add    $0x4,%eax
  803a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a13:	a1 60 50 98 00       	mov    0x985060,%eax
  803a18:	85 c0                	test   %eax,%eax
  803a1a:	74 16                	je     803a32 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a1c:	a1 60 50 98 00       	mov    0x985060,%eax
  803a21:	83 ec 08             	sub    $0x8,%esp
  803a24:	50                   	push   %eax
  803a25:	68 d8 45 80 00       	push   $0x8045d8
  803a2a:	e8 57 cc ff ff       	call   800686 <cprintf>
  803a2f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a32:	a1 00 50 80 00       	mov    0x805000,%eax
  803a37:	ff 75 0c             	pushl  0xc(%ebp)
  803a3a:	ff 75 08             	pushl  0x8(%ebp)
  803a3d:	50                   	push   %eax
  803a3e:	68 dd 45 80 00       	push   $0x8045dd
  803a43:	e8 3e cc ff ff       	call   800686 <cprintf>
  803a48:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  803a4e:	83 ec 08             	sub    $0x8,%esp
  803a51:	ff 75 f4             	pushl  -0xc(%ebp)
  803a54:	50                   	push   %eax
  803a55:	e8 c1 cb ff ff       	call   80061b <vcprintf>
  803a5a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a5d:	83 ec 08             	sub    $0x8,%esp
  803a60:	6a 00                	push   $0x0
  803a62:	68 f9 45 80 00       	push   $0x8045f9
  803a67:	e8 af cb ff ff       	call   80061b <vcprintf>
  803a6c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a6f:	e8 30 cb ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  803a74:	eb fe                	jmp    803a74 <_panic+0x70>

00803a76 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a76:	55                   	push   %ebp
  803a77:	89 e5                	mov    %esp,%ebp
  803a79:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a7c:	a1 20 50 80 00       	mov    0x805020,%eax
  803a81:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8a:	39 c2                	cmp    %eax,%edx
  803a8c:	74 14                	je     803aa2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a8e:	83 ec 04             	sub    $0x4,%esp
  803a91:	68 fc 45 80 00       	push   $0x8045fc
  803a96:	6a 26                	push   $0x26
  803a98:	68 48 46 80 00       	push   $0x804648
  803a9d:	e8 62 ff ff ff       	call   803a04 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803aa9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ab0:	e9 c5 00 00 00       	jmp    803b7a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803abf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac2:	01 d0                	add    %edx,%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	85 c0                	test   %eax,%eax
  803ac8:	75 08                	jne    803ad2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803aca:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803acd:	e9 a5 00 00 00       	jmp    803b77 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ad2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ad9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ae0:	eb 69                	jmp    803b4b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803ae2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af0:	89 d0                	mov    %edx,%eax
  803af2:	01 c0                	add    %eax,%eax
  803af4:	01 d0                	add    %edx,%eax
  803af6:	c1 e0 03             	shl    $0x3,%eax
  803af9:	01 c8                	add    %ecx,%eax
  803afb:	8a 40 04             	mov    0x4(%eax),%al
  803afe:	84 c0                	test   %al,%al
  803b00:	75 46                	jne    803b48 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b02:	a1 20 50 80 00       	mov    0x805020,%eax
  803b07:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b10:	89 d0                	mov    %edx,%eax
  803b12:	01 c0                	add    %eax,%eax
  803b14:	01 d0                	add    %edx,%eax
  803b16:	c1 e0 03             	shl    $0x3,%eax
  803b19:	01 c8                	add    %ecx,%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b28:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b2d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b34:	8b 45 08             	mov    0x8(%ebp),%eax
  803b37:	01 c8                	add    %ecx,%eax
  803b39:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b3b:	39 c2                	cmp    %eax,%edx
  803b3d:	75 09                	jne    803b48 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b3f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b46:	eb 15                	jmp    803b5d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b48:	ff 45 e8             	incl   -0x18(%ebp)
  803b4b:	a1 20 50 80 00       	mov    0x805020,%eax
  803b50:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b59:	39 c2                	cmp    %eax,%edx
  803b5b:	77 85                	ja     803ae2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b61:	75 14                	jne    803b77 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b63:	83 ec 04             	sub    $0x4,%esp
  803b66:	68 54 46 80 00       	push   $0x804654
  803b6b:	6a 3a                	push   $0x3a
  803b6d:	68 48 46 80 00       	push   $0x804648
  803b72:	e8 8d fe ff ff       	call   803a04 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b77:	ff 45 f0             	incl   -0x10(%ebp)
  803b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b80:	0f 8c 2f ff ff ff    	jl     803ab5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b94:	eb 26                	jmp    803bbc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b96:	a1 20 50 80 00       	mov    0x805020,%eax
  803b9b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ba1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ba4:	89 d0                	mov    %edx,%eax
  803ba6:	01 c0                	add    %eax,%eax
  803ba8:	01 d0                	add    %edx,%eax
  803baa:	c1 e0 03             	shl    $0x3,%eax
  803bad:	01 c8                	add    %ecx,%eax
  803baf:	8a 40 04             	mov    0x4(%eax),%al
  803bb2:	3c 01                	cmp    $0x1,%al
  803bb4:	75 03                	jne    803bb9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bb6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb9:	ff 45 e0             	incl   -0x20(%ebp)
  803bbc:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	77 c8                	ja     803b96 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bd4:	74 14                	je     803bea <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bd6:	83 ec 04             	sub    $0x4,%esp
  803bd9:	68 a8 46 80 00       	push   $0x8046a8
  803bde:	6a 44                	push   $0x44
  803be0:	68 48 46 80 00       	push   $0x804648
  803be5:	e8 1a fe ff ff       	call   803a04 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803bea:	90                   	nop
  803beb:	c9                   	leave  
  803bec:	c3                   	ret    
  803bed:	66 90                	xchg   %ax,%ax
  803bef:	90                   	nop

00803bf0 <__udivdi3>:
  803bf0:	55                   	push   %ebp
  803bf1:	57                   	push   %edi
  803bf2:	56                   	push   %esi
  803bf3:	53                   	push   %ebx
  803bf4:	83 ec 1c             	sub    $0x1c,%esp
  803bf7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c07:	89 ca                	mov    %ecx,%edx
  803c09:	89 f8                	mov    %edi,%eax
  803c0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c0f:	85 f6                	test   %esi,%esi
  803c11:	75 2d                	jne    803c40 <__udivdi3+0x50>
  803c13:	39 cf                	cmp    %ecx,%edi
  803c15:	77 65                	ja     803c7c <__udivdi3+0x8c>
  803c17:	89 fd                	mov    %edi,%ebp
  803c19:	85 ff                	test   %edi,%edi
  803c1b:	75 0b                	jne    803c28 <__udivdi3+0x38>
  803c1d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	f7 f7                	div    %edi
  803c26:	89 c5                	mov    %eax,%ebp
  803c28:	31 d2                	xor    %edx,%edx
  803c2a:	89 c8                	mov    %ecx,%eax
  803c2c:	f7 f5                	div    %ebp
  803c2e:	89 c1                	mov    %eax,%ecx
  803c30:	89 d8                	mov    %ebx,%eax
  803c32:	f7 f5                	div    %ebp
  803c34:	89 cf                	mov    %ecx,%edi
  803c36:	89 fa                	mov    %edi,%edx
  803c38:	83 c4 1c             	add    $0x1c,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5f                   	pop    %edi
  803c3e:	5d                   	pop    %ebp
  803c3f:	c3                   	ret    
  803c40:	39 ce                	cmp    %ecx,%esi
  803c42:	77 28                	ja     803c6c <__udivdi3+0x7c>
  803c44:	0f bd fe             	bsr    %esi,%edi
  803c47:	83 f7 1f             	xor    $0x1f,%edi
  803c4a:	75 40                	jne    803c8c <__udivdi3+0x9c>
  803c4c:	39 ce                	cmp    %ecx,%esi
  803c4e:	72 0a                	jb     803c5a <__udivdi3+0x6a>
  803c50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c54:	0f 87 9e 00 00 00    	ja     803cf8 <__udivdi3+0x108>
  803c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c5f:	89 fa                	mov    %edi,%edx
  803c61:	83 c4 1c             	add    $0x1c,%esp
  803c64:	5b                   	pop    %ebx
  803c65:	5e                   	pop    %esi
  803c66:	5f                   	pop    %edi
  803c67:	5d                   	pop    %ebp
  803c68:	c3                   	ret    
  803c69:	8d 76 00             	lea    0x0(%esi),%esi
  803c6c:	31 ff                	xor    %edi,%edi
  803c6e:	31 c0                	xor    %eax,%eax
  803c70:	89 fa                	mov    %edi,%edx
  803c72:	83 c4 1c             	add    $0x1c,%esp
  803c75:	5b                   	pop    %ebx
  803c76:	5e                   	pop    %esi
  803c77:	5f                   	pop    %edi
  803c78:	5d                   	pop    %ebp
  803c79:	c3                   	ret    
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	89 d8                	mov    %ebx,%eax
  803c7e:	f7 f7                	div    %edi
  803c80:	31 ff                	xor    %edi,%edi
  803c82:	89 fa                	mov    %edi,%edx
  803c84:	83 c4 1c             	add    $0x1c,%esp
  803c87:	5b                   	pop    %ebx
  803c88:	5e                   	pop    %esi
  803c89:	5f                   	pop    %edi
  803c8a:	5d                   	pop    %ebp
  803c8b:	c3                   	ret    
  803c8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c91:	89 eb                	mov    %ebp,%ebx
  803c93:	29 fb                	sub    %edi,%ebx
  803c95:	89 f9                	mov    %edi,%ecx
  803c97:	d3 e6                	shl    %cl,%esi
  803c99:	89 c5                	mov    %eax,%ebp
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 ed                	shr    %cl,%ebp
  803c9f:	89 e9                	mov    %ebp,%ecx
  803ca1:	09 f1                	or     %esi,%ecx
  803ca3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ca7:	89 f9                	mov    %edi,%ecx
  803ca9:	d3 e0                	shl    %cl,%eax
  803cab:	89 c5                	mov    %eax,%ebp
  803cad:	89 d6                	mov    %edx,%esi
  803caf:	88 d9                	mov    %bl,%cl
  803cb1:	d3 ee                	shr    %cl,%esi
  803cb3:	89 f9                	mov    %edi,%ecx
  803cb5:	d3 e2                	shl    %cl,%edx
  803cb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbb:	88 d9                	mov    %bl,%cl
  803cbd:	d3 e8                	shr    %cl,%eax
  803cbf:	09 c2                	or     %eax,%edx
  803cc1:	89 d0                	mov    %edx,%eax
  803cc3:	89 f2                	mov    %esi,%edx
  803cc5:	f7 74 24 0c          	divl   0xc(%esp)
  803cc9:	89 d6                	mov    %edx,%esi
  803ccb:	89 c3                	mov    %eax,%ebx
  803ccd:	f7 e5                	mul    %ebp
  803ccf:	39 d6                	cmp    %edx,%esi
  803cd1:	72 19                	jb     803cec <__udivdi3+0xfc>
  803cd3:	74 0b                	je     803ce0 <__udivdi3+0xf0>
  803cd5:	89 d8                	mov    %ebx,%eax
  803cd7:	31 ff                	xor    %edi,%edi
  803cd9:	e9 58 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ce4:	89 f9                	mov    %edi,%ecx
  803ce6:	d3 e2                	shl    %cl,%edx
  803ce8:	39 c2                	cmp    %eax,%edx
  803cea:	73 e9                	jae    803cd5 <__udivdi3+0xe5>
  803cec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cef:	31 ff                	xor    %edi,%edi
  803cf1:	e9 40 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cf6:	66 90                	xchg   %ax,%ax
  803cf8:	31 c0                	xor    %eax,%eax
  803cfa:	e9 37 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cff:	90                   	nop

00803d00 <__umoddi3>:
  803d00:	55                   	push   %ebp
  803d01:	57                   	push   %edi
  803d02:	56                   	push   %esi
  803d03:	53                   	push   %ebx
  803d04:	83 ec 1c             	sub    $0x1c,%esp
  803d07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d1f:	89 f3                	mov    %esi,%ebx
  803d21:	89 fa                	mov    %edi,%edx
  803d23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d27:	89 34 24             	mov    %esi,(%esp)
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	75 1a                	jne    803d48 <__umoddi3+0x48>
  803d2e:	39 f7                	cmp    %esi,%edi
  803d30:	0f 86 a2 00 00 00    	jbe    803dd8 <__umoddi3+0xd8>
  803d36:	89 c8                	mov    %ecx,%eax
  803d38:	89 f2                	mov    %esi,%edx
  803d3a:	f7 f7                	div    %edi
  803d3c:	89 d0                	mov    %edx,%eax
  803d3e:	31 d2                	xor    %edx,%edx
  803d40:	83 c4 1c             	add    $0x1c,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	39 f0                	cmp    %esi,%eax
  803d4a:	0f 87 ac 00 00 00    	ja     803dfc <__umoddi3+0xfc>
  803d50:	0f bd e8             	bsr    %eax,%ebp
  803d53:	83 f5 1f             	xor    $0x1f,%ebp
  803d56:	0f 84 ac 00 00 00    	je     803e08 <__umoddi3+0x108>
  803d5c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d61:	29 ef                	sub    %ebp,%edi
  803d63:	89 fe                	mov    %edi,%esi
  803d65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d69:	89 e9                	mov    %ebp,%ecx
  803d6b:	d3 e0                	shl    %cl,%eax
  803d6d:	89 d7                	mov    %edx,%edi
  803d6f:	89 f1                	mov    %esi,%ecx
  803d71:	d3 ef                	shr    %cl,%edi
  803d73:	09 c7                	or     %eax,%edi
  803d75:	89 e9                	mov    %ebp,%ecx
  803d77:	d3 e2                	shl    %cl,%edx
  803d79:	89 14 24             	mov    %edx,(%esp)
  803d7c:	89 d8                	mov    %ebx,%eax
  803d7e:	d3 e0                	shl    %cl,%eax
  803d80:	89 c2                	mov    %eax,%edx
  803d82:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d86:	d3 e0                	shl    %cl,%eax
  803d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d90:	89 f1                	mov    %esi,%ecx
  803d92:	d3 e8                	shr    %cl,%eax
  803d94:	09 d0                	or     %edx,%eax
  803d96:	d3 eb                	shr    %cl,%ebx
  803d98:	89 da                	mov    %ebx,%edx
  803d9a:	f7 f7                	div    %edi
  803d9c:	89 d3                	mov    %edx,%ebx
  803d9e:	f7 24 24             	mull   (%esp)
  803da1:	89 c6                	mov    %eax,%esi
  803da3:	89 d1                	mov    %edx,%ecx
  803da5:	39 d3                	cmp    %edx,%ebx
  803da7:	0f 82 87 00 00 00    	jb     803e34 <__umoddi3+0x134>
  803dad:	0f 84 91 00 00 00    	je     803e44 <__umoddi3+0x144>
  803db3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803db7:	29 f2                	sub    %esi,%edx
  803db9:	19 cb                	sbb    %ecx,%ebx
  803dbb:	89 d8                	mov    %ebx,%eax
  803dbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dc1:	d3 e0                	shl    %cl,%eax
  803dc3:	89 e9                	mov    %ebp,%ecx
  803dc5:	d3 ea                	shr    %cl,%edx
  803dc7:	09 d0                	or     %edx,%eax
  803dc9:	89 e9                	mov    %ebp,%ecx
  803dcb:	d3 eb                	shr    %cl,%ebx
  803dcd:	89 da                	mov    %ebx,%edx
  803dcf:	83 c4 1c             	add    $0x1c,%esp
  803dd2:	5b                   	pop    %ebx
  803dd3:	5e                   	pop    %esi
  803dd4:	5f                   	pop    %edi
  803dd5:	5d                   	pop    %ebp
  803dd6:	c3                   	ret    
  803dd7:	90                   	nop
  803dd8:	89 fd                	mov    %edi,%ebp
  803dda:	85 ff                	test   %edi,%edi
  803ddc:	75 0b                	jne    803de9 <__umoddi3+0xe9>
  803dde:	b8 01 00 00 00       	mov    $0x1,%eax
  803de3:	31 d2                	xor    %edx,%edx
  803de5:	f7 f7                	div    %edi
  803de7:	89 c5                	mov    %eax,%ebp
  803de9:	89 f0                	mov    %esi,%eax
  803deb:	31 d2                	xor    %edx,%edx
  803ded:	f7 f5                	div    %ebp
  803def:	89 c8                	mov    %ecx,%eax
  803df1:	f7 f5                	div    %ebp
  803df3:	89 d0                	mov    %edx,%eax
  803df5:	e9 44 ff ff ff       	jmp    803d3e <__umoddi3+0x3e>
  803dfa:	66 90                	xchg   %ax,%ax
  803dfc:	89 c8                	mov    %ecx,%eax
  803dfe:	89 f2                	mov    %esi,%edx
  803e00:	83 c4 1c             	add    $0x1c,%esp
  803e03:	5b                   	pop    %ebx
  803e04:	5e                   	pop    %esi
  803e05:	5f                   	pop    %edi
  803e06:	5d                   	pop    %ebp
  803e07:	c3                   	ret    
  803e08:	3b 04 24             	cmp    (%esp),%eax
  803e0b:	72 06                	jb     803e13 <__umoddi3+0x113>
  803e0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e11:	77 0f                	ja     803e22 <__umoddi3+0x122>
  803e13:	89 f2                	mov    %esi,%edx
  803e15:	29 f9                	sub    %edi,%ecx
  803e17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e1b:	89 14 24             	mov    %edx,(%esp)
  803e1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e22:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e26:	8b 14 24             	mov    (%esp),%edx
  803e29:	83 c4 1c             	add    $0x1c,%esp
  803e2c:	5b                   	pop    %ebx
  803e2d:	5e                   	pop    %esi
  803e2e:	5f                   	pop    %edi
  803e2f:	5d                   	pop    %ebp
  803e30:	c3                   	ret    
  803e31:	8d 76 00             	lea    0x0(%esi),%esi
  803e34:	2b 04 24             	sub    (%esp),%eax
  803e37:	19 fa                	sbb    %edi,%edx
  803e39:	89 d1                	mov    %edx,%ecx
  803e3b:	89 c6                	mov    %eax,%esi
  803e3d:	e9 71 ff ff ff       	jmp    803db3 <__umoddi3+0xb3>
  803e42:	66 90                	xchg   %ax,%ax
  803e44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e48:	72 ea                	jb     803e34 <__umoddi3+0x134>
  803e4a:	89 d9                	mov    %ebx,%ecx
  803e4c:	e9 62 ff ff ff       	jmp    803db3 <__umoddi3+0xb3>
