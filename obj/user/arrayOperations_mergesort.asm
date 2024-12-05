
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
  800031:	e8 5d 04 00 00       	call   800493 <libmain>
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
  80003e:	e8 32 1c 00 00       	call   801c75 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 e0 3e 80 00       	push   $0x803ee0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 c2 39 00 00       	call   803a1c <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 e6 3e 80 00       	push   $0x803ee6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 ab 39 00 00       	call   803a1c <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 e0             	pushl  -0x20(%ebp)
  80007a:	e8 b7 39 00 00       	call   803a36 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800082:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  800089:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	68 ef 3e 80 00       	push   $0x803eef
  800098:	ff 75 f0             	pushl  -0x10(%ebp)
  80009b:	e8 79 17 00 00       	call   801819 <sget>
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000a6:	83 ec 08             	sub    $0x8,%esp
  8000a9:	68 f3 3e 80 00       	push   $0x803ef3
  8000ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b1:	e8 63 17 00 00       	call   801819 <sget>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000bf:	8b 00                	mov    (%eax),%eax
  8000c1:	c1 e0 02             	shl    $0x2,%eax
  8000c4:	83 ec 04             	sub    $0x4,%esp
  8000c7:	6a 00                	push   $0x0
  8000c9:	50                   	push   %eax
  8000ca:	68 fb 3e 80 00       	push   $0x803efb
  8000cf:	e8 a0 16 00 00       	call   801774 <smalloc>
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e1:	eb 25                	jmp    800108 <_main+0xd0>
	{
		sortedArray[i] = sharedArray[i];
  8000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f0:	01 c2                	add    %eax,%edx
  8000f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ff:	01 c8                	add    %ecx,%eax
  800101:	8b 00                	mov    (%eax),%eax
  800103:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800105:	ff 45 f4             	incl   -0xc(%ebp)
  800108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010b:	8b 00                	mov    (%eax),%eax
  80010d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800110:	7f d1                	jg     8000e3 <_main+0xab>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800115:	8b 00                	mov    (%eax),%eax
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	50                   	push   %eax
  80011b:	6a 01                	push   $0x1
  80011d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800120:	e8 fd 00 00 00       	call   800222 <MSort>
  800125:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 0a 3f 80 00       	push   $0x803f0a
  800130:	e8 71 05 00 00       	call   8006a6 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 dc             	pushl  -0x24(%ebp)
  80013e:	e8 0d 39 00 00       	call   803a50 <signal_semaphore>
  800143:	83 c4 10             	add    $0x10,%esp

}
  800146:	90                   	nop
  800147:	c9                   	leave  
  800148:	c3                   	ret    

00800149 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80014f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800159:	8b 45 08             	mov    0x8(%ebp),%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800163:	8b 45 0c             	mov    0xc(%ebp),%eax
  800166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016d:	8b 45 08             	mov    0x8(%ebp),%eax
  800170:	01 c2                	add    %eax,%edx
  800172:	8b 45 10             	mov    0x10(%ebp),%eax
  800175:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	01 c8                	add    %ecx,%eax
  800181:	8b 00                	mov    (%eax),%eax
  800183:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800185:	8b 45 10             	mov    0x10(%ebp),%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	8b 45 08             	mov    0x8(%ebp),%eax
  800192:	01 c2                	add    %eax,%edx
  800194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800197:	89 02                	mov    %eax,(%edx)
}
  800199:	90                   	nop
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    

0080019c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8001a2:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8001b0:	eb 42                	jmp    8001f4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8001b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b5:	99                   	cltd   
  8001b6:	f7 7d f0             	idivl  -0x10(%ebp)
  8001b9:	89 d0                	mov    %edx,%eax
  8001bb:	85 c0                	test   %eax,%eax
  8001bd:	75 10                	jne    8001cf <PrintElements+0x33>
			cprintf("\n");
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	68 26 3f 80 00       	push   $0x803f26
  8001c7:	e8 da 04 00 00       	call   8006a6 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 d0                	add    %edx,%eax
  8001de:	8b 00                	mov    (%eax),%eax
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	50                   	push   %eax
  8001e4:	68 28 3f 80 00       	push   $0x803f28
  8001e9:	e8 b8 04 00 00       	call   8006a6 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001f1:	ff 45 f4             	incl   -0xc(%ebp)
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	48                   	dec    %eax
  8001f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001fb:	7f b5                	jg     8001b2 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800200:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 d0                	add    %edx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	50                   	push   %eax
  800212:	68 2d 3f 80 00       	push   $0x803f2d
  800217:	e8 8a 04 00 00       	call   8006a6 <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp

}
  80021f:	90                   	nop
  800220:	c9                   	leave  
  800221:	c3                   	ret    

00800222 <MSort>:


void MSort(int* A, int p, int r)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80022e:	7d 54                	jge    800284 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800230:	8b 55 0c             	mov    0xc(%ebp),%edx
  800233:	8b 45 10             	mov    0x10(%ebp),%eax
  800236:	01 d0                	add    %edx,%eax
  800238:	89 c2                	mov    %eax,%edx
  80023a:	c1 ea 1f             	shr    $0x1f,%edx
  80023d:	01 d0                	add    %edx,%eax
  80023f:	d1 f8                	sar    %eax
  800241:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	ff 75 f4             	pushl  -0xc(%ebp)
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 cd ff ff ff       	call   800222 <MSort>
  800255:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025b:	40                   	inc    %eax
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	ff 75 10             	pushl  0x10(%ebp)
  800262:	50                   	push   %eax
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	e8 b7 ff ff ff       	call   800222 <MSort>
  80026b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80026e:	ff 75 10             	pushl  0x10(%ebp)
  800271:	ff 75 f4             	pushl  -0xc(%ebp)
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	e8 08 00 00 00       	call   800287 <Merge>
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	eb 01                	jmp    800285 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800284:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80028d:	8b 45 10             	mov    0x10(%ebp),%eax
  800290:	2b 45 0c             	sub    0xc(%ebp),%eax
  800293:	40                   	inc    %eax
  800294:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800297:	8b 45 14             	mov    0x14(%ebp),%eax
  80029a:	2b 45 10             	sub    0x10(%ebp),%eax
  80029d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  8002a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  8002a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  8002ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b1:	c1 e0 02             	shl    $0x2,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 99 11 00 00       	call   801456 <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c6:	c1 e0 02             	shl    $0x2,%eax
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	50                   	push   %eax
  8002cd:	e8 84 11 00 00       	call   801456 <malloc>
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002df:	eb 2f                	jmp    800310 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ee:	01 c2                	add    %eax,%edx
  8002f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f6:	01 c8                	add    %ecx,%eax
  8002f8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80030d:	ff 45 ec             	incl   -0x14(%ebp)
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800316:	7c c9                	jl     8002e1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800318:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80031f:	eb 2a                	jmp    80034b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032e:	01 c2                	add    %eax,%edx
  800330:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800336:	01 c8                	add    %ecx,%eax
  800338:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c8                	add    %ecx,%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800348:	ff 45 e8             	incl   -0x18(%ebp)
  80034b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80034e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800351:	7c ce                	jl     800321 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800353:	8b 45 0c             	mov    0xc(%ebp),%eax
  800356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800359:	e9 0a 01 00 00       	jmp    800468 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800361:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800364:	0f 8d 95 00 00 00    	jge    8003ff <Merge+0x178>
  80036a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800370:	0f 8d 89 00 00 00    	jge    8003ff <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800383:	01 d0                	add    %edx,%eax
  800385:	8b 10                	mov    (%eax),%edx
  800387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	7d 33                	jge    8003cf <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80039c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80039f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	8d 50 01             	lea    0x1(%eax),%edx
  8003b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c4:	01 d0                	add    %edx,%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003ca:	e9 96 00 00 00       	jmp    800465 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ea:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f7:	01 d0                	add    %edx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003fd:	eb 66                	jmp    800465 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800402:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800405:	7d 30                	jge    800437 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80040f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	8d 50 01             	lea    0x1(%eax),%edx
  800422:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042f:	01 d0                	add    %edx,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	89 01                	mov    %eax,(%ecx)
  800435:	eb 2e                	jmp    800465 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80044c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044f:	8d 50 01             	lea    0x1(%eax),%edx
  800452:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80045f:	01 d0                	add    %edx,%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800465:	ff 45 e4             	incl   -0x1c(%ebp)
  800468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80046e:	0f 8e ea fe ff ff    	jle    80035e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	ff 75 d8             	pushl  -0x28(%ebp)
  80047a:	e8 f6 11 00 00       	call   801675 <free>
  80047f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	ff 75 d4             	pushl  -0x2c(%ebp)
  800488:	e8 e8 11 00 00       	call   801675 <free>
  80048d:	83 c4 10             	add    $0x10,%esp

}
  800490:	90                   	nop
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800499:	e8 be 17 00 00       	call   801c5c <sys_getenvindex>
  80049e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8004a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	c1 e0 03             	shl    $0x3,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004b2:	01 c8                	add    %ecx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004bf:	01 c8                	add    %ecx,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004c8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d2:	8a 40 20             	mov    0x20(%eax),%al
  8004d5:	84 c0                	test   %al,%al
  8004d7:	74 0d                	je     8004e6 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8004d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004de:	83 c0 20             	add    $0x20,%eax
  8004e1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004ea:	7e 0a                	jle    8004f6 <libmain+0x63>
		binaryname = argv[0];
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 0c             	pushl  0xc(%ebp)
  8004fc:	ff 75 08             	pushl  0x8(%ebp)
  8004ff:	e8 34 fb ff ff       	call   800038 <_main>
  800504:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800507:	e8 d4 14 00 00       	call   8019e0 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80050c:	83 ec 0c             	sub    $0xc,%esp
  80050f:	68 4c 3f 80 00       	push   $0x803f4c
  800514:	e8 8d 01 00 00       	call   8006a6 <cprintf>
  800519:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80051c:	a1 20 50 80 00       	mov    0x805020,%eax
  800521:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800527:	a1 20 50 80 00       	mov    0x805020,%eax
  80052c:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	52                   	push   %edx
  800536:	50                   	push   %eax
  800537:	68 74 3f 80 00       	push   $0x803f74
  80053c:	e8 65 01 00 00       	call   8006a6 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800544:	a1 20 50 80 00       	mov    0x805020,%eax
  800549:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80054f:	a1 20 50 80 00       	mov    0x805020,%eax
  800554:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80055a:	a1 20 50 80 00       	mov    0x805020,%eax
  80055f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800565:	51                   	push   %ecx
  800566:	52                   	push   %edx
  800567:	50                   	push   %eax
  800568:	68 9c 3f 80 00       	push   $0x803f9c
  80056d:	e8 34 01 00 00       	call   8006a6 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800575:	a1 20 50 80 00       	mov    0x805020,%eax
  80057a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 f4 3f 80 00       	push   $0x803ff4
  800589:	e8 18 01 00 00       	call   8006a6 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	68 4c 3f 80 00       	push   $0x803f4c
  800599:	e8 08 01 00 00       	call   8006a6 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a1:	e8 54 14 00 00       	call   8019fa <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8005a6:	e8 19 00 00 00       	call   8005c4 <exit>
}
  8005ab:	90                   	nop
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	6a 00                	push   $0x0
  8005b9:	e8 6a 16 00 00       	call   801c28 <sys_destroy_env>
  8005be:	83 c4 10             	add    $0x10,%esp
}
  8005c1:	90                   	nop
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <exit>:

void
exit(void)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005ca:	e8 bf 16 00 00       	call   801c8e <sys_exit_env>
}
  8005cf:	90                   	nop
  8005d0:	c9                   	leave  
  8005d1:	c3                   	ret    

008005d2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e3:	89 0a                	mov    %ecx,(%edx)
  8005e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e8:	88 d1                	mov    %dl,%cl
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fb:	75 2c                	jne    800629 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005fd:	a0 28 50 80 00       	mov    0x805028,%al
  800602:	0f b6 c0             	movzbl %al,%eax
  800605:	8b 55 0c             	mov    0xc(%ebp),%edx
  800608:	8b 12                	mov    (%edx),%edx
  80060a:	89 d1                	mov    %edx,%ecx
  80060c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060f:	83 c2 08             	add    $0x8,%edx
  800612:	83 ec 04             	sub    $0x4,%esp
  800615:	50                   	push   %eax
  800616:	51                   	push   %ecx
  800617:	52                   	push   %edx
  800618:	e8 81 13 00 00       	call   80199e <sys_cputs>
  80061d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062c:	8b 40 04             	mov    0x4(%eax),%eax
  80062f:	8d 50 01             	lea    0x1(%eax),%edx
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	89 50 04             	mov    %edx,0x4(%eax)
}
  800638:	90                   	nop
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800644:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064b:	00 00 00 
	b.cnt = 0;
  80064e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800655:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800658:	ff 75 0c             	pushl  0xc(%ebp)
  80065b:	ff 75 08             	pushl  0x8(%ebp)
  80065e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800664:	50                   	push   %eax
  800665:	68 d2 05 80 00       	push   $0x8005d2
  80066a:	e8 11 02 00 00       	call   800880 <vprintfmt>
  80066f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800672:	a0 28 50 80 00       	mov    0x805028,%al
  800677:	0f b6 c0             	movzbl %al,%eax
  80067a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	50                   	push   %eax
  800684:	52                   	push   %edx
  800685:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068b:	83 c0 08             	add    $0x8,%eax
  80068e:	50                   	push   %eax
  80068f:	e8 0a 13 00 00       	call   80199e <sys_cputs>
  800694:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800697:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  80069e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ac:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8006b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c2:	50                   	push   %eax
  8006c3:	e8 73 ff ff ff       	call   80063b <vcprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006d9:	e8 02 13 00 00       	call   8019e0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ed:	50                   	push   %eax
  8006ee:	e8 48 ff ff ff       	call   80063b <vcprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006f9:	e8 fc 12 00 00       	call   8019fa <sys_unlock_cons>
	return cnt;
  8006fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800701:	c9                   	leave  
  800702:	c3                   	ret    

00800703 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
  800706:	53                   	push   %ebx
  800707:	83 ec 14             	sub    $0x14,%esp
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800716:	8b 45 18             	mov    0x18(%ebp),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800721:	77 55                	ja     800778 <printnum+0x75>
  800723:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800726:	72 05                	jb     80072d <printnum+0x2a>
  800728:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072b:	77 4b                	ja     800778 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800730:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800733:	8b 45 18             	mov    0x18(%ebp),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	52                   	push   %edx
  80073c:	50                   	push   %eax
  80073d:	ff 75 f4             	pushl  -0xc(%ebp)
  800740:	ff 75 f0             	pushl  -0x10(%ebp)
  800743:	e8 18 35 00 00       	call   803c60 <__udivdi3>
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	83 ec 04             	sub    $0x4,%esp
  80074e:	ff 75 20             	pushl  0x20(%ebp)
  800751:	53                   	push   %ebx
  800752:	ff 75 18             	pushl  0x18(%ebp)
  800755:	52                   	push   %edx
  800756:	50                   	push   %eax
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	ff 75 08             	pushl  0x8(%ebp)
  80075d:	e8 a1 ff ff ff       	call   800703 <printnum>
  800762:	83 c4 20             	add    $0x20,%esp
  800765:	eb 1a                	jmp    800781 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	ff 75 20             	pushl  0x20(%ebp)
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	ff d0                	call   *%eax
  800775:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800778:	ff 4d 1c             	decl   0x1c(%ebp)
  80077b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80077f:	7f e6                	jg     800767 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800781:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800784:	bb 00 00 00 00       	mov    $0x0,%ebx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078f:	53                   	push   %ebx
  800790:	51                   	push   %ecx
  800791:	52                   	push   %edx
  800792:	50                   	push   %eax
  800793:	e8 d8 35 00 00       	call   803d70 <__umoddi3>
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	05 34 42 80 00       	add    $0x804234,%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be c0             	movsbl %al,%eax
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
}
  8007b4:	90                   	nop
  8007b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c1:	7e 1c                	jle    8007df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	8d 50 08             	lea    0x8(%eax),%edx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	89 10                	mov    %edx,(%eax)
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	83 e8 08             	sub    $0x8,%eax
  8007d8:	8b 50 04             	mov    0x4(%eax),%edx
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	eb 40                	jmp    80081f <getuint+0x65>
	else if (lflag)
  8007df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e3:	74 1e                	je     800803 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	eb 1c                	jmp    80081f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	8d 50 04             	lea    0x4(%eax),%edx
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	89 10                	mov    %edx,(%eax)
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	83 e8 04             	sub    $0x4,%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800824:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800828:	7e 1c                	jle    800846 <getint+0x25>
		return va_arg(*ap, long long);
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	8d 50 08             	lea    0x8(%eax),%edx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	89 10                	mov    %edx,(%eax)
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	83 e8 08             	sub    $0x8,%eax
  80083f:	8b 50 04             	mov    0x4(%eax),%edx
  800842:	8b 00                	mov    (%eax),%eax
  800844:	eb 38                	jmp    80087e <getint+0x5d>
	else if (lflag)
  800846:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084a:	74 1a                	je     800866 <getint+0x45>
		return va_arg(*ap, long);
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 50 04             	lea    0x4(%eax),%edx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	89 10                	mov    %edx,(%eax)
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	99                   	cltd   
  800864:	eb 18                	jmp    80087e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	8d 50 04             	lea    0x4(%eax),%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	89 10                	mov    %edx,(%eax)
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	83 e8 04             	sub    $0x4,%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	99                   	cltd   
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	56                   	push   %esi
  800884:	53                   	push   %ebx
  800885:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800888:	eb 17                	jmp    8008a1 <vprintfmt+0x21>
			if (ch == '\0')
  80088a:	85 db                	test   %ebx,%ebx
  80088c:	0f 84 c1 03 00 00    	je     800c53 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	53                   	push   %ebx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a4:	8d 50 01             	lea    0x1(%eax),%edx
  8008a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008aa:	8a 00                	mov    (%eax),%al
  8008ac:	0f b6 d8             	movzbl %al,%ebx
  8008af:	83 fb 25             	cmp    $0x25,%ebx
  8008b2:	75 d6                	jne    80088a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d7:	8d 50 01             	lea    0x1(%eax),%edx
  8008da:	89 55 10             	mov    %edx,0x10(%ebp)
  8008dd:	8a 00                	mov    (%eax),%al
  8008df:	0f b6 d8             	movzbl %al,%ebx
  8008e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e5:	83 f8 5b             	cmp    $0x5b,%eax
  8008e8:	0f 87 3d 03 00 00    	ja     800c2b <vprintfmt+0x3ab>
  8008ee:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
  8008f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fb:	eb d7                	jmp    8008d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800901:	eb d1                	jmp    8008d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090d:	89 d0                	mov    %edx,%eax
  80090f:	c1 e0 02             	shl    $0x2,%eax
  800912:	01 d0                	add    %edx,%eax
  800914:	01 c0                	add    %eax,%eax
  800916:	01 d8                	add    %ebx,%eax
  800918:	83 e8 30             	sub    $0x30,%eax
  80091b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	8a 00                	mov    (%eax),%al
  800923:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800926:	83 fb 2f             	cmp    $0x2f,%ebx
  800929:	7e 3e                	jle    800969 <vprintfmt+0xe9>
  80092b:	83 fb 39             	cmp    $0x39,%ebx
  80092e:	7f 39                	jg     800969 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800930:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800933:	eb d5                	jmp    80090a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 c0 04             	add    $0x4,%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800949:	eb 1f                	jmp    80096a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094f:	79 83                	jns    8008d4 <vprintfmt+0x54>
				width = 0;
  800951:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800958:	e9 77 ff ff ff       	jmp    8008d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800964:	e9 6b ff ff ff       	jmp    8008d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800969:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096e:	0f 89 60 ff ff ff    	jns    8008d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800974:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800977:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800981:	e9 4e ff ff ff       	jmp    8008d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800986:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800989:	e9 46 ff ff ff       	jmp    8008d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	83 c0 04             	add    $0x4,%eax
  800994:	89 45 14             	mov    %eax,0x14(%ebp)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	83 e8 04             	sub    $0x4,%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	ff d0                	call   *%eax
  8009ab:	83 c4 10             	add    $0x10,%esp
			break;
  8009ae:	e9 9b 02 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 c0 04             	add    $0x4,%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 e8 04             	sub    $0x4,%eax
  8009c2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c4:	85 db                	test   %ebx,%ebx
  8009c6:	79 02                	jns    8009ca <vprintfmt+0x14a>
				err = -err;
  8009c8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009ca:	83 fb 64             	cmp    $0x64,%ebx
  8009cd:	7f 0b                	jg     8009da <vprintfmt+0x15a>
  8009cf:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  8009d6:	85 f6                	test   %esi,%esi
  8009d8:	75 19                	jne    8009f3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009da:	53                   	push   %ebx
  8009db:	68 45 42 80 00       	push   $0x804245
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	ff 75 08             	pushl  0x8(%ebp)
  8009e6:	e8 70 02 00 00       	call   800c5b <printfmt>
  8009eb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ee:	e9 5b 02 00 00       	jmp    800c4e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f3:	56                   	push   %esi
  8009f4:	68 4e 42 80 00       	push   $0x80424e
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	e8 57 02 00 00       	call   800c5b <printfmt>
  800a04:	83 c4 10             	add    $0x10,%esp
			break;
  800a07:	e9 42 02 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 c0 04             	add    $0x4,%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	83 e8 04             	sub    $0x4,%eax
  800a1b:	8b 30                	mov    (%eax),%esi
  800a1d:	85 f6                	test   %esi,%esi
  800a1f:	75 05                	jne    800a26 <vprintfmt+0x1a6>
				p = "(null)";
  800a21:	be 51 42 80 00       	mov    $0x804251,%esi
			if (width > 0 && padc != '-')
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2a:	7e 6d                	jle    800a99 <vprintfmt+0x219>
  800a2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a30:	74 67                	je     800a99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	50                   	push   %eax
  800a39:	56                   	push   %esi
  800a3a:	e8 1e 03 00 00       	call   800d5d <strnlen>
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a45:	eb 16                	jmp    800a5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	50                   	push   %eax
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a61:	7f e4                	jg     800a47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a63:	eb 34                	jmp    800a99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a69:	74 1c                	je     800a87 <vprintfmt+0x207>
  800a6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6e:	7e 05                	jle    800a75 <vprintfmt+0x1f5>
  800a70:	83 fb 7e             	cmp    $0x7e,%ebx
  800a73:	7e 12                	jle    800a87 <vprintfmt+0x207>
					putch('?', putdat);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	6a 3f                	push   $0x3f
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	eb 0f                	jmp    800a96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a96:	ff 4d e4             	decl   -0x1c(%ebp)
  800a99:	89 f0                	mov    %esi,%eax
  800a9b:	8d 70 01             	lea    0x1(%eax),%esi
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	0f be d8             	movsbl %al,%ebx
  800aa3:	85 db                	test   %ebx,%ebx
  800aa5:	74 24                	je     800acb <vprintfmt+0x24b>
  800aa7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aab:	78 b8                	js     800a65 <vprintfmt+0x1e5>
  800aad:	ff 4d e0             	decl   -0x20(%ebp)
  800ab0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab4:	79 af                	jns    800a65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab6:	eb 13                	jmp    800acb <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 20                	push   $0x20
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac8:	ff 4d e4             	decl   -0x1c(%ebp)
  800acb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acf:	7f e7                	jg     800ab8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad1:	e9 78 01 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 e8             	pushl  -0x18(%ebp)
  800adc:	8d 45 14             	lea    0x14(%ebp),%eax
  800adf:	50                   	push   %eax
  800ae0:	e8 3c fd ff ff       	call   800821 <getint>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af4:	85 d2                	test   %edx,%edx
  800af6:	79 23                	jns    800b1b <vprintfmt+0x29b>
				putch('-', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 2d                	push   $0x2d
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0e:	f7 d8                	neg    %eax
  800b10:	83 d2 00             	adc    $0x0,%edx
  800b13:	f7 da                	neg    %edx
  800b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b22:	e9 bc 00 00 00       	jmp    800be3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b30:	50                   	push   %eax
  800b31:	e8 84 fc ff ff       	call   8007ba <getuint>
  800b36:	83 c4 10             	add    $0x10,%esp
  800b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b46:	e9 98 00 00 00       	jmp    800be3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	6a 58                	push   $0x58
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	ff d0                	call   *%eax
  800b58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	6a 58                	push   $0x58
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 58                	push   $0x58
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
			break;
  800b7b:	e9 ce 00 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 30                	push   $0x30
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 78                	push   $0x78
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc2:	eb 1f                	jmp    800be3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bca:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcd:	50                   	push   %eax
  800bce:	e8 e7 fb ff ff       	call   8007ba <getuint>
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	52                   	push   %edx
  800bee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf1:	50                   	push   %eax
  800bf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 08             	pushl  0x8(%ebp)
  800bfe:	e8 00 fb ff ff       	call   800703 <printnum>
  800c03:	83 c4 20             	add    $0x20,%esp
			break;
  800c06:	eb 46                	jmp    800c4e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	53                   	push   %ebx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
			break;
  800c17:	eb 35                	jmp    800c4e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c19:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800c20:	eb 2c                	jmp    800c4e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c22:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800c29:	eb 23                	jmp    800c4e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	6a 25                	push   $0x25
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	ff d0                	call   *%eax
  800c38:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c3b:	ff 4d 10             	decl   0x10(%ebp)
  800c3e:	eb 03                	jmp    800c43 <vprintfmt+0x3c3>
  800c40:	ff 4d 10             	decl   0x10(%ebp)
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	48                   	dec    %eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	3c 25                	cmp    $0x25,%al
  800c4b:	75 f3                	jne    800c40 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c4d:	90                   	nop
		}
	}
  800c4e:	e9 35 fc ff ff       	jmp    800888 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c53:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c61:	8d 45 10             	lea    0x10(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 04 fc ff ff       	call   800880 <vprintfmt>
  800c7c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c7f:	90                   	nop
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8b 40 08             	mov    0x8(%eax),%eax
  800c8b:	8d 50 01             	lea    0x1(%eax),%edx
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8b 10                	mov    (%eax),%edx
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8b 40 04             	mov    0x4(%eax),%eax
  800c9f:	39 c2                	cmp    %eax,%edx
  800ca1:	73 12                	jae    800cb5 <sprintputch+0x33>
		*b->buf++ = ch;
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	8d 48 01             	lea    0x1(%eax),%ecx
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	89 0a                	mov    %ecx,(%edx)
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	88 10                	mov    %dl,(%eax)
}
  800cb5:	90                   	nop
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cdd:	74 06                	je     800ce5 <vsnprintf+0x2d>
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	7f 07                	jg     800cec <vsnprintf+0x34>
		return -E_INVAL;
  800ce5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cea:	eb 20                	jmp    800d0c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cec:	ff 75 14             	pushl  0x14(%ebp)
  800cef:	ff 75 10             	pushl  0x10(%ebp)
  800cf2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf5:	50                   	push   %eax
  800cf6:	68 82 0c 80 00       	push   $0x800c82
  800cfb:	e8 80 fb ff ff       	call   800880 <vprintfmt>
  800d00:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d14:	8d 45 10             	lea    0x10(%ebp),%eax
  800d17:	83 c0 04             	add    $0x4,%eax
  800d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d20:	ff 75 f4             	pushl  -0xc(%ebp)
  800d23:	50                   	push   %eax
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	ff 75 08             	pushl  0x8(%ebp)
  800d2a:	e8 89 ff ff ff       	call   800cb8 <vsnprintf>
  800d2f:	83 c4 10             	add    $0x10,%esp
  800d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d47:	eb 06                	jmp    800d4f <strlen+0x15>
		n++;
  800d49:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4c:	ff 45 08             	incl   0x8(%ebp)
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	75 f1                	jne    800d49 <strlen+0xf>
		n++;
	return n;
  800d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d6a:	eb 09                	jmp    800d75 <strnlen+0x18>
		n++;
  800d6c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	ff 4d 0c             	decl   0xc(%ebp)
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	74 09                	je     800d84 <strnlen+0x27>
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	75 e8                	jne    800d6c <strnlen+0xf>
		n++;
	return n;
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d95:	90                   	nop
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da8:	8a 12                	mov    (%edx),%dl
  800daa:	88 10                	mov    %dl,(%eax)
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	84 c0                	test   %al,%al
  800db0:	75 e4                	jne    800d96 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dca:	eb 1f                	jmp    800deb <strncpy+0x34>
		*dst++ = *src;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8d 50 01             	lea    0x1(%eax),%edx
  800dd2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd8:	8a 12                	mov    (%edx),%dl
  800dda:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	84 c0                	test   %al,%al
  800de3:	74 03                	je     800de8 <strncpy+0x31>
			src++;
  800de5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de8:	ff 45 fc             	incl   -0x4(%ebp)
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df1:	72 d9                	jb     800dcc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e08:	74 30                	je     800e3a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e0a:	eb 16                	jmp    800e22 <strlcpy+0x2a>
			*dst++ = *src++;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8d 50 01             	lea    0x1(%eax),%edx
  800e12:	89 55 08             	mov    %edx,0x8(%ebp)
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1e:	8a 12                	mov    (%edx),%dl
  800e20:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e22:	ff 4d 10             	decl   0x10(%ebp)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 09                	je     800e34 <strlcpy+0x3c>
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	75 d8                	jne    800e0c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e49:	eb 06                	jmp    800e51 <strcmp+0xb>
		p++, q++;
  800e4b:	ff 45 08             	incl   0x8(%ebp)
  800e4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	84 c0                	test   %al,%al
  800e58:	74 0e                	je     800e68 <strcmp+0x22>
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8a 10                	mov    (%eax),%dl
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	38 c2                	cmp    %al,%dl
  800e66:	74 e3                	je     800e4b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 d0             	movzbl %al,%edx
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	0f b6 c0             	movzbl %al,%eax
  800e78:	29 c2                	sub    %eax,%edx
  800e7a:	89 d0                	mov    %edx,%eax
}
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e81:	eb 09                	jmp    800e8c <strncmp+0xe>
		n--, p++, q++;
  800e83:	ff 4d 10             	decl   0x10(%ebp)
  800e86:	ff 45 08             	incl   0x8(%ebp)
  800e89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	74 17                	je     800ea9 <strncmp+0x2b>
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	84 c0                	test   %al,%al
  800e99:	74 0e                	je     800ea9 <strncmp+0x2b>
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 10                	mov    (%eax),%dl
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	38 c2                	cmp    %al,%dl
  800ea7:	74 da                	je     800e83 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ead:	75 07                	jne    800eb6 <strncmp+0x38>
		return 0;
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb4:	eb 14                	jmp    800eca <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 d0             	movzbl %al,%edx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 c0             	movzbl %al,%eax
  800ec6:	29 c2                	sub    %eax,%edx
  800ec8:	89 d0                	mov    %edx,%eax
}
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 04             	sub    $0x4,%esp
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed8:	eb 12                	jmp    800eec <strchr+0x20>
		if (*s == c)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee2:	75 05                	jne    800ee9 <strchr+0x1d>
			return (char *) s;
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	eb 11                	jmp    800efa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 e5                	jne    800eda <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 04             	sub    $0x4,%esp
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f08:	eb 0d                	jmp    800f17 <strfind+0x1b>
		if (*s == c)
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f12:	74 0e                	je     800f22 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	75 ea                	jne    800f0a <strfind+0xe>
  800f20:	eb 01                	jmp    800f23 <strfind+0x27>
		if (*s == c)
			break;
  800f22:	90                   	nop
	return (char *) s;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f3a:	eb 0e                	jmp    800f4a <memset+0x22>
		*p++ = c;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	8d 50 01             	lea    0x1(%eax),%edx
  800f42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f48:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f4a:	ff 4d f8             	decl   -0x8(%ebp)
  800f4d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f51:	79 e9                	jns    800f3c <memset+0x14>
		*p++ = c;

	return v;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f6a:	eb 16                	jmp    800f82 <memcpy+0x2a>
		*d++ = *s++;
  800f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6f:	8d 50 01             	lea    0x1(%eax),%edx
  800f72:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f78:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f7e:	8a 12                	mov    (%edx),%dl
  800f80:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f88:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	75 dd                	jne    800f6c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fac:	73 50                	jae    800ffe <memmove+0x6a>
  800fae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 d0                	add    %edx,%eax
  800fb6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb9:	76 43                	jbe    800ffe <memmove+0x6a>
		s += n;
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc7:	eb 10                	jmp    800fd9 <memmove+0x45>
			*--d = *--s;
  800fc9:	ff 4d f8             	decl   -0x8(%ebp)
  800fcc:	ff 4d fc             	decl   -0x4(%ebp)
  800fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd2:	8a 10                	mov    (%eax),%dl
  800fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	75 e3                	jne    800fc9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe6:	eb 23                	jmp    80100b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	8d 50 01             	lea    0x1(%eax),%edx
  800fee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffa:	8a 12                	mov    (%edx),%dl
  800ffc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  801001:	8d 50 ff             	lea    -0x1(%eax),%edx
  801004:	89 55 10             	mov    %edx,0x10(%ebp)
  801007:	85 c0                	test   %eax,%eax
  801009:	75 dd                	jne    800fe8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801022:	eb 2a                	jmp    80104e <memcmp+0x3e>
		if (*s1 != *s2)
  801024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801027:	8a 10                	mov    (%eax),%dl
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	38 c2                	cmp    %al,%dl
  801030:	74 16                	je     801048 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 d0             	movzbl %al,%edx
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	0f b6 c0             	movzbl %al,%eax
  801042:	29 c2                	sub    %eax,%edx
  801044:	89 d0                	mov    %edx,%eax
  801046:	eb 18                	jmp    801060 <memcmp+0x50>
		s1++, s2++;
  801048:	ff 45 fc             	incl   -0x4(%ebp)
  80104b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	8d 50 ff             	lea    -0x1(%eax),%edx
  801054:	89 55 10             	mov    %edx,0x10(%ebp)
  801057:	85 c0                	test   %eax,%eax
  801059:	75 c9                	jne    801024 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801073:	eb 15                	jmp    80108a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f b6 d0             	movzbl %al,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	0f b6 c0             	movzbl %al,%eax
  801083:	39 c2                	cmp    %eax,%edx
  801085:	74 0d                	je     801094 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801090:	72 e3                	jb     801075 <memfind+0x13>
  801092:	eb 01                	jmp    801095 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801094:	90                   	nop
	return (void *) s;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ae:	eb 03                	jmp    8010b3 <strtol+0x19>
		s++;
  8010b0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 20                	cmp    $0x20,%al
  8010ba:	74 f4                	je     8010b0 <strtol+0x16>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	3c 09                	cmp    $0x9,%al
  8010c3:	74 eb                	je     8010b0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 2b                	cmp    $0x2b,%al
  8010cc:	75 05                	jne    8010d3 <strtol+0x39>
		s++;
  8010ce:	ff 45 08             	incl   0x8(%ebp)
  8010d1:	eb 13                	jmp    8010e6 <strtol+0x4c>
	else if (*s == '-')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2d                	cmp    $0x2d,%al
  8010da:	75 0a                	jne    8010e6 <strtol+0x4c>
		s++, neg = 1;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ea:	74 06                	je     8010f2 <strtol+0x58>
  8010ec:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f0:	75 20                	jne    801112 <strtol+0x78>
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 30                	cmp    $0x30,%al
  8010f9:	75 17                	jne    801112 <strtol+0x78>
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	40                   	inc    %eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	3c 78                	cmp    $0x78,%al
  801103:	75 0d                	jne    801112 <strtol+0x78>
		s += 2, base = 16;
  801105:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801109:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801110:	eb 28                	jmp    80113a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801116:	75 15                	jne    80112d <strtol+0x93>
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 30                	cmp    $0x30,%al
  80111f:	75 0c                	jne    80112d <strtol+0x93>
		s++, base = 8;
  801121:	ff 45 08             	incl   0x8(%ebp)
  801124:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112b:	eb 0d                	jmp    80113a <strtol+0xa0>
	else if (base == 0)
  80112d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801131:	75 07                	jne    80113a <strtol+0xa0>
		base = 10;
  801133:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 2f                	cmp    $0x2f,%al
  801141:	7e 19                	jle    80115c <strtol+0xc2>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	3c 39                	cmp    $0x39,%al
  80114a:	7f 10                	jg     80115c <strtol+0xc2>
			dig = *s - '0';
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	83 e8 30             	sub    $0x30,%eax
  801157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115a:	eb 42                	jmp    80119e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 60                	cmp    $0x60,%al
  801163:	7e 19                	jle    80117e <strtol+0xe4>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 7a                	cmp    $0x7a,%al
  80116c:	7f 10                	jg     80117e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f be c0             	movsbl %al,%eax
  801176:	83 e8 57             	sub    $0x57,%eax
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117c:	eb 20                	jmp    80119e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 40                	cmp    $0x40,%al
  801185:	7e 39                	jle    8011c0 <strtol+0x126>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 5a                	cmp    $0x5a,%al
  80118e:	7f 30                	jg     8011c0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f be c0             	movsbl %al,%eax
  801198:	83 e8 37             	sub    $0x37,%eax
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a4:	7d 19                	jge    8011bf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ba:	e9 7b ff ff ff       	jmp    80113a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011bf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c4:	74 08                	je     8011ce <strtol+0x134>
		*endptr = (char *) s;
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d2:	74 07                	je     8011db <strtol+0x141>
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	f7 d8                	neg    %eax
  8011d9:	eb 03                	jmp    8011de <strtol+0x144>
  8011db:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f8:	79 13                	jns    80120d <ltostr+0x2d>
	{
		neg = 1;
  8011fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801207:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801215:	99                   	cltd   
  801216:	f7 f9                	idiv   %ecx
  801218:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	89 c2                	mov    %eax,%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	01 d0                	add    %edx,%eax
  80122b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122e:	83 c2 30             	add    $0x30,%edx
  801231:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801236:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123b:	f7 e9                	imul   %ecx
  80123d:	c1 fa 02             	sar    $0x2,%edx
  801240:	89 c8                	mov    %ecx,%eax
  801242:	c1 f8 1f             	sar    $0x1f,%eax
  801245:	29 c2                	sub    %eax,%edx
  801247:	89 d0                	mov    %edx,%eax
  801249:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80124c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801250:	75 bb                	jne    80120d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	48                   	dec    %eax
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801260:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801264:	74 3d                	je     8012a3 <ltostr+0xc3>
		start = 1 ;
  801266:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80126d:	eb 34                	jmp    8012a3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80127c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	01 c2                	add    %eax,%edx
  801284:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	01 c8                	add    %ecx,%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801290:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	01 c2                	add    %eax,%edx
  801298:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129b:	88 02                	mov    %al,(%edx)
		start++ ;
  80129d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a9:	7c c4                	jl     80126f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ab:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b6:	90                   	nop
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012bf:	ff 75 08             	pushl  0x8(%ebp)
  8012c2:	e8 73 fa ff ff       	call   800d3a <strlen>
  8012c7:	83 c4 04             	add    $0x4,%esp
  8012ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	e8 65 fa ff ff       	call   800d3a <strlen>
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e9:	eb 17                	jmp    801302 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 c2                	add    %eax,%edx
  8012f3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	01 c8                	add    %ecx,%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
  801302:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801305:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801308:	7c e1                	jl     8012eb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801311:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801318:	eb 1f                	jmp    801339 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131d:	8d 50 01             	lea    0x1(%eax),%edx
  801320:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801323:	89 c2                	mov    %eax,%edx
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	01 c2                	add    %eax,%edx
  80132a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	01 c8                	add    %ecx,%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801336:	ff 45 f8             	incl   -0x8(%ebp)
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133f:	7c d9                	jl     80131a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801341:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	c6 00 00             	movb   $0x0,(%eax)
}
  80134c:	90                   	nop
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801352:	8b 45 14             	mov    0x14(%ebp),%eax
  801355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135b:	8b 45 14             	mov    0x14(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801367:	8b 45 10             	mov    0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801372:	eb 0c                	jmp    801380 <strsplit+0x31>
			*string++ = 0;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8d 50 01             	lea    0x1(%eax),%edx
  80137a:	89 55 08             	mov    %edx,0x8(%ebp)
  80137d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	84 c0                	test   %al,%al
  801387:	74 18                	je     8013a1 <strsplit+0x52>
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	0f be c0             	movsbl %al,%eax
  801391:	50                   	push   %eax
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	e8 32 fb ff ff       	call   800ecc <strchr>
  80139a:	83 c4 08             	add    $0x8,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	75 d3                	jne    801374 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	84 c0                	test   %al,%al
  8013a8:	74 5a                	je     801404 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ad:	8b 00                	mov    (%eax),%eax
  8013af:	83 f8 0f             	cmp    $0xf,%eax
  8013b2:	75 07                	jne    8013bb <strsplit+0x6c>
		{
			return 0;
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b9:	eb 66                	jmp    801421 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c6:	89 0a                	mov    %ecx,(%edx)
  8013c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	01 c2                	add    %eax,%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d9:	eb 03                	jmp    8013de <strsplit+0x8f>
			string++;
  8013db:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	84 c0                	test   %al,%al
  8013e5:	74 8b                	je     801372 <strsplit+0x23>
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	0f be c0             	movsbl %al,%eax
  8013ef:	50                   	push   %eax
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	e8 d4 fa ff ff       	call   800ecc <strchr>
  8013f8:	83 c4 08             	add    $0x8,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	74 dc                	je     8013db <strsplit+0x8c>
			string++;
	}
  8013ff:	e9 6e ff ff ff       	jmp    801372 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801404:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	8b 00                	mov    (%eax),%eax
  80140a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801411:	8b 45 10             	mov    0x10(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80141c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	68 c8 43 80 00       	push   $0x8043c8
  801431:	68 3f 01 00 00       	push   $0x13f
  801436:	68 ea 43 80 00       	push   $0x8043ea
  80143b:	e8 35 26 00 00       	call   803a75 <_panic>

00801440 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	ff 75 08             	pushl  0x8(%ebp)
  80144c:	e8 f8 0a 00 00       	call   801f49 <sys_sbrk>
  801451:	83 c4 10             	add    $0x10,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80145c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801460:	75 0a                	jne    80146c <malloc+0x16>
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	e9 07 02 00 00       	jmp    801673 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  80146c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801473:	8b 55 08             	mov    0x8(%ebp),%edx
  801476:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	48                   	dec    %eax
  80147c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80147f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801482:	ba 00 00 00 00       	mov    $0x0,%edx
  801487:	f7 75 dc             	divl   -0x24(%ebp)
  80148a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148d:	29 d0                	sub    %edx,%eax
  80148f:	c1 e8 0c             	shr    $0xc,%eax
  801492:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801495:	a1 20 50 80 00       	mov    0x805020,%eax
  80149a:	8b 40 78             	mov    0x78(%eax),%eax
  80149d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8014a2:	29 c2                	sub    %eax,%edx
  8014a4:	89 d0                	mov    %edx,%eax
  8014a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b1:	c1 e8 0c             	shr    $0xc,%eax
  8014b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8014b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8014be:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014c5:	77 42                	ja     801509 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8014c7:	e8 01 09 00 00       	call   801dcd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 16                	je     8014e6 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	ff 75 08             	pushl  0x8(%ebp)
  8014d6:	e8 41 0e 00 00       	call   80231c <alloc_block_FF>
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e1:	e9 8a 01 00 00       	jmp    801670 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014e6:	e8 13 09 00 00       	call   801dfe <sys_isUHeapPlacementStrategyBESTFIT>
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	0f 84 7d 01 00 00    	je     801670 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	e8 da 12 00 00       	call   8027d8 <alloc_block_BF>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801504:	e9 67 01 00 00       	jmp    801670 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801509:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80150c:	48                   	dec    %eax
  80150d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801510:	0f 86 53 01 00 00    	jbe    801669 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801516:	a1 20 50 80 00       	mov    0x805020,%eax
  80151b:	8b 40 78             	mov    0x78(%eax),%eax
  80151e:	05 00 10 00 00       	add    $0x1000,%eax
  801523:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801526:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  80152d:	e9 de 00 00 00       	jmp    801610 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801532:	a1 20 50 80 00       	mov    0x805020,%eax
  801537:	8b 40 78             	mov    0x78(%eax),%eax
  80153a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153d:	29 c2                	sub    %eax,%edx
  80153f:	89 d0                	mov    %edx,%eax
  801541:	2d 00 10 00 00       	sub    $0x1000,%eax
  801546:	c1 e8 0c             	shr    $0xc,%eax
  801549:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801550:	85 c0                	test   %eax,%eax
  801552:	0f 85 ab 00 00 00    	jne    801603 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	05 00 10 00 00       	add    $0x1000,%eax
  801560:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801563:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  80156a:	eb 47                	jmp    8015b3 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80156c:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801573:	76 0a                	jbe    80157f <malloc+0x129>
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
  80157a:	e9 f4 00 00 00       	jmp    801673 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80157f:	a1 20 50 80 00       	mov    0x805020,%eax
  801584:	8b 40 78             	mov    0x78(%eax),%eax
  801587:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80158a:	29 c2                	sub    %eax,%edx
  80158c:	89 d0                	mov    %edx,%eax
  80158e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801593:	c1 e8 0c             	shr    $0xc,%eax
  801596:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 08                	je     8015a9 <malloc+0x153>
					{
						
						i = j;
  8015a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8015a7:	eb 5a                	jmp    801603 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8015a9:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8015b0:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  8015b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015b6:	48                   	dec    %eax
  8015b7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015ba:	77 b0                	ja     80156c <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8015bc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8015c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015ca:	eb 2f                	jmp    8015fb <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8015cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cf:	c1 e0 0c             	shl    $0xc,%eax
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	01 c2                	add    %eax,%edx
  8015d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8015de:	8b 40 78             	mov    0x78(%eax),%eax
  8015e1:	29 c2                	sub    %eax,%edx
  8015e3:	89 d0                	mov    %edx,%eax
  8015e5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ea:	c1 e8 0c             	shr    $0xc,%eax
  8015ed:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8015f4:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8015f8:	ff 45 e0             	incl   -0x20(%ebp)
  8015fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fe:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801601:	72 c9                	jb     8015cc <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801603:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801607:	75 16                	jne    80161f <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801609:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801610:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801617:	0f 86 15 ff ff ff    	jbe    801532 <malloc+0xdc>
  80161d:	eb 01                	jmp    801620 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  80161f:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801624:	75 07                	jne    80162d <malloc+0x1d7>
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	eb 46                	jmp    801673 <malloc+0x21d>
		ptr = (void*)i;
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801633:	a1 20 50 80 00       	mov    0x805020,%eax
  801638:	8b 40 78             	mov    0x78(%eax),%eax
  80163b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163e:	29 c2                	sub    %eax,%edx
  801640:	89 d0                	mov    %edx,%eax
  801642:	2d 00 10 00 00       	sub    $0x1000,%eax
  801647:	c1 e8 0c             	shr    $0xc,%eax
  80164a:	89 c2                	mov    %eax,%edx
  80164c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80164f:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	ff 75 f0             	pushl  -0x10(%ebp)
  80165f:	e8 1c 09 00 00       	call   801f80 <sys_allocate_user_mem>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	eb 07                	jmp    801670 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
  80166e:	eb 03                	jmp    801673 <malloc+0x21d>
	}
	return ptr;
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80167b:	a1 20 50 80 00       	mov    0x805020,%eax
  801680:	8b 40 78             	mov    0x78(%eax),%eax
  801683:	05 00 10 00 00       	add    $0x1000,%eax
  801688:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80168b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801692:	a1 20 50 80 00       	mov    0x805020,%eax
  801697:	8b 50 78             	mov    0x78(%eax),%edx
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	39 c2                	cmp    %eax,%edx
  80169f:	76 24                	jbe    8016c5 <free+0x50>
		size = get_block_size(va);
  8016a1:	83 ec 0c             	sub    $0xc,%esp
  8016a4:	ff 75 08             	pushl  0x8(%ebp)
  8016a7:	e8 f0 08 00 00       	call   801f9c <get_block_size>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b2:	83 ec 0c             	sub    $0xc,%esp
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	e8 00 1b 00 00       	call   8031bd <free_block>
  8016bd:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8016c0:	e9 ac 00 00 00       	jmp    801771 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016cb:	0f 82 89 00 00 00    	jb     80175a <free+0xe5>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8016d9:	77 7f                	ja     80175a <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8016db:	8b 55 08             	mov    0x8(%ebp),%edx
  8016de:	a1 20 50 80 00       	mov    0x805020,%eax
  8016e3:	8b 40 78             	mov    0x78(%eax),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
  8016ea:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016ef:	c1 e8 0c             	shr    $0xc,%eax
  8016f2:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8016f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8016fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ff:	c1 e0 0c             	shl    $0xc,%eax
  801702:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801705:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80170c:	eb 42                	jmp    801750 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	c1 e0 0c             	shl    $0xc,%eax
  801714:	89 c2                	mov    %eax,%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	01 c2                	add    %eax,%edx
  80171b:	a1 20 50 80 00       	mov    0x805020,%eax
  801720:	8b 40 78             	mov    0x78(%eax),%eax
  801723:	29 c2                	sub    %eax,%edx
  801725:	89 d0                	mov    %edx,%eax
  801727:	2d 00 10 00 00       	sub    $0x1000,%eax
  80172c:	c1 e8 0c             	shr    $0xc,%eax
  80172f:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801736:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80173a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	52                   	push   %edx
  801744:	50                   	push   %eax
  801745:	e8 1a 08 00 00       	call   801f64 <sys_free_user_mem>
  80174a:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80174d:	ff 45 f4             	incl   -0xc(%ebp)
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801756:	72 b6                	jb     80170e <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801758:	eb 17                	jmp    801771 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	68 f8 43 80 00       	push   $0x8043f8
  801762:	68 87 00 00 00       	push   $0x87
  801767:	68 22 44 80 00       	push   $0x804422
  80176c:	e8 04 23 00 00       	call   803a75 <_panic>
	}
}
  801771:	90                   	nop
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 28             	sub    $0x28,%esp
  80177a:	8b 45 10             	mov    0x10(%ebp),%eax
  80177d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801780:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801784:	75 0a                	jne    801790 <smalloc+0x1c>
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	e9 87 00 00 00       	jmp    801817 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801790:	8b 45 0c             	mov    0xc(%ebp),%eax
  801793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801796:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	39 d0                	cmp    %edx,%eax
  8017a5:	73 02                	jae    8017a9 <smalloc+0x35>
  8017a7:	89 d0                	mov    %edx,%eax
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	50                   	push   %eax
  8017ad:	e8 a4 fc ff ff       	call   801456 <malloc>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017bc:	75 07                	jne    8017c5 <smalloc+0x51>
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	eb 52                	jmp    801817 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017c5:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8017cc:	50                   	push   %eax
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	e8 93 03 00 00       	call   801b6b <sys_createSharedObject>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017de:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e2:	74 06                	je     8017ea <smalloc+0x76>
  8017e4:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017e8:	75 07                	jne    8017f1 <smalloc+0x7d>
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	eb 26                	jmp    801817 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8017f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f9:	8b 40 78             	mov    0x78(%eax),%eax
  8017fc:	29 c2                	sub    %eax,%edx
  8017fe:	89 d0                	mov    %edx,%eax
  801800:	2d 00 10 00 00       	sub    $0x1000,%eax
  801805:	c1 e8 0c             	shr    $0xc,%eax
  801808:	89 c2                	mov    %eax,%edx
  80180a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801814:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 68 03 00 00       	call   801b95 <sys_getSizeOfSharedObject>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801833:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801837:	75 07                	jne    801840 <sget+0x27>
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
  80183e:	eb 7f                	jmp    8018bf <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801846:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80184d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801853:	39 d0                	cmp    %edx,%eax
  801855:	73 02                	jae    801859 <sget+0x40>
  801857:	89 d0                	mov    %edx,%eax
  801859:	83 ec 0c             	sub    $0xc,%esp
  80185c:	50                   	push   %eax
  80185d:	e8 f4 fb ff ff       	call   801456 <malloc>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801868:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80186c:	75 07                	jne    801875 <sget+0x5c>
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	eb 4a                	jmp    8018bf <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	ff 75 e8             	pushl  -0x18(%ebp)
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	ff 75 08             	pushl  0x8(%ebp)
  801881:	e8 2c 03 00 00       	call   801bb2 <sys_getSharedObject>
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80188c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80188f:	a1 20 50 80 00       	mov    0x805020,%eax
  801894:	8b 40 78             	mov    0x78(%eax),%eax
  801897:	29 c2                	sub    %eax,%edx
  801899:	89 d0                	mov    %edx,%eax
  80189b:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018a0:	c1 e8 0c             	shr    $0xc,%eax
  8018a3:	89 c2                	mov    %eax,%edx
  8018a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a8:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018af:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018b3:	75 07                	jne    8018bc <sget+0xa3>
  8018b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ba:	eb 03                	jmp    8018bf <sget+0xa6>
	return ptr;
  8018bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8018cf:	8b 40 78             	mov    0x78(%eax),%eax
  8018d2:	29 c2                	sub    %eax,%edx
  8018d4:	89 d0                	mov    %edx,%eax
  8018d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018db:	c1 e8 0c             	shr    $0xc,%eax
  8018de:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f1:	e8 db 02 00 00       	call   801bd1 <sys_freeSharedObject>
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018fc:	90                   	nop
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	68 30 44 80 00       	push   $0x804430
  80190d:	68 e4 00 00 00       	push   $0xe4
  801912:	68 22 44 80 00       	push   $0x804422
  801917:	e8 59 21 00 00       	call   803a75 <_panic>

0080191c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	68 56 44 80 00       	push   $0x804456
  80192a:	68 f0 00 00 00       	push   $0xf0
  80192f:	68 22 44 80 00       	push   $0x804422
  801934:	e8 3c 21 00 00       	call   803a75 <_panic>

00801939 <shrink>:

}
void shrink(uint32 newSize)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 56 44 80 00       	push   $0x804456
  801947:	68 f5 00 00 00       	push   $0xf5
  80194c:	68 22 44 80 00       	push   $0x804422
  801951:	e8 1f 21 00 00       	call   803a75 <_panic>

00801956 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	68 56 44 80 00       	push   $0x804456
  801964:	68 fa 00 00 00       	push   $0xfa
  801969:	68 22 44 80 00       	push   $0x804422
  80196e:	e8 02 21 00 00       	call   803a75 <_panic>

00801973 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	57                   	push   %edi
  801977:	56                   	push   %esi
  801978:	53                   	push   %ebx
  801979:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801982:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801985:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801988:	8b 7d 18             	mov    0x18(%ebp),%edi
  80198b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198e:	cd 30                	int    $0x30
  801990:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801993:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5f                   	pop    %edi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	52                   	push   %edx
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	50                   	push   %eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	e8 b2 ff ff ff       	call   801973 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 02                	push   $0x2
  8019d6:	e8 98 ff ff ff       	call   801973 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 03                	push   $0x3
  8019ef:	e8 7f ff ff ff       	call   801973 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 04                	push   $0x4
  801a09:	e8 65 ff ff ff       	call   801973 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 08                	push   $0x8
  801a27:	e8 47 ff ff ff       	call   801973 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a36:	8b 75 18             	mov    0x18(%ebp),%esi
  801a39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	56                   	push   %esi
  801a46:	53                   	push   %ebx
  801a47:	51                   	push   %ecx
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	6a 09                	push   $0x9
  801a4c:	e8 22 ff ff ff       	call   801973 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	52                   	push   %edx
  801a6b:	50                   	push   %eax
  801a6c:	6a 0a                	push   $0xa
  801a6e:	e8 00 ff ff ff       	call   801973 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	6a 0b                	push   $0xb
  801a89:	e8 e5 fe ff ff       	call   801973 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 0c                	push   $0xc
  801aa2:	e8 cc fe ff ff       	call   801973 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 0d                	push   $0xd
  801abb:	e8 b3 fe ff ff       	call   801973 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 0e                	push   $0xe
  801ad4:	e8 9a fe ff ff       	call   801973 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 0f                	push   $0xf
  801aed:	e8 81 fe ff ff       	call   801973 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	ff 75 08             	pushl  0x8(%ebp)
  801b05:	6a 10                	push   $0x10
  801b07:	e8 67 fe ff ff       	call   801973 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 11                	push   $0x11
  801b20:	e8 4e fe ff ff       	call   801973 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_cputc>:

void
sys_cputc(const char c)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	50                   	push   %eax
  801b44:	6a 01                	push   $0x1
  801b46:	e8 28 fe ff ff       	call   801973 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 14                	push   $0x14
  801b60:	e8 0e fe ff ff       	call   801973 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	8b 45 10             	mov    0x10(%ebp),%eax
  801b74:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b77:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	51                   	push   %ecx
  801b84:	52                   	push   %edx
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	50                   	push   %eax
  801b89:	6a 15                	push   $0x15
  801b8b:	e8 e3 fd ff ff       	call   801973 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	52                   	push   %edx
  801ba5:	50                   	push   %eax
  801ba6:	6a 16                	push   $0x16
  801ba8:	e8 c6 fd ff ff       	call   801973 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	51                   	push   %ecx
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 17                	push   $0x17
  801bc7:	e8 a7 fd ff ff       	call   801973 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	52                   	push   %edx
  801be1:	50                   	push   %eax
  801be2:	6a 18                	push   $0x18
  801be4:	e8 8a fd ff ff       	call   801973 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 14             	pushl  0x14(%ebp)
  801bf9:	ff 75 10             	pushl  0x10(%ebp)
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	50                   	push   %eax
  801c00:	6a 19                	push   $0x19
  801c02:	e8 6c fd ff ff       	call   801973 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	50                   	push   %eax
  801c1b:	6a 1a                	push   $0x1a
  801c1d:	e8 51 fd ff ff       	call   801973 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	50                   	push   %eax
  801c37:	6a 1b                	push   $0x1b
  801c39:	e8 35 fd ff ff       	call   801973 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 05                	push   $0x5
  801c52:	e8 1c fd ff ff       	call   801973 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 06                	push   $0x6
  801c6b:	e8 03 fd ff ff       	call   801973 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 07                	push   $0x7
  801c84:	e8 ea fc ff ff       	call   801973 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_exit_env>:


void sys_exit_env(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 1c                	push   $0x1c
  801c9d:	e8 d1 fc ff ff       	call   801973 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	90                   	nop
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb1:	8d 50 04             	lea    0x4(%eax),%edx
  801cb4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 1d                	push   $0x1d
  801cc1:	e8 ad fc ff ff       	call   801973 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ccf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd2:	89 01                	mov    %eax,(%ecx)
  801cd4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	c9                   	leave  
  801cdb:	c2 04 00             	ret    $0x4

00801cde <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	ff 75 10             	pushl  0x10(%ebp)
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	ff 75 08             	pushl  0x8(%ebp)
  801cee:	6a 13                	push   $0x13
  801cf0:	e8 7e fc ff ff       	call   801973 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_rcr2>:
uint32 sys_rcr2()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 1e                	push   $0x1e
  801d0a:	e8 64 fc ff ff       	call   801973 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d20:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	50                   	push   %eax
  801d2d:	6a 1f                	push   $0x1f
  801d2f:	e8 3f fc ff ff       	call   801973 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
	return ;
  801d37:	90                   	nop
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <rsttst>:
void rsttst()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 21                	push   $0x21
  801d49:	e8 25 fc ff ff       	call   801973 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d60:	8b 55 18             	mov    0x18(%ebp),%edx
  801d63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	ff 75 10             	pushl  0x10(%ebp)
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	ff 75 08             	pushl  0x8(%ebp)
  801d72:	6a 20                	push   $0x20
  801d74:	e8 fa fb ff ff       	call   801973 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7c:	90                   	nop
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <chktst>:
void chktst(uint32 n)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 22                	push   $0x22
  801d8f:	e8 df fb ff ff       	call   801973 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return ;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <inctst>:

void inctst()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 23                	push   $0x23
  801da9:	e8 c5 fb ff ff       	call   801973 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <gettst>:
uint32 gettst()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 24                	push   $0x24
  801dc3:	e8 ab fb ff ff       	call   801973 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801ddf:	e8 8f fb ff ff       	call   801973 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801e10:	e8 5e fb ff ff       	call   801973 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e1b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e1f:	75 07                	jne    801e28 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e21:	b8 01 00 00 00       	mov    $0x1,%eax
  801e26:	eb 05                	jmp    801e2d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801e41:	e8 2d fb ff ff       	call   801973 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
  801e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e4c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e50:	75 07                	jne    801e59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e52:	b8 01 00 00 00       	mov    $0x1,%eax
  801e57:	eb 05                	jmp    801e5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 25                	push   $0x25
  801e72:	e8 fc fa ff ff       	call   801973 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
  801e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e81:	75 07                	jne    801e8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e83:	b8 01 00 00 00       	mov    $0x1,%eax
  801e88:	eb 05                	jmp    801e8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 08             	pushl  0x8(%ebp)
  801e9f:	6a 26                	push   $0x26
  801ea1:	e8 cd fa ff ff       	call   801973 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	53                   	push   %ebx
  801ebf:	51                   	push   %ecx
  801ec0:	52                   	push   %edx
  801ec1:	50                   	push   %eax
  801ec2:	6a 27                	push   $0x27
  801ec4:	e8 aa fa ff ff       	call   801973 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	52                   	push   %edx
  801ee1:	50                   	push   %eax
  801ee2:	6a 28                	push   $0x28
  801ee4:	e8 8a fa ff ff       	call   801973 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ef1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	6a 00                	push   $0x0
  801efc:	51                   	push   %ecx
  801efd:	ff 75 10             	pushl  0x10(%ebp)
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	6a 29                	push   $0x29
  801f04:	e8 6a fa ff ff       	call   801973 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	ff 75 10             	pushl  0x10(%ebp)
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 12                	push   $0x12
  801f20:	e8 4e fa ff ff       	call   801973 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 2a                	push   $0x2a
  801f3e:	e8 30 fa ff ff       	call   801973 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
	return;
  801f46:	90                   	nop
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	50                   	push   %eax
  801f58:	6a 2b                	push   $0x2b
  801f5a:	e8 14 fa ff ff       	call   801973 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	ff 75 0c             	pushl  0xc(%ebp)
  801f70:	ff 75 08             	pushl  0x8(%ebp)
  801f73:	6a 2c                	push   $0x2c
  801f75:	e8 f9 f9 ff ff       	call   801973 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	ff 75 0c             	pushl  0xc(%ebp)
  801f8c:	ff 75 08             	pushl  0x8(%ebp)
  801f8f:	6a 2d                	push   $0x2d
  801f91:	e8 dd f9 ff ff       	call   801973 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
	return;
  801f99:	90                   	nop
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	83 e8 04             	sub    $0x4,%eax
  801fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fae:	8b 00                	mov    (%eax),%eax
  801fb0:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	83 e8 04             	sub    $0x4,%eax
  801fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	83 e0 01             	and    $0x1,%eax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	0f 94 c0             	sete   %al
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	83 f8 02             	cmp    $0x2,%eax
  801fe6:	74 2b                	je     802013 <alloc_block+0x40>
  801fe8:	83 f8 02             	cmp    $0x2,%eax
  801feb:	7f 07                	jg     801ff4 <alloc_block+0x21>
  801fed:	83 f8 01             	cmp    $0x1,%eax
  801ff0:	74 0e                	je     802000 <alloc_block+0x2d>
  801ff2:	eb 58                	jmp    80204c <alloc_block+0x79>
  801ff4:	83 f8 03             	cmp    $0x3,%eax
  801ff7:	74 2d                	je     802026 <alloc_block+0x53>
  801ff9:	83 f8 04             	cmp    $0x4,%eax
  801ffc:	74 3b                	je     802039 <alloc_block+0x66>
  801ffe:	eb 4c                	jmp    80204c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 08             	pushl  0x8(%ebp)
  802006:	e8 11 03 00 00       	call   80231c <alloc_block_FF>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802011:	eb 4a                	jmp    80205d <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	ff 75 08             	pushl  0x8(%ebp)
  802019:	e8 c7 19 00 00       	call   8039e5 <alloc_block_NF>
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802024:	eb 37                	jmp    80205d <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	ff 75 08             	pushl  0x8(%ebp)
  80202c:	e8 a7 07 00 00       	call   8027d8 <alloc_block_BF>
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802037:	eb 24                	jmp    80205d <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	e8 84 19 00 00       	call   8039c8 <alloc_block_WF>
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80204a:	eb 11                	jmp    80205d <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	68 68 44 80 00       	push   $0x804468
  802054:	e8 4d e6 ff ff       	call   8006a6 <cprintf>
  802059:	83 c4 10             	add    $0x10,%esp
		break;
  80205c:	90                   	nop
	}
	return va;
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	53                   	push   %ebx
  802066:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	68 88 44 80 00       	push   $0x804488
  802071:	e8 30 e6 ff ff       	call   8006a6 <cprintf>
  802076:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	68 b3 44 80 00       	push   $0x8044b3
  802081:	e8 20 e6 ff ff       	call   8006a6 <cprintf>
  802086:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208f:	eb 37                	jmp    8020c8 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	ff 75 f4             	pushl  -0xc(%ebp)
  802097:	e8 19 ff ff ff       	call   801fb5 <is_free_block>
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	0f be d8             	movsbl %al,%ebx
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a8:	e8 ef fe ff ff       	call   801f9c <get_block_size>
  8020ad:	83 c4 10             	add    $0x10,%esp
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	53                   	push   %ebx
  8020b4:	50                   	push   %eax
  8020b5:	68 cb 44 80 00       	push   $0x8044cb
  8020ba:	e8 e7 e5 ff ff       	call   8006a6 <cprintf>
  8020bf:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cc:	74 07                	je     8020d5 <print_blocks_list+0x73>
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 00                	mov    (%eax),%eax
  8020d3:	eb 05                	jmp    8020da <print_blocks_list+0x78>
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	89 45 10             	mov    %eax,0x10(%ebp)
  8020dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 ad                	jne    802091 <print_blocks_list+0x2f>
  8020e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e8:	75 a7                	jne    802091 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	68 88 44 80 00       	push   $0x804488
  8020f2:	e8 af e5 ff ff       	call   8006a6 <cprintf>
  8020f7:	83 c4 10             	add    $0x10,%esp

}
  8020fa:	90                   	nop
  8020fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802106:	8b 45 0c             	mov    0xc(%ebp),%eax
  802109:	83 e0 01             	and    $0x1,%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	74 03                	je     802113 <initialize_dynamic_allocator+0x13>
  802110:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802113:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802117:	0f 84 c7 01 00 00    	je     8022e4 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80211d:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802124:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802127:	8b 55 08             	mov    0x8(%ebp),%edx
  80212a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212d:	01 d0                	add    %edx,%eax
  80212f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802134:	0f 87 ad 01 00 00    	ja     8022e7 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	85 c0                	test   %eax,%eax
  80213f:	0f 89 a5 01 00 00    	jns    8022ea <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802145:	8b 55 08             	mov    0x8(%ebp),%edx
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	01 d0                	add    %edx,%eax
  80214d:	83 e8 04             	sub    $0x4,%eax
  802150:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802155:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80215c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802164:	e9 87 00 00 00       	jmp    8021f0 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802169:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216d:	75 14                	jne    802183 <initialize_dynamic_allocator+0x83>
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 e3 44 80 00       	push   $0x8044e3
  802177:	6a 79                	push   $0x79
  802179:	68 01 45 80 00       	push   $0x804501
  80217e:	e8 f2 18 00 00       	call   803a75 <_panic>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 10                	je     80219c <initialize_dynamic_allocator+0x9c>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802194:	8b 52 04             	mov    0x4(%edx),%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 0b                	jmp    8021a7 <initialize_dynamic_allocator+0xa7>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 40 04             	mov    0x4(%eax),%eax
  8021a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 04             	mov    0x4(%eax),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 0f                	je     8021c0 <initialize_dynamic_allocator+0xc0>
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 04             	mov    0x4(%eax),%eax
  8021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ba:	8b 12                	mov    (%edx),%edx
  8021bc:	89 10                	mov    %edx,(%eax)
  8021be:	eb 0a                	jmp    8021ca <initialize_dynamic_allocator+0xca>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8021e2:	48                   	dec    %eax
  8021e3:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021e8:	a1 34 50 80 00       	mov    0x805034,%eax
  8021ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f4:	74 07                	je     8021fd <initialize_dynamic_allocator+0xfd>
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	eb 05                	jmp    802202 <initialize_dynamic_allocator+0x102>
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802202:	a3 34 50 80 00       	mov    %eax,0x805034
  802207:	a1 34 50 80 00       	mov    0x805034,%eax
  80220c:	85 c0                	test   %eax,%eax
  80220e:	0f 85 55 ff ff ff    	jne    802169 <initialize_dynamic_allocator+0x69>
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802218:	0f 85 4b ff ff ff    	jne    802169 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80222d:	a1 44 50 80 00       	mov    0x805044,%eax
  802232:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802237:	a1 40 50 80 00       	mov    0x805040,%eax
  80223c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	83 c0 08             	add    $0x8,%eax
  802248:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	83 c0 04             	add    $0x4,%eax
  802251:	8b 55 0c             	mov    0xc(%ebp),%edx
  802254:	83 ea 08             	sub    $0x8,%edx
  802257:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	01 d0                	add    %edx,%eax
  802261:	83 e8 08             	sub    $0x8,%eax
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	83 ea 08             	sub    $0x8,%edx
  80226a:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80226c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80227f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802283:	75 17                	jne    80229c <initialize_dynamic_allocator+0x19c>
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	68 1c 45 80 00       	push   $0x80451c
  80228d:	68 90 00 00 00       	push   $0x90
  802292:	68 01 45 80 00       	push   $0x804501
  802297:	e8 d9 17 00 00       	call   803a75 <_panic>
  80229c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a5:	89 10                	mov    %edx,(%eax)
  8022a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022aa:	8b 00                	mov    (%eax),%eax
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	74 0d                	je     8022bd <initialize_dynamic_allocator+0x1bd>
  8022b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022b8:	89 50 04             	mov    %edx,0x4(%eax)
  8022bb:	eb 08                	jmp    8022c5 <initialize_dynamic_allocator+0x1c5>
  8022bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8022dc:	40                   	inc    %eax
  8022dd:	a3 38 50 80 00       	mov    %eax,0x805038
  8022e2:	eb 07                	jmp    8022eb <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022e4:	90                   	nop
  8022e5:	eb 04                	jmp    8022eb <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022e7:	90                   	nop
  8022e8:	eb 01                	jmp    8022eb <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022ea:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f3:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	83 e8 04             	sub    $0x4,%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	83 e0 fe             	and    $0xfffffffe,%eax
  80230c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	01 c2                	add    %eax,%edx
  802314:	8b 45 0c             	mov    0xc(%ebp),%eax
  802317:	89 02                	mov    %eax,(%edx)
}
  802319:	90                   	nop
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	83 e0 01             	and    $0x1,%eax
  802328:	85 c0                	test   %eax,%eax
  80232a:	74 03                	je     80232f <alloc_block_FF+0x13>
  80232c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80232f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802333:	77 07                	ja     80233c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802335:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80233c:	a1 24 50 80 00       	mov    0x805024,%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	75 73                	jne    8023b8 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	83 c0 10             	add    $0x10,%eax
  80234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80234e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235b:	01 d0                	add    %edx,%eax
  80235d:	48                   	dec    %eax
  80235e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802364:	ba 00 00 00 00       	mov    $0x0,%edx
  802369:	f7 75 ec             	divl   -0x14(%ebp)
  80236c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80236f:	29 d0                	sub    %edx,%eax
  802371:	c1 e8 0c             	shr    $0xc,%eax
  802374:	83 ec 0c             	sub    $0xc,%esp
  802377:	50                   	push   %eax
  802378:	e8 c3 f0 ff ff       	call   801440 <sbrk>
  80237d:	83 c4 10             	add    $0x10,%esp
  802380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802383:	83 ec 0c             	sub    $0xc,%esp
  802386:	6a 00                	push   $0x0
  802388:	e8 b3 f0 ff ff       	call   801440 <sbrk>
  80238d:	83 c4 10             	add    $0x10,%esp
  802390:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802396:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802399:	83 ec 08             	sub    $0x8,%esp
  80239c:	50                   	push   %eax
  80239d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023a0:	e8 5b fd ff ff       	call   802100 <initialize_dynamic_allocator>
  8023a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023a8:	83 ec 0c             	sub    $0xc,%esp
  8023ab:	68 3f 45 80 00       	push   $0x80453f
  8023b0:	e8 f1 e2 ff ff       	call   8006a6 <cprintf>
  8023b5:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bc:	75 0a                	jne    8023c8 <alloc_block_FF+0xac>
	        return NULL;
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c3:	e9 0e 04 00 00       	jmp    8027d6 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d7:	e9 f3 02 00 00       	jmp    8026cf <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023e2:	83 ec 0c             	sub    $0xc,%esp
  8023e5:	ff 75 bc             	pushl  -0x44(%ebp)
  8023e8:	e8 af fb ff ff       	call   801f9c <get_block_size>
  8023ed:	83 c4 10             	add    $0x10,%esp
  8023f0:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	83 c0 08             	add    $0x8,%eax
  8023f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023fc:	0f 87 c5 02 00 00    	ja     8026c7 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	83 c0 18             	add    $0x18,%eax
  802408:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80240b:	0f 87 19 02 00 00    	ja     80262a <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802411:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802414:	2b 45 08             	sub    0x8(%ebp),%eax
  802417:	83 e8 08             	sub    $0x8,%eax
  80241a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	8d 50 08             	lea    0x8(%eax),%edx
  802423:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802426:	01 d0                	add    %edx,%eax
  802428:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	83 c0 08             	add    $0x8,%eax
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	6a 01                	push   $0x1
  802436:	50                   	push   %eax
  802437:	ff 75 bc             	pushl  -0x44(%ebp)
  80243a:	e8 ae fe ff ff       	call   8022ed <set_block_data>
  80243f:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	75 68                	jne    8024b4 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80244c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802450:	75 17                	jne    802469 <alloc_block_FF+0x14d>
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	68 1c 45 80 00       	push   $0x80451c
  80245a:	68 d7 00 00 00       	push   $0xd7
  80245f:	68 01 45 80 00       	push   $0x804501
  802464:	e8 0c 16 00 00       	call   803a75 <_panic>
  802469:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80246f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802472:	89 10                	mov    %edx,(%eax)
  802474:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 0d                	je     80248a <alloc_block_FF+0x16e>
  80247d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802482:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802485:	89 50 04             	mov    %edx,0x4(%eax)
  802488:	eb 08                	jmp    802492 <alloc_block_FF+0x176>
  80248a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248d:	a3 30 50 80 00       	mov    %eax,0x805030
  802492:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802495:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80249a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a9:	40                   	inc    %eax
  8024aa:	a3 38 50 80 00       	mov    %eax,0x805038
  8024af:	e9 dc 00 00 00       	jmp    802590 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	75 65                	jne    802522 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024bd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024c1:	75 17                	jne    8024da <alloc_block_FF+0x1be>
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	68 50 45 80 00       	push   $0x804550
  8024cb:	68 db 00 00 00       	push   $0xdb
  8024d0:	68 01 45 80 00       	push   $0x804501
  8024d5:	e8 9b 15 00 00       	call   803a75 <_panic>
  8024da:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e3:	89 50 04             	mov    %edx,0x4(%eax)
  8024e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 0c                	je     8024fc <alloc_block_FF+0x1e0>
  8024f0:	a1 30 50 80 00       	mov    0x805030,%eax
  8024f5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024f8:	89 10                	mov    %edx,(%eax)
  8024fa:	eb 08                	jmp    802504 <alloc_block_FF+0x1e8>
  8024fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802504:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802507:	a3 30 50 80 00       	mov    %eax,0x805030
  80250c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802515:	a1 38 50 80 00       	mov    0x805038,%eax
  80251a:	40                   	inc    %eax
  80251b:	a3 38 50 80 00       	mov    %eax,0x805038
  802520:	eb 6e                	jmp    802590 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802526:	74 06                	je     80252e <alloc_block_FF+0x212>
  802528:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80252c:	75 17                	jne    802545 <alloc_block_FF+0x229>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 74 45 80 00       	push   $0x804574
  802536:	68 df 00 00 00       	push   $0xdf
  80253b:	68 01 45 80 00       	push   $0x804501
  802540:	e8 30 15 00 00       	call   803a75 <_panic>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 10                	mov    (%eax),%edx
  80254a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254d:	89 10                	mov    %edx,(%eax)
  80254f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	85 c0                	test   %eax,%eax
  802556:	74 0b                	je     802563 <alloc_block_FF+0x247>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802560:	89 50 04             	mov    %edx,0x4(%eax)
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802569:	89 10                	mov    %edx,(%eax)
  80256b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802571:	89 50 04             	mov    %edx,0x4(%eax)
  802574:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	75 08                	jne    802585 <alloc_block_FF+0x269>
  80257d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802580:	a3 30 50 80 00       	mov    %eax,0x805030
  802585:	a1 38 50 80 00       	mov    0x805038,%eax
  80258a:	40                   	inc    %eax
  80258b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802594:	75 17                	jne    8025ad <alloc_block_FF+0x291>
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 e3 44 80 00       	push   $0x8044e3
  80259e:	68 e1 00 00 00       	push   $0xe1
  8025a3:	68 01 45 80 00       	push   $0x804501
  8025a8:	e8 c8 14 00 00       	call   803a75 <_panic>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 10                	je     8025c6 <alloc_block_FF+0x2aa>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025be:	8b 52 04             	mov    0x4(%edx),%edx
  8025c1:	89 50 04             	mov    %edx,0x4(%eax)
  8025c4:	eb 0b                	jmp    8025d1 <alloc_block_FF+0x2b5>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 04             	mov    0x4(%eax),%eax
  8025cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 0f                	je     8025ea <alloc_block_FF+0x2ce>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e4:	8b 12                	mov    (%edx),%edx
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	eb 0a                	jmp    8025f4 <alloc_block_FF+0x2d8>
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802607:	a1 38 50 80 00       	mov    0x805038,%eax
  80260c:	48                   	dec    %eax
  80260d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802612:	83 ec 04             	sub    $0x4,%esp
  802615:	6a 00                	push   $0x0
  802617:	ff 75 b4             	pushl  -0x4c(%ebp)
  80261a:	ff 75 b0             	pushl  -0x50(%ebp)
  80261d:	e8 cb fc ff ff       	call   8022ed <set_block_data>
  802622:	83 c4 10             	add    $0x10,%esp
  802625:	e9 95 00 00 00       	jmp    8026bf <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80262a:	83 ec 04             	sub    $0x4,%esp
  80262d:	6a 01                	push   $0x1
  80262f:	ff 75 b8             	pushl  -0x48(%ebp)
  802632:	ff 75 bc             	pushl  -0x44(%ebp)
  802635:	e8 b3 fc ff ff       	call   8022ed <set_block_data>
  80263a:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80263d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802641:	75 17                	jne    80265a <alloc_block_FF+0x33e>
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	68 e3 44 80 00       	push   $0x8044e3
  80264b:	68 e8 00 00 00       	push   $0xe8
  802650:	68 01 45 80 00       	push   $0x804501
  802655:	e8 1b 14 00 00       	call   803a75 <_panic>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	85 c0                	test   %eax,%eax
  802661:	74 10                	je     802673 <alloc_block_FF+0x357>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266b:	8b 52 04             	mov    0x4(%edx),%edx
  80266e:	89 50 04             	mov    %edx,0x4(%eax)
  802671:	eb 0b                	jmp    80267e <alloc_block_FF+0x362>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 04             	mov    0x4(%eax),%eax
  802679:	a3 30 50 80 00       	mov    %eax,0x805030
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	74 0f                	je     802697 <alloc_block_FF+0x37b>
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802691:	8b 12                	mov    (%edx),%edx
  802693:	89 10                	mov    %edx,(%eax)
  802695:	eb 0a                	jmp    8026a1 <alloc_block_FF+0x385>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b9:	48                   	dec    %eax
  8026ba:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026c2:	e9 0f 01 00 00       	jmp    8027d6 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8026cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d3:	74 07                	je     8026dc <alloc_block_FF+0x3c0>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	eb 05                	jmp    8026e1 <alloc_block_FF+0x3c5>
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8026e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	0f 85 e9 fc ff ff    	jne    8023dc <alloc_block_FF+0xc0>
  8026f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f7:	0f 85 df fc ff ff    	jne    8023dc <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	83 c0 08             	add    $0x8,%eax
  802703:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802706:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80270d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802710:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802713:	01 d0                	add    %edx,%eax
  802715:	48                   	dec    %eax
  802716:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802719:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271c:	ba 00 00 00 00       	mov    $0x0,%edx
  802721:	f7 75 d8             	divl   -0x28(%ebp)
  802724:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802727:	29 d0                	sub    %edx,%eax
  802729:	c1 e8 0c             	shr    $0xc,%eax
  80272c:	83 ec 0c             	sub    $0xc,%esp
  80272f:	50                   	push   %eax
  802730:	e8 0b ed ff ff       	call   801440 <sbrk>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80273b:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80273f:	75 0a                	jne    80274b <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	e9 8b 00 00 00       	jmp    8027d6 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80274b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802752:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802755:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802758:	01 d0                	add    %edx,%eax
  80275a:	48                   	dec    %eax
  80275b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80275e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802761:	ba 00 00 00 00       	mov    $0x0,%edx
  802766:	f7 75 cc             	divl   -0x34(%ebp)
  802769:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80276c:	29 d0                	sub    %edx,%eax
  80276e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802771:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802774:	01 d0                	add    %edx,%eax
  802776:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80277b:	a1 40 50 80 00       	mov    0x805040,%eax
  802780:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802786:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80278d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802790:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802793:	01 d0                	add    %edx,%eax
  802795:	48                   	dec    %eax
  802796:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802799:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80279c:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a1:	f7 75 c4             	divl   -0x3c(%ebp)
  8027a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027a7:	29 d0                	sub    %edx,%eax
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	6a 01                	push   $0x1
  8027ae:	50                   	push   %eax
  8027af:	ff 75 d0             	pushl  -0x30(%ebp)
  8027b2:	e8 36 fb ff ff       	call   8022ed <set_block_data>
  8027b7:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	ff 75 d0             	pushl  -0x30(%ebp)
  8027c0:	e8 f8 09 00 00       	call   8031bd <free_block>
  8027c5:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	ff 75 08             	pushl  0x8(%ebp)
  8027ce:	e8 49 fb ff ff       	call   80231c <alloc_block_FF>
  8027d3:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	83 e0 01             	and    $0x1,%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 03                	je     8027eb <alloc_block_BF+0x13>
  8027e8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027eb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027ef:	77 07                	ja     8027f8 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027f1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 73                	jne    802874 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	83 c0 10             	add    $0x10,%eax
  802807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80280a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802811:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802814:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802817:	01 d0                	add    %edx,%eax
  802819:	48                   	dec    %eax
  80281a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80281d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802820:	ba 00 00 00 00       	mov    $0x0,%edx
  802825:	f7 75 e0             	divl   -0x20(%ebp)
  802828:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80282b:	29 d0                	sub    %edx,%eax
  80282d:	c1 e8 0c             	shr    $0xc,%eax
  802830:	83 ec 0c             	sub    $0xc,%esp
  802833:	50                   	push   %eax
  802834:	e8 07 ec ff ff       	call   801440 <sbrk>
  802839:	83 c4 10             	add    $0x10,%esp
  80283c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	6a 00                	push   $0x0
  802844:	e8 f7 eb ff ff       	call   801440 <sbrk>
  802849:	83 c4 10             	add    $0x10,%esp
  80284c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80284f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802852:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802855:	83 ec 08             	sub    $0x8,%esp
  802858:	50                   	push   %eax
  802859:	ff 75 d8             	pushl  -0x28(%ebp)
  80285c:	e8 9f f8 ff ff       	call   802100 <initialize_dynamic_allocator>
  802861:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	68 3f 45 80 00       	push   $0x80453f
  80286c:	e8 35 de ff ff       	call   8006a6 <cprintf>
  802871:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80287b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802882:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802889:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802890:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802898:	e9 1d 01 00 00       	jmp    8029ba <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	ff 75 a8             	pushl  -0x58(%ebp)
  8028a9:	e8 ee f6 ff ff       	call   801f9c <get_block_size>
  8028ae:	83 c4 10             	add    $0x10,%esp
  8028b1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	83 c0 08             	add    $0x8,%eax
  8028ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028bd:	0f 87 ef 00 00 00    	ja     8029b2 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	83 c0 18             	add    $0x18,%eax
  8028c9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028cc:	77 1d                	ja     8028eb <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d4:	0f 86 d8 00 00 00    	jbe    8029b2 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028e0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028e6:	e9 c7 00 00 00       	jmp    8029b2 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	83 c0 08             	add    $0x8,%eax
  8028f1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028f4:	0f 85 9d 00 00 00    	jne    802997 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	6a 01                	push   $0x1
  8028ff:	ff 75 a4             	pushl  -0x5c(%ebp)
  802902:	ff 75 a8             	pushl  -0x58(%ebp)
  802905:	e8 e3 f9 ff ff       	call   8022ed <set_block_data>
  80290a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80290d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802911:	75 17                	jne    80292a <alloc_block_BF+0x152>
  802913:	83 ec 04             	sub    $0x4,%esp
  802916:	68 e3 44 80 00       	push   $0x8044e3
  80291b:	68 2c 01 00 00       	push   $0x12c
  802920:	68 01 45 80 00       	push   $0x804501
  802925:	e8 4b 11 00 00       	call   803a75 <_panic>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 10                	je     802943 <alloc_block_BF+0x16b>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293b:	8b 52 04             	mov    0x4(%edx),%edx
  80293e:	89 50 04             	mov    %edx,0x4(%eax)
  802941:	eb 0b                	jmp    80294e <alloc_block_BF+0x176>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	a3 30 50 80 00       	mov    %eax,0x805030
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 40 04             	mov    0x4(%eax),%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	74 0f                	je     802967 <alloc_block_BF+0x18f>
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 04             	mov    0x4(%eax),%eax
  80295e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802961:	8b 12                	mov    (%edx),%edx
  802963:	89 10                	mov    %edx,(%eax)
  802965:	eb 0a                	jmp    802971 <alloc_block_BF+0x199>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802984:	a1 38 50 80 00       	mov    0x805038,%eax
  802989:	48                   	dec    %eax
  80298a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80298f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802992:	e9 01 04 00 00       	jmp    802d98 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80299d:	76 13                	jbe    8029b2 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80299f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029af:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8029b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029be:	74 07                	je     8029c7 <alloc_block_BF+0x1ef>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	eb 05                	jmp    8029cc <alloc_block_BF+0x1f4>
  8029c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cc:	a3 34 50 80 00       	mov    %eax,0x805034
  8029d1:	a1 34 50 80 00       	mov    0x805034,%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	0f 85 bf fe ff ff    	jne    80289d <alloc_block_BF+0xc5>
  8029de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e2:	0f 85 b5 fe ff ff    	jne    80289d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ec:	0f 84 26 02 00 00    	je     802c18 <alloc_block_BF+0x440>
  8029f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f6:	0f 85 1c 02 00 00    	jne    802c18 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ff:	2b 45 08             	sub    0x8(%ebp),%eax
  802a02:	83 e8 08             	sub    $0x8,%eax
  802a05:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	8d 50 08             	lea    0x8(%eax),%edx
  802a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a11:	01 d0                	add    %edx,%eax
  802a13:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	83 c0 08             	add    $0x8,%eax
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	6a 01                	push   $0x1
  802a21:	50                   	push   %eax
  802a22:	ff 75 f0             	pushl  -0x10(%ebp)
  802a25:	e8 c3 f8 ff ff       	call   8022ed <set_block_data>
  802a2a:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	75 68                	jne    802a9f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a37:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a3b:	75 17                	jne    802a54 <alloc_block_BF+0x27c>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 1c 45 80 00       	push   $0x80451c
  802a45:	68 45 01 00 00       	push   $0x145
  802a4a:	68 01 45 80 00       	push   $0x804501
  802a4f:	e8 21 10 00 00       	call   803a75 <_panic>
  802a54:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5d:	89 10                	mov    %edx,(%eax)
  802a5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	74 0d                	je     802a75 <alloc_block_BF+0x29d>
  802a68:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a6d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a70:	89 50 04             	mov    %edx,0x4(%eax)
  802a73:	eb 08                	jmp    802a7d <alloc_block_BF+0x2a5>
  802a75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a78:	a3 30 50 80 00       	mov    %eax,0x805030
  802a7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a80:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a94:	40                   	inc    %eax
  802a95:	a3 38 50 80 00       	mov    %eax,0x805038
  802a9a:	e9 dc 00 00 00       	jmp    802b7b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	75 65                	jne    802b0d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802aa8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aac:	75 17                	jne    802ac5 <alloc_block_BF+0x2ed>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 50 45 80 00       	push   $0x804550
  802ab6:	68 4a 01 00 00       	push   $0x14a
  802abb:	68 01 45 80 00       	push   $0x804501
  802ac0:	e8 b0 0f 00 00       	call   803a75 <_panic>
  802ac5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802acb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad4:	8b 40 04             	mov    0x4(%eax),%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	74 0c                	je     802ae7 <alloc_block_BF+0x30f>
  802adb:	a1 30 50 80 00       	mov    0x805030,%eax
  802ae0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae3:	89 10                	mov    %edx,(%eax)
  802ae5:	eb 08                	jmp    802aef <alloc_block_BF+0x317>
  802ae7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af2:	a3 30 50 80 00       	mov    %eax,0x805030
  802af7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b00:	a1 38 50 80 00       	mov    0x805038,%eax
  802b05:	40                   	inc    %eax
  802b06:	a3 38 50 80 00       	mov    %eax,0x805038
  802b0b:	eb 6e                	jmp    802b7b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b11:	74 06                	je     802b19 <alloc_block_BF+0x341>
  802b13:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b17:	75 17                	jne    802b30 <alloc_block_BF+0x358>
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	68 74 45 80 00       	push   $0x804574
  802b21:	68 4f 01 00 00       	push   $0x14f
  802b26:	68 01 45 80 00       	push   $0x804501
  802b2b:	e8 45 0f 00 00       	call   803a75 <_panic>
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 10                	mov    (%eax),%edx
  802b35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b38:	89 10                	mov    %edx,(%eax)
  802b3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 0b                	je     802b4e <alloc_block_BF+0x376>
  802b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	75 08                	jne    802b70 <alloc_block_BF+0x398>
  802b68:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b70:	a1 38 50 80 00       	mov    0x805038,%eax
  802b75:	40                   	inc    %eax
  802b76:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7f:	75 17                	jne    802b98 <alloc_block_BF+0x3c0>
  802b81:	83 ec 04             	sub    $0x4,%esp
  802b84:	68 e3 44 80 00       	push   $0x8044e3
  802b89:	68 51 01 00 00       	push   $0x151
  802b8e:	68 01 45 80 00       	push   $0x804501
  802b93:	e8 dd 0e 00 00       	call   803a75 <_panic>
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	74 10                	je     802bb1 <alloc_block_BF+0x3d9>
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba9:	8b 52 04             	mov    0x4(%edx),%edx
  802bac:	89 50 04             	mov    %edx,0x4(%eax)
  802baf:	eb 0b                	jmp    802bbc <alloc_block_BF+0x3e4>
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	8b 40 04             	mov    0x4(%eax),%eax
  802bb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	74 0f                	je     802bd5 <alloc_block_BF+0x3fd>
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	8b 40 04             	mov    0x4(%eax),%eax
  802bcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcf:	8b 12                	mov    (%edx),%edx
  802bd1:	89 10                	mov    %edx,(%eax)
  802bd3:	eb 0a                	jmp    802bdf <alloc_block_BF+0x407>
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf2:	a1 38 50 80 00       	mov    0x805038,%eax
  802bf7:	48                   	dec    %eax
  802bf8:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bfd:	83 ec 04             	sub    $0x4,%esp
  802c00:	6a 00                	push   $0x0
  802c02:	ff 75 d0             	pushl  -0x30(%ebp)
  802c05:	ff 75 cc             	pushl  -0x34(%ebp)
  802c08:	e8 e0 f6 ff ff       	call   8022ed <set_block_data>
  802c0d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	e9 80 01 00 00       	jmp    802d98 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802c18:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c1c:	0f 85 9d 00 00 00    	jne    802cbf <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	6a 01                	push   $0x1
  802c27:	ff 75 ec             	pushl  -0x14(%ebp)
  802c2a:	ff 75 f0             	pushl  -0x10(%ebp)
  802c2d:	e8 bb f6 ff ff       	call   8022ed <set_block_data>
  802c32:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c39:	75 17                	jne    802c52 <alloc_block_BF+0x47a>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 e3 44 80 00       	push   $0x8044e3
  802c43:	68 58 01 00 00       	push   $0x158
  802c48:	68 01 45 80 00       	push   $0x804501
  802c4d:	e8 23 0e 00 00       	call   803a75 <_panic>
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 10                	je     802c6b <alloc_block_BF+0x493>
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c63:	8b 52 04             	mov    0x4(%edx),%edx
  802c66:	89 50 04             	mov    %edx,0x4(%eax)
  802c69:	eb 0b                	jmp    802c76 <alloc_block_BF+0x49e>
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	a3 30 50 80 00       	mov    %eax,0x805030
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0f                	je     802c8f <alloc_block_BF+0x4b7>
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c89:	8b 12                	mov    (%edx),%edx
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	eb 0a                	jmp    802c99 <alloc_block_BF+0x4c1>
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cac:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb1:	48                   	dec    %eax
  802cb2:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cba:	e9 d9 00 00 00       	jmp    802d98 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	83 c0 08             	add    $0x8,%eax
  802cc5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cc8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ccf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cd2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cd5:	01 d0                	add    %edx,%eax
  802cd7:	48                   	dec    %eax
  802cd8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cdb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cde:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce3:	f7 75 c4             	divl   -0x3c(%ebp)
  802ce6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ce9:	29 d0                	sub    %edx,%eax
  802ceb:	c1 e8 0c             	shr    $0xc,%eax
  802cee:	83 ec 0c             	sub    $0xc,%esp
  802cf1:	50                   	push   %eax
  802cf2:	e8 49 e7 ff ff       	call   801440 <sbrk>
  802cf7:	83 c4 10             	add    $0x10,%esp
  802cfa:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cfd:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d01:	75 0a                	jne    802d0d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
  802d08:	e9 8b 00 00 00       	jmp    802d98 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d0d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d14:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d17:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d1a:	01 d0                	add    %edx,%eax
  802d1c:	48                   	dec    %eax
  802d1d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d20:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d23:	ba 00 00 00 00       	mov    $0x0,%edx
  802d28:	f7 75 b8             	divl   -0x48(%ebp)
  802d2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d2e:	29 d0                	sub    %edx,%eax
  802d30:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d33:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d36:	01 d0                	add    %edx,%eax
  802d38:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d3d:	a1 40 50 80 00       	mov    0x805040,%eax
  802d42:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d48:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d4f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d52:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d55:	01 d0                	add    %edx,%eax
  802d57:	48                   	dec    %eax
  802d58:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d5b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d63:	f7 75 b0             	divl   -0x50(%ebp)
  802d66:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d69:	29 d0                	sub    %edx,%eax
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	6a 01                	push   $0x1
  802d70:	50                   	push   %eax
  802d71:	ff 75 bc             	pushl  -0x44(%ebp)
  802d74:	e8 74 f5 ff ff       	call   8022ed <set_block_data>
  802d79:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d7c:	83 ec 0c             	sub    $0xc,%esp
  802d7f:	ff 75 bc             	pushl  -0x44(%ebp)
  802d82:	e8 36 04 00 00       	call   8031bd <free_block>
  802d87:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	ff 75 08             	pushl  0x8(%ebp)
  802d90:	e8 43 fa ff ff       	call   8027d8 <alloc_block_BF>
  802d95:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d98:	c9                   	leave  
  802d99:	c3                   	ret    

00802d9a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d9a:	55                   	push   %ebp
  802d9b:	89 e5                	mov    %esp,%ebp
  802d9d:	53                   	push   %ebx
  802d9e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802da1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802da8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802daf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db3:	74 1e                	je     802dd3 <merging+0x39>
  802db5:	ff 75 08             	pushl  0x8(%ebp)
  802db8:	e8 df f1 ff ff       	call   801f9c <get_block_size>
  802dbd:	83 c4 04             	add    $0x4,%esp
  802dc0:	89 c2                	mov    %eax,%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	01 d0                	add    %edx,%eax
  802dc7:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dca:	75 07                	jne    802dd3 <merging+0x39>
		prev_is_free = 1;
  802dcc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd7:	74 1e                	je     802df7 <merging+0x5d>
  802dd9:	ff 75 10             	pushl  0x10(%ebp)
  802ddc:	e8 bb f1 ff ff       	call   801f9c <get_block_size>
  802de1:	83 c4 04             	add    $0x4,%esp
  802de4:	89 c2                	mov    %eax,%edx
  802de6:	8b 45 10             	mov    0x10(%ebp),%eax
  802de9:	01 d0                	add    %edx,%eax
  802deb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dee:	75 07                	jne    802df7 <merging+0x5d>
		next_is_free = 1;
  802df0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	0f 84 cc 00 00 00    	je     802ecd <merging+0x133>
  802e01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e05:	0f 84 c2 00 00 00    	je     802ecd <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e0b:	ff 75 08             	pushl  0x8(%ebp)
  802e0e:	e8 89 f1 ff ff       	call   801f9c <get_block_size>
  802e13:	83 c4 04             	add    $0x4,%esp
  802e16:	89 c3                	mov    %eax,%ebx
  802e18:	ff 75 10             	pushl  0x10(%ebp)
  802e1b:	e8 7c f1 ff ff       	call   801f9c <get_block_size>
  802e20:	83 c4 04             	add    $0x4,%esp
  802e23:	01 c3                	add    %eax,%ebx
  802e25:	ff 75 0c             	pushl  0xc(%ebp)
  802e28:	e8 6f f1 ff ff       	call   801f9c <get_block_size>
  802e2d:	83 c4 04             	add    $0x4,%esp
  802e30:	01 d8                	add    %ebx,%eax
  802e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e35:	6a 00                	push   $0x0
  802e37:	ff 75 ec             	pushl  -0x14(%ebp)
  802e3a:	ff 75 08             	pushl  0x8(%ebp)
  802e3d:	e8 ab f4 ff ff       	call   8022ed <set_block_data>
  802e42:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e49:	75 17                	jne    802e62 <merging+0xc8>
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	68 e3 44 80 00       	push   $0x8044e3
  802e53:	68 7d 01 00 00       	push   $0x17d
  802e58:	68 01 45 80 00       	push   $0x804501
  802e5d:	e8 13 0c 00 00       	call   803a75 <_panic>
  802e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 10                	je     802e7b <merging+0xe1>
  802e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e73:	8b 52 04             	mov    0x4(%edx),%edx
  802e76:	89 50 04             	mov    %edx,0x4(%eax)
  802e79:	eb 0b                	jmp    802e86 <merging+0xec>
  802e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	a3 30 50 80 00       	mov    %eax,0x805030
  802e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 0f                	je     802e9f <merging+0x105>
  802e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e99:	8b 12                	mov    (%edx),%edx
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	eb 0a                	jmp    802ea9 <merging+0x10f>
  802e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebc:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec1:	48                   	dec    %eax
  802ec2:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ec7:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec8:	e9 ea 02 00 00       	jmp    8031b7 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ecd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed1:	74 3b                	je     802f0e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ed3:	83 ec 0c             	sub    $0xc,%esp
  802ed6:	ff 75 08             	pushl  0x8(%ebp)
  802ed9:	e8 be f0 ff ff       	call   801f9c <get_block_size>
  802ede:	83 c4 10             	add    $0x10,%esp
  802ee1:	89 c3                	mov    %eax,%ebx
  802ee3:	83 ec 0c             	sub    $0xc,%esp
  802ee6:	ff 75 10             	pushl  0x10(%ebp)
  802ee9:	e8 ae f0 ff ff       	call   801f9c <get_block_size>
  802eee:	83 c4 10             	add    $0x10,%esp
  802ef1:	01 d8                	add    %ebx,%eax
  802ef3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	6a 00                	push   $0x0
  802efb:	ff 75 e8             	pushl  -0x18(%ebp)
  802efe:	ff 75 08             	pushl  0x8(%ebp)
  802f01:	e8 e7 f3 ff ff       	call   8022ed <set_block_data>
  802f06:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f09:	e9 a9 02 00 00       	jmp    8031b7 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f12:	0f 84 2d 01 00 00    	je     803045 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f18:	83 ec 0c             	sub    $0xc,%esp
  802f1b:	ff 75 10             	pushl  0x10(%ebp)
  802f1e:	e8 79 f0 ff ff       	call   801f9c <get_block_size>
  802f23:	83 c4 10             	add    $0x10,%esp
  802f26:	89 c3                	mov    %eax,%ebx
  802f28:	83 ec 0c             	sub    $0xc,%esp
  802f2b:	ff 75 0c             	pushl  0xc(%ebp)
  802f2e:	e8 69 f0 ff ff       	call   801f9c <get_block_size>
  802f33:	83 c4 10             	add    $0x10,%esp
  802f36:	01 d8                	add    %ebx,%eax
  802f38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f3b:	83 ec 04             	sub    $0x4,%esp
  802f3e:	6a 00                	push   $0x0
  802f40:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f43:	ff 75 10             	pushl  0x10(%ebp)
  802f46:	e8 a2 f3 ff ff       	call   8022ed <set_block_data>
  802f4b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f51:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f58:	74 06                	je     802f60 <merging+0x1c6>
  802f5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f5e:	75 17                	jne    802f77 <merging+0x1dd>
  802f60:	83 ec 04             	sub    $0x4,%esp
  802f63:	68 a8 45 80 00       	push   $0x8045a8
  802f68:	68 8d 01 00 00       	push   $0x18d
  802f6d:	68 01 45 80 00       	push   $0x804501
  802f72:	e8 fe 0a 00 00       	call   803a75 <_panic>
  802f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7a:	8b 50 04             	mov    0x4(%eax),%edx
  802f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f80:	89 50 04             	mov    %edx,0x4(%eax)
  802f83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f89:	89 10                	mov    %edx,(%eax)
  802f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8e:	8b 40 04             	mov    0x4(%eax),%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	74 0d                	je     802fa2 <merging+0x208>
  802f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f98:	8b 40 04             	mov    0x4(%eax),%eax
  802f9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	eb 08                	jmp    802faa <merging+0x210>
  802fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb8:	40                   	inc    %eax
  802fb9:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc2:	75 17                	jne    802fdb <merging+0x241>
  802fc4:	83 ec 04             	sub    $0x4,%esp
  802fc7:	68 e3 44 80 00       	push   $0x8044e3
  802fcc:	68 8e 01 00 00       	push   $0x18e
  802fd1:	68 01 45 80 00       	push   $0x804501
  802fd6:	e8 9a 0a 00 00       	call   803a75 <_panic>
  802fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	85 c0                	test   %eax,%eax
  802fe2:	74 10                	je     802ff4 <merging+0x25a>
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fec:	8b 52 04             	mov    0x4(%edx),%edx
  802fef:	89 50 04             	mov    %edx,0x4(%eax)
  802ff2:	eb 0b                	jmp    802fff <merging+0x265>
  802ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff7:	8b 40 04             	mov    0x4(%eax),%eax
  802ffa:	a3 30 50 80 00       	mov    %eax,0x805030
  802fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0f                	je     803018 <merging+0x27e>
  803009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300c:	8b 40 04             	mov    0x4(%eax),%eax
  80300f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803012:	8b 12                	mov    (%edx),%edx
  803014:	89 10                	mov    %edx,(%eax)
  803016:	eb 0a                	jmp    803022 <merging+0x288>
  803018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803022:	8b 45 0c             	mov    0xc(%ebp),%eax
  803025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803035:	a1 38 50 80 00       	mov    0x805038,%eax
  80303a:	48                   	dec    %eax
  80303b:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803040:	e9 72 01 00 00       	jmp    8031b7 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803045:	8b 45 10             	mov    0x10(%ebp),%eax
  803048:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80304b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304f:	74 79                	je     8030ca <merging+0x330>
  803051:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803055:	74 73                	je     8030ca <merging+0x330>
  803057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305b:	74 06                	je     803063 <merging+0x2c9>
  80305d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803061:	75 17                	jne    80307a <merging+0x2e0>
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	68 74 45 80 00       	push   $0x804574
  80306b:	68 94 01 00 00       	push   $0x194
  803070:	68 01 45 80 00       	push   $0x804501
  803075:	e8 fb 09 00 00       	call   803a75 <_panic>
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 10                	mov    (%eax),%edx
  80307f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803082:	89 10                	mov    %edx,(%eax)
  803084:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 0b                	je     803098 <merging+0x2fe>
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80309e:	89 10                	mov    %edx,(%eax)
  8030a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a6:	89 50 04             	mov    %edx,0x4(%eax)
  8030a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	75 08                	jne    8030ba <merging+0x320>
  8030b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8030bf:	40                   	inc    %eax
  8030c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8030c5:	e9 ce 00 00 00       	jmp    803198 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ce:	74 65                	je     803135 <merging+0x39b>
  8030d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030d4:	75 17                	jne    8030ed <merging+0x353>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 50 45 80 00       	push   $0x804550
  8030de:	68 95 01 00 00       	push   $0x195
  8030e3:	68 01 45 80 00       	push   $0x804501
  8030e8:	e8 88 09 00 00       	call   803a75 <_panic>
  8030ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f6:	89 50 04             	mov    %edx,0x4(%eax)
  8030f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0c                	je     80310f <merging+0x375>
  803103:	a1 30 50 80 00       	mov    0x805030,%eax
  803108:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80310b:	89 10                	mov    %edx,(%eax)
  80310d:	eb 08                	jmp    803117 <merging+0x37d>
  80310f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803112:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803117:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311a:	a3 30 50 80 00       	mov    %eax,0x805030
  80311f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803128:	a1 38 50 80 00       	mov    0x805038,%eax
  80312d:	40                   	inc    %eax
  80312e:	a3 38 50 80 00       	mov    %eax,0x805038
  803133:	eb 63                	jmp    803198 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803135:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803139:	75 17                	jne    803152 <merging+0x3b8>
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	68 1c 45 80 00       	push   $0x80451c
  803143:	68 98 01 00 00       	push   $0x198
  803148:	68 01 45 80 00       	push   $0x804501
  80314d:	e8 23 09 00 00       	call   803a75 <_panic>
  803152:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803158:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315b:	89 10                	mov    %edx,(%eax)
  80315d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	74 0d                	je     803173 <merging+0x3d9>
  803166:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80316b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	eb 08                	jmp    80317b <merging+0x3e1>
  803173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803176:	a3 30 50 80 00       	mov    %eax,0x805030
  80317b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803183:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318d:	a1 38 50 80 00       	mov    0x805038,%eax
  803192:	40                   	inc    %eax
  803193:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803198:	83 ec 0c             	sub    $0xc,%esp
  80319b:	ff 75 10             	pushl  0x10(%ebp)
  80319e:	e8 f9 ed ff ff       	call   801f9c <get_block_size>
  8031a3:	83 c4 10             	add    $0x10,%esp
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	6a 00                	push   $0x0
  8031ab:	50                   	push   %eax
  8031ac:	ff 75 10             	pushl  0x10(%ebp)
  8031af:	e8 39 f1 ff ff       	call   8022ed <set_block_data>
  8031b4:	83 c4 10             	add    $0x10,%esp
	}
}
  8031b7:	90                   	nop
  8031b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031bb:	c9                   	leave  
  8031bc:	c3                   	ret    

008031bd <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031bd:	55                   	push   %ebp
  8031be:	89 e5                	mov    %esp,%ebp
  8031c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031c3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031cb:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d3:	73 1b                	jae    8031f0 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031d5:	a1 30 50 80 00       	mov    0x805030,%eax
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	ff 75 08             	pushl  0x8(%ebp)
  8031e0:	6a 00                	push   $0x0
  8031e2:	50                   	push   %eax
  8031e3:	e8 b2 fb ff ff       	call   802d9a <merging>
  8031e8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031eb:	e9 8b 00 00 00       	jmp    80327b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f8:	76 18                	jbe    803212 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	ff 75 08             	pushl  0x8(%ebp)
  803205:	50                   	push   %eax
  803206:	6a 00                	push   $0x0
  803208:	e8 8d fb ff ff       	call   802d9a <merging>
  80320d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803210:	eb 69                	jmp    80327b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803212:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321a:	eb 39                	jmp    803255 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803222:	73 29                	jae    80324d <free_block+0x90>
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	3b 45 08             	cmp    0x8(%ebp),%eax
  80322c:	76 1f                	jbe    80324d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	ff 75 08             	pushl  0x8(%ebp)
  80323c:	ff 75 f0             	pushl  -0x10(%ebp)
  80323f:	ff 75 f4             	pushl  -0xc(%ebp)
  803242:	e8 53 fb ff ff       	call   802d9a <merging>
  803247:	83 c4 10             	add    $0x10,%esp
			break;
  80324a:	90                   	nop
		}
	}
}
  80324b:	eb 2e                	jmp    80327b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80324d:	a1 34 50 80 00       	mov    0x805034,%eax
  803252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803259:	74 07                	je     803262 <free_block+0xa5>
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	eb 05                	jmp    803267 <free_block+0xaa>
  803262:	b8 00 00 00 00       	mov    $0x0,%eax
  803267:	a3 34 50 80 00       	mov    %eax,0x805034
  80326c:	a1 34 50 80 00       	mov    0x805034,%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	75 a7                	jne    80321c <free_block+0x5f>
  803275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803279:	75 a1                	jne    80321c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80327b:	90                   	nop
  80327c:	c9                   	leave  
  80327d:	c3                   	ret    

0080327e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80327e:	55                   	push   %ebp
  80327f:	89 e5                	mov    %esp,%ebp
  803281:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803284:	ff 75 08             	pushl  0x8(%ebp)
  803287:	e8 10 ed ff ff       	call   801f9c <get_block_size>
  80328c:	83 c4 04             	add    $0x4,%esp
  80328f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803292:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803299:	eb 17                	jmp    8032b2 <copy_data+0x34>
  80329b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80329e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a1:	01 c2                	add    %eax,%edx
  8032a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	01 c8                	add    %ecx,%eax
  8032ab:	8a 00                	mov    (%eax),%al
  8032ad:	88 02                	mov    %al,(%edx)
  8032af:	ff 45 fc             	incl   -0x4(%ebp)
  8032b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032b8:	72 e1                	jb     80329b <copy_data+0x1d>
}
  8032ba:	90                   	nop
  8032bb:	c9                   	leave  
  8032bc:	c3                   	ret    

008032bd <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032bd:	55                   	push   %ebp
  8032be:	89 e5                	mov    %esp,%ebp
  8032c0:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c7:	75 23                	jne    8032ec <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032cd:	74 13                	je     8032e2 <realloc_block_FF+0x25>
  8032cf:	83 ec 0c             	sub    $0xc,%esp
  8032d2:	ff 75 0c             	pushl  0xc(%ebp)
  8032d5:	e8 42 f0 ff ff       	call   80231c <alloc_block_FF>
  8032da:	83 c4 10             	add    $0x10,%esp
  8032dd:	e9 e4 06 00 00       	jmp    8039c6 <realloc_block_FF+0x709>
		return NULL;
  8032e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e7:	e9 da 06 00 00       	jmp    8039c6 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8032ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032f0:	75 18                	jne    80330a <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032f2:	83 ec 0c             	sub    $0xc,%esp
  8032f5:	ff 75 08             	pushl  0x8(%ebp)
  8032f8:	e8 c0 fe ff ff       	call   8031bd <free_block>
  8032fd:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803300:	b8 00 00 00 00       	mov    $0x0,%eax
  803305:	e9 bc 06 00 00       	jmp    8039c6 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80330a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80330e:	77 07                	ja     803317 <realloc_block_FF+0x5a>
  803310:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331a:	83 e0 01             	and    $0x1,%eax
  80331d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803320:	8b 45 0c             	mov    0xc(%ebp),%eax
  803323:	83 c0 08             	add    $0x8,%eax
  803326:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803329:	83 ec 0c             	sub    $0xc,%esp
  80332c:	ff 75 08             	pushl  0x8(%ebp)
  80332f:	e8 68 ec ff ff       	call   801f9c <get_block_size>
  803334:	83 c4 10             	add    $0x10,%esp
  803337:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80333a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333d:	83 e8 08             	sub    $0x8,%eax
  803340:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	83 e8 04             	sub    $0x4,%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	83 e0 fe             	and    $0xfffffffe,%eax
  80334e:	89 c2                	mov    %eax,%edx
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	01 d0                	add    %edx,%eax
  803355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803358:	83 ec 0c             	sub    $0xc,%esp
  80335b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335e:	e8 39 ec ff ff       	call   801f9c <get_block_size>
  803363:	83 c4 10             	add    $0x10,%esp
  803366:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336c:	83 e8 08             	sub    $0x8,%eax
  80336f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803372:	8b 45 0c             	mov    0xc(%ebp),%eax
  803375:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803378:	75 08                	jne    803382 <realloc_block_FF+0xc5>
	{
		 return va;
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	e9 44 06 00 00       	jmp    8039c6 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803382:	8b 45 0c             	mov    0xc(%ebp),%eax
  803385:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803388:	0f 83 d5 03 00 00    	jae    803763 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80338e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803391:	2b 45 0c             	sub    0xc(%ebp),%eax
  803394:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803397:	83 ec 0c             	sub    $0xc,%esp
  80339a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80339d:	e8 13 ec ff ff       	call   801fb5 <is_free_block>
  8033a2:	83 c4 10             	add    $0x10,%esp
  8033a5:	84 c0                	test   %al,%al
  8033a7:	0f 84 3b 01 00 00    	je     8034e8 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033b3:	01 d0                	add    %edx,%eax
  8033b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	6a 01                	push   $0x1
  8033bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8033c0:	ff 75 08             	pushl  0x8(%ebp)
  8033c3:	e8 25 ef ff ff       	call   8022ed <set_block_data>
  8033c8:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	83 e8 04             	sub    $0x4,%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	83 e0 fe             	and    $0xfffffffe,%eax
  8033d6:	89 c2                	mov    %eax,%edx
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	01 d0                	add    %edx,%eax
  8033dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	6a 00                	push   $0x0
  8033e5:	ff 75 cc             	pushl  -0x34(%ebp)
  8033e8:	ff 75 c8             	pushl  -0x38(%ebp)
  8033eb:	e8 fd ee ff ff       	call   8022ed <set_block_data>
  8033f0:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033f7:	74 06                	je     8033ff <realloc_block_FF+0x142>
  8033f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033fd:	75 17                	jne    803416 <realloc_block_FF+0x159>
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	68 74 45 80 00       	push   $0x804574
  803407:	68 f6 01 00 00       	push   $0x1f6
  80340c:	68 01 45 80 00       	push   $0x804501
  803411:	e8 5f 06 00 00       	call   803a75 <_panic>
  803416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803419:	8b 10                	mov    (%eax),%edx
  80341b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	74 0b                	je     803434 <realloc_block_FF+0x177>
  803429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803431:	89 50 04             	mov    %edx,0x4(%eax)
  803434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803437:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80343a:	89 10                	mov    %edx,(%eax)
  80343c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80343f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803442:	89 50 04             	mov    %edx,0x4(%eax)
  803445:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	75 08                	jne    803456 <realloc_block_FF+0x199>
  80344e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803451:	a3 30 50 80 00       	mov    %eax,0x805030
  803456:	a1 38 50 80 00       	mov    0x805038,%eax
  80345b:	40                   	inc    %eax
  80345c:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803461:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803465:	75 17                	jne    80347e <realloc_block_FF+0x1c1>
  803467:	83 ec 04             	sub    $0x4,%esp
  80346a:	68 e3 44 80 00       	push   $0x8044e3
  80346f:	68 f7 01 00 00       	push   $0x1f7
  803474:	68 01 45 80 00       	push   $0x804501
  803479:	e8 f7 05 00 00       	call   803a75 <_panic>
  80347e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	85 c0                	test   %eax,%eax
  803485:	74 10                	je     803497 <realloc_block_FF+0x1da>
  803487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348f:	8b 52 04             	mov    0x4(%edx),%edx
  803492:	89 50 04             	mov    %edx,0x4(%eax)
  803495:	eb 0b                	jmp    8034a2 <realloc_block_FF+0x1e5>
  803497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 0f                	je     8034bb <realloc_block_FF+0x1fe>
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b5:	8b 12                	mov    (%edx),%edx
  8034b7:	89 10                	mov    %edx,(%eax)
  8034b9:	eb 0a                	jmp    8034c5 <realloc_block_FF+0x208>
  8034bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034dd:	48                   	dec    %eax
  8034de:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e3:	e9 73 02 00 00       	jmp    80375b <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8034e8:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034ec:	0f 86 69 02 00 00    	jbe    80375b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034f2:	83 ec 04             	sub    $0x4,%esp
  8034f5:	6a 01                	push   $0x1
  8034f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8034fa:	ff 75 08             	pushl  0x8(%ebp)
  8034fd:	e8 eb ed ff ff       	call   8022ed <set_block_data>
  803502:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	83 e8 04             	sub    $0x4,%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	83 e0 fe             	and    $0xfffffffe,%eax
  803510:	89 c2                	mov    %eax,%edx
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	01 d0                	add    %edx,%eax
  803517:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80351a:	a1 38 50 80 00       	mov    0x805038,%eax
  80351f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803522:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803526:	75 68                	jne    803590 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803528:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80352c:	75 17                	jne    803545 <realloc_block_FF+0x288>
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	68 1c 45 80 00       	push   $0x80451c
  803536:	68 06 02 00 00       	push   $0x206
  80353b:	68 01 45 80 00       	push   $0x804501
  803540:	e8 30 05 00 00       	call   803a75 <_panic>
  803545:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80354b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354e:	89 10                	mov    %edx,(%eax)
  803550:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803553:	8b 00                	mov    (%eax),%eax
  803555:	85 c0                	test   %eax,%eax
  803557:	74 0d                	je     803566 <realloc_block_FF+0x2a9>
  803559:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80355e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	eb 08                	jmp    80356e <realloc_block_FF+0x2b1>
  803566:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803569:	a3 30 50 80 00       	mov    %eax,0x805030
  80356e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803571:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803580:	a1 38 50 80 00       	mov    0x805038,%eax
  803585:	40                   	inc    %eax
  803586:	a3 38 50 80 00       	mov    %eax,0x805038
  80358b:	e9 b0 01 00 00       	jmp    803740 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803590:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803595:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803598:	76 68                	jbe    803602 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80359a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80359e:	75 17                	jne    8035b7 <realloc_block_FF+0x2fa>
  8035a0:	83 ec 04             	sub    $0x4,%esp
  8035a3:	68 1c 45 80 00       	push   $0x80451c
  8035a8:	68 0b 02 00 00       	push   $0x20b
  8035ad:	68 01 45 80 00       	push   $0x804501
  8035b2:	e8 be 04 00 00       	call   803a75 <_panic>
  8035b7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c0:	89 10                	mov    %edx,(%eax)
  8035c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	74 0d                	je     8035d8 <realloc_block_FF+0x31b>
  8035cb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d3:	89 50 04             	mov    %edx,0x4(%eax)
  8035d6:	eb 08                	jmp    8035e0 <realloc_block_FF+0x323>
  8035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035db:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f7:	40                   	inc    %eax
  8035f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8035fd:	e9 3e 01 00 00       	jmp    803740 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803602:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803607:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80360a:	73 68                	jae    803674 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80360c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803610:	75 17                	jne    803629 <realloc_block_FF+0x36c>
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	68 50 45 80 00       	push   $0x804550
  80361a:	68 10 02 00 00       	push   $0x210
  80361f:	68 01 45 80 00       	push   $0x804501
  803624:	e8 4c 04 00 00       	call   803a75 <_panic>
  803629:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	89 50 04             	mov    %edx,0x4(%eax)
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	85 c0                	test   %eax,%eax
  80363d:	74 0c                	je     80364b <realloc_block_FF+0x38e>
  80363f:	a1 30 50 80 00       	mov    0x805030,%eax
  803644:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803647:	89 10                	mov    %edx,(%eax)
  803649:	eb 08                	jmp    803653 <realloc_block_FF+0x396>
  80364b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803653:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803656:	a3 30 50 80 00       	mov    %eax,0x805030
  80365b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803664:	a1 38 50 80 00       	mov    0x805038,%eax
  803669:	40                   	inc    %eax
  80366a:	a3 38 50 80 00       	mov    %eax,0x805038
  80366f:	e9 cc 00 00 00       	jmp    803740 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80367b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803683:	e9 8a 00 00 00       	jmp    803712 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80368e:	73 7a                	jae    80370a <realloc_block_FF+0x44d>
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803698:	73 70                	jae    80370a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80369a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369e:	74 06                	je     8036a6 <realloc_block_FF+0x3e9>
  8036a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036a4:	75 17                	jne    8036bd <realloc_block_FF+0x400>
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 74 45 80 00       	push   $0x804574
  8036ae:	68 1a 02 00 00       	push   $0x21a
  8036b3:	68 01 45 80 00       	push   $0x804501
  8036b8:	e8 b8 03 00 00       	call   803a75 <_panic>
  8036bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c0:	8b 10                	mov    (%eax),%edx
  8036c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c5:	89 10                	mov    %edx,(%eax)
  8036c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	85 c0                	test   %eax,%eax
  8036ce:	74 0b                	je     8036db <realloc_block_FF+0x41e>
  8036d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d3:	8b 00                	mov    (%eax),%eax
  8036d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d8:	89 50 04             	mov    %edx,0x4(%eax)
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e1:	89 10                	mov    %edx,(%eax)
  8036e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e9:	89 50 04             	mov    %edx,0x4(%eax)
  8036ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ef:	8b 00                	mov    (%eax),%eax
  8036f1:	85 c0                	test   %eax,%eax
  8036f3:	75 08                	jne    8036fd <realloc_block_FF+0x440>
  8036f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803702:	40                   	inc    %eax
  803703:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803708:	eb 36                	jmp    803740 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80370a:	a1 34 50 80 00       	mov    0x805034,%eax
  80370f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803716:	74 07                	je     80371f <realloc_block_FF+0x462>
  803718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	eb 05                	jmp    803724 <realloc_block_FF+0x467>
  80371f:	b8 00 00 00 00       	mov    $0x0,%eax
  803724:	a3 34 50 80 00       	mov    %eax,0x805034
  803729:	a1 34 50 80 00       	mov    0x805034,%eax
  80372e:	85 c0                	test   %eax,%eax
  803730:	0f 85 52 ff ff ff    	jne    803688 <realloc_block_FF+0x3cb>
  803736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373a:	0f 85 48 ff ff ff    	jne    803688 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803740:	83 ec 04             	sub    $0x4,%esp
  803743:	6a 00                	push   $0x0
  803745:	ff 75 d8             	pushl  -0x28(%ebp)
  803748:	ff 75 d4             	pushl  -0x2c(%ebp)
  80374b:	e8 9d eb ff ff       	call   8022ed <set_block_data>
  803750:	83 c4 10             	add    $0x10,%esp
				return va;
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	e9 6b 02 00 00       	jmp    8039c6 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	e9 63 02 00 00       	jmp    8039c6 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803763:	8b 45 0c             	mov    0xc(%ebp),%eax
  803766:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803769:	0f 86 4d 02 00 00    	jbe    8039bc <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80376f:	83 ec 0c             	sub    $0xc,%esp
  803772:	ff 75 e4             	pushl  -0x1c(%ebp)
  803775:	e8 3b e8 ff ff       	call   801fb5 <is_free_block>
  80377a:	83 c4 10             	add    $0x10,%esp
  80377d:	84 c0                	test   %al,%al
  80377f:	0f 84 37 02 00 00    	je     8039bc <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803785:	8b 45 0c             	mov    0xc(%ebp),%eax
  803788:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80378b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80378e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803791:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803794:	76 38                	jbe    8037ce <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803796:	83 ec 0c             	sub    $0xc,%esp
  803799:	ff 75 0c             	pushl  0xc(%ebp)
  80379c:	e8 7b eb ff ff       	call   80231c <alloc_block_FF>
  8037a1:	83 c4 10             	add    $0x10,%esp
  8037a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037a7:	83 ec 08             	sub    $0x8,%esp
  8037aa:	ff 75 c0             	pushl  -0x40(%ebp)
  8037ad:	ff 75 08             	pushl  0x8(%ebp)
  8037b0:	e8 c9 fa ff ff       	call   80327e <copy_data>
  8037b5:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8037b8:	83 ec 0c             	sub    $0xc,%esp
  8037bb:	ff 75 08             	pushl  0x8(%ebp)
  8037be:	e8 fa f9 ff ff       	call   8031bd <free_block>
  8037c3:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037c6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037c9:	e9 f8 01 00 00       	jmp    8039c6 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037d7:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037db:	0f 87 a0 00 00 00    	ja     803881 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e5:	75 17                	jne    8037fe <realloc_block_FF+0x541>
  8037e7:	83 ec 04             	sub    $0x4,%esp
  8037ea:	68 e3 44 80 00       	push   $0x8044e3
  8037ef:	68 38 02 00 00       	push   $0x238
  8037f4:	68 01 45 80 00       	push   $0x804501
  8037f9:	e8 77 02 00 00       	call   803a75 <_panic>
  8037fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803801:	8b 00                	mov    (%eax),%eax
  803803:	85 c0                	test   %eax,%eax
  803805:	74 10                	je     803817 <realloc_block_FF+0x55a>
  803807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380f:	8b 52 04             	mov    0x4(%edx),%edx
  803812:	89 50 04             	mov    %edx,0x4(%eax)
  803815:	eb 0b                	jmp    803822 <realloc_block_FF+0x565>
  803817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381a:	8b 40 04             	mov    0x4(%eax),%eax
  80381d:	a3 30 50 80 00       	mov    %eax,0x805030
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	8b 40 04             	mov    0x4(%eax),%eax
  803828:	85 c0                	test   %eax,%eax
  80382a:	74 0f                	je     80383b <realloc_block_FF+0x57e>
  80382c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382f:	8b 40 04             	mov    0x4(%eax),%eax
  803832:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803835:	8b 12                	mov    (%edx),%edx
  803837:	89 10                	mov    %edx,(%eax)
  803839:	eb 0a                	jmp    803845 <realloc_block_FF+0x588>
  80383b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383e:	8b 00                	mov    (%eax),%eax
  803840:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803848:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803851:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803858:	a1 38 50 80 00       	mov    0x805038,%eax
  80385d:	48                   	dec    %eax
  80385e:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803863:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803869:	01 d0                	add    %edx,%eax
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	6a 01                	push   $0x1
  803870:	50                   	push   %eax
  803871:	ff 75 08             	pushl  0x8(%ebp)
  803874:	e8 74 ea ff ff       	call   8022ed <set_block_data>
  803879:	83 c4 10             	add    $0x10,%esp
  80387c:	e9 36 01 00 00       	jmp    8039b7 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803881:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803884:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803887:	01 d0                	add    %edx,%eax
  803889:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80388c:	83 ec 04             	sub    $0x4,%esp
  80388f:	6a 01                	push   $0x1
  803891:	ff 75 f0             	pushl  -0x10(%ebp)
  803894:	ff 75 08             	pushl  0x8(%ebp)
  803897:	e8 51 ea ff ff       	call   8022ed <set_block_data>
  80389c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80389f:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a2:	83 e8 04             	sub    $0x4,%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	83 e0 fe             	and    $0xfffffffe,%eax
  8038aa:	89 c2                	mov    %eax,%edx
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	01 d0                	add    %edx,%eax
  8038b1:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038b8:	74 06                	je     8038c0 <realloc_block_FF+0x603>
  8038ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038be:	75 17                	jne    8038d7 <realloc_block_FF+0x61a>
  8038c0:	83 ec 04             	sub    $0x4,%esp
  8038c3:	68 74 45 80 00       	push   $0x804574
  8038c8:	68 44 02 00 00       	push   $0x244
  8038cd:	68 01 45 80 00       	push   $0x804501
  8038d2:	e8 9e 01 00 00       	call   803a75 <_panic>
  8038d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038da:	8b 10                	mov    (%eax),%edx
  8038dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038df:	89 10                	mov    %edx,(%eax)
  8038e1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e4:	8b 00                	mov    (%eax),%eax
  8038e6:	85 c0                	test   %eax,%eax
  8038e8:	74 0b                	je     8038f5 <realloc_block_FF+0x638>
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	8b 00                	mov    (%eax),%eax
  8038ef:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038f2:	89 50 04             	mov    %edx,0x4(%eax)
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038fb:	89 10                	mov    %edx,(%eax)
  8038fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
  803906:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803909:	8b 00                	mov    (%eax),%eax
  80390b:	85 c0                	test   %eax,%eax
  80390d:	75 08                	jne    803917 <realloc_block_FF+0x65a>
  80390f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803912:	a3 30 50 80 00       	mov    %eax,0x805030
  803917:	a1 38 50 80 00       	mov    0x805038,%eax
  80391c:	40                   	inc    %eax
  80391d:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803922:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803926:	75 17                	jne    80393f <realloc_block_FF+0x682>
  803928:	83 ec 04             	sub    $0x4,%esp
  80392b:	68 e3 44 80 00       	push   $0x8044e3
  803930:	68 45 02 00 00       	push   $0x245
  803935:	68 01 45 80 00       	push   $0x804501
  80393a:	e8 36 01 00 00       	call   803a75 <_panic>
  80393f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803942:	8b 00                	mov    (%eax),%eax
  803944:	85 c0                	test   %eax,%eax
  803946:	74 10                	je     803958 <realloc_block_FF+0x69b>
  803948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394b:	8b 00                	mov    (%eax),%eax
  80394d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803950:	8b 52 04             	mov    0x4(%edx),%edx
  803953:	89 50 04             	mov    %edx,0x4(%eax)
  803956:	eb 0b                	jmp    803963 <realloc_block_FF+0x6a6>
  803958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395b:	8b 40 04             	mov    0x4(%eax),%eax
  80395e:	a3 30 50 80 00       	mov    %eax,0x805030
  803963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803966:	8b 40 04             	mov    0x4(%eax),%eax
  803969:	85 c0                	test   %eax,%eax
  80396b:	74 0f                	je     80397c <realloc_block_FF+0x6bf>
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803976:	8b 12                	mov    (%edx),%edx
  803978:	89 10                	mov    %edx,(%eax)
  80397a:	eb 0a                	jmp    803986 <realloc_block_FF+0x6c9>
  80397c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397f:	8b 00                	mov    (%eax),%eax
  803981:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803989:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803992:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803999:	a1 38 50 80 00       	mov    0x805038,%eax
  80399e:	48                   	dec    %eax
  80399f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039a4:	83 ec 04             	sub    $0x4,%esp
  8039a7:	6a 00                	push   $0x0
  8039a9:	ff 75 bc             	pushl  -0x44(%ebp)
  8039ac:	ff 75 b8             	pushl  -0x48(%ebp)
  8039af:	e8 39 e9 ff ff       	call   8022ed <set_block_data>
  8039b4:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	eb 0a                	jmp    8039c6 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039bc:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039c6:	c9                   	leave  
  8039c7:	c3                   	ret    

008039c8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039c8:	55                   	push   %ebp
  8039c9:	89 e5                	mov    %esp,%ebp
  8039cb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039ce:	83 ec 04             	sub    $0x4,%esp
  8039d1:	68 e0 45 80 00       	push   $0x8045e0
  8039d6:	68 58 02 00 00       	push   $0x258
  8039db:	68 01 45 80 00       	push   $0x804501
  8039e0:	e8 90 00 00 00       	call   803a75 <_panic>

008039e5 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039e5:	55                   	push   %ebp
  8039e6:	89 e5                	mov    %esp,%ebp
  8039e8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039eb:	83 ec 04             	sub    $0x4,%esp
  8039ee:	68 08 46 80 00       	push   $0x804608
  8039f3:	68 61 02 00 00       	push   $0x261
  8039f8:	68 01 45 80 00       	push   $0x804501
  8039fd:	e8 73 00 00 00       	call   803a75 <_panic>

00803a02 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803a02:	55                   	push   %ebp
  803a03:	89 e5                	mov    %esp,%ebp
  803a05:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803a08:	83 ec 04             	sub    $0x4,%esp
  803a0b:	68 30 46 80 00       	push   $0x804630
  803a10:	6a 09                	push   $0x9
  803a12:	68 58 46 80 00       	push   $0x804658
  803a17:	e8 59 00 00 00       	call   803a75 <_panic>

00803a1c <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803a1c:	55                   	push   %ebp
  803a1d:	89 e5                	mov    %esp,%ebp
  803a1f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803a22:	83 ec 04             	sub    $0x4,%esp
  803a25:	68 68 46 80 00       	push   $0x804668
  803a2a:	6a 10                	push   $0x10
  803a2c:	68 58 46 80 00       	push   $0x804658
  803a31:	e8 3f 00 00 00       	call   803a75 <_panic>

00803a36 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803a36:	55                   	push   %ebp
  803a37:	89 e5                	mov    %esp,%ebp
  803a39:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803a3c:	83 ec 04             	sub    $0x4,%esp
  803a3f:	68 90 46 80 00       	push   $0x804690
  803a44:	6a 18                	push   $0x18
  803a46:	68 58 46 80 00       	push   $0x804658
  803a4b:	e8 25 00 00 00       	call   803a75 <_panic>

00803a50 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803a50:	55                   	push   %ebp
  803a51:	89 e5                	mov    %esp,%ebp
  803a53:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803a56:	83 ec 04             	sub    $0x4,%esp
  803a59:	68 b8 46 80 00       	push   $0x8046b8
  803a5e:	6a 20                	push   $0x20
  803a60:	68 58 46 80 00       	push   $0x804658
  803a65:	e8 0b 00 00 00       	call   803a75 <_panic>

00803a6a <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803a6a:	55                   	push   %ebp
  803a6b:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	8b 40 10             	mov    0x10(%eax),%eax
}
  803a73:	5d                   	pop    %ebp
  803a74:	c3                   	ret    

00803a75 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a75:	55                   	push   %ebp
  803a76:	89 e5                	mov    %esp,%ebp
  803a78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a7b:	8d 45 10             	lea    0x10(%ebp),%eax
  803a7e:	83 c0 04             	add    $0x4,%eax
  803a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a84:	a1 60 50 98 00       	mov    0x985060,%eax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 16                	je     803aa3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a8d:	a1 60 50 98 00       	mov    0x985060,%eax
  803a92:	83 ec 08             	sub    $0x8,%esp
  803a95:	50                   	push   %eax
  803a96:	68 e0 46 80 00       	push   $0x8046e0
  803a9b:	e8 06 cc ff ff       	call   8006a6 <cprintf>
  803aa0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803aa3:	a1 00 50 80 00       	mov    0x805000,%eax
  803aa8:	ff 75 0c             	pushl  0xc(%ebp)
  803aab:	ff 75 08             	pushl  0x8(%ebp)
  803aae:	50                   	push   %eax
  803aaf:	68 e5 46 80 00       	push   $0x8046e5
  803ab4:	e8 ed cb ff ff       	call   8006a6 <cprintf>
  803ab9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803abc:	8b 45 10             	mov    0x10(%ebp),%eax
  803abf:	83 ec 08             	sub    $0x8,%esp
  803ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  803ac5:	50                   	push   %eax
  803ac6:	e8 70 cb ff ff       	call   80063b <vcprintf>
  803acb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803ace:	83 ec 08             	sub    $0x8,%esp
  803ad1:	6a 00                	push   $0x0
  803ad3:	68 01 47 80 00       	push   $0x804701
  803ad8:	e8 5e cb ff ff       	call   80063b <vcprintf>
  803add:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803ae0:	e8 df ca ff ff       	call   8005c4 <exit>

	// should not return here
	while (1) ;
  803ae5:	eb fe                	jmp    803ae5 <_panic+0x70>

00803ae7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ae7:	55                   	push   %ebp
  803ae8:	89 e5                	mov    %esp,%ebp
  803aea:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803aed:	a1 20 50 80 00       	mov    0x805020,%eax
  803af2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803afb:	39 c2                	cmp    %eax,%edx
  803afd:	74 14                	je     803b13 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803aff:	83 ec 04             	sub    $0x4,%esp
  803b02:	68 04 47 80 00       	push   $0x804704
  803b07:	6a 26                	push   $0x26
  803b09:	68 50 47 80 00       	push   $0x804750
  803b0e:	e8 62 ff ff ff       	call   803a75 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b21:	e9 c5 00 00 00       	jmp    803beb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b30:	8b 45 08             	mov    0x8(%ebp),%eax
  803b33:	01 d0                	add    %edx,%eax
  803b35:	8b 00                	mov    (%eax),%eax
  803b37:	85 c0                	test   %eax,%eax
  803b39:	75 08                	jne    803b43 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b3b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b3e:	e9 a5 00 00 00       	jmp    803be8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b4a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b51:	eb 69                	jmp    803bbc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b53:	a1 20 50 80 00       	mov    0x805020,%eax
  803b58:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b61:	89 d0                	mov    %edx,%eax
  803b63:	01 c0                	add    %eax,%eax
  803b65:	01 d0                	add    %edx,%eax
  803b67:	c1 e0 03             	shl    $0x3,%eax
  803b6a:	01 c8                	add    %ecx,%eax
  803b6c:	8a 40 04             	mov    0x4(%eax),%al
  803b6f:	84 c0                	test   %al,%al
  803b71:	75 46                	jne    803bb9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b73:	a1 20 50 80 00       	mov    0x805020,%eax
  803b78:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b81:	89 d0                	mov    %edx,%eax
  803b83:	01 c0                	add    %eax,%eax
  803b85:	01 d0                	add    %edx,%eax
  803b87:	c1 e0 03             	shl    $0x3,%eax
  803b8a:	01 c8                	add    %ecx,%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b99:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	01 c8                	add    %ecx,%eax
  803baa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bac:	39 c2                	cmp    %eax,%edx
  803bae:	75 09                	jne    803bb9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803bb0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803bb7:	eb 15                	jmp    803bce <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb9:	ff 45 e8             	incl   -0x18(%ebp)
  803bbc:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	77 85                	ja     803b53 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803bce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bd2:	75 14                	jne    803be8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803bd4:	83 ec 04             	sub    $0x4,%esp
  803bd7:	68 5c 47 80 00       	push   $0x80475c
  803bdc:	6a 3a                	push   $0x3a
  803bde:	68 50 47 80 00       	push   $0x804750
  803be3:	e8 8d fe ff ff       	call   803a75 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803be8:	ff 45 f0             	incl   -0x10(%ebp)
  803beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bf1:	0f 8c 2f ff ff ff    	jl     803b26 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803bf7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bfe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c05:	eb 26                	jmp    803c2d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c07:	a1 20 50 80 00       	mov    0x805020,%eax
  803c0c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c15:	89 d0                	mov    %edx,%eax
  803c17:	01 c0                	add    %eax,%eax
  803c19:	01 d0                	add    %edx,%eax
  803c1b:	c1 e0 03             	shl    $0x3,%eax
  803c1e:	01 c8                	add    %ecx,%eax
  803c20:	8a 40 04             	mov    0x4(%eax),%al
  803c23:	3c 01                	cmp    $0x1,%al
  803c25:	75 03                	jne    803c2a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c27:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c2a:	ff 45 e0             	incl   -0x20(%ebp)
  803c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  803c32:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3b:	39 c2                	cmp    %eax,%edx
  803c3d:	77 c8                	ja     803c07 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c45:	74 14                	je     803c5b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c47:	83 ec 04             	sub    $0x4,%esp
  803c4a:	68 b0 47 80 00       	push   $0x8047b0
  803c4f:	6a 44                	push   $0x44
  803c51:	68 50 47 80 00       	push   $0x804750
  803c56:	e8 1a fe ff ff       	call   803a75 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c5b:	90                   	nop
  803c5c:	c9                   	leave  
  803c5d:	c3                   	ret    
  803c5e:	66 90                	xchg   %ax,%ax

00803c60 <__udivdi3>:
  803c60:	55                   	push   %ebp
  803c61:	57                   	push   %edi
  803c62:	56                   	push   %esi
  803c63:	53                   	push   %ebx
  803c64:	83 ec 1c             	sub    $0x1c,%esp
  803c67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c77:	89 ca                	mov    %ecx,%edx
  803c79:	89 f8                	mov    %edi,%eax
  803c7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c7f:	85 f6                	test   %esi,%esi
  803c81:	75 2d                	jne    803cb0 <__udivdi3+0x50>
  803c83:	39 cf                	cmp    %ecx,%edi
  803c85:	77 65                	ja     803cec <__udivdi3+0x8c>
  803c87:	89 fd                	mov    %edi,%ebp
  803c89:	85 ff                	test   %edi,%edi
  803c8b:	75 0b                	jne    803c98 <__udivdi3+0x38>
  803c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c92:	31 d2                	xor    %edx,%edx
  803c94:	f7 f7                	div    %edi
  803c96:	89 c5                	mov    %eax,%ebp
  803c98:	31 d2                	xor    %edx,%edx
  803c9a:	89 c8                	mov    %ecx,%eax
  803c9c:	f7 f5                	div    %ebp
  803c9e:	89 c1                	mov    %eax,%ecx
  803ca0:	89 d8                	mov    %ebx,%eax
  803ca2:	f7 f5                	div    %ebp
  803ca4:	89 cf                	mov    %ecx,%edi
  803ca6:	89 fa                	mov    %edi,%edx
  803ca8:	83 c4 1c             	add    $0x1c,%esp
  803cab:	5b                   	pop    %ebx
  803cac:	5e                   	pop    %esi
  803cad:	5f                   	pop    %edi
  803cae:	5d                   	pop    %ebp
  803caf:	c3                   	ret    
  803cb0:	39 ce                	cmp    %ecx,%esi
  803cb2:	77 28                	ja     803cdc <__udivdi3+0x7c>
  803cb4:	0f bd fe             	bsr    %esi,%edi
  803cb7:	83 f7 1f             	xor    $0x1f,%edi
  803cba:	75 40                	jne    803cfc <__udivdi3+0x9c>
  803cbc:	39 ce                	cmp    %ecx,%esi
  803cbe:	72 0a                	jb     803cca <__udivdi3+0x6a>
  803cc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cc4:	0f 87 9e 00 00 00    	ja     803d68 <__udivdi3+0x108>
  803cca:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccf:	89 fa                	mov    %edi,%edx
  803cd1:	83 c4 1c             	add    $0x1c,%esp
  803cd4:	5b                   	pop    %ebx
  803cd5:	5e                   	pop    %esi
  803cd6:	5f                   	pop    %edi
  803cd7:	5d                   	pop    %ebp
  803cd8:	c3                   	ret    
  803cd9:	8d 76 00             	lea    0x0(%esi),%esi
  803cdc:	31 ff                	xor    %edi,%edi
  803cde:	31 c0                	xor    %eax,%eax
  803ce0:	89 fa                	mov    %edi,%edx
  803ce2:	83 c4 1c             	add    $0x1c,%esp
  803ce5:	5b                   	pop    %ebx
  803ce6:	5e                   	pop    %esi
  803ce7:	5f                   	pop    %edi
  803ce8:	5d                   	pop    %ebp
  803ce9:	c3                   	ret    
  803cea:	66 90                	xchg   %ax,%ax
  803cec:	89 d8                	mov    %ebx,%eax
  803cee:	f7 f7                	div    %edi
  803cf0:	31 ff                	xor    %edi,%edi
  803cf2:	89 fa                	mov    %edi,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d01:	89 eb                	mov    %ebp,%ebx
  803d03:	29 fb                	sub    %edi,%ebx
  803d05:	89 f9                	mov    %edi,%ecx
  803d07:	d3 e6                	shl    %cl,%esi
  803d09:	89 c5                	mov    %eax,%ebp
  803d0b:	88 d9                	mov    %bl,%cl
  803d0d:	d3 ed                	shr    %cl,%ebp
  803d0f:	89 e9                	mov    %ebp,%ecx
  803d11:	09 f1                	or     %esi,%ecx
  803d13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d17:	89 f9                	mov    %edi,%ecx
  803d19:	d3 e0                	shl    %cl,%eax
  803d1b:	89 c5                	mov    %eax,%ebp
  803d1d:	89 d6                	mov    %edx,%esi
  803d1f:	88 d9                	mov    %bl,%cl
  803d21:	d3 ee                	shr    %cl,%esi
  803d23:	89 f9                	mov    %edi,%ecx
  803d25:	d3 e2                	shl    %cl,%edx
  803d27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2b:	88 d9                	mov    %bl,%cl
  803d2d:	d3 e8                	shr    %cl,%eax
  803d2f:	09 c2                	or     %eax,%edx
  803d31:	89 d0                	mov    %edx,%eax
  803d33:	89 f2                	mov    %esi,%edx
  803d35:	f7 74 24 0c          	divl   0xc(%esp)
  803d39:	89 d6                	mov    %edx,%esi
  803d3b:	89 c3                	mov    %eax,%ebx
  803d3d:	f7 e5                	mul    %ebp
  803d3f:	39 d6                	cmp    %edx,%esi
  803d41:	72 19                	jb     803d5c <__udivdi3+0xfc>
  803d43:	74 0b                	je     803d50 <__udivdi3+0xf0>
  803d45:	89 d8                	mov    %ebx,%eax
  803d47:	31 ff                	xor    %edi,%edi
  803d49:	e9 58 ff ff ff       	jmp    803ca6 <__udivdi3+0x46>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d54:	89 f9                	mov    %edi,%ecx
  803d56:	d3 e2                	shl    %cl,%edx
  803d58:	39 c2                	cmp    %eax,%edx
  803d5a:	73 e9                	jae    803d45 <__udivdi3+0xe5>
  803d5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d5f:	31 ff                	xor    %edi,%edi
  803d61:	e9 40 ff ff ff       	jmp    803ca6 <__udivdi3+0x46>
  803d66:	66 90                	xchg   %ax,%ax
  803d68:	31 c0                	xor    %eax,%eax
  803d6a:	e9 37 ff ff ff       	jmp    803ca6 <__udivdi3+0x46>
  803d6f:	90                   	nop

00803d70 <__umoddi3>:
  803d70:	55                   	push   %ebp
  803d71:	57                   	push   %edi
  803d72:	56                   	push   %esi
  803d73:	53                   	push   %ebx
  803d74:	83 ec 1c             	sub    $0x1c,%esp
  803d77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d8f:	89 f3                	mov    %esi,%ebx
  803d91:	89 fa                	mov    %edi,%edx
  803d93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d97:	89 34 24             	mov    %esi,(%esp)
  803d9a:	85 c0                	test   %eax,%eax
  803d9c:	75 1a                	jne    803db8 <__umoddi3+0x48>
  803d9e:	39 f7                	cmp    %esi,%edi
  803da0:	0f 86 a2 00 00 00    	jbe    803e48 <__umoddi3+0xd8>
  803da6:	89 c8                	mov    %ecx,%eax
  803da8:	89 f2                	mov    %esi,%edx
  803daa:	f7 f7                	div    %edi
  803dac:	89 d0                	mov    %edx,%eax
  803dae:	31 d2                	xor    %edx,%edx
  803db0:	83 c4 1c             	add    $0x1c,%esp
  803db3:	5b                   	pop    %ebx
  803db4:	5e                   	pop    %esi
  803db5:	5f                   	pop    %edi
  803db6:	5d                   	pop    %ebp
  803db7:	c3                   	ret    
  803db8:	39 f0                	cmp    %esi,%eax
  803dba:	0f 87 ac 00 00 00    	ja     803e6c <__umoddi3+0xfc>
  803dc0:	0f bd e8             	bsr    %eax,%ebp
  803dc3:	83 f5 1f             	xor    $0x1f,%ebp
  803dc6:	0f 84 ac 00 00 00    	je     803e78 <__umoddi3+0x108>
  803dcc:	bf 20 00 00 00       	mov    $0x20,%edi
  803dd1:	29 ef                	sub    %ebp,%edi
  803dd3:	89 fe                	mov    %edi,%esi
  803dd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dd9:	89 e9                	mov    %ebp,%ecx
  803ddb:	d3 e0                	shl    %cl,%eax
  803ddd:	89 d7                	mov    %edx,%edi
  803ddf:	89 f1                	mov    %esi,%ecx
  803de1:	d3 ef                	shr    %cl,%edi
  803de3:	09 c7                	or     %eax,%edi
  803de5:	89 e9                	mov    %ebp,%ecx
  803de7:	d3 e2                	shl    %cl,%edx
  803de9:	89 14 24             	mov    %edx,(%esp)
  803dec:	89 d8                	mov    %ebx,%eax
  803dee:	d3 e0                	shl    %cl,%eax
  803df0:	89 c2                	mov    %eax,%edx
  803df2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803df6:	d3 e0                	shl    %cl,%eax
  803df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e00:	89 f1                	mov    %esi,%ecx
  803e02:	d3 e8                	shr    %cl,%eax
  803e04:	09 d0                	or     %edx,%eax
  803e06:	d3 eb                	shr    %cl,%ebx
  803e08:	89 da                	mov    %ebx,%edx
  803e0a:	f7 f7                	div    %edi
  803e0c:	89 d3                	mov    %edx,%ebx
  803e0e:	f7 24 24             	mull   (%esp)
  803e11:	89 c6                	mov    %eax,%esi
  803e13:	89 d1                	mov    %edx,%ecx
  803e15:	39 d3                	cmp    %edx,%ebx
  803e17:	0f 82 87 00 00 00    	jb     803ea4 <__umoddi3+0x134>
  803e1d:	0f 84 91 00 00 00    	je     803eb4 <__umoddi3+0x144>
  803e23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e27:	29 f2                	sub    %esi,%edx
  803e29:	19 cb                	sbb    %ecx,%ebx
  803e2b:	89 d8                	mov    %ebx,%eax
  803e2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e31:	d3 e0                	shl    %cl,%eax
  803e33:	89 e9                	mov    %ebp,%ecx
  803e35:	d3 ea                	shr    %cl,%edx
  803e37:	09 d0                	or     %edx,%eax
  803e39:	89 e9                	mov    %ebp,%ecx
  803e3b:	d3 eb                	shr    %cl,%ebx
  803e3d:	89 da                	mov    %ebx,%edx
  803e3f:	83 c4 1c             	add    $0x1c,%esp
  803e42:	5b                   	pop    %ebx
  803e43:	5e                   	pop    %esi
  803e44:	5f                   	pop    %edi
  803e45:	5d                   	pop    %ebp
  803e46:	c3                   	ret    
  803e47:	90                   	nop
  803e48:	89 fd                	mov    %edi,%ebp
  803e4a:	85 ff                	test   %edi,%edi
  803e4c:	75 0b                	jne    803e59 <__umoddi3+0xe9>
  803e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e53:	31 d2                	xor    %edx,%edx
  803e55:	f7 f7                	div    %edi
  803e57:	89 c5                	mov    %eax,%ebp
  803e59:	89 f0                	mov    %esi,%eax
  803e5b:	31 d2                	xor    %edx,%edx
  803e5d:	f7 f5                	div    %ebp
  803e5f:	89 c8                	mov    %ecx,%eax
  803e61:	f7 f5                	div    %ebp
  803e63:	89 d0                	mov    %edx,%eax
  803e65:	e9 44 ff ff ff       	jmp    803dae <__umoddi3+0x3e>
  803e6a:	66 90                	xchg   %ax,%ax
  803e6c:	89 c8                	mov    %ecx,%eax
  803e6e:	89 f2                	mov    %esi,%edx
  803e70:	83 c4 1c             	add    $0x1c,%esp
  803e73:	5b                   	pop    %ebx
  803e74:	5e                   	pop    %esi
  803e75:	5f                   	pop    %edi
  803e76:	5d                   	pop    %ebp
  803e77:	c3                   	ret    
  803e78:	3b 04 24             	cmp    (%esp),%eax
  803e7b:	72 06                	jb     803e83 <__umoddi3+0x113>
  803e7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e81:	77 0f                	ja     803e92 <__umoddi3+0x122>
  803e83:	89 f2                	mov    %esi,%edx
  803e85:	29 f9                	sub    %edi,%ecx
  803e87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e8b:	89 14 24             	mov    %edx,(%esp)
  803e8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e96:	8b 14 24             	mov    (%esp),%edx
  803e99:	83 c4 1c             	add    $0x1c,%esp
  803e9c:	5b                   	pop    %ebx
  803e9d:	5e                   	pop    %esi
  803e9e:	5f                   	pop    %edi
  803e9f:	5d                   	pop    %ebp
  803ea0:	c3                   	ret    
  803ea1:	8d 76 00             	lea    0x0(%esi),%esi
  803ea4:	2b 04 24             	sub    (%esp),%eax
  803ea7:	19 fa                	sbb    %edi,%edx
  803ea9:	89 d1                	mov    %edx,%ecx
  803eab:	89 c6                	mov    %eax,%esi
  803ead:	e9 71 ff ff ff       	jmp    803e23 <__umoddi3+0xb3>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803eb8:	72 ea                	jb     803ea4 <__umoddi3+0x134>
  803eba:	89 d9                	mov    %ebx,%ecx
  803ebc:	e9 62 ff ff ff       	jmp    803e23 <__umoddi3+0xb3>
