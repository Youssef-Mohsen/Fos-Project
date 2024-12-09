
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
  80004c:	68 c0 40 80 00       	push   $0x8040c0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 b8 3a 00 00       	call   803b12 <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 c6 40 80 00       	push   $0x8040c6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 a1 3a 00 00       	call   803b12 <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 e0             	pushl  -0x20(%ebp)
  80007a:	e8 de 3a 00 00       	call   803b5d <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800082:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  800089:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	68 cf 40 80 00       	push   $0x8040cf
  800098:	ff 75 f0             	pushl  -0x10(%ebp)
  80009b:	e8 79 17 00 00       	call   801819 <sget>
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000a6:	83 ec 08             	sub    $0x8,%esp
  8000a9:	68 d3 40 80 00       	push   $0x8040d3
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
  8000ca:	68 db 40 80 00       	push   $0x8040db
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
  80012b:	68 ea 40 80 00       	push   $0x8040ea
  800130:	e8 71 05 00 00       	call   8006a6 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 dc             	pushl  -0x24(%ebp)
  80013e:	e8 9c 3a 00 00       	call   803bdf <signal_semaphore>
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
  8001c2:	68 06 41 80 00       	push   $0x804106
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
  8001e4:	68 08 41 80 00       	push   $0x804108
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
  800212:	68 0d 41 80 00       	push   $0x80410d
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
  80050f:	68 2c 41 80 00       	push   $0x80412c
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
  800537:	68 54 41 80 00       	push   $0x804154
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
  800568:	68 7c 41 80 00       	push   $0x80417c
  80056d:	e8 34 01 00 00       	call   8006a6 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800575:	a1 20 50 80 00       	mov    0x805020,%eax
  80057a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 d4 41 80 00       	push   $0x8041d4
  800589:	e8 18 01 00 00       	call   8006a6 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	68 2c 41 80 00       	push   $0x80412c
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
  800743:	e8 00 37 00 00       	call   803e48 <__udivdi3>
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
  800793:	e8 c0 37 00 00       	call   803f58 <__umoddi3>
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	05 14 44 80 00       	add    $0x804414,%eax
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
  8008ee:	8b 04 85 38 44 80 00 	mov    0x804438(,%eax,4),%eax
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
  8009cf:	8b 34 9d 80 42 80 00 	mov    0x804280(,%ebx,4),%esi
  8009d6:	85 f6                	test   %esi,%esi
  8009d8:	75 19                	jne    8009f3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009da:	53                   	push   %ebx
  8009db:	68 25 44 80 00       	push   $0x804425
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
  8009f4:	68 2e 44 80 00       	push   $0x80442e
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
  800a21:	be 31 44 80 00       	mov    $0x804431,%esi
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
  80142c:	68 a8 45 80 00       	push   $0x8045a8
  801431:	68 3f 01 00 00       	push   $0x13f
  801436:	68 ca 45 80 00       	push   $0x8045ca
  80143b:	e8 1c 28 00 00       	call   803c5c <_panic>

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
  8014d6:	e8 dd 0e 00 00       	call   8023b8 <alloc_block_FF>
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
  8014f9:	e8 76 13 00 00       	call   802874 <alloc_block_BF>
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
  8016a7:	e8 8c 09 00 00       	call   802038 <get_block_size>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b2:	83 ec 0c             	sub    $0xc,%esp
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	e8 9c 1b 00 00       	call   803259 <free_block>
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
  80175d:	68 d8 45 80 00       	push   $0x8045d8
  801762:	68 87 00 00 00       	push   $0x87
  801767:	68 02 46 80 00       	push   $0x804602
  80176c:	e8 eb 24 00 00       	call   803c5c <_panic>
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
  801908:	68 10 46 80 00       	push   $0x804610
  80190d:	68 e4 00 00 00       	push   $0xe4
  801912:	68 02 46 80 00       	push   $0x804602
  801917:	e8 40 23 00 00       	call   803c5c <_panic>

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
  801925:	68 36 46 80 00       	push   $0x804636
  80192a:	68 f0 00 00 00       	push   $0xf0
  80192f:	68 02 46 80 00       	push   $0x804602
  801934:	e8 23 23 00 00       	call   803c5c <_panic>

00801939 <shrink>:

}
void shrink(uint32 newSize)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 36 46 80 00       	push   $0x804636
  801947:	68 f5 00 00 00       	push   $0xf5
  80194c:	68 02 46 80 00       	push   $0x804602
  801951:	e8 06 23 00 00       	call   803c5c <_panic>

00801956 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	68 36 46 80 00       	push   $0x804636
  801964:	68 fa 00 00 00       	push   $0xfa
  801969:	68 02 46 80 00       	push   $0x804602
  80196e:	e8 e9 22 00 00       	call   803c5c <_panic>

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

00801f9c <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 2e                	push   $0x2e
  801fae:	e8 c0 f9 ff ff       	call   801973 <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
  801fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	50                   	push   %eax
  801fcd:	6a 2f                	push   $0x2f
  801fcf:	e8 9f f9 ff ff       	call   801973 <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
	return;
  801fd7:	90                   	nop
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	52                   	push   %edx
  801fea:	50                   	push   %eax
  801feb:	6a 30                	push   $0x30
  801fed:	e8 81 f9 ff ff       	call   801973 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
	return;
  801ff5:	90                   	nop
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	50                   	push   %eax
  80200a:	6a 31                	push   $0x31
  80200c:	e8 62 f9 ff ff       	call   801973 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
  802014:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802017:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	50                   	push   %eax
  80202b:	6a 32                	push   $0x32
  80202d:	e8 41 f9 ff ff       	call   801973 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
	return;
  802035:	90                   	nop
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	83 e8 04             	sub    $0x4,%eax
  802044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802047:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204a:	8b 00                	mov    (%eax),%eax
  80204c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	83 e8 04             	sub    $0x4,%eax
  80205d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802063:	8b 00                	mov    (%eax),%eax
  802065:	83 e0 01             	and    $0x1,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	0f 94 c0             	sete   %al
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802075:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	83 f8 02             	cmp    $0x2,%eax
  802082:	74 2b                	je     8020af <alloc_block+0x40>
  802084:	83 f8 02             	cmp    $0x2,%eax
  802087:	7f 07                	jg     802090 <alloc_block+0x21>
  802089:	83 f8 01             	cmp    $0x1,%eax
  80208c:	74 0e                	je     80209c <alloc_block+0x2d>
  80208e:	eb 58                	jmp    8020e8 <alloc_block+0x79>
  802090:	83 f8 03             	cmp    $0x3,%eax
  802093:	74 2d                	je     8020c2 <alloc_block+0x53>
  802095:	83 f8 04             	cmp    $0x4,%eax
  802098:	74 3b                	je     8020d5 <alloc_block+0x66>
  80209a:	eb 4c                	jmp    8020e8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	ff 75 08             	pushl  0x8(%ebp)
  8020a2:	e8 11 03 00 00       	call   8023b8 <alloc_block_FF>
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ad:	eb 4a                	jmp    8020f9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 c7 19 00 00       	call   803a81 <alloc_block_NF>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020c0:	eb 37                	jmp    8020f9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	e8 a7 07 00 00       	call   802874 <alloc_block_BF>
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d3:	eb 24                	jmp    8020f9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 08             	pushl  0x8(%ebp)
  8020db:	e8 84 19 00 00       	call   803a64 <alloc_block_WF>
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e6:	eb 11                	jmp    8020f9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020e8:	83 ec 0c             	sub    $0xc,%esp
  8020eb:	68 48 46 80 00       	push   $0x804648
  8020f0:	e8 b1 e5 ff ff       	call   8006a6 <cprintf>
  8020f5:	83 c4 10             	add    $0x10,%esp
		break;
  8020f8:	90                   	nop
	}
	return va;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	53                   	push   %ebx
  802102:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	68 68 46 80 00       	push   $0x804668
  80210d:	e8 94 e5 ff ff       	call   8006a6 <cprintf>
  802112:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	68 93 46 80 00       	push   $0x804693
  80211d:	e8 84 e5 ff ff       	call   8006a6 <cprintf>
  802122:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212b:	eb 37                	jmp    802164 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	ff 75 f4             	pushl  -0xc(%ebp)
  802133:	e8 19 ff ff ff       	call   802051 <is_free_block>
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	0f be d8             	movsbl %al,%ebx
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	ff 75 f4             	pushl  -0xc(%ebp)
  802144:	e8 ef fe ff ff       	call   802038 <get_block_size>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	53                   	push   %ebx
  802150:	50                   	push   %eax
  802151:	68 ab 46 80 00       	push   $0x8046ab
  802156:	e8 4b e5 ff ff       	call   8006a6 <cprintf>
  80215b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80215e:	8b 45 10             	mov    0x10(%ebp),%eax
  802161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802168:	74 07                	je     802171 <print_blocks_list+0x73>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	eb 05                	jmp    802176 <print_blocks_list+0x78>
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
  802176:	89 45 10             	mov    %eax,0x10(%ebp)
  802179:	8b 45 10             	mov    0x10(%ebp),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	75 ad                	jne    80212d <print_blocks_list+0x2f>
  802180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802184:	75 a7                	jne    80212d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	68 68 46 80 00       	push   $0x804668
  80218e:	e8 13 e5 ff ff       	call   8006a6 <cprintf>
  802193:	83 c4 10             	add    $0x10,%esp

}
  802196:	90                   	nop
  802197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a5:	83 e0 01             	and    $0x1,%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	74 03                	je     8021af <initialize_dynamic_allocator+0x13>
  8021ac:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b3:	0f 84 c7 01 00 00    	je     802380 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021b9:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021c0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c9:	01 d0                	add    %edx,%eax
  8021cb:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021d0:	0f 87 ad 01 00 00    	ja     802383 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	0f 89 a5 01 00 00    	jns    802386 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	83 e8 04             	sub    $0x4,%eax
  8021ec:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802200:	e9 87 00 00 00       	jmp    80228c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802209:	75 14                	jne    80221f <initialize_dynamic_allocator+0x83>
  80220b:	83 ec 04             	sub    $0x4,%esp
  80220e:	68 c3 46 80 00       	push   $0x8046c3
  802213:	6a 79                	push   $0x79
  802215:	68 e1 46 80 00       	push   $0x8046e1
  80221a:	e8 3d 1a 00 00       	call   803c5c <_panic>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	74 10                	je     802238 <initialize_dynamic_allocator+0x9c>
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802230:	8b 52 04             	mov    0x4(%edx),%edx
  802233:	89 50 04             	mov    %edx,0x4(%eax)
  802236:	eb 0b                	jmp    802243 <initialize_dynamic_allocator+0xa7>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 40 04             	mov    0x4(%eax),%eax
  80223e:	a3 30 50 80 00       	mov    %eax,0x805030
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 40 04             	mov    0x4(%eax),%eax
  802249:	85 c0                	test   %eax,%eax
  80224b:	74 0f                	je     80225c <initialize_dynamic_allocator+0xc0>
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 04             	mov    0x4(%eax),%eax
  802253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802256:	8b 12                	mov    (%edx),%edx
  802258:	89 10                	mov    %edx,(%eax)
  80225a:	eb 0a                	jmp    802266 <initialize_dynamic_allocator+0xca>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 00                	mov    (%eax),%eax
  802261:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802279:	a1 38 50 80 00       	mov    0x805038,%eax
  80227e:	48                   	dec    %eax
  80227f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802284:	a1 34 50 80 00       	mov    0x805034,%eax
  802289:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802290:	74 07                	je     802299 <initialize_dynamic_allocator+0xfd>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	eb 05                	jmp    80229e <initialize_dynamic_allocator+0x102>
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
  80229e:	a3 34 50 80 00       	mov    %eax,0x805034
  8022a3:	a1 34 50 80 00       	mov    0x805034,%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	0f 85 55 ff ff ff    	jne    802205 <initialize_dynamic_allocator+0x69>
  8022b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b4:	0f 85 4b ff ff ff    	jne    802205 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022c9:	a1 44 50 80 00       	mov    0x805044,%eax
  8022ce:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	83 c0 08             	add    $0x8,%eax
  8022e4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	83 c0 04             	add    $0x4,%eax
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	83 ea 08             	sub    $0x8,%edx
  8022f3:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	01 d0                	add    %edx,%eax
  8022fd:	83 e8 08             	sub    $0x8,%eax
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	83 ea 08             	sub    $0x8,%edx
  802306:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80231b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80231f:	75 17                	jne    802338 <initialize_dynamic_allocator+0x19c>
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	68 fc 46 80 00       	push   $0x8046fc
  802329:	68 90 00 00 00       	push   $0x90
  80232e:	68 e1 46 80 00       	push   $0x8046e1
  802333:	e8 24 19 00 00       	call   803c5c <_panic>
  802338:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80233e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802341:	89 10                	mov    %edx,(%eax)
  802343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	74 0d                	je     802359 <initialize_dynamic_allocator+0x1bd>
  80234c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802351:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802354:	89 50 04             	mov    %edx,0x4(%eax)
  802357:	eb 08                	jmp    802361 <initialize_dynamic_allocator+0x1c5>
  802359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235c:	a3 30 50 80 00       	mov    %eax,0x805030
  802361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802364:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802373:	a1 38 50 80 00       	mov    0x805038,%eax
  802378:	40                   	inc    %eax
  802379:	a3 38 50 80 00       	mov    %eax,0x805038
  80237e:	eb 07                	jmp    802387 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802380:	90                   	nop
  802381:	eb 04                	jmp    802387 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802383:	90                   	nop
  802384:	eb 01                	jmp    802387 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802386:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80238c:	8b 45 10             	mov    0x10(%ebp),%eax
  80238f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8d 50 fc             	lea    -0x4(%eax),%edx
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	83 e8 04             	sub    $0x4,%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8023a8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	01 c2                	add    %eax,%edx
  8023b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b3:	89 02                	mov    %eax,(%edx)
}
  8023b5:	90                   	nop
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    

008023b8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	83 e0 01             	and    $0x1,%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	74 03                	je     8023cb <alloc_block_FF+0x13>
  8023c8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023cb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023cf:	77 07                	ja     8023d8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023d1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	75 73                	jne    802454 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	83 c0 10             	add    $0x10,%eax
  8023e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023ea:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	48                   	dec    %eax
  8023fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802400:	ba 00 00 00 00       	mov    $0x0,%edx
  802405:	f7 75 ec             	divl   -0x14(%ebp)
  802408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240b:	29 d0                	sub    %edx,%eax
  80240d:	c1 e8 0c             	shr    $0xc,%eax
  802410:	83 ec 0c             	sub    $0xc,%esp
  802413:	50                   	push   %eax
  802414:	e8 27 f0 ff ff       	call   801440 <sbrk>
  802419:	83 c4 10             	add    $0x10,%esp
  80241c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80241f:	83 ec 0c             	sub    $0xc,%esp
  802422:	6a 00                	push   $0x0
  802424:	e8 17 f0 ff ff       	call   801440 <sbrk>
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80242f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802432:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802435:	83 ec 08             	sub    $0x8,%esp
  802438:	50                   	push   %eax
  802439:	ff 75 e4             	pushl  -0x1c(%ebp)
  80243c:	e8 5b fd ff ff       	call   80219c <initialize_dynamic_allocator>
  802441:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	68 1f 47 80 00       	push   $0x80471f
  80244c:	e8 55 e2 ff ff       	call   8006a6 <cprintf>
  802451:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802458:	75 0a                	jne    802464 <alloc_block_FF+0xac>
	        return NULL;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	e9 0e 04 00 00       	jmp    802872 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802464:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80246b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802473:	e9 f3 02 00 00       	jmp    80276b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80247e:	83 ec 0c             	sub    $0xc,%esp
  802481:	ff 75 bc             	pushl  -0x44(%ebp)
  802484:	e8 af fb ff ff       	call   802038 <get_block_size>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	83 c0 08             	add    $0x8,%eax
  802495:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802498:	0f 87 c5 02 00 00    	ja     802763 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	83 c0 18             	add    $0x18,%eax
  8024a4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024a7:	0f 87 19 02 00 00    	ja     8026c6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024b0:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b3:	83 e8 08             	sub    $0x8,%eax
  8024b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8d 50 08             	lea    0x8(%eax),%edx
  8024bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024c2:	01 d0                	add    %edx,%eax
  8024c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	83 c0 08             	add    $0x8,%eax
  8024cd:	83 ec 04             	sub    $0x4,%esp
  8024d0:	6a 01                	push   $0x1
  8024d2:	50                   	push   %eax
  8024d3:	ff 75 bc             	pushl  -0x44(%ebp)
  8024d6:	e8 ae fe ff ff       	call   802389 <set_block_data>
  8024db:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	75 68                	jne    802550 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024e8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ec:	75 17                	jne    802505 <alloc_block_FF+0x14d>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 fc 46 80 00       	push   $0x8046fc
  8024f6:	68 d7 00 00 00       	push   $0xd7
  8024fb:	68 e1 46 80 00       	push   $0x8046e1
  802500:	e8 57 17 00 00       	call   803c5c <_panic>
  802505:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80250b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0d                	je     802526 <alloc_block_FF+0x16e>
  802519:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80251e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802521:	89 50 04             	mov    %edx,0x4(%eax)
  802524:	eb 08                	jmp    80252e <alloc_block_FF+0x176>
  802526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802529:	a3 30 50 80 00       	mov    %eax,0x805030
  80252e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802531:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802536:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802540:	a1 38 50 80 00       	mov    0x805038,%eax
  802545:	40                   	inc    %eax
  802546:	a3 38 50 80 00       	mov    %eax,0x805038
  80254b:	e9 dc 00 00 00       	jmp    80262c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	75 65                	jne    8025be <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802559:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80255d:	75 17                	jne    802576 <alloc_block_FF+0x1be>
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 30 47 80 00       	push   $0x804730
  802567:	68 db 00 00 00       	push   $0xdb
  80256c:	68 e1 46 80 00       	push   $0x8046e1
  802571:	e8 e6 16 00 00       	call   803c5c <_panic>
  802576:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80257c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	74 0c                	je     802598 <alloc_block_FF+0x1e0>
  80258c:	a1 30 50 80 00       	mov    0x805030,%eax
  802591:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802594:	89 10                	mov    %edx,(%eax)
  802596:	eb 08                	jmp    8025a0 <alloc_block_FF+0x1e8>
  802598:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b6:	40                   	inc    %eax
  8025b7:	a3 38 50 80 00       	mov    %eax,0x805038
  8025bc:	eb 6e                	jmp    80262c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c2:	74 06                	je     8025ca <alloc_block_FF+0x212>
  8025c4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_FF+0x229>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 54 47 80 00       	push   $0x804754
  8025d2:	68 df 00 00 00       	push   $0xdf
  8025d7:	68 e1 46 80 00       	push   $0x8046e1
  8025dc:	e8 7b 16 00 00       	call   803c5c <_panic>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 10                	mov    (%eax),%edx
  8025e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e9:	89 10                	mov    %edx,(%eax)
  8025eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	74 0b                	je     8025ff <alloc_block_FF+0x247>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025fc:	89 50 04             	mov    %edx,0x4(%eax)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802605:	89 10                	mov    %edx,(%eax)
  802607:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260d:	89 50 04             	mov    %edx,0x4(%eax)
  802610:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	75 08                	jne    802621 <alloc_block_FF+0x269>
  802619:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261c:	a3 30 50 80 00       	mov    %eax,0x805030
  802621:	a1 38 50 80 00       	mov    0x805038,%eax
  802626:	40                   	inc    %eax
  802627:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80262c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802630:	75 17                	jne    802649 <alloc_block_FF+0x291>
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	68 c3 46 80 00       	push   $0x8046c3
  80263a:	68 e1 00 00 00       	push   $0xe1
  80263f:	68 e1 46 80 00       	push   $0x8046e1
  802644:	e8 13 16 00 00       	call   803c5c <_panic>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 10                	je     802662 <alloc_block_FF+0x2aa>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265a:	8b 52 04             	mov    0x4(%edx),%edx
  80265d:	89 50 04             	mov    %edx,0x4(%eax)
  802660:	eb 0b                	jmp    80266d <alloc_block_FF+0x2b5>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	a3 30 50 80 00       	mov    %eax,0x805030
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	74 0f                	je     802686 <alloc_block_FF+0x2ce>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	8b 12                	mov    (%edx),%edx
  802682:	89 10                	mov    %edx,(%eax)
  802684:	eb 0a                	jmp    802690 <alloc_block_FF+0x2d8>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a8:	48                   	dec    %eax
  8026a9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026ae:	83 ec 04             	sub    $0x4,%esp
  8026b1:	6a 00                	push   $0x0
  8026b3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026b6:	ff 75 b0             	pushl  -0x50(%ebp)
  8026b9:	e8 cb fc ff ff       	call   802389 <set_block_data>
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	e9 95 00 00 00       	jmp    80275b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	6a 01                	push   $0x1
  8026cb:	ff 75 b8             	pushl  -0x48(%ebp)
  8026ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8026d1:	e8 b3 fc ff ff       	call   802389 <set_block_data>
  8026d6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dd:	75 17                	jne    8026f6 <alloc_block_FF+0x33e>
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 c3 46 80 00       	push   $0x8046c3
  8026e7:	68 e8 00 00 00       	push   $0xe8
  8026ec:	68 e1 46 80 00       	push   $0x8046e1
  8026f1:	e8 66 15 00 00       	call   803c5c <_panic>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 10                	je     80270f <alloc_block_FF+0x357>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802707:	8b 52 04             	mov    0x4(%edx),%edx
  80270a:	89 50 04             	mov    %edx,0x4(%eax)
  80270d:	eb 0b                	jmp    80271a <alloc_block_FF+0x362>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	a3 30 50 80 00       	mov    %eax,0x805030
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 04             	mov    0x4(%eax),%eax
  802720:	85 c0                	test   %eax,%eax
  802722:	74 0f                	je     802733 <alloc_block_FF+0x37b>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272d:	8b 12                	mov    (%edx),%edx
  80272f:	89 10                	mov    %edx,(%eax)
  802731:	eb 0a                	jmp    80273d <alloc_block_FF+0x385>
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802750:	a1 38 50 80 00       	mov    0x805038,%eax
  802755:	48                   	dec    %eax
  802756:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80275b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80275e:	e9 0f 01 00 00       	jmp    802872 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802763:	a1 34 50 80 00       	mov    0x805034,%eax
  802768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276f:	74 07                	je     802778 <alloc_block_FF+0x3c0>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	eb 05                	jmp    80277d <alloc_block_FF+0x3c5>
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	a3 34 50 80 00       	mov    %eax,0x805034
  802782:	a1 34 50 80 00       	mov    0x805034,%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 85 e9 fc ff ff    	jne    802478 <alloc_block_FF+0xc0>
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	0f 85 df fc ff ff    	jne    802478 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	83 c0 08             	add    $0x8,%eax
  80279f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027a2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	48                   	dec    %eax
  8027b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bd:	f7 75 d8             	divl   -0x28(%ebp)
  8027c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c3:	29 d0                	sub    %edx,%eax
  8027c5:	c1 e8 0c             	shr    $0xc,%eax
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	50                   	push   %eax
  8027cc:	e8 6f ec ff ff       	call   801440 <sbrk>
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027d7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027db:	75 0a                	jne    8027e7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e2:	e9 8b 00 00 00       	jmp    802872 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027e7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802802:	f7 75 cc             	divl   -0x34(%ebp)
  802805:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802808:	29 d0                	sub    %edx,%eax
  80280a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80280d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802810:	01 d0                	add    %edx,%eax
  802812:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802817:	a1 40 50 80 00       	mov    0x805040,%eax
  80281c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802822:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802829:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80282c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80282f:	01 d0                	add    %edx,%eax
  802831:	48                   	dec    %eax
  802832:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802835:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802838:	ba 00 00 00 00       	mov    $0x0,%edx
  80283d:	f7 75 c4             	divl   -0x3c(%ebp)
  802840:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802843:	29 d0                	sub    %edx,%eax
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	6a 01                	push   $0x1
  80284a:	50                   	push   %eax
  80284b:	ff 75 d0             	pushl  -0x30(%ebp)
  80284e:	e8 36 fb ff ff       	call   802389 <set_block_data>
  802853:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	ff 75 d0             	pushl  -0x30(%ebp)
  80285c:	e8 f8 09 00 00       	call   803259 <free_block>
  802861:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	ff 75 08             	pushl  0x8(%ebp)
  80286a:	e8 49 fb ff ff       	call   8023b8 <alloc_block_FF>
  80286f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	83 e0 01             	and    $0x1,%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 03                	je     802887 <alloc_block_BF+0x13>
  802884:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802887:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80288b:	77 07                	ja     802894 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80288d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802894:	a1 24 50 80 00       	mov    0x805024,%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	75 73                	jne    802910 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	83 c0 10             	add    $0x10,%eax
  8028a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028a6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	01 d0                	add    %edx,%eax
  8028b5:	48                   	dec    %eax
  8028b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c1:	f7 75 e0             	divl   -0x20(%ebp)
  8028c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c7:	29 d0                	sub    %edx,%eax
  8028c9:	c1 e8 0c             	shr    $0xc,%eax
  8028cc:	83 ec 0c             	sub    $0xc,%esp
  8028cf:	50                   	push   %eax
  8028d0:	e8 6b eb ff ff       	call   801440 <sbrk>
  8028d5:	83 c4 10             	add    $0x10,%esp
  8028d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028db:	83 ec 0c             	sub    $0xc,%esp
  8028de:	6a 00                	push   $0x0
  8028e0:	e8 5b eb ff ff       	call   801440 <sbrk>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ee:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028f1:	83 ec 08             	sub    $0x8,%esp
  8028f4:	50                   	push   %eax
  8028f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8028f8:	e8 9f f8 ff ff       	call   80219c <initialize_dynamic_allocator>
  8028fd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802900:	83 ec 0c             	sub    $0xc,%esp
  802903:	68 1f 47 80 00       	push   $0x80471f
  802908:	e8 99 dd ff ff       	call   8006a6 <cprintf>
  80290d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802917:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80291e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802925:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80292c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802934:	e9 1d 01 00 00       	jmp    802a56 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80293f:	83 ec 0c             	sub    $0xc,%esp
  802942:	ff 75 a8             	pushl  -0x58(%ebp)
  802945:	e8 ee f6 ff ff       	call   802038 <get_block_size>
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	83 c0 08             	add    $0x8,%eax
  802956:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802959:	0f 87 ef 00 00 00    	ja     802a4e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	83 c0 18             	add    $0x18,%eax
  802965:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802968:	77 1d                	ja     802987 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802970:	0f 86 d8 00 00 00    	jbe    802a4e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802976:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802979:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80297c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80297f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802982:	e9 c7 00 00 00       	jmp    802a4e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	83 c0 08             	add    $0x8,%eax
  80298d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802990:	0f 85 9d 00 00 00    	jne    802a33 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	6a 01                	push   $0x1
  80299b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80299e:	ff 75 a8             	pushl  -0x58(%ebp)
  8029a1:	e8 e3 f9 ff ff       	call   802389 <set_block_data>
  8029a6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	75 17                	jne    8029c6 <alloc_block_BF+0x152>
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	68 c3 46 80 00       	push   $0x8046c3
  8029b7:	68 2c 01 00 00       	push   $0x12c
  8029bc:	68 e1 46 80 00       	push   $0x8046e1
  8029c1:	e8 96 12 00 00       	call   803c5c <_panic>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	74 10                	je     8029df <alloc_block_BF+0x16b>
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d7:	8b 52 04             	mov    0x4(%edx),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	eb 0b                	jmp    8029ea <alloc_block_BF+0x176>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0f                	je     802a03 <alloc_block_BF+0x18f>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fd:	8b 12                	mov    (%edx),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	eb 0a                	jmp    802a0d <alloc_block_BF+0x199>
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a20:	a1 38 50 80 00       	mov    0x805038,%eax
  802a25:	48                   	dec    %eax
  802a26:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a2b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a2e:	e9 01 04 00 00       	jmp    802e34 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a36:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a39:	76 13                	jbe    802a4e <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a3b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a42:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a48:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a4e:	a1 34 50 80 00       	mov    0x805034,%eax
  802a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	74 07                	je     802a63 <alloc_block_BF+0x1ef>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	eb 05                	jmp    802a68 <alloc_block_BF+0x1f4>
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	a3 34 50 80 00       	mov    %eax,0x805034
  802a6d:	a1 34 50 80 00       	mov    0x805034,%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	0f 85 bf fe ff ff    	jne    802939 <alloc_block_BF+0xc5>
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	0f 85 b5 fe ff ff    	jne    802939 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a88:	0f 84 26 02 00 00    	je     802cb4 <alloc_block_BF+0x440>
  802a8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a92:	0f 85 1c 02 00 00    	jne    802cb4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9e:	83 e8 08             	sub    $0x8,%eax
  802aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	8d 50 08             	lea    0x8(%eax),%edx
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	83 c0 08             	add    $0x8,%eax
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	6a 01                	push   $0x1
  802abd:	50                   	push   %eax
  802abe:	ff 75 f0             	pushl  -0x10(%ebp)
  802ac1:	e8 c3 f8 ff ff       	call   802389 <set_block_data>
  802ac6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	75 68                	jne    802b3b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ad3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ad7:	75 17                	jne    802af0 <alloc_block_BF+0x27c>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 fc 46 80 00       	push   $0x8046fc
  802ae1:	68 45 01 00 00       	push   $0x145
  802ae6:	68 e1 46 80 00       	push   $0x8046e1
  802aeb:	e8 6c 11 00 00       	call   803c5c <_panic>
  802af0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802af6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 0d                	je     802b11 <alloc_block_BF+0x29d>
  802b04:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 08                	jmp    802b19 <alloc_block_BF+0x2a5>
  802b11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b14:	a3 30 50 80 00       	mov    %eax,0x805030
  802b19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b30:	40                   	inc    %eax
  802b31:	a3 38 50 80 00       	mov    %eax,0x805038
  802b36:	e9 dc 00 00 00       	jmp    802c17 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	75 65                	jne    802ba9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b44:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b48:	75 17                	jne    802b61 <alloc_block_BF+0x2ed>
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	68 30 47 80 00       	push   $0x804730
  802b52:	68 4a 01 00 00       	push   $0x14a
  802b57:	68 e1 46 80 00       	push   $0x8046e1
  802b5c:	e8 fb 10 00 00       	call   803c5c <_panic>
  802b61:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 0c                	je     802b83 <alloc_block_BF+0x30f>
  802b77:	a1 30 50 80 00       	mov    0x805030,%eax
  802b7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b7f:	89 10                	mov    %edx,(%eax)
  802b81:	eb 08                	jmp    802b8b <alloc_block_BF+0x317>
  802b83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b86:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba1:	40                   	inc    %eax
  802ba2:	a3 38 50 80 00       	mov    %eax,0x805038
  802ba7:	eb 6e                	jmp    802c17 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bad:	74 06                	je     802bb5 <alloc_block_BF+0x341>
  802baf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bb3:	75 17                	jne    802bcc <alloc_block_BF+0x358>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 54 47 80 00       	push   $0x804754
  802bbd:	68 4f 01 00 00       	push   $0x14f
  802bc2:	68 e1 46 80 00       	push   $0x8046e1
  802bc7:	e8 90 10 00 00       	call   803c5c <_panic>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 10                	mov    (%eax),%edx
  802bd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0b                	je     802bea <alloc_block_BF+0x376>
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802be7:	89 50 04             	mov    %edx,0x4(%eax)
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf8:	89 50 04             	mov    %edx,0x4(%eax)
  802bfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	75 08                	jne    802c0c <alloc_block_BF+0x398>
  802c04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c07:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0c:	a1 38 50 80 00       	mov    0x805038,%eax
  802c11:	40                   	inc    %eax
  802c12:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1b:	75 17                	jne    802c34 <alloc_block_BF+0x3c0>
  802c1d:	83 ec 04             	sub    $0x4,%esp
  802c20:	68 c3 46 80 00       	push   $0x8046c3
  802c25:	68 51 01 00 00       	push   $0x151
  802c2a:	68 e1 46 80 00       	push   $0x8046e1
  802c2f:	e8 28 10 00 00       	call   803c5c <_panic>
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	74 10                	je     802c4d <alloc_block_BF+0x3d9>
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c45:	8b 52 04             	mov    0x4(%edx),%edx
  802c48:	89 50 04             	mov    %edx,0x4(%eax)
  802c4b:	eb 0b                	jmp    802c58 <alloc_block_BF+0x3e4>
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	a3 30 50 80 00       	mov    %eax,0x805030
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0f                	je     802c71 <alloc_block_BF+0x3fd>
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6b:	8b 12                	mov    (%edx),%edx
  802c6d:	89 10                	mov    %edx,(%eax)
  802c6f:	eb 0a                	jmp    802c7b <alloc_block_BF+0x407>
  802c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 38 50 80 00       	mov    0x805038,%eax
  802c93:	48                   	dec    %eax
  802c94:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	6a 00                	push   $0x0
  802c9e:	ff 75 d0             	pushl  -0x30(%ebp)
  802ca1:	ff 75 cc             	pushl  -0x34(%ebp)
  802ca4:	e8 e0 f6 ff ff       	call   802389 <set_block_data>
  802ca9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	e9 80 01 00 00       	jmp    802e34 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802cb4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cb8:	0f 85 9d 00 00 00    	jne    802d5b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	6a 01                	push   $0x1
  802cc3:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc6:	ff 75 f0             	pushl  -0x10(%ebp)
  802cc9:	e8 bb f6 ff ff       	call   802389 <set_block_data>
  802cce:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd5:	75 17                	jne    802cee <alloc_block_BF+0x47a>
  802cd7:	83 ec 04             	sub    $0x4,%esp
  802cda:	68 c3 46 80 00       	push   $0x8046c3
  802cdf:	68 58 01 00 00       	push   $0x158
  802ce4:	68 e1 46 80 00       	push   $0x8046e1
  802ce9:	e8 6e 0f 00 00       	call   803c5c <_panic>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 10                	je     802d07 <alloc_block_BF+0x493>
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cff:	8b 52 04             	mov    0x4(%edx),%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	eb 0b                	jmp    802d12 <alloc_block_BF+0x49e>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 40 04             	mov    0x4(%eax),%eax
  802d0d:	a3 30 50 80 00       	mov    %eax,0x805030
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0f                	je     802d2b <alloc_block_BF+0x4b7>
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d25:	8b 12                	mov    (%edx),%edx
  802d27:	89 10                	mov    %edx,(%eax)
  802d29:	eb 0a                	jmp    802d35 <alloc_block_BF+0x4c1>
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2e:	8b 00                	mov    (%eax),%eax
  802d30:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d48:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4d:	48                   	dec    %eax
  802d4e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	e9 d9 00 00 00       	jmp    802e34 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	83 c0 08             	add    $0x8,%eax
  802d61:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d64:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d6b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d6e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d71:	01 d0                	add    %edx,%eax
  802d73:	48                   	dec    %eax
  802d74:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d77:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7f:	f7 75 c4             	divl   -0x3c(%ebp)
  802d82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d85:	29 d0                	sub    %edx,%eax
  802d87:	c1 e8 0c             	shr    $0xc,%eax
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	50                   	push   %eax
  802d8e:	e8 ad e6 ff ff       	call   801440 <sbrk>
  802d93:	83 c4 10             	add    $0x10,%esp
  802d96:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d99:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d9d:	75 0a                	jne    802da9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802da4:	e9 8b 00 00 00       	jmp    802e34 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802da9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802db0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	48                   	dec    %eax
  802db9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dbc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc4:	f7 75 b8             	divl   -0x48(%ebp)
  802dc7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dca:	29 d0                	sub    %edx,%eax
  802dcc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dcf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dd2:	01 d0                	add    %edx,%eax
  802dd4:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802dd9:	a1 40 50 80 00       	mov    0x805040,%eax
  802dde:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802de4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802deb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802df1:	01 d0                	add    %edx,%eax
  802df3:	48                   	dec    %eax
  802df4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802df7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  802dff:	f7 75 b0             	divl   -0x50(%ebp)
  802e02:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e05:	29 d0                	sub    %edx,%eax
  802e07:	83 ec 04             	sub    $0x4,%esp
  802e0a:	6a 01                	push   $0x1
  802e0c:	50                   	push   %eax
  802e0d:	ff 75 bc             	pushl  -0x44(%ebp)
  802e10:	e8 74 f5 ff ff       	call   802389 <set_block_data>
  802e15:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e18:	83 ec 0c             	sub    $0xc,%esp
  802e1b:	ff 75 bc             	pushl  -0x44(%ebp)
  802e1e:	e8 36 04 00 00       	call   803259 <free_block>
  802e23:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e26:	83 ec 0c             	sub    $0xc,%esp
  802e29:	ff 75 08             	pushl  0x8(%ebp)
  802e2c:	e8 43 fa ff ff       	call   802874 <alloc_block_BF>
  802e31:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e34:	c9                   	leave  
  802e35:	c3                   	ret    

00802e36 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e36:	55                   	push   %ebp
  802e37:	89 e5                	mov    %esp,%ebp
  802e39:	53                   	push   %ebx
  802e3a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4f:	74 1e                	je     802e6f <merging+0x39>
  802e51:	ff 75 08             	pushl  0x8(%ebp)
  802e54:	e8 df f1 ff ff       	call   802038 <get_block_size>
  802e59:	83 c4 04             	add    $0x4,%esp
  802e5c:	89 c2                	mov    %eax,%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	01 d0                	add    %edx,%eax
  802e63:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e66:	75 07                	jne    802e6f <merging+0x39>
		prev_is_free = 1;
  802e68:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e73:	74 1e                	je     802e93 <merging+0x5d>
  802e75:	ff 75 10             	pushl  0x10(%ebp)
  802e78:	e8 bb f1 ff ff       	call   802038 <get_block_size>
  802e7d:	83 c4 04             	add    $0x4,%esp
  802e80:	89 c2                	mov    %eax,%edx
  802e82:	8b 45 10             	mov    0x10(%ebp),%eax
  802e85:	01 d0                	add    %edx,%eax
  802e87:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e8a:	75 07                	jne    802e93 <merging+0x5d>
		next_is_free = 1;
  802e8c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e97:	0f 84 cc 00 00 00    	je     802f69 <merging+0x133>
  802e9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea1:	0f 84 c2 00 00 00    	je     802f69 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ea7:	ff 75 08             	pushl  0x8(%ebp)
  802eaa:	e8 89 f1 ff ff       	call   802038 <get_block_size>
  802eaf:	83 c4 04             	add    $0x4,%esp
  802eb2:	89 c3                	mov    %eax,%ebx
  802eb4:	ff 75 10             	pushl  0x10(%ebp)
  802eb7:	e8 7c f1 ff ff       	call   802038 <get_block_size>
  802ebc:	83 c4 04             	add    $0x4,%esp
  802ebf:	01 c3                	add    %eax,%ebx
  802ec1:	ff 75 0c             	pushl  0xc(%ebp)
  802ec4:	e8 6f f1 ff ff       	call   802038 <get_block_size>
  802ec9:	83 c4 04             	add    $0x4,%esp
  802ecc:	01 d8                	add    %ebx,%eax
  802ece:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ed1:	6a 00                	push   $0x0
  802ed3:	ff 75 ec             	pushl  -0x14(%ebp)
  802ed6:	ff 75 08             	pushl  0x8(%ebp)
  802ed9:	e8 ab f4 ff ff       	call   802389 <set_block_data>
  802ede:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ee1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee5:	75 17                	jne    802efe <merging+0xc8>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 c3 46 80 00       	push   $0x8046c3
  802eef:	68 7d 01 00 00       	push   $0x17d
  802ef4:	68 e1 46 80 00       	push   $0x8046e1
  802ef9:	e8 5e 0d 00 00       	call   803c5c <_panic>
  802efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 10                	je     802f17 <merging+0xe1>
  802f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f0f:	8b 52 04             	mov    0x4(%edx),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 0b                	jmp    802f22 <merging+0xec>
  802f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0f                	je     802f3b <merging+0x105>
  802f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f35:	8b 12                	mov    (%edx),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 0a                	jmp    802f45 <merging+0x10f>
  802f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 38 50 80 00       	mov    0x805038,%eax
  802f5d:	48                   	dec    %eax
  802f5e:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f63:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f64:	e9 ea 02 00 00       	jmp    803253 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6d:	74 3b                	je     802faa <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f6f:	83 ec 0c             	sub    $0xc,%esp
  802f72:	ff 75 08             	pushl  0x8(%ebp)
  802f75:	e8 be f0 ff ff       	call   802038 <get_block_size>
  802f7a:	83 c4 10             	add    $0x10,%esp
  802f7d:	89 c3                	mov    %eax,%ebx
  802f7f:	83 ec 0c             	sub    $0xc,%esp
  802f82:	ff 75 10             	pushl  0x10(%ebp)
  802f85:	e8 ae f0 ff ff       	call   802038 <get_block_size>
  802f8a:	83 c4 10             	add    $0x10,%esp
  802f8d:	01 d8                	add    %ebx,%eax
  802f8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	6a 00                	push   $0x0
  802f97:	ff 75 e8             	pushl  -0x18(%ebp)
  802f9a:	ff 75 08             	pushl  0x8(%ebp)
  802f9d:	e8 e7 f3 ff ff       	call   802389 <set_block_data>
  802fa2:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa5:	e9 a9 02 00 00       	jmp    803253 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802faa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fae:	0f 84 2d 01 00 00    	je     8030e1 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fb4:	83 ec 0c             	sub    $0xc,%esp
  802fb7:	ff 75 10             	pushl  0x10(%ebp)
  802fba:	e8 79 f0 ff ff       	call   802038 <get_block_size>
  802fbf:	83 c4 10             	add    $0x10,%esp
  802fc2:	89 c3                	mov    %eax,%ebx
  802fc4:	83 ec 0c             	sub    $0xc,%esp
  802fc7:	ff 75 0c             	pushl  0xc(%ebp)
  802fca:	e8 69 f0 ff ff       	call   802038 <get_block_size>
  802fcf:	83 c4 10             	add    $0x10,%esp
  802fd2:	01 d8                	add    %ebx,%eax
  802fd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	6a 00                	push   $0x0
  802fdc:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fdf:	ff 75 10             	pushl  0x10(%ebp)
  802fe2:	e8 a2 f3 ff ff       	call   802389 <set_block_data>
  802fe7:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802fea:	8b 45 10             	mov    0x10(%ebp),%eax
  802fed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ff0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff4:	74 06                	je     802ffc <merging+0x1c6>
  802ff6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ffa:	75 17                	jne    803013 <merging+0x1dd>
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 88 47 80 00       	push   $0x804788
  803004:	68 8d 01 00 00       	push   $0x18d
  803009:	68 e1 46 80 00       	push   $0x8046e1
  80300e:	e8 49 0c 00 00       	call   803c5c <_panic>
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	8b 50 04             	mov    0x4(%eax),%edx
  803019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301c:	89 50 04             	mov    %edx,0x4(%eax)
  80301f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803022:	8b 55 0c             	mov    0xc(%ebp),%edx
  803025:	89 10                	mov    %edx,(%eax)
  803027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302a:	8b 40 04             	mov    0x4(%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 0d                	je     80303e <merging+0x208>
  803031:	8b 45 0c             	mov    0xc(%ebp),%eax
  803034:	8b 40 04             	mov    0x4(%eax),%eax
  803037:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	eb 08                	jmp    803046 <merging+0x210>
  80303e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803041:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803046:	8b 45 0c             	mov    0xc(%ebp),%eax
  803049:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	a1 38 50 80 00       	mov    0x805038,%eax
  803054:	40                   	inc    %eax
  803055:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80305a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80305e:	75 17                	jne    803077 <merging+0x241>
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	68 c3 46 80 00       	push   $0x8046c3
  803068:	68 8e 01 00 00       	push   $0x18e
  80306d:	68 e1 46 80 00       	push   $0x8046e1
  803072:	e8 e5 0b 00 00       	call   803c5c <_panic>
  803077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 10                	je     803090 <merging+0x25a>
  803080:	8b 45 0c             	mov    0xc(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	8b 55 0c             	mov    0xc(%ebp),%edx
  803088:	8b 52 04             	mov    0x4(%edx),%edx
  80308b:	89 50 04             	mov    %edx,0x4(%eax)
  80308e:	eb 0b                	jmp    80309b <merging+0x265>
  803090:	8b 45 0c             	mov    0xc(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	a3 30 50 80 00       	mov    %eax,0x805030
  80309b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309e:	8b 40 04             	mov    0x4(%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 0f                	je     8030b4 <merging+0x27e>
  8030a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ae:	8b 12                	mov    (%edx),%edx
  8030b0:	89 10                	mov    %edx,(%eax)
  8030b2:	eb 0a                	jmp    8030be <merging+0x288>
  8030b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d6:	48                   	dec    %eax
  8030d7:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030dc:	e9 72 01 00 00       	jmp    803253 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8030e4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030eb:	74 79                	je     803166 <merging+0x330>
  8030ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030f1:	74 73                	je     803166 <merging+0x330>
  8030f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f7:	74 06                	je     8030ff <merging+0x2c9>
  8030f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030fd:	75 17                	jne    803116 <merging+0x2e0>
  8030ff:	83 ec 04             	sub    $0x4,%esp
  803102:	68 54 47 80 00       	push   $0x804754
  803107:	68 94 01 00 00       	push   $0x194
  80310c:	68 e1 46 80 00       	push   $0x8046e1
  803111:	e8 46 0b 00 00       	call   803c5c <_panic>
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	8b 10                	mov    (%eax),%edx
  80311b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311e:	89 10                	mov    %edx,(%eax)
  803120:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 0b                	je     803134 <merging+0x2fe>
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313f:	8b 55 08             	mov    0x8(%ebp),%edx
  803142:	89 50 04             	mov    %edx,0x4(%eax)
  803145:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	75 08                	jne    803156 <merging+0x320>
  80314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803151:	a3 30 50 80 00       	mov    %eax,0x805030
  803156:	a1 38 50 80 00       	mov    0x805038,%eax
  80315b:	40                   	inc    %eax
  80315c:	a3 38 50 80 00       	mov    %eax,0x805038
  803161:	e9 ce 00 00 00       	jmp    803234 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316a:	74 65                	je     8031d1 <merging+0x39b>
  80316c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803170:	75 17                	jne    803189 <merging+0x353>
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	68 30 47 80 00       	push   $0x804730
  80317a:	68 95 01 00 00       	push   $0x195
  80317f:	68 e1 46 80 00       	push   $0x8046e1
  803184:	e8 d3 0a 00 00       	call   803c5c <_panic>
  803189:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80318f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803192:	89 50 04             	mov    %edx,0x4(%eax)
  803195:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 0c                	je     8031ab <merging+0x375>
  80319f:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	eb 08                	jmp    8031b3 <merging+0x37d>
  8031ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8031bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c4:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c9:	40                   	inc    %eax
  8031ca:	a3 38 50 80 00       	mov    %eax,0x805038
  8031cf:	eb 63                	jmp    803234 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031d5:	75 17                	jne    8031ee <merging+0x3b8>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 fc 46 80 00       	push   $0x8046fc
  8031df:	68 98 01 00 00       	push   $0x198
  8031e4:	68 e1 46 80 00       	push   $0x8046e1
  8031e9:	e8 6e 0a 00 00       	call   803c5c <_panic>
  8031ee:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0d                	je     80320f <merging+0x3d9>
  803202:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803207:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 08                	jmp    803217 <merging+0x3e1>
  80320f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803212:	a3 30 50 80 00       	mov    %eax,0x805030
  803217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80321f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 38 50 80 00       	mov    0x805038,%eax
  80322e:	40                   	inc    %eax
  80322f:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803234:	83 ec 0c             	sub    $0xc,%esp
  803237:	ff 75 10             	pushl  0x10(%ebp)
  80323a:	e8 f9 ed ff ff       	call   802038 <get_block_size>
  80323f:	83 c4 10             	add    $0x10,%esp
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	6a 00                	push   $0x0
  803247:	50                   	push   %eax
  803248:	ff 75 10             	pushl  0x10(%ebp)
  80324b:	e8 39 f1 ff ff       	call   802389 <set_block_data>
  803250:	83 c4 10             	add    $0x10,%esp
	}
}
  803253:	90                   	nop
  803254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803257:	c9                   	leave  
  803258:	c3                   	ret    

00803259 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803259:	55                   	push   %ebp
  80325a:	89 e5                	mov    %esp,%ebp
  80325c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80325f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803264:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803267:	a1 30 50 80 00       	mov    0x805030,%eax
  80326c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80326f:	73 1b                	jae    80328c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803271:	a1 30 50 80 00       	mov    0x805030,%eax
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	ff 75 08             	pushl  0x8(%ebp)
  80327c:	6a 00                	push   $0x0
  80327e:	50                   	push   %eax
  80327f:	e8 b2 fb ff ff       	call   802e36 <merging>
  803284:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803287:	e9 8b 00 00 00       	jmp    803317 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80328c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803291:	3b 45 08             	cmp    0x8(%ebp),%eax
  803294:	76 18                	jbe    8032ae <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803296:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	ff 75 08             	pushl  0x8(%ebp)
  8032a1:	50                   	push   %eax
  8032a2:	6a 00                	push   $0x0
  8032a4:	e8 8d fb ff ff       	call   802e36 <merging>
  8032a9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ac:	eb 69                	jmp    803317 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b6:	eb 39                	jmp    8032f1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032be:	73 29                	jae    8032e9 <free_block+0x90>
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c8:	76 1f                	jbe    8032e9 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	ff 75 08             	pushl  0x8(%ebp)
  8032d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8032db:	ff 75 f4             	pushl  -0xc(%ebp)
  8032de:	e8 53 fb ff ff       	call   802e36 <merging>
  8032e3:	83 c4 10             	add    $0x10,%esp
			break;
  8032e6:	90                   	nop
		}
	}
}
  8032e7:	eb 2e                	jmp    803317 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8032ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f5:	74 07                	je     8032fe <free_block+0xa5>
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	8b 00                	mov    (%eax),%eax
  8032fc:	eb 05                	jmp    803303 <free_block+0xaa>
  8032fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803303:	a3 34 50 80 00       	mov    %eax,0x805034
  803308:	a1 34 50 80 00       	mov    0x805034,%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	75 a7                	jne    8032b8 <free_block+0x5f>
  803311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803315:	75 a1                	jne    8032b8 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803317:	90                   	nop
  803318:	c9                   	leave  
  803319:	c3                   	ret    

0080331a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
  80331d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803320:	ff 75 08             	pushl  0x8(%ebp)
  803323:	e8 10 ed ff ff       	call   802038 <get_block_size>
  803328:	83 c4 04             	add    $0x4,%esp
  80332b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80332e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803335:	eb 17                	jmp    80334e <copy_data+0x34>
  803337:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80333a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333d:	01 c2                	add    %eax,%edx
  80333f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	01 c8                	add    %ecx,%eax
  803347:	8a 00                	mov    (%eax),%al
  803349:	88 02                	mov    %al,(%edx)
  80334b:	ff 45 fc             	incl   -0x4(%ebp)
  80334e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803351:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803354:	72 e1                	jb     803337 <copy_data+0x1d>
}
  803356:	90                   	nop
  803357:	c9                   	leave  
  803358:	c3                   	ret    

00803359 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803359:	55                   	push   %ebp
  80335a:	89 e5                	mov    %esp,%ebp
  80335c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80335f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803363:	75 23                	jne    803388 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803369:	74 13                	je     80337e <realloc_block_FF+0x25>
  80336b:	83 ec 0c             	sub    $0xc,%esp
  80336e:	ff 75 0c             	pushl  0xc(%ebp)
  803371:	e8 42 f0 ff ff       	call   8023b8 <alloc_block_FF>
  803376:	83 c4 10             	add    $0x10,%esp
  803379:	e9 e4 06 00 00       	jmp    803a62 <realloc_block_FF+0x709>
		return NULL;
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	e9 da 06 00 00       	jmp    803a62 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803388:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80338c:	75 18                	jne    8033a6 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80338e:	83 ec 0c             	sub    $0xc,%esp
  803391:	ff 75 08             	pushl  0x8(%ebp)
  803394:	e8 c0 fe ff ff       	call   803259 <free_block>
  803399:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80339c:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a1:	e9 bc 06 00 00       	jmp    803a62 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8033a6:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033aa:	77 07                	ja     8033b3 <realloc_block_FF+0x5a>
  8033ac:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b6:	83 e0 01             	and    $0x1,%eax
  8033b9:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bf:	83 c0 08             	add    $0x8,%eax
  8033c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	ff 75 08             	pushl  0x8(%ebp)
  8033cb:	e8 68 ec ff ff       	call   802038 <get_block_size>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d9:	83 e8 08             	sub    $0x8,%eax
  8033dc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	83 e8 04             	sub    $0x4,%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	83 e0 fe             	and    $0xfffffffe,%eax
  8033ea:	89 c2                	mov    %eax,%edx
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033f4:	83 ec 0c             	sub    $0xc,%esp
  8033f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033fa:	e8 39 ec ff ff       	call   802038 <get_block_size>
  8033ff:	83 c4 10             	add    $0x10,%esp
  803402:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803408:	83 e8 08             	sub    $0x8,%eax
  80340b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80340e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803411:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803414:	75 08                	jne    80341e <realloc_block_FF+0xc5>
	{
		 return va;
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	e9 44 06 00 00       	jmp    803a62 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80341e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803421:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803424:	0f 83 d5 03 00 00    	jae    8037ff <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80342a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803433:	83 ec 0c             	sub    $0xc,%esp
  803436:	ff 75 e4             	pushl  -0x1c(%ebp)
  803439:	e8 13 ec ff ff       	call   802051 <is_free_block>
  80343e:	83 c4 10             	add    $0x10,%esp
  803441:	84 c0                	test   %al,%al
  803443:	0f 84 3b 01 00 00    	je     803584 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803449:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80344c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80344f:	01 d0                	add    %edx,%eax
  803451:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	6a 01                	push   $0x1
  803459:	ff 75 f0             	pushl  -0x10(%ebp)
  80345c:	ff 75 08             	pushl  0x8(%ebp)
  80345f:	e8 25 ef ff ff       	call   802389 <set_block_data>
  803464:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	83 e8 04             	sub    $0x4,%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	83 e0 fe             	and    $0xfffffffe,%eax
  803472:	89 c2                	mov    %eax,%edx
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	01 d0                	add    %edx,%eax
  803479:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80347c:	83 ec 04             	sub    $0x4,%esp
  80347f:	6a 00                	push   $0x0
  803481:	ff 75 cc             	pushl  -0x34(%ebp)
  803484:	ff 75 c8             	pushl  -0x38(%ebp)
  803487:	e8 fd ee ff ff       	call   802389 <set_block_data>
  80348c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80348f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803493:	74 06                	je     80349b <realloc_block_FF+0x142>
  803495:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803499:	75 17                	jne    8034b2 <realloc_block_FF+0x159>
  80349b:	83 ec 04             	sub    $0x4,%esp
  80349e:	68 54 47 80 00       	push   $0x804754
  8034a3:	68 f6 01 00 00       	push   $0x1f6
  8034a8:	68 e1 46 80 00       	push   $0x8046e1
  8034ad:	e8 aa 07 00 00       	call   803c5c <_panic>
  8034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b5:	8b 10                	mov    (%eax),%edx
  8034b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034bf:	8b 00                	mov    (%eax),%eax
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	74 0b                	je     8034d0 <realloc_block_FF+0x177>
  8034c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034cd:	89 50 04             	mov    %edx,0x4(%eax)
  8034d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034d6:	89 10                	mov    %edx,(%eax)
  8034d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034de:	89 50 04             	mov    %edx,0x4(%eax)
  8034e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	75 08                	jne    8034f2 <realloc_block_FF+0x199>
  8034ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f7:	40                   	inc    %eax
  8034f8:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803501:	75 17                	jne    80351a <realloc_block_FF+0x1c1>
  803503:	83 ec 04             	sub    $0x4,%esp
  803506:	68 c3 46 80 00       	push   $0x8046c3
  80350b:	68 f7 01 00 00       	push   $0x1f7
  803510:	68 e1 46 80 00       	push   $0x8046e1
  803515:	e8 42 07 00 00       	call   803c5c <_panic>
  80351a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351d:	8b 00                	mov    (%eax),%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	74 10                	je     803533 <realloc_block_FF+0x1da>
  803523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803526:	8b 00                	mov    (%eax),%eax
  803528:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80352b:	8b 52 04             	mov    0x4(%edx),%edx
  80352e:	89 50 04             	mov    %edx,0x4(%eax)
  803531:	eb 0b                	jmp    80353e <realloc_block_FF+0x1e5>
  803533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	a3 30 50 80 00       	mov    %eax,0x805030
  80353e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803541:	8b 40 04             	mov    0x4(%eax),%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	74 0f                	je     803557 <realloc_block_FF+0x1fe>
  803548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354b:	8b 40 04             	mov    0x4(%eax),%eax
  80354e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803551:	8b 12                	mov    (%edx),%edx
  803553:	89 10                	mov    %edx,(%eax)
  803555:	eb 0a                	jmp    803561 <realloc_block_FF+0x208>
  803557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803574:	a1 38 50 80 00       	mov    0x805038,%eax
  803579:	48                   	dec    %eax
  80357a:	a3 38 50 80 00       	mov    %eax,0x805038
  80357f:	e9 73 02 00 00       	jmp    8037f7 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803584:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803588:	0f 86 69 02 00 00    	jbe    8037f7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80358e:	83 ec 04             	sub    $0x4,%esp
  803591:	6a 01                	push   $0x1
  803593:	ff 75 f0             	pushl  -0x10(%ebp)
  803596:	ff 75 08             	pushl  0x8(%ebp)
  803599:	e8 eb ed ff ff       	call   802389 <set_block_data>
  80359e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	83 e8 04             	sub    $0x4,%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	83 e0 fe             	and    $0xfffffffe,%eax
  8035ac:	89 c2                	mov    %eax,%edx
  8035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b1:	01 d0                	add    %edx,%eax
  8035b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8035bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035be:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035c2:	75 68                	jne    80362c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035c8:	75 17                	jne    8035e1 <realloc_block_FF+0x288>
  8035ca:	83 ec 04             	sub    $0x4,%esp
  8035cd:	68 fc 46 80 00       	push   $0x8046fc
  8035d2:	68 06 02 00 00       	push   $0x206
  8035d7:	68 e1 46 80 00       	push   $0x8046e1
  8035dc:	e8 7b 06 00 00       	call   803c5c <_panic>
  8035e1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ea:	89 10                	mov    %edx,(%eax)
  8035ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	74 0d                	je     803602 <realloc_block_FF+0x2a9>
  8035f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035fd:	89 50 04             	mov    %edx,0x4(%eax)
  803600:	eb 08                	jmp    80360a <realloc_block_FF+0x2b1>
  803602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803605:	a3 30 50 80 00       	mov    %eax,0x805030
  80360a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361c:	a1 38 50 80 00       	mov    0x805038,%eax
  803621:	40                   	inc    %eax
  803622:	a3 38 50 80 00       	mov    %eax,0x805038
  803627:	e9 b0 01 00 00       	jmp    8037dc <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80362c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803631:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803634:	76 68                	jbe    80369e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803636:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80363a:	75 17                	jne    803653 <realloc_block_FF+0x2fa>
  80363c:	83 ec 04             	sub    $0x4,%esp
  80363f:	68 fc 46 80 00       	push   $0x8046fc
  803644:	68 0b 02 00 00       	push   $0x20b
  803649:	68 e1 46 80 00       	push   $0x8046e1
  80364e:	e8 09 06 00 00       	call   803c5c <_panic>
  803653:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803659:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365c:	89 10                	mov    %edx,(%eax)
  80365e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803661:	8b 00                	mov    (%eax),%eax
  803663:	85 c0                	test   %eax,%eax
  803665:	74 0d                	je     803674 <realloc_block_FF+0x31b>
  803667:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80366c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80366f:	89 50 04             	mov    %edx,0x4(%eax)
  803672:	eb 08                	jmp    80367c <realloc_block_FF+0x323>
  803674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803677:	a3 30 50 80 00       	mov    %eax,0x805030
  80367c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803687:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368e:	a1 38 50 80 00       	mov    0x805038,%eax
  803693:	40                   	inc    %eax
  803694:	a3 38 50 80 00       	mov    %eax,0x805038
  803699:	e9 3e 01 00 00       	jmp    8037dc <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80369e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036a3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036a6:	73 68                	jae    803710 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ac:	75 17                	jne    8036c5 <realloc_block_FF+0x36c>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 30 47 80 00       	push   $0x804730
  8036b6:	68 10 02 00 00       	push   $0x210
  8036bb:	68 e1 46 80 00       	push   $0x8046e1
  8036c0:	e8 97 05 00 00       	call   803c5c <_panic>
  8036c5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ce:	89 50 04             	mov    %edx,0x4(%eax)
  8036d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d4:	8b 40 04             	mov    0x4(%eax),%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 0c                	je     8036e7 <realloc_block_FF+0x38e>
  8036db:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e3:	89 10                	mov    %edx,(%eax)
  8036e5:	eb 08                	jmp    8036ef <realloc_block_FF+0x396>
  8036e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803700:	a1 38 50 80 00       	mov    0x805038,%eax
  803705:	40                   	inc    %eax
  803706:	a3 38 50 80 00       	mov    %eax,0x805038
  80370b:	e9 cc 00 00 00       	jmp    8037dc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803710:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803717:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80371c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80371f:	e9 8a 00 00 00       	jmp    8037ae <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80372a:	73 7a                	jae    8037a6 <realloc_block_FF+0x44d>
  80372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803734:	73 70                	jae    8037a6 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373a:	74 06                	je     803742 <realloc_block_FF+0x3e9>
  80373c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803740:	75 17                	jne    803759 <realloc_block_FF+0x400>
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	68 54 47 80 00       	push   $0x804754
  80374a:	68 1a 02 00 00       	push   $0x21a
  80374f:	68 e1 46 80 00       	push   $0x8046e1
  803754:	e8 03 05 00 00       	call   803c5c <_panic>
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	8b 10                	mov    (%eax),%edx
  80375e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803761:	89 10                	mov    %edx,(%eax)
  803763:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	85 c0                	test   %eax,%eax
  80376a:	74 0b                	je     803777 <realloc_block_FF+0x41e>
  80376c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803774:	89 50 04             	mov    %edx,0x4(%eax)
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80377d:	89 10                	mov    %edx,(%eax)
  80377f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803785:	89 50 04             	mov    %edx,0x4(%eax)
  803788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	75 08                	jne    803799 <realloc_block_FF+0x440>
  803791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803794:	a3 30 50 80 00       	mov    %eax,0x805030
  803799:	a1 38 50 80 00       	mov    0x805038,%eax
  80379e:	40                   	inc    %eax
  80379f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037a4:	eb 36                	jmp    8037dc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037a6:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b2:	74 07                	je     8037bb <realloc_block_FF+0x462>
  8037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b7:	8b 00                	mov    (%eax),%eax
  8037b9:	eb 05                	jmp    8037c0 <realloc_block_FF+0x467>
  8037bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c0:	a3 34 50 80 00       	mov    %eax,0x805034
  8037c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	0f 85 52 ff ff ff    	jne    803724 <realloc_block_FF+0x3cb>
  8037d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d6:	0f 85 48 ff ff ff    	jne    803724 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	6a 00                	push   $0x0
  8037e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8037e4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037e7:	e8 9d eb ff ff       	call   802389 <set_block_data>
  8037ec:	83 c4 10             	add    $0x10,%esp
				return va;
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	e9 6b 02 00 00       	jmp    803a62 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	e9 63 02 00 00       	jmp    803a62 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8037ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803802:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803805:	0f 86 4d 02 00 00    	jbe    803a58 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80380b:	83 ec 0c             	sub    $0xc,%esp
  80380e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803811:	e8 3b e8 ff ff       	call   802051 <is_free_block>
  803816:	83 c4 10             	add    $0x10,%esp
  803819:	84 c0                	test   %al,%al
  80381b:	0f 84 37 02 00 00    	je     803a58 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803821:	8b 45 0c             	mov    0xc(%ebp),%eax
  803824:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803827:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80382a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80382d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803830:	76 38                	jbe    80386a <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803832:	83 ec 0c             	sub    $0xc,%esp
  803835:	ff 75 0c             	pushl  0xc(%ebp)
  803838:	e8 7b eb ff ff       	call   8023b8 <alloc_block_FF>
  80383d:	83 c4 10             	add    $0x10,%esp
  803840:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803843:	83 ec 08             	sub    $0x8,%esp
  803846:	ff 75 c0             	pushl  -0x40(%ebp)
  803849:	ff 75 08             	pushl  0x8(%ebp)
  80384c:	e8 c9 fa ff ff       	call   80331a <copy_data>
  803851:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803854:	83 ec 0c             	sub    $0xc,%esp
  803857:	ff 75 08             	pushl  0x8(%ebp)
  80385a:	e8 fa f9 ff ff       	call   803259 <free_block>
  80385f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803862:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803865:	e9 f8 01 00 00       	jmp    803a62 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80386a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803870:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803873:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803877:	0f 87 a0 00 00 00    	ja     80391d <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80387d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803881:	75 17                	jne    80389a <realloc_block_FF+0x541>
  803883:	83 ec 04             	sub    $0x4,%esp
  803886:	68 c3 46 80 00       	push   $0x8046c3
  80388b:	68 38 02 00 00       	push   $0x238
  803890:	68 e1 46 80 00       	push   $0x8046e1
  803895:	e8 c2 03 00 00       	call   803c5c <_panic>
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	8b 00                	mov    (%eax),%eax
  80389f:	85 c0                	test   %eax,%eax
  8038a1:	74 10                	je     8038b3 <realloc_block_FF+0x55a>
  8038a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ab:	8b 52 04             	mov    0x4(%edx),%edx
  8038ae:	89 50 04             	mov    %edx,0x4(%eax)
  8038b1:	eb 0b                	jmp    8038be <realloc_block_FF+0x565>
  8038b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b6:	8b 40 04             	mov    0x4(%eax),%eax
  8038b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8038be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c1:	8b 40 04             	mov    0x4(%eax),%eax
  8038c4:	85 c0                	test   %eax,%eax
  8038c6:	74 0f                	je     8038d7 <realloc_block_FF+0x57e>
  8038c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cb:	8b 40 04             	mov    0x4(%eax),%eax
  8038ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d1:	8b 12                	mov    (%edx),%edx
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	eb 0a                	jmp    8038e1 <realloc_block_FF+0x588>
  8038d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038da:	8b 00                	mov    (%eax),%eax
  8038dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8038f9:	48                   	dec    %eax
  8038fa:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803905:	01 d0                	add    %edx,%eax
  803907:	83 ec 04             	sub    $0x4,%esp
  80390a:	6a 01                	push   $0x1
  80390c:	50                   	push   %eax
  80390d:	ff 75 08             	pushl  0x8(%ebp)
  803910:	e8 74 ea ff ff       	call   802389 <set_block_data>
  803915:	83 c4 10             	add    $0x10,%esp
  803918:	e9 36 01 00 00       	jmp    803a53 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80391d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803920:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803923:	01 d0                	add    %edx,%eax
  803925:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803928:	83 ec 04             	sub    $0x4,%esp
  80392b:	6a 01                	push   $0x1
  80392d:	ff 75 f0             	pushl  -0x10(%ebp)
  803930:	ff 75 08             	pushl  0x8(%ebp)
  803933:	e8 51 ea ff ff       	call   802389 <set_block_data>
  803938:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	83 e8 04             	sub    $0x4,%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	83 e0 fe             	and    $0xfffffffe,%eax
  803946:	89 c2                	mov    %eax,%edx
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	01 d0                	add    %edx,%eax
  80394d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803954:	74 06                	je     80395c <realloc_block_FF+0x603>
  803956:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80395a:	75 17                	jne    803973 <realloc_block_FF+0x61a>
  80395c:	83 ec 04             	sub    $0x4,%esp
  80395f:	68 54 47 80 00       	push   $0x804754
  803964:	68 44 02 00 00       	push   $0x244
  803969:	68 e1 46 80 00       	push   $0x8046e1
  80396e:	e8 e9 02 00 00       	call   803c5c <_panic>
  803973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803976:	8b 10                	mov    (%eax),%edx
  803978:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80397b:	89 10                	mov    %edx,(%eax)
  80397d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803980:	8b 00                	mov    (%eax),%eax
  803982:	85 c0                	test   %eax,%eax
  803984:	74 0b                	je     803991 <realloc_block_FF+0x638>
  803986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80398e:	89 50 04             	mov    %edx,0x4(%eax)
  803991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803994:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803997:	89 10                	mov    %edx,(%eax)
  803999:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80399c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	75 08                	jne    8039b3 <realloc_block_FF+0x65a>
  8039ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8039b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b8:	40                   	inc    %eax
  8039b9:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039c2:	75 17                	jne    8039db <realloc_block_FF+0x682>
  8039c4:	83 ec 04             	sub    $0x4,%esp
  8039c7:	68 c3 46 80 00       	push   $0x8046c3
  8039cc:	68 45 02 00 00       	push   $0x245
  8039d1:	68 e1 46 80 00       	push   $0x8046e1
  8039d6:	e8 81 02 00 00       	call   803c5c <_panic>
  8039db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039de:	8b 00                	mov    (%eax),%eax
  8039e0:	85 c0                	test   %eax,%eax
  8039e2:	74 10                	je     8039f4 <realloc_block_FF+0x69b>
  8039e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e7:	8b 00                	mov    (%eax),%eax
  8039e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ec:	8b 52 04             	mov    0x4(%edx),%edx
  8039ef:	89 50 04             	mov    %edx,0x4(%eax)
  8039f2:	eb 0b                	jmp    8039ff <realloc_block_FF+0x6a6>
  8039f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f7:	8b 40 04             	mov    0x4(%eax),%eax
  8039fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a02:	8b 40 04             	mov    0x4(%eax),%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	74 0f                	je     803a18 <realloc_block_FF+0x6bf>
  803a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0c:	8b 40 04             	mov    0x4(%eax),%eax
  803a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a12:	8b 12                	mov    (%edx),%edx
  803a14:	89 10                	mov    %edx,(%eax)
  803a16:	eb 0a                	jmp    803a22 <realloc_block_FF+0x6c9>
  803a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a35:	a1 38 50 80 00       	mov    0x805038,%eax
  803a3a:	48                   	dec    %eax
  803a3b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a40:	83 ec 04             	sub    $0x4,%esp
  803a43:	6a 00                	push   $0x0
  803a45:	ff 75 bc             	pushl  -0x44(%ebp)
  803a48:	ff 75 b8             	pushl  -0x48(%ebp)
  803a4b:	e8 39 e9 ff ff       	call   802389 <set_block_data>
  803a50:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a53:	8b 45 08             	mov    0x8(%ebp),%eax
  803a56:	eb 0a                	jmp    803a62 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a58:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a62:	c9                   	leave  
  803a63:	c3                   	ret    

00803a64 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a64:	55                   	push   %ebp
  803a65:	89 e5                	mov    %esp,%ebp
  803a67:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	68 c0 47 80 00       	push   $0x8047c0
  803a72:	68 58 02 00 00       	push   $0x258
  803a77:	68 e1 46 80 00       	push   $0x8046e1
  803a7c:	e8 db 01 00 00       	call   803c5c <_panic>

00803a81 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a81:	55                   	push   %ebp
  803a82:	89 e5                	mov    %esp,%ebp
  803a84:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	68 e8 47 80 00       	push   $0x8047e8
  803a8f:	68 61 02 00 00       	push   $0x261
  803a94:	68 e1 46 80 00       	push   $0x8046e1
  803a99:	e8 be 01 00 00       	call   803c5c <_panic>

00803a9e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803a9e:	55                   	push   %ebp
  803a9f:	89 e5                	mov    %esp,%ebp
  803aa1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  803aa4:	83 ec 04             	sub    $0x4,%esp
  803aa7:	6a 01                	push   $0x1
  803aa9:	6a 04                	push   $0x4
  803aab:	ff 75 0c             	pushl  0xc(%ebp)
  803aae:	e8 c1 dc ff ff       	call   801774 <smalloc>
  803ab3:	83 c4 10             	add    $0x10,%esp
  803ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  803ab9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803abd:	75 14                	jne    803ad3 <create_semaphore+0x35>
  803abf:	83 ec 04             	sub    $0x4,%esp
  803ac2:	68 0e 48 80 00       	push   $0x80480e
  803ac7:	6a 0d                	push   $0xd
  803ac9:	68 2b 48 80 00       	push   $0x80482b
  803ace:	e8 89 01 00 00       	call   803c5c <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  803ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803adc:	8b 00                	mov    (%eax),%eax
  803ade:	8b 55 10             	mov    0x10(%ebp),%edx
  803ae1:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  803ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae7:	8b 00                	mov    (%eax),%eax
  803ae9:	83 ec 0c             	sub    $0xc,%esp
  803aec:	50                   	push   %eax
  803aed:	e8 cc e4 ff ff       	call   801fbe <sys_init_queue>
  803af2:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  803af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af8:	8b 00                	mov    (%eax),%eax
  803afa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  803b01:	8b 45 08             	mov    0x8(%ebp),%eax
  803b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b07:	8b 12                	mov    (%edx),%edx
  803b09:	89 10                	mov    %edx,(%eax)
}
  803b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0e:	c9                   	leave  
  803b0f:	c2 04 00             	ret    $0x4

00803b12 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803b12:	55                   	push   %ebp
  803b13:	89 e5                	mov    %esp,%ebp
  803b15:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803b18:	83 ec 08             	sub    $0x8,%esp
  803b1b:	ff 75 10             	pushl  0x10(%ebp)
  803b1e:	ff 75 0c             	pushl  0xc(%ebp)
  803b21:	e8 f3 dc ff ff       	call   801819 <sget>
  803b26:	83 c4 10             	add    $0x10,%esp
  803b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b30:	75 14                	jne    803b46 <get_semaphore+0x34>
  803b32:	83 ec 04             	sub    $0x4,%esp
  803b35:	68 3b 48 80 00       	push   $0x80483b
  803b3a:	6a 1f                	push   $0x1f
  803b3c:	68 2b 48 80 00       	push   $0x80482b
  803b41:	e8 16 01 00 00       	call   803c5c <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b52:	8b 12                	mov    (%edx),%edx
  803b54:	89 10                	mov    %edx,(%eax)
}
  803b56:	8b 45 08             	mov    0x8(%ebp),%eax
  803b59:	c9                   	leave  
  803b5a:	c2 04 00             	ret    $0x4

00803b5d <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803b5d:	55                   	push   %ebp
  803b5e:	89 e5                	mov    %esp,%ebp
  803b60:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  803b63:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6d:	83 c0 14             	add    $0x14,%eax
  803b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b76:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803b82:	f0 87 02             	lock xchg %eax,(%edx)
  803b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b8c:	75 dc                	jne    803b6a <wait_semaphore+0xd>

		    sem.semdata->count--;
  803b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b91:	8b 50 10             	mov    0x10(%eax),%edx
  803b94:	4a                   	dec    %edx
  803b95:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803b98:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9b:	8b 40 10             	mov    0x10(%eax),%eax
  803b9e:	85 c0                	test   %eax,%eax
  803ba0:	79 30                	jns    803bd2 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  803ba2:	e8 f5 e3 ff ff       	call   801f9c <sys_get_cpu_process>
  803ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803baa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bad:	83 ec 08             	sub    $0x8,%esp
  803bb0:	ff 75 f0             	pushl  -0x10(%ebp)
  803bb3:	50                   	push   %eax
  803bb4:	e8 21 e4 ff ff       	call   801fda <sys_enqueue>
  803bb9:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  803bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbf:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  803bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  803bd0:	eb 0a                	jmp    803bdc <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  803bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  803bdc:	90                   	nop
  803bdd:	c9                   	leave  
  803bde:	c3                   	ret    

00803bdf <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803bdf:	55                   	push   %ebp
  803be0:	89 e5                	mov    %esp,%ebp
  803be2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  803be5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  803bec:	8b 45 08             	mov    0x8(%ebp),%eax
  803bef:	83 c0 14             	add    $0x14,%eax
  803bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803bfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c01:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c04:	f0 87 02             	lock xchg %eax,(%edx)
  803c07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0e:	75 dc                	jne    803bec <signal_semaphore+0xd>
	    sem.semdata->count++;
  803c10:	8b 45 08             	mov    0x8(%ebp),%eax
  803c13:	8b 50 10             	mov    0x10(%eax),%edx
  803c16:	42                   	inc    %edx
  803c17:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1d:	8b 40 10             	mov    0x10(%eax),%eax
  803c20:	85 c0                	test   %eax,%eax
  803c22:	7f 20                	jg     803c44 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  803c24:	8b 45 08             	mov    0x8(%ebp),%eax
  803c27:	83 ec 0c             	sub    $0xc,%esp
  803c2a:	50                   	push   %eax
  803c2b:	e8 c8 e3 ff ff       	call   801ff8 <sys_dequeue>
  803c30:	83 c4 10             	add    $0x10,%esp
  803c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803c36:	83 ec 0c             	sub    $0xc,%esp
  803c39:	ff 75 f0             	pushl  -0x10(%ebp)
  803c3c:	e8 db e3 ff ff       	call   80201c <sys_sched_insert_ready>
  803c41:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  803c44:	8b 45 08             	mov    0x8(%ebp),%eax
  803c47:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803c4e:	90                   	nop
  803c4f:	c9                   	leave  
  803c50:	c3                   	ret    

00803c51 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803c51:	55                   	push   %ebp
  803c52:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803c54:	8b 45 08             	mov    0x8(%ebp),%eax
  803c57:	8b 40 10             	mov    0x10(%eax),%eax
}
  803c5a:	5d                   	pop    %ebp
  803c5b:	c3                   	ret    

00803c5c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803c5c:	55                   	push   %ebp
  803c5d:	89 e5                	mov    %esp,%ebp
  803c5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803c62:	8d 45 10             	lea    0x10(%ebp),%eax
  803c65:	83 c0 04             	add    $0x4,%eax
  803c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803c6b:	a1 60 50 98 00       	mov    0x985060,%eax
  803c70:	85 c0                	test   %eax,%eax
  803c72:	74 16                	je     803c8a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803c74:	a1 60 50 98 00       	mov    0x985060,%eax
  803c79:	83 ec 08             	sub    $0x8,%esp
  803c7c:	50                   	push   %eax
  803c7d:	68 5c 48 80 00       	push   $0x80485c
  803c82:	e8 1f ca ff ff       	call   8006a6 <cprintf>
  803c87:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803c8a:	a1 00 50 80 00       	mov    0x805000,%eax
  803c8f:	ff 75 0c             	pushl  0xc(%ebp)
  803c92:	ff 75 08             	pushl  0x8(%ebp)
  803c95:	50                   	push   %eax
  803c96:	68 61 48 80 00       	push   $0x804861
  803c9b:	e8 06 ca ff ff       	call   8006a6 <cprintf>
  803ca0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  803ca6:	83 ec 08             	sub    $0x8,%esp
  803ca9:	ff 75 f4             	pushl  -0xc(%ebp)
  803cac:	50                   	push   %eax
  803cad:	e8 89 c9 ff ff       	call   80063b <vcprintf>
  803cb2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803cb5:	83 ec 08             	sub    $0x8,%esp
  803cb8:	6a 00                	push   $0x0
  803cba:	68 7d 48 80 00       	push   $0x80487d
  803cbf:	e8 77 c9 ff ff       	call   80063b <vcprintf>
  803cc4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803cc7:	e8 f8 c8 ff ff       	call   8005c4 <exit>

	// should not return here
	while (1) ;
  803ccc:	eb fe                	jmp    803ccc <_panic+0x70>

00803cce <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803cce:	55                   	push   %ebp
  803ccf:	89 e5                	mov    %esp,%ebp
  803cd1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803cd4:	a1 20 50 80 00       	mov    0x805020,%eax
  803cd9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce2:	39 c2                	cmp    %eax,%edx
  803ce4:	74 14                	je     803cfa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ce6:	83 ec 04             	sub    $0x4,%esp
  803ce9:	68 80 48 80 00       	push   $0x804880
  803cee:	6a 26                	push   $0x26
  803cf0:	68 cc 48 80 00       	push   $0x8048cc
  803cf5:	e8 62 ff ff ff       	call   803c5c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803cfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803d01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803d08:	e9 c5 00 00 00       	jmp    803dd2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d17:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1a:	01 d0                	add    %edx,%eax
  803d1c:	8b 00                	mov    (%eax),%eax
  803d1e:	85 c0                	test   %eax,%eax
  803d20:	75 08                	jne    803d2a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803d22:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803d25:	e9 a5 00 00 00       	jmp    803dcf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803d2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803d38:	eb 69                	jmp    803da3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803d3a:	a1 20 50 80 00       	mov    0x805020,%eax
  803d3f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d48:	89 d0                	mov    %edx,%eax
  803d4a:	01 c0                	add    %eax,%eax
  803d4c:	01 d0                	add    %edx,%eax
  803d4e:	c1 e0 03             	shl    $0x3,%eax
  803d51:	01 c8                	add    %ecx,%eax
  803d53:	8a 40 04             	mov    0x4(%eax),%al
  803d56:	84 c0                	test   %al,%al
  803d58:	75 46                	jne    803da0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803d5a:	a1 20 50 80 00       	mov    0x805020,%eax
  803d5f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803d65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d68:	89 d0                	mov    %edx,%eax
  803d6a:	01 c0                	add    %eax,%eax
  803d6c:	01 d0                	add    %edx,%eax
  803d6e:	c1 e0 03             	shl    $0x3,%eax
  803d71:	01 c8                	add    %ecx,%eax
  803d73:	8b 00                	mov    (%eax),%eax
  803d75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803d78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803d80:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d85:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8f:	01 c8                	add    %ecx,%eax
  803d91:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803d93:	39 c2                	cmp    %eax,%edx
  803d95:	75 09                	jne    803da0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803d97:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803d9e:	eb 15                	jmp    803db5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803da0:	ff 45 e8             	incl   -0x18(%ebp)
  803da3:	a1 20 50 80 00       	mov    0x805020,%eax
  803da8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803dae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db1:	39 c2                	cmp    %eax,%edx
  803db3:	77 85                	ja     803d3a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803db5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803db9:	75 14                	jne    803dcf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803dbb:	83 ec 04             	sub    $0x4,%esp
  803dbe:	68 d8 48 80 00       	push   $0x8048d8
  803dc3:	6a 3a                	push   $0x3a
  803dc5:	68 cc 48 80 00       	push   $0x8048cc
  803dca:	e8 8d fe ff ff       	call   803c5c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803dcf:	ff 45 f0             	incl   -0x10(%ebp)
  803dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803dd8:	0f 8c 2f ff ff ff    	jl     803d0d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803dde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803de5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803dec:	eb 26                	jmp    803e14 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803dee:	a1 20 50 80 00       	mov    0x805020,%eax
  803df3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803df9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803dfc:	89 d0                	mov    %edx,%eax
  803dfe:	01 c0                	add    %eax,%eax
  803e00:	01 d0                	add    %edx,%eax
  803e02:	c1 e0 03             	shl    $0x3,%eax
  803e05:	01 c8                	add    %ecx,%eax
  803e07:	8a 40 04             	mov    0x4(%eax),%al
  803e0a:	3c 01                	cmp    $0x1,%al
  803e0c:	75 03                	jne    803e11 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803e0e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e11:	ff 45 e0             	incl   -0x20(%ebp)
  803e14:	a1 20 50 80 00       	mov    0x805020,%eax
  803e19:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e22:	39 c2                	cmp    %eax,%edx
  803e24:	77 c8                	ja     803dee <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e29:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803e2c:	74 14                	je     803e42 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803e2e:	83 ec 04             	sub    $0x4,%esp
  803e31:	68 2c 49 80 00       	push   $0x80492c
  803e36:	6a 44                	push   $0x44
  803e38:	68 cc 48 80 00       	push   $0x8048cc
  803e3d:	e8 1a fe ff ff       	call   803c5c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803e42:	90                   	nop
  803e43:	c9                   	leave  
  803e44:	c3                   	ret    
  803e45:	66 90                	xchg   %ax,%ax
  803e47:	90                   	nop

00803e48 <__udivdi3>:
  803e48:	55                   	push   %ebp
  803e49:	57                   	push   %edi
  803e4a:	56                   	push   %esi
  803e4b:	53                   	push   %ebx
  803e4c:	83 ec 1c             	sub    $0x1c,%esp
  803e4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e5f:	89 ca                	mov    %ecx,%edx
  803e61:	89 f8                	mov    %edi,%eax
  803e63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e67:	85 f6                	test   %esi,%esi
  803e69:	75 2d                	jne    803e98 <__udivdi3+0x50>
  803e6b:	39 cf                	cmp    %ecx,%edi
  803e6d:	77 65                	ja     803ed4 <__udivdi3+0x8c>
  803e6f:	89 fd                	mov    %edi,%ebp
  803e71:	85 ff                	test   %edi,%edi
  803e73:	75 0b                	jne    803e80 <__udivdi3+0x38>
  803e75:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7a:	31 d2                	xor    %edx,%edx
  803e7c:	f7 f7                	div    %edi
  803e7e:	89 c5                	mov    %eax,%ebp
  803e80:	31 d2                	xor    %edx,%edx
  803e82:	89 c8                	mov    %ecx,%eax
  803e84:	f7 f5                	div    %ebp
  803e86:	89 c1                	mov    %eax,%ecx
  803e88:	89 d8                	mov    %ebx,%eax
  803e8a:	f7 f5                	div    %ebp
  803e8c:	89 cf                	mov    %ecx,%edi
  803e8e:	89 fa                	mov    %edi,%edx
  803e90:	83 c4 1c             	add    $0x1c,%esp
  803e93:	5b                   	pop    %ebx
  803e94:	5e                   	pop    %esi
  803e95:	5f                   	pop    %edi
  803e96:	5d                   	pop    %ebp
  803e97:	c3                   	ret    
  803e98:	39 ce                	cmp    %ecx,%esi
  803e9a:	77 28                	ja     803ec4 <__udivdi3+0x7c>
  803e9c:	0f bd fe             	bsr    %esi,%edi
  803e9f:	83 f7 1f             	xor    $0x1f,%edi
  803ea2:	75 40                	jne    803ee4 <__udivdi3+0x9c>
  803ea4:	39 ce                	cmp    %ecx,%esi
  803ea6:	72 0a                	jb     803eb2 <__udivdi3+0x6a>
  803ea8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803eac:	0f 87 9e 00 00 00    	ja     803f50 <__udivdi3+0x108>
  803eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803eb7:	89 fa                	mov    %edi,%edx
  803eb9:	83 c4 1c             	add    $0x1c,%esp
  803ebc:	5b                   	pop    %ebx
  803ebd:	5e                   	pop    %esi
  803ebe:	5f                   	pop    %edi
  803ebf:	5d                   	pop    %ebp
  803ec0:	c3                   	ret    
  803ec1:	8d 76 00             	lea    0x0(%esi),%esi
  803ec4:	31 ff                	xor    %edi,%edi
  803ec6:	31 c0                	xor    %eax,%eax
  803ec8:	89 fa                	mov    %edi,%edx
  803eca:	83 c4 1c             	add    $0x1c,%esp
  803ecd:	5b                   	pop    %ebx
  803ece:	5e                   	pop    %esi
  803ecf:	5f                   	pop    %edi
  803ed0:	5d                   	pop    %ebp
  803ed1:	c3                   	ret    
  803ed2:	66 90                	xchg   %ax,%ax
  803ed4:	89 d8                	mov    %ebx,%eax
  803ed6:	f7 f7                	div    %edi
  803ed8:	31 ff                	xor    %edi,%edi
  803eda:	89 fa                	mov    %edi,%edx
  803edc:	83 c4 1c             	add    $0x1c,%esp
  803edf:	5b                   	pop    %ebx
  803ee0:	5e                   	pop    %esi
  803ee1:	5f                   	pop    %edi
  803ee2:	5d                   	pop    %ebp
  803ee3:	c3                   	ret    
  803ee4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ee9:	89 eb                	mov    %ebp,%ebx
  803eeb:	29 fb                	sub    %edi,%ebx
  803eed:	89 f9                	mov    %edi,%ecx
  803eef:	d3 e6                	shl    %cl,%esi
  803ef1:	89 c5                	mov    %eax,%ebp
  803ef3:	88 d9                	mov    %bl,%cl
  803ef5:	d3 ed                	shr    %cl,%ebp
  803ef7:	89 e9                	mov    %ebp,%ecx
  803ef9:	09 f1                	or     %esi,%ecx
  803efb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803eff:	89 f9                	mov    %edi,%ecx
  803f01:	d3 e0                	shl    %cl,%eax
  803f03:	89 c5                	mov    %eax,%ebp
  803f05:	89 d6                	mov    %edx,%esi
  803f07:	88 d9                	mov    %bl,%cl
  803f09:	d3 ee                	shr    %cl,%esi
  803f0b:	89 f9                	mov    %edi,%ecx
  803f0d:	d3 e2                	shl    %cl,%edx
  803f0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f13:	88 d9                	mov    %bl,%cl
  803f15:	d3 e8                	shr    %cl,%eax
  803f17:	09 c2                	or     %eax,%edx
  803f19:	89 d0                	mov    %edx,%eax
  803f1b:	89 f2                	mov    %esi,%edx
  803f1d:	f7 74 24 0c          	divl   0xc(%esp)
  803f21:	89 d6                	mov    %edx,%esi
  803f23:	89 c3                	mov    %eax,%ebx
  803f25:	f7 e5                	mul    %ebp
  803f27:	39 d6                	cmp    %edx,%esi
  803f29:	72 19                	jb     803f44 <__udivdi3+0xfc>
  803f2b:	74 0b                	je     803f38 <__udivdi3+0xf0>
  803f2d:	89 d8                	mov    %ebx,%eax
  803f2f:	31 ff                	xor    %edi,%edi
  803f31:	e9 58 ff ff ff       	jmp    803e8e <__udivdi3+0x46>
  803f36:	66 90                	xchg   %ax,%ax
  803f38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f3c:	89 f9                	mov    %edi,%ecx
  803f3e:	d3 e2                	shl    %cl,%edx
  803f40:	39 c2                	cmp    %eax,%edx
  803f42:	73 e9                	jae    803f2d <__udivdi3+0xe5>
  803f44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f47:	31 ff                	xor    %edi,%edi
  803f49:	e9 40 ff ff ff       	jmp    803e8e <__udivdi3+0x46>
  803f4e:	66 90                	xchg   %ax,%ax
  803f50:	31 c0                	xor    %eax,%eax
  803f52:	e9 37 ff ff ff       	jmp    803e8e <__udivdi3+0x46>
  803f57:	90                   	nop

00803f58 <__umoddi3>:
  803f58:	55                   	push   %ebp
  803f59:	57                   	push   %edi
  803f5a:	56                   	push   %esi
  803f5b:	53                   	push   %ebx
  803f5c:	83 ec 1c             	sub    $0x1c,%esp
  803f5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f77:	89 f3                	mov    %esi,%ebx
  803f79:	89 fa                	mov    %edi,%edx
  803f7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f7f:	89 34 24             	mov    %esi,(%esp)
  803f82:	85 c0                	test   %eax,%eax
  803f84:	75 1a                	jne    803fa0 <__umoddi3+0x48>
  803f86:	39 f7                	cmp    %esi,%edi
  803f88:	0f 86 a2 00 00 00    	jbe    804030 <__umoddi3+0xd8>
  803f8e:	89 c8                	mov    %ecx,%eax
  803f90:	89 f2                	mov    %esi,%edx
  803f92:	f7 f7                	div    %edi
  803f94:	89 d0                	mov    %edx,%eax
  803f96:	31 d2                	xor    %edx,%edx
  803f98:	83 c4 1c             	add    $0x1c,%esp
  803f9b:	5b                   	pop    %ebx
  803f9c:	5e                   	pop    %esi
  803f9d:	5f                   	pop    %edi
  803f9e:	5d                   	pop    %ebp
  803f9f:	c3                   	ret    
  803fa0:	39 f0                	cmp    %esi,%eax
  803fa2:	0f 87 ac 00 00 00    	ja     804054 <__umoddi3+0xfc>
  803fa8:	0f bd e8             	bsr    %eax,%ebp
  803fab:	83 f5 1f             	xor    $0x1f,%ebp
  803fae:	0f 84 ac 00 00 00    	je     804060 <__umoddi3+0x108>
  803fb4:	bf 20 00 00 00       	mov    $0x20,%edi
  803fb9:	29 ef                	sub    %ebp,%edi
  803fbb:	89 fe                	mov    %edi,%esi
  803fbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fc1:	89 e9                	mov    %ebp,%ecx
  803fc3:	d3 e0                	shl    %cl,%eax
  803fc5:	89 d7                	mov    %edx,%edi
  803fc7:	89 f1                	mov    %esi,%ecx
  803fc9:	d3 ef                	shr    %cl,%edi
  803fcb:	09 c7                	or     %eax,%edi
  803fcd:	89 e9                	mov    %ebp,%ecx
  803fcf:	d3 e2                	shl    %cl,%edx
  803fd1:	89 14 24             	mov    %edx,(%esp)
  803fd4:	89 d8                	mov    %ebx,%eax
  803fd6:	d3 e0                	shl    %cl,%eax
  803fd8:	89 c2                	mov    %eax,%edx
  803fda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fde:	d3 e0                	shl    %cl,%eax
  803fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fe4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fe8:	89 f1                	mov    %esi,%ecx
  803fea:	d3 e8                	shr    %cl,%eax
  803fec:	09 d0                	or     %edx,%eax
  803fee:	d3 eb                	shr    %cl,%ebx
  803ff0:	89 da                	mov    %ebx,%edx
  803ff2:	f7 f7                	div    %edi
  803ff4:	89 d3                	mov    %edx,%ebx
  803ff6:	f7 24 24             	mull   (%esp)
  803ff9:	89 c6                	mov    %eax,%esi
  803ffb:	89 d1                	mov    %edx,%ecx
  803ffd:	39 d3                	cmp    %edx,%ebx
  803fff:	0f 82 87 00 00 00    	jb     80408c <__umoddi3+0x134>
  804005:	0f 84 91 00 00 00    	je     80409c <__umoddi3+0x144>
  80400b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80400f:	29 f2                	sub    %esi,%edx
  804011:	19 cb                	sbb    %ecx,%ebx
  804013:	89 d8                	mov    %ebx,%eax
  804015:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804019:	d3 e0                	shl    %cl,%eax
  80401b:	89 e9                	mov    %ebp,%ecx
  80401d:	d3 ea                	shr    %cl,%edx
  80401f:	09 d0                	or     %edx,%eax
  804021:	89 e9                	mov    %ebp,%ecx
  804023:	d3 eb                	shr    %cl,%ebx
  804025:	89 da                	mov    %ebx,%edx
  804027:	83 c4 1c             	add    $0x1c,%esp
  80402a:	5b                   	pop    %ebx
  80402b:	5e                   	pop    %esi
  80402c:	5f                   	pop    %edi
  80402d:	5d                   	pop    %ebp
  80402e:	c3                   	ret    
  80402f:	90                   	nop
  804030:	89 fd                	mov    %edi,%ebp
  804032:	85 ff                	test   %edi,%edi
  804034:	75 0b                	jne    804041 <__umoddi3+0xe9>
  804036:	b8 01 00 00 00       	mov    $0x1,%eax
  80403b:	31 d2                	xor    %edx,%edx
  80403d:	f7 f7                	div    %edi
  80403f:	89 c5                	mov    %eax,%ebp
  804041:	89 f0                	mov    %esi,%eax
  804043:	31 d2                	xor    %edx,%edx
  804045:	f7 f5                	div    %ebp
  804047:	89 c8                	mov    %ecx,%eax
  804049:	f7 f5                	div    %ebp
  80404b:	89 d0                	mov    %edx,%eax
  80404d:	e9 44 ff ff ff       	jmp    803f96 <__umoddi3+0x3e>
  804052:	66 90                	xchg   %ax,%ax
  804054:	89 c8                	mov    %ecx,%eax
  804056:	89 f2                	mov    %esi,%edx
  804058:	83 c4 1c             	add    $0x1c,%esp
  80405b:	5b                   	pop    %ebx
  80405c:	5e                   	pop    %esi
  80405d:	5f                   	pop    %edi
  80405e:	5d                   	pop    %ebp
  80405f:	c3                   	ret    
  804060:	3b 04 24             	cmp    (%esp),%eax
  804063:	72 06                	jb     80406b <__umoddi3+0x113>
  804065:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804069:	77 0f                	ja     80407a <__umoddi3+0x122>
  80406b:	89 f2                	mov    %esi,%edx
  80406d:	29 f9                	sub    %edi,%ecx
  80406f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804073:	89 14 24             	mov    %edx,(%esp)
  804076:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80407a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80407e:	8b 14 24             	mov    (%esp),%edx
  804081:	83 c4 1c             	add    $0x1c,%esp
  804084:	5b                   	pop    %ebx
  804085:	5e                   	pop    %esi
  804086:	5f                   	pop    %edi
  804087:	5d                   	pop    %ebp
  804088:	c3                   	ret    
  804089:	8d 76 00             	lea    0x0(%esi),%esi
  80408c:	2b 04 24             	sub    (%esp),%eax
  80408f:	19 fa                	sbb    %edi,%edx
  804091:	89 d1                	mov    %edx,%ecx
  804093:	89 c6                	mov    %eax,%esi
  804095:	e9 71 ff ff ff       	jmp    80400b <__umoddi3+0xb3>
  80409a:	66 90                	xchg   %ax,%ax
  80409c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040a0:	72 ea                	jb     80408c <__umoddi3+0x134>
  8040a2:	89 d9                	mov    %ebx,%ecx
  8040a4:	e9 62 ff ff ff       	jmp    80400b <__umoddi3+0xb3>
