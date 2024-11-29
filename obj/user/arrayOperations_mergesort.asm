
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
  80003e:	e8 ff 1c 00 00       	call   801d42 <sys_getparentenvid>
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
  800057:	68 60 3f 80 00       	push   $0x803f60
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 fa 17 00 00       	call   80185e <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 64 3f 80 00       	push   $0x803f64
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 e4 17 00 00       	call   80185e <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 6c 3f 80 00       	push   $0x803f6c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 c7 17 00 00       	call   80185e <sget>
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
  8000ab:	68 7a 3f 80 00       	push   $0x803f7a
  8000b0:	e8 9f 16 00 00       	call   801754 <smalloc>
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
  80010c:	68 89 3f 80 00       	push   $0x803f89
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
  8001a2:	68 a5 3f 80 00       	push   $0x803fa5
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
  8001c4:	68 a7 3f 80 00       	push   $0x803fa7
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
  8001f2:	68 ac 3f 80 00       	push   $0x803fac
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
  800479:	e8 ab 18 00 00       	call   801d29 <sys_getenvindex>
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
  8004e7:	e8 c1 15 00 00       	call   801aad <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 c8 3f 80 00       	push   $0x803fc8
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
  800517:	68 f0 3f 80 00       	push   $0x803ff0
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
  800548:	68 18 40 80 00       	push   $0x804018
  80054d:	e8 34 01 00 00       	call   800686 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 70 40 80 00       	push   $0x804070
  800569:	e8 18 01 00 00       	call   800686 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800571:	83 ec 0c             	sub    $0xc,%esp
  800574:	68 c8 3f 80 00       	push   $0x803fc8
  800579:	e8 08 01 00 00       	call   800686 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800581:	e8 41 15 00 00       	call   801ac7 <sys_unlock_cons>
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
  800599:	e8 57 17 00 00       	call   801cf5 <sys_destroy_env>
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
  8005aa:	e8 ac 17 00 00       	call   801d5b <sys_exit_env>
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
  8005dd:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8005f8:	e8 6e 14 00 00       	call   801a6b <sys_cputs>
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
  800652:	a0 2c 50 80 00       	mov    0x80502c,%al
  800657:	0f b6 c0             	movzbl %al,%eax
  80065a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	50                   	push   %eax
  800664:	52                   	push   %edx
  800665:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066b:	83 c0 08             	add    $0x8,%eax
  80066e:	50                   	push   %eax
  80066f:	e8 f7 13 00 00       	call   801a6b <sys_cputs>
  800674:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800677:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  80068c:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8006b9:	e8 ef 13 00 00       	call   801aad <sys_lock_cons>
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
  8006d9:	e8 e9 13 00 00       	call   801ac7 <sys_unlock_cons>
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
  800723:	e8 c4 35 00 00       	call   803cec <__udivdi3>
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
  800773:	e8 84 36 00 00       	call   803dfc <__umoddi3>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	05 b4 42 80 00       	add    $0x8042b4,%eax
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
  8008ce:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
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
  8009af:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 19                	jne    8009d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	53                   	push   %ebx
  8009bb:	68 c5 42 80 00       	push   $0x8042c5
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
  8009d4:	68 ce 42 80 00       	push   $0x8042ce
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
  800a01:	be d1 42 80 00       	mov    $0x8042d1,%esi
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
  800bf9:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800c00:	eb 2c                	jmp    800c2e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c02:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  80140c:	68 48 44 80 00       	push   $0x804448
  801411:	68 3f 01 00 00       	push   $0x13f
  801416:	68 6a 44 80 00       	push   $0x80446a
  80141b:	e8 e2 26 00 00       	call   803b02 <_panic>

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
  80142c:	e8 e5 0b 00 00       	call   802016 <sys_sbrk>
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
  8014a7:	e8 ee 09 00 00       	call   801e9a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 16                	je     8014c6 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 2e 0f 00 00       	call   8023e9 <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	e9 8a 01 00 00       	jmp    801650 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014c6:	e8 00 0a 00 00       	call   801ecb <sys_isUHeapPlacementStrategyBESTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 84 7d 01 00 00    	je     801650 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 c7 13 00 00       	call   8028a5 <alloc_block_BF>
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
  801529:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801576:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8015cd:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  80162f:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	ff 75 f0             	pushl  -0x10(%ebp)
  80163f:	e8 09 0a 00 00       	call   80204d <sys_allocate_user_mem>
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
  801687:	e8 dd 09 00 00       	call   802069 <get_block_size>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 10 1c 00 00       	call   8032ad <free_block>
  80169d:	83 c4 10             	add    $0x10,%esp
		}

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
  8016d2:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  8016d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8016dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016df:	c1 e0 0c             	shl    $0xc,%eax
  8016e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8016e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016ec:	eb 42                	jmp    801730 <free+0xdb>
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
  80170f:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801716:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80171a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	52                   	push   %edx
  801724:	50                   	push   %eax
  801725:	e8 07 09 00 00       	call   802031 <sys_free_user_mem>
  80172a:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80172d:	ff 45 f4             	incl   -0xc(%ebp)
  801730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801733:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801736:	72 b6                	jb     8016ee <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801738:	eb 17                	jmp    801751 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	68 78 44 80 00       	push   $0x804478
  801742:	68 88 00 00 00       	push   $0x88
  801747:	68 a2 44 80 00       	push   $0x8044a2
  80174c:	e8 b1 23 00 00       	call   803b02 <_panic>
	}
}
  801751:	90                   	nop
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 28             	sub    $0x28,%esp
  80175a:	8b 45 10             	mov    0x10(%ebp),%eax
  80175d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801760:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801764:	75 0a                	jne    801770 <smalloc+0x1c>
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	e9 ec 00 00 00       	jmp    80185c <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801770:	8b 45 0c             	mov    0xc(%ebp),%eax
  801773:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801776:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80177d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	39 d0                	cmp    %edx,%eax
  801785:	73 02                	jae    801789 <smalloc+0x35>
  801787:	89 d0                	mov    %edx,%eax
  801789:	83 ec 0c             	sub    $0xc,%esp
  80178c:	50                   	push   %eax
  80178d:	e8 a4 fc ff ff       	call   801436 <malloc>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801798:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80179c:	75 0a                	jne    8017a8 <smalloc+0x54>
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	e9 b4 00 00 00       	jmp    80185c <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017a8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	e8 7d 04 00 00       	call   801c38 <sys_createSharedObject>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017c1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017c5:	74 06                	je     8017cd <smalloc+0x79>
  8017c7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017cb:	75 0a                	jne    8017d7 <smalloc+0x83>
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	e9 85 00 00 00       	jmp    80185c <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	ff 75 ec             	pushl  -0x14(%ebp)
  8017dd:	68 ae 44 80 00       	push   $0x8044ae
  8017e2:	e8 9f ee ff ff       	call   800686 <cprintf>
  8017e7:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8017ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f2:	8b 40 78             	mov    0x78(%eax),%eax
  8017f5:	29 c2                	sub    %eax,%edx
  8017f7:	89 d0                	mov    %edx,%eax
  8017f9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017fe:	c1 e8 0c             	shr    $0xc,%eax
  801801:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801807:	42                   	inc    %edx
  801808:	89 15 24 50 80 00    	mov    %edx,0x805024
  80180e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801814:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80181b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80181e:	a1 20 50 80 00       	mov    0x805020,%eax
  801823:	8b 40 78             	mov    0x78(%eax),%eax
  801826:	29 c2                	sub    %eax,%edx
  801828:	89 d0                	mov    %edx,%eax
  80182a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80182f:	c1 e8 0c             	shr    $0xc,%eax
  801832:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801839:	a1 20 50 80 00       	mov    0x805020,%eax
  80183e:	8b 50 10             	mov    0x10(%eax),%edx
  801841:	89 c8                	mov    %ecx,%eax
  801843:	c1 e0 02             	shl    $0x2,%eax
  801846:	89 c1                	mov    %eax,%ecx
  801848:	c1 e1 09             	shl    $0x9,%ecx
  80184b:	01 c8                	add    %ecx,%eax
  80184d:	01 c2                	add    %eax,%edx
  80184f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801852:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801859:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801864:	83 ec 08             	sub    $0x8,%esp
  801867:	ff 75 0c             	pushl  0xc(%ebp)
  80186a:	ff 75 08             	pushl  0x8(%ebp)
  80186d:	e8 f0 03 00 00       	call   801c62 <sys_getSizeOfSharedObject>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801878:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80187c:	75 0a                	jne    801888 <sget+0x2a>
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	e9 e7 00 00 00       	jmp    80196f <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80188e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801895:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	39 d0                	cmp    %edx,%eax
  80189d:	73 02                	jae    8018a1 <sget+0x43>
  80189f:	89 d0                	mov    %edx,%eax
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	50                   	push   %eax
  8018a5:	e8 8c fb ff ff       	call   801436 <malloc>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018b4:	75 0a                	jne    8018c0 <sget+0x62>
  8018b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bb:	e9 af 00 00 00       	jmp    80196f <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	e8 ae 03 00 00       	call   801c7f <sys_getSharedObject>
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8018d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018da:	a1 20 50 80 00       	mov    0x805020,%eax
  8018df:	8b 40 78             	mov    0x78(%eax),%eax
  8018e2:	29 c2                	sub    %eax,%edx
  8018e4:	89 d0                	mov    %edx,%eax
  8018e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018eb:	c1 e8 0c             	shr    $0xc,%eax
  8018ee:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018f4:	42                   	inc    %edx
  8018f5:	89 15 24 50 80 00    	mov    %edx,0x805024
  8018fb:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801901:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801908:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80190b:	a1 20 50 80 00       	mov    0x805020,%eax
  801910:	8b 40 78             	mov    0x78(%eax),%eax
  801913:	29 c2                	sub    %eax,%edx
  801915:	89 d0                	mov    %edx,%eax
  801917:	2d 00 10 00 00       	sub    $0x1000,%eax
  80191c:	c1 e8 0c             	shr    $0xc,%eax
  80191f:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801926:	a1 20 50 80 00       	mov    0x805020,%eax
  80192b:	8b 50 10             	mov    0x10(%eax),%edx
  80192e:	89 c8                	mov    %ecx,%eax
  801930:	c1 e0 02             	shl    $0x2,%eax
  801933:	89 c1                	mov    %eax,%ecx
  801935:	c1 e1 09             	shl    $0x9,%ecx
  801938:	01 c8                	add    %ecx,%eax
  80193a:	01 c2                	add    %eax,%edx
  80193c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801946:	a1 20 50 80 00       	mov    0x805020,%eax
  80194b:	8b 40 10             	mov    0x10(%eax),%eax
  80194e:	83 ec 08             	sub    $0x8,%esp
  801951:	50                   	push   %eax
  801952:	68 bd 44 80 00       	push   $0x8044bd
  801957:	e8 2a ed ff ff       	call   800686 <cprintf>
  80195c:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80195f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801963:	75 07                	jne    80196c <sget+0x10e>
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
  80196a:	eb 03                	jmp    80196f <sget+0x111>
	return ptr;
  80196c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801977:	8b 55 08             	mov    0x8(%ebp),%edx
  80197a:	a1 20 50 80 00       	mov    0x805020,%eax
  80197f:	8b 40 78             	mov    0x78(%eax),%eax
  801982:	29 c2                	sub    %eax,%edx
  801984:	89 d0                	mov    %edx,%eax
  801986:	2d 00 10 00 00       	sub    $0x1000,%eax
  80198b:	c1 e8 0c             	shr    $0xc,%eax
  80198e:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801995:	a1 20 50 80 00       	mov    0x805020,%eax
  80199a:	8b 50 10             	mov    0x10(%eax),%edx
  80199d:	89 c8                	mov    %ecx,%eax
  80199f:	c1 e0 02             	shl    $0x2,%eax
  8019a2:	89 c1                	mov    %eax,%ecx
  8019a4:	c1 e1 09             	shl    $0x9,%ecx
  8019a7:	01 c8                	add    %ecx,%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019be:	e8 db 02 00 00       	call   801c9e <sys_freeSharedObject>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	68 cc 44 80 00       	push   $0x8044cc
  8019da:	68 e5 00 00 00       	push   $0xe5
  8019df:	68 a2 44 80 00       	push   $0x8044a2
  8019e4:	e8 19 21 00 00       	call   803b02 <_panic>

008019e9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	68 f2 44 80 00       	push   $0x8044f2
  8019f7:	68 f1 00 00 00       	push   $0xf1
  8019fc:	68 a2 44 80 00       	push   $0x8044a2
  801a01:	e8 fc 20 00 00       	call   803b02 <_panic>

00801a06 <shrink>:

}
void shrink(uint32 newSize)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 f2 44 80 00       	push   $0x8044f2
  801a14:	68 f6 00 00 00       	push   $0xf6
  801a19:	68 a2 44 80 00       	push   $0x8044a2
  801a1e:	e8 df 20 00 00       	call   803b02 <_panic>

00801a23 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	68 f2 44 80 00       	push   $0x8044f2
  801a31:	68 fb 00 00 00       	push   $0xfb
  801a36:	68 a2 44 80 00       	push   $0x8044a2
  801a3b:	e8 c2 20 00 00       	call   803b02 <_panic>

00801a40 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	57                   	push   %edi
  801a44:	56                   	push   %esi
  801a45:	53                   	push   %ebx
  801a46:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a55:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a58:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a5b:	cd 30                	int    $0x30
  801a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5f                   	pop    %edi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a77:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	52                   	push   %edx
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	6a 00                	push   $0x0
  801a89:	e8 b2 ff ff ff       	call   801a40 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 02                	push   $0x2
  801aa3:	e8 98 ff ff ff       	call   801a40 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_lock_cons>:

void sys_lock_cons(void)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 03                	push   $0x3
  801abc:	e8 7f ff ff ff       	call   801a40 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 04                	push   $0x4
  801ad6:	e8 65 ff ff ff       	call   801a40 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	52                   	push   %edx
  801af1:	50                   	push   %eax
  801af2:	6a 08                	push   $0x8
  801af4:	e8 47 ff ff ff       	call   801a40 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	56                   	push   %esi
  801b02:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b03:	8b 75 18             	mov    0x18(%ebp),%esi
  801b06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	51                   	push   %ecx
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 09                	push   $0x9
  801b19:	e8 22 ff ff ff       	call   801a40 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b24:	5b                   	pop    %ebx
  801b25:	5e                   	pop    %esi
  801b26:	5d                   	pop    %ebp
  801b27:	c3                   	ret    

00801b28 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	6a 0a                	push   $0xa
  801b3b:	e8 00 ff ff ff       	call   801a40 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	6a 0b                	push   $0xb
  801b56:	e8 e5 fe ff ff       	call   801a40 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 0c                	push   $0xc
  801b6f:	e8 cc fe ff ff       	call   801a40 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 0d                	push   $0xd
  801b88:	e8 b3 fe ff ff       	call   801a40 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 0e                	push   $0xe
  801ba1:	e8 9a fe ff ff       	call   801a40 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 0f                	push   $0xf
  801bba:	e8 81 fe ff ff       	call   801a40 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 10                	push   $0x10
  801bd4:	e8 67 fe ff ff       	call   801a40 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 11                	push   $0x11
  801bed:	e8 4e fe ff ff       	call   801a40 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	90                   	nop
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_cputc>:

void
sys_cputc(const char c)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c04:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	50                   	push   %eax
  801c11:	6a 01                	push   $0x1
  801c13:	e8 28 fe ff ff       	call   801a40 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 14                	push   $0x14
  801c2d:	e8 0e fe ff ff       	call   801a40 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	90                   	nop
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c41:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c44:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c47:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	51                   	push   %ecx
  801c51:	52                   	push   %edx
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	50                   	push   %eax
  801c56:	6a 15                	push   $0x15
  801c58:	e8 e3 fd ff ff       	call   801a40 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	6a 16                	push   $0x16
  801c75:	e8 c6 fd ff ff       	call   801a40 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	51                   	push   %ecx
  801c90:	52                   	push   %edx
  801c91:	50                   	push   %eax
  801c92:	6a 17                	push   $0x17
  801c94:	e8 a7 fd ff ff       	call   801a40 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	52                   	push   %edx
  801cae:	50                   	push   %eax
  801caf:	6a 18                	push   $0x18
  801cb1:	e8 8a fd ff ff       	call   801a40 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	ff 75 14             	pushl  0x14(%ebp)
  801cc6:	ff 75 10             	pushl  0x10(%ebp)
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	50                   	push   %eax
  801ccd:	6a 19                	push   $0x19
  801ccf:	e8 6c fd ff ff       	call   801a40 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	50                   	push   %eax
  801ce8:	6a 1a                	push   $0x1a
  801cea:	e8 51 fd ff ff       	call   801a40 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	90                   	nop
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	50                   	push   %eax
  801d04:	6a 1b                	push   $0x1b
  801d06:	e8 35 fd ff ff       	call   801a40 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 05                	push   $0x5
  801d1f:	e8 1c fd ff ff       	call   801a40 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 06                	push   $0x6
  801d38:	e8 03 fd ff ff       	call   801a40 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 07                	push   $0x7
  801d51:	e8 ea fc ff ff       	call   801a40 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_exit_env>:


void sys_exit_env(void)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 1c                	push   $0x1c
  801d6a:	e8 d1 fc ff ff       	call   801a40 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d7b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d7e:	8d 50 04             	lea    0x4(%eax),%edx
  801d81:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	6a 1d                	push   $0x1d
  801d8e:	e8 ad fc ff ff       	call   801a40 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
	return result;
  801d96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d9f:	89 01                	mov    %eax,(%ecx)
  801da1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	c9                   	leave  
  801da8:	c2 04 00             	ret    $0x4

00801dab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 10             	pushl  0x10(%ebp)
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	6a 13                	push   $0x13
  801dbd:	e8 7e fc ff ff       	call   801a40 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 1e                	push   $0x1e
  801dd7:	e8 64 fc ff ff       	call   801a40 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ded:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	50                   	push   %eax
  801dfa:	6a 1f                	push   $0x1f
  801dfc:	e8 3f fc ff ff       	call   801a40 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
	return ;
  801e04:	90                   	nop
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <rsttst>:
void rsttst()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 21                	push   $0x21
  801e16:	e8 25 fc ff ff       	call   801a40 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1e:	90                   	nop
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e2d:	8b 55 18             	mov    0x18(%ebp),%edx
  801e30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e34:	52                   	push   %edx
  801e35:	50                   	push   %eax
  801e36:	ff 75 10             	pushl  0x10(%ebp)
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	6a 20                	push   $0x20
  801e41:	e8 fa fb ff ff       	call   801a40 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
	return ;
  801e49:	90                   	nop
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <chktst>:
void chktst(uint32 n)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	ff 75 08             	pushl  0x8(%ebp)
  801e5a:	6a 22                	push   $0x22
  801e5c:	e8 df fb ff ff       	call   801a40 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
	return ;
  801e64:	90                   	nop
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <inctst>:

void inctst()
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 23                	push   $0x23
  801e76:	e8 c5 fb ff ff       	call   801a40 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7e:	90                   	nop
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <gettst>:
uint32 gettst()
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 24                	push   $0x24
  801e90:	e8 ab fb ff ff       	call   801a40 <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 25                	push   $0x25
  801eac:	e8 8f fb ff ff       	call   801a40 <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
  801eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eb7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ebb:	75 07                	jne    801ec4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec2:	eb 05                	jmp    801ec9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 25                	push   $0x25
  801edd:	e8 5e fb ff ff       	call   801a40 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
  801ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ee8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eec:	75 07                	jne    801ef5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	eb 05                	jmp    801efa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 25                	push   $0x25
  801f0e:	e8 2d fb ff ff       	call   801a40 <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f19:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f1d:	75 07                	jne    801f26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f24:	eb 05                	jmp    801f2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 25                	push   $0x25
  801f3f:	e8 fc fa ff ff       	call   801a40 <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
  801f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f4a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f4e:	75 07                	jne    801f57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f50:	b8 01 00 00 00       	mov    $0x1,%eax
  801f55:	eb 05                	jmp    801f5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	6a 26                	push   $0x26
  801f6e:	e8 cd fa ff ff       	call   801a40 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
	return ;
  801f76:	90                   	nop
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	6a 00                	push   $0x0
  801f8b:	53                   	push   %ebx
  801f8c:	51                   	push   %ecx
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	6a 27                	push   $0x27
  801f91:	e8 aa fa ff ff       	call   801a40 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	6a 28                	push   $0x28
  801fb1:	e8 8a fa ff ff       	call   801a40 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fbe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	51                   	push   %ecx
  801fca:	ff 75 10             	pushl  0x10(%ebp)
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	6a 29                	push   $0x29
  801fd1:	e8 6a fa ff ff       	call   801a40 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	ff 75 10             	pushl  0x10(%ebp)
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	ff 75 08             	pushl  0x8(%ebp)
  801feb:	6a 12                	push   $0x12
  801fed:	e8 4e fa ff ff       	call   801a40 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff5:	90                   	nop
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	52                   	push   %edx
  802008:	50                   	push   %eax
  802009:	6a 2a                	push   $0x2a
  80200b:	e8 30 fa ff ff       	call   801a40 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
	return;
  802013:	90                   	nop
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	50                   	push   %eax
  802025:	6a 2b                	push   $0x2b
  802027:	e8 14 fa ff ff       	call   801a40 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	6a 2c                	push   $0x2c
  802042:	e8 f9 f9 ff ff       	call   801a40 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
	return;
  80204a:	90                   	nop
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	ff 75 08             	pushl  0x8(%ebp)
  80205c:	6a 2d                	push   $0x2d
  80205e:	e8 dd f9 ff ff       	call   801a40 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
	return;
  802066:	90                   	nop
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	83 e8 04             	sub    $0x4,%eax
  802075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	83 e8 04             	sub    $0x4,%eax
  80208e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802094:	8b 00                	mov    (%eax),%eax
  802096:	83 e0 01             	and    $0x1,%eax
  802099:	85 c0                	test   %eax,%eax
  80209b:	0f 94 c0             	sete   %al
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b0:	83 f8 02             	cmp    $0x2,%eax
  8020b3:	74 2b                	je     8020e0 <alloc_block+0x40>
  8020b5:	83 f8 02             	cmp    $0x2,%eax
  8020b8:	7f 07                	jg     8020c1 <alloc_block+0x21>
  8020ba:	83 f8 01             	cmp    $0x1,%eax
  8020bd:	74 0e                	je     8020cd <alloc_block+0x2d>
  8020bf:	eb 58                	jmp    802119 <alloc_block+0x79>
  8020c1:	83 f8 03             	cmp    $0x3,%eax
  8020c4:	74 2d                	je     8020f3 <alloc_block+0x53>
  8020c6:	83 f8 04             	cmp    $0x4,%eax
  8020c9:	74 3b                	je     802106 <alloc_block+0x66>
  8020cb:	eb 4c                	jmp    802119 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	ff 75 08             	pushl  0x8(%ebp)
  8020d3:	e8 11 03 00 00       	call   8023e9 <alloc_block_FF>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020de:	eb 4a                	jmp    80212a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	ff 75 08             	pushl  0x8(%ebp)
  8020e6:	e8 fa 19 00 00       	call   803ae5 <alloc_block_NF>
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f1:	eb 37                	jmp    80212a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	ff 75 08             	pushl  0x8(%ebp)
  8020f9:	e8 a7 07 00 00       	call   8028a5 <alloc_block_BF>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802104:	eb 24                	jmp    80212a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	e8 b7 19 00 00       	call   803ac8 <alloc_block_WF>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802117:	eb 11                	jmp    80212a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	68 04 45 80 00       	push   $0x804504
  802121:	e8 60 e5 ff ff       	call   800686 <cprintf>
  802126:	83 c4 10             	add    $0x10,%esp
		break;
  802129:	90                   	nop
	}
	return va;
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	53                   	push   %ebx
  802133:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802136:	83 ec 0c             	sub    $0xc,%esp
  802139:	68 24 45 80 00       	push   $0x804524
  80213e:	e8 43 e5 ff ff       	call   800686 <cprintf>
  802143:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	68 4f 45 80 00       	push   $0x80454f
  80214e:	e8 33 e5 ff ff       	call   800686 <cprintf>
  802153:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215c:	eb 37                	jmp    802195 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	ff 75 f4             	pushl  -0xc(%ebp)
  802164:	e8 19 ff ff ff       	call   802082 <is_free_block>
  802169:	83 c4 10             	add    $0x10,%esp
  80216c:	0f be d8             	movsbl %al,%ebx
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	ff 75 f4             	pushl  -0xc(%ebp)
  802175:	e8 ef fe ff ff       	call   802069 <get_block_size>
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	53                   	push   %ebx
  802181:	50                   	push   %eax
  802182:	68 67 45 80 00       	push   $0x804567
  802187:	e8 fa e4 ff ff       	call   800686 <cprintf>
  80218c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80218f:	8b 45 10             	mov    0x10(%ebp),%eax
  802192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802195:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802199:	74 07                	je     8021a2 <print_blocks_list+0x73>
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	eb 05                	jmp    8021a7 <print_blocks_list+0x78>
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a7:	89 45 10             	mov    %eax,0x10(%ebp)
  8021aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	75 ad                	jne    80215e <print_blocks_list+0x2f>
  8021b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b5:	75 a7                	jne    80215e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	68 24 45 80 00       	push   $0x804524
  8021bf:	e8 c2 e4 ff ff       	call   800686 <cprintf>
  8021c4:	83 c4 10             	add    $0x10,%esp

}
  8021c7:	90                   	nop
  8021c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d6:	83 e0 01             	and    $0x1,%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 03                	je     8021e0 <initialize_dynamic_allocator+0x13>
  8021dd:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e4:	0f 84 c7 01 00 00    	je     8023b1 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021ea:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8021f1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802201:	0f 87 ad 01 00 00    	ja     8023b4 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	0f 89 a5 01 00 00    	jns    8023b7 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802212:	8b 55 08             	mov    0x8(%ebp),%edx
  802215:	8b 45 0c             	mov    0xc(%ebp),%eax
  802218:	01 d0                	add    %edx,%eax
  80221a:	83 e8 04             	sub    $0x4,%eax
  80221d:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802229:	a1 30 50 80 00       	mov    0x805030,%eax
  80222e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802231:	e9 87 00 00 00       	jmp    8022bd <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223a:	75 14                	jne    802250 <initialize_dynamic_allocator+0x83>
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	68 7f 45 80 00       	push   $0x80457f
  802244:	6a 79                	push   $0x79
  802246:	68 9d 45 80 00       	push   $0x80459d
  80224b:	e8 b2 18 00 00       	call   803b02 <_panic>
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	74 10                	je     802269 <initialize_dynamic_allocator+0x9c>
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 00                	mov    (%eax),%eax
  80225e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802261:	8b 52 04             	mov    0x4(%edx),%edx
  802264:	89 50 04             	mov    %edx,0x4(%eax)
  802267:	eb 0b                	jmp    802274 <initialize_dynamic_allocator+0xa7>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 40 04             	mov    0x4(%eax),%eax
  80226f:	a3 34 50 80 00       	mov    %eax,0x805034
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 40 04             	mov    0x4(%eax),%eax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	74 0f                	je     80228d <initialize_dynamic_allocator+0xc0>
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 40 04             	mov    0x4(%eax),%eax
  802284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802287:	8b 12                	mov    (%edx),%edx
  802289:	89 10                	mov    %edx,(%eax)
  80228b:	eb 0a                	jmp    802297 <initialize_dynamic_allocator+0xca>
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	a3 30 50 80 00       	mov    %eax,0x805030
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022aa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022af:	48                   	dec    %eax
  8022b0:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	74 07                	je     8022ca <initialize_dynamic_allocator+0xfd>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	eb 05                	jmp    8022cf <initialize_dynamic_allocator+0x102>
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	a3 38 50 80 00       	mov    %eax,0x805038
  8022d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	0f 85 55 ff ff ff    	jne    802236 <initialize_dynamic_allocator+0x69>
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	0f 85 4b ff ff ff    	jne    802236 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022fa:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ff:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802304:	a1 44 50 80 00       	mov    0x805044,%eax
  802309:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	83 c0 08             	add    $0x8,%eax
  802315:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	83 c0 04             	add    $0x4,%eax
  80231e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802321:	83 ea 08             	sub    $0x8,%edx
  802324:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	01 d0                	add    %edx,%eax
  80232e:	83 e8 08             	sub    $0x8,%eax
  802331:	8b 55 0c             	mov    0xc(%ebp),%edx
  802334:	83 ea 08             	sub    $0x8,%edx
  802337:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802342:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80234c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802350:	75 17                	jne    802369 <initialize_dynamic_allocator+0x19c>
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 b8 45 80 00       	push   $0x8045b8
  80235a:	68 90 00 00 00       	push   $0x90
  80235f:	68 9d 45 80 00       	push   $0x80459d
  802364:	e8 99 17 00 00       	call   803b02 <_panic>
  802369:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80236f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802372:	89 10                	mov    %edx,(%eax)
  802374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	85 c0                	test   %eax,%eax
  80237b:	74 0d                	je     80238a <initialize_dynamic_allocator+0x1bd>
  80237d:	a1 30 50 80 00       	mov    0x805030,%eax
  802382:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802385:	89 50 04             	mov    %edx,0x4(%eax)
  802388:	eb 08                	jmp    802392 <initialize_dynamic_allocator+0x1c5>
  80238a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238d:	a3 34 50 80 00       	mov    %eax,0x805034
  802392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802395:	a3 30 50 80 00       	mov    %eax,0x805030
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8023a9:	40                   	inc    %eax
  8023aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8023af:	eb 07                	jmp    8023b8 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023b1:	90                   	nop
  8023b2:	eb 04                	jmp    8023b8 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023b4:	90                   	nop
  8023b5:	eb 01                	jmp    8023b8 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023b7:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c0:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cc:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	83 e8 04             	sub    $0x4,%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	83 e0 fe             	and    $0xfffffffe,%eax
  8023d9:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	01 c2                	add    %eax,%edx
  8023e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e4:	89 02                	mov    %eax,(%edx)
}
  8023e6:	90                   	nop
  8023e7:	5d                   	pop    %ebp
  8023e8:	c3                   	ret    

008023e9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	83 e0 01             	and    $0x1,%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 03                	je     8023fc <alloc_block_FF+0x13>
  8023f9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023fc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802400:	77 07                	ja     802409 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802402:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802409:	a1 28 50 80 00       	mov    0x805028,%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	75 73                	jne    802485 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	83 c0 10             	add    $0x10,%eax
  802418:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80241b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802422:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802428:	01 d0                	add    %edx,%eax
  80242a:	48                   	dec    %eax
  80242b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80242e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802431:	ba 00 00 00 00       	mov    $0x0,%edx
  802436:	f7 75 ec             	divl   -0x14(%ebp)
  802439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80243c:	29 d0                	sub    %edx,%eax
  80243e:	c1 e8 0c             	shr    $0xc,%eax
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	50                   	push   %eax
  802445:	e8 d6 ef ff ff       	call   801420 <sbrk>
  80244a:	83 c4 10             	add    $0x10,%esp
  80244d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802450:	83 ec 0c             	sub    $0xc,%esp
  802453:	6a 00                	push   $0x0
  802455:	e8 c6 ef ff ff       	call   801420 <sbrk>
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802463:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802466:	83 ec 08             	sub    $0x8,%esp
  802469:	50                   	push   %eax
  80246a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80246d:	e8 5b fd ff ff       	call   8021cd <initialize_dynamic_allocator>
  802472:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802475:	83 ec 0c             	sub    $0xc,%esp
  802478:	68 db 45 80 00       	push   $0x8045db
  80247d:	e8 04 e2 ff ff       	call   800686 <cprintf>
  802482:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802485:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802489:	75 0a                	jne    802495 <alloc_block_FF+0xac>
	        return NULL;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
  802490:	e9 0e 04 00 00       	jmp    8028a3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80249c:	a1 30 50 80 00       	mov    0x805030,%eax
  8024a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a4:	e9 f3 02 00 00       	jmp    80279c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024af:	83 ec 0c             	sub    $0xc,%esp
  8024b2:	ff 75 bc             	pushl  -0x44(%ebp)
  8024b5:	e8 af fb ff ff       	call   802069 <get_block_size>
  8024ba:	83 c4 10             	add    $0x10,%esp
  8024bd:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	83 c0 08             	add    $0x8,%eax
  8024c6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024c9:	0f 87 c5 02 00 00    	ja     802794 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	83 c0 18             	add    $0x18,%eax
  8024d5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024d8:	0f 87 19 02 00 00    	ja     8026f7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024e1:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e4:	83 e8 08             	sub    $0x8,%eax
  8024e7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	8d 50 08             	lea    0x8(%eax),%edx
  8024f0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024f3:	01 d0                	add    %edx,%eax
  8024f5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	83 c0 08             	add    $0x8,%eax
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	6a 01                	push   $0x1
  802503:	50                   	push   %eax
  802504:	ff 75 bc             	pushl  -0x44(%ebp)
  802507:	e8 ae fe ff ff       	call   8023ba <set_block_data>
  80250c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 04             	mov    0x4(%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	75 68                	jne    802581 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802519:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80251d:	75 17                	jne    802536 <alloc_block_FF+0x14d>
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	68 b8 45 80 00       	push   $0x8045b8
  802527:	68 d7 00 00 00       	push   $0xd7
  80252c:	68 9d 45 80 00       	push   $0x80459d
  802531:	e8 cc 15 00 00       	call   803b02 <_panic>
  802536:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80253c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253f:	89 10                	mov    %edx,(%eax)
  802541:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 0d                	je     802557 <alloc_block_FF+0x16e>
  80254a:	a1 30 50 80 00       	mov    0x805030,%eax
  80254f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802552:	89 50 04             	mov    %edx,0x4(%eax)
  802555:	eb 08                	jmp    80255f <alloc_block_FF+0x176>
  802557:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80255a:	a3 34 50 80 00       	mov    %eax,0x805034
  80255f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802562:	a3 30 50 80 00       	mov    %eax,0x805030
  802567:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802571:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802576:	40                   	inc    %eax
  802577:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80257c:	e9 dc 00 00 00       	jmp    80265d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	75 65                	jne    8025ef <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80258a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80258e:	75 17                	jne    8025a7 <alloc_block_FF+0x1be>
  802590:	83 ec 04             	sub    $0x4,%esp
  802593:	68 ec 45 80 00       	push   $0x8045ec
  802598:	68 db 00 00 00       	push   $0xdb
  80259d:	68 9d 45 80 00       	push   $0x80459d
  8025a2:	e8 5b 15 00 00       	call   803b02 <_panic>
  8025a7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8025ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b0:	89 50 04             	mov    %edx,0x4(%eax)
  8025b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b6:	8b 40 04             	mov    0x4(%eax),%eax
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	74 0c                	je     8025c9 <alloc_block_FF+0x1e0>
  8025bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8025c2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025c5:	89 10                	mov    %edx,(%eax)
  8025c7:	eb 08                	jmp    8025d1 <alloc_block_FF+0x1e8>
  8025c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d4:	a3 34 50 80 00       	mov    %eax,0x805034
  8025d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025e7:	40                   	inc    %eax
  8025e8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025ed:	eb 6e                	jmp    80265d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f3:	74 06                	je     8025fb <alloc_block_FF+0x212>
  8025f5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025f9:	75 17                	jne    802612 <alloc_block_FF+0x229>
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 10 46 80 00       	push   $0x804610
  802603:	68 df 00 00 00       	push   $0xdf
  802608:	68 9d 45 80 00       	push   $0x80459d
  80260d:	e8 f0 14 00 00       	call   803b02 <_panic>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 10                	mov    (%eax),%edx
  802617:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261a:	89 10                	mov    %edx,(%eax)
  80261c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0b                	je     802630 <alloc_block_FF+0x247>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80262d:	89 50 04             	mov    %edx,0x4(%eax)
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802636:	89 10                	mov    %edx,(%eax)
  802638:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263e:	89 50 04             	mov    %edx,0x4(%eax)
  802641:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	75 08                	jne    802652 <alloc_block_FF+0x269>
  80264a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264d:	a3 34 50 80 00       	mov    %eax,0x805034
  802652:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802657:	40                   	inc    %eax
  802658:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80265d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802661:	75 17                	jne    80267a <alloc_block_FF+0x291>
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	68 7f 45 80 00       	push   $0x80457f
  80266b:	68 e1 00 00 00       	push   $0xe1
  802670:	68 9d 45 80 00       	push   $0x80459d
  802675:	e8 88 14 00 00       	call   803b02 <_panic>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	74 10                	je     802693 <alloc_block_FF+0x2aa>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268b:	8b 52 04             	mov    0x4(%edx),%edx
  80268e:	89 50 04             	mov    %edx,0x4(%eax)
  802691:	eb 0b                	jmp    80269e <alloc_block_FF+0x2b5>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 04             	mov    0x4(%eax),%eax
  802699:	a3 34 50 80 00       	mov    %eax,0x805034
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 0f                	je     8026b7 <alloc_block_FF+0x2ce>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	8b 12                	mov    (%edx),%edx
  8026b3:	89 10                	mov    %edx,(%eax)
  8026b5:	eb 0a                	jmp    8026c1 <alloc_block_FF+0x2d8>
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026d9:	48                   	dec    %eax
  8026da:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	6a 00                	push   $0x0
  8026e4:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026e7:	ff 75 b0             	pushl  -0x50(%ebp)
  8026ea:	e8 cb fc ff ff       	call   8023ba <set_block_data>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	e9 95 00 00 00       	jmp    80278c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	6a 01                	push   $0x1
  8026fc:	ff 75 b8             	pushl  -0x48(%ebp)
  8026ff:	ff 75 bc             	pushl  -0x44(%ebp)
  802702:	e8 b3 fc ff ff       	call   8023ba <set_block_data>
  802707:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270e:	75 17                	jne    802727 <alloc_block_FF+0x33e>
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 7f 45 80 00       	push   $0x80457f
  802718:	68 e8 00 00 00       	push   $0xe8
  80271d:	68 9d 45 80 00       	push   $0x80459d
  802722:	e8 db 13 00 00       	call   803b02 <_panic>
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 10                	je     802740 <alloc_block_FF+0x357>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802738:	8b 52 04             	mov    0x4(%edx),%edx
  80273b:	89 50 04             	mov    %edx,0x4(%eax)
  80273e:	eb 0b                	jmp    80274b <alloc_block_FF+0x362>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 40 04             	mov    0x4(%eax),%eax
  802746:	a3 34 50 80 00       	mov    %eax,0x805034
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	74 0f                	je     802764 <alloc_block_FF+0x37b>
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 04             	mov    0x4(%eax),%eax
  80275b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275e:	8b 12                	mov    (%edx),%edx
  802760:	89 10                	mov    %edx,(%eax)
  802762:	eb 0a                	jmp    80276e <alloc_block_FF+0x385>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	a3 30 50 80 00       	mov    %eax,0x805030
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802781:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802786:	48                   	dec    %eax
  802787:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  80278c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80278f:	e9 0f 01 00 00       	jmp    8028a3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802794:	a1 38 50 80 00       	mov    0x805038,%eax
  802799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a0:	74 07                	je     8027a9 <alloc_block_FF+0x3c0>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	eb 05                	jmp    8027ae <alloc_block_FF+0x3c5>
  8027a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ae:	a3 38 50 80 00       	mov    %eax,0x805038
  8027b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	0f 85 e9 fc ff ff    	jne    8024a9 <alloc_block_FF+0xc0>
  8027c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c4:	0f 85 df fc ff ff    	jne    8024a9 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	83 c0 08             	add    $0x8,%eax
  8027d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027d3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	48                   	dec    %eax
  8027e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ee:	f7 75 d8             	divl   -0x28(%ebp)
  8027f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027f4:	29 d0                	sub    %edx,%eax
  8027f6:	c1 e8 0c             	shr    $0xc,%eax
  8027f9:	83 ec 0c             	sub    $0xc,%esp
  8027fc:	50                   	push   %eax
  8027fd:	e8 1e ec ff ff       	call   801420 <sbrk>
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802808:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80280c:	75 0a                	jne    802818 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
  802813:	e9 8b 00 00 00       	jmp    8028a3 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802818:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80281f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802822:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802825:	01 d0                	add    %edx,%eax
  802827:	48                   	dec    %eax
  802828:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80282b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80282e:	ba 00 00 00 00       	mov    $0x0,%edx
  802833:	f7 75 cc             	divl   -0x34(%ebp)
  802836:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802839:	29 d0                	sub    %edx,%eax
  80283b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80283e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802841:	01 d0                	add    %edx,%eax
  802843:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802848:	a1 44 50 80 00       	mov    0x805044,%eax
  80284d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802853:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80285a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80285d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802860:	01 d0                	add    %edx,%eax
  802862:	48                   	dec    %eax
  802863:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802866:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802869:	ba 00 00 00 00       	mov    $0x0,%edx
  80286e:	f7 75 c4             	divl   -0x3c(%ebp)
  802871:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802874:	29 d0                	sub    %edx,%eax
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	6a 01                	push   $0x1
  80287b:	50                   	push   %eax
  80287c:	ff 75 d0             	pushl  -0x30(%ebp)
  80287f:	e8 36 fb ff ff       	call   8023ba <set_block_data>
  802884:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802887:	83 ec 0c             	sub    $0xc,%esp
  80288a:	ff 75 d0             	pushl  -0x30(%ebp)
  80288d:	e8 1b 0a 00 00       	call   8032ad <free_block>
  802892:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802895:	83 ec 0c             	sub    $0xc,%esp
  802898:	ff 75 08             	pushl  0x8(%ebp)
  80289b:	e8 49 fb ff ff       	call   8023e9 <alloc_block_FF>
  8028a0:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	83 e0 01             	and    $0x1,%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 03                	je     8028b8 <alloc_block_BF+0x13>
  8028b5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028b8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028bc:	77 07                	ja     8028c5 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028be:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028c5:	a1 28 50 80 00       	mov    0x805028,%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	75 73                	jne    802941 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	83 c0 10             	add    $0x10,%eax
  8028d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028d7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e4:	01 d0                	add    %edx,%eax
  8028e6:	48                   	dec    %eax
  8028e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f2:	f7 75 e0             	divl   -0x20(%ebp)
  8028f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028f8:	29 d0                	sub    %edx,%eax
  8028fa:	c1 e8 0c             	shr    $0xc,%eax
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	50                   	push   %eax
  802901:	e8 1a eb ff ff       	call   801420 <sbrk>
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80290c:	83 ec 0c             	sub    $0xc,%esp
  80290f:	6a 00                	push   $0x0
  802911:	e8 0a eb ff ff       	call   801420 <sbrk>
  802916:	83 c4 10             	add    $0x10,%esp
  802919:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80291c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80291f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802922:	83 ec 08             	sub    $0x8,%esp
  802925:	50                   	push   %eax
  802926:	ff 75 d8             	pushl  -0x28(%ebp)
  802929:	e8 9f f8 ff ff       	call   8021cd <initialize_dynamic_allocator>
  80292e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802931:	83 ec 0c             	sub    $0xc,%esp
  802934:	68 db 45 80 00       	push   $0x8045db
  802939:	e8 48 dd ff ff       	call   800686 <cprintf>
  80293e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80294f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802956:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80295d:	a1 30 50 80 00       	mov    0x805030,%eax
  802962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802965:	e9 1d 01 00 00       	jmp    802a87 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802970:	83 ec 0c             	sub    $0xc,%esp
  802973:	ff 75 a8             	pushl  -0x58(%ebp)
  802976:	e8 ee f6 ff ff       	call   802069 <get_block_size>
  80297b:	83 c4 10             	add    $0x10,%esp
  80297e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	83 c0 08             	add    $0x8,%eax
  802987:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80298a:	0f 87 ef 00 00 00    	ja     802a7f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	83 c0 18             	add    $0x18,%eax
  802996:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802999:	77 1d                	ja     8029b8 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80299b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a1:	0f 86 d8 00 00 00    	jbe    802a7f <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029ad:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029b3:	e9 c7 00 00 00       	jmp    802a7f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	83 c0 08             	add    $0x8,%eax
  8029be:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c1:	0f 85 9d 00 00 00    	jne    802a64 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	6a 01                	push   $0x1
  8029cc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029cf:	ff 75 a8             	pushl  -0x58(%ebp)
  8029d2:	e8 e3 f9 ff ff       	call   8023ba <set_block_data>
  8029d7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029de:	75 17                	jne    8029f7 <alloc_block_BF+0x152>
  8029e0:	83 ec 04             	sub    $0x4,%esp
  8029e3:	68 7f 45 80 00       	push   $0x80457f
  8029e8:	68 2c 01 00 00       	push   $0x12c
  8029ed:	68 9d 45 80 00       	push   $0x80459d
  8029f2:	e8 0b 11 00 00       	call   803b02 <_panic>
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	74 10                	je     802a10 <alloc_block_BF+0x16b>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a08:	8b 52 04             	mov    0x4(%edx),%edx
  802a0b:	89 50 04             	mov    %edx,0x4(%eax)
  802a0e:	eb 0b                	jmp    802a1b <alloc_block_BF+0x176>
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	a3 34 50 80 00       	mov    %eax,0x805034
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 0f                	je     802a34 <alloc_block_BF+0x18f>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2e:	8b 12                	mov    (%edx),%edx
  802a30:	89 10                	mov    %edx,(%eax)
  802a32:	eb 0a                	jmp    802a3e <alloc_block_BF+0x199>
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a51:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a56:	48                   	dec    %eax
  802a57:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802a5c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a5f:	e9 24 04 00 00       	jmp    802e88 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a67:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a6a:	76 13                	jbe    802a7f <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a6c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a73:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a79:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a7f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8b:	74 07                	je     802a94 <alloc_block_BF+0x1ef>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	eb 05                	jmp    802a99 <alloc_block_BF+0x1f4>
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	a3 38 50 80 00       	mov    %eax,0x805038
  802a9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	0f 85 bf fe ff ff    	jne    80296a <alloc_block_BF+0xc5>
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	0f 85 b5 fe ff ff    	jne    80296a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ab5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab9:	0f 84 26 02 00 00    	je     802ce5 <alloc_block_BF+0x440>
  802abf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ac3:	0f 85 1c 02 00 00    	jne    802ce5 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acc:	2b 45 08             	sub    0x8(%ebp),%eax
  802acf:	83 e8 08             	sub    $0x8,%eax
  802ad2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8d 50 08             	lea    0x8(%eax),%edx
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	01 d0                	add    %edx,%eax
  802ae0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	83 c0 08             	add    $0x8,%eax
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	6a 01                	push   $0x1
  802aee:	50                   	push   %eax
  802aef:	ff 75 f0             	pushl  -0x10(%ebp)
  802af2:	e8 c3 f8 ff ff       	call   8023ba <set_block_data>
  802af7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	75 68                	jne    802b6c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b04:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_BF+0x27c>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 b8 45 80 00       	push   $0x8045b8
  802b12:	68 45 01 00 00       	push   $0x145
  802b17:	68 9d 45 80 00       	push   $0x80459d
  802b1c:	e8 e1 0f 00 00       	call   803b02 <_panic>
  802b21:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2a:	89 10                	mov    %edx,(%eax)
  802b2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0d                	je     802b42 <alloc_block_BF+0x29d>
  802b35:	a1 30 50 80 00       	mov    0x805030,%eax
  802b3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	eb 08                	jmp    802b4a <alloc_block_BF+0x2a5>
  802b42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b45:	a3 34 50 80 00       	mov    %eax,0x805034
  802b4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b61:	40                   	inc    %eax
  802b62:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b67:	e9 dc 00 00 00       	jmp    802c48 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	75 65                	jne    802bda <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b75:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b79:	75 17                	jne    802b92 <alloc_block_BF+0x2ed>
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 ec 45 80 00       	push   $0x8045ec
  802b83:	68 4a 01 00 00       	push   $0x14a
  802b88:	68 9d 45 80 00       	push   $0x80459d
  802b8d:	e8 70 0f 00 00       	call   803b02 <_panic>
  802b92:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0c                	je     802bb4 <alloc_block_BF+0x30f>
  802ba8:	a1 34 50 80 00       	mov    0x805034,%eax
  802bad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	eb 08                	jmp    802bbc <alloc_block_BF+0x317>
  802bb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bbf:	a3 34 50 80 00       	mov    %eax,0x805034
  802bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bd2:	40                   	inc    %eax
  802bd3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bd8:	eb 6e                	jmp    802c48 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bde:	74 06                	je     802be6 <alloc_block_BF+0x341>
  802be0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802be4:	75 17                	jne    802bfd <alloc_block_BF+0x358>
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	68 10 46 80 00       	push   $0x804610
  802bee:	68 4f 01 00 00       	push   $0x14f
  802bf3:	68 9d 45 80 00       	push   $0x80459d
  802bf8:	e8 05 0f 00 00       	call   803b02 <_panic>
  802bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c00:	8b 10                	mov    (%eax),%edx
  802c02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0b                	je     802c1b <alloc_block_BF+0x376>
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c29:	89 50 04             	mov    %edx,0x4(%eax)
  802c2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	75 08                	jne    802c3d <alloc_block_BF+0x398>
  802c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c38:	a3 34 50 80 00       	mov    %eax,0x805034
  802c3d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c42:	40                   	inc    %eax
  802c43:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4c:	75 17                	jne    802c65 <alloc_block_BF+0x3c0>
  802c4e:	83 ec 04             	sub    $0x4,%esp
  802c51:	68 7f 45 80 00       	push   $0x80457f
  802c56:	68 51 01 00 00       	push   $0x151
  802c5b:	68 9d 45 80 00       	push   $0x80459d
  802c60:	e8 9d 0e 00 00       	call   803b02 <_panic>
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	74 10                	je     802c7e <alloc_block_BF+0x3d9>
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c76:	8b 52 04             	mov    0x4(%edx),%edx
  802c79:	89 50 04             	mov    %edx,0x4(%eax)
  802c7c:	eb 0b                	jmp    802c89 <alloc_block_BF+0x3e4>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	a3 34 50 80 00       	mov    %eax,0x805034
  802c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 0f                	je     802ca2 <alloc_block_BF+0x3fd>
  802c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9c:	8b 12                	mov    (%edx),%edx
  802c9e:	89 10                	mov    %edx,(%eax)
  802ca0:	eb 0a                	jmp    802cac <alloc_block_BF+0x407>
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	a3 30 50 80 00       	mov    %eax,0x805030
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cc4:	48                   	dec    %eax
  802cc5:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802cca:	83 ec 04             	sub    $0x4,%esp
  802ccd:	6a 00                	push   $0x0
  802ccf:	ff 75 d0             	pushl  -0x30(%ebp)
  802cd2:	ff 75 cc             	pushl  -0x34(%ebp)
  802cd5:	e8 e0 f6 ff ff       	call   8023ba <set_block_data>
  802cda:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	e9 a3 01 00 00       	jmp    802e88 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ce5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ce9:	0f 85 9d 00 00 00    	jne    802d8c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	6a 01                	push   $0x1
  802cf4:	ff 75 ec             	pushl  -0x14(%ebp)
  802cf7:	ff 75 f0             	pushl  -0x10(%ebp)
  802cfa:	e8 bb f6 ff ff       	call   8023ba <set_block_data>
  802cff:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d06:	75 17                	jne    802d1f <alloc_block_BF+0x47a>
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	68 7f 45 80 00       	push   $0x80457f
  802d10:	68 58 01 00 00       	push   $0x158
  802d15:	68 9d 45 80 00       	push   $0x80459d
  802d1a:	e8 e3 0d 00 00       	call   803b02 <_panic>
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	74 10                	je     802d38 <alloc_block_BF+0x493>
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d30:	8b 52 04             	mov    0x4(%edx),%edx
  802d33:	89 50 04             	mov    %edx,0x4(%eax)
  802d36:	eb 0b                	jmp    802d43 <alloc_block_BF+0x49e>
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	a3 34 50 80 00       	mov    %eax,0x805034
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 0f                	je     802d5c <alloc_block_BF+0x4b7>
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d56:	8b 12                	mov    (%edx),%edx
  802d58:	89 10                	mov    %edx,(%eax)
  802d5a:	eb 0a                	jmp    802d66 <alloc_block_BF+0x4c1>
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	a3 30 50 80 00       	mov    %eax,0x805030
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d7e:	48                   	dec    %eax
  802d7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	e9 fc 00 00 00       	jmp    802e88 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	83 c0 08             	add    $0x8,%eax
  802d92:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d95:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d9c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d9f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802da2:	01 d0                	add    %edx,%eax
  802da4:	48                   	dec    %eax
  802da5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802da8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dab:	ba 00 00 00 00       	mov    $0x0,%edx
  802db0:	f7 75 c4             	divl   -0x3c(%ebp)
  802db3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802db6:	29 d0                	sub    %edx,%eax
  802db8:	c1 e8 0c             	shr    $0xc,%eax
  802dbb:	83 ec 0c             	sub    $0xc,%esp
  802dbe:	50                   	push   %eax
  802dbf:	e8 5c e6 ff ff       	call   801420 <sbrk>
  802dc4:	83 c4 10             	add    $0x10,%esp
  802dc7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802dca:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802dce:	75 0a                	jne    802dda <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd5:	e9 ae 00 00 00       	jmp    802e88 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802dda:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802de1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802de4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802de7:	01 d0                	add    %edx,%eax
  802de9:	48                   	dec    %eax
  802dea:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ded:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802df0:	ba 00 00 00 00       	mov    $0x0,%edx
  802df5:	f7 75 b8             	divl   -0x48(%ebp)
  802df8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dfb:	29 d0                	sub    %edx,%eax
  802dfd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e00:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e03:	01 d0                	add    %edx,%eax
  802e05:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802e0a:	a1 44 50 80 00       	mov    0x805044,%eax
  802e0f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e15:	83 ec 0c             	sub    $0xc,%esp
  802e18:	68 44 46 80 00       	push   $0x804644
  802e1d:	e8 64 d8 ff ff       	call   800686 <cprintf>
  802e22:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e25:	83 ec 08             	sub    $0x8,%esp
  802e28:	ff 75 bc             	pushl  -0x44(%ebp)
  802e2b:	68 49 46 80 00       	push   $0x804649
  802e30:	e8 51 d8 ff ff       	call   800686 <cprintf>
  802e35:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e38:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e3f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e42:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e45:	01 d0                	add    %edx,%eax
  802e47:	48                   	dec    %eax
  802e48:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e4b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e53:	f7 75 b0             	divl   -0x50(%ebp)
  802e56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e59:	29 d0                	sub    %edx,%eax
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	6a 01                	push   $0x1
  802e60:	50                   	push   %eax
  802e61:	ff 75 bc             	pushl  -0x44(%ebp)
  802e64:	e8 51 f5 ff ff       	call   8023ba <set_block_data>
  802e69:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e6c:	83 ec 0c             	sub    $0xc,%esp
  802e6f:	ff 75 bc             	pushl  -0x44(%ebp)
  802e72:	e8 36 04 00 00       	call   8032ad <free_block>
  802e77:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e7a:	83 ec 0c             	sub    $0xc,%esp
  802e7d:	ff 75 08             	pushl  0x8(%ebp)
  802e80:	e8 20 fa ff ff       	call   8028a5 <alloc_block_BF>
  802e85:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e88:	c9                   	leave  
  802e89:	c3                   	ret    

00802e8a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e8a:	55                   	push   %ebp
  802e8b:	89 e5                	mov    %esp,%ebp
  802e8d:	53                   	push   %ebx
  802e8e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea3:	74 1e                	je     802ec3 <merging+0x39>
  802ea5:	ff 75 08             	pushl  0x8(%ebp)
  802ea8:	e8 bc f1 ff ff       	call   802069 <get_block_size>
  802ead:	83 c4 04             	add    $0x4,%esp
  802eb0:	89 c2                	mov    %eax,%edx
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	01 d0                	add    %edx,%eax
  802eb7:	3b 45 10             	cmp    0x10(%ebp),%eax
  802eba:	75 07                	jne    802ec3 <merging+0x39>
		prev_is_free = 1;
  802ebc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec7:	74 1e                	je     802ee7 <merging+0x5d>
  802ec9:	ff 75 10             	pushl  0x10(%ebp)
  802ecc:	e8 98 f1 ff ff       	call   802069 <get_block_size>
  802ed1:	83 c4 04             	add    $0x4,%esp
  802ed4:	89 c2                	mov    %eax,%edx
  802ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed9:	01 d0                	add    %edx,%eax
  802edb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ede:	75 07                	jne    802ee7 <merging+0x5d>
		next_is_free = 1;
  802ee0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eeb:	0f 84 cc 00 00 00    	je     802fbd <merging+0x133>
  802ef1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef5:	0f 84 c2 00 00 00    	je     802fbd <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802efb:	ff 75 08             	pushl  0x8(%ebp)
  802efe:	e8 66 f1 ff ff       	call   802069 <get_block_size>
  802f03:	83 c4 04             	add    $0x4,%esp
  802f06:	89 c3                	mov    %eax,%ebx
  802f08:	ff 75 10             	pushl  0x10(%ebp)
  802f0b:	e8 59 f1 ff ff       	call   802069 <get_block_size>
  802f10:	83 c4 04             	add    $0x4,%esp
  802f13:	01 c3                	add    %eax,%ebx
  802f15:	ff 75 0c             	pushl  0xc(%ebp)
  802f18:	e8 4c f1 ff ff       	call   802069 <get_block_size>
  802f1d:	83 c4 04             	add    $0x4,%esp
  802f20:	01 d8                	add    %ebx,%eax
  802f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f25:	6a 00                	push   $0x0
  802f27:	ff 75 ec             	pushl  -0x14(%ebp)
  802f2a:	ff 75 08             	pushl  0x8(%ebp)
  802f2d:	e8 88 f4 ff ff       	call   8023ba <set_block_data>
  802f32:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f39:	75 17                	jne    802f52 <merging+0xc8>
  802f3b:	83 ec 04             	sub    $0x4,%esp
  802f3e:	68 7f 45 80 00       	push   $0x80457f
  802f43:	68 7d 01 00 00       	push   $0x17d
  802f48:	68 9d 45 80 00       	push   $0x80459d
  802f4d:	e8 b0 0b 00 00       	call   803b02 <_panic>
  802f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 10                	je     802f6b <merging+0xe1>
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f63:	8b 52 04             	mov    0x4(%edx),%edx
  802f66:	89 50 04             	mov    %edx,0x4(%eax)
  802f69:	eb 0b                	jmp    802f76 <merging+0xec>
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	8b 40 04             	mov    0x4(%eax),%eax
  802f71:	a3 34 50 80 00       	mov    %eax,0x805034
  802f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f79:	8b 40 04             	mov    0x4(%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	74 0f                	je     802f8f <merging+0x105>
  802f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f89:	8b 12                	mov    (%edx),%edx
  802f8b:	89 10                	mov    %edx,(%eax)
  802f8d:	eb 0a                	jmp    802f99 <merging+0x10f>
  802f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	a3 30 50 80 00       	mov    %eax,0x805030
  802f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fac:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fb1:	48                   	dec    %eax
  802fb2:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fb7:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fb8:	e9 ea 02 00 00       	jmp    8032a7 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc1:	74 3b                	je     802ffe <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fc3:	83 ec 0c             	sub    $0xc,%esp
  802fc6:	ff 75 08             	pushl  0x8(%ebp)
  802fc9:	e8 9b f0 ff ff       	call   802069 <get_block_size>
  802fce:	83 c4 10             	add    $0x10,%esp
  802fd1:	89 c3                	mov    %eax,%ebx
  802fd3:	83 ec 0c             	sub    $0xc,%esp
  802fd6:	ff 75 10             	pushl  0x10(%ebp)
  802fd9:	e8 8b f0 ff ff       	call   802069 <get_block_size>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	01 d8                	add    %ebx,%eax
  802fe3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fe6:	83 ec 04             	sub    $0x4,%esp
  802fe9:	6a 00                	push   $0x0
  802feb:	ff 75 e8             	pushl  -0x18(%ebp)
  802fee:	ff 75 08             	pushl  0x8(%ebp)
  802ff1:	e8 c4 f3 ff ff       	call   8023ba <set_block_data>
  802ff6:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ff9:	e9 a9 02 00 00       	jmp    8032a7 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803002:	0f 84 2d 01 00 00    	je     803135 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803008:	83 ec 0c             	sub    $0xc,%esp
  80300b:	ff 75 10             	pushl  0x10(%ebp)
  80300e:	e8 56 f0 ff ff       	call   802069 <get_block_size>
  803013:	83 c4 10             	add    $0x10,%esp
  803016:	89 c3                	mov    %eax,%ebx
  803018:	83 ec 0c             	sub    $0xc,%esp
  80301b:	ff 75 0c             	pushl  0xc(%ebp)
  80301e:	e8 46 f0 ff ff       	call   802069 <get_block_size>
  803023:	83 c4 10             	add    $0x10,%esp
  803026:	01 d8                	add    %ebx,%eax
  803028:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	6a 00                	push   $0x0
  803030:	ff 75 e4             	pushl  -0x1c(%ebp)
  803033:	ff 75 10             	pushl  0x10(%ebp)
  803036:	e8 7f f3 ff ff       	call   8023ba <set_block_data>
  80303b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80303e:	8b 45 10             	mov    0x10(%ebp),%eax
  803041:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803044:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803048:	74 06                	je     803050 <merging+0x1c6>
  80304a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80304e:	75 17                	jne    803067 <merging+0x1dd>
  803050:	83 ec 04             	sub    $0x4,%esp
  803053:	68 58 46 80 00       	push   $0x804658
  803058:	68 8d 01 00 00       	push   $0x18d
  80305d:	68 9d 45 80 00       	push   $0x80459d
  803062:	e8 9b 0a 00 00       	call   803b02 <_panic>
  803067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306a:	8b 50 04             	mov    0x4(%eax),%edx
  80306d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803076:	8b 55 0c             	mov    0xc(%ebp),%edx
  803079:	89 10                	mov    %edx,(%eax)
  80307b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	74 0d                	je     803092 <merging+0x208>
  803085:	8b 45 0c             	mov    0xc(%ebp),%eax
  803088:	8b 40 04             	mov    0x4(%eax),%eax
  80308b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80308e:	89 10                	mov    %edx,(%eax)
  803090:	eb 08                	jmp    80309a <merging+0x210>
  803092:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803095:	a3 30 50 80 00       	mov    %eax,0x805030
  80309a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030a0:	89 50 04             	mov    %edx,0x4(%eax)
  8030a3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030a8:	40                   	inc    %eax
  8030a9:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8030ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b2:	75 17                	jne    8030cb <merging+0x241>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 7f 45 80 00       	push   $0x80457f
  8030bc:	68 8e 01 00 00       	push   $0x18e
  8030c1:	68 9d 45 80 00       	push   $0x80459d
  8030c6:	e8 37 0a 00 00       	call   803b02 <_panic>
  8030cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 10                	je     8030e4 <merging+0x25a>
  8030d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030dc:	8b 52 04             	mov    0x4(%edx),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 0b                	jmp    8030ef <merging+0x265>
  8030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8030ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0f                	je     803108 <merging+0x27e>
  8030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803102:	8b 12                	mov    (%edx),%edx
  803104:	89 10                	mov    %edx,(%eax)
  803106:	eb 0a                	jmp    803112 <merging+0x288>
  803108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	a3 30 50 80 00       	mov    %eax,0x805030
  803112:	8b 45 0c             	mov    0xc(%ebp),%eax
  803115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80312a:	48                   	dec    %eax
  80312b:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803130:	e9 72 01 00 00       	jmp    8032a7 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803135:	8b 45 10             	mov    0x10(%ebp),%eax
  803138:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80313b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313f:	74 79                	je     8031ba <merging+0x330>
  803141:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803145:	74 73                	je     8031ba <merging+0x330>
  803147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314b:	74 06                	je     803153 <merging+0x2c9>
  80314d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803151:	75 17                	jne    80316a <merging+0x2e0>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 10 46 80 00       	push   $0x804610
  80315b:	68 94 01 00 00       	push   $0x194
  803160:	68 9d 45 80 00       	push   $0x80459d
  803165:	e8 98 09 00 00       	call   803b02 <_panic>
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 10                	mov    (%eax),%edx
  80316f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803172:	89 10                	mov    %edx,(%eax)
  803174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	85 c0                	test   %eax,%eax
  80317b:	74 0b                	je     803188 <merging+0x2fe>
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803185:	89 50 04             	mov    %edx,0x4(%eax)
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803193:	8b 55 08             	mov    0x8(%ebp),%edx
  803196:	89 50 04             	mov    %edx,0x4(%eax)
  803199:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	75 08                	jne    8031aa <merging+0x320>
  8031a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8031aa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031af:	40                   	inc    %eax
  8031b0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031b5:	e9 ce 00 00 00       	jmp    803288 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031be:	74 65                	je     803225 <merging+0x39b>
  8031c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031c4:	75 17                	jne    8031dd <merging+0x353>
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	68 ec 45 80 00       	push   $0x8045ec
  8031ce:	68 95 01 00 00       	push   $0x195
  8031d3:	68 9d 45 80 00       	push   $0x80459d
  8031d8:	e8 25 09 00 00       	call   803b02 <_panic>
  8031dd:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8031e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	74 0c                	je     8031ff <merging+0x375>
  8031f3:	a1 34 50 80 00       	mov    0x805034,%eax
  8031f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	eb 08                	jmp    803207 <merging+0x37d>
  8031ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803202:	a3 30 50 80 00       	mov    %eax,0x805030
  803207:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320a:	a3 34 50 80 00       	mov    %eax,0x805034
  80320f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803218:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80321d:	40                   	inc    %eax
  80321e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803223:	eb 63                	jmp    803288 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803225:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803229:	75 17                	jne    803242 <merging+0x3b8>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 b8 45 80 00       	push   $0x8045b8
  803233:	68 98 01 00 00       	push   $0x198
  803238:	68 9d 45 80 00       	push   $0x80459d
  80323d:	e8 c0 08 00 00       	call   803b02 <_panic>
  803242:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803248:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0d                	je     803263 <merging+0x3d9>
  803256:	a1 30 50 80 00       	mov    0x805030,%eax
  80325b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 08                	jmp    80326b <merging+0x3e1>
  803263:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803266:	a3 34 50 80 00       	mov    %eax,0x805034
  80326b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326e:	a3 30 50 80 00       	mov    %eax,0x805030
  803273:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803282:	40                   	inc    %eax
  803283:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803288:	83 ec 0c             	sub    $0xc,%esp
  80328b:	ff 75 10             	pushl  0x10(%ebp)
  80328e:	e8 d6 ed ff ff       	call   802069 <get_block_size>
  803293:	83 c4 10             	add    $0x10,%esp
  803296:	83 ec 04             	sub    $0x4,%esp
  803299:	6a 00                	push   $0x0
  80329b:	50                   	push   %eax
  80329c:	ff 75 10             	pushl  0x10(%ebp)
  80329f:	e8 16 f1 ff ff       	call   8023ba <set_block_data>
  8032a4:	83 c4 10             	add    $0x10,%esp
	}
}
  8032a7:	90                   	nop
  8032a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032ab:	c9                   	leave  
  8032ac:	c3                   	ret    

008032ad <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
  8032b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032b3:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032bb:	a1 34 50 80 00       	mov    0x805034,%eax
  8032c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c3:	73 1b                	jae    8032e0 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8032ca:	83 ec 04             	sub    $0x4,%esp
  8032cd:	ff 75 08             	pushl  0x8(%ebp)
  8032d0:	6a 00                	push   $0x0
  8032d2:	50                   	push   %eax
  8032d3:	e8 b2 fb ff ff       	call   802e8a <merging>
  8032d8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032db:	e9 8b 00 00 00       	jmp    80336b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032e0:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e8:	76 18                	jbe    803302 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032ea:	a1 30 50 80 00       	mov    0x805030,%eax
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	ff 75 08             	pushl  0x8(%ebp)
  8032f5:	50                   	push   %eax
  8032f6:	6a 00                	push   $0x0
  8032f8:	e8 8d fb ff ff       	call   802e8a <merging>
  8032fd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803300:	eb 69                	jmp    80336b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803302:	a1 30 50 80 00       	mov    0x805030,%eax
  803307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80330a:	eb 39                	jmp    803345 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803312:	73 29                	jae    80333d <free_block+0x90>
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803317:	8b 00                	mov    (%eax),%eax
  803319:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331c:	76 1f                	jbe    80333d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	ff 75 08             	pushl  0x8(%ebp)
  80332c:	ff 75 f0             	pushl  -0x10(%ebp)
  80332f:	ff 75 f4             	pushl  -0xc(%ebp)
  803332:	e8 53 fb ff ff       	call   802e8a <merging>
  803337:	83 c4 10             	add    $0x10,%esp
			break;
  80333a:	90                   	nop
		}
	}
}
  80333b:	eb 2e                	jmp    80336b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80333d:	a1 38 50 80 00       	mov    0x805038,%eax
  803342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803349:	74 07                	je     803352 <free_block+0xa5>
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	eb 05                	jmp    803357 <free_block+0xaa>
  803352:	b8 00 00 00 00       	mov    $0x0,%eax
  803357:	a3 38 50 80 00       	mov    %eax,0x805038
  80335c:	a1 38 50 80 00       	mov    0x805038,%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	75 a7                	jne    80330c <free_block+0x5f>
  803365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803369:	75 a1                	jne    80330c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80336b:	90                   	nop
  80336c:	c9                   	leave  
  80336d:	c3                   	ret    

0080336e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80336e:	55                   	push   %ebp
  80336f:	89 e5                	mov    %esp,%ebp
  803371:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803374:	ff 75 08             	pushl  0x8(%ebp)
  803377:	e8 ed ec ff ff       	call   802069 <get_block_size>
  80337c:	83 c4 04             	add    $0x4,%esp
  80337f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803389:	eb 17                	jmp    8033a2 <copy_data+0x34>
  80338b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80338e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803391:	01 c2                	add    %eax,%edx
  803393:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	01 c8                	add    %ecx,%eax
  80339b:	8a 00                	mov    (%eax),%al
  80339d:	88 02                	mov    %al,(%edx)
  80339f:	ff 45 fc             	incl   -0x4(%ebp)
  8033a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033a8:	72 e1                	jb     80338b <copy_data+0x1d>
}
  8033aa:	90                   	nop
  8033ab:	c9                   	leave  
  8033ac:	c3                   	ret    

008033ad <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033ad:	55                   	push   %ebp
  8033ae:	89 e5                	mov    %esp,%ebp
  8033b0:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b7:	75 23                	jne    8033dc <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033bd:	74 13                	je     8033d2 <realloc_block_FF+0x25>
  8033bf:	83 ec 0c             	sub    $0xc,%esp
  8033c2:	ff 75 0c             	pushl  0xc(%ebp)
  8033c5:	e8 1f f0 ff ff       	call   8023e9 <alloc_block_FF>
  8033ca:	83 c4 10             	add    $0x10,%esp
  8033cd:	e9 f4 06 00 00       	jmp    803ac6 <realloc_block_FF+0x719>
		return NULL;
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	e9 ea 06 00 00       	jmp    803ac6 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8033dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e0:	75 18                	jne    8033fa <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033e2:	83 ec 0c             	sub    $0xc,%esp
  8033e5:	ff 75 08             	pushl  0x8(%ebp)
  8033e8:	e8 c0 fe ff ff       	call   8032ad <free_block>
  8033ed:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f5:	e9 cc 06 00 00       	jmp    803ac6 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8033fa:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033fe:	77 07                	ja     803407 <realloc_block_FF+0x5a>
  803400:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340a:	83 e0 01             	and    $0x1,%eax
  80340d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803410:	8b 45 0c             	mov    0xc(%ebp),%eax
  803413:	83 c0 08             	add    $0x8,%eax
  803416:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803419:	83 ec 0c             	sub    $0xc,%esp
  80341c:	ff 75 08             	pushl  0x8(%ebp)
  80341f:	e8 45 ec ff ff       	call   802069 <get_block_size>
  803424:	83 c4 10             	add    $0x10,%esp
  803427:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80342a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342d:	83 e8 08             	sub    $0x8,%eax
  803430:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	83 e8 04             	sub    $0x4,%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	83 e0 fe             	and    $0xfffffffe,%eax
  80343e:	89 c2                	mov    %eax,%edx
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	01 d0                	add    %edx,%eax
  803445:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803448:	83 ec 0c             	sub    $0xc,%esp
  80344b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80344e:	e8 16 ec ff ff       	call   802069 <get_block_size>
  803453:	83 c4 10             	add    $0x10,%esp
  803456:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803459:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345c:	83 e8 08             	sub    $0x8,%eax
  80345f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803462:	8b 45 0c             	mov    0xc(%ebp),%eax
  803465:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803468:	75 08                	jne    803472 <realloc_block_FF+0xc5>
	{
		 return va;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	e9 54 06 00 00       	jmp    803ac6 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803472:	8b 45 0c             	mov    0xc(%ebp),%eax
  803475:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803478:	0f 83 e5 03 00 00    	jae    803863 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	2b 45 0c             	sub    0xc(%ebp),%eax
  803484:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803487:	83 ec 0c             	sub    $0xc,%esp
  80348a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80348d:	e8 f0 eb ff ff       	call   802082 <is_free_block>
  803492:	83 c4 10             	add    $0x10,%esp
  803495:	84 c0                	test   %al,%al
  803497:	0f 84 3b 01 00 00    	je     8035d8 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80349d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034a3:	01 d0                	add    %edx,%eax
  8034a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034a8:	83 ec 04             	sub    $0x4,%esp
  8034ab:	6a 01                	push   $0x1
  8034ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8034b0:	ff 75 08             	pushl  0x8(%ebp)
  8034b3:	e8 02 ef ff ff       	call   8023ba <set_block_data>
  8034b8:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	83 e8 04             	sub    $0x4,%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8034c6:	89 c2                	mov    %eax,%edx
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	01 d0                	add    %edx,%eax
  8034cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034d0:	83 ec 04             	sub    $0x4,%esp
  8034d3:	6a 00                	push   $0x0
  8034d5:	ff 75 cc             	pushl  -0x34(%ebp)
  8034d8:	ff 75 c8             	pushl  -0x38(%ebp)
  8034db:	e8 da ee ff ff       	call   8023ba <set_block_data>
  8034e0:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034e7:	74 06                	je     8034ef <realloc_block_FF+0x142>
  8034e9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034ed:	75 17                	jne    803506 <realloc_block_FF+0x159>
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	68 10 46 80 00       	push   $0x804610
  8034f7:	68 f6 01 00 00       	push   $0x1f6
  8034fc:	68 9d 45 80 00       	push   $0x80459d
  803501:	e8 fc 05 00 00       	call   803b02 <_panic>
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	8b 10                	mov    (%eax),%edx
  80350b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80350e:	89 10                	mov    %edx,(%eax)
  803510:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 0b                	je     803524 <realloc_block_FF+0x177>
  803519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803527:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80352a:	89 10                	mov    %edx,(%eax)
  80352c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80352f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803532:	89 50 04             	mov    %edx,0x4(%eax)
  803535:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	75 08                	jne    803546 <realloc_block_FF+0x199>
  80353e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803541:	a3 34 50 80 00       	mov    %eax,0x805034
  803546:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80354b:	40                   	inc    %eax
  80354c:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803551:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803555:	75 17                	jne    80356e <realloc_block_FF+0x1c1>
  803557:	83 ec 04             	sub    $0x4,%esp
  80355a:	68 7f 45 80 00       	push   $0x80457f
  80355f:	68 f7 01 00 00       	push   $0x1f7
  803564:	68 9d 45 80 00       	push   $0x80459d
  803569:	e8 94 05 00 00       	call   803b02 <_panic>
  80356e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803571:	8b 00                	mov    (%eax),%eax
  803573:	85 c0                	test   %eax,%eax
  803575:	74 10                	je     803587 <realloc_block_FF+0x1da>
  803577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80357f:	8b 52 04             	mov    0x4(%edx),%edx
  803582:	89 50 04             	mov    %edx,0x4(%eax)
  803585:	eb 0b                	jmp    803592 <realloc_block_FF+0x1e5>
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 40 04             	mov    0x4(%eax),%eax
  80358d:	a3 34 50 80 00       	mov    %eax,0x805034
  803592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803595:	8b 40 04             	mov    0x4(%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 0f                	je     8035ab <realloc_block_FF+0x1fe>
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359f:	8b 40 04             	mov    0x4(%eax),%eax
  8035a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a5:	8b 12                	mov    (%edx),%edx
  8035a7:	89 10                	mov    %edx,(%eax)
  8035a9:	eb 0a                	jmp    8035b5 <realloc_block_FF+0x208>
  8035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035cd:	48                   	dec    %eax
  8035ce:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035d3:	e9 83 02 00 00       	jmp    80385b <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035d8:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035dc:	0f 86 69 02 00 00    	jbe    80384b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	6a 01                	push   $0x1
  8035e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8035ea:	ff 75 08             	pushl  0x8(%ebp)
  8035ed:	e8 c8 ed ff ff       	call   8023ba <set_block_data>
  8035f2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	83 e8 04             	sub    $0x4,%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	83 e0 fe             	and    $0xfffffffe,%eax
  803600:	89 c2                	mov    %eax,%edx
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	01 d0                	add    %edx,%eax
  803607:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80360a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80360f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803612:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803616:	75 68                	jne    803680 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803618:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80361c:	75 17                	jne    803635 <realloc_block_FF+0x288>
  80361e:	83 ec 04             	sub    $0x4,%esp
  803621:	68 b8 45 80 00       	push   $0x8045b8
  803626:	68 06 02 00 00       	push   $0x206
  80362b:	68 9d 45 80 00       	push   $0x80459d
  803630:	e8 cd 04 00 00       	call   803b02 <_panic>
  803635:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80363b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363e:	89 10                	mov    %edx,(%eax)
  803640:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803643:	8b 00                	mov    (%eax),%eax
  803645:	85 c0                	test   %eax,%eax
  803647:	74 0d                	je     803656 <realloc_block_FF+0x2a9>
  803649:	a1 30 50 80 00       	mov    0x805030,%eax
  80364e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803651:	89 50 04             	mov    %edx,0x4(%eax)
  803654:	eb 08                	jmp    80365e <realloc_block_FF+0x2b1>
  803656:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803659:	a3 34 50 80 00       	mov    %eax,0x805034
  80365e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803661:	a3 30 50 80 00       	mov    %eax,0x805030
  803666:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803670:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803675:	40                   	inc    %eax
  803676:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80367b:	e9 b0 01 00 00       	jmp    803830 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803680:	a1 30 50 80 00       	mov    0x805030,%eax
  803685:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803688:	76 68                	jbe    8036f2 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80368a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80368e:	75 17                	jne    8036a7 <realloc_block_FF+0x2fa>
  803690:	83 ec 04             	sub    $0x4,%esp
  803693:	68 b8 45 80 00       	push   $0x8045b8
  803698:	68 0b 02 00 00       	push   $0x20b
  80369d:	68 9d 45 80 00       	push   $0x80459d
  8036a2:	e8 5b 04 00 00       	call   803b02 <_panic>
  8036a7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b0:	89 10                	mov    %edx,(%eax)
  8036b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	74 0d                	je     8036c8 <realloc_block_FF+0x31b>
  8036bb:	a1 30 50 80 00       	mov    0x805030,%eax
  8036c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036c3:	89 50 04             	mov    %edx,0x4(%eax)
  8036c6:	eb 08                	jmp    8036d0 <realloc_block_FF+0x323>
  8036c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cb:	a3 34 50 80 00       	mov    %eax,0x805034
  8036d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8036d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036e7:	40                   	inc    %eax
  8036e8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036ed:	e9 3e 01 00 00       	jmp    803830 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8036f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036fa:	73 68                	jae    803764 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803700:	75 17                	jne    803719 <realloc_block_FF+0x36c>
  803702:	83 ec 04             	sub    $0x4,%esp
  803705:	68 ec 45 80 00       	push   $0x8045ec
  80370a:	68 10 02 00 00       	push   $0x210
  80370f:	68 9d 45 80 00       	push   $0x80459d
  803714:	e8 e9 03 00 00       	call   803b02 <_panic>
  803719:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80371f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803722:	89 50 04             	mov    %edx,0x4(%eax)
  803725:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	85 c0                	test   %eax,%eax
  80372d:	74 0c                	je     80373b <realloc_block_FF+0x38e>
  80372f:	a1 34 50 80 00       	mov    0x805034,%eax
  803734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803737:	89 10                	mov    %edx,(%eax)
  803739:	eb 08                	jmp    803743 <realloc_block_FF+0x396>
  80373b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373e:	a3 30 50 80 00       	mov    %eax,0x805030
  803743:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803746:	a3 34 50 80 00       	mov    %eax,0x805034
  80374b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803754:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803759:	40                   	inc    %eax
  80375a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80375f:	e9 cc 00 00 00       	jmp    803830 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80376b:	a1 30 50 80 00       	mov    0x805030,%eax
  803770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803773:	e9 8a 00 00 00       	jmp    803802 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80377e:	73 7a                	jae    8037fa <realloc_block_FF+0x44d>
  803780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803788:	73 70                	jae    8037fa <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80378a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378e:	74 06                	je     803796 <realloc_block_FF+0x3e9>
  803790:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803794:	75 17                	jne    8037ad <realloc_block_FF+0x400>
  803796:	83 ec 04             	sub    $0x4,%esp
  803799:	68 10 46 80 00       	push   $0x804610
  80379e:	68 1a 02 00 00       	push   $0x21a
  8037a3:	68 9d 45 80 00       	push   $0x80459d
  8037a8:	e8 55 03 00 00       	call   803b02 <_panic>
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	8b 10                	mov    (%eax),%edx
  8037b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b5:	89 10                	mov    %edx,(%eax)
  8037b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ba:	8b 00                	mov    (%eax),%eax
  8037bc:	85 c0                	test   %eax,%eax
  8037be:	74 0b                	je     8037cb <realloc_block_FF+0x41e>
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	8b 00                	mov    (%eax),%eax
  8037c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037c8:	89 50 04             	mov    %edx,0x4(%eax)
  8037cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037d1:	89 10                	mov    %edx,(%eax)
  8037d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037d9:	89 50 04             	mov    %edx,0x4(%eax)
  8037dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	85 c0                	test   %eax,%eax
  8037e3:	75 08                	jne    8037ed <realloc_block_FF+0x440>
  8037e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e8:	a3 34 50 80 00       	mov    %eax,0x805034
  8037ed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037f2:	40                   	inc    %eax
  8037f3:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8037f8:	eb 36                	jmp    803830 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803806:	74 07                	je     80380f <realloc_block_FF+0x462>
  803808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380b:	8b 00                	mov    (%eax),%eax
  80380d:	eb 05                	jmp    803814 <realloc_block_FF+0x467>
  80380f:	b8 00 00 00 00       	mov    $0x0,%eax
  803814:	a3 38 50 80 00       	mov    %eax,0x805038
  803819:	a1 38 50 80 00       	mov    0x805038,%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	0f 85 52 ff ff ff    	jne    803778 <realloc_block_FF+0x3cb>
  803826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382a:	0f 85 48 ff ff ff    	jne    803778 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803830:	83 ec 04             	sub    $0x4,%esp
  803833:	6a 00                	push   $0x0
  803835:	ff 75 d8             	pushl  -0x28(%ebp)
  803838:	ff 75 d4             	pushl  -0x2c(%ebp)
  80383b:	e8 7a eb ff ff       	call   8023ba <set_block_data>
  803840:	83 c4 10             	add    $0x10,%esp
				return va;
  803843:	8b 45 08             	mov    0x8(%ebp),%eax
  803846:	e9 7b 02 00 00       	jmp    803ac6 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80384b:	83 ec 0c             	sub    $0xc,%esp
  80384e:	68 8d 46 80 00       	push   $0x80468d
  803853:	e8 2e ce ff ff       	call   800686 <cprintf>
  803858:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	e9 63 02 00 00       	jmp    803ac6 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803863:	8b 45 0c             	mov    0xc(%ebp),%eax
  803866:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803869:	0f 86 4d 02 00 00    	jbe    803abc <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80386f:	83 ec 0c             	sub    $0xc,%esp
  803872:	ff 75 e4             	pushl  -0x1c(%ebp)
  803875:	e8 08 e8 ff ff       	call   802082 <is_free_block>
  80387a:	83 c4 10             	add    $0x10,%esp
  80387d:	84 c0                	test   %al,%al
  80387f:	0f 84 37 02 00 00    	je     803abc <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803885:	8b 45 0c             	mov    0xc(%ebp),%eax
  803888:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80388b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80388e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803891:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803894:	76 38                	jbe    8038ce <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803896:	83 ec 0c             	sub    $0xc,%esp
  803899:	ff 75 08             	pushl  0x8(%ebp)
  80389c:	e8 0c fa ff ff       	call   8032ad <free_block>
  8038a1:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038a4:	83 ec 0c             	sub    $0xc,%esp
  8038a7:	ff 75 0c             	pushl  0xc(%ebp)
  8038aa:	e8 3a eb ff ff       	call   8023e9 <alloc_block_FF>
  8038af:	83 c4 10             	add    $0x10,%esp
  8038b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038b5:	83 ec 08             	sub    $0x8,%esp
  8038b8:	ff 75 c0             	pushl  -0x40(%ebp)
  8038bb:	ff 75 08             	pushl  0x8(%ebp)
  8038be:	e8 ab fa ff ff       	call   80336e <copy_data>
  8038c3:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038c6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038c9:	e9 f8 01 00 00       	jmp    803ac6 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038d7:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038db:	0f 87 a0 00 00 00    	ja     803981 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038e5:	75 17                	jne    8038fe <realloc_block_FF+0x551>
  8038e7:	83 ec 04             	sub    $0x4,%esp
  8038ea:	68 7f 45 80 00       	push   $0x80457f
  8038ef:	68 38 02 00 00       	push   $0x238
  8038f4:	68 9d 45 80 00       	push   $0x80459d
  8038f9:	e8 04 02 00 00       	call   803b02 <_panic>
  8038fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803901:	8b 00                	mov    (%eax),%eax
  803903:	85 c0                	test   %eax,%eax
  803905:	74 10                	je     803917 <realloc_block_FF+0x56a>
  803907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390f:	8b 52 04             	mov    0x4(%edx),%edx
  803912:	89 50 04             	mov    %edx,0x4(%eax)
  803915:	eb 0b                	jmp    803922 <realloc_block_FF+0x575>
  803917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391a:	8b 40 04             	mov    0x4(%eax),%eax
  80391d:	a3 34 50 80 00       	mov    %eax,0x805034
  803922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803925:	8b 40 04             	mov    0x4(%eax),%eax
  803928:	85 c0                	test   %eax,%eax
  80392a:	74 0f                	je     80393b <realloc_block_FF+0x58e>
  80392c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392f:	8b 40 04             	mov    0x4(%eax),%eax
  803932:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803935:	8b 12                	mov    (%edx),%edx
  803937:	89 10                	mov    %edx,(%eax)
  803939:	eb 0a                	jmp    803945 <realloc_block_FF+0x598>
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 00                	mov    (%eax),%eax
  803940:	a3 30 50 80 00       	mov    %eax,0x805030
  803945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803948:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80394e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803951:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803958:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80395d:	48                   	dec    %eax
  80395e:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803963:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803969:	01 d0                	add    %edx,%eax
  80396b:	83 ec 04             	sub    $0x4,%esp
  80396e:	6a 01                	push   $0x1
  803970:	50                   	push   %eax
  803971:	ff 75 08             	pushl  0x8(%ebp)
  803974:	e8 41 ea ff ff       	call   8023ba <set_block_data>
  803979:	83 c4 10             	add    $0x10,%esp
  80397c:	e9 36 01 00 00       	jmp    803ab7 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803981:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803984:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803987:	01 d0                	add    %edx,%eax
  803989:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80398c:	83 ec 04             	sub    $0x4,%esp
  80398f:	6a 01                	push   $0x1
  803991:	ff 75 f0             	pushl  -0x10(%ebp)
  803994:	ff 75 08             	pushl  0x8(%ebp)
  803997:	e8 1e ea ff ff       	call   8023ba <set_block_data>
  80399c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80399f:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a2:	83 e8 04             	sub    $0x4,%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	83 e0 fe             	and    $0xfffffffe,%eax
  8039aa:	89 c2                	mov    %eax,%edx
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	01 d0                	add    %edx,%eax
  8039b1:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039b8:	74 06                	je     8039c0 <realloc_block_FF+0x613>
  8039ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039be:	75 17                	jne    8039d7 <realloc_block_FF+0x62a>
  8039c0:	83 ec 04             	sub    $0x4,%esp
  8039c3:	68 10 46 80 00       	push   $0x804610
  8039c8:	68 44 02 00 00       	push   $0x244
  8039cd:	68 9d 45 80 00       	push   $0x80459d
  8039d2:	e8 2b 01 00 00       	call   803b02 <_panic>
  8039d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039da:	8b 10                	mov    (%eax),%edx
  8039dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039df:	89 10                	mov    %edx,(%eax)
  8039e1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e4:	8b 00                	mov    (%eax),%eax
  8039e6:	85 c0                	test   %eax,%eax
  8039e8:	74 0b                	je     8039f5 <realloc_block_FF+0x648>
  8039ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ed:	8b 00                	mov    (%eax),%eax
  8039ef:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039f2:	89 50 04             	mov    %edx,0x4(%eax)
  8039f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039fb:	89 10                	mov    %edx,(%eax)
  8039fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a03:	89 50 04             	mov    %edx,0x4(%eax)
  803a06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	85 c0                	test   %eax,%eax
  803a0d:	75 08                	jne    803a17 <realloc_block_FF+0x66a>
  803a0f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a12:	a3 34 50 80 00       	mov    %eax,0x805034
  803a17:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a1c:	40                   	inc    %eax
  803a1d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a26:	75 17                	jne    803a3f <realloc_block_FF+0x692>
  803a28:	83 ec 04             	sub    $0x4,%esp
  803a2b:	68 7f 45 80 00       	push   $0x80457f
  803a30:	68 45 02 00 00       	push   $0x245
  803a35:	68 9d 45 80 00       	push   $0x80459d
  803a3a:	e8 c3 00 00 00       	call   803b02 <_panic>
  803a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a42:	8b 00                	mov    (%eax),%eax
  803a44:	85 c0                	test   %eax,%eax
  803a46:	74 10                	je     803a58 <realloc_block_FF+0x6ab>
  803a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a50:	8b 52 04             	mov    0x4(%edx),%edx
  803a53:	89 50 04             	mov    %edx,0x4(%eax)
  803a56:	eb 0b                	jmp    803a63 <realloc_block_FF+0x6b6>
  803a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5b:	8b 40 04             	mov    0x4(%eax),%eax
  803a5e:	a3 34 50 80 00       	mov    %eax,0x805034
  803a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a66:	8b 40 04             	mov    0x4(%eax),%eax
  803a69:	85 c0                	test   %eax,%eax
  803a6b:	74 0f                	je     803a7c <realloc_block_FF+0x6cf>
  803a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a70:	8b 40 04             	mov    0x4(%eax),%eax
  803a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a76:	8b 12                	mov    (%edx),%edx
  803a78:	89 10                	mov    %edx,(%eax)
  803a7a:	eb 0a                	jmp    803a86 <realloc_block_FF+0x6d9>
  803a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	a3 30 50 80 00       	mov    %eax,0x805030
  803a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a99:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a9e:	48                   	dec    %eax
  803a9f:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803aa4:	83 ec 04             	sub    $0x4,%esp
  803aa7:	6a 00                	push   $0x0
  803aa9:	ff 75 bc             	pushl  -0x44(%ebp)
  803aac:	ff 75 b8             	pushl  -0x48(%ebp)
  803aaf:	e8 06 e9 ff ff       	call   8023ba <set_block_data>
  803ab4:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	eb 0a                	jmp    803ac6 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803abc:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ac3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ac6:	c9                   	leave  
  803ac7:	c3                   	ret    

00803ac8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ac8:	55                   	push   %ebp
  803ac9:	89 e5                	mov    %esp,%ebp
  803acb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ace:	83 ec 04             	sub    $0x4,%esp
  803ad1:	68 94 46 80 00       	push   $0x804694
  803ad6:	68 58 02 00 00       	push   $0x258
  803adb:	68 9d 45 80 00       	push   $0x80459d
  803ae0:	e8 1d 00 00 00       	call   803b02 <_panic>

00803ae5 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ae5:	55                   	push   %ebp
  803ae6:	89 e5                	mov    %esp,%ebp
  803ae8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aeb:	83 ec 04             	sub    $0x4,%esp
  803aee:	68 bc 46 80 00       	push   $0x8046bc
  803af3:	68 61 02 00 00       	push   $0x261
  803af8:	68 9d 45 80 00       	push   $0x80459d
  803afd:	e8 00 00 00 00       	call   803b02 <_panic>

00803b02 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803b02:	55                   	push   %ebp
  803b03:	89 e5                	mov    %esp,%ebp
  803b05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803b08:	8d 45 10             	lea    0x10(%ebp),%eax
  803b0b:	83 c0 04             	add    $0x4,%eax
  803b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803b11:	a1 60 90 18 01       	mov    0x1189060,%eax
  803b16:	85 c0                	test   %eax,%eax
  803b18:	74 16                	je     803b30 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803b1a:	a1 60 90 18 01       	mov    0x1189060,%eax
  803b1f:	83 ec 08             	sub    $0x8,%esp
  803b22:	50                   	push   %eax
  803b23:	68 e4 46 80 00       	push   $0x8046e4
  803b28:	e8 59 cb ff ff       	call   800686 <cprintf>
  803b2d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803b30:	a1 00 50 80 00       	mov    0x805000,%eax
  803b35:	ff 75 0c             	pushl  0xc(%ebp)
  803b38:	ff 75 08             	pushl  0x8(%ebp)
  803b3b:	50                   	push   %eax
  803b3c:	68 e9 46 80 00       	push   $0x8046e9
  803b41:	e8 40 cb ff ff       	call   800686 <cprintf>
  803b46:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803b49:	8b 45 10             	mov    0x10(%ebp),%eax
  803b4c:	83 ec 08             	sub    $0x8,%esp
  803b4f:	ff 75 f4             	pushl  -0xc(%ebp)
  803b52:	50                   	push   %eax
  803b53:	e8 c3 ca ff ff       	call   80061b <vcprintf>
  803b58:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803b5b:	83 ec 08             	sub    $0x8,%esp
  803b5e:	6a 00                	push   $0x0
  803b60:	68 05 47 80 00       	push   $0x804705
  803b65:	e8 b1 ca ff ff       	call   80061b <vcprintf>
  803b6a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803b6d:	e8 32 ca ff ff       	call   8005a4 <exit>

	// should not return here
	while (1) ;
  803b72:	eb fe                	jmp    803b72 <_panic+0x70>

00803b74 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803b74:	55                   	push   %ebp
  803b75:	89 e5                	mov    %esp,%ebp
  803b77:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803b7a:	a1 20 50 80 00       	mov    0x805020,%eax
  803b7f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b88:	39 c2                	cmp    %eax,%edx
  803b8a:	74 14                	je     803ba0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b8c:	83 ec 04             	sub    $0x4,%esp
  803b8f:	68 08 47 80 00       	push   $0x804708
  803b94:	6a 26                	push   $0x26
  803b96:	68 54 47 80 00       	push   $0x804754
  803b9b:	e8 62 ff ff ff       	call   803b02 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803ba7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803bae:	e9 c5 00 00 00       	jmp    803c78 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc0:	01 d0                	add    %edx,%eax
  803bc2:	8b 00                	mov    (%eax),%eax
  803bc4:	85 c0                	test   %eax,%eax
  803bc6:	75 08                	jne    803bd0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803bc8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803bcb:	e9 a5 00 00 00       	jmp    803c75 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bd7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803bde:	eb 69                	jmp    803c49 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803be0:	a1 20 50 80 00       	mov    0x805020,%eax
  803be5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803beb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bee:	89 d0                	mov    %edx,%eax
  803bf0:	01 c0                	add    %eax,%eax
  803bf2:	01 d0                	add    %edx,%eax
  803bf4:	c1 e0 03             	shl    $0x3,%eax
  803bf7:	01 c8                	add    %ecx,%eax
  803bf9:	8a 40 04             	mov    0x4(%eax),%al
  803bfc:	84 c0                	test   %al,%al
  803bfe:	75 46                	jne    803c46 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c00:	a1 20 50 80 00       	mov    0x805020,%eax
  803c05:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c0e:	89 d0                	mov    %edx,%eax
  803c10:	01 c0                	add    %eax,%eax
  803c12:	01 d0                	add    %edx,%eax
  803c14:	c1 e0 03             	shl    $0x3,%eax
  803c17:	01 c8                	add    %ecx,%eax
  803c19:	8b 00                	mov    (%eax),%eax
  803c1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803c1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803c26:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803c32:	8b 45 08             	mov    0x8(%ebp),%eax
  803c35:	01 c8                	add    %ecx,%eax
  803c37:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c39:	39 c2                	cmp    %eax,%edx
  803c3b:	75 09                	jne    803c46 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803c3d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c44:	eb 15                	jmp    803c5b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c46:	ff 45 e8             	incl   -0x18(%ebp)
  803c49:	a1 20 50 80 00       	mov    0x805020,%eax
  803c4e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c57:	39 c2                	cmp    %eax,%edx
  803c59:	77 85                	ja     803be0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803c5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c5f:	75 14                	jne    803c75 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803c61:	83 ec 04             	sub    $0x4,%esp
  803c64:	68 60 47 80 00       	push   $0x804760
  803c69:	6a 3a                	push   $0x3a
  803c6b:	68 54 47 80 00       	push   $0x804754
  803c70:	e8 8d fe ff ff       	call   803b02 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803c75:	ff 45 f0             	incl   -0x10(%ebp)
  803c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c7e:	0f 8c 2f ff ff ff    	jl     803bb3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803c84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c8b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c92:	eb 26                	jmp    803cba <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c94:	a1 20 50 80 00       	mov    0x805020,%eax
  803c99:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ca2:	89 d0                	mov    %edx,%eax
  803ca4:	01 c0                	add    %eax,%eax
  803ca6:	01 d0                	add    %edx,%eax
  803ca8:	c1 e0 03             	shl    $0x3,%eax
  803cab:	01 c8                	add    %ecx,%eax
  803cad:	8a 40 04             	mov    0x4(%eax),%al
  803cb0:	3c 01                	cmp    $0x1,%al
  803cb2:	75 03                	jne    803cb7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803cb4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803cb7:	ff 45 e0             	incl   -0x20(%ebp)
  803cba:	a1 20 50 80 00       	mov    0x805020,%eax
  803cbf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803cc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cc8:	39 c2                	cmp    %eax,%edx
  803cca:	77 c8                	ja     803c94 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803cd2:	74 14                	je     803ce8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803cd4:	83 ec 04             	sub    $0x4,%esp
  803cd7:	68 b4 47 80 00       	push   $0x8047b4
  803cdc:	6a 44                	push   $0x44
  803cde:	68 54 47 80 00       	push   $0x804754
  803ce3:	e8 1a fe ff ff       	call   803b02 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ce8:	90                   	nop
  803ce9:	c9                   	leave  
  803cea:	c3                   	ret    
  803ceb:	90                   	nop

00803cec <__udivdi3>:
  803cec:	55                   	push   %ebp
  803ced:	57                   	push   %edi
  803cee:	56                   	push   %esi
  803cef:	53                   	push   %ebx
  803cf0:	83 ec 1c             	sub    $0x1c,%esp
  803cf3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cf7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d03:	89 ca                	mov    %ecx,%edx
  803d05:	89 f8                	mov    %edi,%eax
  803d07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d0b:	85 f6                	test   %esi,%esi
  803d0d:	75 2d                	jne    803d3c <__udivdi3+0x50>
  803d0f:	39 cf                	cmp    %ecx,%edi
  803d11:	77 65                	ja     803d78 <__udivdi3+0x8c>
  803d13:	89 fd                	mov    %edi,%ebp
  803d15:	85 ff                	test   %edi,%edi
  803d17:	75 0b                	jne    803d24 <__udivdi3+0x38>
  803d19:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1e:	31 d2                	xor    %edx,%edx
  803d20:	f7 f7                	div    %edi
  803d22:	89 c5                	mov    %eax,%ebp
  803d24:	31 d2                	xor    %edx,%edx
  803d26:	89 c8                	mov    %ecx,%eax
  803d28:	f7 f5                	div    %ebp
  803d2a:	89 c1                	mov    %eax,%ecx
  803d2c:	89 d8                	mov    %ebx,%eax
  803d2e:	f7 f5                	div    %ebp
  803d30:	89 cf                	mov    %ecx,%edi
  803d32:	89 fa                	mov    %edi,%edx
  803d34:	83 c4 1c             	add    $0x1c,%esp
  803d37:	5b                   	pop    %ebx
  803d38:	5e                   	pop    %esi
  803d39:	5f                   	pop    %edi
  803d3a:	5d                   	pop    %ebp
  803d3b:	c3                   	ret    
  803d3c:	39 ce                	cmp    %ecx,%esi
  803d3e:	77 28                	ja     803d68 <__udivdi3+0x7c>
  803d40:	0f bd fe             	bsr    %esi,%edi
  803d43:	83 f7 1f             	xor    $0x1f,%edi
  803d46:	75 40                	jne    803d88 <__udivdi3+0x9c>
  803d48:	39 ce                	cmp    %ecx,%esi
  803d4a:	72 0a                	jb     803d56 <__udivdi3+0x6a>
  803d4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d50:	0f 87 9e 00 00 00    	ja     803df4 <__udivdi3+0x108>
  803d56:	b8 01 00 00 00       	mov    $0x1,%eax
  803d5b:	89 fa                	mov    %edi,%edx
  803d5d:	83 c4 1c             	add    $0x1c,%esp
  803d60:	5b                   	pop    %ebx
  803d61:	5e                   	pop    %esi
  803d62:	5f                   	pop    %edi
  803d63:	5d                   	pop    %ebp
  803d64:	c3                   	ret    
  803d65:	8d 76 00             	lea    0x0(%esi),%esi
  803d68:	31 ff                	xor    %edi,%edi
  803d6a:	31 c0                	xor    %eax,%eax
  803d6c:	89 fa                	mov    %edi,%edx
  803d6e:	83 c4 1c             	add    $0x1c,%esp
  803d71:	5b                   	pop    %ebx
  803d72:	5e                   	pop    %esi
  803d73:	5f                   	pop    %edi
  803d74:	5d                   	pop    %ebp
  803d75:	c3                   	ret    
  803d76:	66 90                	xchg   %ax,%ax
  803d78:	89 d8                	mov    %ebx,%eax
  803d7a:	f7 f7                	div    %edi
  803d7c:	31 ff                	xor    %edi,%edi
  803d7e:	89 fa                	mov    %edi,%edx
  803d80:	83 c4 1c             	add    $0x1c,%esp
  803d83:	5b                   	pop    %ebx
  803d84:	5e                   	pop    %esi
  803d85:	5f                   	pop    %edi
  803d86:	5d                   	pop    %ebp
  803d87:	c3                   	ret    
  803d88:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d8d:	89 eb                	mov    %ebp,%ebx
  803d8f:	29 fb                	sub    %edi,%ebx
  803d91:	89 f9                	mov    %edi,%ecx
  803d93:	d3 e6                	shl    %cl,%esi
  803d95:	89 c5                	mov    %eax,%ebp
  803d97:	88 d9                	mov    %bl,%cl
  803d99:	d3 ed                	shr    %cl,%ebp
  803d9b:	89 e9                	mov    %ebp,%ecx
  803d9d:	09 f1                	or     %esi,%ecx
  803d9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803da3:	89 f9                	mov    %edi,%ecx
  803da5:	d3 e0                	shl    %cl,%eax
  803da7:	89 c5                	mov    %eax,%ebp
  803da9:	89 d6                	mov    %edx,%esi
  803dab:	88 d9                	mov    %bl,%cl
  803dad:	d3 ee                	shr    %cl,%esi
  803daf:	89 f9                	mov    %edi,%ecx
  803db1:	d3 e2                	shl    %cl,%edx
  803db3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803db7:	88 d9                	mov    %bl,%cl
  803db9:	d3 e8                	shr    %cl,%eax
  803dbb:	09 c2                	or     %eax,%edx
  803dbd:	89 d0                	mov    %edx,%eax
  803dbf:	89 f2                	mov    %esi,%edx
  803dc1:	f7 74 24 0c          	divl   0xc(%esp)
  803dc5:	89 d6                	mov    %edx,%esi
  803dc7:	89 c3                	mov    %eax,%ebx
  803dc9:	f7 e5                	mul    %ebp
  803dcb:	39 d6                	cmp    %edx,%esi
  803dcd:	72 19                	jb     803de8 <__udivdi3+0xfc>
  803dcf:	74 0b                	je     803ddc <__udivdi3+0xf0>
  803dd1:	89 d8                	mov    %ebx,%eax
  803dd3:	31 ff                	xor    %edi,%edi
  803dd5:	e9 58 ff ff ff       	jmp    803d32 <__udivdi3+0x46>
  803dda:	66 90                	xchg   %ax,%ax
  803ddc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803de0:	89 f9                	mov    %edi,%ecx
  803de2:	d3 e2                	shl    %cl,%edx
  803de4:	39 c2                	cmp    %eax,%edx
  803de6:	73 e9                	jae    803dd1 <__udivdi3+0xe5>
  803de8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803deb:	31 ff                	xor    %edi,%edi
  803ded:	e9 40 ff ff ff       	jmp    803d32 <__udivdi3+0x46>
  803df2:	66 90                	xchg   %ax,%ax
  803df4:	31 c0                	xor    %eax,%eax
  803df6:	e9 37 ff ff ff       	jmp    803d32 <__udivdi3+0x46>
  803dfb:	90                   	nop

00803dfc <__umoddi3>:
  803dfc:	55                   	push   %ebp
  803dfd:	57                   	push   %edi
  803dfe:	56                   	push   %esi
  803dff:	53                   	push   %ebx
  803e00:	83 ec 1c             	sub    $0x1c,%esp
  803e03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e07:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e1b:	89 f3                	mov    %esi,%ebx
  803e1d:	89 fa                	mov    %edi,%edx
  803e1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e23:	89 34 24             	mov    %esi,(%esp)
  803e26:	85 c0                	test   %eax,%eax
  803e28:	75 1a                	jne    803e44 <__umoddi3+0x48>
  803e2a:	39 f7                	cmp    %esi,%edi
  803e2c:	0f 86 a2 00 00 00    	jbe    803ed4 <__umoddi3+0xd8>
  803e32:	89 c8                	mov    %ecx,%eax
  803e34:	89 f2                	mov    %esi,%edx
  803e36:	f7 f7                	div    %edi
  803e38:	89 d0                	mov    %edx,%eax
  803e3a:	31 d2                	xor    %edx,%edx
  803e3c:	83 c4 1c             	add    $0x1c,%esp
  803e3f:	5b                   	pop    %ebx
  803e40:	5e                   	pop    %esi
  803e41:	5f                   	pop    %edi
  803e42:	5d                   	pop    %ebp
  803e43:	c3                   	ret    
  803e44:	39 f0                	cmp    %esi,%eax
  803e46:	0f 87 ac 00 00 00    	ja     803ef8 <__umoddi3+0xfc>
  803e4c:	0f bd e8             	bsr    %eax,%ebp
  803e4f:	83 f5 1f             	xor    $0x1f,%ebp
  803e52:	0f 84 ac 00 00 00    	je     803f04 <__umoddi3+0x108>
  803e58:	bf 20 00 00 00       	mov    $0x20,%edi
  803e5d:	29 ef                	sub    %ebp,%edi
  803e5f:	89 fe                	mov    %edi,%esi
  803e61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e65:	89 e9                	mov    %ebp,%ecx
  803e67:	d3 e0                	shl    %cl,%eax
  803e69:	89 d7                	mov    %edx,%edi
  803e6b:	89 f1                	mov    %esi,%ecx
  803e6d:	d3 ef                	shr    %cl,%edi
  803e6f:	09 c7                	or     %eax,%edi
  803e71:	89 e9                	mov    %ebp,%ecx
  803e73:	d3 e2                	shl    %cl,%edx
  803e75:	89 14 24             	mov    %edx,(%esp)
  803e78:	89 d8                	mov    %ebx,%eax
  803e7a:	d3 e0                	shl    %cl,%eax
  803e7c:	89 c2                	mov    %eax,%edx
  803e7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e82:	d3 e0                	shl    %cl,%eax
  803e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e88:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e8c:	89 f1                	mov    %esi,%ecx
  803e8e:	d3 e8                	shr    %cl,%eax
  803e90:	09 d0                	or     %edx,%eax
  803e92:	d3 eb                	shr    %cl,%ebx
  803e94:	89 da                	mov    %ebx,%edx
  803e96:	f7 f7                	div    %edi
  803e98:	89 d3                	mov    %edx,%ebx
  803e9a:	f7 24 24             	mull   (%esp)
  803e9d:	89 c6                	mov    %eax,%esi
  803e9f:	89 d1                	mov    %edx,%ecx
  803ea1:	39 d3                	cmp    %edx,%ebx
  803ea3:	0f 82 87 00 00 00    	jb     803f30 <__umoddi3+0x134>
  803ea9:	0f 84 91 00 00 00    	je     803f40 <__umoddi3+0x144>
  803eaf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803eb3:	29 f2                	sub    %esi,%edx
  803eb5:	19 cb                	sbb    %ecx,%ebx
  803eb7:	89 d8                	mov    %ebx,%eax
  803eb9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ebd:	d3 e0                	shl    %cl,%eax
  803ebf:	89 e9                	mov    %ebp,%ecx
  803ec1:	d3 ea                	shr    %cl,%edx
  803ec3:	09 d0                	or     %edx,%eax
  803ec5:	89 e9                	mov    %ebp,%ecx
  803ec7:	d3 eb                	shr    %cl,%ebx
  803ec9:	89 da                	mov    %ebx,%edx
  803ecb:	83 c4 1c             	add    $0x1c,%esp
  803ece:	5b                   	pop    %ebx
  803ecf:	5e                   	pop    %esi
  803ed0:	5f                   	pop    %edi
  803ed1:	5d                   	pop    %ebp
  803ed2:	c3                   	ret    
  803ed3:	90                   	nop
  803ed4:	89 fd                	mov    %edi,%ebp
  803ed6:	85 ff                	test   %edi,%edi
  803ed8:	75 0b                	jne    803ee5 <__umoddi3+0xe9>
  803eda:	b8 01 00 00 00       	mov    $0x1,%eax
  803edf:	31 d2                	xor    %edx,%edx
  803ee1:	f7 f7                	div    %edi
  803ee3:	89 c5                	mov    %eax,%ebp
  803ee5:	89 f0                	mov    %esi,%eax
  803ee7:	31 d2                	xor    %edx,%edx
  803ee9:	f7 f5                	div    %ebp
  803eeb:	89 c8                	mov    %ecx,%eax
  803eed:	f7 f5                	div    %ebp
  803eef:	89 d0                	mov    %edx,%eax
  803ef1:	e9 44 ff ff ff       	jmp    803e3a <__umoddi3+0x3e>
  803ef6:	66 90                	xchg   %ax,%ax
  803ef8:	89 c8                	mov    %ecx,%eax
  803efa:	89 f2                	mov    %esi,%edx
  803efc:	83 c4 1c             	add    $0x1c,%esp
  803eff:	5b                   	pop    %ebx
  803f00:	5e                   	pop    %esi
  803f01:	5f                   	pop    %edi
  803f02:	5d                   	pop    %ebp
  803f03:	c3                   	ret    
  803f04:	3b 04 24             	cmp    (%esp),%eax
  803f07:	72 06                	jb     803f0f <__umoddi3+0x113>
  803f09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f0d:	77 0f                	ja     803f1e <__umoddi3+0x122>
  803f0f:	89 f2                	mov    %esi,%edx
  803f11:	29 f9                	sub    %edi,%ecx
  803f13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f17:	89 14 24             	mov    %edx,(%esp)
  803f1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f22:	8b 14 24             	mov    (%esp),%edx
  803f25:	83 c4 1c             	add    $0x1c,%esp
  803f28:	5b                   	pop    %ebx
  803f29:	5e                   	pop    %esi
  803f2a:	5f                   	pop    %edi
  803f2b:	5d                   	pop    %ebp
  803f2c:	c3                   	ret    
  803f2d:	8d 76 00             	lea    0x0(%esi),%esi
  803f30:	2b 04 24             	sub    (%esp),%eax
  803f33:	19 fa                	sbb    %edi,%edx
  803f35:	89 d1                	mov    %edx,%ecx
  803f37:	89 c6                	mov    %eax,%esi
  803f39:	e9 71 ff ff ff       	jmp    803eaf <__umoddi3+0xb3>
  803f3e:	66 90                	xchg   %ax,%ax
  803f40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f44:	72 ea                	jb     803f30 <__umoddi3+0x134>
  803f46:	89 d9                	mov    %ebx,%ecx
  803f48:	e9 62 ff ff ff       	jmp    803eaf <__umoddi3+0xb3>
